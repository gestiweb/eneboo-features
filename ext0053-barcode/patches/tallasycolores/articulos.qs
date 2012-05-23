
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends ivaIncluido 
{
	var tblTallas:QTable;
	var tblColores:QTable;
	var tblMatrizPrecios:QTable;
	var tblMatrizBarcodes:QTable;
	var tblStock:QTable;
	var listaTallas:String;
	var listaColores:String;
	var tbwTC:Object;
	var arrayStock:Array;
	var datosModificados:Boolean;
	var ultimoBarcode_:String;
	var calculoBarcode_:String;
	var digitosBarcode_:String;
	var prefijoBarcode_:String;

    function barCode( context ) { ivaIncluido ( context ); }
    function init() {
		return this.ctx.barCode_init();
	}
	function validateForm():Boolean {
		return this.ctx.barCode_validateForm();
	}
	function bufferChanged(fN:String) {
		return this.ctx.barCode_bufferChanged(fN);
	}
	function refrescarTablaStock(tblStock:FLTable, arrayStock:Array, cursor:FLSqlCursor):Array {
		return this.ctx.barCode_refrescarTablaStock(tblStock, arrayStock, cursor);
	}
	function pbnTransferir_clicked() {
		return this.ctx.barCode_pbnTransferir_clicked();
	}
	function pbnRegularizar_clicked() {
		return this.ctx.barCode_pbnRegularizar_clicked();
	}
	function refrescarColores() {
			return this.ctx.barCode_refrescarColores();
	}
	function generarTC() {
			return this.ctx.barCode_generarTC();
	}
	function guardarTC() {
			return this.ctx.barCode_guardarTC();
	}
	function guardarPreciosTarifas() {
			return this.ctx.barCode_guardarPreciosTarifas();
	}
	function reloadTallas() {
		return this.ctx.barCode_reloadTallas(); 
	}
	function reloadColores() {
		return this.ctx.barCode_reloadColores(); 
	}
	function reloadMatrizPrecios() {
		return this.ctx.barCode_reloadMatrizPrecios(); 
	}
	function reloadMatrizPreciosTarifas() {
		return this.ctx.barCode_reloadMatrizPreciosTarifas(); 
	}
	function clickedTalla(fil:Number, col:Number) {
		return this.ctx.barCode_clickedTalla(fil, col); 
	}
	function clickedColor(fil:Number, col:Number) {
		return this.ctx.barCode_clickedColor(fil, col); 
	}
	function clickedBC(fil:Number, col:Number) {
		return this.ctx.barCode_clickedBC(fil, col); 
	}
	function clickedPrecios(fil:Number, col:Number) {
		return this.ctx.barCode_clickedPrecios(fil, col); 
	}
	function obtenerBarcode(referencia:String, codTalla:String, codColor:String):String {
		return this.ctx.barCode_obtenerBarcode(referencia, codTalla, codColor);
	}
	function digitoControlEAN(valorSinDC:String):String {
		return this.ctx.barCode_digitoControlEAN(valorSinDC);
	}
	//funcion de etiBarcode
	function imprimirEtiquetas() {
		return this.ctx.barCode_imprimirEtiquetas();
	}
	//función de tpvTallColBar
	function refrescarStock() {
		return this.ctx.barCode_refrescarStock();
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_declaration pubBarCode */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class pubBarCode extends ifaceCtx {
    function pubBarCode( context ) { ifaceCtx( context ); }
	function pub_refrescarTablaStock(tblStock:FLTable, arrayStock:Array, cursor:FLSqlCursor):Array {
		return this.refrescarTablaStock(tblStock, arrayStock, cursor);
	}
}
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_init()
{
	this.iface.__init();
	
	this.iface.tblStock = this.child("tblStock");
	this.iface.tblTallas = this.child("tblTallas");
	this.iface.tblColores = this.child("tblColores");
	this.iface.tbwTC = this.child("tbwTC");
	this.iface.tblMatrizPrecios = this.child("tblMatrizPrecios");
	this.iface.tblMatrizBarcodes = this.child("tblMatrizBarcodes");
	this.iface.ultimoBarcode_ = false;
	this.iface.calculoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("calculobarcode");
	this.iface.digitosBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("digitosbarcode");
	this.iface.prefijoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("prefijobarcode");
	if (!this.iface.prefijoBarcode_ || this.iface.prefijoBarcode_ == "NULL") {
		this.iface.prefijoBarcode_ = "";
	}
	
	connect(this.child("pbnTransferir"), "clicked()", this, "iface.pbnTransferir_clicked()");
	connect(this.child("pbnRegularizar"), "clicked()", this, "iface.pbnRegularizar_clicked()");
	connect(this.child("pbnGenerarTC"), "clicked()", this, "iface.generarTC()");
	connect(this.child("pbnGenerarPrecios"), "clicked()", this, "iface.reloadMatrizPrecios()");
	connect(this.child("pbnGuardarTC"), "clicked()", this, "iface.guardarTC()");
	connect(this.child("pbnGenerarPreciosTarifas"), "clicked()", this, "iface.reloadMatrizPreciosTarifas()");
	connect(this.child("pbnGuardarPreciosTarifas"), "clicked()", this, "iface.guardarPreciosTarifas()");
 	connect(this.iface.tblTallas, "clicked(int,int)", this, "iface.clickedTalla");
 	connect(this.iface.tblColores, "clicked(int,int)", this, "iface.clickedColor");
 	connect(this.iface.tblMatrizBarcodes, "clicked(int,int)", this, "iface.clickedBC");
 	connect(this.iface.tblMatrizPrecios, "clicked(int,int)", this, "iface.clickedPrecios");

 	connect(this.child("tdbAtributosArticulos").cursor(), "bufferCommited()", this, "iface.refrescarColores()");

	//conexión del init de etiBarcode
	connect(this.child("tbnEtiquetas"), "clicked()", this, "iface.imprimirEtiquetas");

	//conexión de intit de tpvTallColBar
	connect(this.child("tdbAtributosArticulos").cursor(), "bufferCommited()", this, "iface.refrescarStock()");

	this.child("pbnGenerarPrecios").setDisabled(true);
	this.child("pbnGuardarTC").setDisabled(true);
	this.child("pbnGuardarPreciosTarifas").setDisabled(true);
	
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.modeAccess() == cursor.Edit) {
		this.iface.generarTC();
		this.iface.reloadMatrizPrecios();
	}
	
	if (cursor.modeAccess() == cursor.Insert)
		this.child("fdbCodAlmacenStock").setValue(flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
	else
		this.iface.arrayStock = this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, cursor);
}

function barCode_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		case "codalmacenstock": {
			this.iface.arrayStock = this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, this.cursor());
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}

/** \D Compone una tabla de tantas filas como tallas y tantas columnas como colores hay definidos para el artï¿?culo seleccionado, indicando en cada celda la cantidad existente para la combinaciï¿?n talla / color en el almacï¿?n seleccionado */
function barCode_refrescarTablaStock(tblStock:FLTable, arrayStock:Array, cursor:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var referencia:String = cursor.valueBuffer("referencia");
	var codAlmacen:String = cursor.valueBuffer("codalmacenstock");
	
	if (!referencia || !codAlmacen || referencia == "" || codAlmacen == "")
		return;
	
	var numFilas:Number = tblStock.numRows();
	var numColumnas:Number;
	
	for (var i:Number = (numFilas - 1); i >= 0; i--)
		tblStock.removeRow(i);
	
	var codGrupoTalla:String = util.sqlSelect("articulos", "codgrupotalla", "referencia = '" + referencia + "'");
	var listaTallas:String = "";
	var tallas:Array = [];
	var qryTallas:FLSqlQuery = new FLSqlQuery;
	if (codGrupoTalla && codGrupoTalla != "") {
		qryTallas.setTablesList("tallas");
		qryTallas.setSelect("codtalla");
		qryTallas.setFrom("tallas");
		qryTallas.setWhere("codgrupotalla = '" + codGrupoTalla + "'");
	} else {
		qryTallas.setTablesList("atributosarticulos");
		qryTallas.setSelect("talla");
		qryTallas.setFrom("atributosarticulos");
		qryTallas.setWhere("referencia = '" + referencia + "' AND talla IS NOT NULL GROUP BY talla ORDER BY talla");
	}
	qryTallas.setForwardOnly(true);
	if (!qryTallas.exec())
		return;
	numColumnas = 0;
	var sep:String = "ï¿?";
	while (qryTallas.next()) {
		tallas[numColumnas++] = qryTallas.value(0);
		if (listaTallas)
			listaTallas += sep;
		listaTallas += qryTallas.value(0);
	}
	tblStock.setNumCols(numColumnas);
	tblStock.setColumnLabels(sep, listaTallas);
	
	var listaColores:String = "";
	var colores:Array = [];
	var qryColores:FLSqlQuery = new FLSqlQuery;
	qryColores.setTablesList("coloresarticulo");
	qryColores.setSelect("codcolor");
	qryColores.setFrom("coloresarticulo");
	qryColores.setWhere("referencia = '" + referencia + "' ORDER BY codcolor");
	if (!qryColores.exec())
		return;
	numFilas = 0;
	while (qryColores.next()) {
		colores[numFilas++] = qryColores.value("codcolor");
		if (listaColores)
			listaColores += sep;
		listaColores += qryColores.value("codcolor");
	}
	tblStock.insertRows(0, numFilas);
	tblStock.setRowLabels(sep, listaColores);
	
	if (arrayStock)
		delete arrayStock;
	arrayStock = new Array(numFilas);
	for (var i:Number = 0; i < numFilas; i++) {
		arrayStock[i] = new Array(numColumnas);
		for (var k:Number = 0; k < numColumnas; k++) {
			arrayStock[i][k] = new Array(3);
			arrayStock[i][k]["idstock"] = false;
			arrayStock[i][k]["talla"] = tallas[k];
			arrayStock[i][k]["color"] = colores[i];
		}
	}
	
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("stocks,atributosarticulos");
	qryStock.setSelect("aa.talla, aa.color, s.cantidad, s.idstock");
	qryStock.setFrom("atributosarticulos aa INNER JOIN stocks s ON s.barcode = aa.barcode");
	qryStock.setWhere("aa.referencia = '" + referencia + "' AND s.codalmacen = '" + codAlmacen + "'");
	if (!qryStock.exec())
		return false;

	while (qryStock.next()) {
		for (numFilas = 0; numFilas < colores.length; numFilas++) {
			if (colores[numFilas] == qryStock.value("aa.color"))
				break;
		}
		if (numFilas == colores.length)
			continue;
		 
		for (numColumnas = 0; numColumnas < tallas.length; numColumnas++) {
			if (tallas[numColumnas ] == qryStock.value("aa.talla"))
				break;
		}
		if (numColumnas == tallas.length)
			continue;

		var cantidad:Number = parseInt(qryStock.value("s.cantidad"));
		
		if(!cantidad)
			cantidad = 0;

		tblStock.setText(numFilas, numColumnas, cantidad);
		arrayStock[numFilas][numColumnas]["idstock"] = qryStock.value("s.idstock");
		arrayStock[numFilas][numColumnas]["talla"] = qryStock.value("aa.talla");
		arrayStock[numFilas][numColumnas]["color"] = qryStock.value("aa.color");
	}
	return arrayStock;
}

function barCode_pbnTransferir_clicked()
{
	var util:FLUtil = new FLUtil;
	var curTransStock:FLSqlCursor = new FLSqlCursor("transstock");
	curTransStock.insertRecord();
/*
	var idStock = this.iface.arrayStock[this.iface.tblStock.currentRow()][this.iface.tblStock.currentColumn()]["idstock"];
	if (!idStock) {
		MessageBox.information(util.translate("scripts", "Debe seleccionar un stock existente para realizar la transferencia"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	if (!formregstocks.iface.pub_transferirStock(idStock))
		return;
	this.iface.arrayStock = this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, this.cursor());
*/
}

function barCode_pbnRegularizar_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = cursor.valueBuffer("referencia");

	formregstocks.iface.pub_insertarRegularizaciones(referencia, cursor.valueBuffer("codalmacenstock"));
	this.iface.arrayStock = this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, cursor);
	this.child("fdbStockFisico").setValue(util.sqlSelect("stocks", "SUM(cantidad)", "referencia = '" + referencia + "'"));
}

function barCode_refrescarColores()
{
	this.child("tdbColoresArticulo").refresh();
}

function barCode_generarTC()
{
	var util:FLUtil = new FLUtil();
	
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		var curAA:FLSqlCursor = this.child("tdbAtributosArticulos").cursor();
		curAA.setModeAccess(curAA.Insert);
		if (!curAA.commitBufferCursorRelation())
			return false;
	}
	
	if (this.iface.tblTallas.numRows() || this.iface.tblColores.numRows()) {
		res = MessageBox.information(util.translate("scripts", "Si recarga las tallas y colores se eliminarï¿?n los cambios no guardados\n\nï¿?Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return;
	}

	this.iface.reloadTallas();
	this.iface.reloadColores();
	this.iface.tbwTC.showPage("tallas");
	this.child("pbnGenerarPrecios").setDisabled(false);
}

function barCode_reloadTallas()
{
	var referencia:String = this.cursor().valueBuffer("referencia");
	if (!referencia)
		return;
	
	var curTab:FLSqlCursor = new FLSqlCursor("tallasset");
	var curTabA:FLSqlCursor = new FLSqlCursor("tallasarticulo");
	
	var codSet:String = this.cursor().valueBuffer("codsettallas");
	var pvp:String = this.cursor().valueBuffer("pvp");
	if (!codSet)
		return;
	
	var util:FLUtil = new FLUtil();
	
	var fila:Number;
	this.iface.tblTallas.clear();
	
	fila = 0;
	curTab.select("codset = '" + codSet + "'");
	while (curTab.next()) {
	
		this.iface.tblTallas.insertRows(fila, 1);
		this.iface.tblTallas.setText(fila, 0, curTab.valueBuffer("codtalla"));
		
		curTabA.select("referencia = '" + referencia + "' AND codtalla = '" + curTab.valueBuffer("codtalla") + "'");
		if (curTabA.first()) {
			this.iface.tblTallas.setText(fila, 2, curTabA.valueBuffer("pvp"));
			if (curTabA.valueBuffer("activo"))
				this.iface.tblTallas.setText(fila, 3, "X");
		}
		else {
			this.iface.tblTallas.setText(fila, 2, pvp);
			this.iface.tblTallas.setText(fila, 3, "X");
		}
		
		descTalla = util.sqlSelect("tallas", "descripcion", "codtalla = '" + curTab.valueBuffer("codtalla") + "'");
		this.iface.tblTallas.setText(fila, 1, descTalla);
		
		fila++;
	}
	
	this.iface.tblTallas.setColumnReadOnly(0, true);
	this.iface.tblTallas.setColumnReadOnly(1, true);
	this.iface.tblTallas.setColumnReadOnly(3, true);
	
}

function barCode_reloadColores()
{
	var referencia:String = this.cursor().valueBuffer("referencia");
	if (!referencia)
		return;
	
	var curTab:FLSqlCursor = new FLSqlCursor("coloresset");
	var curTabA:FLSqlCursor = new FLSqlCursor("coloresarticulo");
	
	var codSet:String = this.cursor().valueBuffer("codsetcolores");
	if (!codSet)
		return;
	
	var util:FLUtil = new FLUtil();
	
	var fila:Number;
	this.iface.tblColores.clear();
	
	fila = 0;
	curTab.select("codset = '" + codSet + "'");
	while (curTab.next()) {
	
		this.iface.tblColores.insertRows(fila, 1);		
		this.iface.tblColores.setText(fila, 0, curTab.valueBuffer("codcolor"));
		
		curTabA.select("referencia = '" + referencia + "' AND codcolor = '" + curTab.valueBuffer("codcolor") + "'");
		if (curTabA.first()) {
			this.iface.tblColores.setText(fila, 2, curTabA.valueBuffer("incporcentual"));
			this.iface.tblColores.setText(fila, 3, curTabA.valueBuffer("inclineal"));
			if (curTabA.valueBuffer("activo"))
				this.iface.tblColores.setText(fila, 4, "X");
		}
		else {
			this.iface.tblColores.setText(fila, 2, 0);
			this.iface.tblColores.setText(fila, 3, 0);
			this.iface.tblColores.setText(fila, 4, "X");
		}
		
		descColor = util.sqlSelect("colores", "descripcion", "codcolor = '" + curTab.valueBuffer("codcolor") + "'");
		this.iface.tblColores.setText(fila, 1, descColor);
	
		fila++;
	}

	this.iface.tblColores.setColumnReadOnly(0, true);
	this.iface.tblColores.setColumnReadOnly(1, true);
	this.iface.tblColores.setColumnReadOnly(4, true);
}

function barCode_reloadMatrizPrecios()
{
	var util:FLUtil = new FLUtil();
	
	if (this.iface.tblMatrizBarcodes.numRows()) {
		res = MessageBox.information(util.translate("scripts", "Si regenera los precios y barcodes se eliminarï¿?n los cambios no guardados\n\nï¿?Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return;
	}

	this.iface.listaTallas = "";
	this.iface.listaColores = "";
	
	var listaTallasBC:String = "";
	var preciosTallas:Array = [];
	var codigosTallas:Array = [];
	
	var sep:String = "ï¿?";

	var fila:Number = 0;
	var col:Number = 0;
	
	var referencia:String = this.cursor().valueBuffer("referencia");
	
	this.iface.tblMatrizPrecios.clear();
	this.iface.tblMatrizBarcodes.clear();
	
	for (numT = 0; numT < this.iface.tblTallas.numRows(); numT++) {
	
		if(!this.iface.tblTallas.text(numT, 3))
			continue;
	
		if (this.iface.listaTallas)
			this.iface.listaTallas += sep;
			
		this.iface.listaTallas += this.iface.tblTallas.text(numT, 0);
		listaTallasBC += sep + this.iface.tblTallas.text(numT, 0);
		listaTallasBC += sep + util.translate("scripts", "Activo");
		
		codigosTallas[col] = this.iface.tblTallas.text(numT, 0);
		preciosTallas[col] = this.iface.tblTallas.text(numT, 2);
		col++;
	}
	
	if (!col)
		return;
		
	this.iface.tblMatrizPrecios.setNumCols(col);
	this.iface.tblMatrizPrecios.setColumnLabels(sep, this.iface.listaTallas);
		
	this.iface.tblMatrizBarcodes.setNumCols(col * 2);
	this.iface.tblMatrizBarcodes.setColumnLabels(sep, listaTallasBC);
		
	for (numT = 0; numT < col; numT++)
		this.iface.tblMatrizBarcodes.setColumnWidth(numT * 2 + 1, 45);		
		
	for (numC = 0; numC < this.iface.tblColores.numRows(); numC++) {
		
		if(!this.iface.tblColores.text(numC, 4))
			continue;
	
		if (this.iface.listaColores)
			this.iface.listaColores += sep;
			
		this.iface.listaColores += this.iface.tblColores.text(numC, 0);
	
		this.iface.tblMatrizPrecios.insertRows(fila, 1);
		this.iface.tblMatrizBarcodes.insertRows(fila, 1);
			
 		for (numT = 0; numT < col; numT++) {
 		
 			precio = parseFloat(preciosTallas[numT]);
 			incPor = parseFloat(this.iface.tblColores.text(numC, 2));
 			incLin = parseFloat(this.iface.tblColores.text(numC, 3));
 			
 			precio = precio + precio*incPor/100 + incLin;
 			this.iface.tblMatrizPrecios.setText(fila, numT, precio);
 			
 			barcode = this.iface.obtenerBarcode(referencia, codigosTallas[numT], this.iface.tblColores.text(numC, 0));
			if (!barcode) {
			    break;
			}
 			this.iface.tblMatrizBarcodes.setText(fila, numT * 2, barcode);
 			this.iface.tblMatrizBarcodes.setText(fila, numT * 2 + 1, "X");
 		}
		
		fila++;
	}
	
	if (!fila)
		return;

	this.iface.tblMatrizPrecios.setRowLabels(sep, this.iface.listaColores);
	this.iface.tblMatrizBarcodes.setRowLabels(sep, this.iface.listaColores);

	this.iface.tbwTC.showPage("precios");
	this.child("pbnGuardarTC").setDisabled(false);
}

function barCode_obtenerBarcode(referencia:String, codTalla:String, codColor:String):String
{
	var util:FLUtil = new FLUtil;
	var valor:String;
	if(!this.iface.calculoBarcode_ || this.iface.calculoBarcode_ == "") {
		if (flfactalma.iface.pub_valorDefectoAlmacen("calculobarcode") == "") {
		      MessageBox.information(util.translate("scripts", "Para calcular los cÃ³digos barcode debe establecer el tipo de cÃ¡lculo automÃ¡tico de barcode en \ndatos generales del mÃ³dulo de almacÃ©n"), MessageBox.Ok, MessageBox.NoButton);   
		      return;
		}
		this.iface.calculoBarcode_ = flfactalma.iface.pub_valorDefectoAlmacen("calculobarcode");
	}
	

	switch (this.iface.calculoBarcode_) {
		case "Referencia+Talla+Color": {
			valor = referencia + codTalla + codColor;
			break;
		}
		case "Autonumï¿?rico": {
			var numero:Number;
			var cadenaNumero:String;
			var filtroPrefijo:String = "";
			var longPrefijo:Number = 0;
			if (this.iface.prefijoBarcode_ != "") {
				filtroPrefijo = " AND barcode LIKE '" + this.iface.prefijoBarcode_ + "%'";
				longPrefijo = this.iface.prefijoBarcode_.length;
			}
			var longNumero:Number = this.iface.digitosBarcode_ - longPrefijo;
			
			if (this.iface.ultimoBarcode_) {
				cadenaNumero = this.iface.ultimoBarcode_;
			} else {
				cadenaNumero = util.sqlSelect("atributosarticulos", "barcode", "LENGTH(barcode) = " + this.iface.digitosBarcode_ + filtroPrefijo + " ORDER BY barcode DESC");
			}
			if (cadenaNumero && cadenaNumero != "") {
				cadenaNumero = cadenaNumero.right(longNumero);
				numero = parseFloat(cadenaNumero);
				if (isNaN(numero)) {
					return false;
				}
			} else {
				numero = 0;
			}
			numero++;
			valor = this.iface.prefijoBarcode_ + flfactppal.iface.pub_cerosIzquierda(numero, longNumero);
			this.iface.ultimoBarcode_ = valor;
			break;
		}
		case "Autonumï¿?rico EAN13":
		case "Autonumï¿?rico EAN14": {
			var numero:Number;
			var cadenaNumero:String;
			var filtroPrefijo:String = "";
			var longPrefijo:Number = 0;
			if (this.iface.prefijoBarcode_ != "") {
				filtroPrefijo = " AND barcode LIKE '" + this.iface.prefijoBarcode_ + "%'";
				longPrefijo = this.iface.prefijoBarcode_.length;
			}
			var longNumero:Number = this.iface.digitosBarcode_ - longPrefijo - 1;
			if (this.iface.ultimoBarcode_) {
				cadenaNumero = this.iface.ultimoBarcode_;
			} else {
				cadenaNumero = util.sqlSelect("atributosarticulos", "barcode", "LENGTH(barcode) = " + this.iface.digitosBarcode_ + filtroPrefijo + " ORDER BY barcode DESC");
			}
		debug("cadenaNumero " + cadenaNumero);
			if (cadenaNumero && cadenaNumero != "") {
				cadenaNumero = cadenaNumero.mid(longPrefijo, longNumero);
				numero = parseFloat(cadenaNumero);
		debug("numeroparse " + numero);
				if (isNaN(numero)) {
					return false;
				}
			} else {
				numero = 0;
			}
			numero++;
		debug("numero " + numero);

			valor = this.iface.prefijoBarcode_ + flfactppal.iface.pub_cerosIzquierda(numero, longNumero);
			var dc:String = this.iface.digitoControlEAN(valor)
			valor += dc;
debug("valor = " + valor);
			this.iface.ultimoBarcode_ = valor;
			break;
		}
	}
	return valor;
}

function barCode_digitoControlEAN(valorSinDC:String):String
{
	var pesos:Array;
	if (!valorSinDC || valorSinDC == "") {
		return false;
	}
debug("dc para " + valorSinDC);
	var longValorSinDC:Number = valorSinDC.length;
	switch (longValorSinDC) {
		case 12: { /// EAN 13
			pesos = [1,3,1,3,1,3,1,3,1,3,1,3];
			break;
		}
		case 13: { /// EAN 14
			pesos = [3,1,3,1,3,1,3,1,3,1,3,1,3];
			break;
		}
		default: {
			return false;
		}
	}
	var suma:Number = 0;
	for (var i:Number = 0; i < longValorSinDC; i++) {
		suma += parseInt(valorSinDC.charAt(i)) * parseInt(pesos[i]);
	}
debug("suma = " + suma);
	var decenaSuperior:Number = (Math.floor(suma / 10) + 1) * 10;
debug("decenaSuperior = " + decenaSuperior);
	var valor:Number = decenaSuperior - suma;
	if (valor == 10) {
		valor = 0;
	}
debug("valor = " + valor);
	return valor.toString();
}

function barCode_reloadMatrizPreciosTarifas()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	if (this.iface.tblMatrizPrecios.numRows()) {
		res = MessageBox.information(util.translate("scripts", "Si regenera los precios se eliminarï¿?n los cambios no guardados\n\nï¿?Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return;
	}

	var preciosTallas:Array = [];
	var codigosTallas:Array = [];
	
	var sep:String = "ï¿?";

	var fila:Number = 0;
	var col:Number = 0;
	
	var referencia:String = cursor.valueBuffer("referencia");
	var codTarifaTC:String = cursor.valueBuffer("codtarifatc");
	var incLinTarifa:Number = 0;
	var incPorTarifa:Number = 0;
	
	var datosTarifa:Array;
	if (codTarifaTC) {
		datosTarifa = flfactppal.iface.pub_ejecutarQry("tarifas", "nombre,inclineal,incporcentual", "codtarifa = '" + codTarifaTC + "'");
		if (datosTarifa.result > 0) {
			incLinTarifa = parseFloat(datosTarifa.inclineal);
			incPorTarifa = parseFloat(datosTarifa.incporcentual);
			this.child("leTarifaCargada").text = util.translate("scripts", "Tarifa cargada") + ":  " + codTarifaTC + " - " + datosTarifa.nombre;
		}
	}
	
	for (numT = 0; numT < this.iface.tblTallas.numRows(); numT++) {
	
		if(!this.iface.tblTallas.text(numT, 3))
			continue;
	
		if (this.iface.listaTallas)
			this.iface.listaTallas += sep;
			
		this.iface.listaTallas += this.iface.tblTallas.text(numT, 0);
		
		codigosTallas[col] = this.iface.tblTallas.text(numT, 0);
		preciosTallas[col] = this.iface.tblTallas.text(numT, 2);
		col++;
	}
	
	if (!col) {
		MessageBox.information(util.translate("scripts", "Debe seleccionar al menos una talla"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

		
	for (numC = 0; numC < this.iface.tblColores.numRows(); numC++) {
		
		if(!this.iface.tblColores.text(numC, 4))
			continue;
			
 		for (numT = 0; numT < col; numT++) {
 		
 			precio = parseFloat(preciosTallas[numT]);
 			incPor = parseFloat(this.iface.tblColores.text(numC, 2));
 			incLin = parseFloat(this.iface.tblColores.text(numC, 3));
 			precio = precio + precio*incPor/100 + incLin;
 			
			if (codTarifaTC)
	 			precio = precio + precio*incPorTarifa/100 + incLinTarifa;
 			
 			this.iface.tblMatrizPrecios.setText(fila, numT, precio);
 		}
		
		fila++;
	}
	
	if (!fila) {
		MessageBox.information(util.translate("scripts", "Debe seleccionar al menos un color"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.iface.tbwTC.showPage("precios");
 	this.child("pbnGuardarPreciosTarifas").setDisabled(false);
}

function barCode_clickedTalla(fil:Number, col:Number)
{
	if (col != 3)
		return;
		
	if (this.iface.tblTallas.text(fil, col))
		this.iface.tblTallas.setText(fil, col, "");
	else
		this.iface.tblTallas.setText(fil, col, "X");
		
	this.iface.datosModificados = true;
}

function barCode_clickedColor(fil:Number, col:Number)
{
	if (col != 4)
		return;
		
	if (this.iface.tblColores.text(fil, col))
		this.iface.tblColores.setText(fil, col, "");
	else
		this.iface.tblColores.setText(fil, col, "X");
		
	this.iface.datosModificados = true;
}

function barCode_clickedBC(fil:Number, col:Number)
{
	if (col % 2 == 0)
		return;
		
	if (this.iface.tblMatrizBarcodes.text(fil, col))
		this.iface.tblMatrizBarcodes.setText(fil, col, "");
	else
		this.iface.tblMatrizBarcodes.setText(fil, col, "X");
		
	this.iface.datosModificados = true;
}

function barCode_clickedPrecios(fil:Number, col:Number)
{
	this.iface.datosModificados = true;
}

function barCode_guardarTC()
{
	var cursor:FLSqlCursor = this.cursor();

	var referencia:String = this.cursor().valueBuffer("referencia");
	if (!referencia)
		return;
	
	var pvpBase:Number = this.cursor().valueBuffer("pvp");
	if (!pvpBase)
		pvpBase = 0;
	
	var util:FLUtil = new FLUtil();
	var sep:String = "ï¿?";
	var t:Number, c:Number;
	
	var barcode:String;
	var precio:Number;
		
	var tallas:Array = this.iface.listaTallas.split(sep);
	var colores:Array = this.iface.listaColores.split(sep);
	
	var curTab:FLSqlCursor = new FLSqlCursor("atributosarticulos");

	for (c = 0; c < colores.length; c++)
		for (t = 0; t < tallas.length; t++) {
			
			if(!this.iface.tblMatrizBarcodes.text(c, t * 2 + 1))
				continue;
				
			barcode = this.iface.tblMatrizBarcodes.text(c, t * 2);
			if (!barcode)
				continue;
			
			precio = this.iface.tblMatrizPrecios.text(c, t);
			
			curTab.select("barcode = '" + barcode + "'");
			if (curTab.first()) {
				curTab.setModeAccess(curTab.Edit);
				curTab.refreshBuffer();
			}
			else {
				curTab.setModeAccess(curTab.Insert);
				curTab.refreshBuffer();
				curTab.setValueBuffer("referencia", referencia);
				curTab.setValueBuffer("barcode", barcode);
				curTab.setValueBuffer("talla", tallas[t]);
				curTab.setValueBuffer("color", colores[c]);
			}
			
			if (precio != pvpBase) {
				curTab.setValueBuffer("pvpespecial", true);
				curTab.setValueBuffer("pvp", precio);
			}
			else {
				curTab.setValueBuffer("pvpespecial", false);
				curTab.setNull("pvp");
			}
				
			curTab.commitBuffer();
		}

	var curTabC:FLSqlCursor = new FLSqlCursor("tallasarticulo");
	for (c = 0; c < this.iface.tblTallas.numRows(); c++) {
		curTabC.select("referencia = '" + referencia + "' AND codtalla = '" + this.iface.tblTallas.text(c, 0) + "'");
		if (curTabC.first()) {
			curTabC.setModeAccess(curTabC.Edit);
			curTabC.refreshBuffer();
		}
		else {
			curTabC.setModeAccess(curTabC.Insert);
			curTabC.refreshBuffer();
			curTabC.setValueBuffer("referencia", referencia);
			curTabC.setValueBuffer("codtalla", this.iface.tblTallas.text(c, 0));
		}
		curTabC.setValueBuffer("destalla", this.iface.tblTallas.text(c, 1));
		curTabC.setValueBuffer("pvp", this.iface.tblTallas.text(c, 2));
		if (this.iface.tblTallas.text(c, 3))
			curTabC.setValueBuffer("activo", true);
		else
			curTabC.setValueBuffer("activo", false);
			
		curTabC.commitBuffer();
	}
	
	
	var curTabC:FLSqlCursor = new FLSqlCursor("coloresarticulo");
	for (c = 0; c < this.iface.tblColores.numRows(); c++) {
		curTabC.select("referencia = '" + referencia + "' AND codcolor = '" + this.iface.tblColores.text(c, 0) + "'");
		if (curTabC.first()) {
			curTabC.setModeAccess(curTabC.Edit);
			curTabC.refreshBuffer();
		}
		else {
			curTabC.setModeAccess(curTabC.Insert);
			curTabC.refreshBuffer();
			curTabC.setValueBuffer("referencia", referencia);
			curTabC.setValueBuffer("codcolor", this.iface.tblColores.text(c, 0));
		}
		curTabC.setValueBuffer("descolor", this.iface.tblColores.text(c, 1));
		curTabC.setValueBuffer("incporcentual", this.iface.tblColores.text(c, 2));
		curTabC.setValueBuffer("inclineal", this.iface.tblColores.text(c, 3));
		if (this.iface.tblColores.text(c, 4))
			curTabC.setValueBuffer("activo", true);
		else
			curTabC.setValueBuffer("activo", false);
			
		curTabC.commitBuffer();
	}
	
	this.iface.datosModificados = false;
	
	this.iface.tbwTC.showPage("barcodes");
	this.child("tdbAtributosArticulos").refresh();
	this.child("tdbColoresArticulo").refresh();
}


function barCode_guardarPreciosTarifas()
{
	var cursor:FLSqlCursor = this.cursor();

	var referencia:String = this.cursor().valueBuffer("referencia");
	if (!referencia)
		return;
	
	var codTarifaTC:String = cursor.valueBuffer("codtarifatc");
	if (!codTarifaTC)
		return;
	
	var util:FLUtil = new FLUtil();
	
	res = MessageBox.information(util.translate("scripts", "A continuaciï¿?n se actualizarï¿?n todos los precios para la tarifa %0\n\nï¿?Continuar?").arg(codTarifaTC), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	var sep:String = "ï¿?";
	var t:Number, c:Number;
	
	var barcode:String;
	var precio:Number;
		
	var tallas:Array = this.iface.listaTallas.split(sep);
	var colores:Array = this.iface.listaColores.split(sep);
	
	var curTab:FLSqlCursor = new FLSqlCursor("atributostarifas");

	for (c = 0; c < colores.length; c++)
		for (t = 0; t < tallas.length; t++) {
			
			if(!this.iface.tblMatrizBarcodes.text(c, t * 2 + 1))
				continue;
				
			barcode = this.iface.tblMatrizBarcodes.text(c, t * 2);
			if (!barcode)
				continue;
			
			precio = this.iface.tblMatrizPrecios.text(c, t);
			
			curTab.select("barcode = '" + barcode + "' and codtarifa = '" + codTarifaTC + "'");
			if (curTab.first()) {
				curTab.setModeAccess(curTab.Edit);
				curTab.refreshBuffer();
			}
			else {
				curTab.setModeAccess(curTab.Insert);
				curTab.refreshBuffer();
				curTab.setValueBuffer("barcode", barcode);
				curTab.setValueBuffer("codtarifa", codTarifaTC);
			}
			
			curTab.setValueBuffer("pvp", precio);
			curTab.commitBuffer();
		}
	
	this.iface.tbwTC.showPage("barcodes");
	this.child("tdbAtributosArticulos").refresh();
}

function barCode_validateForm():Boolean 
{
	var util:FLUtil = new FLUtil();
	
	if (!this.iface.__validateForm())
		return false;
		
	if (this.iface.datosModificados) {
		var res = MessageBox.warning(util.translate("scripts", "Algunos valores de tallas, colores o precios han sido modificados.\nLos cambios aï¿?n no se guardaron como barcodes.\n\nï¿?Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return false;
	}
		
	return true;
}

/** \D Imprime las etiquetas correspondientes a todas las líneas del albarán seleccionado
\end */
//Función de etiBarcode
function barCode_imprimirEtiquetas()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curBarcode:FLSqlCursor = this.child("tdbAtributosArticulos").cursor();
	var barcode:String = curBarcode.valueBuffer("barcode");
	if (!barcode) {
		return false;
	}

	var cantidad:Number = Input.getNumber(util.translate("scripts", "Nº etiquetas"), 1, 0, 1, 100000, util.translate("scripts", "Imprimir etiquetas"));
	if (!cantidad) {
		return false;
	}

	var descripcion:String = cursor.valueBuffer("descripcion");
	var talla:String = curBarcode.valueBuffer("talla");
	if (talla && talla != "") {
		descripcion += ", " + talla;
	}
	var color:String = curBarcode.valueBuffer("color");
	if (color && color != "") {
		descripcion += ", " + color;
	}
	
	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var eRow:FLDomElement;
	for (var i:Number = 0; i < cantidad; i++) {
		eRow = xmlKD.createElement("Row");
		eRow.setAttribute("barcode", curBarcode.valueBuffer("barcode"));
		eRow.setAttribute("referencia", curBarcode.valueBuffer("barcode"));
		eRow.setAttribute("descripcion", descripcion);
		if (curBarcode.valueBuffer("pvpespecial")) {
			eRow.setAttribute("pvp", curBarcode.valueBuffer("pvp"));
		} else {
			eRow.setAttribute("pvp", cursor.valueBuffer("pvp"));
		}
		eRow.setAttribute("level", 0);
		xmlKD.firstChild().appendChild(eRow);
	}

	if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
		return false;
	}
}

//Función de tpvTallColBar
function barCode_refrescarStock()
{
	var cursor:FLSqlCursor = this.cursor();
	if (!this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, cursor))
		return false;

}	

//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

