
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends oficial /** %from: oficial */ {
	var COL_REFERENCIA:Number;
	var COL_DESCRIPCION:Number;
	var COL_CANTIDAD:Number;
	var COL_UNIDAD:Number;

	var curComponente_:FLSqlCursor;
	var lvwComponentes:Object;
	var lvwCompuestos:Object;
	var componenteSeleccionado:FLListViewItem;
	var compuestoSeleccionado:FLListViewItem;
	var raizComponente:FLListViewItem;
	var raizCompuesto:FLListViewItem;
	//var arrayNodos:Array;
	//var indice:Number;
	var curArticulosComp_:FLSqlCursor;
	var referenciaComp_:String;
	var idTipoOpcionArt_:String;
	var opcionesActuales:Array;
	var expansiones:Array;
	function articuloscomp( context ) { oficial ( context ); }
	function init() {
		this.ctx.articuloscomp_init();
	}
	function calcularPvp() {
		return this.ctx.articuloscomp_calcularPvp();
	}
	function pintarNodo(nodo:FLListViewItem,tipoNodo:String) {
		return this.ctx.articuloscomp_pintarNodo(nodo,tipoNodo);
	}
	function pintarNodosHijo(nodo:FLListViewItem, tipoNodo:String, idOpcion:String):Boolean {
		return this.ctx.articuloscomp_pintarNodosHijo(nodo, tipoNodo, idOpcion);
	}
	function buscarNodo(clave:String, padre) {
		return this.ctx.articuloscomp_buscarNodo(clave, padre);
	}
	function insertArticuloComp() {
		return this.ctx.articuloscomp_insertArticuloComp();
	}
	function editArticuloComp() {
		return this.ctx.articuloscomp_editArticuloComp();
	}
	function editTipoOpcion(clave:String) {
		return this.ctx.articuloscomp_editTipoOpcion(clave);
	}
	function editArticulo() {
		return this.ctx.articuloscomp_editArticulo();
	}
	function browseArticulo() {
		return this.ctx.articuloscomp_browseArticulo();
	}
	function deleteArticulo() {
		return this.ctx.articuloscomp_deleteArticulo();
	}
	function browseArticuloComp() {
		return this.ctx.articuloscomp_browseArticuloComp();
	}
	function browseArticuloCompuestos() {
		return this.ctx.articuloscomp_browseArticuloCompuestos();
	}
	function deleteArticuloComp() {
		return this.ctx.articuloscomp_deleteArticuloComp();
	}
	function cambiarSeleccionComponentes(item:FLListViewItem) {
		return this.ctx.articuloscomp_cambiarSeleccionComponentes(item);
	}
	function cambiarSeleccionCompuestos(item:FLListViewItem) {
		return this.ctx.articuloscomp_cambiarSeleccionCompuestos(item);
	}
	function crearArbolComponentes() {
		return this.ctx.articuloscomp_crearArbolComponentes();
	}
	function crearArbolCompuestos() {
		return this.ctx.articuloscomp_crearArbolCompuestos();
	}
	function establecerDatosNodo(nodo:FLListViewItem,datos:Array) {
		return this.ctx.articuloscomp_establecerDatosNodo(nodo,datos);
	}
	function establecerOpcionNodo(nodo:FLListViewItem, datos:Array) {
		return this.ctx.articuloscomp_establecerOpcionNodo(nodo, datos);
	}
// 	function buscarNodos(codigo:String,raiz:FLListViewItem,refPadre:String) {
// 		return this.ctx.articuloscomp_buscarNodos(codigo,raiz,refPadre);
// 	}
// 	function buscarSiguienteNodo(codigo:String,raiz:FLListViewItem,refPadre:String) {
// 		return this.ctx.articuloscomp_buscarSiguienteNodo(codigo,raiz,refPadre);
// 	}
	function calcularDatosNodoComponente(referencia:String, idOpcionArticulo:String):Array {
		return this.ctx.articuloscomp_calcularDatosNodoComponente(referencia, idOpcionArticulo);
	}
	function calcularOpcionesNodoComponente(referencia:String):Array {
		return this.ctx.articuloscomp_calcularOpcionesNodoComponente(referencia);
	}
	function calcularDatosNodoCompuesto(referencia:String):Array {
		return this.ctx.articuloscomp_calcularDatosNodoCompuesto(referencia);
	}
	function refrescarArbol() {
		return this.ctx.articuloscomp_refrescarArbol();
	}
	function borrarArticulo(referencia:String,id:Number):Boolean {
		return this.ctx.articuloscomp_borrarArticulo(referencia,id);
	}
	function refrescarNodos() {
		return this.ctx.articuloscomp_refrescarNodos();
	}
	function siguienteOpcion_clicked() {
		return this.ctx.articuloscomp_siguienteOpcion_clicked();
	}
	function buscarOpcionActual(idTipoOpcionArt:Number):String {
		return this.ctx.articuloscomp_buscarOpcionActual(idTipoOpcionArt);
	}
	function cambiarOpcionActual(idTipoOpcionArt:Number, valor:Number):Boolean {
		return this.ctx.articuloscomp_cambiarOpcionActual(idTipoOpcionArt, valor);
	}
	function expandido(clave:String):Boolean {
		return this.ctx.articuloscomp_expandido(clave);
	}
	function guardarExpansion(nodo:FLListViewItem) {
		return this.ctx.articuloscomp_guardarExpansion(nodo);
	}
	function guardarExpansiones() {
		return this.ctx.articuloscomp_guardarExpansiones();
	}
	function referenciaNodo(nodo:FLListViewItem):String {
		return this.ctx.articuloscomp_referenciaNodo(nodo);
	}
	function imagenComponente(idComp:String, referencia:String):String {
		return this.ctx.articuloscomp_imagenComponente(idComp, referencia);
	}
	function codigoComponente(idComp:String, referencia:String):String {
		return this.ctx.articuloscomp_codigoComponente(idComp, referencia);
	}
	function anadirComponente() {
		return this.ctx.articuloscomp_anadirComponente();
	}
	function establecerColumnas() {
		return this.ctx.articuloscomp_establecerColumnas();
	}
	function esArticuloVariable(referencia:String):Boolean {
		return this.ctx.articuloscomp_esArticuloVariable(referencia);
	}
	function tieneHijosVariables(referencia:string):Boolean {
		return this.ctx.articuloscomp_tieneHijosVariables(referencia);
	}
	function esVariable(referencia:String):Boolean {
		return this.ctx.articuloscomp_esVariable(referencia);
	}
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArticulosComp */
/////////////////////////////////////////////////////////////////
//// PUB ARTICULOS COMP /////////////////////////////////////////
class pubArticulosComp extends head /** %from: head */ {
    function pubArticulosComp( context ) { head( context ); }
	function pub_buscarOpcionActual(idTipoOpcionArt:Number):String {
		return this.buscarOpcionActual(idTipoOpcionArt);
	}
	function pub_esArticuloVariable(referencia:String):Boolean {
		return this.esArticuloVariable(referencia);
	}
}
//// PUB ARTICULOS COMP /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_init()
{
	this.iface.__init();

	var util:FLUtil;

	this.iface.establecerColumnas();
	this.iface.opcionesActuales = [];
	this.iface.expansiones = [];
	this.iface.idTipoOpcionArt_ = false;
	this.iface.lvwCompuestos = this.child("lvwCompuestos");
	this.iface.lvwComponentes = this.child("lvwComponentes");
	this.iface.refrescarArbol();


	//this.iface.arrayNodos = new Array();
	//this.iface.indice = 0;

	connect(this.child("pbnCalcularPvpComponentes"), "clicked()", this, "iface.calcularPvp()");
	connect (this.iface.lvwComponentes, "doubleClicked(FLListViewItemInterface)", this, "iface.editArticuloComp()");
	connect (this.iface.lvwComponentes, "selectionChanged(FLListViewItemInterface)", this, "iface.cambiarSeleccionComponentes()");
	connect (this.child("toolButtonZoomComponente"), "clicked()", this, "iface.browseArticuloComp()");
	connect (this.child("toolButtonEditComponente"), "clicked()", this, "iface.editArticuloComp()");
	connect (this.child("tbnAsociarComponente"), "clicked()", this, "iface.insertArticuloComp()");
	connect (this.child("tbnQuitarComponente"), "clicked()", this, "iface.deleteArticuloComp()");
	connect (this.iface.lvwCompuestos, "doubleClicked(FLListViewItemInterface)", this, "iface.browseArticuloCompuestos()");
	connect (this.iface.lvwCompuestos, "selectionChanged(FLListViewItemInterface)", this, "iface.cambiarSeleccionCompuestos()");
	connect (this.child("toolButtonZoomCompuesto"), "clicked()", this, "iface.browseArticuloCompuestos()");
	connect (this.child("tbnSiguienteOpcion"), "clicked()", this, "iface.siguienteOpcion_clicked()");

	if (this.cursor().action() == "articuloscomponente") {
		this.child("toolButtonEditArticulo").close();
		this.child("toolButtonDeleteArticulo").close();
		this.child("toolButtonZoomArticulo").close();
		this.child("toolButtonZoomComponente").close();
		this.child("tbnAsociarComponente").close();
		this.child("tbnQuitarComponente").close();
		disconnect (this.iface.lvwCompuestos, "doubleClicked(FLListViewItemInterface)", this, "iface.browseArticuloCompuestos()");
		this.child("toolButtonZoomCompuesto").close();
		if (this.cursor().modeAccess == this.cursor().Browse) {
			disconnect (this.iface.lvwComponentes, "doubleClicked(FLListViewItemInterface)", this, "iface.editArticuloComp()");
			this.child("toolButtonEditComponente").close();
		}
	}

	if (this.iface.curComponente_)
		delete this.iface.curComponente_;
	this.iface.curComponente_ = new FLSqlCursor("articulos");
	this.iface.curComponente_.setAction("articuloscomponente");

	connect (this.child("toolButtonEditArticulo"), "clicked()", this, "iface.editArticulo()");
	connect (this.iface.curComponente_, "bufferCommited()", this, "iface.refrescarArbol()");
	connect (this.child("toolButtonDeleteArticulo"), "clicked()", this, "iface.deleteArticulo()");
	connect (this.child("toolButtonZoomArticulo"), "clicked()", this, "iface.browseArticulo()");

	this.iface.curArticulosComp_ = new FLSqlCursor("articuloscomp");
	connect(this.iface.curArticulosComp_, "bufferCommited()", this, "iface.refrescarNodos");
}

function articuloscomp_refrescarArbol()
{
	this.iface.crearArbolComponentes();
	this.iface.crearArbolCompuestos();
}

function articuloscomp_crearArbolComponentes()
{
	var util:FLUtil;

	this.iface.lvwComponentes.setColumnText(0, util.translate("scripts", "Referencia"));
	this.iface.lvwComponentes.addColumn(util.translate("scripts", "Descripcion"));
	this.iface.lvwComponentes.addColumn(util.translate("scripts", "Cantidad"));
	this.iface.lvwComponentes.addColumn(util.translate("scripts", "Unidad"));

	var referencia:String = this.child("fdbReferencia").value();

	this.iface.lvwComponentes.clear();
	var raiz = new FLListViewItem(this.iface.lvwComponentes);
	var datosNodo:Array = new Array();
	datosNodo["cantidad"] = "";
	datosNodo["descripcion"] = this.child("fdbDescripcion").value();
	datosNodo["codigo"] = referencia;
	datosNodo["unidad"] = this.child("fdbCodUnidad").value();
	datosNodo["id"] = 0;
	datosNodo["tipo"] = "componente";
	datosNodo["imagen"] = util.sqlSelect("familias","imagen","codfamilia = '" + this.child("fdbCodFamilia").value() + "'");
	this.iface.establecerDatosNodo(raiz,datosNodo);
	raiz.setExpandable(false);
	this.iface.componenteSeleccionado = raiz;
	this.iface.raizComponente = raiz;
	this.iface.pintarNodo(raiz,"componente");
	raiz.setOpen(true);
}

function articuloscomp_anadirComponente()
{
	var util:FLUtil;

	var referencia:String = this.child("fdbReferencia").value();

	this.iface.lvwComponentes.clear();
	var raiz = new FLListViewItem(this.iface.lvwComponentes);
	var datosNodo:Array = new Array();
	datosNodo["cantidad"] = "";
	datosNodo["descripcion"] = this.child("fdbDescripcion").value();
	datosNodo["codigo"] = referencia;
	datosNodo["unidad"] = this.child("fdbCodUnidad").value();
	datosNodo["id"] = 0;
	datosNodo["tipo"] = "componente";
	datosNodo["imagen"] = util.sqlSelect("familias","imagen","codfamilia = '" + this.child("fdbCodFamilia").value() + "'");
	this.iface.establecerDatosNodo(raiz,datosNodo);
	raiz.setExpandable(false);
	this.iface.componenteSeleccionado = raiz;
	this.iface.raizComponente = raiz;
	this.iface.pintarNodo(raiz,"componente");
	raiz.setOpen(true);
}

function articuloscomp_crearArbolCompuestos()
{
	var util:FLUtil;

	this.iface.lvwCompuestos.setColumnText(0, util.translate("scripts", "Referencia"));
	this.iface.lvwCompuestos.addColumn(util.translate("scripts", "Descripcion"));
	this.iface.lvwCompuestos.addColumn(util.translate("scripts", "Cantidad"));
	this.iface.lvwCompuestos.addColumn(util.translate("scripts", "Unidad"));

	var referencia:String = this.child("fdbReferencia").value();

	this.iface.lvwCompuestos.clear();
	var raiz = new FLListViewItem(this.iface.lvwCompuestos);
	var datosNodo:Array = new Array;
	datosNodo["cantidad"] = "";
	datosNodo["descripcion"] = this.child("fdbDescripcion").value();
	datosNodo["codigo"] = referencia;
	datosNodo["unidad"] = this.child("fdbCodUnidad").value();
	datosNodo["id"] = 0;
	datosNodo["tipo"] = "compuesto";
	datosNodo["imagen"] = util.sqlSelect("familias","imagen","codfamilia = '" + this.child("fdbCodFamilia").value() + "'");
	this.iface.establecerDatosNodo(raiz,datosNodo);
	raiz.setExpandable(false);
	this.iface.compuestoSeleccionado = raiz;
	this.iface.raizCompuesto = raiz;
	this.iface.pintarNodo(raiz,"compuesto");
	raiz.setOpen(true);
}

function articuloscomp_pintarNodo(nodo:FLListViewItem, tipoNodo:String)
{
	var util:FLUtil;
	var referencia:String = "";
	var opcionesNodo:Array = new Array();

	if (!nodo) {
		if (tipoNodo == "componente")
			nodo = this.iface.raizComponente;
		if (tipoNodo == "compuesto")
			nodo = this.iface.raizCompuesto;
	}

	referencia = nodo.text(0);
	if (!nodo || !referencia || referencia == "")
		return;

	if (!this.iface.pintarNodosHijo(nodo, tipoNodo))
		return false;

	if (tipoNodo == "componente") {
		var opcionesNodo = this.iface.calcularOpcionesNodoComponente(referencia);
		if (!opcionesNodo)
			return false;

		var idOpcionDefecto:String;
		var idTipoOpcion:String;
		var primerHijo:Boolean = false;
		for (var i = 0; i < opcionesNodo.length; i++) {
			if (!primerHijo){
				nodo.setExpandable(true);
				if (this.iface.expandido(nodo.key()))
					nodo.setOpen(true);
				primerHijo = true;
			}
			var nodoHijo = new FLListViewItem(nodo);
			this.iface.establecerOpcionNodo(nodoHijo, opcionesNodo[i]);
			nodoHijo.setExpandable(false);

			idTipoOpcion = opcionesNodo[i]["id"];
			idOpcionDefecto = this.iface.buscarOpcionActual(idTipoOpcion);
			if (idOpcionDefecto) {
				if (!this.iface.pintarNodosHijo(nodoHijo, "componente", idOpcionDefecto))
					return false;
			}
		}
	}
	return true;
}

function articuloscomp_pintarNodosHijo(nodo:FLListViewItem, tipoNodo:String, idOpcion:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var datosNodo:Array = new Array();
	var referencia:String = this.iface.referenciaNodo(nodo);

	if (!nodo || !referencia || referencia == "")
		return;
	if (tipoNodo == "componente")
		datosNodo = this.iface.calcularDatosNodoComponente(referencia, idOpcion);

	if (tipoNodo == "compuesto")
		datosNodo = this.iface.calcularDatosNodoCompuesto(referencia);

	if (!datosNodo)
		return false;

	nodo.setExpandable(false);

	var primerHijo:Boolean = false;
	for (var i = 0; i < datosNodo.length; i++) {
		if (!primerHijo) {
			nodo.setExpandable(true);
			if (this.iface.expandido(nodo.key()))
				nodo.setOpen(true);

			primerHijo = true;
		}
		var nodoHijo = new FLListViewItem(nodo);
		this.iface.establecerDatosNodo(nodoHijo,datosNodo[i]);
		nodoHijo.setExpandable(false);
		this.iface.pintarNodo(nodoHijo,tipoNodo);
	}
	return true;
}

/** \C la referencia del artículo asociado a un nodo se obtiene:
Si el nodo corresponde a una composición normal, de la primera columna de texto del nodo
Si el nodo corresponde a un tipo de opción (el id será TO_ + id del tipo de opción), de la tabla de tipos de opción por artículo
@param	Nodo: Nodo cuya referencia queremos conocer.
@return	Referencia
\end */
function articuloscomp_referenciaNodo(nodo:FLListViewItem):String
{
	var util:FLUtil = new FLUtil;

	var clave:String = nodo.key();
	if (clave.startsWith("TO_")) {
		this.iface.idTipoOpcionArt_ = clave.right(clave.length - 3);
		referencia = util.sqlSelect("tiposopcionartcomp", "referencia", "idtipoopcionart = " + this.iface.idTipoOpcionArt_);
	} else {
		this.iface.idTipoOpcionArt_ = false;
		referencia = nodo.text(0);
	}
	return referencia;
}

function articuloscomp_buscarNodo(clave:String, padre)
{
	if (!padre)
		padre = this.iface.raizComponente;

	var nodoAux;
	var nodoHijo;
	for (nodoAux = padre.firstChild(); nodoAux; nodoAux = nodoAux.nextSibling()) {
		if (nodoAux.key() == clave)
			return nodoAux;
		if (nodoAux.isExpandable()) {
			nodoHijo = this.iface.buscarNodo(clave, nodoAux);
			if (nodoHijo)
				return nodoHijo;
		}
	}
	return false;
}

function articuloscomp_calcularDatosNodoComponente(referencia:String, idOpcionArticulo:String):Array
{
	var util:FLUtil;
	var datosNodo = new Array;

	var masWhere:String = " AND (idopcionarticulo IS NULL OR idopcionarticulo = 0)";
	if (idOpcionArticulo && idOpcionArticulo != "")
		masWhere = " AND idopcionarticulo = " + idOpcionArticulo;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("articuloscomp");
	q.setSelect("id,refcomponente,desccomponente,cantidad,codunidad");
	q.setFrom("articuloscomp");
	q.setWhere("refcompuesto = '" + referencia + "'" + masWhere);
	q.setForwardOnly(true);

debug(q.sql());
	if (!q.exec())
		return false;

	var i:Number = 0;
	while (q.next()) {
		datosNodo[i] = new Array;
		datosNodo[i]["id"] = q.value("id");
		datosNodo[i]["tipo"] = "componente";
		datosNodo[i]["codigo"] = this.iface.codigoComponente(q.value("id"), q.value("refcomponente"));
		datosNodo[i]["descripcion"] = q.value("desccomponente");
		datosNodo[i]["cantidad"] = q.value("cantidad");
		datosNodo[i]["unidad"] = q.value("codunidad");
		datosNodo[i]["imagen"] = this.iface.imagenComponente(q.value("id"), q.value("refcomponente"));
		i += 1;
	}
	return datosNodo;
}

/** \D Función a sobrecargar
\end */
function articuloscomp_codigoComponente(idComp:String, referencia:String):String
{
	var codigo = referencia;
	return codigo;
}

function articuloscomp_imagenComponente(idComp:String, referencia:String):String
{
	var util:FLUtil;
	var imagen:String = util.sqlSelect("articulos INNER JOIN familias ON articulos.codfamilia = familias.codfamilia", "familias.imagen", "articulos.referencia = '" + referencia + "'", "articulos,familias");
	return imagen;
}

function articuloscomp_calcularOpcionesNodoComponente(referencia:String):Array
{
	var util:FLUtil;
	var datosNodo = new Array;


	var qryOpciones:FLSqlQuery = new FLSqlQuery();
	qryOpciones.setTablesList("tiposopcionartcomp");
	qryOpciones.setSelect("idtipoopcionart, idtipoopcion, tipo");
	qryOpciones.setFrom("tiposopcionartcomp");
	qryOpciones.setWhere("referencia = '" + referencia + "'");
	qryOpciones.setForwardOnly(true);

	if (!qryOpciones.exec())
		return false;

	var i:Number = 0;
	while (qryOpciones.next()) {
		datosNodo[i] = new Array;
		datosNodo[i]["id"] = qryOpciones.value("idtipoopcionart");
		datosNodo[i]["tipo"] = "componente";
		datosNodo[i]["codigo"] = "Opción";
		datosNodo[i]["descripcion"] = qryOpciones.value("tipo");
		datosNodo[i]["cantidad"] = false;
		datosNodo[i]["unidad"] = false;
		datosNodo[i]["imagen"] = false;
		i += 1;
	}

	return datosNodo;
}

function articuloscomp_calcularDatosNodoCompuesto(referencia:String):Array
{
	var util:FLUtil;
	datosNodo = new Array;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("articuloscomp,articulos");
	q.setSelect("articuloscomp.id, articuloscomp.refcompuesto, articulos.descripcion, articuloscomp.cantidad, articuloscomp.codunidad");
	q.setFrom("articuloscomp INNER JOIN articulos ON articuloscomp.refcompuesto = articulos.referencia");
	q.setWhere("articuloscomp.refcomponente = '" + referencia + "'");

	if (!q.exec())
		return false;

	var i:Number = 0;
	while (q.next()) {
		datosNodo[i] = new Array;
		datosNodo[i]["id"] = q.value("articuloscomp.id");
		datosNodo[i]["tipo"] = "compuesto";
		datosNodo[i]["codigo"] = q.value("articuloscomp.refcompuesto");
		datosNodo[i]["descripcion"] = q.value("articulos.descripcion");
		datosNodo[i]["cantidad"] = q.value("articuloscomp.cantidad");
		datosNodo[i]["unidad"] = q.value("articuloscomp.codunidad");
		datosNodo[i]["imagen"] = util.sqlSelect("articulos INNER JOIN familias ON articulos.codfamilia = familias.codfamilia","familias.imagen","articulos.referencia = '" + q.value("articuloscomp.refcompuesto") + "'","articulos,familias");
		i += 1;
	}

	return datosNodo;
}


function articuloscomp_establecerDatosNodo(nodo:FLListViewItem, datos:Array)
{
	var util:FLUtil;
	if (datos["codigo"] && datos["codigo"] != "") {
		nodo.setText(this.iface.COL_REFERENCIA, datos["codigo"]);
		nodo.setPixmap(this.iface.COL_REFERENCIA, datos["imagen"]);
	}

	if(datos["descripcion"] && datos["descripcion"] != "")
		nodo.setText(this.iface.COL_DESCRIPCION, datos["descripcion"]);

	if(datos["cantidad"] && datos["cantidad"] != "")
		nodo.setText(this.iface.COL_CANTIDAD, datos["cantidad"]);

	if(datos["unidad"] && datos["unidad"] != "")
		nodo.setText(this.iface.COL_UNIDAD, datos["unidad"]);

	if(datos["id"] && datos["id"] != "")
		nodo.setKey(datos["id"]);
}

function articuloscomp_establecerOpcionNodo(nodo:FLListViewItem, datos:Array)
{
	var util:FLUtil;
	if (datos["codigo"] && datos["codigo"] != "") {
		nodo.setText(this.iface.COL_REFERENCIA, datos["codigo"]);
		nodo.setPixmap(this.iface.COL_REFERENCIA, datos["imagen"]);
	}
	var opcionActual:String = "";
	var idOpcionActual:Number = this.iface.buscarOpcionActual(datos["id"]);
	if (idOpcionActual) {
		opcionActual = util.sqlSelect("opcionesarticulocomp", "opcion", "idopcionarticulo= " + idOpcionActual);
		if (opcionActual) {
			opcionActual = " = " + opcionActual;
		} else {
			opcionActual = "";
		}
	}

	if (datos["descripcion"] && datos["descripcion"] != "")
		nodo.setText(this.iface.COL_DESCRIPCION, datos["descripcion"] + opcionActual);

	if (datos["id"] && datos["id"] != "")
		nodo.setKey("TO_" + datos["id"]);
}

function articuloscomp_buscarOpcionActual(idTipoOpcionArt:Number):String
{
	var util:FLUtil = new FLUtil;
	var valor:String;
	var tamano:Number= this.iface.opcionesActuales.length;
	for (var i:Number = 0; i < tamano; i++) {
		if (this.iface.opcionesActuales[i]["tipo"] == idTipoOpcionArt)
			return this.iface.opcionesActuales[i]["valor"];
	}

	idOpcionDefecto = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + idTipoOpcionArt);
	if (idOpcionDefecto && idOpcionDefecto != "") {
		this.iface.opcionesActuales[tamano] = [];
		this.iface.opcionesActuales[tamano]["tipo"] = idTipoOpcionArt;
		this.iface.opcionesActuales[tamano]["valor"] = idOpcionDefecto;
		valor = idOpcionDefecto;
	} else {
		valor = false;
	}
	return valor;
}

function articuloscomp_cambiarOpcionActual(idTipoOpcionArt:Number, valor:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var tamano:Number= this.iface.opcionesActuales.length;
	var ok:Boolean = false;
	for (var i:Number = 0; i < tamano; i++) {
		if (this.iface.opcionesActuales[i]["tipo"] == idTipoOpcionArt) {
			this.iface.opcionesActuales[i]["valor"] = valor;
			ok = true;
			break;
		}
	}
	return ok;
}

function articuloscomp_cambiarSeleccionComponentes(item:FLListViewItem)
{
	this.iface.componenteSeleccionado = item;
}

function articuloscomp_cambiarSeleccionCompuestos(item:FLListViewItem)
{
	this.iface.compuestoSeleccionado = item;
}

function articuloscomp_insertArticuloComp()
{
	var util:FLUtil;

	if (this.cursor().modeAccess() == this.cursor().Insert) {
		if (!this.child("tdbArticulosTarifas").cursor().commitBufferCursorRelation())
			return false;

		//this.iface.crearArbolComponentes();
		this.iface.anadirComponente();
		this.iface.crearArbolCompuestos();
	}

	if (!this.iface.componenteSeleccionado)
		return;

	var referencia:String = this.iface.referenciaNodo(this.iface.componenteSeleccionado);
	if (!referencia || referencia == "")
		return;

	this.iface.referenciaComp_ = referencia;

	disconnect(this.iface.curArticulosComp_, "bufferCommited()", this, "iface.refrescarNodos");
	delete this.iface.curArticulosComp_;
	this.iface.curArticulosComp_ = new FLSqlCursor("articuloscomp");
	connect(this.iface.curArticulosComp_, "bufferCommited()", this, "iface.refrescarNodos");

	this.iface.guardarExpansiones();
	this.iface.curArticulosComp_.insertRecord();
}

function articuloscomp_refrescarNodos()
{
	var clave:String = this.iface.componenteSeleccionado.key();
	//this.iface.crearArbolComponentes();
	this.iface.anadirComponente();
	if (clave) {
		var nodo = this.iface.buscarNodo(clave);
		if (nodo) {
			try { // setSelected publicado 01/10/07
				this.iface.lvwComponentes.setSelected(nodo, true);
				this.iface.componenteSeleccionado = nodo;
			} catch (e) {}
		} else {
			this.iface.componenteSeleccionado = this.iface.raizComponente;
		}
	}
	return;

	var util:FLUtil = new FLUtil;

// 	if (this.iface.referenciaComp_) {
// 		/// Alta de nuevo nodo
// 		if (this.iface.referenciaComp_ != this.iface.raizComponente.text(0)) {
// 			this.iface.buscarNodos(this.iface.referenciaComp_,this.iface.raizComponente,"");
// 		}
// 		else {
// 			this.iface.indice = 0;
// 			this.iface.arrayNodos[this.iface.indice] = this.iface.raizComponente;
// 			this.iface.indice += 1;
// 		}
//
// 		var datosNodo:Array = new Array;
// 		datosNodo["cantidad"] = parseFloat(this.iface.curArticulosComp_.valueBuffer("cantidad"));
// 		datosNodo["descripcion"] = this.iface.curArticulosComp_.valueBuffer("desccomponente");
// 		datosNodo["codigo"] = this.iface.curArticulosComp_.valueBuffer("refcomponente");
// 		datosNodo["unidad"] = this.iface.curArticulosComp_.valueBuffer("codunidad");
// 		datosNodo["id"] = this.iface.curArticulosComp_.valueBuffer("id");
// 		var codFamilia:String = util.sqlSelect("articulos","codfamilia","referencia = '" + this.iface.curArticulosComp_.valueBuffer("refcomponente") + "'");
// 		datosNodo["imagen"] = util.sqlSelect("familias","imagen","codfamilia = '" + codFamilia + "'");
//
// 		for (var i = 0; i < this.iface.indice; i++) {
// 			var nodoHijo = new FLListViewItem(this.iface.arrayNodos[i]);
// 			this.iface.establecerDatosNodo(nodoHijo,datosNodo);
// 			nodoHijo.setExpandable(false);
// 			this.iface.pintarNodo(nodoHijo,"componente");
// 		}
//
// 	} else {
// 		/// Modificación de nodo existente
// 		var q:FLSqlQuery = new FLSqlQuery();
// 		q.setTablesList("articuloscomp");
// 		q.setSelect("refcomponente, desccomponente, cantidad, codunidad, refcompuesto");
// 		q.setFrom("articuloscomp");
// 		q.setWhere("id = " + this.iface.curArticulosComp_.valueBuffer("id"));
//
// 		if (!q.exec())
// 			return;
//
// 		if (!q.first())
// 			return;
// 		this.iface.buscarNodos(this.iface.componenteSeleccionado.text(0), this.iface.raizComponente, this.iface.curArticulosComp_.valueBuffer("refcompuesto"));
//
// 		var datosNodo:Array = new Array;
// 		datosNodo["cantidad"] = parseFloat(q.value("cantidad"));
// 		datosNodo["descripcion"] = q.value("desccomponente");
// 		datosNodo["codigo"] = "";
// 		datosNodo["unidad"] = "";
// 		datosNodo["id"] = "";
// 		datosNodo["imagen"] = "";
//
// 		for (var i = 0; i < this.iface.indice; i++) {
// 			this.iface.establecerDatosNodo(this.iface.arrayNodos[i], datosNodo);
// 		}
// 	}
}

// function articuloscomp_buscarSiguienteNodo(codigo:String,raiz:FLListViewItem,refPadre:String)
// {
// 	var hijo:Object = raiz.firstChild();
// 	var copiar:Boolean = true;
// 	if(refPadre && refPadre != ""){
// 		if(refPadre != raiz.text(0)){
// 			copiar = false;
// 		}
// 	}
//
// 	while (hijo) {
// 		this.iface.buscarSiguienteNodo(codigo,hijo,refPadre);
// 		if (hijo.text(0) == codigo && copiar) {
// 			this.iface.arrayNodos[this.iface.indice] = hijo;
// 			this.iface.indice += 1;
// 		}
// 		hijo = hijo.nextSibling();
// 	}
// }

// function articuloscomp_buscarNodos(codigo:String,raiz:FLListViewItem,refPadre:String)
// {
// 	this.iface.indice = 0;
// 	delete this.iface.arrayNodos;
// 	this.iface.arrayNodos = new Array();
// 	this.iface.buscarSiguienteNodo(codigo,raiz,refPadre);
// }

function articuloscomp_guardarExpansiones()
{
	delete this.iface.expansiones;
	this.iface.expansiones = [];
	this.iface.guardarExpansion(this.iface.raizComponente);
}

function articuloscomp_guardarExpansion(nodo:FLListViewItem)
{
	var id:String;
	try { // isOpen publicado 01/11/07
		if (nodo.isOpen()) {
			this.iface.expansiones[this.iface.expansiones.length] = nodo.key();

			var nodoAux;
			for (nodoAux = nodo.firstChild(); nodoAux; nodoAux = nodoAux.nextSibling()) {
				this.iface.guardarExpansion(nodoAux);
			}
		}
	} catch (e) {}
}

function articuloscomp_expandido(clave:String):Boolean
{
debug(clave);
	for (var i:Number = 0; i < this.iface.expansiones.length; i++) {
		if (this.iface.expansiones[i] == clave)
			return true;
	}
	return false;
}

function articuloscomp_editArticuloComp()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;
	if (!this.iface.componenteSeleccionado)
		return;

	var clave:String = this.iface.componenteSeleccionado.key();
	if (!clave || clave == 0)
		return;
	if (clave.startsWith("TO_"))
		return this.iface.editTipoOpcion(clave);

	disconnect(this.iface.curArticulosComp_, "bufferCommited()", this, "iface.refrescarNodos");
	delete this.iface.curArticulosComp_;
	this.iface.curArticulosComp_ = new FLSqlCursor("articuloscomp");
	this.iface.curArticulosComp_.select("id = " + clave);
	if (!this.iface.curArticulosComp_.first())
		return;

	this.iface.referenciaComp_ = false;
	connect(this.iface.curArticulosComp_, "bufferCommited()", this, "iface.refrescarNodos");

	this.iface.guardarExpansiones();
	this.iface.curArticulosComp_.editRecord();
}

function articuloscomp_editTipoOpcion(clave:String)
{
	idTipoOpcionArt = clave.right(clave.length - 3);

	var curTipoOpcion:FLSqlCursor = new FLSqlCursor("tiposopcionartcomp");
	curTipoOpcion.select("idtipoopcionart = " + idTipoOpcionArt);
	if (!curTipoOpcion.first())
		return;

	curTipoOpcion.editRecord();
}

function articuloscomp_editArticulo()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;
	if (!this.iface.componenteSeleccionado)
		return;

	var clave:String = this.iface.componenteSeleccionado.key();
	if (clave.startsWith("TO_"))
		return this.iface.editTipoOpcion(clave);

	var referencia:String = this.iface.referenciaNodo(this.iface.componenteSeleccionado);
	if (!referencia || referencia == "")
		return;

	delete this.iface.curComponente_;
	this.iface.curComponente_ = new FLSqlCursor("articulos");
	this.iface.curComponente_.setAction("articuloscomponente");
	this.iface.curComponente_.select("referencia = '" + referencia + "'");
	if (!this.iface.curComponente_.first())
		return;

	this.iface.curComponente_.editRecord();
}

function articuloscomp_browseArticulo()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;
	if(!this.iface.componenteSeleccionado)
		return;

	var clave:String = this.iface.componenteSeleccionado.key();
	if (clave.startsWith("TO_"))
		return;

	var referencia:String = this.iface.referenciaNodo(this.iface.componenteSeleccionado);
	if (!referencia || referencia == "")
		return;

	delete this.iface.curComponente_;
	this.iface.curComponente_ = new FLSqlCursor("articulos");
	this.iface.curComponente_.setAction("articuloscomponente");
	this.iface.curComponente_.select("referencia = '" + referencia + "'");
	if (!this.iface.curComponente_.first())
		return;

	this.iface.curComponente_.browseRecord();
}

function articuloscomp_deleteArticulo()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;
	if (!this.iface.componenteSeleccionado)
		return;

	var clave:String = this.iface.componenteSeleccionado.key();
	if (clave.startsWith("TO_"))
		return;

	var referencia:String = this.iface.referenciaNodo(this.iface.componenteSeleccionado);
	if (!referencia || referencia == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	if (!this.iface.borrarArticulo(referencia, clave))
		return;

	this.iface.guardarExpansiones();
	this.iface.refrescarNodos();

	//var nodoPadre:Object = this.iface.componenteSeleccionado.parent();

// 	this.iface.buscarNodos(referencia,this.iface.raizComponente,nodoPadre.text(0));
// 	for (var i = 0; i < this.iface.indice; i++) {
// 		var nodoPadre:Object = this.iface.arrayNodos[i].parent();
// 		this.iface.arrayNodos[i].del();
// 		nodoPadre.setExpandable(false);
// 	}

	//this.iface.componenteSeleccionado = nodoPadre;
}

function articuloscomp_borrarArticulo(referencia:String, id:Number):Boolean
{
	var util:FLUtil;

	if (!referencia || referencia == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var res:Number = MessageBox.information(util.translate("scripts", "El artículo seleccionado será borrado ¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return false;

	if (util.sqlSelect("articuloscomp","refcomponente","refcompuesto = '" + referencia + "'")) {
		MessageBox.critical(util.translate("scripts", "El artículo seleccionado está compuesto. Antes de eliminarlo debe eliminar sus componentes"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (util.sqlSelect("articuloscomp","refcompuesto","refcomponente = '" + referencia + "' AND id <> " + id)) {
		MessageBox.warning(util.translate("scripts", "El artículo seleccionado es componente de otros artículos. Antes de eliminarlo debe eliminar estas composiciones"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if(!util.sqlDelete("articuloscomp","id = " + id)) {
		MessageBox.warning(util.translate("scripts", "Hubo un error al eliminar el artículo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlDelete("articulos", "referencia = '" + referencia + "'")) {
		MessageBox.warning(util.translate("scripts", "Hubo un error al eliminar el artículo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	MessageBox.information(util.translate("scripts", "El articulo seleccionado se eliminó correctamente"), MessageBox.Ok, MessageBox.NoButton);

	return true;
}

function articuloscomp_browseArticuloComp()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;
	if(!this.iface.componenteSeleccionado)
		return;
	var clave:Number = this.iface.componenteSeleccionado.key();
	if (!clave || clave == 0)
		return;
	if (clave.startsWith("TO_"))
		return;

	var f:Object = new FLFormSearchDB("articuloscomparbol");
	var curArticulosComp:FLSqlCursor = f.cursor();
	curArticulosComp.select("id = " + clave);
	if (!curArticulosComp.first())
		return;
	curArticulosComp.setModeAccess(curArticulosComp.Browse);
	curArticulosComp.refreshBuffer();
	f.setMainWidget();
	curArticulosComp.refreshBuffer()
	f.exec("clave");
}

function articuloscomp_browseArticuloCompuestos()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;
	if(!this.iface.compuestoSeleccionado)
		return;
	var id:Number = this.iface.compuestoSeleccionado.key();
	if (!id || id == 0)
		return;

	var f:Object = new FLFormSearchDB("articuloscomparbol");
	var curArticulosComp:FLSqlCursor = f.cursor();
	curArticulosComp.select("id = " + id);
	if (!curArticulosComp.first())
		return;
	curArticulosComp.setModeAccess(curArticulosComp.Browse);
	curArticulosComp.refreshBuffer();
	f.setMainWidget();
	curArticulosComp.refreshBuffer()
	f.exec("id");
}

function articuloscomp_deleteArticuloComp()
{
	if (this.cursor().modeAccess() == this.cursor().Insert)
		return;

	var util:FLUtil;
	if (!this.iface.componenteSeleccionado)
		return;

	var clave:String = this.iface.componenteSeleccionado.key();
	if (clave.startsWith("TO_"))
		return;

	var referencia:String = this.iface.referenciaNodo(this.iface.componenteSeleccionado);
	if (!referencia || referencia == "") {
		MessageBox.information(util.translate("scripts", "No hay ningún registro seleccionado"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var res:Number = MessageBox.information(util.translate("scripts", "Se eliminará la asociación del artículo " + referencia + ".\n¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return false;

	var nodoPadre:Object = this.iface.componenteSeleccionado.parent();
	var curArticulosComp:FLSqlCursor = new FLSqlCursor("articuloscomp");
	curArticulosComp.select("id = " + clave);
	if (!curArticulosComp.first())
		return;
	curArticulosComp.setModeAccess(curArticulosComp.Del);
	curArticulosComp.refreshBuffer();
	if(!curArticulosComp.commitBuffer())
		return;

// 	this.iface.buscarNodos(this.iface.componenteSeleccionado.text(0),this.iface.raizComponente,curArticulosComp.valueBuffer("refcompuesto"));
// 	for (var i = 0; i < this.iface.indice; i++) {
// 		var nodoPadre:Object = this.iface.arrayNodos[i].parent();
// 		this.iface.arrayNodos[i].del();
// 		nodoPadre.setExpandable(false);
// 	}
//
// 	this.iface.componenteSeleccionado = nodoPadre;

	this.iface.guardarExpansiones();
	this.iface.refrescarNodos();
}

function articuloscomp_calcularPvp()
{
	var cursor:FLSqlCursor = this.cursor();
	var total:Number = flfactalma.iface.pub_pvpCompuesto(cursor.valueBuffer("referencia"));
	cursor.setValueBuffer("pvp",total);
}

function articuloscomp_siguienteOpcion_clicked()
{
// 	var cursor:FLSqlCursor = this.cursor();
// 	var util:FLUtil = new FLUtil();
//
// debug(this.iface.componenteSeleccionado);
// 	if (!this.iface.componenteSeleccionado)
// 		return;
//
// debug(this.iface.componenteSeleccionado.key());
// 	var id:Number = this.iface.componenteSeleccionado.key();
// 	if (!id || id == 0)
// 		return;
//
// 	var referencia:String = this.iface.componenteSeleccionado.text(0);
// 	if (!referencia || referencia == "")
// 		return;
//
// 	var filtroTiposOpcion:String = "((referencia IS NULL AND codfamilia IS NULL) OR (referencia = '" + referencia + "')"
//
// 	var codFamilia:String = util.sqlSelect("articulos", "codfamilia", "referencia = '" + referencia + "'");
// 	if (codFamilia && codFamilia != "")
// 		filtroTiposOpcion += " OR (referencia IS NULL AND codfamilia = '" + codFamilia + "')";
//
// 	filtroTiposOpcion += ")";// AND idtipoopcion NOT IN (SELECT idtipoopcion FROM tiposopcionartcomp WHERE referencia = '" + referencia + "'"
//
// 	var f:Object = new FLFormSearchDB("tiposopcioncomp");
// 	var curTiposOpcion:FLSqlCursor = f.cursor();
//
// 	curTiposOpcion.setMainFilter(filtroTiposOpcion);
// 	f.setMainWidget();
//
// 	var idTipoOpcion:String = f.exec("idtipoopcion");
// 	if (!idTipoOpcion) {
// 		return false;
// 	}
// 	var tipo:String = util.sqlSelect("tiposopcioncomp", "tipo", "idtipoopcion = " + idTipoOpcion);
//
// 	if (util.sqlSelect("tiposopcionartcomp", "idtipoopcion", "referencia = '" + referencia + "' AND idtipoopcion = " + idTipoOpcion)) {
// 		MessageBox.warning(util.translate("scripts", "La opción %1 ya está asociada al artículo %2").arg(tipo).arg(referencia), MessageBox.Ok, MessageBox.NoButton);
// 		return false;
// 	}
//
// 	var ok:Boolean = false;
// 	cursor.transaction(false);
// 	try {
// 		if (!this.iface.asociarTipoOpcion(referencia, idTipoOpcion)) {
// 			cursor.rollback();
// 		} else {
// 			cursor.commit();
// 			ok = true;
// 		}
// 	} catch (e) {
// 		cursor.rollback();
// 		MessageBox.critical(util.translate("scripts", "La asociación de la opción ha fallado: ") + e, MessageBox.Ok, MessageBox.NoButton);
// 	}
// 	if (ok)
// 		this.iface.crearArbolCompuestos();

	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!this.iface.componenteSeleccionado)
		return;

	var clave:String = this.iface.componenteSeleccionado.key();
	if (!clave.startsWith("TO_"))
		return;

	var idTipoOpcionActual:Number = parseFloat(clave.right(clave.length - 3));;
	var idOpcionActual:Number = this.iface.buscarOpcionActual(idTipoOpcionActual);
	if (!idOpcionActual)
		idOpcionActual = -1;

	var idNuevaOpcion:String = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + idTipoOpcionActual + " AND idopcionarticulo > " + idOpcionActual + " ORDER BY idopcionarticulo");
	if (!idNuevaOpcion && idOpcionActual >= 0) {
		idNuevaOpcion = util.sqlSelect("opcionesarticulocomp", "idopcionarticulo", "idtipoopcionart = " + idTipoOpcionActual + " ORDER BY idopcionarticulo");
	}
	if (!idNuevaOpcion)
		return false;

	if (!this.iface.cambiarOpcionActual(idTipoOpcionActual, idNuevaOpcion))
		return false;

	this.iface.guardarExpansiones();
	this.iface.refrescarNodos();
}

function articuloscomp_establecerColumnas()
{
	this.iface.COL_REFERENCIA = 0;
	this.iface.COL_DESCRIPCION = 1;
	this.iface.COL_CANTIDAD = 2;
	this.iface.COL_UNIDAD = 3;
}

function articuloscomp_esArticuloVariable(referencia:String):Boolean
{
	var util:FLUtil;

	var variable:Boolean = false;

	if(!referencia || referencia == "")
		return false;

	if(this.iface.esVariable(referencia))
		variable = true;

	if(!variable)
		if(this.iface.tieneHijosVariables(referencia))
			variable = true;

	return variable;
}

function articuloscomp_tieneHijosVariables(referencia:string):Boolean
{
	var util:FLUtil;

	var variable:Boolean = false;
	if(!referencia || referencia == "")
		return false;

	var qryAC:FLSqlQuery = new FLSqlQuery();
	qryAC.setTablesList("articuloscomp");
	qryAC.setSelect("refcomponente");
	qryAC.setFrom("articuloscomp");
	qryAC.setWhere("refcompuesto = '" + referencia + "'");
	qryAC.exec();
	while (qryAC.next()) {
		if(this.iface.esArticuloVariable(qryAC.value("refcomponente"))) {
			variable = true;
				if(!util.sqlUpdate("articulos","variable",variable,"referencia = '" + referencia + "'"))
					return false;
		}
	}

	return variable;
}

function articuloscomp_esVariable(referencia:String):Boolean
{
	var util:FLUtil;
	if(!referencia || referencia == "")
		return false;

// 	if(util.sqlSelect("articulos","variable","referencia = '" + referencia + "'"))
// 		return true;

	if(util.sqlSelect("tiposopcionartcomp","idtipoopcionart","referencia = '" + referencia + "'"))
		return true;

	return false;
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

