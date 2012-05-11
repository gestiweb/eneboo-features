
/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial {
    function pgc2008( context ) { oficial ( context ); }
	function validarCierre():Boolean {
		return this.ctx.pgc2008_validarCierre();
	}
	function asientoApertura(idAsientoCierre, ejNuevo):Boolean {
		return this.ctx.pgc2008_asientoApertura(idAsientoCierre, ejNuevo);
	}
	function comprobarSaldosHuerfanos():Boolean {
		return this.ctx.pgc2008_comprobarSaldosHuerfanos();
	}
	function asientoCierre():Boolean {
		return this.ctx.pgc2008_asientoCierre();
	}
	function asientoPyG():Boolean {
		return this.ctx.pgc2008_asientoPyG();
	}
	function comprobarSubcuentas08(idAsientoCierre:Number, ejNuevo:String):Boolean {
		return this.ctx.pgc2008_comprobarSubcuentas08(idAsientoCierre, ejNuevo);
	}
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////

function pgc2008_validarCierre():Boolean
{
	var util:FLUtil = new FLUtil();

	var codEjercicioAnt:String = this.cursor().valueBuffer("codejercicio");
	var codEjercicioAct:String = this.child("ledEjercicio").text;

	if (!codEjercicioAct)
		return this.iface.__validarCierre();

	var planContableAnt:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicioAnt + "'");
	var planContableAct:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicioAct + "'");

	// Si se pasa del 90 al 08 hay que comprobar cuentas huérfanas
	if (planContableAnt != "08" && planContableAct == "08")
		if (!this.iface.comprobarSaldosHuerfanos())
			return false;

	// No se puede pasar del 08 al 90
	if (planContableAnt == "08" && planContableAct != "08") {
		MessageBox.information(util.translate("scripts", "No es posible crear el asiento de apertura en un ejercicio con PGC 90\nporque el ejercicio que se está cerrando corresponde a un PGC 08"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (!flcontinfo.iface.cuentasSinCB(codEjercicioAnt))
		return false;

	return this.iface.__validarCierre();
}


/** Se comprueban los saldos de las subcuentas que no tienen correspondencias
en el nuevo PGC. Si hay alguna, se da un aviso
*/
function pgc2008_comprobarSaldosHuerfanos():Boolean
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	curCbl.setForwardOnly(true);
	var codEjercicio = this.cursor().valueBuffer("codejercicio");

	var saldos:String = "";
	var saldo:Number;
	var paso:Number = 0;

	curCbl.select("codejercicio = '" + codEjercicio + "' and saldo <> 0");
	util.createProgressDialog(util.translate("scripts", "Comprobando cuentas"), curCbl.size());

	while (curCbl.next()) {
		util.setProgress(paso++);
		codCuenta08 = util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + curCbl.valueBuffer("codcuenta") + "'");
		if (!codCuenta08) {
			saldo = parseFloat(curCbl.valueBuffer("saldo"));
			saldos += "\n" + curCbl.valueBuffer("codsubcuenta") + "   -   " + util.buildNumber(saldo, "f", 2);
		}
	}

	util.destroyProgressDialog();

	if (saldos) {
		MessageBox.information(util.translate("scripts",
		"Algunas subcuentas que ya no existen en el nuevo PGC tienen saldos\nen el ejercicio que se está cerrando.\nDeberá trasladar el saldo de estas subcuentas a otras o bien establecer\n su correspondencia en las opciones del módulo principal de financiera y repetir el cierre\n\nLas subcuentas y sus saldos son:") + "\n" + saldos,
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		this.iface.rollbackCierre();
		return false;
	}

	return true;
}

function pgc2008_asientoPyG():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	var planContable:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicio + "'");

	if (planContable != "08")
		return this.iface.__asientoPyG();

	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.setForwardOnly(true);
	curAsiento.setModeAccess(curAsiento.Insert);
	curAsiento.refreshBuffer();
	curAsiento.setValueBuffer("numero", 0);
	curAsiento.setValueBuffer("fecha", this.child("dedFecha").date);
	curAsiento.setValueBuffer("codejercicio", cursor.valueBuffer("codejercicio"));

	if (!curAsiento.commitBuffer())
			return false;

	var idAsiento:Number = curAsiento.valueBuffer("idasiento");
	var curPartida:Number = new FLSqlCursor("co_partidas");
	curPartida.setForwardOnly(true);
	var debe:Number = 0;
	var haber:Number = 0;
	var totalDebe:Number = 0;
	var totalHaber:Number = 0;
	var paso:Number = 0;


	// select s.codsubcuenta,s.codcuenta,s.idsubcuenta,s.saldo from co_subcuentas s inner join co_cuentas c on s.idcuenta=c.idcuenta where s.codejercicio='0002' and c.codcuenta like '430%' and s.saldo <> 0;
	var qSC:FLSqlQuery = new FLSqlQuery();
	qSC.setForwardOnly(true);
	qSC.setTablesList("co_subcuentas,co_cuentas");
	qSC.setFrom("co_subcuentas s inner join co_cuentas c on s.idcuenta=c.idcuenta");
	qSC.setSelect("s.saldo, s.idsubcuenta, s.codsubcuenta");

	// 	select codcuenta from co_cuentascb where codbalance like 'PG-%' order by codcuenta;
	var q:FLSqlQuery = new FLSqlQuery();
	q.setForwardOnly(true);
	q.setTablesList("co_cuentascb");
	q.setFrom("co_cuentascb");
	q.setSelect("codcuenta");
	q.setWhere("codbalance like 'PG-%'");

	if (!q.exec())
		return false;

	util.createProgressDialog( util.translate( "scripts", "Creando asiento de regularización..." ), q.size() );
	util.setProgress(1);

	while(q.next()) {

		qSC.setWhere("s.codejercicio='" + codEjercicio + "' and c.codcuenta like '" + q.value(0) + "%' and s.saldo <> 0 order by codsubcuenta");
		qSC.exec();
		while(qSC.next()) {
			if (parseFloat(qSC.value(0)) > 0) {
					debe = 0;
					haber = parseFloat(qSC.value(0));
			} else {
					debe = 0 - parseFloat(qSC.value(0));
					haber = 0;
			}
			totalDebe += debe;
			totalHaber += haber;

			curPartida.setModeAccess(curPartida.Insert);
			curPartida.refreshBuffer();
			curPartida.setValueBuffer("concepto", util.translate("scripts", "Regularización ejercicio ") +
					cursor.valueBuffer("nombre"));
			curPartida.setValueBuffer("idsubcuenta", qSC.value(1));
			curPartida.setValueBuffer("codsubcuenta", qSC.value(2));
			curPartida.setValueBuffer("idasiento", idAsiento);
			curPartida.setValueBuffer("debe", debe);
			curPartida.setValueBuffer("haber", haber);
			curPartida.setValueBuffer("coddivisa", this.iface.divisaEmpresa);
			curPartida.setValueBuffer("tasaconv", 1);
			curPartida.setValueBuffer("debeME", 0);
			curPartida.setValueBuffer("haberME", 0);

			if (!curPartida.commitBuffer()) {
					util.destroyProgressDialog();
					return false;
			}
		}
		util.setProgress(paso++);
	}

	var ctaPyG:Array = flfactppal.iface.pub_ejecutarQry("co_subcuentas s INNER JOIN co_cuentas c ON s.idcuenta = c.idcuenta INNER JOIN co_cuentascb cb ON c.codcuenta = cb.codcuenta", "idsubcuenta,codsubcuenta",	"cb.codbalance = 'P-A-1-VII-' AND c.codejercicio = '" + cursor.valueBuffer("codejercicio") + "'", "co_subcuentas,co_cuentas,co_cuentascb");
	if (ctaPyG.result != 1) {
			util.destroyProgressDialog();
			MessageBox.warning(util.translate("scripts",
					"Error en la búsqueda de la cuenta de pérdidas y ganancias"),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
	}

	if (totalDebe > totalHaber) {
			debe = 0;
			haber = totalDebe - totalHaber;
	} else {
			debe = totalHaber - totalDebe;
			haber = 0;
	}

	curPartida.setModeAccess(curPartida.Insert);
	curPartida.refreshBuffer();
	curPartida.setValueBuffer("concepto", util.translate("scripts", "Regularización ejercicio ") + cursor.valueBuffer("nombre"));
	curPartida.setValueBuffer("idsubcuenta", ctaPyG.idsubcuenta);
	curPartida.setValueBuffer("codsubcuenta", ctaPyG.codsubcuenta);
	curPartida.setValueBuffer("idasiento", idAsiento);
	curPartida.setValueBuffer("debe", debe);
	curPartida.setValueBuffer("haber", haber);
	curPartida.setValueBuffer("coddivisa", this.iface.divisaEmpresa);
	curPartida.setValueBuffer("tasaconv", 1);
	curPartida.setValueBuffer("debeME", 0);
	curPartida.setValueBuffer("haberME", 0);

	if (!curPartida.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
	}

	curAsiento.select("idasiento = " + idAsiento);
	curAsiento.first();
	curAsiento.setModeAccess(curAsiento.Edit);
	curAsiento.refreshBuffer();
	curAsiento.setUnLock("editable", false);

	cursor.setValueBuffer("idasientopyg", idAsiento);

	util.destroyProgressDialog();
	return true;
}

function pgc2008_asientoCierre():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	var planContable:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicio + "'");

	if (planContable != "08")
		return this.iface.__asientoCierre();


	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.setForwardOnly(true);
	curAsiento.setModeAccess(curAsiento.Insert);
	curAsiento.refreshBuffer();
	curAsiento.setValueBuffer("numero", 0);
	curAsiento.setValueBuffer("fecha", this.child("dedFecha").date);
	curAsiento.setValueBuffer("codejercicio", cursor.valueBuffer("codejercicio"));

	if (!curAsiento.commitBuffer())
			return false;

	var idAsiento:Number = curAsiento.valueBuffer("idasiento");
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	curPartida.setForwardOnly(true);
	var debe:Number = 0;
	var haber:Number = 0;
	var totalDebe:Number = 0;
	var totalHaber:Number = 0;
	var paso:Number = 0;


	// select s.codsubcuenta,s.codcuenta,s.idsubcuenta,s.saldo from co_subcuentas s inner join co_cuentas c on s.idcuenta=c.idcuenta where s.codejercicio='0002' and c.codcuenta like '430%' and s.saldo <> 0;
	var qSC:FLSqlQuery = new FLSqlQuery();
	qSC.setForwardOnly(true);
	qSC.setTablesList("co_subcuentas,co_cuentas");
	qSC.setFrom("co_subcuentas s inner join co_cuentas c on s.idcuenta=c.idcuenta");
	qSC.setSelect("s.saldo, s.idsubcuenta, s.codsubcuenta");

	// 	select codcuenta from co_cuentascb where codbalance like 'A-%' or codbalance like 'P-%' order by codcuenta;
	var q:FLSqlQuery = new FLSqlQuery();
	q.setForwardOnly(true);
	q.setTablesList("co_cuentascb");
	q.setFrom("co_cuentascb");
	q.setSelect("codcuenta");
	q.setWhere("codbalance like 'A-%' or codbalance like 'P-%' order by codcuenta");

	if (!q.exec())
		return false;

	util.createProgressDialog( util.translate( "scripts", "Creando asiento de cierre..." ), q.size() );
	util.setProgress(1);

	while(q.next()) {

		qSC.setWhere("s.codejercicio='" + codEjercicio + "' and c.codcuenta like '" + q.value(0) + "%' and s.saldo <> 0 order by codsubcuenta");
		qSC.exec();
		while(qSC.next()) {
			if (parseFloat(qSC.value(0)) > 0) {
					debe = 0;
					haber = parseFloat(qSC.value(0));
			} else {
					debe = 0 - parseFloat(qSC.value(0));
					haber = 0;
			}

			totalDebe += debe;
			totalHaber += haber;

			curPartida.setModeAccess(curPartida.Insert);
			curPartida.refreshBuffer();
			curPartida.setValueBuffer("concepto", util.translate("scripts", "Asiento de cierre de ejercicio ") +
					cursor.valueBuffer("nombre"));
			curPartida.setValueBuffer("idsubcuenta", qSC.value(1));
			curPartida.setValueBuffer("codsubcuenta", qSC.value(2));
			curPartida.setValueBuffer("idasiento", idAsiento);
			curPartida.setValueBuffer("debe", debe);
			curPartida.setValueBuffer("haber", haber);
			curPartida.setValueBuffer("coddivisa", this.iface.divisaEmpresa);
			curPartida.setValueBuffer("tasaconv", 1);
			curPartida.setValueBuffer("debeME", 0);
			curPartida.setValueBuffer("haberME", 0);

			if (!curPartida.commitBuffer()) {
					util.destroyProgressDialog();
					return false;
			}
		}
		util.setProgress(paso++);
	}

	if (parseFloat(totalDebe) -  parseFloat(totalHaber) > 0.01) {
			MessageBox.critical(util.translate("scripts",
					"Asiento de cierre: los totales de debe y haber no coinciden\n" +
					"DEBE : " + Math.round(parseFloat(totalDebe)) + "  HABER : " + Math.round(parseFloat(totalHaber)) ),
						MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			util.destroyProgressDialog();
			return false;
	}
	curAsiento.select("idasiento = " + idAsiento);
	curAsiento.first();
	curAsiento.setModeAccess(curAsiento.Edit);
	curAsiento.refreshBuffer();
	curAsiento.setUnLock("editable", false);

	cursor.setValueBuffer("estado", "CERRADO");

	cursor.setValueBuffer("idasientocierre", idAsiento);
	util.destroyProgressDialog();
	return true;
}


function pgc2008_asientoApertura(idAsientoCierre, ejNuevo):Boolean
{
	var util:FLUtil = new FLUtil();

	if (!ejNuevo) {
		return false;
	}
	if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codejercicio = '" + ejNuevo + "' AND idsubcuenta <> 0")) {
		return false;
	}
	var datosEjercicio:Array = flfactppal.iface.pub_ejecutarQry("ejercicios", "fechainicio,nombre,plancontable,longsubcuenta", "codejercicio = '" + ejNuevo + "'");
	if (datosEjercicio.plancontable != "08") {
		return this.iface.__asientoApertura(idAsientoCierre, ejNuevo);
	}
	var ejAnterior:String = util.sqlSelect("co_asientos", "codejercicio", "idasiento = " + idAsientoCierre);
	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsiento.setForwardOnly(true);
	var fechaAsiento:String = datosEjercicio.fechainicio;
	var nombreEjercicio:String = datosEjercicio.nombre;
	var planContableAnt = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + ejAnterior + "'");

	if (planContableAnt != "08") {
		if (!this.iface.comprobarSubcuentas08(idAsientoCierre, ejNuevo)) {
			return false;
		}
	}
	curAsiento.setModeAccess(curAsiento.Insert);
	curAsiento.refreshBuffer();
	curAsiento.setValueBuffer("numero", 0);
	curAsiento.setValueBuffer("fecha", fechaAsiento);
	curAsiento.setValueBuffer("codejercicio", ejNuevo);

	if (!curAsiento.commitBuffer()) {
		return false;
	}
	var idAsiento:Number = curAsiento.valueBuffer("idasiento");
	var qryCierre:FLSqlQuery = new FLSqlQuery();
	qryCierre.setForwardOnly(true);
	with (qryCierre) {
		setTablesList("co_partidas");
		setSelect("codsubcuenta, debe, haber, coddivisa, tasaconv, debeME, haberME");
		setFrom("co_partidas");
		setWhere("idasiento = " + idAsientoCierre);
	}
	if (!qryCierre.exec()) {
		return false;
	}

	// Es necesario migrar el resultado de la 129 a la 120 o 121 (resultados de ejercicio anteriores)
	var codSubcuentaPyG:String;
	if (planContableAnt == "08") {
		codSubcuentaPyG = util.sqlSelect("co_subcuentas s INNER JOIN co_cuentas c ON s.idcuenta = c.idcuenta INNER JOIN co_cuentascb cb ON c.codcuenta = cb.codcuenta", "codsubcuenta",	"cb.codbalance = 'P-A-1-VII-' AND c.codejercicio = '" + ejAnterior + "'", "co_subcuentas,co_cuentas,co_cuentascb");
	} else {
		var ctaPyG:Array = flfacturac.iface.pub_datosCtaEspecial("PYG", ejAnterior);
		codSubcuentaPyG = ctaPyG.codsubcuenta;
	}

	var codSubcuentaPyGPos:String = util.sqlSelect("co_subcuentas s INNER JOIN co_cuentas c ON s.idcuenta = c.idcuenta INNER JOIN co_cuentascb cb ON c.codcuenta = cb.codcuenta", "codsubcuenta",	"cb.codbalance = 'P-A-1-V-1' AND c.codejercicio = '" + ejNuevo + "'", "co_subcuentas,co_cuentas,co_cuentascb");
	var codSubcuentaPyGNeg:String = util.sqlSelect("co_subcuentas s INNER JOIN co_cuentas c ON s.idcuenta = c.idcuenta INNER JOIN co_cuentascb cb ON c.codcuenta = cb.codcuenta", "codsubcuenta",	"cb.codbalance = 'P-A-1-V-2' AND c.codejercicio = '" + ejNuevo + "'", "co_subcuentas,co_cuentas,co_cuentascb");


	util.createProgressDialog( util.translate( "scripts", "Creando asiento de apertura..." ), qryCierre.size() );
	util.setProgress(1);

	var curApertura:FLSqlCursor = new FLSqlCursor("co_partidas");
	curApertura.setForwardOnly(true);
	var paso:Number = 0;
	var idSubcuentaAp:String;
	var codSubcuenta08:String;
	var numCeros:Number;

	while (qryCierre.next()) {

		if (planContableAnt == "08") {
			codSubcuenta08 = qryCierre.value("codsubcuenta");
		} else {
			codSubcuenta08 = flcontppal.iface.convertirCodSubcuenta(ejAnterior, qryCierre.value("codsubcuenta"));
			if (!codSubcuenta08) {
				MessageBox.critical(util.translate("scripts", "No se encuentra la correspondencia entre la cuenta correspondiente a la subcuenta %0 en el ejercicio %0.\nDeberá migrar el saldo de esta subcuenta a otra y repetir el cierre").arg(qryCierre.value("codsubcuenta")).arg(ejAnterior), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				util.destroyProgressDialog();
				return false;
			}
		}

		if (qryCierre.value("codsubcuenta") == codSubcuentaPyG) {
			if (qryCierre.value("debe") - qryCierre.value("haber") > 0) {
				codSubcuenta08 = codSubcuentaPyGPos;
			} else {
				codSubcuenta08 = codSubcuentaPyGNeg;
			}
		}

		idSubcuentaAp = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta08 + "' AND codejercicio = '" + ejNuevo + "'");

		if (!idSubcuentaAp) {
			util.destroyProgressDialog();
			var res:Number = MessageBox.warning(util.translate("scripts", "No existe la subcuenta %1 en el ejercicio %2.\n¿Desea crearla?").arg(codSubcuenta08).arg(ejNuevo), MessageBox.Yes, MessageBox.Cancel);
			if (res != MessageBox.Yes) {
				return false;
			}
			idSubcuentaAp = this.iface.crearSubcuentaApertura(codSubcuenta08, ejNuevo);
			if (!idSubcuentaAp) {
				return false;
			}
		}

		curApertura.setModeAccess(curApertura.Insert);
		curApertura.refreshBuffer();
		curApertura.setValueBuffer("concepto", util.translate("scripts", "Asiento de apertura de ejercicio ") + nombreEjercicio);
		curApertura.setValueBuffer("idsubcuenta", idSubcuentaAp);
		curApertura.setValueBuffer("codsubcuenta", codSubcuenta08);
		curApertura.setValueBuffer("idasiento", idAsiento);
		curApertura.setValueBuffer("debe", qryCierre.value("haber"));
		curApertura.setValueBuffer("haber", qryCierre.value("debe"));
		curApertura.setValueBuffer("coddivisa", qryCierre.value("coddivisa"));
		curApertura.setValueBuffer("tasaconv", qryCierre.value("tasaconv"));
		curApertura.setValueBuffer("debeME", qryCierre.value("haberME"));
		curApertura.setValueBuffer("haberME", qryCierre.value("debeME"));
		util.setProgress(paso++);

		if (!curApertura.commitBuffer()) {
			util.destroyProgressDialog();
			return false;
		}
	}

	if (!util.sqlUpdate("ejercicios", "idasientoapertura", idAsiento, "codejercicio = '" + ejNuevo + "'")) {
		util.destroyProgressDialog();
		return false;
	}

	curAsiento.select("idasiento = " + idAsiento);
	curAsiento.first();
	curAsiento.setModeAccess(curAsiento.Edit);
	curAsiento.refreshBuffer();
	curAsiento.setUnLock("editable", false);

	util.destroyProgressDialog();
	return true;
}

function pgc2008_comprobarSubcuentas08(idAsientoCierre, ejNuevo):Boolean
{
	var util:FLUtil = new FLUtil();

	if (!ejNuevo) {
		return false;
	}
	if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "codejercicio = '" + ejNuevo + "' AND idsubcuenta <> 0")) {
		return false;
	}
	var qryCierre:FLSqlQuery = new FLSqlQuery();
	qryCierre.setForwardOnly(true);
	with (qryCierre) {
		setTablesList("co_partidas");
		setSelect("codsubcuenta, debe, haber, coddivisa, tasaconv, debeME, haberME");
		setFrom("co_partidas");
		setWhere("idasiento = " + idAsientoCierre);
	}
	if (!qryCierre.exec())
		return false;

	var paso:Number = 0;
	var idSubcuentaAp:String;
	var codSubcuenta08:String;
	var numCeros:Number;
	var faltan:String = "";

	util.createProgressDialog( util.translate( "scripts", "Comprobando subcuentas del nuevo ejercicio..." ), qryCierre.size() );

	while (qryCierre.next()) {

		util.setProgress(paso++);

		codSubcuenta08 = flcontppal.iface.convertirCodSubcuenta(this.cursor().valueBuffer("codejercicio"), qryCierre.value("codsubcuenta"));
		idSubcuentaAp = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta08 + "' AND codejercicio = '" + ejNuevo + "'");

		if (!idSubcuentaAp)
			idSubcuentaAp = this.iface.crearSubcuentaApertura(codSubcuenta08, ejNuevo);

		idSubcuentaAp = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta08 + "' AND codejercicio = '" + ejNuevo + "'");

		if (!idSubcuentaAp)
			faltan += "\n" + codSubcuenta08 + " (Subcuenta ejercicio anterior: " + qryCierre.value("codsubcuenta") + ")";

	}
	util.destroyProgressDialog();

	if (faltan) {
		MessageBox.critical(util.translate("scripts", "Las siguientes subcuentas no existen en el nuevo ejercicio. Debe crearlas antes de proceder al cierre:\n") + faltan,
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	return true;
}

//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

