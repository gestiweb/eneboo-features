
/** @class_declaration funServiciosCli */
//////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
class funServiciosCli extends oficial /** %from: oficial */ {
	function funServiciosCli( context ) { oficial( context ); }
	function init() { return this.ctx.funServiciosCli_init(); }
	function imprimirServicio() {
		this.ctx.funServiciosCli_imprimirServicio();
	}
}
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////

function funServiciosCli_init()
{
	connect(this.child("toolButtonPrintServ"), "clicked()", this, "iface.imprimirServicio");
	this.iface.__init();
}

function funServiciosCli_imprimirServicio()
{
	var numServicio:String = this.child("tdbServicios").cursor().valueBuffer("numservicio");
	if (!numServicio)
		return;
	formservicioscli.iface.pub_imprimir(numServicio);
}

//// FUN_SERVICIOS_CLI ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

