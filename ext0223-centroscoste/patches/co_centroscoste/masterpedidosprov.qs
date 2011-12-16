
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
	function datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.centrosCoste_datosAlbaran(curPedido, where, datosAgrupacion);
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////

function centrosCoste_datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean
{
	if (!this.iface.__datosAlbaran(curPedido,where,datosAgrupacion))
		return false;

	with (this.iface.curAlbaran) {
		setValueBuffer("codcentro", curPedido.valueBuffer("codcentro"));
		setValueBuffer("codsubcentro", curPedido.valueBuffer("codsubcentro"));
	}
	return true;
}

//// CENTROS COSTE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

