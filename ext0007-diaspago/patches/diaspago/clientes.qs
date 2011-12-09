
/** @class_declaration diasPago */
/////////////////////////////////////////////////////////////////
//// DIAS_PAGO //////////////////////////////////////////////////
class diasPago extends oficial /** %from: oficial */ {
    function diasPago( context ) { oficial ( context ); }
	function validateForm():Boolean {
		return this.ctx.diasPago_validateForm();
	}
	function validarDiasPago():Boolean {
		return this.ctx.diasPago_validarDiasPago();
	}
}
//// DIAS_PAGO //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition diasPago */
/////////////////////////////////////////////////////////////////
//// DIAS_PAGO //////////////////////////////////////////////////
function diasPago_validateForm():Boolean
{
	if (!this.iface.__validateForm())
		return false;

	return this.iface.validarDiasPago();
}
/** \D
Comprueba que el valor del campo --diaspago-- es una lista de días válido ordenada de forma ascentente
@return	Verdadero si se cumplo, falso en caso contrario
\end */
function diasPago_validarDiasPago():Boolean
{
	var util = new FLUtil();
	var cursor:FLSqlCursor = form.cursor();
	var diasPago:String = cursor.valueBuffer("diaspago");
	if (!diasPago || diasPago == "")
			return true;
	var dia:Array = diasPago.split(",");
	var numDias = dia.length;
	if (numDias == 0) {
		MessageBox.warning(util.translate("scripts", "El formato de los días de pago no es válido"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var diaAnterior:Number = 0;
	for (var i:Number = 0; i < numDias; i++) {
		if (parseFloat(dia[i]) <= parseFloat(diaAnterior)) {
			MessageBox.warning(util.translate("scripts", "Los días de pago deben formar una lista ascendente"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		if (dia[i] > 31) {
			MessageBox.warning(util.translate("scripts", "El formato de los días de pago no es válido"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		diaAnterior = dia[i];
	}
	return true;
}
//// DIAS_PAGO //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

