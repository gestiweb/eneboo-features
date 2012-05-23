
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends funNumSerie {
    function barCode( context ) { funNumSerie ( context ); }
	function afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean {
		return this.ctx.barCode_afterCommit_lineaspedidosprov(curLP);
	}
	function validarLinea(curLinea:FLSqlCursor):Boolean {
		return this.ctx.barCode_validarLinea(curLinea);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBarcode */
/////////////////////////////////////////////////////////////////
//// PUB BARCODE ////////////////////////////////////////////////
class pubBarcode extends ifaceCtx {
	function pubBarcode( context ) { ifaceCtx( context ); }
	function pub_validarLinea(curLinea:FLSqlCursor):Boolean {
		return this.validarLinea(curLinea);
	}
}
//// PUB BARCODE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/** \C
Actualiza el stock correspondiente al artículo seleccionado en la línea
\end */
function barCode_afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean
{
	if (sys.isLoadedModule("flfactalma"))
		if (!flfactalma.iface.pub_controlStockPedidosProv(curLP))
			return false;

	return true;
}

function barCode_validarLinea(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var talla:String = curLinea.valueBuffer("talla");
	var color:String = curLinea.valueBuffer("color");
	var barcode:String = curLinea.valueBuffer("barcode");
	if (((talla && talla != "") || (color && color != "")) && (!barcode || barcode == "")) {
		MessageBox.warning(util.translate("scripts", "Si establece la talla o color debe indicar el código de barras (barcode) del artículo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

