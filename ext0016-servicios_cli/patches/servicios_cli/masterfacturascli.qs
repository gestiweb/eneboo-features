
/** @class_declaration funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
class funServiciosCli extends oficial /** %from: oficial */ {
    function funServiciosCli( context ) { oficial ( context ); }
	function init() {
		return this.ctx.funServiciosCli_init();
	}
	function imprimirServ() {
		return this.ctx.funServiciosCli_imprimirServ();
	}
}
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////

function funServiciosCli_init() {
	connect(this.child("toolButtonPrintServ"), "clicked()", this, "iface.imprimirServ");
	this.iface.__init();
}

function funServiciosCli_imprimirServ()
{
	if (sys.isLoadedModule("flfactinfo")) {
		if (!this.cursor().isValid())
				return;

		var util:FLUtil = new FLUtil();
		if (!util.sqlSelect("servicioscli INNER JOIN albaranescli ON servicioscli.idalbaran = albaranescli.idalbaran", "servicioscli.idservicio", "albaranescli.idfactura = " + this.cursor().valueBuffer("idfactura"), "servicioscli,albaranescli")) {
			MessageBox.warning(util.translate("scripts", "Esta factura no está asociada a ningún servicio"), MessageBox.Ok, MessageBox.NoButton);
			util.destroyProgressDialog();
			return;
		}

		var automatica:Boolean = this.cursor().valueBuffer("automatica");
		if (automatica == true) {
			var codigo:String = this.cursor().valueBuffer("codigo");
			var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturascli");
			curImprimir.setModeAccess(curImprimir.Insert);
			curImprimir.refreshBuffer();
			curImprimir.setValueBuffer("descripcion", "temp");
			curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
			curImprimir.setValueBuffer("h_facturascli_codigo", codigo);
			flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_facturascli_serv");
		} else
			this.iface.__imprimir();
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");

}
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

