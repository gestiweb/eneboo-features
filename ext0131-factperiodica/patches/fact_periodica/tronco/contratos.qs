/**************************************************************************
                 contratos.qs  -  description
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
	function calculateCounter():String { return this.ctx.interna_calculateCounter(); }
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function cargarArticulos() {
		return this.ctx.oficial_cargarArticulos();
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

/** \D Sólo mostramos las facturas del contrato actual
*/
function interna_init()
{
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("periodoscontratos");
	q.setFrom("periodoscontratos");
	q.setSelect("idfactura");
	q.setWhere("codcontrato = '" + this.cursor().valueBuffer("codigo") + "'");

	q.exec();
	
	var lista:String = "";
	while(q.next()) {
		if (lista) lista += ",";
		lista += q.value(0);
	}

	if (lista)
		this.child("tdbFacturas").cursor().setMainFilter("idfactura IN (" + lista + ")");
	else
		this.child("tdbFacturas").cursor().setMainFilter("idfactura = -1");

	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("toolButtomRecargarArticulos"), "clicked()", this, "iface.cargarArticulos");
}

function interna_calculateCounter()
{
}

function interna_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
	
		case "periodopago":
		
			var tipo:Number = 0;
			var tipos:Array = [];
			tipos["Mensual"] = tipo++;
			tipos["Bimestral"] = tipo++;
			tipos["Trimestral"] = tipo++;
			tipos["Semestral"] = tipo++;
			tipos["Anual"] = tipo++;
			tipos["Bienal"] = tipo;
	
			valor = util.sqlSelect("tiposcontrato", "periodopago", "codigo = '" + this.cursor().valueBuffer("tipocontrato") + "'");
			if (!valor) return "";
			valor = tipos[valor];
		break;
	}
	
	return valor;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_bufferChanged(fN:String)
{
	switch (fN) {
		case "tipocontrato":
			var valor = this.iface.calculateField("periodopago");
			if (valor)
				this.child("fdbPeriodoPago").setValue(valor);
				
			this.iface.cargarArticulos();
		break;
	}
}

function oficial_cargarArticulos()
{
	var util:FLUtil = new FLUtil();
	var res = MessageBox.warning(util.translate("scripts", "Se va a regenerar la lista de artículos a partir del tipo de contrato\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;

	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Insert) {
		var curES:FLSqlCursor = this.child("tdbArticulos").cursor();
		if (!curES.commitBufferCursorRelation())
			return false;
	}

	var curAT:FLSqlCursor = new FLSqlCursor("articulostiposcontratos");
	var curAC:FLSqlCursor = new FLSqlCursor("articuloscontratos");
	var codContrato:String = cursor.valueBuffer("codigo");
	
	util.sqlDelete("articuloscontratos", "codcontrato = '" + codContrato + "'");
	
	curAT.select("tipocontrato = '" + cursor.valueBuffer("tipocontrato") + "'");
	while(curAT.next()) {
		curAC.setModeAccess(curAC.Insert);
		curAC.refreshBuffer();
		curAC.setValueBuffer("codcontrato", codContrato);
		curAC.setValueBuffer("referencia", curAT.valueBuffer("referencia"));
		curAC.setValueBuffer("descripcion", curAT.valueBuffer("descripcion"));
		curAC.setValueBuffer("codimpuesto", curAT.valueBuffer("codimpuesto"));
		curAC.setValueBuffer("periododesde", curAT.valueBuffer("periododesde"));
		curAC.setValueBuffer("periodohasta", curAT.valueBuffer("periodohasta"));
		curAC.setValueBuffer("coste", curAT.valueBuffer("coste"));
		curAC.setValueBuffer("condiciones", curAT.valueBuffer("condiciones"));
		curAC.commitBuffer();
	}
	
	this.child("tdbArticulos").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
