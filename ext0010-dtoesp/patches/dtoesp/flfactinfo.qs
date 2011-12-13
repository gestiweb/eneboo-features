
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTOESPECIAL/////////////////////////////////////////////////
class dtoEspecial extends oficial /** %from: oficial */ {
    function dtoEspecial( context ) { oficial ( context ); }
	function descuento(nodo:FLDomNode, campo:String):String {
		return this.ctx.dtoEspecial_descuento(nodo, campo);
	}
}
//// DTOESPECIAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubDtoEspecial */
/////////////////////////////////////////////////////////////////
//// PUB_DTOESPECIAL//////////////////////////////////////////////////
class pubDtoEspecial extends ifaceCtx /** %from: ifaceCtx */ {
	function pubDtoEspecial( context ) { ifaceCtx( context ); }
	function pub_descuento(nodo:FLDomNode, campo:String):Number {
		return this.descuento(nodo, campo);
	}
}

//// PUB_DTOESPECIAL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTOESPECIAL/////////////////////////////////////////////////

function dtoEspecial_descuento(nodo:FLDomNode, campo:String):String
{
	var res:String;
	var idDescuento:String;
	var tabla:String;

	switch (campo) {
		case "facturacli": {
			tabla = "facturascli";
			break;
		}
		case "facturaprov": {
			tabla = "facturasprov";
			break;
		}
	}
    if ( nodo.attributeValue(tabla + ".pordtoesp") == 0 )
		res = "";
	else
		res = nodo.attributeValue(tabla + ".pordtoesp") + " %";

	return res;
}
//// DTOESPECIAL/////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

