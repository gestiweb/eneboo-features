
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
	var idAlbaran:String = cursor.valueBuffer("idalbaran");
	if (!idAlbaran) {
		return false;
	}

	var qryLineas:FLSqlQuery = new FLSqlQuery();
	with (qryLineas) {
		setTablesList("lineasalbaranesprov,articulos");
		setSelect("la.referencia, la.cantidad, la.descripcion, a.codbarras, a.pvp");
		setFrom("lineasalbaranesprov la LEFT OUTER JOIN articulos a ON la.referencia = a.referencia");
		setWhere("idalbaran = " + idAlbaran + " ORDER BY referencia");
		setForwardOnly(true);
	}
	if (!qryLineas.exec()) {
		return false;
	}

	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var eRow:FLDomElement;
	var cantidad:Number;
	while (qryLineas.next()) {
		cantidad = parseInt(qryLineas.value("la.cantidad"));
		for (var i:Number = 0; i < cantidad; i++) {
			eRow = xmlKD.createElement("Row");
			eRow.setAttribute("barcode", qryLineas.value("a.codbarras"));
			eRow.setAttribute("referencia", qryLineas.value("la.referencia"));
			eRow.setAttribute("descripcion", qryLineas.value("la.descripcion"));
			eRow.setAttribute("pvp", qryLineas.value("a.pvp"));
			eRow.setAttribute("level", 0);
			xmlKD.firstChild().appendChild(eRow);
		}
	}

	if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
		return false;
	}
}
//// ETIQUETAS POR ARTÍCULO /////////////////////////////////////
/////////////////////////////////////////////////////////////////

