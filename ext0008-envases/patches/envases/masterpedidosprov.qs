
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial /** %from: oficial */ {
    function envases( context ) { oficial ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.envases_datosLineaAlbaran(curLineaPedido);
	}
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
/** \D Copia los datos de una línea de pedido en una línea de albarán añadiendo los datos relativos al envase (--valormetrico-- y --canenvases--)
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function envases_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("valormetrico", curLineaPedido.valueBuffer("valormetrico"));
		setValueBuffer("canenvases", curLineaPedido.valueBuffer("canenvases"));
		setValueBuffer("codenvase", curLineaPedido.valueBuffer("codenvase"));
	}

	if(!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	return true;
}
//// ENVASES ////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

