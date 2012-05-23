
/** @class_declaration barcodeTPV */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE TPV ///////////////////////////////////
class barcodeTPV extends barCode {
	function barcodeTPV ( context ) { barCode( context ); }
	function controlStockValesTPV(curLinea:FLSqlCursor):Boolean {
		return this.ctx.barCodeTPV_controlStockValesTPV(curLinea);
	}
	function controlStockComandasCli(curLV:FLSqlCursor):Boolean {
		return this.ctx.barCodeTPV_controlStockComandasCli(curLV);
	}
}
//// IVAINCLUIDO + BARCODE TPV ///////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition barcodeTPV */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE + TPV /////////////////////////////////
/** \D Cuando se da de alta una línea de vale de TPV por devolución de ventas se incrementa el stock correspondiente.
@param	curLinea: Cursor posicionado en la línea de vale modificada
@return	True si el control se realiza correctamente, false en caso contrario
*/
function barCodeTPV_controlStockValesTPV(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var codAlmacen:String = curLinea.valueBuffer("codalmacen");
	if (!codAlmacen || codAlmacen == "")
		return true;

	if (!this.iface.controlStock(curLinea, "cantidad", 1, codAlmacen))
		return false;

	return true;
}

function barCodeTPV_controlStockComandasCli(curLV:FLSqlCursor):Boolean {
	var util:FLUtil = new FLUtil;

	var codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + curLV.valueBuffer("idtpv_comanda"), "tpv_comandas,tpv_puntosventa");
	if (!codAlmacen || codAlmacen == "")
		return true;

	if (!this.iface.controlStock(curLV, "cantidad", -1, codAlmacen))
		return false;

	return true;
}

//// IVAINCLUIDO + BARCODE + TPV /////////////////////////////////
//////////////////////////////////////////////////////////////////

