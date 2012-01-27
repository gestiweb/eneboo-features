
/** @class_declaration medidas */
/////////////////////////////////////////////////////////////////
//// PESOS Y MEDIDAS ////////////////////////////////////////////
class medidas extends oficial /** %from: oficial */ {
	function medidas( context ) { oficial ( context ); }
	function convertirValorUnidades(valor:Number, codUnidadOrigen:String, codUnidadDestino:String):Number {
		return this.ctx.medidas_convertirValorUnidades(valor, codUnidadOrigen, codUnidadDestino);
	}
}
//// PESOS Y MEDIDAS ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubMedidas */
/////////////////////////////////////////////////////////////////
//// PUB PESOS Y MEDIDAS ////////////////////////////////////////
class pubMedidas extends ifaceCtx /** %from: ifaceCtx */ {
	function pubMedidas( context ) { ifaceCtx( context ); }
	function pub_convertirValorUnidades(valor:Number, codUnidadOrigen:String, codUnidadDestino:String):Number {
		return this.convertirValorUnidades(valor, codUnidadOrigen, codUnidadDestino);
	}
}
//// PUB PESOS Y MEDIDAS ////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition medidas */
/////////////////////////////////////////////////////////////////
//// PESOS Y MEDIDAS ////////////////////////////////////////////
function medidas_convertirValorUnidades(valor:Number, unOrigen:String, unDestino:String):Number
{
	var util:FLUtil = new FLUtil;
	var factorOrigen:Number = parseFloat(util.sqlSelect("pesosmedidas", "factorconv", "codunidad = '" + unOrigen + "'"));
	if (isNaN(factorOrigen)) {
		factorOrigen = 0;
	}
	var factorDestino:Number = parseFloat(util.sqlSelect("pesosmedidas", "factorconv", "codunidad = '" + unDestino + "'"));
	if (isNaN(factorDestino)) {
		factorDestino = 0;
	}
	if (factorOrigen == 0 || factorDestino == 0) {
		valorConvertido = valor;
	} else {
		valorConvertido = valor * factorOrigen / factorDestino;
	}
	return valorConvertido;
}
//// PESOS Y MEDIDAS ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

