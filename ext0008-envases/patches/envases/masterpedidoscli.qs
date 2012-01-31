
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
/** \D Copia los datos de una línea de pedido en una línea de albarán añadiendo los datos relativos al envase (--codenvase--, --valormetrico-- y --canenvases--)
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function envases_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	var canEnvases:Number;
	if (parseFloat(curLineaPedido.valueBuffer("totalenalbaran")) != 0)
		canEnvases = parseFloat(this.iface.curLineaAlbaran.valueBuffer("cantidad")) / parseFloat(curLineaPedido.valueBuffer("valormetrico"));
	else
		canEnvases = curLineaPedido.valueBuffer("canenvases");
	canEnvases = util.roundFieldValue(canEnvases, "lineaspedidoscli", "canenvases");
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("valormetrico", curLineaPedido.valueBuffer("valormetrico"));
		setValueBuffer("canenvases", canEnvases);
		setValueBuffer("codenvase", curLineaPedido.valueBuffer("codenvase"));
	}

	return true;
}
//// ENVASES ////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

