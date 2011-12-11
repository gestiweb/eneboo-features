
/** @class_declaration etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
class etiArticulo extends oficial /** %from: oficial */ {
	function etiArticulo( context ) { oficial ( context ); }
	function lanzarEtiArticulo(xmlKD:FLDomDocument) {
		return this.ctx.etiArticulo_lanzarEtiArticulo(xmlKD);
	}
	function tipoInformeEtiquetas() {
		return this.ctx.etiArticulo_tipoInformeEtiquetas();
	}
}
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEtiArticulo */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class pubEtiArticulo extends etiArticulo /** %from: oficial */ {
	function pubEtiArticulo( context ) { etiArticulo ( context ); }
	function pub_lanzarEtiArticulo(xmlKD) {
		return this.lanzarEtiArticulo(xmlKD);
	}
}
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/** \D Lanza el informe de etiquetas de artículos.
\end */
function etiArticulo_lanzarEtiArticulo(xmlKD:FLDomDocument)
{
debug(xmlKD.toString(4));
	var rptViewer:FLReportViewer = new FLReportViewer();

	var datosReport:Array = this.iface.tipoInformeEtiquetas();
	try {
		rptViewer.setReportData(xmlKD);
	} catch (e) {
		return;
	}

	var etiquetaInicial:Array;
	if (datosReport["cols"] > 0) {
		etiquetaInicial = flfactinfo.iface.seleccionEtiquetaInicial();
	}

	var rptViewer:FLReportViewer = new FLReportViewer();
	rptViewer.setReportTemplate(datosReport["nombreinforme"]);
	rptViewer.setReportData(xmlKD);
	if (datosReport["cols"] > 0) {
		rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
	} else {
		rptViewer.renderReport();
	}
	rptViewer.exec();
}

function etiArticulo_tipoInformeEtiquetas()
{
	var res:Array = [];
	res["nombreinforme"] = "i_a4_4x11";
	res["cols"] = 4;
	return res;
}
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

