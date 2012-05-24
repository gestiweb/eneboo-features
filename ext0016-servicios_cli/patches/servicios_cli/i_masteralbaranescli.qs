
/** @class_declaration funServiciosCli */
///////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI ////////////////////////////////////////////
class funServiciosCli extends oficial /** %from: oficial */ {
	function funServiciosCli( context ) { oficial( context ); }
	function init() {
		return this.ctx.funServiciosCli_init();
	}
	function imprimirServ() {
		return this.ctx.funServiciosCli_imprimirServ();
	}
}
//// FUN_SERVICIOS_CLI ////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////

function funServiciosCli_init()
{
	if(this.cursor().action() == "i_resalbaranescli")
		this.child("toolButtonPrintServ").close()
	else
		connect(this.child("toolButtonPrintServ"), "clicked()", this, "iface.imprimirServ");
	this.iface.__init();
}

function funServiciosCli_imprimirServ()
{
	var cursor:FLSqlCursor = this.cursor();
	var pI = this.iface.obtenerParamInforme();
	if (!pI) {
		return;
	}

	pI.nombreInforme = "i_albaranescli_serv"
	flfactinfo.iface.pub_lanzarInforme(cursor, pI.nombreInforme, pI.orderBy, "", false, false, pI.whereFijo);
}

//// FUN_SERVICIOS_CLI ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

