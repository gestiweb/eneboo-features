
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_datosPedido(curPresupuesto);
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////

function centrosCoste_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	if (!this.iface.__datosPedido(curPresupuesto))
		return false;

	with (this.iface.curPedido) {
		setValueBuffer("codcentro", curPresupuesto.valueBuffer("codcentro"));
		setValueBuffer("codsubcentro", curPresupuesto.valueBuffer("codsubcentro"));
	}
	return true;
}

//// CENTROS COSTE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

