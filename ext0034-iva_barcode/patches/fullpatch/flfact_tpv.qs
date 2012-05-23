
/** @class_declaration ivaBarcode */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
class ivaBarcode extends funNumSerie {
	function ivaBarcode( context ) { funNumSerie( context ); }
	function datosLineaFactura(curLineaComanda:FLSqlCursor):Boolean {
		return this.ctx.ivaBarcode_datosLineaFactura(curLineaComanda);
	}
}
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaBarcode */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
/** \D Copia campo a campo los datos de IVA incluido y tallas y colores de una linea de la comanda en una línea de la factura
@param curLineaComanda cursor de las lineas de la comanda
@return Boolean, true si la linea se ha copiado correctamente y false si ha habido algún errror
*/
function ivaBarcode_datosLineaFactura(curLineaComanda:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaComanda))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("ivaincluido", curLineaComanda.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaComanda.valueBuffer("pvpunitarioiva"));
		setValueBuffer("barcode", curLineaComanda.valueBuffer("barcode"));
		setValueBuffer("talla", curLineaComanda.valueBuffer("talla"));
		setValueBuffer("color", curLineaComanda.valueBuffer("color"));
	}
	return true;
}

//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

