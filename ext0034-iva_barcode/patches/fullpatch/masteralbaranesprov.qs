
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends funNumSerie {
    function barCode( context ) { funNumSerie ( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.barCode_datosLineaFactura(curLineaAlbaran);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function barCode_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("barcode", curLineaAlbaran.valueBuffer("barcode"));
		setValueBuffer("talla", curLineaAlbaran.valueBuffer("talla"));
		setValueBuffer("color", curLineaAlbaran.valueBuffer("color"));
	}
	return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

