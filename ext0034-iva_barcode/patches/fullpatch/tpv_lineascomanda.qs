
/** @class_declaration ivaBarcode */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
class ivaBarcode extends funNumSerie {
	var bloqueoPrecio:Boolean;
    function ivaBarcode( context ) { funNumSerie( context ); }
	function init() {
		return this.ctx.ivaBarcode_init();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaBarcode_commonCalculateField(fN, cursor);
	}
	function bufferChanged(fN:String) {
		return this.ctx.ivaBarcode_bufferChanged(fN);
	}
}
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaBarcode */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
function ivaBarcode_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "referencia": {
			if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
				this.child("fdbBarCode").setFilter("");
			else
				this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");

			this.iface.bloqueoPrecio = true;
			this.child("fdbIvaIncluido").setValue(this.iface.commonCalculateField("ivaincluido", this.cursor()));
			this.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva", this.cursor()));
			this.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", this.cursor()));
			cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", this.cursor()));
			this.iface.bloqueoPrecio = false;
			break;
		}
		case "barcode": {
			this.child("fdbReferencia").setValue(this.iface.commonCalculateField("referencia", cursor));
			break;
		}
		case "codimpuesto": {
			this.child("fdbIva").setValue(this.iface.commonCalculateField("iva", this.cursor()));
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", this.cursor()));
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "ivaincluido": {
			if (this.cursor().valueBuffer("ivaincluido")) {
				this.child("fdbPvpUnitario").setDisabled(true);
				this.child("fdbPvpUnitarioIva").setDisabled(false);
			}
			else {
				this.child("fdbPvpUnitario").setDisabled(false);
				this.child("fdbPvpUnitarioIva").setDisabled(true);
			}
		}
		case "pvpunitarioiva": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", this.cursor()));
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "pvpunitario": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				this.child("fdbPvpUnitarioIva").setValue(this.cursor().valueBuffer("pvpunitarioiva"));
				this.iface.bloqueoPrecio = false;
			}
		}
		case "cantidad": {
			if (cursor.valueBuffer("ivaincluido")) {
				cursor.setValueBuffer("pvpsindto", this.iface.commonCalculateField("pvpsindto", this.cursor()));
			} else {
				return this.iface.__bufferChanged(fN);
			}
			break;
		}
		case "pvpsindto":
		case "dtopor": {
			this.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", this.cursor()));
		}
		case "dtolineal": {
			if (cursor.valueBuffer("ivaincluido")) {
				cursor.setValueBuffer("pvptotal", this.iface.commonCalculateField("pvptotal", this.cursor()));
			} else {
				return this.iface.__bufferChanged(fN);
			}
			break;
		}
		default:
			return this.iface.__bufferChanged(fN);
	}
}

function ivaBarcode_commonCalculateField(fN, cursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var referencia:String = cursor.valueBuffer("referencia");

	switch (fN) {
		case "pvpunitarioiva": {
			var referencia:String = cursor.valueBuffer("referencia");
			var barcode:String = cursor.valueBuffer("barcode");
			var qryBarcode:FLSqlQuery = new FLSqlQuery();
			with (qryBarcode) {
				setTablesList("atributosarticulos");
				setSelect("pvp");
				setFrom("atributosarticulos");
				setWhere("pvpespecial = true AND barcode = '" + barcode + "'");
				setForwardOnly(true);
			}
			if (!qryBarcode.exec())
				return false;

			if (!qryBarcode.first())
				valor = this.iface.__commonCalculateField("pvpunitario", cursor);
			else {
				valor = qryBarcode.value("pvp");
			}
			break;
		}
		case "pvpunitario": {
			valor = cursor.valueBuffer("pvpunitarioiva");
			if (cursor.valueBuffer("ivaincluido")) {
				var iva:Number = cursor.valueBuffer("iva");
				if (!iva)
					iva = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + cursor.valueBuffer("codimpuesto") + "'");
				valor = parseFloat(valor) / (1 + iva / 100);
			}
			break;
		}
		case "pvpsindto": {
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			break;
		}
		case "ivaincluido": {
			valor = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");
			break;
		}
		case "referencia": {
			valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
			break;
		}
		/** \C
		El --pvptotal-- es el --pvpsindto-- menos el descuento menos el descuento lineal. Se omite el redondeo para que la funcionalidad de IVA incluido funcione correctamente
		*/
		case "pvptotal": {
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			//dtoPor = util.roundFieldValue(dtoPor, "tpv_lineascomanda", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			break;
		}

		default: {
			return this.iface.__commonCalculateField(fN, cursor);
		}
	}
	return valor;
}

function ivaBarcode_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
		this.child("fdbBarCode").setFilter("");
	else
		this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
}
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
//////////////////////////////////////////////////////////////////

