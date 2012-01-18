
/** @class_declaration liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQUIDACIONES A AGENTES ////////////////////////////////////
class liqAgentes extends oficial /** %from: oficial */ {
    function liqAgentes( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.liqAgentes_commonCalculateField(fN, cursor);
	}
}
//// LIQUIDACIONES A AGENTES ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQUIDACIONES A AGENTES ////////////////////////////////////
function liqAgentes_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		case "irpf": {
			if (util.sqlSelect("liquidaciones", "codliquidacion", "codfactura = '" + cursor.valueBuffer("codigo") + "'")) {
				valor = cursor.valueBuffer("irpf");
				break;
			}
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
		}
	}
	return valor;
}
//// LIQUIDACIONES A AGENTES ////////////////////////////////////
/////////////////////////////////////////////////////////////////

