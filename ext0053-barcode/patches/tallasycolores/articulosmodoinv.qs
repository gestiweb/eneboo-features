/***************************************************************************
                 articulos.qs  -  description
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
class oficial extends interna 
{
	var tblTallas:QTable;
	var tblColores:QTable;
	var tblCombinaciones:QTable;
	var ordenComb:Array;
	var listaCombinaciones:String;
	
	function oficial( context ) { interna( context ); } 	
	function cargarTallasColores() {
		return this.ctx.oficial_cargarTallasColores(); 
	}
	function reloadColores() {
		return this.ctx.oficial_reloadColores(); 
	}
	function reloadTallas() {
		return this.ctx.oficial_reloadTallas(); 
	}
	function insertarColor() {
		return this.ctx.oficial_insertarColor(); 
	}
	function insertarTalla() {
		return this.ctx.oficial_insertarTalla(); 
	}
	function actualizarCombinaciones() {
		return this.ctx.oficial_actualizarCombinaciones(); 
	}
	function establecerCombinaciones() {
		return this.ctx.oficial_establecerCombinaciones(); 
	}
	function crearListaCombinaciones() {
		return this.ctx.oficial_crearListaCombinaciones(); 
	}
	function borrarCombinaciones() {
		return this.ctx.oficial_borrarCombinaciones(); 
	}
	function valueChangedComb(fil:Number, col:Number) {
		return this.ctx.oficial_valueChangedComb(fil, col); 
	}
	function clickedComb(fil:Number, col:Number) {
		return this.ctx.oficial_clickedComb(fil, col); 
	}
	function crearArticulo():Boolean {
		return this.ctx.oficial_crearArticulo(); 
	}
	function crearArticuloYotro() {
		return this.ctx.oficial_crearArticuloYotro(); 
	}
	function crearArticuloYcierre() {
		return this.ctx.oficial_crearArticuloYcierre(); 
	}
	function validarBarcodes():Boolean {
		return this.ctx.oficial_validarBarcodes(); 
	}
	function insertarColoresArt():Boolean {
		return this.ctx.oficial_insertarColoresArt(); 
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
	
	if (cursor.modeAccess() != cursor.Insert)
		return;
		
	var curOp:FLSqlCursor = new FLSqlCursor("opcionesmodoinv");
	curOp.select();
	if (!curOp.first()) {
		MessageBox.warning(util.translate("scripts", "No se han establecido las opciones. Se cancelará la inserción"), MessageBox.Ok, MessageBox.NoButton);
		this.child("pushButtonCancel").animateClick();
		return;
	}
	
	cursor.setValueBuffer("referencia", curOp.valueBuffer("valorreferencia"));
	cursor.setValueBuffer("descripcion", curOp.valueBuffer("valordescripcion"));
	
	var campos:Array = ["codfamilia","controlstock","imagen","codbarras","tipocodbarras","observaciones","pvp","ivaincluido","codimpuesto","stockmin","stockmax","codalmacenstock","codgrupotalla"];
	for (var i:Number = 0; i < campos.length; i++)
		if (curOp.valueBuffer(campos[i]))
			cursor.setValueBuffer(campos[i], curOp.valueBuffer("valor" + campos[i]));
		
/*	// OCULTAR CAMPOS ??
	var fdbXfield:Array;
	fdbXfield["controlstock"] = "fdbControlStock";
	fdbXfield["imagen"] = "fdbImagen";
	fdbXfield["iva"] = "frmIva";*/
	
	if (!curOp.valueBuffer("preciostarifa"))
		this.child("gbxPreciosTarifa").setDisabled(true);		
	if (!curOp.valueBuffer("preciosproveedor"))
		this.child("tbwArticulo").setTabEnabled("compra", false);	
	if (!curOp.valueBuffer("stocksalmacen"))
		this.child("gbxStocks2").setDisabled(true);	
	if (!curOp.valueBuffer("comisiones"))
		this.child("tbwArticulo").setTabEnabled("agentes", false);
			
	if (curOp.valueBuffer("codsubcuentacom"))
		cursor.setValueBuffer("idsubcuentacom", curOp.valueBuffer("idsubcuentacom"));
	if (curOp.valueBuffer("codsubcuentairpfcom"))
		cursor.setValueBuffer("idsubcuentairpfcom", curOp.valueBuffer("idsubcuentairpfcom"));
	
	this.iface.tblTallas = this.child("tblTallas");
	this.iface.tblColores = this.child("tblColores");
	this.iface.tblCombinaciones = this.child("tblCombinaciones");

	connect(this.child("pbnInsertarColor"), "clicked()", this, "iface.insertarColor");
	connect(this.child("pbnInsertarTalla"), "clicked()", this, "iface.insertarTalla");
	connect(this.child("pbnReloadColores"), "clicked()", this, "iface.reloadColores");
	connect(this.child("pbnReloadTallas"), "clicked()", this, "iface.reloadTallas");	
	connect(this.child("pbnActualizarCombinaciones"), "clicked()", this, "iface.actualizarCombinaciones");
	connect(this.child("pbnEstablecerCombinaciones"), "clicked()", this, "iface.establecerCombinaciones");
	connect(this.child("pbnBorrarCombinaciones"), "clicked()", this, "iface.borrarCombinaciones");
	connect(this.child("pbnOK"), "clicked()", this, "iface.crearArticuloYcierre");
	connect(this.child("pbnOKC"), "clicked()", this, "iface.crearArticuloYotro");
	
	this.iface.tblCombinaciones.setColumnReadOnly(0, true);
	this.iface.tblCombinaciones.setColumnReadOnly(1, true);
	this.iface.tblCombinaciones.setColumnReadOnly(2, true);
	this.iface.tblCombinaciones.setColumnReadOnly(3, true);
	
	if (!curOp.valueBuffer("regstocks"))
		this.iface.tblCombinaciones.setColumnReadOnly(5, true);
	
	this.iface.listaCombinaciones = "";
	this.iface.cargarTallasColores();

 	connect(this.iface.tblCombinaciones, "valueChanged(int,int)", this, "iface.valueChangedComb");
 	connect(this.iface.tblCombinaciones, "clicked(int,int)", this, "iface.clickedComb");

	
	this.child("pushButtonAccept").setDisabled(true);
	this.child("pushButtonAcceptContinue").setDisabled(true);
	this.child("tblCombinaciones").clear();
	this.child("gbxCombinaciones").setDisabled(true);	
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_cargarTallasColores()
{
	this.iface.reloadTallas();
	this.iface.reloadColores();
}

function oficial_reloadColores()
{
	var curTab:FLSqlCursor = new FLSqlCursor("colores");
	
	var totalFilas:Number = this.iface.tblColores.numRows() - 1;
	var fila:Number;
	this.iface.tblColores.clear();
	
	fila = 0;
	curTab.select();
	while (curTab.next()) {
		this.iface.tblColores.insertRows(fila, 1);
		this.iface.tblColores.setText(fila, 0, curTab.valueBuffer("codcolor"));
		this.iface.tblColores.setText(fila, 1, curTab.valueBuffer("descripcion"));
		fila++;
	}
}

function oficial_reloadTallas()
{
	var curTab:FLSqlCursor = new FLSqlCursor("tallas");
	
	var totalFilas:Number = this.iface.tblTallas.numRows() - 1;
	var fila:Number;
	this.iface.tblTallas.clear();
	
	fila = 0;
	
	var codGrupo:String = this.cursor().valueBuffer("codgrupotalla");
	var selectT:String = "";
	if (codGrupo)
		selectT = "codgrupotalla = '" + codGrupo + "'";
	
	curTab.select(selectT);
	while (curTab.next()) {
		this.iface.tblTallas.insertRows(fila, 1);
		this.iface.tblTallas.setText(fila, 0, curTab.valueBuffer("codtalla"));
		this.iface.tblTallas.setText(fila, 1, curTab.valueBuffer("descripcion"));
		fila++;
	}
}

function oficial_insertarColor()
{
	var curTab:FLSqlCursor = new FLSqlCursor("colores");
	curTab.insertRecord();
}

function oficial_insertarTalla()
{
	var curTab:FLSqlCursor = new FLSqlCursor("tallas");
	curTab.insertRecord();
}

function oficial_actualizarCombinaciones()
{
	var totalFilas:Number = this.iface.tblCombinaciones.numRows() - 1;
	var fila:Number;
	var talla:String, color:String;
		
	fila = 0;
	var colores:Array = this.iface.tblColores.selectedRows();
	var tallas:Array = this.iface.tblTallas.selectedRows();
	
	// Al inicio está bloqueada para no romper al clickar
	if (colores.length && tallas.length)
		this.child("gbxCombinaciones").setDisabled(false);
	
	for (i = 0; i < colores.length; i++) {
		for (j = 0; j < tallas.length; j++) {
			
			talla = this.iface.tblTallas.text(tallas[j], 0);
			color = this.iface.tblColores.text(colores[i], 0);
			
			// Existe ya?
			if (this.iface.listaCombinaciones.search("ðð" + talla + "ð" + color) > -1)
				continue;
			
			this.iface.tblCombinaciones.insertRows(fila, 1);
			this.iface.tblCombinaciones.setText(fila, 2, talla);
			this.iface.tblCombinaciones.setText(fila, 3, color);
			this.iface.tblCombinaciones.setRowReadOnly(fila, false);
			fila++;
		}
	}
	
	this.iface.crearListaCombinaciones();
}

function oficial_establecerCombinaciones()
{
	var referencia:String = this.child("fdbReferencia").value();

	var filInicio:Number = -1, colInicio:Number;

	var totalFilas:Number = this.iface.tblCombinaciones.numRows();
	for (i = totalFilas - 1; i >= 0; i--)
		if (this.iface.tblCombinaciones.text(i,0) != "X")
			this.iface.tblCombinaciones.removeRow(i);
	
	this.iface.crearListaCombinaciones();
	
	totalFilas = this.iface.tblCombinaciones.numRows();
	for (fila = 0; fila < totalFilas; fila++) {
		
		// Usar?
		if (!this.iface.tblCombinaciones.text(fila,0)) {
			this.iface.tblCombinaciones.setText(fila, 4, "");
			this.iface.tblCombinaciones.setText(fila, 5, "");
			this.iface.tblCombinaciones.setRowReadOnly(fila, true);
			continue;
		}
		
		// Auto?
		if(this.iface.tblCombinaciones.text(fila,1)) {
			talla = this.iface.tblCombinaciones.text(fila,2);
			color = this.iface.tblCombinaciones.text(fila,3);
			barcode = referencia + talla + color;
			this.iface.tblCombinaciones.setText(fila, 4, barcode);
			
			if (filInicio == -1) {
				filInicio = fila;
				colInicio = 5;
			}
		}
		
		else {
			this.iface.tblCombinaciones.setText(fila, 4, "");
			if (filInicio == -1) {
				filInicio = fila;
				colInicio = 4;
			}
		}
	
	}
	
	debug(filInicio + "," +colInicio);
 	this.iface.tblCombinaciones.editCell(filInicio,colInicio);
}

function oficial_crearListaCombinaciones()
{
	this.iface.listaCombinaciones = "";
	var fila:Number, talla:String, color:String;
	for (fila = 0; fila < this.iface.tblCombinaciones.numRows(); fila++) {
		talla = this.iface.tblCombinaciones.text(fila, 2);
		color = this.iface.tblCombinaciones.text(fila, 3);
		this.iface.listaCombinaciones += "ðð" + talla + "ð" + color;
	}
}

function oficial_borrarCombinaciones()
{
	var aBorrar:Array = this.iface.tblCombinaciones.selectedRows();
	if (!aBorrar.length)
		return;
		
	var util:FLUtil = new FLUtil();
	res = MessageBox.warning(util.translate("scripts", "Se borrarán las combinaciones seleccionadas\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;		
	
	for (i = aBorrar.length - 1; i >= 0; i--)
		this.iface.tblCombinaciones.removeRow(aBorrar[i]);

	this.iface.crearListaCombinaciones();
	
	if (!this.iface.tblCombinaciones.numRows())
		this.child("gbxCombinaciones").setDisabled(true);
}

function oficial_valueChangedComb(fil:Number, col:Number)
{
	var util:FLUtil = new FLUtil();
	debug("Cambio valor " + fil + " " + col);
	
	switch (col) {
		case 4:
			if (util.sqlSelect("opcionesmodoinv", "regstocks", "1=1"))
				col = 5;
			else
				fil++;
			break;
		case 5:
			col = 4;
			fil++;
		break;
		default:
			return;
	}
	
	if (fil == this.iface.tblCombinaciones.numRows())
		fil = 0;
	
	if (this.iface.tblCombinaciones.text(fil, 1))
		col = 5;
		
	debug("Destino " + fil + " " + col);
 	this.iface.tblCombinaciones.editCell(fil,col);
}

function oficial_clickedComb(fil:Number, col:Number)
{
	if (col > 1)
		return;
		
	if (this.iface.tblCombinaciones.text(fil, col))
		this.iface.tblCombinaciones.setText(fil, col, "");
	else {
		this.iface.tblCombinaciones.setText(fil, col, "X");
		if (col == 1)
			this.iface.tblCombinaciones.setText(fil, 0, "X");
	}
	
}


function oficial_crearArticuloYcierre() 
{
	if (!this.iface.crearArticulo())
		return;
	this.child("pushButtonAccept").setDisabled(false);
	this.child("pushButtonAccept").animateClick();
}

function oficial_crearArticuloYotro() 
{
	if (!this.iface.crearArticulo())
		return;
	this.child("pushButtonAcceptContinue").setDisabled(false);
	this.child("pushButtonAcceptContinue").animateClick();
}


function oficial_crearArticulo():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (!this.iface.validarBarcodes())
		return false;
	
	var curTab:FLSqlCursor = this.child("tdbArticlulosProv").cursor();
	curTab.setModeAccess(curTab.Insert);
	if (!curTab.commitBufferCursorRelation())
		return false;
	
	var referencia:String = cursor.valueBuffer("referencia");
	var pvp:Number = cursor.valueBuffer("pvp");
	var creados:Number = 0, stockados:Number = 0;
		
	var codAlmacen:String = cursor.valueBuffer("codalmacenstock");
	if (!codAlmacen) {
		res = MessageBox.warning(util.translate("scripts", "No se ha establecido un almacén para los stocks. Si continúa no se crearán los stocks\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return false;
	}
	
	// Barcodes
	curTab = new FLSqlCursor("atributosarticulos");
	curTabS = new FLSqlCursor("stocks");
	var talla:String, color:String, barcode:String, stock:Number;
	
	var numFilas:Number = this.iface.tblCombinaciones.numRows();
	util.createProgressDialog( util.translate( "scripts", "Creando barcodes..." ), numFilas );
	
	for (fila = 0; fila < numFilas; fila++) {
		
		util.setProgress(fila + 1);
		
		// Usar?
		if (!this.iface.tblCombinaciones.text(fila,0))
			continue;
				
		barcode = this.iface.tblCombinaciones.text(fila,4);
		if (!barcode)
			continue;
				
		talla = this.iface.tblCombinaciones.text(fila,2);
		color = this.iface.tblCombinaciones.text(fila,3);
		stock = parseFloat(this.iface.tblCombinaciones.text(fila,5));
		
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("barcode", barcode);
		curTab.setValueBuffer("referencia", referencia);
		curTab.setValueBuffer("talla", talla);
		curTab.setValueBuffer("color", color);
		curTab.setValueBuffer("pvp", pvp);
		curTab.commitBuffer();
		
		if (stock && codAlmacen) {
			
			curTabS.setModeAccess(curTabS.Insert);
			curTabS.refreshBuffer();
			curTabS.setValueBuffer("referencia", referencia);
			curTabS.setValueBuffer("barcode", barcode);
			curTabS.setValueBuffer("codalmacen", codAlmacen);
			curTabS.setValueBuffer("cantidad", stock);
			curTabS.setValueBuffer("disponible", stock);
			curTabS.setValueBuffer("reservada", 0);
			curTabS.setValueBuffer("pterecibir", 0);
			curTabS.commitBuffer();
			stockados++;
		}
		
		creados++;
	}
	
	this.iface.insertarColoresArt();
	
	util.destroyProgressDialog();
	MessageBox.information(util.translate("scripts", "Se crearon %0 nuevos barcodes y %0 nuevos registros de stock").arg(creados).arg(stockados), MessageBox.Ok, MessageBox.NoButton);

	return true;
}

function oficial_insertarColoresArt():Boolean
{
	var totalFilas:Number = this.iface.tblCombinaciones.numRows() - 1;
	var fila:Number = 0;
	var colores:Array = this.iface.tblColores.selectedRows();
	var color:String;
	var curTab:FLSqlCursor = new FLSqlCursor("coloresarticulo");
	var referencia:String = this.cursor().valueBuffer("referencia");
	
	var util:FLUtil = new FLUtil();
	util.createProgressDialog( util.translate( "scripts", "Creando colores por artículo..." ), colores.length );
	
	for (i = 0; i < colores.length; i++) {
		
		util.setProgress(i + 1);
		
		color = this.iface.tblColores.text(colores[i], 0);
		
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("referencia", referencia);
		curTab.setValueBuffer("codcolor", color);
		curTab.setValueBuffer("descolor", util.sqlSelect("colores", "descripcion", "codcolor = '" + color + "'"));
		curTab.commitBuffer();
	}
	
	util.destroyProgressDialog();
}


function oficial_validarBarcodes():Boolean
{
	var util:FLUtil = new FLUtil();
	var faltanBarcodes:String = "";
	var existenBarcodes:String = "";
	var talla:String, color:String, barcode:String;
	
	for (fila = 0; fila < this.iface.tblCombinaciones.numRows(); fila++) {
		
		// Usar?
		if (!this.iface.tblCombinaciones.text(fila,0))
			continue;
				
		barcode = this.iface.tblCombinaciones.text(fila,4);
		if (!barcode)
			faltanBarcodes += "\n" + fila;
		if (util.sqlSelect("atributosarticulos", "barcode", "barcode = '" + barcode + "'"))
			existenBarcodes += "\n" + barcode;
	}
	
	if (existenBarcodes) {
		MessageBox.warning(util.translate("scripts", "Algunos barcodes ya existen:\n") + existenBarcodes, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	if (faltanBarcodes) {
		res = MessageBox.warning(util.translate("scripts", "Algunos barcodes no han sido establecidos y se ignorarán\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return false;
	}
	
	return true;
}

//// OFICIAL ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////