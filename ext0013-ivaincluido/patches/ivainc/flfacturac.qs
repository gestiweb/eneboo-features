
/** @class_declaration ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ///////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
	function ivaIncluido( context ) { oficial ( context ); }
	function datosLineaDocIva():Boolean {
		return this.ctx.ivaIncluido_datosLineaDocIva();
	}
}
//// IVA INCLUIDO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ///////////////////////////////////////////////
function ivaIncluido_datosLineaDocIva():Boolean
{
	if (!this.iface.__datosLineaDocIva()) {
		return false;
	}
	switch (this.iface.curLineaDoc_.table()) {
		case "lineaspresupuestoscli":
		case "lineaspedidoscli":
		case "lineasalbaranescli":
		case "lineasfacturascli": {
			if (this.iface.curLineaDoc_.valueBuffer("ivaincluido")) {
				this.iface.curLineaDoc_.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaDoc_));
			} else {
				this.iface.curLineaDoc_.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineaDoc_));
			}
			this.iface.curLineaDoc_.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaDoc_));
			this.iface.curLineaDoc_.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaDoc_));
			break;
		}
	}

	return true;
}
//// IVA INCLUIDO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

