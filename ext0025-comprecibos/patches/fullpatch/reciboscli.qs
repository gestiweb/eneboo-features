
/** @class_declaration compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
class compRecibos extends oficial /** %from: oficial */ {
    function compRecibos( context ) { oficial ( context ); }
	function obtenerEstado(idRecibo:String):String {
		return this.ctx.compRecibos_obtenerEstado(idRecibo);
	}
}
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
/** \D
Si el recibo está compensado, no puede editarse ni pagarse
@param	idRecibo: Identificador del recibo cuyo estado se desea calcular
@return	Estado del recibo
\end */
function compRecibos_obtenerEstado(idRecibo:String):String
{
// 	var cursor:FLSqlCursor = this.cursor();
// 	if (cursor.valueBuffer("estado") != "Compensado")
	var util:FLUtil;
	var estado:String = util.sqlSelect("reciboscli","estado","idrecibo = " + idRecibo);
	if(!estado || estado == "")
		return false;

	if(estado != "Compensado")
		return this.iface.__obtenerEstado(idRecibo);

	var idReciboComp:Number = util.sqlSelect("reciboscli","idrecibocomp","idrecibo = " + idRecibo);
	if(!idReciboComp || idReciboComp == "")
		return false;
	var util:FLUtil = new FLUtil;
	this.child("lblRemesado").text = "Compensado con:\n" + util.sqlSelect("reciboscli", "codigo", "idrecibo = " + idReciboComp);
	this.child("tdbPagosDevolCli").setReadOnly(true);
	this.child("fdbImporte").setDisabled(true);
	this.child("toolButtomInsert").enabled = false;
	this.child("toolButtonEdit").enabled = false;
	this.child("toolButtonDelete").enabled = false;

	return "Compensado";
}

//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////

