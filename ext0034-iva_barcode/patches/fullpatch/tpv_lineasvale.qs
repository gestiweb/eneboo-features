
/** @class_declaration ivaBarcode */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO + BARCODE ///////////////////////////////////////
class ivaBarcode extends oficial {
	var bloqueoPrecio:Boolean;
    function ivaBarcode( context ) { oficial( context ); }
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
			break;
		}
		case "barcode": {
			this.child("fdbReferencia").setValue(this.iface.commonCalculateField("referencia", cursor));
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

	switch (fN) {
		case "referencia": {
			valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
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

