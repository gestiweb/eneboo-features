
/** @class_declaration kits */
/////////////////////////////////////////////////////////////////
//// ARTICULOS COMPUESTOS ///////////////////////////////////////
class kits extends oficial /** %from: oficial */ {
    function kits( context ) { oficial ( context ); }
    function init() {
		return this.ctx.kits_init();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.kits_commonCalculateField(fN, cursor);
	}
	function mostrarListadoMS() {
		return this.ctx.kits_mostrarListadoMS();
	}
	function filtrarMovimientos() {
		return this.ctx.kits_filtrarMovimientos();
	}
	function calcularCantidad() {
		return this.ctx.kits_calcularCantidad();
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

	connect(this.child("chkDesdeUltReg"), "clicked()", this, "iface.filtrarMovimientos");
	connect(this.child("chkExcluirPtes"), "clicked()", this, "iface.filtrarMovimientos");
	connect (this.child("tnbMostrarListadoMS"), "clicked()", this, "iface.mostrarListadoMS");

	var campos:Array = ["fechareal", "horareal", "fechaprev", "estado", "cantidad"];
	this.child("tdbMoviStocks").setOrderCols(campos);
	this.iface.filtrarMovimientos();
}

function kits_mostrarListadoMS()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var f:Object = new FLFormSearchDB("mostrarlistadoms");
	var curMostrar:FLSqlCursor = f.cursor();
	curMostrar.select("idusuario = '" + sys.nameUser() + "'");
	if (!curMostrar.first()) {
		curMostrar.setModeAccess(curMostrar.Insert);
		curMostrar.refreshBuffer();
		curMostrar.setValueBuffer("idusuario", sys.nameUser());
	} else {
		curMostrar.setModeAccess(curMostrar.Edit);
		curMostrar.refreshBuffer();
	}
	curMostrar.setValueBuffer("idstock", cursor.valueBuffer("idstock"));
	curMostrar.setValueBuffer("codalmacen", cursor.valueBuffer("codalmacen"));
	curMostrar.setValueBuffer("referencia", cursor.valueBuffer("referencia"));
	curMostrar.setValueBuffer("desdeultimareg",true);
	curMostrar.setValueBuffer("pendiente", true);
	curMostrar.setValueBuffer("reservado", true);
	curMostrar.setValueBuffer("hecho", true);
	if (!curMostrar.commitBuffer()) {
		return false;;
	}
	curMostrar.select("idusuario = '" + sys.nameUser() + "' AND idstock = " + cursor.valueBuffer("idstock"));
	if (!curMostrar.first()) {
		return false;
	}
	curMostrar.setModeAccess(curMostrar.Edit);
	curMostrar.refreshBuffer();

	f.setMainWidget();
	curMostrar.refreshBuffer();
	var acpt:String = f.exec("idusuario");
	if (!acpt) {
		return false;
	}
}

function kits_filtrarMovimientos()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var filtro:String = "1 = 1";
	if (this.child("chkDesdeUltReg").checked) {
		var ultFecha:String = util.sqlSelect("lineasregstocks", "fecha", "idstock = " + cursor.valueBuffer("idstock") + " ORDER BY fecha DESC, hora DESC");
		if (ultFecha && ultFecha != "") {
			var ultHora:String = util.sqlSelect("lineasregstocks", "hora", "idstock = " + cursor.valueBuffer("idstock") + " AND fecha = '" + ultFecha + "' ORDER BY hora DESC");
			if (ultHora && ultHora != "") {
				filtro += " AND ((fechareal IS NULL OR fechareal > '" + ultFecha + "') OR (fechareal = '" + ultFecha + "' AND (horareal > '" + ultHora.toString().right(8) + "' 	OR horareal IS NULL)))";
			}
		}
	}
	if (this.child("chkExcluirPtes").checked) {
		filtro += " AND fechareal IS NOT NULL";
	}
	this.child("tdbMoviStocks").cursor().setMainFilter(filtro);
	this.child("tdbMoviStocks").refresh();
}

function kits_calcularCantidad()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;

	this.iface.calcularValoresUltReg();

	this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
	this.child("fdbReservada").setValue(this.iface.calculateField("reservada"));
	this.child("fdbDisponible").setValue(this.iface.calculateField("disponible"));

	this.iface.filtrarMovimientos();
}

function kits_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil;
	var valor:String;
	var idStock:String = cursor.valueBuffer("idstock");
	switch (fN) {
		case "pterecibir": {
			valor = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idstock = " + idStock + " AND estado = 'PTE' AND cantidad > 0"));
			if (!valor || isNaN(valor)) {
				valor = 0;
			}
			valor = util.roundFieldValue(valor, "stocks", "pterecibir");
			break;
		}
		case "reservada": {
			valor = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idstock = " + idStock + " AND estado = 'PTE' AND cantidad < 0"));
			if (!valor || isNaN(valor)) {
				valor = 0;
			}
			valor *= -1;
			valor = util.roundFieldValue(valor, "stocks", "reservada");
			break;
		}
		case "cantidad": {
			var cantidadUltReg:Number = parseFloat(cursor.valueBuffer("cantidadultreg"));
			if (isNaN(cantidadUltReg)) {
				cantidadUltReg = 0;
			}
			var whereStock:String = "idstock = " + idStock + " AND estado = 'HECHO'";
			if (!cursor.isNull("fechaultreg")) {
				whereStock += " AND ((fechareal > '" + cursor.valueBuffer("fechaultreg") + "') OR (fechareal = '" + cursor.valueBuffer("fechaultreg") + "' AND horareal > '" + cursor.valueBuffer("horaultreg").toString().right(8) + "'))";
			}
			var cantidadMov:Number = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", whereStock));
			if (!cantidadMov || isNaN(cantidadMov)) {
				cantidadMov = 0;
			}
			valor = parseFloat(cantidadUltReg) + parseFloat(cantidadMov);
			valor = util.roundFieldValue(valor, "stocks", "cantidad");
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

//// ARTICULOS COMPUESTOS ///////////////////////////////////////
/////////////////////////////////////////////////////////////////

