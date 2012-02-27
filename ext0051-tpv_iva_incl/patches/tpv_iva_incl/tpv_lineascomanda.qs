
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ////////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
	var bloqueoPrecio:Boolean;
    function ivaIncluido( context ) { oficial( context ); }
	function init() {
		return this.ctx.ivaIncluido_init();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaIncluido_commonCalculateField(fN, cursor);
	}
	function bufferChanged(fN:String) {
		return this.ctx.ivaIncluido_bufferChanged(fN);
	}
	function habilitarPorIvaIncluido() {
		return this.ctx.ivaIncluido_habilitarPorIvaIncluido();
	}
}
//// IVA INCLUIDO ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////
function ivaIncluido_init()
{
	this.iface.habilitarPorIvaIncluido();
	this.iface.__init();
}

function ivaIncluido_bufferChanged(fN:String)
{
debug("BCH " + fN);
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "referencia": {
// 			this.iface.__bufferChanged(fN);
			this.iface.bloqueoPrecio = true;
			var ivaIncluido:Boolean = this.iface.commonCalculateField("ivaincluido", cursor);
			this.child("fdbIvaIncluido").setValue(ivaIncluido);
			this.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", cursor));
			if (ivaIncluido) {
				this.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva", cursor));
				cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", cursor));
			} else {
				cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", cursor));
				this.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", cursor));
			}
			this.iface.bloqueoPrecio = false;
			break;
		}
		case "codimpuesto": {
			this.child("fdbIva").setValue(this.iface.commonCalculateField("iva", this.cursor()));
			break;
		}
		case "ivaincluido": {
			this.iface.habilitarPorIvaIncluido()
			break;
		}
		case "iva": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				if (cursor.valueBuffer("ivaincluido")) {
					cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", cursor));
/*					this.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", cursor));*/
				} else {
					this.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", cursor));
/*					cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", cursor));*/
				}
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "pvpunitarioiva": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				cursor.setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", this.cursor()));
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "pvpunitario": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				this.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", this.cursor()));
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

function ivaIncluido_habilitarPorIvaIncluido()
{
	var cursor:FLSqlCursor = this.cursor();
	if (this.cursor().valueBuffer("ivaincluido")) {
		this.child("fdbPvpUnitario").setDisabled(true);
		this.child("fdbPvpUnitarioIva").setDisabled(false);
	}
	else {
		this.child("fdbPvpUnitario").setDisabled(false);
		this.child("fdbPvpUnitarioIva").setDisabled(true);
	}
}
function ivaIncluido_commonCalculateField(fN, cursor):String
{
debug("CF " + fN);
	var util:FLUtil = new FLUtil();
	var valor:String;
	var referencia:String = cursor.valueBuffer("referencia");

	switch (fN) {
		case "codimpuesto": {
// 			var codCliente:String = util.sqlSelect(tablaPadre, "codcliente", wherePadre);
// 			var codSerie:String = util.sqlSelect(tablaPadre, "codserie", wherePadre);
// 			if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, codCliente)) {
				valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + cursor.valueBuffer("referencia") + "'");
// 			} else {
// 				valor = "";
// 			}
			break;
		}
		case "pvpunitarioiva": {
			valor = this.iface.__commonCalculateField("pvpunitario", cursor);
			break;
		}
		case "pvpunitarioiva2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
			valor = cursor.valueBuffer("pvpunitario") * ((100 + iva) / 100);
			break;
		}
		case "pvpunitario2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
debug("iva = " + iva);
			valor = parseFloat(cursor.valueBuffer("pvpunitarioiva")) / ((100 + iva) / 100);
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
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
		}
	}
debug("CF " + fN + " = " + valor);
	return valor;
}

//// IVAINCLUIDO /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

