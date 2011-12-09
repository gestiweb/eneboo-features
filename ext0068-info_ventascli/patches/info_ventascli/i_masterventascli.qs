/***************************************************************************
                 i_masterventascli.qs  -  description
                             -------------------
    begin                : mie jun 7 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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


/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function lanzar() {
		return this.ctx.oficial_lanzar();
	}
	function rellenarDatos(cursor:FLSqlCursor) {
		return this.ctx.oficial_rellenarDatos(cursor);
	}
	function vaciarDatos() {
		return this.ctx.oficial_vaciarDatos();
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
function interna_init()
{
	connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_lanzar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return;
			
	if (!this.iface.rellenarDatos()) {
		this.iface.vaciarDatos();
		return;
	}
		
 	var idSesion = sys.idSession();
	var nombreInforme:String = cursor.action();
	
	var orden1:String = cursor.valueBuffer("orden1");
	var tipoOrden1:String = cursor.valueBuffer("tipoorden1");
	var orden2:String = cursor.valueBuffer("orden2");
	var tipoOrden2:String = cursor.valueBuffer("tipoorden2");
	
	var orderBy:String = "";
	var orderBy2:String = "";
	var where:String;
	
	switch(orden1) {
		case util.translate( "scripts", "Código cliente"):
			orderBy += "b.codcliente";
			break;
		case util.translate( "scripts", "Nombre cliente"):
			orderBy += "c.nombre";
			break;
		case util.translate( "scripts", "Código postal"):
			orderBy += "b.codpostal";
			break;
		case util.translate( "scripts", "Agente comercial"):
			orderBy += "a.codagente";
			break;
		case util.translate( "scripts", "Ventas"):
			orderBy += "b.totalfactura";
			break;
	}
	
	if (orderBy && tipoOrden1 == util.translate( "scripts", "Descendente"))
		orderBy += " DESC";
	
	if (orderBy) {
		switch(orden2) {
			case util.translate( "scripts", "Código cliente"):
				orderBy2 += ",b.codcliente";
				break;
			case util.translate( "scripts", "Nombre cliente"):
				orderBy2 += ",c.nombre";
				break;
			case util.translate( "scripts", "Código postal"):
				orderBy2 += ",b.codpostal";
				break;
			case util.translate( "scripts", "Agente comercial"):
				orderBy2 += ",a.codagente";
				break;
			case util.translate( "scripts", "Ventas"):
				orderBy2 += ",b.totalfactura";
				break;
		}
		
		if (orderBy2 && tipoOrden2 == util.translate( "scripts", "Descendente"))
			orderBy2 += " DESC";
	}
		
	orderBy += orderBy2;
	
 	
 	
 	// Para no mostrar algunos datos
	var q:FLSqlQuery = new FLSqlQuery("i_ventascli");
	
	var camposSelect:String = "empresa.nombre,i_ventascli.titulo,i_ventascli.fechadesde,i_ventascli.fechahasta,	i_ventascli.codclientedesde, i_ventascli.codclientehasta, i_ventascli.codagentedesde, i_ventascli.codagentehasta, i_ventascli.codpostaldesde, i_ventascli.codpostalhasta, i_ventascli.ventamin, i_ventascli.codejercicio, c.nombre,b.codcliente";
	
	if (cursor.valueBuffer("mostrarultimafactura"))	camposSelect += ",b.ultimafactura";
	if (cursor.valueBuffer("mostrarnif")) camposSelect += ",c.cifnif";
	if (cursor.valueBuffer("mostrartotalfactura"))	camposSelect += ",b.totalfactura";
	if (cursor.valueBuffer("mostraragente")) camposSelect += ",b.codagente,a.nombre,a.apellidos";
	
	q.setSelect(camposSelect);
	q.setOrderBy(orderBy);
	q.setWhere("idsesion = '" + idSesion + "' AND i_ventascli.id = " + seleccion);
	
	if (q.exec() == false) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
		return;
	} else {
		if (q.first() == false) {
			MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton);
			return;
		}
	}

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate("i_ventascli");
	rptViewer.setReportData(q);
	rptViewer.renderReport();
	rptViewer.exec();
 	
	this.iface.vaciarDatos();
}

function oficial_rellenarDatos()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var codEjercicio:String = cursor.valueBuffer("codejercicio");
	var fechaD = cursor.valueBuffer("fechadesde");
	var fechaH = cursor.valueBuffer("fechahasta");
	var agenteD:String = cursor.valueBuffer("codagentedesde");
	var agenteH:String = cursor.valueBuffer("codagentehasta");
	var clienteD:String = cursor.valueBuffer("codclientedesde");
	var clienteH:String = cursor.valueBuffer("codclientehasta");
	var codPostalD:String = cursor.valueBuffer("codpostaldesde");
	var codPostalH:String = cursor.valueBuffer("codpostalhasta");
	var ventaMin:Number = cursor.valueBuffer("ventamin");
	
 	var idSesion = sys.idSession();
	
	var whereClientes:String = "";
	if (clienteD)
		whereClientes += " AND clientes.codcliente >= '" + clienteD + "'"; 
	if (clienteH)
		whereClientes += " AND clientes.codcliente <= '" + clienteH + "'"; 
	
	var whereAgentes:String = "";
	if (agenteD)
		whereAgentes += "facturascli.codagente >= '" + agenteD + "'"; 
	if (agenteH) {
		if (whereAgentes)
			whereAgentes += " AND ";
		whereAgentes += "facturascli.codagente <= '" + agenteH + "'"; 
	}
	if (whereAgentes)
		whereAgentes = " AND (facturascli.codagente IS NULL OR (" + whereAgentes + "))";
	
	
	var whereFechas:String = "";
	if (fechaD)
		whereFechas += " AND facturascli.fecha >= '" + fechaD + "'"; 
	if (fechaH)
		whereFechas += " AND facturascli.fecha <= '" + fechaH + "'"; 
	
	// Si mostramos clientes sin ventas, las fechas de factura no son relevantes para la primera consulta
	var whereFechasGeneral:String = whereFechas;
	if (cursor.valueBuffer("mostrarsinventas"))
		whereFechasGeneral = "";
	
	var whereEjercicio:String = "";
	if (codEjercicio)
		whereEjercicio += " AND (facturascli.codejercicio = '" + codEjercicio + "' OR facturascli.codejercicio IS NULL)"; 
	
	
	var q:FLSqlQuery = new FLSqlQuery;
	q.setTablesList("clientes,facturascli");
	q.setSelect("max(clientes.codcliente), max(clientes.codagente), sum(facturascli.total), sum(facturascli.neto), max(facturascli.fecha)");
	q.setFrom("clientes LEFT OUTER JOIN facturascli ON clientes.codcliente = facturascli.codcliente");
	q.setWhere("1 = 1 " + whereClientes + whereAgentes + whereFechasGeneral + whereEjercicio + " GROUP BY clientes.codcliente");
	
	var curTab:FLSqlCursor = new FLSqlCursor("i_ventascli_buffer");
 	var paso:Number = 0;
	
	debug(q.sql());
	
	if (!q.exec()) {
		MessageBox.critical(util.translate("scripts", "Falló la consulta"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
			
 	util.createProgressDialog( util.translate( "scripts", "Recabando datos de ventas..." ), q.size() );
	util.setProgress(1);
	
	var codCliente:String, ventas:String;
	var codPostal:String = "";
	
	while(q.next()) {
	
		util.setProgress(paso++);
		
		codCliente = q.value(0);
		
		// Código postal
		if (codPostalD || codPostalH) {
			codPostal = util.sqlSelect("dirclientes", "codpostal", "codcliente = '" + codCliente + "' AND domfacturacion = true");
			if (codPostal < codPostalD || codPostal > codPostalH)
				continue;
		}
	
		// Ventas
		debug("codcliente = '" + codCliente + "'" + whereFechas + whereEjercicio);
		if (cursor.valueBuffer("coniva"))
			ventas = util.sqlSelect("facturascli", "sum(total)", "codcliente = '" + codCliente + "'" + whereFechas + whereEjercicio);
		else
			ventas = util.sqlSelect("facturascli", "sum(neto)", "codcliente = '" + codCliente + "'" + whereFechas + whereEjercicio);
		
		if (ventaMin) {
			if (ventas < ventaMin)
				continue;
		}
		if (!ventas && !cursor.valueBuffer("mostrarsinventas"))
			continue;
	
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codcliente", q.value(0));
		curTab.setValueBuffer("codagente", q.value(1));
		curTab.setValueBuffer("totalfactura", ventas);
		curTab.setValueBuffer("ultimafactura", q.value(4));
		curTab.setValueBuffer("codpostal", codPostal);
		curTab.setValueBuffer("idsesion", idSesion);
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
			
	if (paso == 0) {
		MessageBox.warning(util.translate("scripts",
				"No hay registros que cumplan los criterios de búsqueda establecidos"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	return true;
}

function oficial_vaciarDatos()
{
	var util:FLUtil = new FLUtil();
	if (util.sqlDelete("i_ventascli_buffer", "idsesion = '" + sys.idSession() + "'"))
		return true;
	
	return false
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
