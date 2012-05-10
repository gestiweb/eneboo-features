/***************************************************************************
                 zonasventa.qs  -  description
                             -------------------
    begin                : lun abr 26 2006
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

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	function oficial( context ) { interna( context ); } 
	function insertarPais() {
		return this.ctx.oficial_insertarPais();
	}
	function quitarPais() {
		return this.ctx.oficial_quitarPais();
	}
	function insertarProvincia() {
		return this.ctx.oficial_insertarProvincia();
	}
	function quitarProvincia() {
		return this.ctx.oficial_quitarProvincia();
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
/** \C
Este formulario realiza la gestión de las líneas de pedidos a clientes.
\end */
function interna_init()
{
	connect (this.child("tbIncluir"), "clicked()", this, "iface.insertarPais()");
	connect (this.child("tbExcluir"), "clicked()", this, "iface.quitarPais()");
	connect (this.child("tbIncluirProv"), "clicked()", this, "iface.insertarProvincia()");
	connect (this.child("tbExcluirProv"), "clicked()", this, "iface.quitarProvincia()");

	this.child("tdbPaises").cursor().setMainFilter("codzona is null OR codzona = ''");
	this.child("tdbProvincias").cursor().setMainFilter("codzona is null OR codzona = ''");
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_insertarPais()
{
	var util:FLUtil;	

	var cursor:FLSqlCursor = this.cursor();
	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		if (!this.child("tdbPaises").cursor().commitBufferCursorRelation())
			return;
	}

	var curTab:FLSqlCursor = this.child("tdbPaises").cursor();
	if (!curTab.isValid())
		return;
	
	var codPais:String = curTab.valueBuffer("codpais");
	curTab = new FLSqlCursor("paises");
	curTab.select("codpais = '" + codPais + "'");
	if (!curTab.first())
		return;
	curTab.setModeAccess(curTab.Edit);
	curTab.refreshBuffer();
	curTab.setValueBuffer("codzona", cursor.valueBuffer("codzona"));
	curTab.commitBuffer();

	this.child("tdbPaises").refresh();
	this.child("tdbPaisesSel").refresh();
}

function oficial_quitarPais()
{
	var util:FLUtil;	

	var curTab:FLSqlCursor = this.child("tdbPaisesSel").cursor();
	if (!curTab.isValid())
		return;
	
	var codPais:String = curTab.valueBuffer("codpais");
	curTab = new FLSqlCursor("paises");
	curTab.select("codpais = '" + codPais + "'");
	if (!curTab.first())
		return;
	curTab.setModeAccess(curTab.Edit);
	curTab.refreshBuffer();
	curTab.setNull("codzona");
	curTab.commitBuffer();

	this.child("tdbPaises").refresh();
	this.child("tdbPaisesSel").refresh();
}

function oficial_insertarProvincia()
{
	var util:FLUtil;	

	var cursor:FLSqlCursor = this.cursor();
	if (this.cursor().modeAccess() == this.cursor().Insert) { 
		if (!this.child("tdbProvincias").cursor().commitBufferCursorRelation())
			return;
	}

	var curTab:FLSqlCursor = this.child("tdbProvincias").cursor();
	if (!curTab.isValid())
		return;
	
	var idProvincia:String = curTab.valueBuffer("idprovincia");
	curTab = new FLSqlCursor("provincias");
	curTab.select("idprovincia = " + idProvincia);
	if (!curTab.first())
		return;
	curTab.setModeAccess(curTab.Edit);
	curTab.refreshBuffer();
	curTab.setValueBuffer("codzona", cursor.valueBuffer("codzona"));
	curTab.commitBuffer();

	this.child("tdbProvincias").refresh();
	this.child("tdbProvinciasSel").refresh();
}

function oficial_quitarProvincia()
{
	var util:FLUtil;	

	var curTab:FLSqlCursor = this.child("tdbProvinciasSel").cursor();
	if (!curTab.isValid())
		return;
	
	var idProvincia:String = curTab.valueBuffer("idprovincia");
	curTab = new FLSqlCursor("provincias");
	curTab.select("idprovincia = " + idProvincia);
	if (!curTab.first())
		return;
	curTab.setModeAccess(curTab.Edit);
	curTab.refreshBuffer();
	curTab.setNull("codzona");
	curTab.commitBuffer();

	this.child("tdbProvincias").refresh();
	this.child("tdbProvinciasSel").refresh();
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////