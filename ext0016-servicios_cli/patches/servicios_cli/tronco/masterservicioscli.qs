/***************************************************************************
                 masterservicioscli.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx:Object;
	function interna( context ) { this.ctx = context; }
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration  oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var pbnGAlbaran:Object;
	var tdbRecords:FLTableDB;
	var tbnImprimir:Object;
    function oficial( context ) { interna( context ); } 
	function imprimir(numServicio:String) {
		return this.ctx.oficial_imprimir(numServicio);
	}
	function procesarEstado() {
		return this.ctx.oficial_procesarEstado();
	}
	function pbnGenerarAlbaran_clicked() {
		return this.ctx.oficial_pbnGenerarAlbaran_clicked();
	}
	function generarAlbaran(where:String, cursor:FLSqlCursor):Number {
		return this.ctx.oficial_generarAlbaran(where, cursor);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function copiaLineas(idServicio:Number, idAlbaran:Number):Boolean {
		return this.ctx.oficial_copiaLineas(idServicio, idAlbaran);
	}
	function copiaLineaServicio(curLineaServicio:FLSqlCursor, idAlbaran:Number):Number {
		return this.ctx.oficial_copiaLineaServicio(curLineaServicio, idAlbaran);
	}
	function actualizarDatosServicio(where:String, idAlbaran:String):Boolean {
		return this.ctx.oficial_actualizarDatosServicio(where, idAlbaran);
	}
	function datosLineaServicio(curLineaServicio:FLSqlCursor,curLineaAlbaran:FLSqlCursor,idAlbaran:Number):Boolean {
		return this.ctx.oficial_datosLineaServicio(curLineaServicio,curLineaAlbaran,idAlbaran);
	}
	function datosAlbaran(cursor:FLSqlCursor,curAlbaran:FLSqlCursor,where:String):Boolean {
		return this.ctx.oficial_datosAlbaran(cursor,curAlbaran,where);
	}
	function totalesAlbaran(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.oficial_totalesAlbaran(curAlbaran);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
			return this.commonCalculateField(fN, cursor);
	}
	function pub_generarAlbaran(where:String, cursor:FLSqlCursor):Number {
			return this.generarAlbaran(where, cursor);
	}
	function pub_imprimir(numServicio:String) {
		return this.imprimir(numServicio);
	}
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C
Este es el formulario maestro de servicios a cliente.
\end */
function interna_init()
{
	this.iface.pbnGAlbaran = this.child("pbnGenerarAlbaran");
	this.iface.tdbRecords = this.child("tableDBRecords");
	this.iface.tbnImprimir = this.child("toolButtonPrint");

	connect(this.iface.pbnGAlbaran, "clicked()", this, "iface.pbnGenerarAlbaran_clicked()");
	connect(this.iface.tdbRecords, "currentChanged()", this, "iface.procesarEstado");
	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");

	this.iface.procesarEstado();

	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosEjercicio = flfactppal.iface.pub_ejecutarQry("ejercicios", "fechainicio,fechafin", "codejercicio = '" + codEjercicio + "'");
	if (datosEjercicio.result > 0)
		this.cursor().setMainFilter("fecha >='" + datosEjercicio.fechainicio + "' AND fecha <= '" + datosEjercicio.fechafin + "'");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al servicio seleccionado (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir(numServicio:String)
{
		if (sys.isLoadedModule("flfactinfo")) {
						
				var numero:String;
				if (numServicio)
					numero = numServicio;
				else {
					if (!this.cursor().isValid())
							return;
					numero = this.cursor().valueBuffer("numservicio");
				}
					
				var curImprimir:FLSqlCursor = new FLSqlCursor("i_servicioscli");
				curImprimir.setModeAccess(curImprimir.Insert);
				curImprimir.refreshBuffer();
				curImprimir.setValueBuffer("descripcion", "temp");
				curImprimir.setValueBuffer("d_servicioscli_numservicio", numero);
				curImprimir.setValueBuffer("h_servicioscli_numservicio", numero);
				flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_servicioscli");
		} else
				flfactppal.iface.pub_msgNoDisponible("Informes");
}

function oficial_procesarEstado()
{
		if (this.cursor().valueBuffer("editable") == true) {
				this.iface.pbnGAlbaran.enabled = true;
		} else {
				this.iface.pbnGAlbaran.enabled = false;
		}
}

/** \C
Al pulsar el botón de generar albarán se creará el albarán correspondiente al servicio seleccionado.
\end */
function oficial_pbnGenerarAlbaran_clicked()
{
		var util:FLUtil = new FLUtil;
		var cursor:FLSqlCursor = this.cursor();
		var where:String = "idservicio = " + cursor.valueBuffer("idservicio");

		if (cursor.valueBuffer("editable") == false) {
			MessageBox.warning(util.translate("scripts", "El servicio ya generó un albarán"), MessageBox.Ok, MessageBox.NoButton);
			this.iface.procesarEstado();
			return;
		}
		this.iface.pbnGAlbaran.setEnabled(false);

		cursor.transaction(false);
		if (this.iface.generarAlbaran(where, cursor))
				cursor.commit();
		else
				cursor.rollback();

		this.iface.tdbRecords.refresh();
		this.iface.procesarEstado();
}

/** \D 
Genera el albarán asociado a uno o más servicios
@param where: Sentencia where para la consulta de búsqueda de los servicios a agrupar
@param cursor: Cursor con los datos principales que se copiarán del servicio al albarán
@return Identificador del albarán generado. FALSE si hay error
\end */
function oficial_generarAlbaran(where:String, cursor:FLSqlCursor):Number
{
	var util:FLUtil = new FLUtil();

	var curAlbaran:FLSqlCursor = new FLSqlCursor("albaranescli");
	curAlbaran.setModeAccess(curAlbaran.Insert);
	curAlbaran.refreshBuffer();

	if(!this.iface.datosAlbaran(cursor,curAlbaran,where))
		return false;

	if (!curAlbaran.commitBuffer())
		return false;

	var idAlbaran:Number = curAlbaran.valueBuffer("idalbaran");
	var qryServicios:FLSqlQuery = new FLSqlQuery();
	qryServicios.setTablesList("servicioscli");
	qryServicios.setSelect("idservicio");
	qryServicios.setFrom("servicioscli");
	qryServicios.setWhere(where);

	if (!qryServicios.exec())
		return false;

	var idServicio:String;
	while (qryServicios.next()) {
		idServicio = qryServicios.value(0);
		if (!this.iface.copiaLineas(idServicio, idAlbaran))
			return false;
	}
		
	curAlbaran.select("idalbaran = " + idAlbaran);
	if (curAlbaran.first()) {
		curAlbaran.setModeAccess(curAlbaran.Edit);
		curAlbaran.refreshBuffer();
		
		if(!this.iface.totalesAlbaran(curAlbaran))
			return false;
		
		if (!curAlbaran.commitBuffer())
			return false;
	}

	if(!this.iface.actualizarDatosServicio(where, idAlbaran))
		return false;
	
	return idAlbaran;
}

function oficial_totalesAlbaran(curAlbaran:FLSqlCursor):Boolean
{
	with(curAlbaran) {
		setValueBuffer("neto", formalbaranescli.iface.pub_commonCalculateField("neto", curAlbaran));
		setValueBuffer("totaliva", formalbaranescli.iface.pub_commonCalculateField("totaliva", curAlbaran));
		setValueBuffer("totalirpf", formalbaranescli.iface.pub_commonCalculateField("totalirpf", curAlbaran));
		setValueBuffer("totalrecargo", formalbaranescli.iface.pub_commonCalculateField("totalrecargo", curAlbaran));
		setValueBuffer("total", formalbaranescli.iface.pub_commonCalculateField("total", curAlbaran));
		setValueBuffer("totaleuros", formalbaranescli.iface.pub_commonCalculateField("totaleuros", curAlbaran));
		setValueBuffer("codigo", formalbaranescli.iface.pub_commonCalculateField("codigo", curAlbaran));
	}
	return true;
}

function oficial_datosAlbaran(cursor:FLSqlCursor,curAlbaran:FLSqlCursor,where:String):Boolean
{
	var util:FLUtil;

	var codCliente:String = cursor.valueBuffer("codcliente");
	var codSerie:String = cursor.valueBuffer("codserie");
	var codAgente:String = cursor.valueBuffer("codagente");
	var porComision:String = cursor.valueBuffer("porcomision");
	var irpf:String = cursor.valueBuffer("irpf");
	var datosCliente:Array = flfactppal.iface.pub_ejecutarQry("clientes", "coddivisa,codpago", "codcliente = '" + codCliente + "'");
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();	
	var codAlmacen:String = flfactppal.iface.pub_valorDefectoEmpresa("codalmacen");
	
	var codDivisa:String = datosCliente.coddivisa;
	if (!codDivisa) codDivisa = flfactppal.iface.pub_valorDefectoEmpresa("coddivisa");
	
	var codPago:String = datosCliente.codpago;
	if (!codPago) codPago = flfactppal.iface.pub_valorDefectoEmpresa("codpago");
	
	var nomTecnico:String = "";
	var datosTec = flfactppal.iface.pub_ejecutarQry("tecnicos", "nombre,apellidos", "codtecnico = '" + cursor.valueBuffer("codtecnico") + "'");
	if (datosTec["result"] == 1)
		nomTecnico = datosTec["apellidos"] + ", " + datosTec["nombre"];
	
	var observaciones:String = 
		util.translate("MetaData", "SERVICIO Nº ") + cursor.valueBuffer("numservicio") + "     " + 
		util.translate("MetaData", "Fecha: ") + util.dateAMDtoDMA(cursor.valueBuffer("fecha"));
		 
	if (cursor.valueBuffer("contratomant")) {
		observaciones += "    " + util.translate("MetaData", "MANTENIMIENTO");
	}
		
	observaciones += "\n\n" +
		util.translate("MetaData", "TÉCNICO: ") + 
		cursor.valueBuffer("codtecnico") + " - " + nomTecnico + "\n\n" +
		util.translate("MetaData", "DESCRIPCIÓN: ") + "\n" +
		cursor.valueBuffer("descripcion") + "\n\n" +
		util.translate("MetaData", "SOLUCIÓN: ") + "\n" +
		cursor.valueBuffer("solucion") + "\n\n" + 
		util.translate("MetaData", "OBSERVACIONES: ") + "\n" +
		cursor.valueBuffer("observaciones");
;
		
	
	var fecha = new Date();
	var hora:String = fecha.toString().right(8);

	var numeroAlbaran:Number = flfacturac.iface.pub_siguienteNumero(codSerie, codEjercicio, "nalbarancli");
	if (!numeroAlbaran)
		return false;
	
	with(curAlbaran) {	
		setValueBuffer("numero", numeroAlbaran);
		setValueBuffer("fecha", fecha);
		setValueBuffer("hora", hora);
		setValueBuffer("codejercicio", codEjercicio);
		setValueBuffer("coddivisa", codDivisa);
		setValueBuffer("codpago", codPago);
		setValueBuffer("codalmacen", codAlmacen);
		setValueBuffer("codagente", codAgente);
		setValueBuffer("porcomision", porComision);
		setValueBuffer("irpf", irpf);
		setValueBuffer("codserie", codSerie);
		setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + codDivisa + "'"));
		
		setValueBuffer("codcliente", codCliente);
		setValueBuffer("cifnif", util.sqlSelect("clientes", "cifnif", "codcliente = '" + codCliente + "'"));
		setValueBuffer("nombrecliente", util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'"));
		
		datosDir = flfactppal.iface.pub_ejecutarQry("dirclientes", "direccion,codpostal,ciudad,provincia,apartado,codpais", "codcliente = '" + codCliente + "' AND domfacturacion = 'true'");		
		if (datosDir["result"] == -1) {
			MessageBox.warning(util.translate("scripts","No se encontró una dirección de facturación para este cliente.\nNo se puede generar el albarán"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}	
		setValueBuffer("direccion", datosDir["direccion"]);
		setValueBuffer("codpostal", datosDir["codpostal"]);
		setValueBuffer("ciudad", datosDir["ciudad"]);
		setValueBuffer("provincia", datosDir["provincia"]);
		setValueBuffer("apartado", datosDir["apartado"]);
		setValueBuffer("codpais", datosDir["codpais"]);
		
		setValueBuffer("observaciones", observaciones);	
	}

	return true;
}

function oficial_actualizarDatosServicio(where:String, idAlbaran:String):Boolean
{
	var curServicios:FLSqlCursor = new FLSqlCursor("servicioscli");
	curServicios.select(where);
	while (curServicios.next()) {
		curServicios.setModeAccess(curServicios.Edit);
		curServicios.refreshBuffer();
		curServicios.setValueBuffer("editable", false);
		curServicios.setValueBuffer("idalbaran", idAlbaran);
		if(!curServicios.commitBuffer()) 
			return false;
	}
	return true;
}

/** \D
Copia las líneas de un servicio como líneas de su albarán asociado
@param idServicio: Identificador del servicio
@param idAlbaran: Identificador del albarán
@return VERDADERO si no hay error. FALSE en otro caso.
\end */
function oficial_copiaLineas(idServicio:Number, idAlbaran:Number):Boolean
{
	var cantidad:Number;
	var totalEnAlbaran:Number;
	var curLineaServicio:FLSqlCursor = new FLSqlCursor("lineasservicioscli");
	curLineaServicio.select("idservicio = " + idServicio);
	while (curLineaServicio.next()) {
		curLineaServicio.setModeAccess(curLineaServicio.Browse);
		curLineaServicio.refreshBuffer();
		if (!this.iface.copiaLineaServicio(curLineaServicio, idAlbaran))
			return false;
	}
	return true;
}

/** \D
Copia una líneas de un servicio en su albarán asociado
@param curServicio: Cursor posicionado en la línea de servicio a copiar
@param idAlbaran: Identificador del albarán
@return identificador de la línea de albarán creada si no hay error. FALSE en otro caso.
\end */
function oficial_copiaLineaServicio(curLineaServicio:FLSqlCursor, idAlbaran:Number):Number
{
	var curLineaAlbaran:FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
	curLineaAlbaran.setModeAccess(curLineaAlbaran.Insert);
	curLineaAlbaran.refreshBuffer();
	
	this.iface.datosLineaServicio(curLineaServicio,curLineaAlbaran,idAlbaran);

	if (!curLineaAlbaran.commitBuffer())
		return false;

	return curLineaAlbaran.valueBuffer("idlinea");
}

function oficial_datosLineaServicio(curLineaServicio:FLSqlCursor,curLineaAlbaran:FLSqlCursor,idAlbaran:Number):Boolean
{
	var cantidad:Number = parseFloat(curLineaServicio.valueBuffer("cantidad"));

	with(curLineaAlbaran) {
		setValueBuffer("idalbaran", idAlbaran);
		setValueBuffer("referencia", curLineaServicio.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineaServicio.valueBuffer("descripcion"));
		setValueBuffer("pvpunitario", curLineaServicio.valueBuffer("pvpunitario"));
		setValueBuffer("cantidad", cantidad);
		setValueBuffer("pvpsindto", curLineaServicio.valueBuffer("pvpsindto"));
		setValueBuffer("pvptotal", curLineaServicio.valueBuffer("pvptotal"));
		setValueBuffer("codimpuesto", curLineaServicio.valueBuffer("codimpuesto"));
		setValueBuffer("iva", curLineaServicio.valueBuffer("iva"));
		setValueBuffer("recargo", curLineaServicio.valueBuffer("recargo"));
		setValueBuffer("dtolineal", curLineaServicio.valueBuffer("dtolineal"));
		setValueBuffer("dtopor", curLineaServicio.valueBuffer("dtopor"));
		setValueBuffer("irpf", curLineaServicio.valueBuffer("irpf"));
	}
	return true;
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		/** \C
		El --total-- es el --neto-- menos el --totalirpf-- más el --totaliva-- más el --totalrecargo-- más el --recfinanciero--
		\end */
		case "total":
			var neto:Number = parseFloat(cursor.valueBuffer("neto"));
			var totalIva:Number = parseFloat(cursor.valueBuffer("totaliva"));
			var totalRecargo:Number = parseFloat(cursor.valueBuffer("totalrecargo"));
			valor = neto + totalIva + totalRecargo;
			valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "total"));
			break;
		/** \C
		El --neto-- es la suma del pvp total de las líneas de albarán
		\end */
		case "neto":
			valor = util.sqlSelect("lineasservicioscli", "SUM(pvptotal)", "idservicio = " + cursor.valueBuffer("idservicio"));
			valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "neto"));
			break;
		/** \C
		El --totaliva-- es la suma del iva correspondiente a las líneas de albarán
		\end */
		case "totaliva":
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = util.sqlSelect("clientes","regimeniva","codcliente = '" + codCli + "'");
			if(regIva == "U.E." || regIva == "Exento"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasservicioscli", "SUM((pvptotal * iva) / 100)", "idservicio = " + cursor.valueBuffer("idservicio"));
			valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "totaliva"));
			break;
		/** \C
		El --totarecargo-- es la suma del recargo correspondiente a las líneas de albarán
		\end */
		case "totalrecargo":
			var codCli:String = cursor.valueBuffer("codcliente");
			var regIva:String = util.sqlSelect("clientes","regimeniva","codcliente = '" + codCli + "'");
			if(regIva == "U.E." || regIva == "Exento"){
				valor = 0;
				break;
			}
			valor = util.sqlSelect("lineasservicioscli", "SUM((pvptotal * recargo) / 100)", "idservicio = " + cursor.valueBuffer("idservicio"));
			valor = parseFloat(util.roundFieldValue(valor, "servicioscli", "totalrecargo"));
			break;
	}
	return valor;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
