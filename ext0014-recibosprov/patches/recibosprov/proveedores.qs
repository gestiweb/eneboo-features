
/** @class_declaration recibosProv */
/////////////////////////////////////////////////////////////////
//// RECIBOS PROV ///////////////////////////////////////////////
class recibosProv extends oficial {
    function recibosProv( context ) { oficial ( context ); }
	function init() {
		this.ctx.recibosProv_init();
	}
	function imprimirRecibo() {
		this.ctx.recibosProv_imprimirRecibo();
	}
}
//// RECIBOS PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition recibosProv */
/////////////////////////////////////////////////////////////////
//// RECIBOS PROV ///////////////////////////////////////////////
function recibosProv_init()
{
	this.iface.__init();

	connect(this.child("toolButtonPrintRec"), "clicked()", this, "iface.imprimirRecibo()");
}

function recibosProv_imprimirRecibo()
{
	var codRecibo:String = this.child("tdbRecibos").cursor().valueBuffer("codigo");
	if (!codRecibo)
		return;
	formrecibosprov.iface.pub_imprimir(codRecibo);

}
//// RECIBOS PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
