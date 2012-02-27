
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ////////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
	function ivaIncluido( context ) { oficial( context ); }
	function datosLineaFactura(curLineaComanda:FLSqlCursor):Boolean {
		return this.ctx.ivaIncluido_datosLineaFactura(curLineaComanda);
	}
}
//// IVA INCLUIDO ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ////////////////////////////////////////////////
/** \D Copia campo a campo los datos de IVA incluido de una linea de la comanda en una línea de la factura
@param curLineaComanda cursor de las lineas de la comanda
@return Boolean, true si la linea se ha copiado correctamente y false si ha habido algún errror
*/
function ivaIncluido_datosLineaFactura(curLineaComanda:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaComanda))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("ivaincluido", curLineaComanda.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaComanda.valueBuffer("pvpunitarioiva"));
	}
	return true;
}
//// IVA INCLUIDO ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

