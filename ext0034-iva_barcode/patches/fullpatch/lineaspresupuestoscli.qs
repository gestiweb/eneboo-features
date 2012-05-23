
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial {
    function barCode( context ) { oficial ( context ); }
    function init() {
		return this.ctx.barCode_init();
	}
	function validateForm():Boolean {
		return this.ctx.barCode_validateForm();
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
		this.child("fdbBarCode").setFilter("");
	else
		this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
}

function barCode_validateForm():Boolean
{
	if (!this.iface.__validateForm())
		return false;

	var cursor:FLSqlCursor = this.cursor();

	if (!flfacturac.iface.pub_validarLinea(cursor))
		return false;

	return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

