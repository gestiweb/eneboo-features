
/** @class_declaration tpvBarcode */
/////////////////////////////////////////////////////////////////
//// TPV + TALLAS Y COLORES POR BARCODE /////////////////////////
class tpvBarcode extends barCode {
	function tpvBarcode( context ) { barCode ( context ); }
	function transferirStock(idStock1:String):Boolean {
		return this.ctx.tpvBarcode_transferirStock(idStock1);
	}
	function transferencia(curTrans:FLSqlCursor):Boolean {
		return this.ctx.tpvBarcode_transferencia(curTrans);
	}
}
//// TPV + TALLAS Y COLORES POR BARCODE /////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvBarcode */
//////////////////////////////////////////////////////////////////
//// TPV + TALLAS Y COLORES POR BARCODE //////////////////////////
/** \D Realiza la transferencia de stock de un almacén a otro
@param idStock1: Identificador del stock desde el que se inicia la transferencia
@return	true si la transferencia se realiza correctamente, false en caso contrario
\end */
function tpvBarcode_transferirStock(idStock1:String):Boolean
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
function tpvBarcode_transferencia(curTrans:FLSqlCursor):Boolean
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
//// TPV + TALLAS Y COLORES POR BARCODE //////////////////////////
/////////////////////////////////////////////////////////////////

