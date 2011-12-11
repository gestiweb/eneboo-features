
/** @class_declaration infoVtos */
/////////////////////////////////////////////////////////////////
//// INFO_VENCIMIENTOS //////////////////////////////////////////
class infoVtos extends oficial /** %from: oficial */ {
    function infoVtos( context ) { oficial ( context ); }
	function cabeceraVencimientos(nodo:FLDomNode, campo:String):String {
		return this.ctx.infoVtos_cabeceraVencimientos(nodo, campo);
	}
}
//// INFO_VENCIMIENTOS //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubInfoVtos */
/////////////////////////////////////////////////////////////////
//// PUB_INFO_VENCIMIENTOS //////////////////////////////////////
class pubInfoVtos extends ifaceCtx /** %from: ifaceCtx */ {
    function pubInfoVtos( context ) { ifaceCtx ( context ); }
	function pub_cabeceraVencimientos(nodo:FLDomNode, campo:String):String {
		return this.cabeceraVencimientos(nodo, campo);
	}
}
//// PUB_INFO_VENCIMIENTOS //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition infoVtos */
/////////////////////////////////////////////////////////////////
//// INFO_VENCIMIENTOS //////////////////////////////////////////
function infoVtos_cabeceraVencimientos(nodo:FLDomNode, campo:String):String
{
	switch (campo) {
		case "codejercicio":
			return nodo.attributeValue("criterios.codejercicio");
			break;
		case "empresa":
			return nodo.attributeValue("empresa.nombre");
			break;
		case "fachavtodesde":
			return nodo.attributeValue("criterios.fechavtodesde");
			break;
		case "fachavtohasta":
			return nodo.attributeValue("criterios.fechavtohasta");
			break;
	}
}
//// INFO_VENCIMIENTOS //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

