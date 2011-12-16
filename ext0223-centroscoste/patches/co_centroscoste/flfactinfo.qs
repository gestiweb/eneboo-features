
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
	function datosCentrosCoste(nodo:FLDomNode, campo:String):String {
		return this.ctx.centrosCoste_datosCentrosCoste(nodo, campo);
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////

function centrosCoste_datosCentrosCoste(nodo:FLDomNode, campo:String):String
{
	// provisional
//	return "";

	var util:FLUtil = new FLUtil;
	var codCentro:String = nodo.attributeValue(campo + ".codcentro");
	if (!codCentro)
		return "";

	var texto:String;

	texto += util.translate("scripts","Centro de coste") + " " + codCentro + " - " + util.sqlSelect("centroscoste", "descripcion", "codcentro = '" + codCentro + "'");

	var codSubcentro:String = nodo.attributeValue(campo + ".codsubcentro");
	if (!codSubcentro)
		return texto;

	texto += "\n" + util.translate("scripts","Subcentro de coste") + " " + codSubcentro + " - " + util.sqlSelect("subcentroscoste", "descripcion", "codsubcentro = '" + codSubcentro + "'");
	return texto;
}

//// CENTROS COSTE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

