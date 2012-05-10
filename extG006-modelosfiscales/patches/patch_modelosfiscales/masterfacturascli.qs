
/** @class_declaration modelos */
/////////////////////////////////////////////////////////////////
//// BASE MODELOS ///////////////////////////////////////////////
class modelos extends oficial /** %from: oficial */ {
	var tbnModelos:Object;
	function modelos( context ) { oficial ( context ); }
	function init() {
		return this.ctx.modelos_init();
	}
	function tbnModelos_clicked() {
		return this.ctx.modelos_tbnModelos_clicked();
	}
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelos_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelos_ejecutarOpcionModelo(opcion);
	}
	function obtenerOpcionModelo(arrayOps:Array):String {
		return this.ctx.modelos_obtenerOpcionModelo(arrayOps);
	}
	function configurarBotonModelos() {
		return this.ctx.modelos_configurarBotonModelos();
	}
}
//// BASE MODELOS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends modelos /** %from: modelos */ {
    function modelo347( context ) { modelos ( context ); }
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelo347_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelo347_ejecutarOpcionModelo(opcion);
	}
	function incluirExcluir347(incluir:Boolean):Boolean {
		return this.ctx.modelo347_incluirExcluir347(incluir);
	}
	function incluirExcluir347Trans(incluir:Boolean):Boolean {
		return this.ctx.modelo347_incluirExcluir347Trans(incluir);
	}
	function configurarBotonModelos() {
		return this.ctx.modelo347_configurarBotonModelos();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.modelo347_commonCalculateField(fN, cursor);
	}
	function totalesFactura():Boolean {
		return this.ctx.modelo347_totalesFactura();
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends modelo347 /** %from: modelo347 */ {
    function modelo303( context ) { modelo347 ( context ); }
	function completarOpcionesModelos(arrayOps:Array):Boolean {
		return this.ctx.modelo303_completarOpcionesModelos(arrayOps);
	}
	function ejecutarOpcionModelo(opcion:String):Boolean {
		return this.ctx.modelo303_ejecutarOpcionModelo(opcion);
	}
	function configurarBotonModelos() {
		return this.ctx.modelo303_configurarBotonModelos();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelos */
/////////////////////////////////////////////////////////////////
//// BASE MODELOS ///////////////////////////////////////////////
function modelos_init()
{
	this.iface.__init();

	this.iface.tbnModelos = this.child("tbnModelos");
	connect (this.iface.tbnModelos, "clicked()", this, "iface.tbnModelos_clicked");
	this.iface.configurarBotonModelos();
}

function modelos_tbnModelos_clicked()
{
	var arrayOpciones:Array = [];
	if (!this.iface.completarOpcionesModelos(arrayOpciones)) {
		return false;
	}
	var opcion:String = this.iface.obtenerOpcionModelo(arrayOpciones);
	if (!opcion) {
		return false;
	}
	if (!this.iface.ejecutarOpcionModelo(opcion)) {
		return false;
	}
}

function modelos_completarOpcionesModelos(arrayOps:Array):Boolean
{
// 	var i:Number = arrayOps.length;
// 	arrayOps[i] = [];
// 	arrayOps[i]["texto"] = "prueba";
// 	arrayOps[i]["opcion"] = "PB";
	return true;
}

function modelos_ejecutarOpcionModelo(opcion:String):Boolean
{
// 	debug("Opción = " + opcion);
	return true;
}

function modelos_obtenerOpcionModelo(arrayOps:Array):String
{
	var util:FLUtil = new FLUtil;
	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione opción");

	var rButton:Array = new Array(arrayOps.length);
	for (var i:Number = 0; i < rButton.length; i++) {
		rButton[i] = new RadioButton;
		rButton[i].text = arrayOps[i]["texto"];
		rButton[i].checked = false;
		gbxDialogo.add(rButton[i]);
	}

	dialogo.add(gbxDialogo);
	if (!dialogo.exec()) {
		return false;
	}
	for (var i:Number = 0; i < rButton.length; i++) {
		if (rButton[i].checked) {
			return arrayOps[i]["opcion"];
		}
	}
	return false;
}

function modelos_configurarBotonModelos()
{
	this.child("tbnModelos").close();
}

//// BASE MODELOS ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_completarOpcionesModelos(arrayOps:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var idFactura:String = cursor.valueBuffer("idfactura");
	if (!idFactura) {
		return false;
	}
	var codFactura:String = cursor.valueBuffer("codigo");
	var noModelo347:Boolean = cursor.valueBuffer("nomodelo347");
	var i:Number = arrayOps.length;
	arrayOps[i] = [];
	if (noModelo347) {
		arrayOps[i]["texto"] = util.translate("scripts", "Incluir factura %1 en modelo 347").arg(codFactura);
		arrayOps[i]["opcion"] = "347S";
	} else {
		arrayOps[i]["texto"] = util.translate("scripts", "Excluir factura %1 de modelo 347").arg(codFactura);
		arrayOps[i]["opcion"] = "347N";
	}
	return true;
}

function modelo347_ejecutarOpcionModelo(opcion:String):Boolean
{
	switch (opcion) {
		case "347S": {
			this.iface.incluirExcluir347(true);
			break;
		}
		case "347N": {
			this.iface.incluirExcluir347(false);
			break;
		}
		default: {
			this.iface.__ejecutarOpcionModelo(opcion);
		}
	}
	return true;
}

function modelo347_incluirExcluir347(incluir:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var curTrans:FLSqlCursor = new FLSqlCursor("empresa");
	curTrans.transaction(false);
	try {
		if (this.iface.incluirExcluir347Trans(incluir)) {
			curTrans.commit();
		} else {
			curTrans.rollback();
			MessageBox.warning(util.translate("scripts", "Error al incluir/excluir la factura del modelo 347"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} catch (e) {
		curTrans.rollback();
		MessageBox.critical(util.translate("scripts", "Error al incluir/excluir la factura del modelo 347: ") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	this.iface.tdbRecords.refresh();
	if (incluir) {
		MessageBox.information(util.translate("scripts", "Factura incluida correctamente"), MessageBox.Ok, MessageBox.NoButton);
	} else {
		MessageBox.information(util.translate("scripts", "Factura excluida correctamente"), MessageBox.Ok, MessageBox.NoButton);
	}
	return true;
}

function modelo347_incluirExcluir347Trans(incluir:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var idFactura:String = cursor.valueBuffer("idfactura");
	if (!idFactura) {
		return false;
	}
	if (!flfacturac.iface.pub_cambiarCampoRegistroBloqueado("facturascli", "idfactura", idFactura, "nomodelo347", !incluir, "editable")) {
		return false;
	}
	var idAsiento:String = cursor.valueBuffer("idasiento");
	if (!idAsiento) {
		return false;
	}
	if (!flfacturac.iface.pub_cambiarCampoRegistroBloqueado("co_asientos", "idasiento", idAsiento, "nomodelo347", !incluir, "editable")) {
		return false;
	}
	return true;
}

function modelo347_configurarBotonModelos()
{
	return true; //this.child("tbnModelos").close();
}

function modelo347_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		case "nomodelo347": {
			var totalIrpf:Number = parseFloat(cursor.valueBuffer("totalirpf"));
			if (totalIrpf != 0) {
				valor = true;
			} else {
				valor = false;
			}
			break;
		}
		default : {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

function modelo347_totalesFactura():Boolean
{
	if (!this.iface.__totalesFactura()) {
		return false;
	}
	with (this.iface.curFactura) {
		setValueBuffer("nomodelo347", formfacturascli.iface.pub_commonCalculateField("nomodelo347", this));
	}
	return true;
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_configurarBotonModelos()
{
	return true;
}

function modelo303_completarOpcionesModelos(arrayOps:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var i:Number = arrayOps.length;
	arrayOps[i] = [];
	if (cursor.valueBuffer("excluir303")) {
		arrayOps[i]["texto"] = util.translate("scripts", "Incluir en modelo 303");
		arrayOps[i]["opcion"] = "303IN";
	} else {
		arrayOps[i]["texto"] = util.translate("scripts", "Excluir de modelo 303");
		arrayOps[i]["opcion"] = "303EX";
	}
	return true;
}

function modelo303_ejecutarOpcionModelo(opcion:String):Boolean
{
debug("modelo303_ejecutarOpcionModelo = " + opcion);
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (opcion != "303IN" && opcion != "303EX") {
		return this.iface.__ejecutarOpcionModelo(opcion);
	}

	var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
	curFactura.setActivatedCheckIntegrity(false);
	curFactura.setActivatedCommitActions(false);
	var idFactura:String = cursor.valueBuffer("idfactura");
	curFactura.select("idfactura = " + idFactura);
	if (!curFactura.first()) {
		return false;
	}

	var editable:Boolean = curFactura.valueBuffer("editable");
	if (!editable) {
		curFactura.setUnLock("editable", true);
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
			return false;
		}
	}

	curFactura.setModeAccess(curFactura.Edit);
	curFactura.refreshBuffer();
	if (opcion == "303EX") {
		curFactura.setValueBuffer("excluir303", true);
	} else {
		curFactura.setValueBuffer("excluir303", false);
	}
	if (!curFactura.commitBuffer()) {
		return false;
	}

	if (!editable) {
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
			return false;
		}
		curFactura.setUnLock("editable", false);
	}

	if (opcion == "303EX") {
		MessageBox.information(util.translate("scripts", "La factura %1 será excluida del modelo 303").arg(cursor.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
	} else {
		MessageBox.information(util.translate("scripts", "La factura %1 será incluida en el modelo 303").arg(cursor.valueBuffer("codigo")), MessageBox.Ok, MessageBox.NoButton);
	}
	this.iface.tdbRecords.refresh();
	return true;
}

//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

