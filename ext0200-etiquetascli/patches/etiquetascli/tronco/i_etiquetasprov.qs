/***************************************************************************
                 i_etiquetasprov.qs  -  description
                             -------------------
    begin                : vier sep 28 2007
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
	var curProveedor_:FLSqlCursor;
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
	function insertarProveedor(codProveedor:String) {
		return this.ctx.oficial_insertarProveedor(codProveedor);
	}
	function quitarProveedor() {
		return this.ctx.oficial_quitarProveedor();
	}
	function mostrarDirProveedor() {
		return this.ctx.oficial_mostrarDirProveedor();
	}
	function seleccionarProveedor():String {
		return this.ctx.oficial_seleccionarProveedor();
	}
	function establecerProveedorDesde() {
		return this.ctx.oficial_establecerProveedorDesde();
	}
	function establecerProveedorHasta() {
		return this.ctx.oficial_establecerProveedorHasta();
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

	this.child("tdbProveedoresAux").close();
	
	connect (this.iface.tbInsertIntervalo, "clicked()", this, "iface.insertarIntervalo()");
	connect (this.iface.tbInsert, "clicked()", this, "iface.insertarProveedor()");
	connect (this.iface.tbDelete, "clicked()", this, "iface.quitarProveedor()");
	connect (this.iface.toolButtonZoomDireccion, "clicked()", this, "iface.mostrarDirProveedor()");
	connect (this.iface.tbDesde, "clicked()", this, "iface.establecerProveedorDesde()");
	connect (this.iface.tbHasta, "clicked()", this, "iface.establecerProveedorHasta()");

	if (this.iface.curProveedor_)
		delete this.iface.curProveedor_;
	this.iface.curProveedor_ = new FLSqlCursor("dirproveedores");
	this.iface.curProveedor_.setAction("direccionproveedor");
	this.child("tdbTodosProveedores").cursor().setMainFilter("codproveedor NOT IN (SELECT codproveedor FROM i_etiquetasprov_lista WHERE idinforme = " + this.cursor().valueBuffer("id") + ")");
	this.child("tdbProveedores").cursor().setMainFilter("lista.idinforme = " + this.cursor().valueBuffer("id"));
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_insertarIntervalo()
{
	var util:FLUtil = new FLUtil();
	
	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		if (!this.child("tdbProveedoresAux").cursor().commitBufferCursorRelation())
			return false;
	}
	
	var codigoInicio:String = this.child("lineEditDesde").text;
	var codigoFin:String = this.child("lineEditHasta").text;
	var codProveedor:String = "";
	var where:String = "";

	if (codigoInicio && codigoInicio != "")
		where += "codproveedor >= '" + codigoInicio + "'";

	if (codigoFin && codigoFin != "") {
		if (where != "")
			where += " AND ";
		where += "codproveedor <= '" + codigoFin + "'";
	}

	if (where == "")
		return;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("proveedores");
	q.setSelect("codproveedor");
	q.setFrom("proveedores");
	q.setWhere(where);
	
	if(!q.exec())
		return false;

	var curListaProveedores:FLSqlCursor = new FLSqlCursor("i_etiquetasprov_lista");
	var idinforme:Number = this.cursor().valueBuffer("id");
	
	util.createProgressDialog( util.translate( "scripts", "Insertando proveedores..." ), q.size());
	var paso:Number = 0;
	
	while (q.next()) {
		curListaProveedores.setModeAccess(curListaProveedores.Insert);
		curListaProveedores.refreshBuffer();
		curListaProveedores.setValueBuffer("idinforme",idinforme);
		curListaProveedores.setValueBuffer("codproveedor",q.value(0));
		if(!curListaProveedores.commitBuffer())
			return;
		util.setProgress(paso++);
	}
	
	util.destroyProgressDialog();

	this.child("tdbTodosProveedores").refresh();
	this.child("tdbProveedores").refresh();
}

function oficial_insertarProveedor(codProveedor:String)
{
	var util:FLUtil;	

	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		if (!this.child("tdbProveedoresAux").cursor().commitBufferCursorRelation())
			return false;
	}

	if (!codProveedor || codProveedor == "")
		codProveedor = this.child("tdbTodosProveedores").cursor().valueBuffer("codproveedor");

	if (!codProveedor || codProveedor == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	var idinforme:Number = this.cursor().valueBuffer("id");
	
	if(!idinforme || idinforme == 0)
		return;
	
	if(util.sqlSelect("i_etiquetasprov_lista","id","idinforme = " + idinforme + " AND codproveedor = '" + codProveedor + "'"))
		return;

	var curListaProveedores:FLSqlCursor = new FLSqlCursor("i_etiquetasprov_lista");
	curListaProveedores.setModeAccess(curListaProveedores.Insert);
	curListaProveedores.refreshBuffer();
	curListaProveedores.setValueBuffer("idinforme",idinforme);
	curListaProveedores.setValueBuffer("codproveedor",codProveedor);
	if(!curListaProveedores.commitBuffer())
		return;

	this.child("tdbTodosProveedores").refresh();
	this.child("tdbProveedores").refresh();
}

function oficial_seleccionarProveedor():String
{
	var util:FLUtil;

	var f:Object = new FLFormSearchDB("proveedores");
	var curProveedores:FLSqlCursor = f.cursor();
	curProveedores.setModeAccess(curProveedores.Browse);
	curProveedores.refreshBuffer();
	f.setMainWidget();
	curProveedores.refreshBuffer();
	f.exec("codproveedor");
	var codProveedor:String;
	if (f.accepted()) {
		codProveedor = curProveedores.valueBuffer("codproveedor");
	}

	if (!codProveedor || codProveedor == "")
		return false;

	return codProveedor
}

function oficial_quitarProveedor()
{
	var util:FLUtil;

	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var id:Number = this.cursor().valueBuffer("id");
	
	if (!id)
		return;

	var codProveedor:String = this.child("tdbProveedores").cursor().valueBuffer("codproveedor");

	if (!codProveedor || codProveedor == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	if(!util.sqlDelete("i_etiquetasprov_lista","idinforme = " + id + " AND codproveedor = '" + codProveedor + "'")) {
		MessageBox.warning(util.translate("scripts", "Hubo un error al eliminar el proveedor de la lista"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.child("tdbTodosProveedores").refresh();
	this.child("tdbProveedores").refresh();
}

function oficial_mostrarDirProveedor()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;

	var codProveedor:String = this.child("tdbProveedores").cursor().valueBuffer("codproveedor");
	if (!codProveedor || codProveedor == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var idDirProveedor:Number = util.sqlSelect("dirproveedores","id","codproveedor = '" + codProveedor + "' AND direccionppal = true");

	if (!idDirProveedor || idDirProveedor == 0) {
		MessageBox.information(util.translate("scripts", "El proveedor seleccionado no tiene establecida una dirección de facturación"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.iface.curProveedor_.setAction("direccionproveedor");
	this.iface.curProveedor_.select("id = " + idDirProveedor);
	if (!this.iface.curProveedor_.first())
		return;

	this.iface.curProveedor_.browseRecord();
}

function oficial_establecerProveedorDesde()
{
	var codProveedor:String = this.iface.seleccionarProveedor();
	if (codProveedor)
		this.child("lineEditDesde").setText(codProveedor);
}

function oficial_establecerProveedorHasta()
{
	var codProveedor:String = this.iface.seleccionarProveedor();
	if (codProveedor)
		this.child("lineEditHasta").setText(codProveedor);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
