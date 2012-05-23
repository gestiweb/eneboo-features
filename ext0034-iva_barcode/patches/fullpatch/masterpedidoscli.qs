
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends ivaIncluido {
    function barCode( context ) { ivaIncluido ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.barCode_datosLineaAlbaran(curLineaPedido);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////

/** \D Copia los datos de una línea de pedido en una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function barCode_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	with (this.iface.curLineaAlbaran) {
		setValueBuffer("barcode", curLineaPedido.valueBuffer("barcode"));
		setValueBuffer("talla", curLineaPedido.valueBuffer("talla"));
		setValueBuffer("color", curLineaPedido.valueBuffer("color"));
	}
	return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

