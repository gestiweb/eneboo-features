
/** @class_declaration actPrecios */
/////////////////////////////////////////////////////////////////
//// ACT_PRECIOS //////////////////////////////////////////////////
class actPrecios extends oficial
{
	var sep:String = "ð";
	var tablaDestino:String = "articulos";
	var crearSiNoExiste:Boolean = false;
	var corr = [];
	var pos = [];
	var arrayNomCampos = [];
	var tableDBRecords:Object;

    function actPrecios( context ) { oficial ( context ); }
	function init() {
		return this.ctx.actPrecios_init();
	}
	function importar() {
		return this.ctx.actPrecios_importar();
	}
	function preprocesarFichero(tabla:String, file, posClaveFich:String, encabezados:String):Array {
		return this.ctx.actPrecios_preprocesarFichero(tabla, file, posClaveFich, encabezados);
	}
	function leerLinea(file, numCampos):String {
		return this.ctx.actPrecios_leerLinea(file, numCampos);
	}
	function crearCorrespondencias() {
		return this.ctx.actPrecios_crearCorrespondencias();
	}
	function crearPosiciones(cabeceras:String) {
		return this.ctx.actPrecios_crearPosiciones(cabeceras);
	}
	function comprobarFichero(cabeceras:String) {
		return this.ctx.actPrecios_comprobarFichero(cabeceras);
	}
	function whereTablaDestino( linea:String ):String {
		return this.ctx.actPrecios_whereTablaDestino( linea );
	}
}
//// ACT_PRECIOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends actPrecios {
	var curArticuloComp:FLSqlCursor;
	var curTipoOpcionArt:FLSqlCursor;
	var curOpcionArt:FLSqlCursor;
	var tbnActualizarVariable:Object;
	function articuloscomp( context ) { actPrecios ( context ); }
	function init() {
		return this.ctx.articuloscomp_init();
	}
	function copiarAnexosArticulo(refOriginal:String, refNueva:String) {
		return this.ctx.articuloscomp_copiarAnexosArticulo(refOriginal, refNueva);
	}
// 	function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
// 		return this.ctx.articuloscomp_datosArticulo(cursor,referencia);
// 	}
	function copiarArticuloComp(id:Number, refNueva:String):Number {
		return this.ctx.articuloscomp_copiarArticuloComp(id, refNueva);
	}
	function copiarTablaArticulosComp(refOrigen:String, refNueva:String):Boolean {
		return this.ctx.articuloscomp_copiarTablaArticulosComp(refOrigen, refNueva);
	}
	function datosArticuloComp(cursorOrigen:FLSqlCursor, campo:String):Boolean {
		return this.ctx.articuloscomp_datosArticuloComp(cursorOrigen, campo);
	}
	function copiarTiposOpcionArticulo(refOrigen:String, refNueva:String):Boolean {
		return this.ctx.articuloscomp_copiarTiposOpcionArticulo(refOrigen, refNueva);
	}
	function copiarTipoOpcionArticulo(id:Number, refNueva:String):Number {
		return this.ctx.articuloscomp_copiarTipoOpcionArticulo(id, refNueva);
	}
	function datosTipoOpcionArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean {
		return this.ctx.articuloscomp_datosTipoOpcionArticulo(cursorOrigen, campo);
	}
	function copiarOpcionesArticulo(idTipoOpcion:String, idTipoOpcionNueva:String):Boolean {
		return this.ctx.articuloscomp_copiarOpcionesArticulo(idTipoOpcion, idTipoOpcionNueva);
	}
	function copiarOpcionArticulo(id:String, idTipoOpcionNueva:String):Number {
		return this.ctx.articuloscomp_copiarOpcionArticulo(id, idTipoOpcionNueva);
	}
	function datosOpcionArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean {
		return this.ctx.articuloscomp_datosOpcionArticulo(cursorOrigen, campo);
	}
	function actualizarVariables_clicked() {
		return this.ctx.articuloscomp_actualizarVariables_clicked();
	}
	function actualizarVariables():Boolean {
		return this.ctx.articuloscomp_actualizarVariables();
	}
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pesosMedidas */
/////////////////////////////////////////////////////////////////
//// PESOSMEDIDAS ///////////////////////////////////////////////
class pesosMedidas extends articuloscomp {
    function pesosMedidas( context ) { articuloscomp ( context ); }
// 	function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
// 		return this.ctx.pesosMedidas_datosArticulo(cursor,referencia);
// 	}
}
//// PESOSMEDIDAS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVAINCLUIDO ////////////////////////////////////////////////
class ivaIncluido extends pesosMedidas {
    function ivaIncluido( context ) { pesosMedidas ( context ); }
	function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
		return this.ctx.ivaIncluido_datosArticulo(cursor,referencia);
	}
}
//// IVAINCLUIDO ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends ivaIncluido {
	var curAtributoArticulo:FLSqlCursor;
	var curAccesorioArticulo:FLSqlCursor;
    function fluxEcommerce( context ) { ivaIncluido ( context ); }
// 	function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
// 		return this.ctx.fluxEcommerce_datosArticulo(cursor,referencia);
// 	}
	function copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.fluxEcommerce_copiarAnexosArticulo(refOriginal, refNueva);
	}
// 	function copiarTablaAtributosArticulos(nuevaReferencia:String):Boolean {
// 		return this.ctx.fluxEcommerce_copiarTablaAtributosArticulos(nuevaReferencia);
// 	}
	function copiarAtributosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.fluxEcommerce_copiarAtributosArticulo(refOriginal, refNueva);
	}
	function datosAtributoArticulo(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean {
		return this.ctx.fluxEcommerce_datosAtributoArticulo(cursor,cursorNuevo,referencia);
	}
// 	function copiarTablaAccesoriosArticulos(nuevaReferencia:String):Boolean {
// 		return this.ctx.fluxEcommerce_copiarTablaAccesoriosArticulos(nuevaReferencia);
// 	}
	function copiarAccesoriosArticulo(refOriginal:String, refNueva:String):Number {
		return this.ctx.fluxEcommerce_copiarAccesoriosArticulo(refOriginal, refNueva);
	}
	function datosAccesorioArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean {
		return this.ctx.fluxEcommerce_datosAccesorioArticulo(cursorOrigen, campo);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration etiArticulo */
/////////////////////////////////////////////////////////////////
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
class etiArticulo extends fluxEcommerce {
	var tbnEtiquetas:Object;
    function etiArticulo( context ) { fluxEcommerce ( context ); }
	function init() {
		return this.ctx.etiArticulo_init();
	}
	function imprimirEtiquetas() {
		return this.ctx.etiArticulo_imprimirEtiquetas();
	}
}
//// ETIQUETAS DE ARTÍCULOS /////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition actPrecios */
/////////////////////////////////////////////////////////////////
//// ACT_PRECIOS //////////////////////////////////////////////////

function actPrecios_init()
{
	this.iface.tableDBRecords = this.child("tableDBRecords")
	connect(this.child("pbnImportar"), "clicked()", this, "iface.importar");

	this.iface.__init();
}

function actPrecios_importar()
{
	var util:FLUtil = new FLUtil();

	var res:Object = MessageBox.information(util.translate("scripts",  "Van a realizarse el proceso de importación. Esta acción no podrá deshacerse.\nEs aconsejable tener copias de seguridad en su base de datos antes de proceder.\n\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes) return;

	this.iface.corr = [];
	this.iface.pos = [];
	this.iface.arrayNomCampos = [];

	var fichero:String = FileDialog.getOpenFileName( util.translate( "scripts", "Texto CSV (precios.csv)" ), util.translate( "scripts", "Elegir fichero de artículos" ) );

	if (!fichero) return;
	if ( !File.exists( fichero ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return ;
	}

	var file = new File( fichero );
	file.open( File.ReadOnly );

	var encabezados:String = file.readLine();

	if (!this.iface.comprobarFichero(encabezados))
		return false;

	this.iface.crearCorrespondencias();
	this.iface.crearPosiciones(encabezados);

	if (!encabezados) {
		MessageBox.information( util.translate( "scripts", "El fichero está vácío" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return ;
	}

	var arrayLineas = this.iface.preprocesarFichero(this.iface.tablaDestino, file, this.iface.pos["REF"], encabezados);

	var curTab:FLSqlCursor = new FLSqlCursor(this.iface.tablaDestino);
	var referencia:String;
	var pvp:Number;
	var actualizados:Number = 0;
	var creados:Number = 0;
	var faltanFila:Number = 0;
	var faltan:String = "";

	util.createProgressDialog( util.translate( "scripts", "Actualizando precios..." ), arrayLineas.length);

	for (var i:Number = 0; i < arrayLineas.length; i++) {
		linea = arrayLineas[i];
		campos = linea.split(this.iface.sep);
		referencia = campos[this.iface.pos["REF"]];

		curTab.select( this.iface.whereTablaDestino( linea ) );

		// Edición
		if (curTab.first()) {
			actualizados++;
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
 		}
		// No existe
		else {
			if ( this.iface.crearSiNoExiste ) {
				creados++;
				curTab.setModeAccess(curTab.Insert);
				curTab.refreshBuffer();
			} else {
				faltan += referencia + " ";
				faltanFila++;
				// 5 por fila
				if (faltanFila == 5) {
					faltan += "\n";
					faltanFila = 0;
				}
				util.setProgress(i);
				continue;
			}
		}

		for (var j:Number = 0; j < this.iface.arrayNomCampos.length; j++) {
			nomCampo = this.iface.arrayNomCampos[j];
			// Control de campos numéricos cuando el dato está vacío
			tipoCampo = curTab.fieldType(this.iface.corr[nomCampo]);
			if (tipoCampo >= 17 && tipoCampo <= 19)
				if (!campos[this.iface.pos[nomCampo]])
					campos[this.iface.pos[nomCampo]] = 0;
				else {
					valor = campos[this.iface.pos[nomCampo]];
					valor = valor.toString().replace(",",".");
					campos[this.iface.pos[nomCampo]] = valor;
				}

			curTab.setValueBuffer(this.iface.corr[nomCampo], campos[this.iface.pos[nomCampo]]);
		}
		if (!curTab.commitBuffer())
			debug("Error al actualizar/crear el artículo " + referencia + " en la línea válida " + i);

		util.setProgress(i);
	}

	util.destroyProgressDialog();

	var util:FLUtil = new FLUtil();
	MessageBox.information( util.translate( "scripts", "Se actualizaron los precios de %0 artículos.\n\nSe crearon los precios de %1 articulos.").arg(actualizados).arg(creados), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );

	if (faltan)
		MessageBox.information( util.translate( "scripts", "Los siguientes artículos no se encuentran registrados:\n\n%0\n\nPuede crearlos y repetir la actualización").arg(faltan), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );

}

/** \D
Indica la clausula where necesaria para determinar si existe el registro destino para la linea de texto pasada
@param	linea	Linea de texto del fichero correspondiente a un registro
\end */
function actPrecios_whereTablaDestino( linea:String ):String {
	var campos:Array = linea.split(this.iface.sep);
	var referencia:String = campos[this.iface.pos["REF"]];
	var where:String = "referencia = '" + referencia + "'";

	return where;
}

/** \D Recorre el fichero buscando registros existentes y devuelve un
array con los registros a importar
@param posClaveFich Posición del campo clave en el fichero
*/
function actPrecios_preprocesarFichero(tabla:String, file, posClaveFich:String, encabezados:String):Array
{
	var arrayLineas:Array = [];

	var i:Number = 0;
	var j:Number = 0;
	var bufferLinea:String;
	var arrayBuffer = [];

	var campos:Array = encabezados.split(this.iface.sep);
	var numCampos:Number = campos.length;
	var campoClave:String;
	var numLineas:Number = 0;

	var util:FLUtil = new FLUtil();
	var paso:Number = 0;
	util.createProgressDialog( util.translate( "scripts", "Preprocesando datos..." ), 30);

	while ( !file.eof ) {
		linea = this.iface.leerLinea(file, numCampos);
		campos = linea.split(this.iface.sep);
		campoClave = campos[posClaveFich];
		if (!campoClave || campoClave.toString().length < 2 ) continue;

		if (campos.length != numCampos) {
			debug("Se ignora la línea " + parseInt(numLineas - 1) + ". No contiene un registro válido")
			continue;
		}

		arrayLineas[numLineas++] = linea;
		util.setProgress(paso++);
		if (paso == 29)
			paso = 1;
	}
	util.destroyProgressDialog();

	file.close();

	return arrayLineas;
}

function actPrecios_leerLinea(file, numCampos):String
{
	var regExp:RegExp = new RegExp( "\"" );
	regExp.global = true;

	contCampos = 0;
	var linea:String = "";

	while (contCampos < numCampos) {
		bufferLinea = file.readLine().replace( regExp, "" );
		if (bufferLinea.length < 2 || bufferLinea.left(1) == "#") continue;
		linea += bufferLinea;
		arrayBuffer = bufferLinea.split(this.iface.sep);
		contCampos += arrayBuffer.length;
	}

	// Eliminamos el salto de línea
	if (linea.charCodeAt( linea.length - 1 ) == 10)
		linea = linea.left(linea.length - 1);

	return linea;
}

function actPrecios_crearCorrespondencias()
{
	this.iface.arrayNomCampos = new Array("REF","PVP");

	this.iface.corr["REF"] = "referencia";
	this.iface.corr["PVP"] = "pvp";
}

/** Crea un array con las posiciones de los nombres de campos en el fichero
@param cabeceras String con la primera línea del fichero que contiene las cabeceras
*/
function actPrecios_crearPosiciones(cabeceras:String)
{
	// Eliminar el retorno de carro
	cabeceras = cabeceras.left(cabeceras.length - 1);

	var campos = cabeceras.split(this.iface.sep);
	var campo:String;

	for (var i:Number = 0; i < campos.length; i++) {
		campo = campos[i];
		campo = campo.toString();
		this.iface.pos[campo] = i;
	}
}

/** Comprueba que la primera línea del fichero contiene un campo REF y un PVP
@param cabeceras String con la primera línea del fichero que contiene las cabeceras
*/
function actPrecios_comprobarFichero(cabeceras:String)
{
	var util:FLUtil = new FLUtil();

	// Eliminar el retorno de carro
	cabeceras = cabeceras.left(cabeceras.length - 1);

	var campos = cabeceras.split(this.iface.sep);
	var campo:String;
	var ref:Boolean = false;
	var pvp:Boolean = false;

	for (var i:Number = 0; i < campos.length; i++) {
		campo = campos[i];
		if (campo == "REF")
			ref = true;
		if (campo == "PVP")
			pvp = true;
	}

	if (!ref || !pvp) {
		MessageBox.critical( util.translate( "scripts", "El fichero no es válido.\nLa primera línea debe contener los campos REF (referencia) y PVP (precio)"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return false;
	}

	return true;
}


//// ACT_PRECIOS /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_init()
{
	if (this.cursor().mainFilter().startsWith("1 = 1")) {debug("setAction");
		this.cursor().setAction("articuloscomponente");
	}

	this.iface.tbnActualizarVariable = this.child("tbnActualizarVariable");
	connect(this.iface.tbnActualizarVariable,"clicked()", this, "iface.actualizarVariables_clicked()");

	if (!this.iface.__init()) {
		return false;
	}
	return true;
}

function articuloscomp_copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean
{
	if (!this.iface.__copiarAnexosArticulo(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarTiposOpcionArticulo(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarTablaArticulosComp(refOriginal, refNueva)) {
		return false;
	}
	return true;
}

function articuloscomp_copiarTablaArticulosComp(refOrigen:String, refNueva:String):Boolean
{
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("articuloscomp");
	q.setSelect("id");
	q.setFrom("articuloscomp");
	q.setWhere("refcompuesto = '" + refOrigen + "'");

	if (!q.exec()) {
		return false;
	}
	while (q.next()) {
		if (!this.iface.copiarArticuloComp(q.value("id"), refNueva)) {
			return false;
		}
	}

	return true;
}

function articuloscomp_copiarTiposOpcionArticulo(refOrigen:String, refNueva:String):Boolean
{
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("tiposopcionartcomp");
	q.setSelect("idtipoopcionart");
	q.setFrom("tiposopcionartcomp");
	q.setWhere("referencia= '" + refOrigen + "'");

	if (!q.exec()) {
		return false;
	}
	while (q.next()) {
		if (!this.iface.copiarTipoOpcionArticulo(q.value("idtipoopcionart"), refNueva)) {
			return false;
		}
	}

	return true;
}

// function articuloscomp_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean
// {
// 	if (!this.iface.__datosArticulo(cursor,referencia))
// 		return false;
//
// 	var codUnidad:String = this.iface.curArticulo.valueBuffer("codunidad");
// 	if (codUnidad)
// 		cursor.setValueBuffer("codunidad",codUnidad);
//
// 	return true;
// }

function articuloscomp_copiarArticuloComp(id:Number, refNueva:String):Number
{
	var util:FLUtil = new FLUtil;
	var curArticuloCompOrigen:FLSqlCursor = new FLSqlCursor("articuloscomp");
	curArticuloCompOrigen.select("id = " + id);
	if (!curArticuloCompOrigen.first()) {
		return false;
	}
	curArticuloCompOrigen.setModeAccess(curArticuloCompOrigen.Browse);
	curArticuloCompOrigen.refreshBuffer();

	if (!this.iface.curArticuloComp) {
		this.iface.curArticuloComp = new FLSqlCursor("articuloscomp");
	}
// 	var curArticuloCompNuevo:FLSqlCursor = new FLSqlCursor("articuloscomp");
	this.iface.curArticuloComp.setModeAccess(this.iface.curArticuloComp.Insert);
	this.iface.curArticuloComp.refreshBuffer();
	this.iface.curArticuloComp.setValueBuffer("refcompuesto", refNueva);

	var campos:Array = util.nombreCampos("articuloscomp");
	var totalCampos:Number = campos[0];
	for (var i:Number = 1; i <= totalCampos; i++) {
		if (!this.iface.datosArticuloComp(curArticuloCompOrigen, campos[i])) {
			return false;
		}
	}
// 	if (!this.iface.datosArticuloComp(curArticuloComp,curArticuloCompNuevo,referencia))
// 		return false;

	if (!this.iface.curArticuloComp.commitBuffer()) {
		return false;
	}
	var idNuevo:Number = this.iface.curArticuloComp.valueBuffer("id");

	return idNuevo;
}

function articuloscomp_copiarTipoOpcionArticulo(id:Number, refNueva:String):Number
{
	var util:FLUtil = new FLUtil;

	var curTipoOpcionArtOrigen:FLSqlCursor = new FLSqlCursor("tiposopcionartcomp");
	curTipoOpcionArtOrigen.select("idtipoopcionart = " + id);
	if (!curTipoOpcionArtOrigen.first()) {
		return false;
	}
	curTipoOpcionArtOrigen.setModeAccess(curTipoOpcionArtOrigen.Browse);
	curTipoOpcionArtOrigen.refreshBuffer();

	if (!this.iface.curTipoOpcionArt) {
		this.iface.curTipoOpcionArt = new FLSqlCursor("tiposopcionartcomp");
	}
	this.iface.curTipoOpcionArt.setModeAccess(this.iface.curTipoOpcionArt.Insert);
	this.iface.curTipoOpcionArt.refreshBuffer();
	this.iface.curTipoOpcionArt.setValueBuffer("referencia", refNueva);

	var campos:Array = util.nombreCampos("tiposopcionartcomp");
	var totalCampos:Number = campos[0];
	for (var i:Number = 1; i <= totalCampos; i++) {
		if (!this.iface.datosTipoOpcionArticulo(curTipoOpcionArtOrigen, campos[i])) {
			return false;
		}
	}
// 	if (!this.iface.datosTipoOpcionArticulo(curTipoOpcionArt, curTipoOpcionArtNuevo, referencia))
// 		return false;

	if (!this.iface.curTipoOpcionArt.commitBuffer())
		return false;

	var idNuevo:Number = this.iface.curTipoOpcionArt.valueBuffer("idtipoopcionart");

	if (!this.iface.copiarOpcionesArticulo(id, idNuevo)) {
		return false;
	}

	return idNuevo;
}

function articuloscomp_copiarOpcionesArticulo(idTipoOpcion:String, idTipoOpcionNueva:String):Boolean
{
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("opcionesarticulocomp");
	q.setSelect("idopcionarticulo");
	q.setFrom("opcionesarticulocomp");
	q.setWhere("idtipoopcionart = " + idTipoOpcion);

	if (!q.exec()) {
		return false;
	}
	while (q.next()) {
		if (!this.iface.copiarOpcionArticulo(q.value("idopcionarticulo"), idTipoOpcionNueva)) {
			return false;
		}
	}

	return true;
}

function articuloscomp_copiarOpcionArticulo(id:String, idTipoOpcionNueva:String):Number
{
	var util:FLUtil = new FLUtil;

	var curOpcionArtOrigen:FLSqlCursor = new FLSqlCursor("opcionesarticulocomp");
	curOpcionArtOrigen.select("idopcionarticulo = " + id);
	if (!curOpcionArtOrigen.first()) {
		return false;
	}
	curOpcionArtOrigen.setModeAccess(curOpcionArtOrigen.Edit);
	curOpcionArtOrigen.refreshBuffer();

	if (!this.iface.curOpcionArt) {
		this.iface.curOpcionArt = new FLSqlCursor("opcionesarticulocomp");
	}
	this.iface.curOpcionArt.setModeAccess(this.iface.curOpcionArt.Insert);
	this.iface.curOpcionArt.refreshBuffer();
	this.iface.curOpcionArt.setValueBuffer("idtipoopcionart", idTipoOpcionNueva);

	var campos:Array = util.nombreCampos("opcionesarticulocomp");
	var totalCampos:Number = campos[0];
	for (var i:Number = 1; i <= totalCampos; i++) {
		if (!this.iface.datosOpcionArticulo(curOpcionArtOrigen, campos[i])) {
			return false;
		}
	}
// 	if (!this.iface.datosOpcionArticulo(curOpcionArt, curOpcionArtNuevo, idTipoOpcionNueva))
// 		return false;

	if (!this.iface.curOpcionArt.commitBuffer()) {
		return false;
	}
	var idNuevo:Number = this.iface.curOpcionArt.valueBuffer("idopcionarticulo");

	return idNuevo;
}


function articuloscomp_datosArticuloComp(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "refcompuesto": {
			return true;
			break;
		}
		case "idtipoopcionart": {
			var idTipoOpcion:String = util.sqlSelect("tiposopcionartcomp", "idtipoopcion", "idtipoopcionart = " + cursorOrigen.valueBuffer("idtipoopcionart"));
			var idTipoOpcionArt:String;
			if (idTipoOpcion) {
				idTipoOpcionArt = util.sqlSelect("tiposopcionartcomp", "idtipoopcionart", "referencia = '" + this.iface.curArticuloComp.valueBuffer("refcompuesto") + "' AND idtipoopcion = " + idTipoOpcion);
				if (idTipoOpcionArt && idTipoOpcionArt != "") {
					this.iface.curArticuloComp.setValueBuffer("idtipoopcionart", idTipoOpcionArt);
				}
			}
			break;
		}
		case "idopcionarticulo": {
			if (this.iface.curArticuloComp.isNull("idtipoopcionart")) {
				if (!this.iface.datosArticuloComp(cursorOrigen, "idtipoopcionart")) {
					return false;
				}
			}
			var idOpcion:String = util.sqlSelect("opcionesarticulocomp", "idopcion", "idopcionarticulo = " + cursorOrigen.valueBuffer("idopcionarticulo"));
			if (idOpcion) {
				var idTipoOpcionArt:String = this.iface.curArticuloComp.valueBuffer("idtipoopcionart");
				var idOpcionArt:String = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + idTipoOpcionArt + " AND idopcion = " + idOpcion);
				if (idOpcionArt && idOpcionArt != "") {
					this.iface.curArticuloComp.setValueBuffer("idopcionarticulo", idOpcionArt);
				}
			}
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curArticuloComp.setNull(campo);
			} else {
				this.iface.curArticuloComp.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;


// 	this.iface.curArticuloComp.setValueBuffer("refcompuesto", referencia);
// 	cursorNuevo.setValueBuffer("refcomponente", cursor.valueBuffer("refcomponente"));
// 	cursorNuevo.setValueBuffer("desccomponente", cursor.valueBuffer("desccomponente"));
// 	cursorNuevo.setValueBuffer("cantidad", cursor.valueBuffer("cantidad"));
// 	cursorNuevo.setValueBuffer("codunidad", cursor.valueBuffer("codunidad"));
//
// 	var idTipoOpcion:String = util.sqlSelect("tiposopcionartcomp", "idtipoopcion", "idtipoopcionart = " + cursor.valueBuffer("idtipoopcionart"));
// 	var idTipoOpcionArt:String;
// 	if (idTipoOpcion) {
// 		idTipoOpcionArt = util.sqlSelect("tiposopcionartcomp", "idtipoopcionart", "referencia = '" + cursorNuevo.valueBuffer("refcompuesto") + "' AND idtipoopcion = " + idTipoOpcion);
// 		if (idTipoOpcionArt && idTipoOpcionArt != "") {
// 			cursorNuevo.setValueBuffer("idtipoopcionart", idTipoOpcionArt);
// 		}
// 	}
// 	var idOpcion:String = util.sqlSelect("opcionesarticulocomp", "idopcion", "idopcionarticulo = " + cursor.valueBuffer("idopcionarticulo"));
// 	if (idOpcion) {
// 		var idOpcionArt:String = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + idTipoOpcionArt + " AND idopcion = " + idOpcion);
// 		if (idOpcionArt && idOpcionArt != "") {
// 			cursorNuevo.setValueBuffer("idopcionarticulo", idOpcionArt);
// 		}
// 	}
	//cursorNuevo.setValueBuffer("idopcionarticulo", cursor.valueBuffer("idopcionarticulo"));

// 	return true;
}

function articuloscomp_datosTipoOpcionArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "idtipoopcionart":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curTipoOpcionArt.setNull(campo);
			} else {
				this.iface.curTipoOpcionArt.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;

// 	cursorNuevo.setValueBuffer("referencia", referencia);
// 	cursorNuevo.setValueBuffer("idtipoopcion", cursor.valueBuffer("idtipoopcion"));
// 	cursorNuevo.setValueBuffer("tipo", cursor.valueBuffer("tipo"));

// 	return true;
}

function articuloscomp_datosOpcionArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "idopcionarticulo":
		case "idtipoopcionart": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curOpcionArt.setNull(campo);
			} else {
				this.iface.curOpcionArt.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;

// 	cursorNuevo.setValueBuffer("idtipoopcionart", idTipoOpcion);
// 	cursorNuevo.setValueBuffer("idopcion", cursor.valueBuffer("idopcion"));
// 	cursorNuevo.setValueBuffer("opcion", cursor.valueBuffer("opcion"));
// 	cursorNuevo.setValueBuffer("valordefecto", cursor.valueBuffer("valordefecto"));
//
// 	return true;
}

function articuloscomp_actualizarVariables_clicked()
{
	var util:FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	cursor.transaction(false);

	try {
		if (this.iface.actualizarVariables()) {
			cursor.commit();
		}
		else {
			cursor.rollback();
			return false;
		}
	}
	catch (e) {
		cursor.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error al actualizar la propiedad variable de los artículos:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	MessageBox.information(util.translate("scripts", "Los artículos se actualizaron correctamente"), MessageBox.Ok, MessageBox.NoButton);
}

function articuloscomp_actualizarVariables():Boolean
{
	var util:FLUtil;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("articulos");
	q.setSelect("referencia");
	q.setFrom("articulos");
	q.setWhere("1 = 1");

	if (!q.exec())
		return false;

	util.createProgressDialog( util.translate( "scripts", "Actualizando propiedad Variable ..." ), q.size());

	var progress:Number = 0;
	var variable:Boolean;
	while (q.next()) {
		util.setProgress(progress++);
		variable = false;
		if(formRecordarticulos.iface.pub_esArticuloVariable(q.value("referencia"))) {
			variable = true;
		}

		if(!util.sqlUpdate("articulos","variable",variable,"referencia = '" + q.value("referencia") + "'"))
			return false;
	}

	util.destroyProgressDialog();
	return true;
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pesosMedidas */
/////////////////////////////////////////////////////////////////
//// PESOSMEDIDAS ///////////////////////////////////////////////
// function pesosMedidas_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean
// {
// 	if (!this.iface.__datosArticulo(cursor,referencia))
// 		return false;
//
// 	cursor.setValueBuffer("codunidad",this.iface.curArticulo.valueBuffer("codunidad"));
//
// 	return true;
// }
//// PESOSMEDIDAS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVAINCLUIDO ////////////////////////////////////////////////
function ivaIncluido_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean
{
	if (!this.iface.__datosArticulo(cursor,referencia))
		return false

	cursor.setValueBuffer("ivaincluido",this.iface.curArticulo.valueBuffer("ivaincluido"));

	return true;
}
//// IVAINCLUIDO ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE /////////////////////////////////////////////

// function fluxEcommerce_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean
// {
// 	if (!this.iface.__datosArticulo(cursor,referencia))
// 		return false
//
// 	cursor.setValueBuffer("codfabricante",this.iface.curArticulo.valueBuffer("codfabricante"));
// 	cursor.setValueBuffer("publico",this.iface.curArticulo.valueBuffer("publico"));
// 	cursor.setValueBuffer("descpublica",this.iface.curArticulo.valueBuffer("descpublica"));
// 	cursor.setValueBuffer("fechapub",this.iface.curArticulo.valueBuffer("fechapub"));
// 	cursor.setValueBuffer("fechaimagen",this.iface.curArticulo.valueBuffer("fechaimagen"));
// 	cursor.setValueBuffer("codplazoenvio",this.iface.curArticulo.valueBuffer("codplazoenvio"));
// 	cursor.setValueBuffer("enportada",this.iface.curArticulo.valueBuffer("enportada"));
// 	cursor.setValueBuffer("ordenportada",this.iface.curArticulo.valueBuffer("ordenportada"));
// 	cursor.setValueBuffer("enoferta",this.iface.curArticulo.valueBuffer("enoferta"));
// 	cursor.setValueBuffer("codtarifa",this.iface.curArticulo.valueBuffer("codtarifa"));
// 	cursor.setValueBuffer("pvpoferta",this.iface.curArticulo.valueBuffer("pvpoferta"));
// 	cursor.setValueBuffer("pvpoferta",this.iface.curArticulo.valueBuffer("pvpoferta"));
// 	cursor.setValueBuffer("tipoimagen",this.iface.curArticulo.valueBuffer("tipoimagen"));
// 	cursor.setValueBuffer("modificado",this.iface.curArticulo.valueBuffer("modificado"));
//
// 	return true;
// }

function fluxEcommerce_copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean
{
	if (!this.iface.__copiarAnexosArticulo(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarAtributosArticulo(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarAccesoriosArticulo(refOriginal, refNueva)) {
		return false;
	}
	return true;
}

// function fluxEcommerce_copiarTablaAtributosArticulos(refOriginal:String, refNueva:String):Boolean
// {
// 	var q:FLSqlQuery = new FLSqlQuery();
// 	q.setTablesList("atributosart");
// 	q.setSelect("id");
// 	q.setFrom("atributosart");
// 	q.setWhere("referencia = '" + refOriginal + "'");
//
// 	if (!q.exec()) {
// 		return false;
// 	}
// 	while (q.next()) {
// 		if (!this.iface.copiarAtributosArticulo(q.value("id"), refNueva)) {
// 			return false;
// 		}
// 	}
//
// 	return true;
// }

function fluxEcommerce_copiarAtributosArticulo(refOriginal:String, refNueva:String):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curAtributoArticulo) {
		this.iface.curAtributoArticulo = new FLSqlCursor("atributosart");
	}

	var campos:Array = util.nombreCampos("atributosart");
	var totalCampos:Number = campos[0];

	var curAtributoArticuloOrigen:FLSqlCursor = new FLSqlCursor("atributosart");
	curAtributoArticuloOrigen.select("referencia = '" + refOriginal + "'");
	while (curAtributoArticuloOrigen.next()) {
		this.iface.curAtributoArticulo.setModeAccess(this.iface.curAtributoArticulo.Insert);
		this.iface.curAtributoArticulo.refreshBuffer();
		this.iface.curAtributoArticulo.setValueBuffer("referencia", refNueva);

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosAtributoArticulo(curAtributoArticuloOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curAtributoArticulo.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function fluxEcommerce_datosAtributoArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curAtributoArticulo.setNull(campo);
			} else {
				this.iface.curAtributoArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;
}
// 	cursorNuevo.setValueBuffer("referencia",referencia);
// 	cursorNuevo.setValueBuffer("codatributo",cursor.valueBuffer("codatributo"));
// 	cursorNuevo.setValueBuffer("valor",cursor.valueBuffer("valor"));
// 	cursorNuevo.setValueBuffer("modificado",cursor.valueBuffer("modificado"));
//
// 	return true;
// }

// function fluxEcommerce_copiarTablaAccesoriosArticulos(nuevaReferencia:String):Boolean
// {
// 	var q:FLSqlQuery = new FLSqlQuery();
// 	q.setTablesList("accesoriosart");
// 	q.setSelect("id");
// 	q.setFrom("accesoriosart");
// 	q.setWhere("referenciappal = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");
//
// 	if (!q.exec())
// 		return false;
//
// 	while (q.next()) {
// 		if (!this.iface.copiarAccesoriosArticulo(q.value("id"),nuevaReferencia))
// 			return false;
// 	}
//
// 	return true;
// }

function fluxEcommerce_copiarAccesoriosArticulo(refOriginal:String, refNueva:String):Number
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curAccesorioArticulo) {
		this.iface.curAccesorioArticulo = new FLSqlCursor("accesoriosart");
	}

	var campos:Array = util.nombreCampos("accesoriosart");
	var totalCampos:Number = campos[0];

	var curAccesorioArticuloOrigen:FLSqlCursor = new FLSqlCursor("accesoriosart");
	curAccesorioArticuloOrigen.select("referenciappal = '" + refOriginal + "'");
	while (curAccesorioArticuloOrigen.next()) {
		this.iface.curAccesorioArticulo.setModeAccess(this.iface.curAccesorioArticulo.Insert);
		this.iface.curAccesorioArticulo.refreshBuffer();
		this.iface.curAccesorioArticulo.setValueBuffer("referenciappal", refNueva);

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosAccesorioArticulo(curAccesorioArticuloOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curAccesorioArticulo.commitBuffer()) {
			return false;
		}
	}

	return true;

// 	var curAccesorioArticulo:FLSqlCursor = new FLSqlCursor("accesoriosart");
// 	curAccesorioArticulo.select("id = " + id);
// 	if (!curAccesorioArticulo.first())
// 		return false;
// 	curAccesorioArticulo.setModeAccess(curAccesorioArticulo.Edit);
// 	curAccesorioArticulo.refreshBuffer();
//
// 	var curAccesorioArticuloNuevo:FLSqlCursor = new FLSqlCursor("accesoriosart");
// 	curAccesorioArticuloNuevo.setModeAccess(curAccesorioArticuloNuevo.Insert);
// 	curAccesorioArticuloNuevo.refreshBuffer();
//
// 	if (!this.iface.datosAccesorioArticulo(curAccesorioArticulo,curAccesorioArticuloNuevo,referencia))
// 		return false;
//
// 	if (!curAccesorioArticuloNuevo.commitBuffer())
// 		return false;
//
// 	var idNuevo:Number = curAccesorioArticuloNuevo.valueBuffer("id");
//
// 	return idNuevo;
}

function fluxEcommerce_datosAccesorioArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referenciappal": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curAccesorioArticulo.setNull(campo);
			} else {
				this.iface.curAccesorioArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;

// 	cursorNuevo.setValueBuffer("referenciappal",referencia);
// 	cursorNuevo.setValueBuffer("referenciaacc",cursor.valueBuffer("referenciaacc"));
// 	cursorNuevo.setValueBuffer("orden",cursor.valueBuffer("orden"));
// 	cursorNuevo.setValueBuffer("modificado",cursor.valueBuffer("modificado"));
//
// 	return true;
}
//// FLUX ECOMMERCE /////////////////////////////////////////////
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

