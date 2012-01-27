
/** @class_declaration ctaVentas */
/////////////////////////////////////////////////////////////////
//// CTA VENTAS /////////////////////////////////////////////////
class ctaVentas extends oficial /** %from: oficial */ {
    function ctaVentas( context ) { oficial ( context ); }
	var posActualPuntoSubcuentaV:Number;
	function init() {
		return this.ctx.ctaVentas_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.ctaVentas_bufferChanged(fN);
	}
}
//// CTA VENTAS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ctaVentas */
/////////////////////////////////////////////////////////////////
//// CTA VENTAS /////////////////////////////////////////////////
function ctaVentas_init()
{
	this.iface.__init();
	this.iface.posActualPuntoSubcuentaV = -1;
}

function ctaVentas_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "codsubcuentaven": {
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuentaV = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaVen", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaV);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}
//// CTA VENTAS /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

