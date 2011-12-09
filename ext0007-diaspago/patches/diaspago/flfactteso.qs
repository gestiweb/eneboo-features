
/** @class_declaration diasPago */
/////////////////////////////////////////////////////////////////
//// DIAS_PAGO //////////////////////////////////////////////////
class diasPago extends oficial /** %from: oficial */ {
    function diasPago( context ) { oficial ( context ); }
	function calcFechaVencimientoCli(curFactura:FLSqlCursor, numPlazo:Number, diasAplazado:Number):String {
		return this.ctx.diasPago_calcFechaVencimientoCli(curFactura, numPlazo, diasAplazado);
	}
	function procesarDiasPagoCli(fechaV:String, diasPago:Array):String {
		return this.ctx.diasPago_procesarDiasPagoCli(fechaV, diasPago);
	}
	function procesarDiasPagoCliAnt(fechaV:String, diasPago:Array):String {
		return this.ctx.diasPago_procesarDiasPagoCliAnt(fechaV, diasPago);
	}
}
//// DIAS_PAGO //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition diasPago */
/////////////////////////////////////////////////////////////////
//// DIAS_PAGO //////////////////////////////////////////////////
/* \D Calcula la fecha de vencimiento de un recibo en base a los días de pago y vacaciones del cliente
@param curFactura: Cursor posicionado en el registro de facturas correspondiente a la factura
@param numPlazo: Número del plazo actual
@param diasAplazado: Días de aplazamiento del pago
@return Fecha de vencimiento
\end */
function diasPago_calcFechaVencimientoCli(curFactura:FLSqlCursor, numPlazo:Number, diasAplazado:Number):String
{
	var util:FLUtil = new FLUtil;
	var fechaFactura:String = curFactura.valueBuffer("fecha")
	var f:String = this.iface.__calcFechaVencimientoCli(curFactura, numPlazo, diasAplazado);

	var codCliente:String = curFactura.valueBuffer("codcliente");
	if (!codCliente || codCliente == "")
		return f;

	var diasPago:Array;
	var cadenaDiasPago:String = util.sqlSelect("clientes", "diaspago", "codcliente = '" + codCliente + "'");
	if (!cadenaDiasPago || cadenaDiasPago == "")
		diasPago = "";
	else
		diasPago = cadenaDiasPago.split(",");

	var buscarDia:String = util.sqlSelect("clientes", "buscardia", "codcliente = '" + codCliente + "'");
	if (buscarDia == "Anterior") {
		fechaVencimiento = this.iface.procesarDiasPagoCliAnt(f, diasPago);
		if (util.daysTo(fechaVencimiento, fechaFactura) > 0)
			fechaVencimiento = this.iface.procesarDiasPagoCli(f, diasPago);
	}
	else
		fechaVencimiento = this.iface.procesarDiasPagoCli(f, diasPago);

	return fechaVencimiento;
}

/** \D Modifica la fecha de vencimiento en función del día de pago del cliente, buscando el siguiente día de pago
@param	fechaV: String con la fecha de vencimiento actual
@param	diasPago: Array con los días de pago para cada plazo
@return	Fecha de vencimiento modificada
\end */
function diasPago_procesarDiasPagoCli(fechaV:String, diasPago:Array):String
{
	var util:FLUtil = new FLUtil;
	var fechaVencimiento:Date = new Date (Date.parse(fechaV.toString()));

	if (diasPago == "" || !diasPago)
		return fechaV;
	var diaFV:Number = parseFloat(fechaVencimiento.getDate());

	var i:Number = 0;
	var distancia:Number;
	var diaPago:Number;
	for (i = 0; i < diasPago.length && parseFloat(diasPago[i]) < diaFV; i++);

	if (i < diasPago.length) {
		diaPago = diasPago[i];
	} else {
		var aux = util.addMonths(fechaVencimiento.toString(), 1);
		fechaVencimiento = new Date(Date.parse(aux.toString()));
		diaPago = diasPago[0];
	}

	// Control de fechas inexistentes (30 de febrero, 31 de abril, etc)
	var fechaVencimientoBk:String = fechaVencimiento.toString();

	var paso:Number = 0;
	fechaVencimiento.setDate(diaPago);
	while (!fechaVencimiento) {
		fechaVencimiento = new Date(Date.parse(fechaVencimientoBk));
		fechaVencimiento.setDate(--diaPago);
		if (paso++ == 10) {
			MessageBox.warning(util.translate("scripts", "Hubo un problema al establecer el día de pago"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	return fechaVencimiento.toString();
}

/** \D Modifica la fecha de vencimiento en función del día de pago del cliente, buscando el anterior día de pago
@param	fechaV: String con la fecha de vencimiento actual
@param	diasPago: Array con los días de pago para cada plazo
@return	Fecha de vencimiento modificada
\end */
function diasPago_procesarDiasPagoCliAnt(fechaV:String, diasPago:Array):String
{
	var util:FLUtil = new FLUtil;
	var fechaVencimiento:Date = new Date (Date.parse(fechaV.toString()));
	if (diasPago == "" || !diasPago)
		return fechaV;
	var diaFV:Number = parseFloat(fechaVencimiento.getDate());
	var i:Number = 0;
	var distancia:Number;
	for (i = (diasPago.length - 1); i >= 0 && parseFloat(diasPago[i]) > diaFV; i--);
	if (i >= 0 ) {
		fechaVencimiento.setDate(diasPago[i]);
	} else {
		var aux = util.addMonths(fechaVencimiento.toString(), -1);
		fechaVencimiento = new Date(Date.parse(aux.toString()));
		fechaVencimiento.setDate(diasPago[(diasPago.length - 1)]);
	}

	return fechaVencimiento.toString();
}
//// DIAS_PAGO //////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

