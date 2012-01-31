
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial /** %from: oficial */ {
    function envases( context ) { oficial ( context ); }
	function datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean{
		return this.ctx.envases_datosLineaPedido(curLineaPresupuesto)
	}
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////

/** \D Copia los datos de una línea de presupuesto en una línea de pedido
@param	curLineaPresupuesto: Cursor que contiene los datos a incluir en la línea de pedido
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function envases_datosLineaPedido(curLineaPresupuesto:FLSqlCursor):Boolean
{
	if(!this.iface.__datosLineaPedido(curLineaPresupuesto))
		return false;

	with (this.iface.curLineaPedido) {
		setValueBuffer("valormetrico", curLineaPresupuesto.valueBuffer("valormetrico"));
		setValueBuffer("canenvases", curLineaPresupuesto.valueBuffer("canenvases"));
		setValueBuffer("codenvase", curLineaPresupuesto.valueBuffer("codenvase"));
	}

	return true;
}
//// ENVASES ////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

