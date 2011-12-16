
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
	function datosFactura(curAlbaran:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean {
		return this.ctx.centrosCoste_datosFactura(curAlbaran,where,datosAgrupacion);
	}
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_datosLineaFactura(curLineaAlbaran);
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////

function centrosCoste_datosFactura(curAlbaran:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean
{
	if (!this.iface.__datosFactura(curAlbaran,where,datosAgrupacion))
		return false;

	with (this.iface.curFactura) {
		setValueBuffer("codcentro", curAlbaran.valueBuffer("codcentro"));
		setValueBuffer("codsubcentro", curAlbaran.valueBuffer("codsubcentro"));
	}
	return true;
}

function centrosCoste_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("codcentro", curLineaAlbaran.valueBuffer("codcentro"));
		setValueBuffer("codsubcentro", curLineaAlbaran.valueBuffer("codsubcentro"));
	}
	return true;
}

//// CENTROS COSTE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

