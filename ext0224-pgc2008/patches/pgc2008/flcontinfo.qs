
/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial {
	var parciales08:Array;
	var parciales08ant:Array;
    function pgc2008( context ) { oficial ( context ); }
	function lanzarBalance(cursor:FLSqlCursor, csv:Boolean) {
		return this.ctx.pgc2008_lanzarBalance(cursor, csv);
	}
	function cargarQryReport(cursor:FLSqlCursor):Array {
		return this.ctx.pgc2008_cargarQryReport(cursor);
	}
	function popularBuffer(ejercicio:String, posicion:String, idBalance:Number, fechaDesde:String, fechaHasta:String, tablaCB:String, masWhere:String) {
		return this.ctx.pgc2008_popularBuffer(ejercicio, posicion, idBalance, fechaDesde, fechaHasta, tablaCB, masWhere);
	}	
	function vaciarBuffer08(idBalance:Number) {
		return this.ctx.pgc2008_vaciarBuffer08(idBalance);
	}	
	
	function completarPGB18(posicion:String, idBalance:Number) {
		return this.ctx.pgc2008_completarPGB18(posicion, idBalance);
	}	
	function resultadoEjercicio08(posicion:String, idBalance:Number) {
		return this.ctx.pgc2008_resultadoEjercicio08(posicion, idBalance);
	}	

	function labelBalances08(nodo:FLDomNode, campo:String):String {
		return this.ctx.pgc2008_labelBalances08(nodo, campo);
	}
	function recalcularDatosBalance(curTab:FLSqlCursor):Boolean {
		return this.ctx.pgc2008_recalcularDatosBalance(curTab);
	}
	function calcularSubTotalesBalances08(idBalance:Number) {
		return this.ctx.pgc2008_calcularSubTotalesBalances08(idBalance);
	}
	function subTotalesBalances08(nodo:FLDomNode, campo:String):String {
		return this.ctx.pgc2008_subTotalesBalances08(nodo, campo);
	}
	function cabeceraInforme(nodo:FLDomNode, campo:String):String {
		return this.ctx.pgc2008_cabeceraInforme(nodo, campo);
	}
	function cuentasSinCB(codEjercicio:String, abreviado:Boolean):Boolean {
		return this.ctx.pgc2008_cuentasSinCB(codEjercicio, abreviado);
	}
	function volcarCsv(qryInforme:FLSqlQuery):Boolean {
		return this.ctx.pgc2008_volcarCsv(qryInforme);
	}
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPgc2008 */
/////////////////////////////////////////////////////////////////
//// PUB_PGC2008 ////////////////////////////////////////////////
class pubPgc2008 extends head {
    function pubPgc2008( context ) { head( context ); }
	function pub_cargarQryReport(cursor:FLSqlCursor):Array {
		return this.cargarQryReport(cursor);
	}
}

//// PUB_PGC2008 ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////


function pgc2008_lanzarBalance(cursor:FLSqlCursor, csv:Boolean)
{
	var util:FLUtil = new FLUtil;
	
	flcontinfo.iface.numPag = 0;
	var datos:Array = this.iface.cargarQryReport(cursor);
	if (!datos) {
		return false;
	}
	var qInforme:FLSqlQuery = datos["query"];
	var nombreInforme:String = datos["report"];
	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(nombreInforme);

	if (!qInforme.exec()) {
		MessageBox.warning(util.translate("scripts", "Error al ejecutar la consulta."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!qInforme.first()) {
		MessageBox.information(util.translate("scripts", "No existen datos para este informe."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	if (csv) {
		this.iface.volcarCsv(qInforme);
	} else {
		rptViewer.setReportData(qInforme);
		rptViewer.renderReport();
		rptViewer.exec();
	}
}

function pgc2008_volcarCsv(qryInforme:FLSqlQuery):Boolean
{
	var util:FLUtil = new FLUtil;
	var nombreFichero:String = FileDialog.getSaveFileName("*.csv", util.translate("scripts", "Indique el archivo csv a guardar"));
	if (!nombreFichero) {
		return;
	}
	var fichero:Object = new File(nombreFichero);
	fichero.open(File.WriteOnly);

	var miSelect:String = qryInforme.select();
	var aCampos:Array = miSelect.split(",");
	var numCampos:Number = aCampos.length;
	var linea:String;
	do {
		linea = "";
		for (var i:Number = 0; i < numCampos; i++) {
			linea += qryInforme.value(i) + "|";
		}
		fichero.writeLine(linea);
	} while (qryInforme.next());
	fichero.close();

	MessageBox.information(util.translate("scripts", "Fichero %1 generado correctamente").arg(fichero.name), MessageBox.Ok, MessageBox.NoButton);
	return true;
}

function pgc2008_cargarQryReport(cursor:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datos:Array;
	var idBalance = cursor.valueBuffer("id");
	
	if (cursor.valueBuffer("recalculoauto")) {
		if (!this.iface.recalcularDatosBalance(cursor))
			return;
	}
	
	this.iface.resultadoEjercicio08("saldoact", idBalance);
	if (cursor.valueBuffer("i_co__subcuentas_codejercicioant"))
		this.iface.resultadoEjercicio08("saldoant", idBalance);
		
	if (!util.sqlSelect("co_i_balances08_datos", "id", "idbalance = " + idBalance))	 {
		MessageBox.information(util.translate("scripts", "No existen datos para este informe. Debe crearlos con el boton <<Recalcular>> del formulario"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	var qInforme:FLSqlQuery = new FLSqlQuery("co_i_balancesit_08");
	var nombreInforme:String;
	var where:String;
	var orderBy:String = "";
	
	var tipo:String = cursor.valueBuffer("tipo");
	var formato:String = cursor.valueBuffer("formato");
	var ejAct:String = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
	var ejAnt:String = cursor.valueBuffer("i_co__subcuentas_codejercicioant");
	
	this.iface.establecerEjerciciosPYG(ejAct, ejAnt, true);
	
	switch(tipo) {
		case "Situacion":
			where = "(cbl.naturaleza = 'A' OR cbl.naturaleza = 'P')";
			
			if (formato == "Normal")
				nombreInforme = "co_i_balancesit_08";
			else
				nombreInforme = "co_i_balancesit_08_abr";
			
			orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
		break;
		
		case "Perdidas y ganancias":
			where = "cbl.naturaleza = 'PG'";
			if (formato == "Normal")
				nombreInforme = "co_i_balancepyg_08";
			else
				nombreInforme = "co_i_balancepyg_08_abr";
			
			orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
			
		break;		
		
		case "Ingresos y gastos":
			where = "cbl.naturaleza = 'IG'";
			if (formato == "Normal")
				nombreInforme = "co_i_balanceig";
			else
				nombreInforme = "co_i_balanceig_abr";
			orderBy = "cbl.naturaleza, cbl.nivel1, cbl.nivel2, cbl.orden3, cbl.descripcion4";
		break;		
	}

	if (idBalance)
		where += " AND buf.idbalance = " + idBalance;
	
	if (orderBy)
		qInforme.setOrderBy(orderBy);
	
	qInforme.setWhere(where);
	debug(qInforme.sql());
	datos["query"] = qInforme;
	datos["report"] = nombreInforme;
	return datos;
}



/** Recalcula todos los datos para el balance
*/
function pgc2008_recalcularDatosBalance(curTab:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	
	var ejercicioAct:String = curTab.valueBuffer("i_co__subcuentas_codejercicioact");
	var fechaDesdeAct:String = curTab.valueBuffer("d_co__asientos_fechaact");
	var fechaHastaAct:String = curTab.valueBuffer("h_co__asientos_fechaact");
	
	var ejercicioAnt:String = curTab.valueBuffer("i_co__subcuentas_codejercicioant");
	var fechaDesdeAnt:String = curTab.valueBuffer("d_co__asientos_fechaant");
	var fechaHastaAnt:String = curTab.valueBuffer("h_co__asientos_fechaant");
	
	var idBalance:Number = curTab.valueBuffer("id");
	if (!this.iface.vaciarBuffer08(idBalance))
		return;

	var esAbreviado:Boolean = false;
	var tablaCB:String = "co_cuentascb";
	
	if (curTab.valueBuffer("formato") == "Abreviado") {
		esAbreviado = true;
		tablaCB = "co_cuentascbba";
	}
		
	if (!this.iface.cuentasSinCB(ejercicioAct, esAbreviado))
		return false;
	
	if (ejercicioAnt)
		if (!this.iface.cuentasSinCB(ejercicioAnt, esAbreviado))
			return false;

	this.iface.pgc2008_vaciarBuffer08(idBalance);
	this.iface.popularBuffer(ejercicioAct, "saldoact", idBalance, fechaDesdeAct, fechaHastaAct, tablaCB);
	if (ejercicioAnt)
		this.iface.popularBuffer(ejercicioAnt, "saldoant", idBalance, fechaDesdeAnt, fechaHastaAnt, tablaCB);
	
	if (curTab.valueBuffer("formato") != "Abreviado") {
		this.iface.completarPGB18("saldoact", idBalance)
		if (ejercicioAnt)
			this.iface.completarPGB18("saldoant", idBalance)
	}
	
	this.iface.calcularSubTotalesBalances08(idBalance);
	return true;
}



/** Rellena la tabla de buffer con los datos del total por código de balance
Se utiliza después en cada uno de los balances
@param posicion Indica si es actual o anterior (valores saldoact o saldoant)
@param tablaCB Indica la tabla que usamos para la query, co_cuentascb / co_cuentascbba
*/
function pgc2008_popularBuffer(ejercicio:String, posicion:String, idBalance:Number, fechaDesde:String, fechaHasta:String, tablaCB:String, masWhere:String)
{
	var util:FLUtil = new FLUtil();	
	var from:String = "";
	var where:String = "";
	var codBalance:String;
	var codCuentaCB:String;
	
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_datos");
	
	var q:FLSqlQuery = new FLSqlQuery();
	
	// Todas las naturalezas, se filtra más tarde
	where = "s.codejercicio = '" + ejercicio + "'";
		
	var idAsientoCierre:Number = util.sqlSelect("ejercicios", "idasientocierre", "codejercicio = '" + ejercicio + "'");
	if (idAsientoCierre)
		where += " AND a.idasiento <> " + idAsientoCierre;
		
	var idAsientoPyG:Number = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + ejercicio + "'");
	if (idAsientoPyG)
		where += " AND a.idasiento <> " + idAsientoPyG;
		
	if (masWhere)
		where += masWhere;
		
	from = "co_subcuentas s INNER JOIN co_partidas p ON s.idsubcuenta = p.idsubcuenta " +
			"INNER JOIN co_asientos a ON p.idasiento = a.idasiento";
	
	if (fechaDesde)	where += " AND a.fecha >= '" + fechaDesde + "'";
	if (fechaHasta)	where += " AND a.fecha <= '" + fechaHasta + "'";	
	
	q.setTablesList("co_subcuentas,co_asientos,co_partidas");
	q.setFrom(from);
	q.setSelect("sum(p.debe)-sum(p.haber)");
	
	
	// Bucle principal
	var qCB:FLSqlQuery = new FLSqlQuery();
	qCB.setTablesList(tablaCB + ",co_codbalances08");
	qCB.setFrom(tablaCB + " ccb INNER JOIN co_codbalances08 cb ON ccb.codbalance = cb.codbalance");
	qCB.setSelect("cb.codbalance,cb.naturaleza,ccb.codcuenta");
	qCB.setWhere("1=1 ORDER BY cb.naturaleza, cb.nivel1, cb.nivel2, cb.orden3, cb.nivel4");
	
	if (!qCB.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta de códigos por cuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	var paso:Number = 0;
	var suma:Number, sumaActual:Number;
	
	util.createProgressDialog( util.translate( "scripts", "Recabando datos..." ), qCB.size());
	
	while (qCB.next()) {
		
		codBalance = qCB.value(0);
		naturaleza = qCB.value(1);
		codCuentaCB = qCB.value(2);
		
		util.setProgress(paso++);
		util.setLabelText(util.translate( "scripts", "Recabando datos del ejercicio %0\n\nAnalizando código de balance\n" ).arg(ejercicio) + codBalance);
		
		// Evitamos contar dos veces casos como 281 y 2811
		q.setWhere(where + " and s.codcuenta like '" + codCuentaCB + "%' and s.codcuenta not in (select codcuenta from " + tablaCB + " where codcuenta like '" + codCuentaCB + "%' and codcuenta <> '" + codCuentaCB + "')");
	
		if (!q.exec()) {
			debug(util.translate("scripts", "Error buscando cuentas ") + codCuentaCB, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			continue;
		}
	
		suma = 0;
		while (q.next()) {
			suma += parseFloat(q.value(0));
		}
	
		// El pasivo cambia de signo
		// Si es PG siempre cambia de signo
		if (naturaleza == "P" || naturaleza == "PG")
			suma = 0 - suma;
		
		curTab.select("codbalance = '" + codBalance + "' and idbalance = " + idBalance);
		if (curTab.first()) {
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
			sumaActual = parseFloat(curTab.valueBuffer(posicion));
		}
		else {
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("codbalance", codBalance);
			curTab.setValueBuffer("idbalance", idBalance);
			sumaActual = 0;
		}
		
		suma += sumaActual;
		
		curTab.setValueBuffer(posicion, suma);
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
	
	return true;
}


function pgc2008_vaciarBuffer08(idBalance:Number)
{
	var util:FLUtil = new FLUtil();
	
	if (!util.sqlDelete("co_i_balances08_datos", "idbalance = " + idBalance)) {
		MessageBox.critical(util.translate("scripts", "No se pudo vaciar el buffer. Inténtelo de nuevo más tarde"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	if (!util.sqlDelete("co_i_balances08_subtotales", "idbalance = " + idBalance)) {
		MessageBox.critical(util.translate("scripts", "No se pudo vaciar el buffer. Inténtelo de nuevo más tarde"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	return true;
}


/** En la tabla de buffer sustituye el valor de la cuenta 129 (CBL P-A-1-VII-) por los resultados del ejercicio
*/
function pgc2008_resultadoEjercicio08(posicion:String, idBalance:Number):Boolean
{
	var util:FLUtil = new FLUtil();	
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_datos")
	
	var resultadoEj:Number = util.sqlSelect("co_i_balances08_datos", "sum(" + posicion + ")", "idbalance=" + idBalance + " and codbalance like 'PG%'");
	debug(posicion + " " + resultadoEj);
	curTab.select("codbalance = 'P-A-1-VII-' and idbalance = " + idBalance);
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Edit);
		curTab.refreshBuffer();
	}
	else {
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codbalance", "P-A-1-VII-");
	}
		
	// Se suma la del año anterior (129 asiento apertura) con el resultado del presente
	resultadoEj += parseFloat(curTab.valueBuffer(posicion));
	
	curTab.setValueBuffer("idbalance", idBalance);
	curTab.setValueBuffer(posicion, resultadoEj);
	curTab.commitBuffer();
}



function pgc2008_labelBalances08(nodo:FLDomNode, campo:String):String
{
	var texto:String = "";

	switch(campo) {
	
		case "naturaleza":
		
			switch(nodo.attributeValue("cbl.naturaleza")) {
				case "A":
					texto = " ACTIVO";
					break;
				case "P":
					texto = " PATRIMONIO NETO Y PASIVO";
					break;
			}
		
		break;
		
		default:
	
			switch(nodo.attributeValue("cbl.naturaleza")) {
				case "A":
					texto = " TOTAL ACTIVO (A+B)";
					break;
				case "P":
					texto = " TOTAL PATRIMONIO NETO Y PASIVO (A+B+C)";
					break;
			}
	
	}
	
	return texto;
}

function pgc2008_subTotalesBalances08(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil();
	var texto:String = "";
	var valor:Number = 0;
	
	var formato:String = "N"; // Normal
	if (util.sqlSelect("co_i_cuentasanuales", "formato", "id = " + this.iface.idInformeActual) == "Abreviado")
		formato = "A"; // Abreviado
	
	var nivel1:Number = nodo.attributeValue("cbl.nivel1");
	var nivel2:Number = nodo.attributeValue("cbl.nivel2");
	var mostrar1:Boolean,mostrar2:Boolean,mostrar34:Boolean,mostrar5:Boolean;

	if (nivel2 < 12  && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 12 AND indice > " +  nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar1 = true;
	
	if (nivel2 < 17 && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 17 and indice > " + nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar2 = true;
	
	if (nivel2 < 18 && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 18 and indice > " + nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar34 = true;

	if (nivel2 < 19 && !util.sqlSelect("co_i_balances08_subtotales", "indice", "indice < 19 and indice > " + nivel2 + " and idbalance=" + this.iface.idInformeActual ))
		mostrar5 = true;
	
	switch(campo) {
	
		case "labelpyg":
		
			if (mostrar1) {
				if (formato == "N")
					texto += "\nA.1) RESULTADOS DE EXPLOTACIÓN (1+2+3+4+5+6+7+8+9+10+11)";
				else
					texto += "\nA) RESULTADOS DE EXPLOTACIÓN (1+2+3+4+5+6+7+8+9+10+11)";
			}
		
			if (mostrar2) {
				if (formato == "N") {
					texto += "\nA.2) RESULTADO FINANCIERO (12+13+14+15+16)";
					texto += "\nA.3) RESULTADO ANTES DE IMPUESTOS (A.1+A.2)";
				}
				else {
					texto += "\nB) RESULTADO FINANCIERO (12+13+14+15+16)";
					texto += "\nC) RESULTADO ANTES DE IMPUESTOS (A+B)";
				}
			}
		
			if (mostrar34) {
				if (formato == "N") {
					texto += "\nA.4) RESULTADO DEL EJERCICIO PROCEDENTE DE OPERACIONES CONTINUADAS (A.3+17)";
					texto += "\n\nB) OPERACIONES INTERRUMPIDAS\n";
				}
				else {
					texto += "\nD) RESULTADO DEL EJERCICIO (C+17)";
				}
			}

			if (mostrar5) {
				if (formato == "N") {
					texto += "\nA.5) RESULTADO DEL EJERCICIO (A.4+18)";
				}
			}
		
		break;
	
		case "valoractpyg":
		
			if (mostrar1) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=11");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar2) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice >=12 AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				valor = 0;
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar34) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=17");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
					if (formato == "N")
						texto += "\n";
			}
			if (mostrar5) {
				if (formato == "N") {
					valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND indice <=18");
					valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "saldoact", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'PG-B-18--'"));
					texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				}
			}
			
		break;
	
		case "valorantpyg":
		
			if (mostrar1) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=11");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar2) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice >=12 AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				valor = 0;
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=16");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
			}
			if (mostrar34) {
				valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=17");
				texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				if (formato == "N") 
					texto += "\n";
			}
			if (mostrar5) {
				if (formato == "N") {
					valor = util.sqlSelect("co_i_balances08_subtotales", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND indice <=18");
					valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "saldoant", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'PG-B-18--'"));
					texto += "\n" + util.formatoMiles(util.buildNumber(valor, "f", 2));
				}
			}
			
		break;
		
		
		case "valorigact":
			valor = util.sqlSelect("co_i_balances08_datos", "saldoact", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'P-A-1-VII-'");
			if (nivel1 == "B")
				valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "sum(saldoact)", "idbalance=" + this.iface.idInformeActual + " AND codbalance like 'IG%'"));
			texto = util.formatoMiles(util.buildNumber(valor, "f", 2));
		break;
		
		case "valorigant":
			valor = util.sqlSelect("co_i_balances08_datos", "saldoant", "idbalance=" + this.iface.idInformeActual + " AND codbalance = 'P-A-1-VII-'");
			if (nivel1 == "B")
				valor += parseFloat(util.sqlSelect("co_i_balances08_datos", "sum(saldoant)", "idbalance=" + this.iface.idInformeActual + " AND codbalance like 'IG%'"));
			texto = util.formatoMiles(util.buildNumber(valor, "f", 2));
		break;
		
		
		case "labelig":
			if (nivel1 == "A")
				texto += "B) Total ingresos imputados al patrimonio neto (I+II+III+IV+V)\n";
			if (nivel1 == "B")
				texto += "C) Total transferencias a la cuenta de pérdidas y ganancias (VI+VII+VIII+IX)\n";
			
		break;
	}
	
	return texto;
}


function pgc2008_calcularSubTotalesBalances08(idBalance:Number)
{
	var util:FLUtil = new FLUtil();
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("co_codbalances08,co_i_balances08_datos");
	q.setFrom("co_codbalances08 cbl LEFT JOIN co_i_balances08_datos buf on cbl.codbalance = buf.codbalance");
	q.setWhere("cbl.naturaleza = 'PG' and buf.idbalance=" + idBalance + " group by cbl.nivel2 order by cbl.nivel2");
	q.setSelect("cbl.nivel2,sum(buf.saldoact),sum(buf.saldoant)");
	
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_subtotales")
	
	q.exec();		
	while (q.next()) {
		
		curTab.select("indice = " + q.value(0) + " and idbalance = " + idBalance);
		if (curTab.first()) {
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
		}
		else {
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("idbalance", idBalance);
			curTab.setValueBuffer("indice", q.value(0));
		}
		
		curTab.setValueBuffer("saldoact", q.value(1));
		curTab.setValueBuffer("saldoant", q.value(2));
		curTab.commitBuffer();
	}
}

function pgc2008_completarPGB18(posicion:String, idBalance:Number)
{
	var curTab:FLSqlCursor = new FLSqlCursor("co_i_balances08_datos")
	curTab.select("codbalance = 'PG-B-18--' and idbalance = " + idBalance);
	if (!curTab.first()) {
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codbalance", "PG-B-18--");
		curTab.setValueBuffer("idbalance", idBalance);
		curTab.setValueBuffer(posicion, 0);
		curTab.commitBuffer();
	}
}

function pgc2008_cabeceraInforme(nodo:FLDomNode, campo:String):String
{
	var texCampo:String = new String(campo);

	var util:FLUtil = new FLUtil();
	var desc:String;
	var ejAct:String, ejAnt:String;

	var texto:String;
	var sep:String = "       ";

	var qCondiciones:FLSqlQuery = new FLSqlQuery();

	qCondiciones.setWhere("id = " + this.iface.idInformeActual);

	switch (texCampo) {

		case "balancepyg08":
	
			qCondiciones.setTablesList("co_i_cuentasanuales");
			qCondiciones.setFrom("co_i_cuentasanuales");
			qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,i_co__subcuentas_codejercicioant");
	
			if (!qCondiciones.exec())
				return "";
			if (!qCondiciones.first())
				return "";
	
			desc = qCondiciones.value(0);
			ejAct = qCondiciones.value(1);
			ejAnt = qCondiciones.value(2);
	
			texto = "[ " + desc + " ]" + sep + "Ejercicio " + ejAct + sep +	"Ejercicio anterior " + ejAnt;
	
		break;

		case "datosEmpresa":
			
			var dE:Array = flfactppal.iface.pub_ejecutarQry("empresa", "nombre,cifnif,direccion,codpostal,ciudad,provincia", "1=1");
		
			texto = dE.nombre + "    CIF/NIF " + dE.cifnif;
			texto += "\n" + dE.direccion + "    " + dE.codpostal + "  " + dE.ciudad + ", " + dE.provincia;
		break;

		case "titSituacion":
			texto = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Balance al cierre del ejercicio") + " " + texto.toString().left(4);
		break;

		case "titSituacionAbr":
			texto = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Balance de PYMES al cierre del ejercicio") + " " + texto.toString().left(4);
		break;

		case "titIG":
			texto = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Estado de ingresos y gastos reconocidos correspondiente al ejercicio terminado el") + " " + texto.toString().left(4);
		break;

		case "titIGAbr":
			texto = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + this.iface.ejActPYG + "'");
			texto = "  " + util.translate("scripts", "Estado abreviado de ingresos y gastos reconocidos correspondiente al ejercicio terminado el") + " " + texto.toString().left(4);
		break;

		case "ant":
			texto = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + this.iface.ejAntPYG + "'");
		break;
		
		case "act":
			texto = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + this.iface.ejActPYG + "'");
		break;
		
		default:
			return this.iface.__cabeceraInforme(nodo, campo);
	}
	
	if (!texto)
		texto = "";
		
	return texto;
}

function pgc2008_cuentasSinCB(codEjercicio:String, abreviado):Boolean
{
	var util:FLUtil = new FLUtil();
	
	var q:FLSqlQuery = new FLSqlQuery();
	var error:String = "";
	
	var tablaCB:String = "co_cuentascb";
	if (abreviado)
		tablaCB = "co_cuentascbba";
	
	q.setTablesList("co_subcuentas," + tablaCB);
	q.setWhere("s.codejercicio='" + codEjercicio + "' and (s.debe>0 OR s.haber>0) and cb.codcuenta is null order by s.codsubcuenta");
	q.setSelect("s.codsubcuenta,s.codcuenta,s.debe,s.haber");
	
	var driver:String = sys.nameDriver();
	debug(driver);
	
	if (driver.left(8) == "FLQMYSQL")
        q.setFrom("co_subcuentas s left join " + tablaCB + " cb on s.codcuenta like concat(cb.codcuenta,'%')");
	else
		q.setFrom("co_subcuentas s left join " + tablaCB + " cb on s.codcuenta like cb.codcuenta || '%'");
	
	q.exec();
	debug(q.sql());
	
	while (q.next()) {
		error += "\n" + util.translate("scripts", "Subcuenta ") + q.value(0)
		error += "   " + util.translate("scripts", "Cuenta ") + q.value(1)
		error += "   " + util.translate("scripts", "Debe: ") + q.value(2)
		error += "   " + util.translate("scripts", "Haber: ") + q.value(3)
	}
	
	if (error) {
		error = util.translate("scripts", "Atención: algunas subcuentas del ejercicio %0 pertenecen a cuentas\nque no tienen asociado un código de balance\nEsto puede motivar que los resultados sean incorrectos\n\nPara corregirlo, es necesario asociar cada cuenta a su código de balance 2008:\n%1\n\n¿Continuar?").arg(codEjercicio).arg(error);
		res = MessageBox.information(util.translate("scripts", error), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return false;
	}	
	
	return true;
}

//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
