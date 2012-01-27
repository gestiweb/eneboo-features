
/** @class_declaration etiquetas */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS //////////////////////////////////////////////////
class etiquetas extends oficial {
    function etiquetas( context ) { oficial ( context ); }
// 	function lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, groupBy:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, impresora:String) {
// 		return this.ctx.etiquetas_lanzarInforme(cursor, nombreInforme, orderBy, groupBy, etiquetas, impDirecta, whereFijo, nombreReport, numCopias, impresora);
// 	}
}
//// ETIQUETAS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



/** @class_definition etiquetas */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS //////////////////////////////////////////////////
/** \D
Lanza un informe
@param	cursor: Cursor con los criterios de búsqueda para la consulta base del informe
@param	nombreinforme: Nombre del informe
@param	orderBy: Cláusula ORDER BY de la consulta base
@param	groupBy: Cláusula GROUP BY de la consulta base
@param	etiquetas: Indicador de si se trata de un informe de etiquetas
@param	impDirecta: Indicador para imprimir directaemnte el informe, sin previsualización
@param	whereFijo: Sentencia where que debe preceder a la sentencia where calculada por la función
\end */
// function etiquetas_lanzarInforme(cursor:FLSqlCursor, nombreInforme:String, orderBy:String, cantEtiquetas:String, etiquetas:Boolean, impDirecta:Boolean, whereFijo:String, nombreReport:String, numCopias:Number, impresora:String)
// {
// 	if(!nombreInforme.startsWith("i_etiquetas"))
// 		return this.iface.__lanzarInforme(cursor,nombreInforme,orderBy,cantEtiquetas,etiquetas,impDirecta,whereFijo,nombreReport,numCopias,impresora);
// 
// 	var util:FLUtil;
// 	var etiquetaInicial:Array = [];
// 	
// 	etiquetaInicial["fila"] = parseFloat(cantEtiquetas.right(1));
// 	etiquetaInicial["col"] = parseFloat(cantEtiquetas.left(1));
// 
// 	var q:FLSqlQuery = this.iface.establecerConsulta(cursor, nombreInforme, orderBy, "", whereFijo);
// debug("------ CONSULTA -------" + q.sql());
// 	if (q.exec() == false) {
// 		MessageBox.critical(util.translate("scripts", "Falló la consulta"), MessageBox.Ok, MessageBox.NoButton);
// 		return;
// 	} else {
// 		if (q.first() == false) {
// 			MessageBox.warning(util.translate("scripts", "No hay registros que cumplan los criterios de búsqueda establecidos"), MessageBox.Ok, MessageBox.NoButton);
// 			return;
// 		}
// 	}
// 
// 	if (!nombreReport) 
// 		nombreReport = nombreInforme;
// 
// debug("Informe " + nombreInforme);
// debug("Report " + nombreReport);
// debug("Filas " + etiquetaInicial.fila);
// debug("Columnas " + etiquetaInicial.col);
// 		
// 	var rptViewer:FLReportViewer = new FLReportViewer();
// 	rptViewer.setReportTemplate(nombreReport);
// 	rptViewer.setReportData(q);
// 	rptViewer.renderReport(etiquetaInicial.fila, etiquetaInicial.col);
// 	if (numCopias)
// 		rptViewer.setNumCopies(numCopias);
// 	if (impresora) {
// 		try {
// 			rptViewer.setPrinterName(impresora);
// 		}
// 		catch (e) {}
// 	}
// 		
// 	if (impDirecta)
// 		rptViewer.printReport();
// 	else
// 		rptViewer.exec();
// }
//// ETIQUETAS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


