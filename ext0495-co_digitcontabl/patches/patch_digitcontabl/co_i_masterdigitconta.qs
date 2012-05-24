 /***************************************************************************
                 co_i_masterdigitconta.qs  -  description
                             -------------------
    begin                : vie jun 05 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
    function init() { 
		return this.ctx.interna_init(); 
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function datosQueryInventario(curInventario:FLSqlCursor):Array {
		return this.ctx.oficial_datosQueryInventario(curInventario);
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
/** \C El botón de impresión lanza el informe
\end */
function interna_init()
{ 
	connect(this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Lanza el informe 
\end */
function oficial_lanzar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return;
	var codEjercicio:String = cursor.valueBuffer("i_co_subcuentas__codejercicio");
	var fechaIni:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
	fechaIni = fechaIni.toString();
	var annoEjer:String = fechaIni.left(4);
	var iniPrTrimestre:String = annoEjer + "-01-01";
	var finPrTrimestre:String = annoEjer + "-03-31";
	var finSegTrimestre:String = annoEjer + "-06-30";
	var finTerTrimestre:String = annoEjer + "-09-30";
	var finCuaTrimestre:String = annoEjer + "-12-31";

	var paginaActual:Number = 0;
	var rptViewer:FLReportViewer = new FLReportViewer();

	//Informe de inventario (es opcional)
	if (cursor.valueBuffer("idinventario") && cursor.valueBuffer("idinventario") != "") {
		var curInventario:FLSqlCursor = new FLSqlCursor("i_inventario");
		curInventario.select("id = " + cursor.valueBuffer("idinventario"));
		curInventario.first();
		var datosInventario:Array = this.iface.datosQueryInventario(curInventario);
		if (!datosInventario) {
			return false;
		}
		rptViewer.setReportTemplate(datosInventario["report"]);
		rptViewer.setReportData(datosInventario["query"]);
		rptViewer.renderReport(0,0,false,false);
		paginaActual = rptViewer.pageCount();
	}

	//Informe Balance de Sumas Y Saldos 
	flcontinfo.iface.numPag = paginaActual;
	flcontinfo.iface.establecerInformeActual(cursor.valueBuffer("idbalancesis"), "co_i_balancesis");
	var datosSumasYsaldos:Array;
	var ahora:Date = new Date;
	var idImpresion:String = ahora.getTime().toString();
	idImpresion += sys.nameUser();

	var curSumasYsaldos:FLSqlCursor = new FLSqlCursor("co_i_balancesis");
	curSumasYsaldos.select("id = " + cursor.valueBuffer("idbalancesis"));
	curSumasYsaldos.first();
	curSumasYsaldos.setModeAccess(curSumasYsaldos.Edit);
	curSumasYsaldos.refreshBuffer();
	curSumasYsaldos.setValueBuffer("d_co__asientos_fecha", iniPrTrimestre);
	curSumasYsaldos.setValueBuffer("h_co__asientos_fecha", finPrTrimestre);
	curSumasYsaldos.commitBuffer();
	datosSumasYsaldos = formco_i_balancesis.iface.pub_cargarQryReport(curSumasYsaldos, idImpresion);
	if (!datosSumasYsaldos) {
		return false;
	}
	rptViewer.setReportTemplate(datosSumasYsaldos["report"]);
	rptViewer.setReportData(datosSumasYsaldos["query"]);
	rptViewer.renderReport(0,0,true,false);

	curSumasYsaldos.select("id = " + cursor.valueBuffer("idbalancesis"));
	curSumasYsaldos.first();
	curSumasYsaldos.setModeAccess(curSumasYsaldos.Edit);
	curSumasYsaldos.refreshBuffer();
	curSumasYsaldos.setValueBuffer("d_co__asientos_fecha", iniPrTrimestre);
	curSumasYsaldos.setValueBuffer("h_co__asientos_fecha", finSegTrimestre);
	curSumasYsaldos.commitBuffer();
	datosSumasYsaldos = formco_i_balancesis.iface.pub_cargarQryReport(curSumasYsaldos, idImpresion);
	if (!datosSumasYsaldos) {
		return false;
	}
	rptViewer.setReportTemplate(datosSumasYsaldos["report"]);
	rptViewer.setReportData(datosSumasYsaldos["query"]);
	rptViewer.renderReport(0,0,true,false);

	curSumasYsaldos.select("id = " + cursor.valueBuffer("idbalancesis"));
	curSumasYsaldos.first();
	curSumasYsaldos.setModeAccess(curSumasYsaldos.Edit);
	curSumasYsaldos.refreshBuffer();
	curSumasYsaldos.setValueBuffer("d_co__asientos_fecha", iniPrTrimestre);
	curSumasYsaldos.setValueBuffer("h_co__asientos_fecha", finTerTrimestre);
	curSumasYsaldos.commitBuffer();
	datosSumasYsaldos = formco_i_balancesis.iface.pub_cargarQryReport(curSumasYsaldos, idImpresion);
	if (!datosSumasYsaldos) {
		return false;
	}
	rptViewer.setReportTemplate(datosSumasYsaldos["report"]);
	rptViewer.setReportData(datosSumasYsaldos["query"]);
	rptViewer.renderReport(0,0,true,false);

	curSumasYsaldos.select("id = " + cursor.valueBuffer("idbalancesis"));
	curSumasYsaldos.first();
	curSumasYsaldos.setModeAccess(curSumasYsaldos.Edit);
	curSumasYsaldos.refreshBuffer();
	curSumasYsaldos.setValueBuffer("d_co__asientos_fecha", iniPrTrimestre);
	curSumasYsaldos.setValueBuffer("h_co__asientos_fecha", finCuaTrimestre);
	curSumasYsaldos.commitBuffer();
	datosSumasYsaldos = formco_i_balancesis.iface.pub_cargarQryReport(curSumasYsaldos, idImpresion);
	if (!datosSumasYsaldos) {
		return false;
	}
	rptViewer.setReportTemplate(datosSumasYsaldos["report"]);
	rptViewer.setReportData(datosSumasYsaldos["query"]);
	rptViewer.renderReport(0,0,true,false);

	//Informe Balance de Situación
	var datosSituacion:Array;
	flcontinfo.iface.establecerInformeActual(cursor.valueBuffer("idbalancesit"), "co_i_cuentasanuales");
	var curSituacion:FLSqlCursor = new FLSqlCursor("co_i_cuentasanuales");
	curSituacion.select("id = " + cursor.valueBuffer("idbalancesit"));
	curSituacion.first();
	curSituacion.setModeAccess(curSituacion.Edit);
	curSituacion.refreshBuffer();
	curSituacion.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curSituacion.setValueBuffer("h_co__asientos_fechaact", finPrTrimestre);
	curSituacion.commitBuffer();
	datosSituacion = flcontinfo.iface.pub_cargarQryReport(curSituacion);
	if (!datosSituacion) {	
		return false;
	}
	rptViewer.setReportTemplate(datosSituacion["report"]);
	rptViewer.setReportData(datosSituacion["query"]);
	rptViewer.renderReport(0,0,true,false);

	curSituacion.select("id = " + cursor.valueBuffer("idbalancesit"));
	curSituacion.first();
	curSituacion.setModeAccess(curSituacion.Edit);
	curSituacion.refreshBuffer();
	curSituacion.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curSituacion.setValueBuffer("h_co__asientos_fechaact", finSegTrimestre);
	curSituacion.commitBuffer();
	datosSituacion = flcontinfo.iface.pub_cargarQryReport(curSituacion);
	if (!datosSituacion) {
		return false;
	}
	rptViewer.setReportTemplate(datosSituacion["report"]);
	rptViewer.setReportData(datosSituacion["query"]);
	rptViewer.renderReport(0,0,true,false);

	curSituacion.select("id = " + cursor.valueBuffer("idbalancesit"));
	curSituacion.first();
	curSituacion.setModeAccess(curSituacion.Edit);
	curSituacion.refreshBuffer();
	curSituacion.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curSituacion.setValueBuffer("h_co__asientos_fechaact", finTerTrimestre);
	curSituacion.commitBuffer();
	datosSituacion = flcontinfo.iface.pub_cargarQryReport(curSituacion);
	if (!datosSituacion) {
		return false;
	}
	rptViewer.setReportTemplate(datosSituacion["report"]);
	rptViewer.setReportData(datosSituacion["query"]);
	rptViewer.renderReport(0,0,true,false);

	curSituacion.select("id = " + cursor.valueBuffer("idbalancesit"));
	curSituacion.first();
	curSituacion.setModeAccess(curSituacion.Edit);
	curSituacion.refreshBuffer();
	curSituacion.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curSituacion.setValueBuffer("h_co__asientos_fechaact", finCuaTrimestre);
	curSituacion.commitBuffer();
	datosSituacion = flcontinfo.iface.pub_cargarQryReport(curSituacion);
	if (!datosSituacion) {
		return false;
	}
	rptViewer.setReportTemplate(datosSituacion["report"]);
	rptViewer.setReportData(datosSituacion["query"]);
	rptViewer.renderReport(0,0,true,false);

	//Informe Pérdidas y ganancias
	var datosPyG:Array;
	flcontinfo.iface.establecerInformeActual(cursor.valueBuffer("idbalancepyg"), "co_i_cuentasanuales");
	var curPyG:FLSqlCursor = new FLSqlCursor("co_i_cuentasanuales");
	curPyG.select("id = " + cursor.valueBuffer("idbalancepyg"));
	curPyG.first();
	curPyG.setModeAccess(curPyG.Edit);
	curPyG.refreshBuffer();
	curPyG.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curPyG.setValueBuffer("h_co__asientos_fechaact", finPrTrimestre);
	curPyG.commitBuffer();
	datosPyG = flcontinfo.iface.pub_cargarQryReport(curPyG);
	if (!datosPyG) {
		return false;
	}
	rptViewer.setReportTemplate(datosPyG["report"]);
	rptViewer.setReportData(datosPyG["query"]);
	rptViewer.renderReport(0,0,true,false);

	curPyG.select("id = " + cursor.valueBuffer("idbalancepyg"));
	curPyG.first();
	curPyG.setModeAccess(curPyG.Edit);
	curPyG.refreshBuffer();
	curPyG.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curPyG.setValueBuffer("h_co__asientos_fechaact", finSegTrimestre);
	curPyG.commitBuffer();
	datosPyG = flcontinfo.iface.pub_cargarQryReport(curPyG);
	if (!datosPyG) {
		return false;
	}
	rptViewer.setReportTemplate(datosPyG["report"]);
	rptViewer.setReportData(datosPyG["query"]);
	rptViewer.renderReport(0,0,true,false);

	curPyG.select("id = " + cursor.valueBuffer("idbalancepyg"));
	curPyG.first();
	curPyG.setModeAccess(curPyG.Edit);
	curPyG.refreshBuffer();
	curPyG.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curPyG.setValueBuffer("h_co__asientos_fechaact", finTerTrimestre);
	curPyG.commitBuffer();
	datosPyG = flcontinfo.iface.pub_cargarQryReport(curPyG);
	if (!datosPyG) {
		return false;
	}
	rptViewer.setReportTemplate(datosPyG["report"]);
	rptViewer.setReportData(datosPyG["query"]);
	rptViewer.renderReport(0,0,true,false);

	curPyG.select("id = " + cursor.valueBuffer("idbalancepyg"));
	curPyG.first();
	curPyG.setModeAccess(curPyG.Edit);
	curPyG.refreshBuffer();
	curPyG.setValueBuffer("d_co__asientos_fechaact", iniPrTrimestre);
	curPyG.setValueBuffer("h_co__asientos_fechaact", finCuaTrimestre);
	curPyG.commitBuffer();
	datosPyG = flcontinfo.iface.pub_cargarQryReport(curPyG);
	if (!datosPyG) {
		return false;
	}
	rptViewer.setReportTemplate(datosPyG["report"]);
	rptViewer.setReportData(datosPyG["query"]);
	rptViewer.renderReport(0,0,true,true);

	rptViewer.exec();
}

function oficial_datosQueryInventario(curInventario:FLSqlCursor):Array
{
	var datos:Array;
	var nombreReport:String = "i_inventarioval";

	datos["report"] = nombreReport;
	var whereFijo:String = "articulos.nostock <> true";
	var orderBy:String = "";
	var o:String = "";
	for (var i:Number = 1; i < 3; i++) {
		o = formi_inventario.iface.obtenerOrden(i, curInventario);
		if (o) {
			if (orderBy == "") {
				orderBy = o;
			} else {
				orderBy += ", " + o;
			}
		}
	}
	datos["query"] = flfactinfo.iface.pub_establecerConsulta(curInventario, nombreReport, orderBy, "", whereFijo);
	return datos;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
