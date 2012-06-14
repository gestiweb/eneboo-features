
/** @class_declaration tpvtactIvainc */
/////////////////////////////////////////////////////////////////
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
class tpvtactIvainc extends oficial {
    function tpvtactIvainc( context ) { oficial ( context ); }
    function datosLineaVenta(referencia:String, cantidad:Number,comanda:Number):Boolean {
		return this.ctx.tpvtactIvainc_datosLineaVenta(referencia, cantidad,comanda);
	}
}
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition tpvtactIvainc */
/////////////////////////////////////////////////////////////////
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
function tpvtactIvainc_datosLineaVenta(referencia:String, cantidad:Number,comanda:Number):Boolean
{
	if(!this.iface.__datosLineaVenta(referencia, cantidad,comanda))
		return false;

	var ivaIncluido:Boolean = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas);
	this.iface.curLineas.setValueBuffer("ivaincluido", ivaIncluido);
	this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva", this.iface.curLineas));

	if (ivaIncluido) {
		this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineas));
		this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
		this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
	}

	return true;
}
//// TPV_TACTIL + IVA_INCLUIDO ///////////////////////
/////////////////////////////////////////////////////////////////

