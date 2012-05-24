
/** @class_declaration funServiciosCli */
//////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
class funServiciosCli extends oficial /** %from: oficial */ {
	function funServiciosCli( context ) { oficial( context ); }
	function init() { return this.ctx.funServiciosCli_init(); }
}
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////

function funServiciosCli_init()
{
	this.iface.__init();

	var idAlbaran:Number = this.cursor().valueBuffer("idalbaran");
	var curServicio:FLSqlCursor = new FLSqlCursor("servicioscli");
	curServicio.select("idalbaran = " + idAlbaran);
	if (curServicio.first()) {
		this.child("fdbCodCliente").setDisabled(true);
		this.child("fdbNombreCliente").setDisabled(true);
		this.child("fdbCifNif").setDisabled(true);
		this.child("fdbCodDivisa").setDisabled(true);
		this.child("fdbRecFinanciero").setDisabled(true);
		this.child("fdbTasaConv").setDisabled(true);
	}
}

//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

