
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial {
    function barCode( context ) { oficial ( context ); }
// 	function controlStockPedidosCli(curLP:FLSqlCursor):Boolean {
// 		return this.ctx.barCode_controlStockPedidosCli(curLP);
// 	}
// 	function controlStockPedidosProv(curLP:FLSqlCursor):Boolean {
// 		return this.ctx.barCode_controlStockPedidosProv(curLP);
// 	}
	//Funciones de etiArticulo
	function lanzarEtiArticulo(xmlKD:FLDomDocument) {
		return this.ctx.barCode_lanzarEtiArticulo(xmlKD);
	}
	function tipoInformeEtiquetas() {
		return this.ctx.barCode_tipoInformeEtiquetas();
	}
	//////////////////////////////////////////////
	function controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
		return this.ctx.barCode_controlStockAlbaranesCli(curLA);
	}
	function controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
		return this.ctx.barCode_controlStockAlbaranesProv(curLA);
	}
	function controlStockFacturasCli(curLF:FLSqlCursor):Boolean {
		return this.ctx.barCode_controlStockFacturasCli(curLF);
	}
	function controlStockFacturasProv(curLF:FLSqlCursor):Boolean {
		return this.ctx.barCode_controlStockFacturasProv(curLF);
	}
	function controlStock(curLinea:FLSqlCursor, campo:String, signo:Number, codAlmacen:String):Boolean {
		return this.ctx.barCode_controlStock(curLinea, campo, signo, codAlmacen);
	}
	function cambiarStock(codAlmacen:String, barCode:String, referencia:String, variacion:Number, campo:String):Boolean {
		return this.ctx.barCode_cambiarStock(codAlmacen, barCode, referencia, variacion, campo);
	}
	function crearStock(codAlmacen:String, barCode:String, referencia:String):Number {
		return this.ctx.barCode_crearStock(codAlmacen, barCode, referencia);
	}
	function crearStockBarcode(codAlmacen:String, barCode:String, referencia:String):Number {
		return this.ctx.barCode_crearStockBarcode(codAlmacen, barCode, referencia);
	}
	function crearBarcode(referencia:String, datos:Array):Boolean {
		return this.ctx.barCode_crearBarcode(referencia, datos);
	}
	function pedirColor(referencia:String):Boolean {
		return this.ctx.barCode_pedirColor(referencia);
	}
	function construirBarcode(referencia:Sring, codTalla:String, codColor:String):String {
		return this.ctx.barCode_construirBarcode(referencia, codTalla, codColor);
	}
	function controlStockLineasTrans(curLTS:FLSqlCursor):Boolean {
		return this.ctx.barCode_controlStockLineasTrans(curLTS);
	}
	function controlStockReservado(curLinea:FLSqlCursor, codAlmacen:String):Boolean {
		return this.ctx.barCode_controlStockReservado(curLinea, codAlmacen);
	}
	function actualizarStockReservado(referencia:String, barcode:String, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.barCode_actualizarStockReservado(referencia, barcode, codAlmacen, idPedido);
	}
	function controlStockPteRecibir(curLinea:FLSqlCursor, codAlmacen:String):Boolean {
		return this.ctx.barCode_controlStockPteRecibir(curLinea, codAlmacen);
	}
	function actualizarStockPteRecibir(referencia:String, barcode:String, codAlmacen:String, idPedido:String):Boolean {
		return this.ctx.barCode_actualizarStockPteRecibir(referencia, barcode, codAlmacen, idPedido);
	}
	//Funciones de barcodeTPV
	function controlStockValesTPV(curLinea:FLSqlCursor):Boolean {
		return this.ctx.barCode_controlStockValesTPV(curLinea);
	}
	function controlStockComandasCli(curLV:FLSqlCursor):Boolean {
		return this.ctx.barCode_controlStockComandasCli(curLV);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_declaration pubBarCode */
/////////////////////////////////////////////////////////////////
//// PUB TALLAS Y COLORES POR BARCODE ///////////////////////////
class pubBarCode extends ifaceCtx {
	function pubBarCode( context ) { ifaceCtx( context ); }
	function pub_controlStockPedidosProv(curLP:FLSqlCursor):Boolean {
		return this.controlStockPedidosProv(curLP);
	}
	function pub_crearStock(codAlmacen:String, barCode:String, referencia:String):Number {
		return this.crearStock(codAlmacen, barCode, referencia);
	}
	function pub_crearStockBarcode(codAlmacen:String, barCode:String, referencia:String):Number {
		return this.crearStockBarcode(codAlmacen, barCode, referencia);
	}
	function pub_crearBarcode(referencia:String, datos:Array):Boolean {
		return this.crearBarcode(referencia, datos);
	}
	function pub_pedirColor(referencia:String):Boolean {
		return this.pedirColor(referencia);
	}
	function pub_construirBarcode(referencia:Sring, codTalla:String, codColor:String):String {
		return this.construirBarcode(referencia, codTalla, codColor);
	}
	//Funcion de pubEtiArticulo
	function pub_lanzarEtiArticulo(xmlKD) {
		return this.lanzarEtiArticulo(xmlKD);
	}
}
//// PUB TALLAS Y COLORES POR BARCODE ///////////////////////////
/////////////////////////////////////////////////////////////////
/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////

/** Funciones de etiArticulo -------------------------------------------------------------------------------------------- */
/** \D Lanza el informe de etiquetas de artículos.
\end */
function barCode_lanzarEtiArticulo(xmlKD:FLDomDocument)
{
debug(xmlKD.toString(4));
	var rptViewer:FLReportViewer = new FLReportViewer();

	var datosReport:Array = this.iface.tipoInformeEtiquetas();
	try {
		rptViewer.setReportData(xmlKD);
	} catch (e) {
		return;
	}

	var etiquetaInicial:Array;
	if (datosReport["cols"] > 0) {
		etiquetaInicial = flfactinfo.iface.seleccionEtiquetaInicial();
	}

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(datosReport["nombreinforme"]);
	rptViewer.setReportData(xmlKD);
	if (datosReport["cols"] > 0) {
		rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
	} else {
		rptViewer.renderReport();
	}
	rptViewer.exec();
}

function barCode_tipoInformeEtiquetas()
{
	var res:Array = [];
	res["nombreinforme"] = "i_a4_4x11";
	res["cols"] = 4;
	return res;
}
/** ----------------------------------------------------------------------*/


/** \D Incrementa o decrementa el stock en función de la variación experimentada por una línea de documento de facturación
@param	curLinea: Cursor posicionado en la línea de documento de facturación
@param	campo: Campo a modificar
@param	operación: Indica si la cantidad debe sumarse o restarse del stock
@param	codAlmacen: Código del almacén asociado al stock a modificar
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStock(curLinea:FLSqlCursor, campo:String, signo:Number, codAlmacen:String):Boolean
{
	var variacion:Number;
	var cantidad:Number = parseFloat(curLinea.valueBuffer("cantidad"));
	var cantidadPrevia:Number = parseFloat(curLinea.valueBufferCopy("cantidad"));
	if (curLinea.table() == "lineaspedidoscli" || curLinea.table() == "lineaspedidosprov") {
		cantidad -= parseFloat(curLinea.valueBuffer("totalenalbaran"));
		cantidadPrevia -= parseFloat(curLinea.valueBufferCopy("totalenalbaran"));
	}
	switch(curLinea.modeAccess()) {
		case curLinea.Insert: {
			variacion = signo * cantidad;
			if (!this.iface.cambiarStock(codAlmacen, curLinea.valueBuffer("barcode"), curLinea.valueBuffer("referencia"), variacion, campo))
				return false;
			break;
		}
		case curLinea.Del: {
			variacion = signo * -1 * cantidad;
			if (!this.iface.cambiarStock(codAlmacen, curLinea.valueBuffer("barcode"), curLinea.valueBuffer("referencia"), variacion, campo))
				return false;
			break;
		}
		case curLinea.Edit: {
			if (curLinea.valueBuffer("referencia") != curLinea.valueBufferCopy("referencia") || curLinea.valueBuffer("barcode") != curLinea.valueBufferCopy("barcode") || cantidad != cantidadPrevia) {
				variacion = signo * -1 * cantidadPrevia;
				if (!this.iface.cambiarStock(codAlmacen, curLinea.valueBufferCopy("barcode"), curLinea.valueBufferCopy("referencia"), variacion, campo))
					return false;
				variacion = signo * cantidad;
				if (!this.iface.cambiarStock(codAlmacen, curLinea.valueBuffer("barcode"), curLinea.valueBuffer("referencia"), variacion, campo))
					return false;
			}
			break;
		}
	}
	return true;
}

/** \D Cambia un campo del stock según la variación especificada
@param	codAlmacen: Código del almacén asociado al stock 
@param	barCode: Bar code asociado al stock 
@param	referencia: Referencia asociada al stock 
@param	variacion: Variación a aplicar
@param	campo: Nombre del campo a modificar
@return	identificador del stock creado si la inserción es correcta, false en caso contrario
*/
function barCode_cambiarStock(codAlmacen:String, barCode:String, referencia:String, variacion:Number, campo:String)
{
	var util:FLUtil = new FLUtil;
	var idStock:String;
	if (!referencia || referencia == "")
		return true;
	
	if (!barCode || barCode == "") 
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND (barcode IS NULL OR barcode = '') AND codalmacen = '" + codAlmacen + "'");
	else
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND barcode = '" + barCode + "' AND codalmacen = '" + codAlmacen + "'");
	if (!idStock) {
		idStock = this.iface.crearStock(codAlmacen, barCode, referencia);
		if (!idStock)
			return false;
	}
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first())
		return false;
	
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	
	var cantidadPrevia:Number = parseFloat(curStock.valueBuffer(campo));
	var nuevaCantidad:Number = cantidadPrevia + parseFloat(variacion);
	if (nuevaCantidad < 0 && campo == "cantidad") {
		if (!util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'")) {
			MessageBox.warning(util.translate("scripts", "No hay suficiente stock en el almacén %1 para el artículo %2 - barcode %3.\nLa operación no puede realizarse").arg(codAlmacen).arg(referencia).arg(barCode), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	
	curStock.setValueBuffer(campo, nuevaCantidad);

	if (campo == "cantidad" || campo == "reservada") {
		curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	}
debug("CS ");
	try  {
		if (!curStock.commitBuffer(true)) {
		  return false;
		}
	} catch (e) {
		if (!curStock.commitBuffer()) {
			return false;
		}
	}
	return true;
}
	
/** \D Crea una línea de stock
@param	codAlmacen: Código del almacén asociado al stock 
@param	barCode: Bar code asociado al stock 
@param	referencia: Referencia asociada al stock 
@return	identificador del stock creado si la inserción es correcta, false en caso contrario
*/
function barCode_crearStock(codAlmacen:String, barCode:String, referencia:String):Number
{
	var util:FLUtil = new FLUtil;
	var nombreAlmacen:String = util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'");
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	with (curStock) {
		setModeAccess(curStock.Insert);
		refreshBuffer();
		setValueBuffer("referencia", referencia);
		setValueBuffer("codalmacen", codAlmacen);
		if (!barCode || barCode == "")
			setNull("barcode");
		else
			setValueBuffer("barcode", barCode);
		setValueBuffer("nombre", nombreAlmacen);
		setValueBuffer("cantidad", 0);
		setValueBuffer("reservada", 0);
		setValueBuffer("pterecibir", 0);
	}
	if (!curStock.commitBuffer())
		return false;
	
	return curStock.valueBuffer("idstock");
}

/** \D Crea una línea de stock. Esta función se ha creado para evitar que la sobrecarga de crearStock haga que no funcionen las llamadas dentro de la clase barcode
@param	codAlmacen: Código del almacén asociado al stock 
@param	barCode: Bar code asociado al stock 
@param	referencia: Referencia asociada al stock 
@return	identificador del stock creado si la inserción es correcta, false en caso contrario
*/
function barCode_crearStockBarcode(codAlmacen:String, barCode:String, referencia:String):Number
{
	var util:FLUtil = new FLUtil;
	var nombreAlmacen:String = util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'");
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	with (curStock) {
		setModeAccess(curStock.Insert);
		refreshBuffer();
		setValueBuffer("referencia", referencia);
		setValueBuffer("codalmacen", codAlmacen);
		if (!barCode || barCode == "")
			setNull("barcode");
		else
			setValueBuffer("barcode", barCode);
		setValueBuffer("nombre", nombreAlmacen);
		setValueBuffer("cantidad", 0);
		setValueBuffer("reservada", 0);
		setValueBuffer("pterecibir", 0);
	}
	if (!curStock.commitBuffer())
		return false;
	
	return curStock.valueBuffer("idstock");
}

/** \D Cuando se da de alta un pedido a un proveedor marca el stock como
cantidad pendiente de recibir. La cantidad en pendiente será la cantidad menos la cantidad ya servida en albarán
@param	curLP: Cursor posicionado en la línea de pedido modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStockPedidosProv(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var codAlmacen:String = util.sqlSelect("pedidosprov", "codalmacen", "idpedido = " + curLP.valueBuffer("idpedido"));
	if (!codAlmacen || codAlmacen == "")
		return true;
	
	if (!this.iface.controlStock(curLP, "pterecibir", 1, codAlmacen))
		return false;
	
	return true;
}

/** \D Cuando se da de alta una línea de albarán de proveedor que proviene de un
pedido se incrementa el stock en la cantidad correspondiente y se descuente de
la cantidad pendiente de recibir. Si no proviene de pedido se incrementa el
stock solamente.
@param	curLA: Cursor posicionado en la línea de albarán modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var codAlmacen:String = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	if (!codAlmacen || codAlmacen == "")
		return true;
	
	if (!this.iface.controlStock(curLA, "cantidad", 1, codAlmacen))
		return false;
	
	return true;
}

/** \D Cuando se da de alta una línea de factura de proveedor que no proviene de
un albarán, se incrementa el stock en la cantidad correspondiente.
@param	curLF: Cursor posicionado en la línea de factura modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStockFacturasProv(curLF:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idFactura:String = curLF.valueBuffer("idfactura");
	var automatica:Boolean = util.sqlSelect("facturasprov", "automatica", "idfactura = " + idFactura);
	if (automatica == false) {
		var codAlmacen:String = util.sqlSelect("facturasprov", "codalmacen", "idfactura = " + idFactura);
		if (!codAlmacen || codAlmacen == "")
			return true;
		
		if (!this.iface.controlStock(curLF, "cantidad", 1, codAlmacen))
			return false;
	}
	return true;
}

/** \D Cuando se da de alta un pedido que no proviene de un presupuesto marca el stock como reservado. La cantidad en pendiente será la cantidad menos la cantidad ya servida en albarán
@param	curLP: Cursor posicionado en la línea de pedido modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStockPedidosCli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idPedido:String = curLP.valueBuffer("idpedido");
	
	var codAlmacen:String = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + idPedido);
	if (!codAlmacen || codAlmacen == "")
		return true;

	if (!this.iface.controlStock(curLP, "reservada", 1, codAlmacen))
		return false;
	
	return true;
}

/** \D Cuando se da de alta un albaran que proviene de un pedido, descuenta
la cantidad de reservada y la descuenta del stock. Si no proviene de un
pedido, la descuenta directamente del stock
@param	curLA: Cursor posicionado en la línea de albarán modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var codAlmacen:String = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	if (!codAlmacen || codAlmacen == "")
		return true;
	
	if (!this.iface.controlStock(curLA, "cantidad", -1, codAlmacen))
		return false;
	
	return true;
}


/** \D Cuando se da de alta una factura que no proviene de un albarán la
descuenta del stock.
@param	curLF: Cursor posicionado en la línea de factura modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStockFacturasCli(curLF:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idFactura:String = curLF.valueBuffer("idfactura");
	var automatica:Boolean = util.sqlSelect("facturascli", "automatica", "idfactura = " + idFactura);
	if (automatica == false) {
		var codAlmacen:String = util.sqlSelect("facturascli", "codalmacen", "idfactura = " + idFactura);
		if (!codAlmacen || codAlmacen == "")
			return true;
		
		if (!this.iface.controlStock(curLF, "cantidad", -1, codAlmacen))
			return false;
	}
	return true;
}

/** \D Crea un registro de atributos de artículo (barcode)
@param	referencia: Referencia del artículo
@param	datos: Array con datos referentes al barcode
\end */
function barCode_crearBarcode(referencia:String, datos:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!util.sqlSelect("coloresarticulo", "codcolor", "referencia = '" + referencia + "' AND codcolor = '" + datos["codcolor"] + "'")) {
		var curColoresArt:FLSqlCursor = new FLSqlCursor("coloresarticulo");
		with (curColoresArt) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("referencia", referencia);
			setValueBuffer("codcolor", datos["codcolor"]);
			setValueBuffer("descolor", util.sqlSelect("colores", "descripcion", "codcolor = '" + datos["codcolor"] + "'"));
			if (!commitBuffer())
				return false;
		}
	}

	var curBarCode:FLSqlCursor = new FLSqlCursor("atributosarticulos");
	curBarCode.setModeAccess(curBarCode.Insert);
	curBarCode.refreshBuffer();
	curBarCode.setValueBuffer("barcode", datos["barcode"]);
	curBarCode.setValueBuffer("talla", datos["codtalla"]);
	curBarCode.setValueBuffer("color", datos["codcolor"]);
	curBarCode.setValueBuffer("referencia", referencia);
	if (!curBarCode.commitBuffer())
		return false;
	return true;
}

/** \D Pide al usuario la talla y color de un artículo y crea su registro de atributos (barcode)
@param	referencia: Referencia del artículo
\end */ 
function barCode_pedirColor(referencia:String):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!referencia || referencia == "")
		return false;

	f = new FLFormSearchDB("colores");
	var curColores:FLSqlCursor = f.cursor();

	f.setMainWidget();
	var codColor:String = f.exec("codcolor");
	if (!codColor)
		return false;

	if (util.sqlSelect("coloresarticulo", "codcolor", "referencia = '" + referencia + "' AND codcolor = '" + codColor + "'")) {
		return true;
	}

 	var curColoresArt:FLSqlCursor = new FLSqlCursor("coloresarticulo");
	with (curColoresArt) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("referencia", referencia);
		setValueBuffer("codcolor", codColor);
		setValueBuffer("descolor", util.sqlSelect("colores", "descripcion", "codcolor = '" + codColor + "'"));
		if (!commitBuffer())
			return false;
	}
	
	return true;
}

/** \D Construye el barcode componiendo el código como referencia + codTalla + codColor
@param	referencia: Referencia del artículo
@param	codTalla: Código de talla
@param	codColor: Código de color
@retrun barCode
\end */
function barCode_construirBarcode(referencia:Sring, codTalla:String, codColor:String):String
{
	return referencia + codTalla + codColor;
}


/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function barCode_controlStockLineasTrans(curLTS:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var codAlmacenOrigen:String = util.sqlSelect("transstock", "codalmaorigen", "idtrans = " + curLTS.valueBuffer("idtrans"));
	if (!codAlmacenOrigen || codAlmacenOrigen == "")
		return true;
		
	var codAlmacenDestino:String = util.sqlSelect("transstock", "codalmadestino", "idtrans = " + curLTS.valueBuffer("idtrans"));
	if (!codAlmacenDestino || codAlmacenDestino == "")
		return true;
	
	var cantidad:Number = parseFloat(curLTS.valueBuffer("cantidad"));
	var referencia:String = curLTS.valueBuffer("referencia");
	var barCode:String = curLTS.valueBuffer("barcode");
	switch(curLTS.modeAccess()) {
		case curLTS.Insert:
			if (!this.iface.cambiarStock(codAlmacenOrigen, barCode, referencia, (-1 * cantidad), "cantidad"))
				return false;
			if (!this.iface.cambiarStock(codAlmacenDestino, barCode, referencia, cantidad, "cantidad"))
				return false;
			break;
		case curLTS.Del:
			if (!this.iface.cambiarStock(codAlmacenOrigen, barCode, referencia, cantidad, "cantidad"))
				return false;
			if (!this.iface.cambiarStock(codAlmacenDestino, barCode, referencia, (-1 * cantidad), "cantidad"))
				return false;
			break;
		case curLTS.Edit:
			if (referencia != curLTS.valueBufferCopy("referencia") || cantidad != curLTS.valueBufferCopy("cantidad") || barCode != curLTS.valueBufferCopy("barcode") ) {
				var cantidadPrevia:Number = parseFloat(curLTS.valueBufferCopy("cantidad"));
				if (!this.iface.cambiarStock(codAlmacenOrigen, curLTS.valueBufferCopy("barcode"), curLTS.valueBufferCopy("referencia"), cantidadPrevia, "cantidad"))
					return false;
				if (!this.iface.cambiarStock(codAlmacenOrigen, barCode, referencia, (-1 * cantidad), "cantidad"))
					return false;
				if (!this.iface.cambiarStock(codAlmacenDestino, curLTS.valueBufferCopy("barcode"), curLTS.valueBufferCopy("referencia"), (-1 * cantidadPrevia), "cantidad"))
					return false;
				if (!this.iface.cambiarStock(codAlmacenDestino, barCode, referencia, cantidad, "cantidad"))
					return false;
			}
			break;
	}
	return true;
}

function barCode_controlStockReservado(curLinea:FLSqlCursor, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idPedido:String = curLinea.valueBuffer("idpedido");
	var referencia:String = curLinea.valueBuffer("referencia");
	var barcode:String = curLinea.valueBuffer("barcode");

	if ((referencia && referencia != "") || (barcode && barcode != "")) {
		if (!this.iface.actualizarStockReservado(referencia, barcode, codAlmacen, idPedido)) {
			return false;
		}
	}

	var referenciaPrevia:String = curLinea.valueBufferCopy("referencia");
	var barcodePrevio:String = curLinea.valueBufferCopy("barcode");
	if ((referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) || (barcodePrevio && barcodePrevio != "" && barcodePrevio != barcode)) {
		if (!this.iface.actualizarStockReservado(referenciaPrevia, barcodePrevio, codAlmacen, idPedido)) {
			return false;
		}
	}
 
	return true;
}

function barCode_actualizarStockReservado(referencia:String, barcode:String, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	if (!referencia || referencia == "") {
		return true;
	}
	
	var idStock:String;
	if (!barcode || barcode == "") {
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND (barcode IS NULL OR barcode = '') AND codalmacen = '" + codAlmacen + "'");
	} else {
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND barcode = '" + barcode + "' AND codalmacen = '" + codAlmacen + "'");
	}
	if (!idStock) {
		idStock = this.iface.crearStock(codAlmacen, barcode, referencia);
		if (!idStock) {
			return false;
		}
	}
	
	var reservada:Number;
	if (!barcode || barcode == "") {
		reservada = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", "p.codalmacen = '" + codAlmacen + "' AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ") AND lp.referencia = '" + referencia + "' AND (barcode IS NULL OR barcode = '') AND (lp.cerrada IS NULL OR lp.cerrada = false)", "lineaspedidoscli,pedidoscli");
	} else {
		reservada = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", "p.codalmacen = '" + codAlmacen + "' AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ") AND lp.referencia = '" + referencia + "' AND barcode = '" + barcode + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)", "lineaspedidoscli,pedidoscli");
	}
	if (isNaN(reservada)) {
		reservada = 0;
	}

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("reservada", reservada);
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!this.iface.comprobarStock(curStock)) {
		return false;
	}
	try  {
		if (!curStock.commitBuffer(true)) {
		  return false;
		}
	} catch (e) {
		if (!curStock.commitBuffer()) {
			return false;
		}
	}
	return true;
}

function barCode_controlStockPteRecibir(curLinea:FLSqlCursor, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idPedido:String = curLinea.valueBuffer("idpedido");
	var referencia:String = curLinea.valueBuffer("referencia");
	var barcode:String = curLinea.valueBuffer("barcode");

	if ((referencia && referencia != "") || (barcode && barcode != "")) {
		if (!this.iface.actualizarStockPteRecibir(referencia, barcode, codAlmacen, idPedido)) {
			return false;
		}
	}

	var referenciaPrevia:String = curLinea.valueBufferCopy("referencia");
	var barcodePrevio:String = curLinea.valueBufferCopy("barcode");
	if ((referenciaPrevia && referenciaPrevia != "" && referenciaPrevia != referencia) || (barcodePrevio && barcodePrevio != "" && barcodePrevio != barcode)) {
		if (!this.iface.actualizarStockPteRecibir(referenciaPrevia, barcodePrevio, codAlmacen, idPedido)) {
			return false;
		}
	}
 
	return true;
}

function barCode_actualizarStockPteRecibir(referencia:String, barcode:String, codAlmacen:String, idPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var idStock:String;
	if (!barcode || barcode == "") {
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND (barcode IS NULL OR barcode = '') AND codalmacen = '" + codAlmacen + "'");
	} else {
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND barcode = '" + barcode + "' AND codalmacen = '" + codAlmacen + "'");
	}
	if (!idStock) {
		idStock = this.iface.crearStock(codAlmacen, barcode, referencia);
		if (!idStock) {
			return false;
		}
	}

	var pteRecibir:Number;
	if (!barcode || barcode == "") {
		pteRecibir = util.sqlSelect("lineaspedidosprov lp INNER JOIN pedidosprov p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", "p.codalmacen = '" + codAlmacen + "' AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ") AND lp.referencia = '" + referencia + "' AND (barcode IS NULL OR barcode = '') AND (lp.cerrada IS NULL OR lp.cerrada = false)", "lineaspedidosprov,pedidosprov");
	} else {
		pteRecibir = util.sqlSelect("lineaspedidosprov lp INNER JOIN pedidosprov p ON lp.idpedido = p.idpedido", "sum(lp.cantidad - lp.totalenalbaran)", "p.codalmacen = '" + codAlmacen + "' AND (p.servido IN ('No', 'Parcial') OR p.idpedido = " + idPedido + ") AND lp.referencia = '" + referencia + "' AND barcode = '" + barcode + "' AND (lp.cerrada IS NULL OR lp.cerrada = false)", "lineaspedidosprov,pedidosprov");
	}
	
	if (isNaN(pteRecibir)) {
		pteRecibir = 0;
	}
	
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("pterecibir", pteRecibir);
	try  {
		if (!curStock.commitBuffer(true)) {
		  return false;
		}
	} catch (e) {
		if (!curStock.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** Funciones de barCodeTPV ------------------------------------------------------------------------------------------------------*/
/** \D Cuando se da de alta una línea de vale de TPV por devolución de ventas se incrementa el stock correspondiente.
@param	curLinea: Cursor posicionado en la línea de vale modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCode_controlStockValesTPV(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var codAlmacen:String = curLinea.valueBuffer("codalmacen");
	if (!codAlmacen || codAlmacen == "")
		return true;
	
	if (!this.iface.controlStock(curLinea, "cantidad", 1, codAlmacen))
		return false;
	
	return true;
}

function barCode_controlStockComandasCli(curLV:FLSqlCursor):Boolean {
	var util:FLUtil = new FLUtil;
	
	var codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + curLV.valueBuffer("idtpv_comanda"), "tpv_comandas,tpv_puntosventa");
	if (!codAlmacen || codAlmacen == "")
		return true;
		
	if (!this.iface.controlStock(curLV, "cantidad", -1, codAlmacen))
		return false;
	
	return true;
}

/** ------------------------------------------------------------------------------------------------------------------------------------- */
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

