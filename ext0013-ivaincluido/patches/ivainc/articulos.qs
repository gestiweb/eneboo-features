
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
    function ivaIncluido( context ) { oficial( context ); }
	function validateForm():Boolean {
		return this.ctx.ivaIncluido_validateForm();
	}
	function establecerDatosAlta() {
		return this.ctx.ivaIncluido_establecerDatosAlta();
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////

function ivaIncluido_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if(!this.iface.__validateForm())
		return false;

	if (cursor.valueBuffer("ivaincluido") && !cursor.valueBuffer("codimpuesto")) {
		MessageBox.critical(util.translate("scripts","Si el IVA del artículo está incluído se debe especificar el tipo de IVA"),
				MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
		return false;
	}

	return true;
}

function ivaIncluido_establecerDatosAlta()
{
	this.iface.__establecerDatosAlta();
	this.child("fdbIvaIncluido").setValue(flfactalma.iface.pub_valorDefectoAlmacen("ivaincluido"));
}
//// IVAINCLUIDO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

