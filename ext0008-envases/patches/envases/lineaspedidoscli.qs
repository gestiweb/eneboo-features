
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial /** %from: oficial */ {
    function envases( context ) { oficial ( context ); }
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.envases_commonBufferChanged(fN, miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.envases_commonCalculateField(fN, cursor);
	}
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
function envases_commonBufferChanged(fN:String, miForm:Object)
{
	switch (fN) {
		case "canenvases":
		case "valormetrico":
			miForm.child("fdbCantidad").setValue(this.iface.commonCalculateField("cantidad", miForm.cursor()));
			break;
/** \C Al seleccionar un --codenvase--, se establece automáticamente los valores --referencia-- y --valormetrico-- asociados
\end */
		case "codenvase":
			miForm.child("fdbReferencia").setValue(this.iface.commonCalculateField("referencia", miForm.cursor()));
			miForm.child("fdbValorMetrico").setValue(this.iface.commonCalculateField("valormetrico", miForm.cursor()));
			break;
		default:
			this.iface.__commonBufferChanged(fN, miForm);
			break;
	}
}

function envases_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
/** \C --cantidad-- es el producto de --valormetrico-- por --canenvases--
\end */
		case "cantidad":
			valor = parseFloat(cursor.valueBuffer("canenvases")) * parseFloat(cursor.valueBuffer("valormetrico"));
			break;
		case "referencia":
			var codEnvase = cursor.valueBuffer("codEnvase");
			var referencia = util.sqlSelect("envases", "referencia", "codEnvase = '" + codEnvase + "'");
			if (referencia)
				valor = referencia;
			break;
		case "valormetrico":
			var codEnvase = cursor.valueBuffer("codEnvase");
			var cantidad = util.sqlSelect("envases", "cantidad", "codEnvase = '" + codEnvase + "'");
			valor = 1;
			if (cantidad)
				valor = cantidad;
			break;
		default:
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
	}
	return valor;
}
//// ENVASES ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

