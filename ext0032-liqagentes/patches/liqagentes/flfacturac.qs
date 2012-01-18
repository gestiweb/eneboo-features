
/** @class_declaration liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
class liqAgentes extends oficial /** %from: oficial */ {
	function liqAgentes( context ) { oficial ( context ); }
	function afterCommit_facturasprov(curFactura:FLSqlCursor):Boolean {
		return this.ctx.liqAgentes_afterCommit_facturasprov(curFactura);
	}
}
//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
function liqAgentes_afterCommit_facturasprov(curFactura:FLSqlCursor):Boolean
{
	if(!this.iface.__afterCommit_facturasprov(curFactura))
		return false;

	var util:FLUtil;

	if(curFactura.modeAccess() == curFactura.Del) {
		var codLiquidacion:String = util.sqlSelect("liquidaciones","codliquidacion","codfactura = '" + curFactura.valueBuffer("codigo") + "'");
		if(codLiquidacion && codLiquidacion != "") {
			if(!util.sqlUpdate("liquidaciones","codfactura","","codliquidacion = '" + codLiquidacion + "'"))
				return false;
		}
	}

	return true;
}
//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

