
/** @class_declaration gastoDevol */
/////////////////////////////////////////////////////////////////
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
class gastoDevol extends oficial /** %from: oficial */ {
    function gastoDevol( context ) { oficial ( context ); }
	function datosReciboCli() {
		return this.ctx.gastoDevol_datosReciboCli();
	}
	function generarPartidasBanco(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean {
		return this.ctx.gastoDevol_generarPartidasBanco(curPD, valoresDefecto, datosAsiento, recibo);
	}
	function generarPartidasCli(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean {
		return this.ctx.gastoDevol_generarPartidasCli(curPD, valoresDefecto, datosAsiento, recibo);
	}
}
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gastoDevol */
/////////////////////////////////////////////////////////////////
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
function gastoDevol_datosReciboCli():Boolean
{
	if (!this.iface.__datosReciboCli())
		return false;

	this.iface.curReciboCli.setValueBuffer("importesingd", this.iface.curReciboCli.valueBuffer("importe"));
	return true;
}

/** \D Genera la partida correspondiente al banco o a caja del asiento de pago
@param	curPD: Cursor del pago o devolución
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@param	recibo: Array con los datos del recibo asociado al pago
@return	true si la generación es correcta, false en caso contrario
\end */
function gastoDevol_generarPartidasBanco(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaDebe:Array = [];
	ctaDebe.codsubcuenta = curPD.valueBuffer("codsubcuenta");
	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var debe:Number = 0;
	var debeME:Number = 0;
	var tasaconvDebe:Number = 1;
	var importeTotal:Number;
	var esPago:Boolean = this.iface.esPagoEstePagoDevol(curPD);

	if (esPago) {
		importeTotal = recibo.importe;
	} else {
		importeTotal = recibo.importe - parseFloat(curPD.valueBufferCopy("gastodevol")) + parseFloat(curPD.valueBuffer("gastodevol"));
	}
	if (valoresDefecto.coddivisa == recibo.coddivisa) {
		debe = importeTotal;
		debeME = 0;
	} else {
		tasaconvDebe = curPD.valueBuffer("tasaconv");
		debe = parseFloat(importeTotal) * parseFloat(tasaconvDebe);
		debeME = parseFloat(importeTotal);
	}
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var esAbono:Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");


	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		try {
			setValueBuffer("concepto", datosAsiento.concepto);
		} catch (e) {
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
		}
		setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		if (esPago) {
			if (esAbono) {
				setValueBuffer("debe", 0);
				setValueBuffer("haber", debe * -1);
			} else {
				setValueBuffer("debe", debe);
				setValueBuffer("haber", 0);
			}
		} else {
			if (esAbono) {
				setValueBuffer("haber", 0);
				setValueBuffer("debe", debe * -1);
			} else {
				setValueBuffer("haber", debe);
				setValueBuffer("debe", 0);
			}
		}

		setValueBuffer("coddivisa", recibo.coddivisa);
		setValueBuffer("tasaconv", tasaconvDebe);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

function gastoDevol_generarPartidasCli(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaHaber:Array = [];
	/** \C La cuenta del haber del asiento de pago será la misma cuenta de tipo CLIENT que se usó para realizar el asiento de la correspondiente factura
	\end */
	var idAsientoFactura:Number = util.sqlSelect("reciboscli r INNER JOIN facturascli f" +
		" ON r.idfactura = f.idfactura", "f.idasiento",
		"r.idrecibo = " + curPD.valueBuffer("idrecibo"),
		"facturascli,reciboscli");

	var codEjercicioFac:String = util.sqlSelect("co_asientos", "codejercicio", "idasiento = " + idAsientoFactura);
	if (codEjercicioFac == valoresDefecto.codejercicio) {
		ctaHaber.codsubcuenta = util.sqlSelect("co_partidas p" +
			" INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta" +
			" INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta",
			"s.codsubcuenta",
			"p.idasiento = " + idAsientoFactura + " AND c.idcuentaesp = 'CLIENT'",
			"co_partidas,co_subcuentas,co_cuentas");

		if (!ctaHaber.codsubcuenta) {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado la subcuenta de cliente del asiento contable correspondiente a la factura a pagar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	} else {
		var codCliente:String = util.sqlSelect("reciboscli", "codcliente", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (codCliente && codCliente != "") {
			ctaHaber.codsubcuenta = util.sqlSelect("co_subcuentascli", "codsubcuenta", "codcliente = '" + codCliente + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
			if (!ctaHaber.codsubcuenta) {
				MessageBox.warning(util.translate("scripts", "El cliente %1 no tiene definida ninguna subcuenta en el ejercicio %2.\nEspecifique la subcuenta en la pestaña de contabilidad del formulario de clientes").arg(codCliente).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		} else {
			ctaHaber = flfacturac.iface.pub_datosCtaEspecial("CLIENT", valoresDefecto.codejercicio);
			if (!ctaHaber.codsubcuenta) {
				MessageBox.warning(util.translate("scripts", "No tiene definida ninguna cuenta de tipo CLIENT.\nDebe crear este tipo especial y asociarlo a una cuenta\nen el módulo principal de contabilidad"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}

	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaHaber.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;
	var tasaconvHaber:Number = 1;

	var importeTotal:Number;
	var esPago:Boolean = this.iface.esPagoEstePagoDevol(curPD);
	if (esPago) {
		importeTotal = recibo.importe;
	} else {
		importeTotal = recibo.importe - parseFloat(curPD.valueBufferCopy("gastodevol")) + parseFloat(curPD.valueBuffer("gastodevol"));
	}

	if (valoresDefecto.coddivisa == recibo.coddivisa) {
		haber = importeTotal;
		haberMe = 0;
	} else {
		tasaconvHaber = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");
		haber = parseFloat(importeTotal) * parseFloat(tasaConvHaber);
		haberME = parseFloat(importeTotal);
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var esAbono:Boolean = util.sqlSelect("reciboscli r INNER JOIN facturascli f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "reciboscli,facturascli");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		try {
			setValueBuffer("concepto", datosAsiento.concepto);
		} catch (e) {
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo " + recibo.codigo + " - " + recibo.nombrecliente);
		}
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		if (esPago) {
			if (esAbono) {
				setValueBuffer("debe", haber * -1);
				setValueBuffer("haber", 0);
			} else {
				setValueBuffer("debe", 0);
				setValueBuffer("haber", haber);
			}
		} else {
			if (esAbono) {
				setValueBuffer("haber", haber * -1);
				setValueBuffer("debe", 0);
			} else {
				setValueBuffer("haber", 0);
				setValueBuffer("debe", haber);
			}
		}
		setValueBuffer("coddivisa", recibo.coddivisa);
		setValueBuffer("tasaconv", tasaconvHaber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
/////////////////////////////////////////////////////////////////

