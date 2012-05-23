/***************************************************************************
                 regstocks_buffer.qs  -  description
                             -------------------
    begin                : mie sep 20 2006
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
	var tablaStock:FLTable;
	var arrayStocks:Array;
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function actualizarTabla() {
		return this.ctx.oficial_actualizarTabla();
	}
	function insertar() {
		return this.ctx.oficial_insertar();
	}
	function nuevaFila() {
		return this.ctx.oficial_nuevaFila();
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
\end */
function interna_init()
{
	this.iface.tablaStock = this.child("tblAtributos");
	this.iface.arrayStocks = [];
	var cursor:FLSqlCursor = this.cursor();
	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect (this.child("pbnInsertar"), "clicked()", this, "iface.insertar");
	connect (this.child("tbnNuevaFila"), "clicked()", this, "iface.nuevaFila");
	
	var hoy:Date = new Date;
	this.child("fdbFecha").setValue(hoy);
	this.child("fdbHora").setValue(hoy);
	this.iface.actualizarTabla();
	this.child("pushButtonAccept").setEnabled(false);
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "codalmacenstock":
		case "referencia": {
			this.iface.actualizarTabla();
			break;
		}
	}
}

/** \D Si el almacén y la referencia son válidos, carga los datos de stock actuales
\end */
function oficial_actualizarTabla()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var codAlmacen = cursor.valueBuffer("codalmacenstock");
	if (!codAlmacen || codAlmacen == "")
		return false;
	var referencia = cursor.valueBuffer("referencia");
	if (!referencia || referencia == "")
		return false;

	if (!util.sqlSelect("almacenes", "codalmacen", "codalmacen = '" + codAlmacen + "'"))
		return false;
	if (!util.sqlSelect("articulos", "referencia", "referencia = '" + referencia + "'"))
		return false;

	this.iface.arrayStocks = formRecordarticulos.iface.pub_refrescarTablaStock(this.iface.tablaStock, this.iface.arrayStocks, cursor);
	/*
	var qryStocks:FLSqlQuery = new FLSqlQuery;
	qryStocks.setTablesList("stocks,atributosarticulos");
	qryStocks.setSelect("s.barcode, s.cantidad, aa.talla, aa.color");
	qryStocks.setFrom("stocks s INNER JOIN atributosarticulos aa ON s.barcode = aa.barcode");
	qryStocks.setWhere("s.codalmacen = '" + codAlmacen + "' AND referencia = '" + referencia + "'");
	qryStocks.setForwardOnly(true);
	if (!qryStocks.exec())
		return false;
	*/
}

function oficial_insertar()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var datos:String = "";
	var idStock:String;
	var nuevaCantidad:Number;
	var referencia:String = cursor.valueBuffer("referencia");
	var texto:String;
	var codTalla:String;
	var codColor:String;
	var barCode:String;
	for (var fila:Number = 0; fila < this.iface.tablaStock.numRows(); fila++) {
		for (var columna:Number = 0; columna < this.iface.arrayStocks[fila].length; columna++) {
			texto = parseFloat(this.iface.tablaStock.text(fila, columna))
			nuevaCantidad = parseFloat(texto);
			if (isNaN(nuevaCantidad))
				continue;
			
			barCode = false;
			viejaCantidad = 0;
			idStock = this.iface.arrayStocks[fila][columna]["idstock"];
			codTalla = this.iface.arrayStocks[fila][columna]["talla"];
			codColor = this.iface.arrayStocks[fila][columna]["color"];
			if (idStock && idStock != "") {
				barCode = util.sqlSelect("stocks", "barcode", "idstock = " + idStock);
				viejaCantidad = util.sqlSelect("stocks", "cantidad", "idstock = " + idStock);
			}
			if (nuevaCantidad == parseFloat(viejaCantidad))
				continue;
			if (!barCode)
				barCode = util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND talla = '" + codTalla + "' AND color = '" + codColor + "'");
			if (!barCode)
				barCode = flfactalma.iface.pub_construirBarcode(referencia, codTalla, codColor);			
					
			debug(barCode);
			
			if (datos != "")
				datos += ";"
			datos += barCode + "," + codTalla + "," + codColor + "," + nuevaCantidad + "," + viejaCantidad;
		}
	}

	cursor.setValueBuffer("datos", datos);
	this.child("pushButtonAccept").setEnabled(true);
	this.child("pushButtonAccept").animateClick();
}

function oficial_nuevaFila()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = cursor.valueBuffer("referencia");
	if (!referencia || referencia == "")
		return;
	
	var res:Number = MessageBox.information(util.translate("scripts", "Si modifica la tabla de tallas y colores perderá los datos que haya modificado en la misma. ¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return false;

	if (!flfactalma.iface.pub_pedirColor(referencia))
		return false;

	this.iface.arrayStocks = formRecordarticulos.iface.pub_refrescarTablaStock(this.iface.tablaStock, this.iface.arrayStocks, cursor);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
