
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends pesosMedidas /** %from: oficial */ {
	var curArticuloComp:FLSqlCursor;
	var curTipoOpcionArt:FLSqlCursor;
	var curOpcionArt:FLSqlCursor;
	var tbnActualizarVariable:Object;
	function articuloscomp( context ) { pesosMedidas ( context ); }
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

