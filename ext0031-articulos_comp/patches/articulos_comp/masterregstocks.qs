
/** @class_declaration kits */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
class kits extends oficial /** %from: oficial */ {
    var tbnRevisarStock:Object;
    function kits( context ) { oficial ( context ); }
    function init() {
		return this.ctx.kits_init();
	}
	function tbnRevisarStock_clicked() {
		return this.ctx.kits_tbnRevisarStock_clicked();
	}
	function revisarStock(where:String, mostrarDialogo:Boolean):Boolean {
		return this.ctx.kits_revisarStock(where, mostrarDialogo);
	}
	function regenerarMovistock(where:String):Boolean {
		return this.ctx.kits_regenerarMovistock(where);
	}
	function regenerarMS(curStock:FLSqlCursor):Boolean {
		return this.ctx.kits_regenerarMS(curStock);
	}
	function regenerarMSPedCli(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSPedCli(referencia, codAlmacen);
	}
	function regenerarMSPedProv(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSPedProv(referencia, codAlmacen);
	}
	function regenerarMSAlbCli(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSAlbCli(referencia, codAlmacen);
	}
	function regenerarMSAlbProv(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSAlbProv(referencia, codAlmacen);
	}
	function regenerarMSFacCli(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSFacCli(referencia, codAlmacen);
	}
	function regenerarMSFacProv(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSFacProv(referencia, codAlmacen);
	}
	function regenerarMSTrans(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSTrans(referencia, codAlmacen);
	}
	function regenerarMSComTPV(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSComTPV(referencia, codAlmacen);
	}
	function regenerarMSValTPV(referencia:String, codAlmacen:String):Boolean {
		return this.ctx.kits_regenerarMSValTPV(referencia, codAlmacen);
	}
	function dameQueryPedCli(aDatosArt:Array, codAlmacen:String):FLSqlQuery {
		return this.ctx.kits_dameQueryPedCli(aDatosArt, codAlmacen);
	}
	function dameQueryPedProv(aDatosArt:Array, codAlmacen:String):FLSqlQuery {
		return this.ctx.kits_dameQueryPedProv(aDatosArt, codAlmacen);
	}
	function dameQueryAlbCli(aDatosArt:Array, codAlmacen:String):FLSqlQuery {
		return this.ctx.kits_dameQueryAlbCli(aDatosArt, codAlmacen);
	}
	function dameQueryAlbProv(aDatosArt:Array, codAlmacen:String):FLSqlQuery {
		return this.ctx.kits_dameQueryAlbProv(aDatosArt, codAlmacen);
	}
	function dameQueryFacCli(aDatosArt:Array, codAlmacen:String):FLSqlQuery {
		return this.ctx.kits_dameQueryFacCli(aDatosArt, codAlmacen);
	}
	function dameQueryFacProv(aDatosArt:Array, codAlmacen:String):FLSqlQuery {
		return this.ctx.kits_dameQueryFacProv(aDatosArt, codAlmacen);
	}
	function dameQueryTrans(aDatosArt:Array, codAlmacen:String):FLSqlQuery {
		return this.ctx.kits_dameQueryTrans(aDatosArt, codAlmacen);
	}
	function dameQueryComTPV(aDatosArt:Array, codAlmacen:String):String {
		return this.ctx.kits_dameQueryComTPV(aDatosArt, codAlmacen);
	}

}
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition kits */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
function kits_init()
{
	this.iface.__init();
	this.iface.tbnRevisarStock = this.child("tbnRevisarStock");

	connect (this.iface.tbnRevisarStock, "clicked()", this, "iface.tbnRevisarStock_clicked");
}

function kits_tbnRevisarStock_clicked()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codAlmacen:String = cursor.valueBuffer("codalmacen");
	if (!codAlmacen || codAlmacen == "") {
		return false;
	}
	var referencia:String = cursor.valueBuffer("referencia");

	var arrayOps:Array = [];
	arrayOps[0] = util.translate("scripts", "Actualizar el stock seleccionado (%1 - %2)").arg(referencia).arg(codAlmacen);
	arrayOps[1] = util.translate("scripts", "Actualizar los stocks de %1").arg(codAlmacen);
	arrayOps[2] = util.translate("scripts", "Actualizar todos los stocks");

	var dialogo = new Dialog;
	dialogo.okButtonText = util.translate("scripts", "Aceptar");
	dialogo.cancelButtonText = util.translate("scripts", "Cancelar");

	var gbxDialogo = new GroupBox;
	gbxDialogo.title = util.translate("scripts", "Seleccione opción");

	var rButton:Array = new Array(arrayOps.length);
	for (var i:Number = 0; i < rButton.length; i++) {
		rButton[i] = new RadioButton;
		rButton[i].text = arrayOps[i];
		rButton[i].checked = (i == 0);
		gbxDialogo.add(rButton[i]);
	}
	var chkRegenerar = new CheckBox;
	chkRegenerar.text = util.translate("scripts", "Regenerar movimientos de stock");
	dialogo.add(chkRegenerar);

	dialogo.add(gbxDialogo);
	if (!dialogo.exec()) {
		return false;
	}
	var seleccion:Number = -1;
	for (var i:Number = 0; i < rButton.length; i++) {
		if (rButton[i].checked) {
			seleccion = i;
			break;
		}
	}
	if (seleccion == -1) {
		return false;
	}

	if (chkRegenerar.checked) {
		var res:Number = MessageBox.information(util.translate("scripts", "Activando la opción de regenerar movimientos AbanQ buscará todos los documentos que implican movimiento de stock (albaranes, etc) y\n generará (si no los tienen ya) los movimientos correspondientes.\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes) {
			return false;
		}
	}

	var where:String;
	switch (seleccion) {
		case 0: {
			where = "idstock = " + cursor.valueBuffer("idstock");
			break;
		}
		case 1: {
			where = "codalmacen = '" + codAlmacen + "'";
			break;
		}
		case 2: {
			where = "1 = 1";
			break;
		}
	}

	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");

	if (chkRegenerar.checked) {
		curTransaccion.transaction(false);
		try {
			flfactalma.iface.pub_bloquearCalculoStock(true);
			if (this.iface.regenerarMovistock(where)) {
				curTransaccion.commit();
				flfactalma.iface.pub_bloquearCalculoStock(false);
			} else {
				curTransaccion.rollback();
				flfactalma.iface.pub_bloquearCalculoStock(false);
				MessageBox.warning(util.translate("scripts", "Error al revisar el stock"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		} catch(e) {
			flfactalma.iface.pub_bloquearCalculoStock(false);
			curTransaccion.rollback();
			MessageBox.warning(util.translate("scripts", "Error al revisar el stock:") + e, MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		curTransaccion.transaction(false);
		try {
			if (this.iface.revisarStock(where, true)) {
				curTransaccion.commit();
			} else {
				curTransaccion.rollback();
				MessageBox.warning(util.translate("scripts", "Error al revisar el stock"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		} catch(e) {
			flfactalma.iface.pub_activarCalculoStock(true);
			curTransaccion.rollback();
			MessageBox.warning(util.translate("scripts", "Error al revisar el stock:") + e, MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	MessageBox.information(util.translate("scripts", "Stocks revisados correctamente"), MessageBox.Ok, MessageBox.NoButton);

	this.child("tdbRegStocks").refresh();
}

function kits_revisarStock(where:String, mostrarDialogo:Boolean):Boolean
{
	var util:FLUtil = new FLUtil;

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select(where);
	if (mostrarDialogo) {
		util.createProgressDialog(util.translate("scripts", "Revisando stocks..."), curStock.size());
	}
	var paso:Number = 0;
	var canUltReg:Number;
	while (curStock.next()) {
		if (mostrarDialogo) {
			util.setProgress(++paso);
		}
		curStock.setModeAccess(curStock.Edit);
		curStock.refreshBuffer();
		curStock.setValueBuffer("fechaultreg", formRecordregstocks.iface.pub_commonCalculateField("fechaultreg", curStock));
		curStock.setValueBuffer("horaultreg", formRecordregstocks.iface.pub_commonCalculateField("horaultreg", curStock));
		canUltReg = formRecordregstocks.iface.pub_commonCalculateField("cantidadultreg", curStock);
		if (!canUltReg || isNaN(canUltReg)) {
			canUltReg = 0;
		}
		curStock.setValueBuffer("cantidadultreg", canUltReg);
		curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock));
		curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock));
		curStock.setValueBuffer("cantidad", formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock));
		curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
		if (!curStock.commitBuffer()) {
			if (mostrarDialogo) {
				util.destroyProgressDialog();
			}
			return false;
		}
	}
	if (mostrarDialogo) {
		util.destroyProgressDialog();
	}
	return true;
}

function kits_regenerarMovistock(where:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select(where);
	util.createProgressDialog(util.translate("scripts", "Revisando stocks..."), curStock.size());
	var paso:Number = 0;
	var canUltReg:Number;
	while (curStock.next()) {
		util.setProgress(++paso);
		curStock.setModeAccess(curStock.Browse);
		curStock.refreshBuffer();
		if (!this.iface.regenerarMS(curStock)) {
			return false;
		}
		if (!this.iface.revisarStock("idstock = " + curStock.valueBuffer("idstock"), false)) {
			return false;
		}
	}

	return true;
}

function kits_regenerarMS(curStock:FLSqlCursor):Boolean
{
	var aDatosArt:Array = flfactalma.iface.pub_datosArticulo(curStock);
	var codAlmacen:String = curStock.valueBuffer("codalmacen");
	if (!this.iface.regenerarMSPedCli(aDatosArt, codAlmacen)) {
		return false;
	}
	if (!this.iface.regenerarMSPedProv(aDatosArt, codAlmacen)) {
		return false;
	}
	if (!this.iface.regenerarMSAlbCli(aDatosArt, codAlmacen)) {
		return false;
	}
	if (!this.iface.regenerarMSAlbProv(aDatosArt, codAlmacen)) {
		return false;
	}
	if (!this.iface.regenerarMSFacCli(aDatosArt, codAlmacen)) {
		return false;
	}
	if (!this.iface.regenerarMSFacProv(aDatosArt, codAlmacen)) {
		return false;
	}
	if (!this.iface.regenerarMSTrans(aDatosArt, codAlmacen)) {
		return false;
	}
	if (sys.isLoadedModule("flfact_tpv")) {
		if (!this.iface.regenerarMSComTPV(aDatosArt, codAlmacen)) {
			return false;
		}
		if (!this.iface.regenerarMSValTPV(aDatosArt, codAlmacen)) {
			return false;
		}
	}
	return true;
}

function kits_dameQueryPedCli(aDatosArt:Array, codAlmacen:String):FLSqlQuery
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("pedidoscli,lineaspedidoscli,movistock");
	qryStock.setSelect("lp.idlinea, lp.cantidad");
	qryStock.setFrom("pedidoscli p INNER JOIN lineaspedidoscli lp ON p.idpedido = lp.idpedido LEFT OUTER JOIN movistock ms ON lp.idlinea = ms.idlineapc");
	qryStock.setWhere("p.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSPedCli(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryPedCli(aDatosArt, codAlmacen);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando pedidos de cliente..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	while (qryStock.next()) {
		util.setProgress(++paso);
		curLinea.select("idlinea = " + qryStock.value("lp.idlinea"));
		if (!curLinea.first()) {
			util.destroyProgressDialog();
			return false;
		}
		if (!flfactalma.iface.generarMoviStock(curLinea, false, qryStock.value("lp.cantidad"))) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_dameQueryPedProv(aDatosArt:Array, codAlmacen:String):FLSqlQuery
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("pedidosprov,lineaspedidosprov,movistock");
	qryStock.setSelect("lp.idlinea, lp.cantidad");
	qryStock.setFrom("pedidosprov p INNER JOIN lineaspedidosprov lp ON p.idpedido = lp.idpedido LEFT OUTER JOIN movistock ms ON lp.idlinea = ms.idlineapp");
	qryStock.setWhere("p.codalmacen = '" + codAlmacen + "' AND lp.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSPedProv(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryPedProv(aDatosArt, codAlmacen);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando pedidos de proveedor..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
	while (qryStock.next()) {
		util.setProgress(++paso);
		curLinea.select("idlinea = " + qryStock.value("lp.idlinea"));
		if (!curLinea.first()) {
			util.destroyProgressDialog();
			return false;
		}
		if (!flfactalma.iface.generarMoviStock(curLinea, false, qryStock.value("lp.cantidad"))) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_dameQueryAlbCli(aDatosArt:Array, codAlmacen:String):FLSqlQuery
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("albaranescli,lineasalbaranescli,movistock");
	qryStock.setSelect("la.idlinea, la.idlineapedido");
	qryStock.setFrom("albaranescli a INNER JOIN lineasalbaranescli la ON a.idalbaran = la.idalbaran LEFT OUTER JOIN movistock ms ON la.idlinea = ms.idlineaac");
	qryStock.setWhere("a.codalmacen = '" + codAlmacen + "' AND la.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSAlbCli(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryAlbCli(aDatosArt, codAlmacen);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando albaranes de cliente..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("lineasalbaranescli");
	var idLineaPedido:String;
	while (qryStock.next()) {
		util.setProgress(++paso);
		idLineaPedido = qryStock.value("la.idlineapedido");
		curLinea.select("idlinea = " + qryStock.value("la.idlinea"));
		if (!curLinea.first()) {
			return false;
		}
		if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
			if (!flfactalma.iface.albaranarParcialLPC(idLineaPedido, curLinea)) {
				util.destroyProgressDialog();
				return false;
			}
		} else {
			if (!flfactalma.iface.generarMoviStock(curLinea)) {
				util.destroyProgressDialog();
				return false;
			}
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_dameQueryAlbProv(aDatosArt:Array, codAlmacen:String):FLSqlQuery
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("albaranesprov,lineasalbaranesprov,movistock");
	qryStock.setSelect("la.idlinea, la.idlineapedido");
	qryStock.setFrom("albaranesprov a INNER JOIN lineasalbaranesprov la ON a.idalbaran = la.idalbaran LEFT OUTER JOIN movistock ms ON la.idlinea = ms.idlineaap");
	qryStock.setWhere("a.codalmacen = '" + codAlmacen + "' AND la.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSAlbProv(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryAlbProv(aDatosArt, codAlmacen);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando albaranes de proveedor..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("lineasalbaranesprov");
	var idLineaPedido:String;
	while (qryStock.next()) {
		util.setProgress(++paso);
		idLineaPedido = qryStock.value("la.idlineapedido");
		curLinea.select("idlinea = " + qryStock.value("la.idlinea"));
		if (!curLinea.first()) {
			return false;
		}
		if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
			if (!flfactalma.iface.albaranarParcialLPP(idLineaPedido, curLinea)) {
				util.destroyProgressDialog();
				return false;
			}
		} else {
			if (!flfactalma.iface.generarMoviStock(curLinea)) {
				util.destroyProgressDialog();
				return false;
			}
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_dameQueryFacCli(aDatosArt:Array, codAlmacen:String):FLSqlQuery
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("facturascli,lineasfacturascli,movistock");
	qryStock.setSelect("lf.idlinea");
	qryStock.setFrom("facturascli f INNER JOIN lineasfacturascli lf ON f.idfactura = lf.idfactura LEFT OUTER JOIN movistock ms ON lf.idlinea = ms.idlineafc");
	qryStock.setWhere("f.codalmacen = '" + codAlmacen + "' AND lf.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL AND f.automatica <> true");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSFacCli(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryFacCli(aDatosArt, codAlmacen);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando facturas de cliente..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("lineasfacturascli");
	var idLineaPedido:String;
	while (qryStock.next()) {
		util.setProgress(++paso);
		curLinea.select("idlinea = " + qryStock.value("lf.idlinea"));
		if (!curLinea.first()) {
			return false;
		}
		if (!flfactalma.iface.generarMoviStock(curLinea)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_dameQueryFacProv(aDatosArt:Array, codAlmacen:String):FLSqlQuery
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("facturasprov,lineasfacturasprov,movistock");
	qryStock.setSelect("lf.idlinea");
	qryStock.setFrom("facturasprov f INNER JOIN lineasfacturasprov lf ON f.idfactura = lf.idfactura LEFT OUTER JOIN movistock ms ON lf.idlinea = ms.idlineafp");
	qryStock.setWhere("f.codalmacen = '" + codAlmacen + "' AND lf.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL AND f.automatica <> true");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSFacProv(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryFacProv(aDatosArt, codAlmacen);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando facturas de proveedor..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("lineasfacturasprov");
	var idLineaPedido:String;
	while (qryStock.next()) {
		util.setProgress(++paso);
		curLinea.select("idlinea = " + qryStock.value("lf.idlinea"));
		if (!curLinea.first()) {
			return false;
		}
		if (!flfactalma.iface.generarMoviStock(curLinea)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_dameQueryTrans(aDatosArt:Array, codAlmacen:String):FLSqlQuery
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("transstock,lineastransstock,movistock");
	qryStock.setSelect("lt.idlinea");
	qryStock.setFrom("transstock t INNER JOIN lineastransstock lt ON t.idtrans = lt.idtrans LEFT OUTER JOIN movistock ms ON lt.idlinea = ms.idlineats");
	qryStock.setWhere("(t.codalmaorigen = '" + codAlmacen + "' OR t.codalmadestino = '" + codAlmacen + "') AND lt.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSTrans(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryTrans(aDatosArt, codAlmacen);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando transferencias de stock..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("lineastransstock");
	var idLineaPedido:String;
	while (qryStock.next()) {
		util.setProgress(++paso);
		curLinea.select("idlinea = " + qryStock.value("lt.idlinea"));
		if (!curLinea.first()) {
			return false;
		}
		if (!flfactalma.iface.generarMoviStock(curLinea)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_dameQueryComTPV(aDatosArt:Array, codAlmacen:String):String
{
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("tpv_comandas,tpv_lineascomanda,movistock");
	qryStock.setSelect("lc.idtpv_linea");
	qryStock.setFrom("tpv_comandas c INNER JOIN tpv_lineascomanda lc ON c.idtpv_comanda = lc.idtpv_comanda LEFT OUTER JOIN movistock ms ON lc.idtpv_linea = ms.idlineaco");
	qryStock.setWhere("c.codalmacen = '" + codAlmacen + "' AND lc.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
	qryStock.setForwardOnly(true);
	return qryStock;
}

function kits_regenerarMSComTPV(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = this.iface.dameQueryComTPV(aDatosArt, codAlmacen);
	if (!qryStock || !qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando ventas de TPV..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	var idLineaPedido:String;
	while (qryStock.next()) {
		util.setProgress(++paso);
		curLinea.select("idtpv_linea = " + qryStock.value("lc.idtpv_linea"));
		if (!curLinea.first()) {
			return false;
		}
		if (!flfactalma.iface.generarMoviStock(curLinea)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}

function kits_regenerarMSValTPV(aDatosArt:Array, codAlmacen:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryStock:FLSqlQuery = new FLSqlQuery;
	qryStock.setTablesList("tpv_vales,tpv_lineasvale,movistock");
	qryStock.setSelect("lv.idlinea");
	qryStock.setFrom("tpv_vales v INNER JOIN tpv_lineasvale lv ON v.referencia = lv.refvale LEFT OUTER JOIN movistock ms ON lv.idlinea = ms.idlineava");
	qryStock.setWhere("lv.codalmacen = '" + codAlmacen + "' AND lv.referencia = '" + aDatosArt["referencia"] + "' AND ms.idmovimiento IS NULL");
	qryStock.setForwardOnly(true);
	if (!qryStock.exec()) {
		return false;
	}
	util.createProgressDialog(util.translate("scripts", "Revisando vales de TPV..."), qryStock.size());
	var paso:Number = 0;

	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineasvale");
	var idLineaPedido:String;
	while (qryStock.next()) {
		util.setProgress(++paso);
		curLinea.select("idlinea = " + qryStock.value("lv.idlinea"));
		if (!curLinea.first()) {
			return false;
		}
		if (!flfactalma.iface.generarMoviStock(curLinea)) {
			util.destroyProgressDialog();
			return false;
		}
	}
	util.destroyProgressDialog();
	return true;
}
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

