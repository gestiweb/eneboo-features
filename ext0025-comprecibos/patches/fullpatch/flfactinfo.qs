
/** @class_declaration compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
class compRecibos extends recibosProv /** %from: oficial */ {
    function compRecibos( context ) { recibosProv ( context ); }
	function vencimiento(nodo:FLDomNode, campo:String):String {
		return this.ctx.compRecibos_vencimiento(nodo, campo);
	}
	function reemplazar(cadena:String, patronOrigen:String, patronDestino:String):String {
		return this.ctx.compRecibos_reemplazar(cadena, patronOrigen, patronDestino);
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
function compRecibos_vencimiento(nodo:FLDomNode, campo:String):String
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flfactteso")) {
		return "";
	}
	var idFactura:String = nodo.attributeValue("facturascli.idfactura");
	var qryRecibos:FLSqlQuery = new FLSqlQuery();
	var vencimientos:String = "";
	var aPagar:Number = parseFloat(nodo.attributeValue("facturascli.total"));
	var compensado:Number = 0;
	with (qryRecibos) {
		setTablesList("reciboscli");
		setSelect("fechav,importe,estado");
		setFrom("reciboscli");
		setWhere("idfactura = '" + idFactura + "' ORDER BY fechav");
	}
	if (!qryRecibos.exec())
		return false;

	var fecha:Date;
	while (qryRecibos.next()) {
		fecha = util.dateAMDtoDMA(qryRecibos.value(0));
		importe = qryRecibos.value(1);
		if (qryRecibos.value(2) == "Compensado") {
			aPagar -= parseFloat(importe);
			compensado += parseFloat(importe);
		} else {
			if (vencimientos != "")
				vencimientos += ", ";
			vencimientos += fecha.substring(0,10) + " de " + importe ;
		}
	}
	aPagar = util.roundFieldValue(aPagar, "reciboscli", "importe");
	compensado = util.roundFieldValue(compensado, "reciboscli", "importe");
	if (compensado > 0)
		vencimientos += "   Total a pagar: " + aPagar + ".   Compensado: " + compensado;

	var res:String = this.iface.reemplazar(vencimientos, '-', '/');
	return res;
}

function compRecibos_reemplazar(cadena:String, patronOrigen:String, patronDestino:String):String
{
	var res:String = "";
	if (cadena != "") {
		for (var i:Number = 0; i < cadena.length; i++) {
			if (cadena.charAt(i) == patronOrigen)
				res += patronDestino;
			else
				res += cadena.charAt(i);
		}
	}
	return res;
}

//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////

