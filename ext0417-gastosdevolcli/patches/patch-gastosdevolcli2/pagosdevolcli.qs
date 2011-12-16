
/** @class_declaration gastoDevol */
/////////////////////////////////////////////////////////////////
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
class gastoDevol extends oficial /** %from: oficial */ {
    function gastoDevol( context ) { oficial ( context ); }
	function init() {
		return this.ctx.gastoDevol_init();
	}
	function habilitarGastoDevol() {
		return this.ctx.gastoDevol_habilitarGastoDevol();
	}
}
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gastoDevol */
/////////////////////////////////////////////////////////////////
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
function gastoDevol_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	this.iface.habilitarGastoDevol();
}

function gastoDevol_habilitarGastoDevol()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("tipo") == "Devolución") {
		this.child("fdbGastoDevol").setDisabled(false);
	} else {
		this.child("fdbGastoDevol").setDisabled(true);
	}
}
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
/////////////////////////////////////////////////////////////////

