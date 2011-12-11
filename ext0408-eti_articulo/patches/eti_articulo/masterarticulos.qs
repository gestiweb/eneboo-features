
/** @class_declaration etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
class etiArticulo extends oficial /** %from: oficial */ {
	var tbnEtiquetas:Object;
    function etiArticulo( context ) { oficial ( context ); }
	function init() {
		return this.ctx.etiArticulo_init();
	}
	function imprimirEtiquetas() {
		return this.ctx.etiArticulo_imprimirEtiquetas();
	}
}
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS POR ARTÍCULO /////////////////////////////////////
function etiArticulo_init()
{
	this.iface.__init();
	this.iface.tbnEtiquetas = this.child("tbnEtiquetas");

	connect(this.iface.tbnEtiquetas, "clicked()", this, "iface.imprimirEtiquetas");
}

/** \D Imprime las etiquetas correspondientes a todas las líneas del albarán seleccionado
\end */
function etiArticulo_imprimirEtiquetas()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = cursor.valueBuffer("referencia");
	if (!referencia) {
		return false;
	}

	var cantidad:Number = Input.getNumber(util.translate("scripts", "Nº etiquetas"), 1, 0, 1, 100000, util.translate("scripts", "Imprimir etiquetas"));
	if (!cantidad) {
		return false;
	}

	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var eRow:FLDomElement;
	for (var i:Number = 0; i < cantidad; i++) {
		eRow = xmlKD.createElement("Row");
		eRow.setAttribute("barcode", cursor.valueBuffer("codbarras"));
		eRow.setAttribute("referencia", cursor.valueBuffer("referencia"));
		eRow.setAttribute("descripcion", cursor.valueBuffer("descripcion"));
		eRow.setAttribute("pvp", cursor.valueBuffer("pvp"));
		eRow.setAttribute("level", 0);
		xmlKD.firstChild().appendChild(eRow);
	}

	if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
		return false;
	}
}
//// ETIQUETAS POR ARTÍCULO /////////////////////////////////////
/////////////////////////////////////////////////////////////////

