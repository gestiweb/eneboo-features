/***************************************************************************
                 numerosserie.qs  -  description
                             -------------------
    begin                : lun abr 26 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
	function verAlbaranCli() {
		return this.ctx.oficial_verAlbaranCli();
	}
	function verFacturaCli() {
		return this.ctx.oficial_verFacturaCli();
	}
	function verFacturaCliDev() {
		return this.ctx.oficial_verFacturaCliDev();
	}
	function verAlbaranProv() {
		return this.ctx.oficial_verAlbaranProv();
	}
	function verFacturaProv() {
		return this.ctx.oficial_verFacturaProv();
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
	var util:FLUtil = new FLUtil();

	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() != cursor.Insert) {
		this.child("fdbCodAlmacen").setDisabled(true);
	}
	
	connect(this.child("pbnVerAlbaranCli"), "clicked()", this, "iface.verAlbaranCli");
	connect(this.child("pbnVerFacturaCli"), "clicked()", this, "iface.verFacturaCli");
	connect(this.child("pbnVerFacturaCliDev"), "clicked()", this, "iface.verFacturaCliDev");
	connect(this.child("pbnVerAlbaranProv"), "clicked()", this, "iface.verAlbaranProv");
	connect(this.child("pbnVerFacturaProv"), "clicked()", this, "iface.verFacturaProv");
	
	var dato:String;
	
	dato = util.sqlSelect("albaranesprov", "codigo", "idalbaran = " + cursor.valueBuffer("idalbarancompra"));
	if (dato)
		this.child("leAlbaranCompra").text = util.translate("scripts", "Albarán") + " " + dato;
	
	dato = util.sqlSelect("facturasprov", "codigo", "idfactura = " + cursor.valueBuffer("idfacturacompra"));
	if (dato)
		this.child("leFacturaCompra").text = util.translate("scripts", "Factura") + " " + dato;
	
	dato = util.sqlSelect("albaranescli", "codigo", "idalbaran = " + cursor.valueBuffer("idalbaranventa"));
	if (dato)
		this.child("leAlbaranVenta").text = util.translate("scripts", "Albarán") + " " + dato;
	
	dato = util.sqlSelect("facturascli", "codigo", "idfactura = " + cursor.valueBuffer("idfacturaventa"));
	if (dato)
		this.child("leFacturaVenta").text = util.translate("scripts", "Factura") + " " + dato;
	
	dato = util.sqlSelect("facturascli", "codigo", "idfactura = " + cursor.valueBuffer("idfacturadevol"));
	if (dato)
		this.child("leFacturaDev").text = util.translate("scripts", "Factura de devolución") + " " + dato;
	
}

function oficial_verAlbaranCli()
{
	var curTab:FLSqlCursor = new FLSqlCursor("albaranescli");
	curTab.select("idalbaran = " + this.cursor().valueBuffer("idalbaranventa"));
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Browse);
		curTab.refreshBuffer();
		curTab.browseRecord();
	}
}

function oficial_verFacturaCli()
{
	var curTab:FLSqlCursor = new FLSqlCursor("facturascli");
	curTab.select("idfactura = " + this.cursor().valueBuffer("idfacturaventa"));
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Browse);
		curTab.refreshBuffer();
		curTab.browseRecord();
	}
}

function oficial_verFacturaCliDev()
{
	var curTab:FLSqlCursor = new FLSqlCursor("facturascli");
	curTab.select("idfactura = " + this.cursor().valueBuffer("idfacturadevol"));
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Browse);
		curTab.refreshBuffer();
		curTab.browseRecord();
	}
}

function oficial_verAlbaranProv()
{
	var curTab:FLSqlCursor = new FLSqlCursor("albaranesprov");
	curTab.select("idalbaran = " + this.cursor().valueBuffer("idalbarancompra"));
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Browse);
		curTab.refreshBuffer();
		curTab.browseRecord();
	}
}

function oficial_verFacturaProv()
{
	var curTab:FLSqlCursor = new FLSqlCursor("facturasprov");
	curTab.select("idfactura = " + this.cursor().valueBuffer("idfacturacompra"));
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Browse);
		curTab.refreshBuffer();
		curTab.browseRecord();
	}
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

