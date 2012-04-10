
/** @class_declaration pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI PROV ///////////////////////////////////////////
class pagosMultiProv extends proveed /** %from: proveed */ {
    function pagosMultiProv( context ) { proveed ( context ); }
	function init() {
		return this.ctx.pagosMultiProv_init();
	}
}
//// PAGOS MULTI PROV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI PROV ///////////////////////////////////////////
/** \D Establece el label de pago múltiple
\end */
function pagosMultiProv_init()
{
	this.iface.__init();

	if (!this.cursor().isNull("idpagomulti")) {
		var util:FLUtil = new FLUtil;
		this.child("lblPagoMulti").text = util.translate("scripts", "PAGO MÚLTIPLE Nº ") + this.cursor().valueBuffer("idpagomulti");
	}
}
//// PAGOS MULTI PROV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

