
/** @class_declaration ctaVentaArt */
/////////////////////////////////////////////////////////////////
//// CTA VENTA ART //////////////////////////////////////////////
class ctaVentaArt extends oficial /** %from: oficial */ {
    function ctaVentaArt( context ) { oficial ( context ); }
	function copiadatosLineaFactura(curLineaFactura:FLSqlCursor):Boolean {
		return this.ctx.ctaVentaArt_copiadatosLineaFactura(curLineaFactura);
	}
}
//// CTA VENTA ART //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ctaVentaArt */
/////////////////////////////////////////////////////////////////
//// CTA VENTA ART //////////////////////////////////////////////
function ctaVentaArt_copiadatosLineaFactura(curLineaFactura:FLSqlCursor):Boolean
{
	if (!this.iface.__copiadatosLineaFactura(curLineaFactura))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("codsubcuenta", curLineaFactura.valueBuffer("codsubcuenta"));
	}
	return true;
}

//// CTA VENTA ART //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

