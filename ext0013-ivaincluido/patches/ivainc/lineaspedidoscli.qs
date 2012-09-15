
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
	var bloqueoPrecio:Boolean;
    function ivaIncluido( context ) { oficial( context ); }
	function init() {
		return this.ctx.ivaIncluido_init();
	}
	function habilitarPorIvaIncluido(miForm:Object) {
		return this.ctx.ivaIncluido_habilitarPorIvaIncluido(miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.ivaIncluido_commonCalculateField(fN, cursor);
	}
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.ivaIncluido_commonBufferChanged(fN, miForm);
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pubIvaIncluido */
/////////////////////////////////////////////////////////////////
//// PUB_IVA_INCLUIDO ///////////////////////////////////////////
class pubIvaIncluido extends ifaceCtx /** %from: ifaceCtx */ {
    function pubIvaIncluido( context ) { ifaceCtx( context ); }
	function pub_habilitarPorIvaIncluido(miForm:Object) {
		return this.habilitarPorIvaIncluido(miForm);
	}
}

//// PUB_IVA_INCLUIDO ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
function ivaIncluido_init()
{
	this.iface.__init();
	this.iface.habilitarPorIvaIncluido(form);
}

function ivaIncluido_habilitarPorIvaIncluido(miForm:Object)
{
	if (miForm.cursor().valueBuffer("ivaincluido")) {
		miForm.child("fdbPvpUnitarioIva").setDisabled(false);
		miForm.child("fdbPvpUnitario").setDisabled(true);
	} else {
		miForm.child("fdbPvpUnitarioIva").setDisabled(true);
		miForm.child("fdbPvpUnitario").setDisabled(false);
        miForm.child("fdbPvpTotalIvaInc").setValue("0");
	}
}

function ivaIncluido_commonBufferChanged(fN:String, miForm:Object)
{
	var util:FLUtil = new FLUtil();

	switch (fN) {
		case "referencia":
			this.iface.bloqueoPrecio = true;
			var ivaIncluido:Boolean = this.iface.commonCalculateField("ivaincluido", miForm.cursor());
			miForm.child("fdbIvaIncluido").setValue(ivaIncluido);
			miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));

			if (ivaIncluido) {
				miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva", miForm.cursor()));
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
			} else {
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
				miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
			}
			this.iface.bloqueoPrecio = false;
			this.iface.habilitarPorIvaIncluido(miForm);
			break;
		case "codimpuesto":
			miForm.child("fdbIva").setValue(this.iface.commonCalculateField("iva", miForm.cursor()));
			miForm.child("fdbRecargo").setValue(this.iface.commonCalculateField("recargo", miForm.cursor()));
/*			if (!this.iface.bloqueoPrecio && miForm.cursor().valueBuffer("ivaincluido")) {
				this.iface.bloqueoPrecio = true;
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
				this.iface.bloqueoPrecio = false;
			}*/
			break;

		case "ivaincluido":
			this.iface.habilitarPorIvaIncluido(miForm);
		case "iva": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				if (miForm.cursor().valueBuffer("ivaincluido")) {
					miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
				} else {
					miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
				}
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "recargo": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				if (miForm.cursor().valueBuffer("ivaincluido")) {
					miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
				} else {
					miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
				}
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "pvpunitarioiva": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				miForm.cursor().setValueBuffer("pvpunitario", this.iface.commonCalculateField("pvpunitario2", miForm.cursor()));
				this.iface.bloqueoPrecio = false;
			}
			break;
		}
		case "pvpunitario": {
			if (!this.iface.bloqueoPrecio) {
				this.iface.bloqueoPrecio = true;
				miForm.child("fdbPvpUnitarioIva").setValue(this.iface.commonCalculateField("pvpunitarioiva2", miForm.cursor()));
				this.iface.bloqueoPrecio = false;
			}
		}
		case "cantidad": {
			if (miForm.cursor().valueBuffer("ivaincluido")) {
				miForm.cursor().setValueBuffer("pvpsindto", this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
			} else {
				return this.iface.__commonBufferChanged(fN, miForm);
			}
			break;
		}
		case "pvpsindto":
		case "dtopor": {
			miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
		}
		case "dtolineal": {
			if (miForm.cursor().valueBuffer("ivaincluido")) {
				miForm.cursor().setValueBuffer("pvptotal", this.iface.commonCalculateField("pvptotal", miForm.cursor()));
                miForm.cursor().setValueBuffer("pvptotalivainc", this.iface.commonCalculateField("pvptotalivainc", miForm.cursor()));
			} else {
				return this.iface.__commonBufferChanged(fN, miForm);
			}
			break;
		}
		default:
			return this.iface.__commonBufferChanged(fN, miForm);
	}
}

function ivaIncluido_commonCalculateField(fN, cursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var referencia:String = cursor.valueBuffer("referencia");

	switch (fN) {
		case "pvpunitarioiva":
			valor = this.iface.__commonCalculateField("pvpunitario", cursor);
			break;
		case "pvpunitarioiva2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
			var recargo:Number = parseFloat(cursor.valueBuffer("recargo"));
			if (isNaN(recargo)) {
				iva = recargo;
			}
			iva += parseFloat(recargo);
			valor = cursor.valueBuffer("pvpunitario") * ((100 + iva) / 100);
			break;
		}
		case "pvpunitario2": {
			var iva:Number = parseFloat(cursor.valueBuffer("iva"));
			if (isNaN(iva)) {
				iva = 0;
			}
			var recargo:Number = parseFloat(cursor.valueBuffer("recargo"));
			if (isNaN(recargo)) {
				iva = recargo;
			}
			iva += parseFloat(recargo);
			valor = parseFloat(cursor.valueBuffer("pvpunitarioiva")) / ((100 + iva) / 100);
			break;
		}
		case "pvpsindto":
			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
			break;

		case "ivaincluido":
			valor = util.sqlSelect("articulos", "ivaincluido", "referencia = '" + referencia + "'");
			break;

		case "pvptotal":{
			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
			break;
		}
        case "pvptotalivainc":{
            var iva:Number = parseFloat(cursor.valueBuffer("iva"));
            if (isNaN(iva)) {
                iva = 0;
            }
            var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
            dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
            pvpTotal = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
            valor = pvpTotal * ((100 + iva) / 100);
            break;
        }
		default:
			return this.iface.__commonCalculateField(fN, cursor);
	}
	return valor;
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

