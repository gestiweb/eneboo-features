
/** @class_declaration factPeriodica */
/////////////////////////////////////////////////////////////////
//// FACTURACION PERIODICA //////////////////////////////////////
class factPeriodica extends oficial /** %from: oficial */ {
	function factPeriodica( context ) { oficial ( context ); }
	function globalInit() {
		return this.ctx.factPeriodica_globalInit();
	}
	function init() {
		return this.ctx.factPeriodica_init();
	}
}
//// FACTURACION PERIODICA //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition factPeriodica */
/////////////////////////////////////////////////////////////////
//// FACTURACION PERIODICA //////////////////////////////////////
function factPeriodica_globalInit()
{
	this.iface.__globalInit();

	var util:FLUtil = new FLUtil;
	var idUsuario:String = sys.nameUser();
	if (util.sqlSelect("usuarios", "avisarcontratopte", "idusuario = '" + idUsuario + "'")) {
		formcontratos.iface.pub_avisoContratosPendientes();
	}
}

function factPeriodica_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil;
	var funcion:String = util.readSettingEntry("application/callFunction");
	if (funcion != "flfactppal.globalInit") {
		util.writeSettingEntry("application/callFunction", "flfactppal.globalInit");
	}
}
//// FACTURACION PERIODICA //////////////////////////////////////
/////////////////////////////////////////////////////////////////

