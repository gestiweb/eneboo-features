
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial {
	function barCode( context ) { oficial ( context ); }
	function init() {
		return this.ctx.barCode_init();
	}
	function transferirStock(idStock1:String):Boolean {
		return this.ctx.barCode_transferirStock(idStock1);
	}
	function transferencia(curTrans:FLSqlCursor):Boolean {
		return this.ctx.barCode_transferencia(curTrans);
	}
	function insertarRegularizaciones(referencia:String, codAlmacen:String) {
		return this.ctx.barCode_insertarRegularizaciones(referencia, codAlmacen);
	}
	function generarRegStocks(curRegBuffer:FLSqlCursor):Boolean {
		return this.ctx.barCode_generarRegStocks(curRegBuffer);
	}
	function crearRegularizacion(idStock:String, curRegBuffer:FLSqlCursor, datos:Array):Boolean {
		return this.ctx.barCode_crearRegularizacion(idStock, curRegBuffer, datos);
	}
	function toolButtonInsertClicked() {
		return this.ctx.barCode_toolButtonInsertClicked();
	}
	/** Funciones de tpv+tallas y colores por barcode */
	function transferirStock(idStock1:String):Boolean {
		return this.ctx.barCode_transferirStock(idStock1);
	}
	function transferencia(curTrans:FLSqlCursor):Boolean {
		return this.ctx.barCode_transferencia(curTrans);
	}
	/** ------------------------------------------------------------------------------------------------------------------------- */
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBarCode */
/////////////////////////////////////////////////////////////////
//// PUB_BARCODE ////////////////////////////////////////////////
class pubBarCode extends ifaceCtx {
    function pubBarCode( context ) { ifaceCtx( context ); }
	function pub_insertarRegularizaciones(referencia:String, codAlmacen:String) {
		return this.insertarRegularizaciones(referencia, codAlmacen);
	}
}
//// PUB_BARCODE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
//////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/** \C Para insertar regularizaciones de stocks indicando las cantidades por talla y color de un determinado artículo, se usará el botón de inserción. Este botón mostrará un formulario en el que se especificarán los datos normales de una línea de regularización de stock, más una matriz de tallas / colores en la que especificar las distintas cantidades por talla / color
\end */
function barCode_init()
{
	this.iface.__init();
	connect (this.child("tbnTallasCol"), "clicked()", this, "iface.toolButtonInsertClicked");
}

function barCode_toolButtonInsertClicked()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.insertarRegularizaciones(cursor.valueBuffer("referencia"), cursor.valueBuffer("codalmacen"));
}

/** \D Lanza el formulario de buffer para recolectar los barcodes que cambian y sus cantidades, y llama a la función de crear regularizaciones de stock
@param	referencia: Referencia por defecto de la prenda
@param	codAlmacen: Almacén por defecto donde se realiza la regularización
\end */
function barCode_insertarRegularizaciones(referencia:String, codAlmacen:String)
{
	var util:FLUtil = new FLUtil();
	util.sqlDelete("regstocks_buffer", "usuario = '" + sys.nameUser() + "'");

	var f:Object = new FLFormSearchDB("regstocks_buffer");
	var curRegBuffer:FLSqlCursor = f.cursor();
	curRegBuffer.setModeAccess(curRegBuffer.Insert);
	curRegBuffer.refreshBuffer();
	curRegBuffer.setValueBuffer("usuario", sys.nameUser());
	if (!curRegBuffer.commitBuffer())
		return false;;

	curRegBuffer.select("usuario = '" + sys.nameUser() + "'");
	if (!curRegBuffer.first())
		return false;

	curRegBuffer.setModeAccess(curRegBuffer.Edit);
	
	f.setMainWidget();
	curRegBuffer.refreshBuffer();
	curRegBuffer.setValueBuffer("referencia", referencia);
	curRegBuffer.setValueBuffer("codalmacenstock", codAlmacen);
	var acpt:String = f.exec("usuario");
	if (!acpt)
		return false;

	var idBuffer:String = curRegBuffer.valueBuffer("id");
	curRegBuffer.commitBuffer();
	curRegBuffer.select("id = " + idBuffer);
	if (!curRegBuffer.first())
		return false;

	curRegBuffer.setModeAccess(curRegBuffer.Browse);
	curRegBuffer.refreshBuffer();

	curRegBuffer.transaction(false);
	try {
		if (this.iface.generarRegStocks(curRegBuffer)) {
			curRegBuffer.commit();
		} else {
			curRegBuffer.rollback();
		}
	}
	catch (e) {
		curRegBuffer.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de las líneas de regularización de stocks:\n%1").arg(e), MessageBox.Ok, MessageBox.NoButton);
	}
	
	return true;
}

/** \D Genera las regularizaciones de stocks necesarias para un conjunto de tallas y colores de una determinada prenda y almacén
*/
function barCode_generarRegStocks(curRegBuffer:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var codAlmacen:String = curRegBuffer.valueBuffer("codalmacenstock");
	if (!codAlmacen || codAlmacen == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer el almacén"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var referencia:String = curRegBuffer.valueBuffer("referencia");
	if (!referencia || referencia == "") {
		MessageBox.warning(util.translate("scripts", "Debe establecer la referencia del artículo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var datos:String = curRegBuffer.valueBuffer("datos");
	if (!datos || datos == "")
		return false;

	var temp:Array;
	var tempBarcode:Array = datos.split(";");
	var arrayBarcodes:Array = new Array();
	var barCode:String;
	var idStock:String;
	var datos:Array;
	for (var i:Number = 0; i < tempBarcode.length; i++) {
		temp = tempBarcode[i].split(",");
		datos = [];
		datos["barcode"] = temp[0]; 
		datos["codtalla"] = temp[1];
		datos["codcolor"] = temp[2];
		datos["cantidadfin"] = parseFloat(temp[3]);
		datos["cantidadini"] = parseFloat(temp[4]);
		if (!util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND barcode = '" + datos["barcode"] + "'")) {
			if (!flfactalma.iface.pub_crearBarcode(referencia, datos))
				return false;
		}
		idStock = util.sqlSelect("stocks", "idstock", "referencia = '" + referencia + "' AND barcode = '" + datos["barcode"] + "' AND codalmacen = '" + codAlmacen + "'");
		if (!idStock) {
			idStock = flfactalma.iface.pub_crearStockBarcode(codAlmacen, datos["barcode"], referencia);
			if (!idStock)
				return false;
		}
		if (!this.iface.crearRegularizacion(idStock, curRegBuffer, datos))
			return false;
	}
	return true;
}

/** \D Crea un registro de línea de regularización de stocks y actualiza el stock correspondiente
@param	idStock: Stock afectado
@param	curRegBuffer: Cursor con los datos de la regularización
@param	datos: Array con datos referentes al barcode
\end */
function barCode_crearRegularizacion(idStock:String, curRegBuffer:FLSqlCursor, datos:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var curLineaReg:FLSqlCursor = new FLSqlCursor("lineasregstocks");
	curLineaReg.setModeAccess(curLineaReg.Insert);
	curLineaReg.refreshBuffer();
	curLineaReg.setValueBuffer("idstock", idStock);
	curLineaReg.setValueBuffer("fecha", curRegBuffer.valueBuffer("fecha"));
	curLineaReg.setValueBuffer("cantidadini", datos["cantidadini"]);
	curLineaReg.setValueBuffer("cantidadfin", datos["cantidadfin"]);
	curLineaReg.setValueBuffer("motivo", curRegBuffer.valueBuffer("motivo"));
	curLineaReg.setValueBuffer("hora", curRegBuffer.valueBuffer("hora"));
	if (!curLineaReg.commitBuffer())
		return false;
	
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	with (curStock) {
		select("idstock = " + idStock);
		if (!first())
			return false;
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("cantidad", datos["cantidadfin"]);
		setValueBuffer("disponible", datos["cantidadfin"] - parseFloat(valueBuffer("reservada")));
		if (!commitBuffer())
			return false;
	}
	/*
	if (!util.sqlUpdate("stocks", "cantidad", datos["cantidadfin"], "idstock = " + idStock))
		return false;
	*/

	return true;
}



/** \D Realiza la transferencia de stock de un almacén a otro
@param idStock1: Identificador del stock desde el que se inicia la transferencia
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function barCode_transferirStock(idStock1:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var referencia:String = util.sqlSelect("stocks", "referencia", "idstock = " + idStock1);
	if (!referencia)
		return false;
	
	var barCode:String = util.sqlSelect("stocks", "barcode", "idstock = " + idStock1);
	if (!referencia)
		return false;

	var fecha:Date = new Date();
	
	var f:Object = new FLFormSearchDB("transferenciastock");
	var curTrans:FLSqlCursor = f.cursor();
	
	curTrans.select();
	if (!curTrans.first())
		curTrans.setModeAccess(curTrans.Insert);
	else
		curTrans.setModeAccess(curTrans.Edit);
	
	f.setMainWidget();
	curTrans.refreshBuffer();
	curTrans.setValueBuffer("referencia", referencia);
	curTrans.setValueBuffer("barcode", barCode);
	curTrans.setValueBuffer("idstock1", idStock1);
	curTrans.setValueBuffer("fecha", fecha);
	curTrans.setValueBuffer("hora", fecha);
	
	var acpt:String = f.exec("id");

	if (acpt) {
		if (!curTrans.commitBuffer())
			return false;
		var cantidad = parseFloat(curTrans.valueBuffer("cantidad"));
		if (!cantidad || isNaN(cantidad) || cantidad == 0) {
			MessageBox.warning(util.translate("scripts", "La cantidad a transferir no puede ser cero"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (parseFloat(curTrans.valueBuffer("cantidadactual2")) == parseFloat(curTrans.valueBuffer("cantidadnueva2"))) {
			MessageBox.warning(util.translate("scripts", "No ha establecido el sentido de la transferencia"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		
		curTrans.transaction(false);
		try {
			if (this.iface.transferencia(curTrans))
				curTrans.commit();
			else {
				curTrans.rollback();
				return false;
			}
		}
		catch (e) {
			curTrans.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la transferencia:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	f.close();
	return true;
}

/** \D Realiza una transferencia de material de un almacén a otro
@param	curTrans: Cursor que contiene los datos de la transferencia a realizar
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function barCode_transferencia(curTrans:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var codAlmacen2:String = curTrans.valueBuffer("codalmacen2");
	var codAlmacen1:String = util.sqlSelect("stocks", "codalmacen", "idstock = " +
	 curTrans.valueBuffer("idstock1"));
	var referencia:String = curTrans.valueBuffer("referencia");
	var barCode:String = curTrans.valueBuffer("barcode");
	
	var idStock2:String = util.sqlSelect("stocks", "idstock", "codalmacen = '" + codAlmacen2 + "' AND barcode = '" + barCode + "'");
	if (!idStock2) {
		idStock2 = flfactalma.iface.pub_crearStockBarcode(codAlmacen2, barCode, referencia);
		if (!idStock2)
			return false;
	}
	var de1a2:Boolean;
	if (parseFloat(curTrans.valueBuffer("cantidadactual1")) < parseFloat(curTrans.valueBuffer("cantidadnueva1")))
		de1a2 = true;
	else
		de1a2 = false;
	
	var curLineaReg:FLSqlCursor = new FLSqlCursor("lineasregstocks");
	with(curLineaReg) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idstock", curTrans.valueBuffer("idstock1"));
		setValueBuffer("fecha", curTrans.valueBuffer("fecha"));
		setValueBuffer("hora", curTrans.valueBuffer("hora"));
		setValueBuffer("codalmacendest", codAlmacen2);
		setValueBuffer("cantidadini", curTrans.valueBuffer("cantidadactual1"));
		setValueBuffer("cantidadfin", curTrans.valueBuffer("cantidadnueva1"));
		if (de1a2)
			setValueBuffer("motivo", util.translate("scripts", "Transferencia a ") + codAlmacen2);
		else
			setValueBuffer("motivo", util.translate("scripts", "Transferencia desde ") + codAlmacen2);
		if (!commitBuffer())
			return false;
	}

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	with (curStock) {
		select("idstock = " + curTrans.valueBuffer("idstock1"));
		if (!first())
			return false;
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("cantidad", curTrans.valueBuffer("cantidadnueva1"));
		if (!commitBuffer())
			return false;
	}
		
	with(curLineaReg) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idstock", idStock2);
		setValueBuffer("fecha", curTrans.valueBuffer("fecha"));
		setValueBuffer("hora", curTrans.valueBuffer("hora"));
		setValueBuffer("codalmacendest", codAlmacen1);
		setValueBuffer("cantidadini", curTrans.valueBuffer("cantidadactual2"));
		setValueBuffer("cantidadfin", curTrans.valueBuffer("cantidadnueva2"));
		if (de1a2)
			setValueBuffer("motivo", util.translate("scripts", "Transferencia desde ") + codAlmacen1);
		else
			setValueBuffer("motivo", util.translate("scripts", "Transferencia a ") + codAlmacen1);
		if (!commitBuffer())
			return false;
	}
	with (curStock) {
		select("idstock = " + idStock2);
		if (!first())
			return false;
		setModeAccess(Edit);
		refreshBuffer();
		setValueBuffer("cantidad", curTrans.valueBuffer("cantidadnueva2"));
		setValueBuffer("disponible", datos["cantidadfin"] - parseFloat(valueBuffer("reservada")));
		if (!commitBuffer())
			return false;
	}
	
	return true;
}

/* Funciones de tpv+tallas y colores por barcode **/

/** \D Realiza la transferencia de stock de un almacén a otro
@param idStock1: Identificador del stock desde el que se inicia la transferencia
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function barCode_transferirStock(idStock1:String):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var referencia:String = util.sqlSelect("stocks", "referencia", "idstock = " + idStock1);
	if (!referencia)
		return false;
	
	var barCode:String = util.sqlSelect("stocks", "barcode", "idstock = " + idStock1);
	if (!referencia)
		return false;
	
	var fecha:Date = new Date();
	
	var f:Object = new FLFormSearchDB("transferenciastock");
	var curTrans:FLSqlCursor = f.cursor();
	
	curTrans.select();
	if (!curTrans.first())
		curTrans.setModeAccess(curTrans.Insert);
	else
		curTrans.setModeAccess(curTrans.Edit);
	
	f.setMainWidget();
	curTrans.refreshBuffer();
	curTrans.setValueBuffer("referencia", referencia);
	curTrans.setValueBuffer("barcode", barCode);
	curTrans.setValueBuffer("idstock1", idStock1);
	curTrans.setValueBuffer("fecha", fecha);
	curTrans.setValueBuffer("hora", fecha);
	
	var codTerminal:String = util.readSettingEntry("scripts/fltpv_ppal/codTerminal");
	if (codTerminal)
		curTrans.setValueBuffer("codagente", util.sqlSelect("tpv_puntosventa","codtpv_agente","codtpv_puntoventa ='" + codTerminal + "'"));
	
	var acpt:String = f.exec("id");
	
	if (acpt) {
		if (!curTrans.commitBuffer())
			return false;
		var cantidad = parseFloat(curTrans.valueBuffer("cantidad"));
		if (!cantidad || isNaN(cantidad) || cantidad == 0) {
			MessageBox.warning(util.translate("scripts", "La cantidad a transferir no puede ser cero"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (parseFloat(curTrans.valueBuffer("cantidadactual2")) == parseFloat(curTrans.valueBuffer("cantidadnueva2"))) {
			MessageBox.warning(util.translate("scripts", "No ha establecido el sentido de la transferencia"), MessageBox.Ok, MessageBox.NoButton);
		return false;
		}
	
		curTrans.transaction(false);
		try {
			if (this.iface.transferencia(curTrans))
				curTrans.commit();
			else {
				curTrans.rollback();
				return false;
			}
		}
		catch (e) {
			curTrans.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la transferencia:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	f.close();
	return true;
}

/** \D Realiza una transferencia de material de un almacén a otro
@param	curTrans: Cursor que contiene los datos de la transferencia a realizar
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function barCode_transferencia(curTrans:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	
	var codAlmacen2:String = curTrans.valueBuffer("codalmacen2");
	var codAlmacen1:String = util.sqlSelect("stocks", "codalmacen", "idstock = " + curTrans.valueBuffer("idstock1"));
	var referencia:String = curTrans.valueBuffer("referencia");
	var barCode:String = curTrans.valueBuffer("barcode");
	
	var idStock2:String = util.sqlSelect("stocks", "idstock", "codalmacen = '" + codAlmacen2 + "' AND barcode = '" + barCode + "'");
	if (!idStock2) {
		idStock2 = flfactalma.iface.pub_crearStock(codAlmacen2, barCode, referencia);
		if (!idStock2)
			return false;
	}
	var de1a2:Boolean;
	if (parseFloat(curTrans.valueBuffer("cantidadactual1")) < parseFloat(curTrans.valueBuffer("cantidadnueva1")))
		de1a2 = true;
	else
		de1a2 = false;
		
	var curLineaReg:FLSqlCursor = new FLSqlCursor("lineasregstocks");
	with(curLineaReg) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idstock", curTrans.valueBuffer("idstock1"));
		setValueBuffer("fecha", curTrans.valueBuffer("fecha"));
		setValueBuffer("hora", curTrans.valueBuffer("hora"));
		setValueBuffer("codalmacendest", codAlmacen2);
		setValueBuffer("codagente", curTrans.valueBuffer("codagente"));
		setValueBuffer("cantidadini", curTrans.valueBuffer("cantidadactual1"));
		setValueBuffer("cantidadfin", curTrans.valueBuffer("cantidadnueva1"));
		if (de1a2)
			setValueBuffer("motivo", util.translate("scripts", "Transferencia a ") + codAlmacen2);
		else
			setValueBuffer("motivo", util.translate("scripts", "Transferencia desde ") + codAlmacen2);
		if (!commitBuffer())
			return false;
	}
	if (!util.sqlUpdate("stocks", "cantidad", curTrans.valueBuffer("cantidadnueva1"), "idstock = " + curTrans.valueBuffer("idstock1")))
		return false;
	
	with(curLineaReg) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("idstock", idStock2);
		setValueBuffer("fecha", curTrans.valueBuffer("fecha"));
		setValueBuffer("hora", curTrans.valueBuffer("hora"));
		setValueBuffer("codalmacendest", codAlmacen1);
		setValueBuffer("codagente", curTrans.valueBuffer("codagente"));
		setValueBuffer("cantidadini", curTrans.valueBuffer("cantidadactual2"));
		setValueBuffer("cantidadfin", curTrans.valueBuffer("cantidadnueva2"));
		if (de1a2)
			setValueBuffer("motivo", util.translate("scripts", "Transferencia desde ") + codAlmacen1);
		else
			setValueBuffer("motivo", util.translate("scripts", "Transferencia a ") + codAlmacen1);
		if (!commitBuffer())
			return false;
	}
	if (!util.sqlUpdate("stocks", "cantidad", curTrans.valueBuffer("cantidadnueva2"), "idstock = " + idStock2))
		return false;
	
	return true;
}
/** ----------------------------------------------------------------------------------------------------------------------------------- */

//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
