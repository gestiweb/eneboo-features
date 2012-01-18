/***************************************************************************
                 co_punteo.qs  -  description
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

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

class oficial extends interna {
	var tdbPartidas:FLTableDB;
    function oficial( context ) { interna( context ); } 
	function puntear() { return this.ctx.oficial_puntear(); }
	function casar() { return this.ctx.oficial_casar(); }
	function actualizarSaldoP() { return this.ctx.oficial_actualizarSaldoP(); }
	function actualizarSaldoC() { return this.ctx.oficial_actualizarSaldoC(); }
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
	this.iface.tdbPartidas = this.child("tdbPartidasPunteo")
	
	connect(this.child("pbnPuntear"), "clicked()", this, "iface.puntear");
	connect(this.child("pbnCasar"), "clicked()", this, "iface.casar");
	this.child("fdbDescripcion").setDisabled(true);
 	this.child("pushButtonAcceptContinue").setDisabled(true);
	this.iface.tdbPartidas.setReadOnly(true);
	
	this.iface.actualizarSaldoP();
	this.iface.actualizarSaldoC();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_puntear()
{
	var util:FLUtil = new FLUtil();
	
	var cursor:FLSqlCursor = this.iface.tdbPartidas.cursor();
	if (!cursor.isValid())
		return;
	
	var curPunteo:FLSqlCursor = new FLSqlCursor("co_punteo");
	
	curPunteo.select("idpartida = " + cursor.valueBuffer("idpartida"));
	if (curPunteo.first()) {
		curPunteo.setModeAccess(curPunteo.Edit);
		curPunteo.refreshBuffer();
		if (curPunteo.valueBuffer("punteado"))
			curPunteo.setNull("punteado");
		else
			curPunteo.setValueBuffer("punteado", true);
	}
	else {
		curPunteo.setModeAccess(curPunteo.Insert);
		curPunteo.refreshBuffer();
		curPunteo.setValueBuffer("idpartida", cursor.valueBuffer("idpartida"));
		curPunteo.setValueBuffer("punteado", true);
	}

	curPunteo.commitBuffer();
	this.iface.tdbPartidas.refresh();

	this.iface.actualizarSaldoP();
}

function oficial_casar()
{
	var util:FLUtil = new FLUtil();
	
	var cursor:FLSqlCursor = this.iface.tdbPartidas.cursor();	
	if (!cursor.isValid())
		return;
	
	var curPunteo:FLSqlCursor = new FLSqlCursor("co_punteo");
	
	curPunteo.select("idpartida = " + cursor.valueBuffer("idpartida"));
	if (curPunteo.first()) {
		curPunteo.setModeAccess(curPunteo.Edit);
		curPunteo.refreshBuffer();
		if (curPunteo.valueBuffer("casado"))
			curPunteo.setNull("casado");
		else
			curPunteo.setValueBuffer("casado", true);
	}
	else {
		curPunteo.setModeAccess(curPunteo.Insert);
		curPunteo.refreshBuffer();
		curPunteo.setValueBuffer("idpartida", cursor.valueBuffer("idpartida"));
		curPunteo.setValueBuffer("casado", true);
	}

	curPunteo.commitBuffer();
	this.iface.tdbPartidas.refresh();

	this.iface.actualizarSaldoC();
}

/** Actualiza la etiqueta de saldos según el punteo hasta el momento
*/
function oficial_actualizarSaldoP()
{
	var util:FLUtil = new FLUtil();
	
	var saldo:Number = util.sqlSelect("co_partidas pa inner join co_punteo pu on pa.idpartida=pu.idpartida", "sum(pa.debe)-sum(pa.haber)", "idsubcuenta = " + this.cursor().valueBuffer("idsubcuenta") + " AND punteado = true", "co_partidas,co_punteo");
	if (!saldo)
		saldo = 0;
	else
		saldo = Math.round(parseFloat(saldo) * 100) / 100;
		
	this.child("leSaldoP").text = util.translate("scripts", "Saldo punteado") + ": <b>" + saldo + "</b>";
}

/** Actualiza la etiqueta de saldos según la casación hasta el momento
*/
function oficial_actualizarSaldoC()
{
	var util:FLUtil = new FLUtil();
	
	var saldo:Number = util.sqlSelect("co_partidas pa inner join co_punteo pu on pa.idpartida=pu.idpartida", "sum(pa.debe)-sum(pa.haber)", "idsubcuenta = " + this.cursor().valueBuffer("idsubcuenta") + " AND casado = true", "co_partidas,co_punteo");
	if (!saldo)
		saldo = 0;
	else
		saldo = Math.round(parseFloat(saldo) * 100) / 100;
		
	this.child("leSaldoC").text = util.translate("scripts", "Saldo casado") + ": <b>" + saldo + "</b>";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
