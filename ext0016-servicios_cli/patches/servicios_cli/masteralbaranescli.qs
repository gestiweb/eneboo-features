
/** @class_declaration funServiciosCli */
//////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
class funServiciosCli extends oficial /** %from: oficial */ {
	function funServiciosCli( context ) { oficial( context ); }
	function init() {
		return this.ctx.funServiciosCli_init();
	}
	function imprimirServ() {
		return this.ctx.funServiciosCli_imprimirServ();
	}
}
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////

function funServiciosCli_init()
{
	connect(this.child("toolButtonPrintServ"), "clicked()", this, "iface.imprimirServ");
	this.iface.__init();
}

function funServiciosCli_imprimirServ()
{
	if (sys.isLoadedModule("flfactinfo")) {
		if (!this.cursor().isValid())
				return;
		var codigo:String = this.cursor().valueBuffer("codigo");
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranescli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
		curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_albaranescli_serv");
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUN_SERVICIOS_CLI ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

