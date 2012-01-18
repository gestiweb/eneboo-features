/***************************************************************************
                 i_etiquetascli.qs  -  description
                             -------------------
    begin                : mar ago 28 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
	var curCliente_:FLSqlCursor;
	var tbInsertIntervalo:Object;
	var tbInsert:Object;
	var tbDelete:Object;
	var toolButtonZoomDireccion:Object;
	var tbDesde:Object;
	var tbHasta:Object;
    function oficial( context ) { interna( context ); }
	function insertarIntervalo() {
		return this.ctx.oficial_insertarIntervalo();
	}
	function insertarCliente(codCliente:String) {
		return this.ctx.oficial_insertarCliente(codCliente);
	}
	function quitarCliente() {
		return this.ctx.oficial_quitarCliente();
	}
	function mostrarDirCliente() {
		return this.ctx.oficial_mostrarDirCliente();
	}
	function seleccionarCliente():String {
		return this.ctx.oficial_seleccionarCliente();
	}
	function establecerClienteDesde() {
		return this.ctx.oficial_establecerClienteDesde();
	}
	function establecerClienteHasta() {
		return this.ctx.oficial_establecerClienteHasta();
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
	this.iface.tbInsertIntervalo = this.child("tbInsertIntervalo");
	this.iface.tbInsert = this.child("tbInsert");
	this.iface.tbDelete = this.child("tbDelete");
	this.iface.toolButtonZoomDireccion = this.child("toolButtonZoomDireccion");
	this.iface.tbDesde = this.child("tbDesde");
	this.iface.tbHasta = this.child("tbHasta");

	connect (this.iface.tbInsertIntervalo, "clicked()", this, "iface.insertarIntervalo()");
	connect (this.iface.tbInsert, "clicked()", this, "iface.insertarCliente()");
	connect (this.iface.tbDelete, "clicked()", this, "iface.quitarCliente()");
	connect (this.iface.toolButtonZoomDireccion, "clicked()", this, "iface.mostrarDirCliente()");
	connect (this.iface.tbDesde, "clicked()", this, "iface.establecerClienteDesde()");
	connect (this.iface.tbHasta, "clicked()", this, "iface.establecerClienteHasta()");
	
	this.child("tdbClientesAux").close();

	if (this.iface.curCliente_)
		delete this.iface.curCliente_;
	this.iface.curCliente_ = new FLSqlCursor("dirclientes");
	this.iface.curCliente_.setAction("direccioncliente");
	this.child("tdbTodosClientes").cursor().setMainFilter("codcliente NOT IN (SELECT codcliente FROM i_etiquetascli_lista WHERE i_etiquetascli_lista.idinforme = " + this.cursor().valueBuffer("id") + ")");
	this.child("tdbClientes").cursor().setMainFilter("(dirclientes.domfacturacion=true and lista.idinforme = " + this.cursor().valueBuffer("id") + ")");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_insertarIntervalo()
{
	var util:FLUtil = new FLUtil();
	///Campo
	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		if (!this.child("tdbClientesAux").cursor().commitBufferCursorRelation())
			return false;
	}
	
	var codigoInicio:String = this.child("lineEditDesde").text;
	var codigoFin:String = this.child("lineEditHasta").text;
	var codCliente:String = "";
	var where:String = "";

	if (codigoInicio && codigoInicio != "")
		where += "codcliente >= '" + codigoInicio + "'";

	if (codigoFin && codigoFin != "") {
		if (where != "")
			where += " AND ";
		where += "codcliente <= '" + codigoFin + "'";
	}

	if (where == "")
		return;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("clientes");
	q.setSelect("codcliente");
	q.setFrom("clientes");
	q.setWhere(where);
	
	if(!q.exec())
		return false;

	var curListaClientes:FLSqlCursor = new FLSqlCursor("i_etiquetascli_lista");
	var idinforme:Number = this.cursor().valueBuffer("id");
	
	util.createProgressDialog( util.translate( "scripts", "Insertando clientes..." ), q.size());
	var paso:Number = 0;
	
	while (q.next()) {
		curListaClientes.setModeAccess(curListaClientes.Insert);
		curListaClientes.refreshBuffer();
		curListaClientes.setValueBuffer("idinforme",idinforme);
		curListaClientes.setValueBuffer("codcliente",q.value(0));
		if(!curListaClientes.commitBuffer())
			return;
		util.setProgress(paso++);
	}
	
	util.destroyProgressDialog();

	this.child("tdbTodosClientes").refresh();
	this.child("tdbClientes").refresh();
}

function oficial_insertarCliente(codCliente:String)
{
	var util:FLUtil;	

	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		if (!this.child("tdbClientesAux").cursor().commitBufferCursorRelation())
			return false;
	}

	if (!codCliente || codCliente == "")
		codCliente = this.child("tdbTodosClientes").cursor().valueBuffer("codcliente");

	if (!codCliente || codCliente == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var idinforme:Number = this.cursor().valueBuffer("id");
	
	if(!idinforme || idinforme == 0)
		return;
	
	if(util.sqlSelect("i_etiquetascli_lista","id","idinforme = " + idinforme + " AND codcliente = '" + codCliente + "'"))
		return;

	var curListaClientes:FLSqlCursor = new FLSqlCursor("i_etiquetascli_lista");
	curListaClientes.setModeAccess(curListaClientes.Insert);
	curListaClientes.refreshBuffer();
	curListaClientes.setValueBuffer("idinforme",idinforme);
	curListaClientes.setValueBuffer("codcliente",codCliente);
	if(!curListaClientes.commitBuffer())
		return;

	this.child("tdbTodosClientes").refresh();
	this.child("tdbClientes").refresh();
}

function oficial_seleccionarCliente():String
{
	var util:FLUtil;

	var f:Object = new FLFormSearchDB("clientes");
	var curClientes:FLSqlCursor = f.cursor();
	curClientes.setModeAccess(curClientes.Browse);
	curClientes.refreshBuffer();
	f.setMainWidget();
	curClientes.refreshBuffer();
	f.exec("codcliente");
	var codCliente:String;
	if (f.accepted()) {
		codCliente = curClientes.valueBuffer("codcliente");
	}

	if (!codCliente || codCliente == "")
		return false;

	return codCliente
}

function oficial_quitarCliente()
{
	var util:FLUtil;

	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var id:Number = this.cursor().valueBuffer("id");
	
	if (!id)
		return;

	var codCliente:String = this.child("tdbClientes").cursor().valueBuffer("codcliente");

	if (!codCliente || codCliente == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	if(!util.sqlDelete("i_etiquetascli_lista","idinforme = " + id + " AND codcliente = '" + codCliente + "'")) {
		MessageBox.warning(util.translate("scripts", "Hubo un error al eliminar el cliente de la lista"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.child("tdbTodosClientes").refresh();
	this.child("tdbClientes").refresh();
}

function oficial_mostrarDirCliente()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;

	var codCliente:String = this.child("tdbClientes").cursor().valueBuffer("codcliente");
	if (!codCliente || codCliente == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var idDirCliente:Number = util.sqlSelect("dirclientes","id","codcliente = '" + codCliente + "' AND domfacturacion = true");

	if (!idDirCliente || idDirCliente == 0) {
		MessageBox.information(util.translate("scripts", "El cliente seleccionado no tiene establecida una dirección de facturación"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.iface.curCliente_.setAction("direccioncliente");
	this.iface.curCliente_.select("id = " + idDirCliente);
	if (!this.iface.curCliente_.first())
		return;

	this.iface.curCliente_.browseRecord();
}

function oficial_establecerClienteDesde()
{
	var codCliente:String = this.iface.seleccionarCliente();
	if (codCliente)
		this.child("lineEditDesde").setText(codCliente);
}

function oficial_establecerClienteHasta()
{
	var codCliente:String = this.iface.seleccionarCliente();
	if (codCliente)
		this.child("lineEditHasta").setText(codCliente);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
