
/** @class_declaration numSerie */
/////////////////////////////////////////////////////////////////
//// NÚMEROS DE SERIE ///////////////////////////////////////////
class numSerie extends oficial {
    function numSerie( context ) { oficial ( context ); }
	function datosLineaVenta():Boolean {
		return this.ctx.numSerie_datosLineaVenta();
	}
	function calculateField(fN:String):String {
		return this.ctx.numSerie_calculateField(fN);
	}
}
//// NÚMEROS DE SERIE ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ivaBarcode */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
class ivaBarcode extends numSerie {
	function ivaBarcode( context ) { numSerie( context ); }
	function datosLineaVenta() {
		return this.ctx.ivaBarcode_datosLineaVenta();
	}
	function bufferChanged(fN:String) {
		return this.ctx.ivaBarcode_bufferChanged(fN);
	}
	function calculateField(fN:String):String {
		return this.ctx.ivaBarcode_calculateField(fN);
	}
	function descontar(idLinea:Number, descuentoLineal:Number, porDescuento:Number):Boolean {
		return this.ctx.ivaBarcode_descontar(idLinea, descuentoLineal, porDescuento);
	}
	function aplicarTarifaLinea(codTarifa:String):Boolean {
		return this.ctx.ivaBarcode_aplicarTarifaLinea(codTarifa);
	}
}
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration tpvTallCol */
/////////////////////////////////////////////////////////////////
//// TPVTALLCOL /////////////////////////////////////////////////
class tpvTallCol extends ivaBarcode {
	var tipoBarcode_:String;
	var referencia_:String;
	var introReferencia_:Number;
    function tpvTallCol( context ) { ivaBarcode ( context ); }
	function init() {
		return this.ctx.tpvTallCol_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.tpvTallCol_bufferChanged(fN);
	}
	function calculateField(fN:String):String {
		return this.ctx.tpvTallCol_calculateField(fN);
	}
	function datosLineaVenta():Boolean {
		return this.ctx.tpvTallCol_datosLineaVenta();
	}
	function insertarLineaClicked() {
		return this.ctx.tpvTallCol_insertarLineaClicked();
	}
	function buscarArticuloClicked() {
		return this.ctx.tpvTallCol_buscarArticuloClicked();
	}
	function datosVisorArt(curLineas:FLSqlCursor) {
		return this.ctx.tpvTallCol_datosVisorArt(curLineas);
	}
	function fdbReferencia_lostFocus() {
		return this.ctx.tpvTallCol_fdbReferencia_lostFocus();
	}
	function cursorAPosicionInicial() {
		return this.ctx.tpvTallCol_cursorAPosicionInicial();
	}
	function fdbReferencia_returnPressed() {
		return this.ctx.tpvTallCol_fdbReferencia_returnPressed();
	}
	function conectarInsercionRapida():Boolean {
		return this.ctx.tpvTallCol_conectarInsercionRapida()
	}
}
//// TPVTALLCOL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numSerie */
/////////////////////////////////////////////////////////////////
//// NÚMEROS DE SERIE////////////////////////////////////////////
/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida. Si lo que se inserta como referencia es un número de serie, se comprueba que el número no esté vendido y se ajusta la línea de venta con el dato
\end */
function numSerie_datosLineaVenta():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var qryNumSerie:FLSqlQuery = new FLSqlQuery();
	with (qryNumSerie) {
		setTablesList("numerosserie,articulos");
		setSelect("ns.numserie, ns.referencia, ns.idfacturaventa, ns.vendido, a.descripcion, a.pvp");
		setFrom("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia");
		setWhere("ns.numserie = '" + cursor.valueBuffer("referencia") + "'")
		setForwardOnly(true);
	}
	if (!qryNumSerie.exec())
		return false;

	if (!qryNumSerie.first())
		return this.iface.__datosLineaVenta();

	if (qryNumSerie.value("ns.vendido")) {
		MessageBox.warning(util.translate("scripts", "Este número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	if (util.sqlSelect("tpv_lineascomanda", "idtpv_linea", "numserie = '" + qryNumSerie.value("ns.numserie") + "'")) {
		MessageBox.warning(util.translate("scripts", "Este número de serie ya está incluido en la venta actual"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	if (parseFloat(this.iface.txtCanArticulo.text) != 1) {
		MessageBox.warning(util.translate("scripts", "Si establece un número de serie la cantidad debe ser siempre 1"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	this.iface.__datosLineaVenta();
	this.iface.curLineas.setValueBuffer("referencia", qryNumSerie.value("ns.referencia"));
	this.iface.curLineas.setValueBuffer("numserie", qryNumSerie.value("ns.numserie"));

	return true;
}

/** \D Los datos del artículo se buscan primero suponiendo que la referencia es un número de serie. Si no se encuantran se buscan de la forma normal
\end */
function numSerie_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "desarticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.descripcion", "ns.numserie = '" + cursor.valueBuffer("referencia") + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			if (!valor)
				valor = "";
			break;
		}
		case "pvparticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.pvp", "ns.numserie = '" + cursor.valueBuffer("referencia") + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			break;
		}
		case "ivaarticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.codimpuesto", "ns.numserie = '" + cursor.valueBuffer("referencia") + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
debug(valor);
	return valor;
}
//// NÚMEROS DE SERIE////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaBarcode */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
function ivaBarcode_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		/** \C
		Al cambiar el --barcode-- se calcula su descripción, talla, color y precio unitario, y se almacena su impuesto asociado
		*/
		case "barcode": {
			this.iface.txtDesArticulo.text = this.iface.calculateField("desarticulo");
			this.iface.txtPvpArticulo.text = this.iface.calculateField("pvparticulo");
			this.iface.ivaArticulo = this.iface.calculateField("ivaarticulo");
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}

function ivaBarcode_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "desarticulo": {
			var qryArticulo = new FLSqlQuery;
			qryArticulo.setTablesList("articulos,atributosarticulos");
			qryArticulo.setSelect("a.descripcion, aa.talla, aa.color");
			qryArticulo.setFrom("atributosarticulos aa INNER JOIN articulos a ON aa.referencia = a.referencia");
			qryArticulo.setWhere("aa.barcode = '" + cursor.valueBuffer("barcode") + "'");
			if (!qryArticulo.exec()) {
				valor = "";
				break;
			}
			if (!qryArticulo.first()) {
				valor = "";
				break;
			}
			valor = qryArticulo.value("a.descripcion") + "-" + qryArticulo.value("aa.talla") + "-" + qryArticulo.value("aa.color");
			break;
		}
		case "pvparticulo": {
			var qryBarcode:FLSqlQuery = new FLSqlQuery();
			with (qryBarcode) {
				setTablesList("atributosarticulos");
				setSelect("pvp");
				setFrom("atributosarticulos");
				setWhere("pvpespecial = true AND barcode = '" + cursor.valueBuffer("barcode") + "'");
				setForwardOnly(true);
			}
			if (!qryBarcode.exec())
				return false;

			if (!qryBarcode.first()) {
				var referencia:String = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
				if (!referencia || referencia == "") {
					valor = 0;
				} else {
					valor = formRecordtpv_lineascomanda.iface.calcularPvpTarifa(referencia, cursor.valueBuffer("codtarifa"));
				}
// 				valor = util.sqlSelect("atributosarticulos aa INNER JOIN articulos a ON aa.referencia = a.referencia", "a.pvp", "aa.barcode = '" + cursor.valueBuffer("barcode") + "'", "articulos,atributosarticulos");
				if (!valor) {
					valor = "0";
				}
			} else {
				valor = qryBarcode.value("pvp");
			}
			valor = util.roundFieldValue(valor, "articulos", "pvp");
			break;
		}
		case "ivaarticulo": {
			valor = util.sqlSelect("atributosarticulos aa INNER JOIN articulos a ON aa.referencia = a.referencia", "a.codimpuesto", "aa.barcode = '" + cursor.valueBuffer("barcode") + "'", "articulos,atributosarticulos");
			if (!valor)
				valor = "";
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}

/** \D
Aplica un descuento a la linea, teniendo en cuenta el IVA incluido
*/
function ivaBarcode_descontar(idLinea:Number,descuentoLineal:Number,porDescuento:Number):Boolean
{
	if (!idLinea)
		return false;
	var util:FLUtil = new FLUtil;

	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_linea = " + idLinea);
	curLinea.first();
	curLinea.setModeAccess(curLinea.Edit);
	curLinea.refreshBuffer();
	var valor:Number;
	if (curLinea.valueBuffer("ivaincluido"))
		valor = parseFloat(descuentoLineal) * 100 / (100 + parseFloat(curLinea.valueBuffer("iva")));
	else
		valor = descuentoLineal;
	valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");

	curLinea.setValueBuffer("dtolineal", valor);
	curLinea.setValueBuffer("dtopor", porDescuento);
	curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea));
	if (!curLinea.commitBuffer())
		return false;
	this.iface.calcularTotales();
	return true;
}

/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida
\end */
function ivaBarcode_datosLineaVenta():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	this.iface.curLineas.setValueBuffer("cantidad", util.roundFieldValue(this.iface.txtCanArticulo.text, "tpv_lineascomanda", "cantidad"));
	this.iface.curLineas.setValueBuffer("barcode", cursor.valueBuffer("barcode"));
	this.iface.curLineas.setValueBuffer("referencia", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("referencia", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("talla", util.sqlSelect("atributosarticulos", "talla", "barcode = '" + cursor.valueBuffer("barcode") + "'"));
	this.iface.curLineas.setValueBuffer("color", util.sqlSelect("atributosarticulos", "color", "barcode = '" + cursor.valueBuffer("barcode") + "'"));
	this.iface.curLineas.setValueBuffer("descripcion", this.iface.txtDesArticulo.text);
	this.iface.curLineas.setValueBuffer("ivaincluido", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpunitarioiva", util.roundFieldValue(this.iface.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitarioiva"));
	this.iface.curLineas.setValueBuffer("codimpuesto", this.iface.ivaArticulo);
	this.iface.curLineas.setValueBuffer("iva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("iva", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
	return true;
}

function ivaBarcode_aplicarTarifaLinea(codTarifa:String):Boolean
{
	this.iface.curLineas.setValueBuffer("ivaincluido", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva", this.iface.curLineas)); this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpsindto",
	formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal",
	formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
	return true;
}
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition tpvTallCol */
/////////////////////////////////////////////////////////////////
//// TPVTALLCOL /////////////////////////////////////////////////
function tpvTallCol_init()
{
	this.iface.__init();
	var fdbReferencia:Object = this.child("fdbReferencia");
	connect(fdbReferencia.editor(), "lostFocus()", this, "iface.fdbReferencia_lostFocus()");
	connect(this.child("tbnBuscar"), "clicked()", this, "iface.buscarArticuloClicked()");
	if (this.child("fdbCodBarras")) {
		this.child("fdbCodBarras").close();
	}
}

function tpvTallCol_cursorAPosicionInicial()
{
	var posInicial:String = this.iface.config_["ircursorinicio"];
	switch (posInicial) {
		case "Cod.Barras":
		case "Referencia": {
			this.child("fdbReferencia").setFocus();
			break;
		}
		case "Cantidad": {
			this.child("txtCanArticulo").setFocus();
			break;
		}
	}
}

/// Probar cuando funcione la conexión y quitar tpvTallCol_insertarLineaClicked()
function tpvTallCol_fdbReferencia_returnPressed()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	this.iface.bufferChanged("barcodeLinea");

	if (this.iface.config_["irultrarrapida"]) {
		this.iface.insertarLineaClicked();
	} else {
		this.child("txtDesArticulo").setFocus();
	}
}

function tpvTallCol_fdbReferencia_lostFocus()
{
debug("lostfoc");
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var barcode:String = cursor.valueBuffer("barcode");
debug("barcode "  + barcode);
	if (!barcode || barcode == "") {
		this.iface.txtDesArticulo.text = util.translate("scripts", "VARIOS");
	}
}

function tpvTallCol_buscarArticuloClicked()
{
	var util:FLUtil = new FLUtil;
	var valor:String = "";

	var f:Object = new FLFormSearchDB("articulos");//tpv_buscarreferencia");
	f.setMainWidget();
	valor = f.exec("referencia");
	if(!valor)
		return;

	if (util.sqlSelect("atributosarticulos","barcode","referencia = '" + valor + "'")) {
		delete f;
		f = new FLFormSearchDB("tpv_buscarbarcode");
		f.setMainWidget();
		f.cursor().setMainFilter("referencia = '" + valor + "'");
		valor = f.exec("barcode");

		if(!valor)
			return;
	}
	else
		valor = util.sqlSelect("articulos","codbarras","referencia = '" + valor + "'");

	this.child("fdbReferencia").setValue(valor);
	this.iface.bufferChanged("barcodeLinea");
}

function tpvTallCol_insertarLineaClicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var barcode:String = cursor.valueBuffer("barcode");
	if (barcode && barcode != "") {
		this.iface.bufferChanged("barcodeLinea");
	} else {
		this.iface.tipoBarcode_ = "referencia";
		this.iface.referencia_ = "";
	}

	this.iface.__insertarLineaClicked()
}

function tpvTallCol_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "barcode": {
			return;
		}
		case "barcodeLinea": {
			/// Esto se hace para evitar que el lector de código de barras dé lecturas erróneas al lanzarse contínuamente el bufferChanged
			var barcode:String = cursor.valueBuffer("barcode");
			this.iface.tipoBarcode_ = false;
			this.iface.referencia_ = false;
			if (barcode && barcode != "") {
				this.iface.referencia_ = util.sqlSelect("articulos", "referencia", "codbarras = '" + barcode + "'");
				if (this.iface.referencia_) {
					this.iface.tipoBarcode_ = "articulo";
				} else {
					this.iface.referencia_ = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + barcode + "'");
					if (this.iface.referencia_)
						this.iface.tipoBarcode_ = "barcode";
				}
			}
			this.iface.__bufferChanged("barcode");
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}

function tpvTallCol_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "desarticulo": {
			valor = util.sqlSelect("articulos", "descripcion", "referencia = '" + this.iface.referencia_ + "'");
			if (!valor)
				valor = "";
			break;
		}
		case "pvparticulo": {
			valor = formRecordtpv_lineascomanda.iface.calcularPvpTarifa(this.iface.referencia_, cursor.valueBuffer("codtarifa"));
			if (!valor)
				valor = "0";
			valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");
			break;
		}
		case "ivaarticulo": {
			valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + this.iface.referencia_ + "'");
			if (!valor)
				valor = "";
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
			break;
		}
	}
	return valor;
}

/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida
\end */
function tpvTallCol_datosLineaVenta():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	this.iface.curLineas.setValueBuffer("cantidad", util.roundFieldValue(this.iface.txtCanArticulo.text, "tpv_lineascomanda", "cantidad"));
	this.iface.curLineas.setValueBuffer("referencia", this.iface.referencia_);
	if (this.iface.tipoBarcode_ == "barcode") {
		this.iface.curLineas.setValueBuffer("barcode", cursor.valueBuffer("barcode"));
		this.iface.curLineas.setValueBuffer("talla", util.sqlSelect("atributosarticulos", "talla", "barcode = '" + cursor.valueBuffer("barcode") + "'"));
		this.iface.curLineas.setValueBuffer("color", util.sqlSelect("atributosarticulos", "color", "barcode = '" + cursor.valueBuffer("barcode") + "'"));
	}
	this.iface.curLineas.setValueBuffer("descripcion", this.iface.txtDesArticulo.text);
	this.iface.curLineas.setValueBuffer("ivaincluido", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpunitarioiva", util.roundFieldValue(this.iface.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitarioiva"));
	this.iface.curLineas.setValueBuffer("codimpuesto", this.iface.ivaArticulo);
	this.iface.curLineas.setValueBuffer("iva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("iva", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
	return true;
}

function tpvTallCol_datosVisorArt(curLineas:FLSqlCursor)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var codPuntoVenta:String = cursor.valueBuffer("codtpv_puntoventa");

	var datos:Array = [];

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("atributosarticulos");
	qry.setSelect("referencia, talla, color");
	qry.setFrom("atributosarticulos");
	qry.setWhere("barcode = '" + cursor.valueBuffer("barcode") + "'");
	if (!qry.exec())
		return;
	if (qry.first()) {
		var numDatos:Number = 0;
		datos[numDatos] = qry.value("referencia");
		numDatos ++;
		if(qry.value("talla") && qry.value("talla") != "") {
			var talla:String = util.sqlSelect("tallas", "descripcion", "codtalla = '" + qry.value("talla") + "'");
			datos[numDatos] = talla;
			numDatos ++;
		}
		if(qry.value("color") && qry.value("color") != "") {
			var color:String = util.sqlSelect("colores", "descripcion", "codcolor = '" + qry.value("color") + "'");
			datos[numDatos] = color;
			numDatos++;
		}
	} else {
		var ref:String = util.sqlSelect("articulos", "referencia", "codbarras = '" + cursor.valueBuffer("barcode") + "'");
		if (!ref) {
			ref = "";
		}
		datos[0] = ref;
		var des:String;
		if (ref != "") {
			des = util.sqlSelect("articulos", "descripcion", "referencia = '" + ref + "'");
		} else {
			des = this.iface.txtDesArticulo.text;
		}
		datos[1] = des;
	}

	var otrosDatos:Array = [];
	otrosDatos[0] = "PVP";

	var precio:Number = util.roundFieldValue(this.child("txtPvpArticulo").text, "tpv_comandas", "total");
	if (!precio || precio == "")
		precio = 0;
	otrosDatos[1] = precio;

	var linea1:String = this.iface.formatearLineaVisor(codPuntoVenta, 1, datos, "CONCAT");
	var linea2:String = this.iface.formatearLineaVisor(codPuntoVenta, 2, otrosDatos, "SEPARAR");
	var datosVisor:Array = [];
	datosVisor[0] = linea1;
	datosVisor[1] = linea2;
	this.iface.escribirEnVisor(codPuntoVenta, datosVisor);
}

function tpvTallCol_conectarInsercionRapida():Boolean
{
	try {
	connect(this.child("fdbReferencia"), "keyReturnPressed()", this, "iface.fdbReferencia_returnPressed");
	} catch (e) {
		var fdbReferencia:Object = this.child("fdbReferencia");
		this.iface.introReferencia_ = fdbReferencia.insertAccel("Return");
		this.iface.introReferencia_ = fdbReferencia.insertAccel("Enter");
		connect(fdbReferencia, "activatedAccel(int)", this, "iface.insertarLineaClicked()");
	}
	return true;
}
//// TPVTALLCOL ////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

