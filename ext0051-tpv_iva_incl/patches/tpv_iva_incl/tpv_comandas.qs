
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ////////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
	function ivaIncluido( context ) { oficial( context ); }
	function datosLineaVenta():Boolean {
		return this.ctx.ivaIncluido_datosLineaVenta();
	}
	function descontar(idLinea:Number, descuentoLineal:Number, porDescuento:Number):Boolean {
		return this.ctx.ivaIncluido_descontar(idLinea, descuentoLineal, porDescuento);
	}
	function aplicarTarifaLinea(codTarifa:String):Boolean {
		return this.ctx.ivaIncluido_aplicarTarifaLinea(codTarifa);
	}
	function calculateField(fN:String):String {
		return this.ctx.ivaIncluido_calculateField(fN);
	}
	function actualizarIvaLineas(codCliente:String) {
		return this.ctx.ivaIncluido_actualizarIvaLineas(codCliente);
	}
	function calcularTotales() {
		return this.ctx.ivaIncluido_calcularTotales();
	}
}
//// IVA INCLUIDO ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ////////////////////////////////////////////////
function ivaIncluido_datosLineaVenta():Boolean
{
	this.iface.__datosLineaVenta();

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var ivaIncluido:Boolean;
	if (cursor.valueBuffer("referencia")) {
		ivaIncluido = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas);
	} else {
		ivaIncluido = flfactalma.iface.pub_valorDefectoAlmacen("ivaincluido");
	}
	this.iface.curLineas.setValueBuffer("ivaincluido", ivaIncluido);

//	if (ivaIncluido) {
		this.iface.curLineas.setValueBuffer("pvpunitarioiva", util.roundFieldValue(this.iface.txtPvpArticulo.text, "tpv_lineascomanda", "pvpunitarioiva"));
		this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineas));
//	}

	this.iface.curLineas.setValueBuffer("pvpsindto", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));

	return true;
}

/** \D
Aplica un descuento a la linea, teniendo en cuenta el IVA incluido
*/
function ivaIncluido_descontar(idLinea:Number,descuentoLineal:Number,porDescuento:Number):Boolean
{
	if (!idLinea)
		return false;
	var util:FLUtil = new FLUtil;

	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_linea = " + idLinea);
	curLinea.first();
	curLinea.setModeAccess(curLinea.Edit);
	curLinea.refreshBuffer();
	var valor:Number;
	if (curLinea.valueBuffer("ivaincluido"))
		valor = parseFloat(descuentoLineal) * 100 / (100 + parseFloat(curLinea.valueBuffer("iva")));
	else
		valor = descuentoLineal;
	valor = util.roundFieldValue(valor, "tpv_lineascomanda", "pvpunitario");

	curLinea.setValueBuffer("dtolineal", valor);
	curLinea.setValueBuffer("dtopor", porDescuento);
	curLinea.setValueBuffer("pvptotal", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea));
	if (!curLinea.commitBuffer())
		return false;
	this.iface.calcularTotales();
	return true;
}

function ivaIncluido_aplicarTarifaLinea(codTarifa:String):Boolean
{
	var ivaIncluido:Boolean = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", this.iface.curLineas);
	this.iface.curLineas.setValueBuffer("ivaincluido", ivaIncluido);

	if (ivaIncluido) {
		this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva", this.iface.curLineas))
		this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineas))
	} else {
		this.iface.curLineas.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario", this.iface.curLineas))
		this.iface.curLineas.setValueBuffer("pvpunitarioiva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineas))
	}
	this.iface.curLineas.setValueBuffer("pvpsindto",
	formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineas));
	this.iface.curLineas.setValueBuffer("pvptotal",
	formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", this.iface.curLineas));
	return true;
}

function ivaIncluido_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "pvparticulo": {
			valor = this.iface.__calculateField("pvparticulo");
			if (isNaN(valor)) {
				valor = 0;
			}
			var ivaIncluido:Boolean = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + cursor.valueBuffer("referencia") + "'");
			if (!ivaIncluido) {
				var iva:Number = parseFloat(util.sqlSelect("articulos a INNER JOIN impuestos i ON a.codimpuesto = i.codimpuesto", "i.iva", "a.referencia = '" + cursor.valueBuffer("referencia") + "'", "articulos,impuestos"));
				if (isNaN(iva)) {
					iva = 0;
				}
				valor = valor * ((100 + iva) / 100);
			}
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}

function ivaIncluido_actualizarIvaLineas(codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var codImpuesto:String = "";
	var curLinea:FLSqlCursor = new FLSqlCursor("tpv_lineascomanda");
	curLinea.select("idtpv_comanda = " + cursor.valueBuffer("idtpv_comanda"));
	var ivaIncluido:Boolean;
	var pvpSinDto:Number, pvpTotal:Number, pvpUnitarioIva:Number;
	while (curLinea.next()) {
		curLinea.setModeAccess(curLinea.Edit);
		curLinea.refreshBuffer();
		curLinea.setValueBuffer("codimpuesto", this.iface.calcularIvaLinea(curLinea.valueBuffer("referencia")));
		curLinea.setValueBuffer("iva", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("iva", curLinea));
		ivaIncluido = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("ivaincluido", curLinea);
		if (ivaIncluido) {
			curLinea.setValueBuffer("pvpunitario", formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitario2", curLinea));
		} else {
			pvpUnitarioIva = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpunitarioiva2", curLinea);
			pvpUnitarioIva = util.roundFieldValue(pvpUnitarioIva, "tpv_lineascomanda", "pvpunitarioiva");
			curLinea.setValueBuffer("pvpunitarioiva", pvpUnitarioIva);
		}
		pvpSinDto = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvpsindto", curLinea);
		pvpSinDto = util.roundFieldValue(pvpSinDto, "tpv_lineascomanda", "pvpsindto");
		curLinea.setValueBuffer("pvpsindto", pvpSinDto);
		pvpTotal = formRecordtpv_lineascomanda.iface.pub_commonCalculateField("pvptotal", curLinea);
		pvpTotal = util.roundFieldValue(pvpTotal, "tpv_lineascomanda", "pvptotal");
		curLinea.setValueBuffer("pvptotal", pvpTotal);
		if (!curLinea.commitBuffer()) {
			return false;
		}
	}
	this.iface.calcularTotales();
	this.child("tdbLineasComanda").refresh();
}

function ivaIncluido_calcularTotales()
{
	this.iface.__calcularTotales();

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var dtoEspecial:Number = parseFloat(cursor.valueBuffer("dtoesp"));
	if (!isNaN(dtoEspecial) && dtoEspecial != 0) return;

	var tabla:String = "tpv_lineascomanda";

	var id:Number = cursor.valueBuffer("idtpv_comanda");
	var neto:Number = util.sqlSelect(tabla, "sum((pvpunitario-dtolineal-pvpunitario*dtopor/100)*cantidad)", "idtpv_comanda = " + id);
	var iva:Number = util.sqlSelect(tabla, "sum((pvpunitario-dtolineal-pvpunitario*dtopor/100)*cantidad*iva/100)", "idtpv_comanda = " + id);

	// Comparamos la suma exacta redondeada a 2 con la suma de neto + iva
	var totalExacto = Math.round(100 * (parseFloat(neto) + parseFloat(iva)))/100;
	var totalActual = parseFloat(cursor.valueBuffer("neto")) + parseFloat(cursor.valueBuffer("totaliva"));

	var dif:Number = parseFloat(totalActual) - parseFloat(totalExacto);
	if (dif != 0) {
		cursor.setValueBuffer("totaliva", parseFloat(cursor.valueBuffer("totaliva")) - dif);
	}
}

//// IVA INCLUIDO ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

