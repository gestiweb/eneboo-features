
/** @class_declaration pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI ////////////////////////////////////////////////
class pagosMulti extends oficial /** %from: oficial */ {
    function pagosMulti( context ) { oficial ( context ); }
	function cambiaUltimoPagoCli(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean {
		return this.ctx.pagosMulti_cambiaUltimoPagoCli(idRecibo, idPagoDevol, unlock);
	}
	function beforeCommit_pagosmulticli(curPM:FLSqlCursor):Boolean {
		return this.ctx.pagosMulti_beforeCommit_pagosmulticli(curPM);
	}
	function generarAsientoPagoMultiCli(curPM:FLSqlCursor):Boolean {
		return this.ctx.pagosMulti_generarAsientoPagoMultiCli(curPM);
	}
	function generarPartidaDifCambioPM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMulti_generarPartidaDifCambioPM(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidaBancoPM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMulti_generarPartidaBancoPM(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidaClientePM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMulti_generarPartidaClientePM(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidasPM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMulti_generarPartidasPM(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidasFacClientePM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMulti_generarPartidasFacClientePM(curPM, valoresDefecto, datosAsiento);
	}
	function afterCommit_pagosmulticli(curPM:FLSqlCursor):Boolean {
		return this.ctx.pagosMulti_afterCommit_pagosmulticli(curPM);
	}
}
//// PAGOS MULTI ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI ////////////////////////////////////////////////
/** \D Cambia la el estado del último pago anterior al especificado, de forma que se mantenga como único pago editable el último de todos. Si el pago anterior proviene de un pago múltiple, no pasa a ser editable
@param	idRecibo: Identificador del recibo al que pertenecen los pagos tratados
@param	idPagoDevol: Identificador del pago que ha cambiado
@param	unlock: Indicador de si el últim pago debe ser editable o no
@return	true si la verificación del estado es correcta, false en caso contrario
\end */
function pagosMulti_cambiaUltimoPagoCli(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean
{
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolcli");
	curPagosDevol.select("idrecibo = " + idRecibo + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
	if (curPagosDevol.last()) {
		if (!curPagosDevol.isNull("idpagomulti"))
			return true;
		curPagosDevol.setUnLock("editable", unlock);
	}

	return true;
}

/** \C Antes de borrar el pago múltiple se borran los registros de pago de los recibos asociados
\end */
function pagosMulti_beforeCommit_pagosmulticli(curPM:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curPM.modeAccess()) {
		case curPM.Del: {
			var idPagoMulti:String = curPM.valueBuffer("idpagomulti");
			var qryPagos:FLSqlQuery = new FLSqlQuery();
			qryPagos.setTablesList("pagosdevolcli");
			qryPagos.setSelect("idrecibo");
			qryPagos.setFrom("pagosdevolcli");
			qryPagos.setWhere("idpagomulti = " + idPagoMulti);
			try { qryPagos.setForwardOnly( true ); } catch (e) {}
			if (!qryPagos.exec())
				return false;

			while (qryPagos.next()) {
				if (!formRecordpagosmulticli.iface.pub_excluirDePagoMulti(idPagoMulti, qryPagos.value(0)))
					return false;
			}
			break;
		}
	}
	if (sys.isLoadedModule("flcontppal") && !curPM.valueBuffer("nogenerarasiento") && util.sqlSelect("empresa", "contintegrada", "1 = 1")) {
		if (!this.iface.generarAsientoPagoMultiCli(curPM))
			return false;
	}

	return true;
}

/** \Genera o regenera el asiento contable asociado a un pago múltiple de recibos
@param	curPM: Cursor posicionado en el pago múltiple
@return	true si la regeneración se realiza correctamente, false en caso contrario
\end */
function pagosMulti_generarAsientoPagoMultiCli(curPM:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curPM.modeAccess() != curPM.Insert && curPM.modeAccess() != curPM.Edit) {
		return true;
	}
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPM.valueBuffer("fecha"), codEjercicio, "pagosdevolcli");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		curPM.setValueBuffer("fecha", datosDoc.fecha);
	}

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

	if (parseFloat(curPM.valueBuffer("importe")) == 0) {
		var idAsiento:String = curPM.valueBuffer("idasiento");
		if (idAsiento) {
			var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
			curAsiento.select("idasiento = " + idAsiento);
			if (!curAsiento.first())
				return false;
			curAsiento.setUnLock("editable", true);
			if (!util.sqlDelete("co_asientos", "idasiento = " + idAsiento))
				return false;
			curPM.setNull("idasiento");
		}
		return true;
	}

	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);
	try {
		datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPM, valoresDefecto);
		if (datosAsiento.error == true) {
			throw util.translate("scripts", "Error al regenerar el asiento");
		}
		/** \C La cuenta del haber del asiento de pago será la misma cuenta de tipo CLIENT que se usó para realizar el asiento de las correspondientes facturas. Todos los asientos deben estar asignados a la misma subcuenta de cliente
		\end */
		var qryAsientos:FLSqlQuery = new FLSqlQuery();
		qryAsientos.setTablesList("facturascli,reciboscli,pagosdevolcli");
		qryAsientos.setSelect("f.idasiento, r.codigo, f.tasaconv, f.nombrecliente, r.importeeuros");
		qryAsientos.setFrom("pagosdevolcli p INNER JOIN reciboscli r ON p.idrecibo = r.idrecibo INNER JOIN facturascli f ON f.idfactura = r.idfactura")
		qryAsientos.setWhere("p.idpagomulti = " + curPM.valueBuffer("idpagomulti"));
		qryAsientos.setForwardOnly( true );
		if (!qryAsientos.exec()) {
			throw util.translate("scripts", "Error obtener los datos del pago múltiple");
		}
		var listaRecibos:String = "";
		var nombreCliente:String = "";
		var codSubcuentaHaberPrevia:String = "";
		var codSubcuentaHaber:String = "";
		var tasaConvFactPrevia:Number = -1;
		var tasaConvFact:Number = -1;
		var tasasConvIguales:Boolean = true;
		var importeEuros:Number = 0;

		while (qryAsientos.next()) {
			codSubcuentaHaber = util.sqlSelect("co_partidas p" +
			" INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta" +
			" INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta",
			"s.codsubcuenta",
			"p.idasiento = " + qryAsientos.value(0) + " AND c.idcuentaesp = 'CLIENT'",
			"co_partidas,co_subcuentas,co_cuentas");

			if (!codSubcuentaHaber) {
				throw util.translate("scripts", "No se ha encontrado la subcuenta de cliente del asiento contable correspondiente a la factura del recibo").arg(qryAsientos.value(1));
			}

			if (codSubcuentaHaberPrevia == "") {
				codSubcuentaHaberPrevia = codSubcuentaHaber;
			}
			if (codSubcuentaHaberPrevia != codSubcuentaHaber) {
				throw  util.translate("scripts", "No puede generarse el asiento correspondiente al pago múltiple porque los asientos asociados a las facturas que\ngeneraron los recibos están asociados a distintas cuentas de cliente");
			}
			codSubcuentaHaberPrevia = codSubcuentaHaber;

			if (tasasConvIguales) {
				tasaConvFact = parseFloat(qryAsientos.value("f.tasaconv"));
				tasaConvFact = util.roundFieldValue(tasaConvFact, "facturascli", "tasaconv");
				if (tasaConvFactPrevia == -1) {
					tasaConvFactPrevia = tasaConvFact;
				}
				if (tasaConvFactPrevia != tasaConvFact) {
					tasasConvIguales = false;
				}
				tasaConvFactPrevia = tasaConvFact;
			}

			if (listaRecibos != "") {
				listaRecibos += ", ";
			}
			listaRecibos += qryAsientos.value("r.codigo");
			nombreCliente = qryAsientos.value("f.nombrecliente");

			importeEuros += parseFloat(qryAsientos.value("r.importeeuros"));
		}

		if (!tasasConvIguales) {
			tasaConvFact = false;
		}

		valoresDefecto["codsubcuentacliente"] = codSubcuentaHaber;
		valoresDefecto["tasaconvfact"] = tasaConvFact;
		valoresDefecto["lista"] = listaRecibos;
		valoresDefecto["nombrecliente"] = nombreCliente;

		if (!this.iface.generarPartidasPM(curPM, valoresDefecto, datosAsiento)) {
			throw util.translate("scripts", "Error al generar las partidas del pago múltiple");
		}
		curPM.setValueBuffer("idasiento", datosAsiento.idasiento);
		if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
			throw util.translate("scripts", "Error al comprobar el asiento");
		}
	} catch (e) {
		curTransaccion.rollback();
		MessageBox.warning(util.translate("scripts", "Error al generar el asiento del pago múltiple:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	curTransaccion.commit();
	return true;
}

function pagosMulti_generarPartidasPM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.generarPartidaClientePM(curPM, valoresDefecto, datosAsiento))
		return false;

	if (!this.iface.generarPartidaBancoPM(curPM, valoresDefecto, datosAsiento))
		return false;

	if (!this.iface.generarPartidaDifCambioPM(curPM, valoresDefecto, datosAsiento))
		return false;

	return true;
}

function pagosMulti_generarPartidaClientePM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	if (valoresDefecto.coddivisa != curPM.valueBuffer("coddivisa")) {
		if (!valoresDefecto["tasaconvfact"]) {
			return this.iface.generarPartidasFacClientePM(curPM, valoresDefecto, datosAsiento);
		}
	}

	var util:FLUtil = new FLUtil;

	var ctaHaber:Array = [];
	var haber:Number = 0;
	var haberME:Number = 0;
	var tasaconvHaber:Number = 1;
	var diferenciaCambio:Number = 0;

	ctaHaber.codsubcuenta = valoresDefecto["codsubcuentacliente"];
	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaHaber.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (valoresDefecto.coddivisa == curPM.valueBuffer("coddivisa")) {
		haber = curPM.valueBuffer("importe");
		haberMe = 0;
	} else {
		tasaconvHaber = valoresDefecto["tasaconvfact"];
		haber = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvHaber)
		haberME = parseFloat(curPM.valueBuffer("importe"));
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", "Pago recibos " + valoresDefecto["lista"] + " - " + valoresDefecto["nombrecliente"]);
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", curPM.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", tasaconvHaber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
	if (!curPartida.commitBuffer())
			return false;

	return true;
}

/** \D Genera las partidas de cliente, una por recibo, para el caso de que la divisa sea extranjera y haya distintas tasas de conversión entre los recibos
\end */
function pagosMulti_generarPartidasFacClientePM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	var ctaHaber:Array = [];
	var haber:Number = 0;
	var haberME:Number = 0;
	var tasaconvHaber:Number = 1;
	var diferenciaCambio:Number = 0;

	ctaHaber.codsubcuenta = valoresDefecto["codsubcuentacliente"];
	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaHaber.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	valoresDefecto["haberdifcambio"] = 0;
	var qryRecibos:FLSqlQuery = new FLSqlQuery;
	with (qryRecibos) {
		setTablesList("reciboscli,facturascli,pagosdevolcli");
		setSelect("r.importe, f.tasaconv, r.codigo");
		setFrom("pagosdevolcli pd INNER JOIN reciboscli r ON pd.idrecibo = r.idrecibo INNER JOIN facturascli f ON r.idfactura = f.idfactura");
		setWhere("pd.idpagomulti = " + curPM.valueBuffer("idpagomulti"));
		setForwardOnly(true);
	}
	if (!qryRecibos.exec())
		return false;

	while (qryRecibos.next()) {
		tasaconvHaber = qryRecibos.value("f.tasaconv");
		haber = parseFloat(qryRecibos.value("r.importe")) * parseFloat(tasaconvHaber)
		haberME = parseFloat(qryRecibos.value("r.importe"));

		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", util.translate("scripts", "Pago recibo %1 - %2").arg(qryRecibos.value("r.codigo")).arg(valoresDefecto["nombrecliente"]));
			setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
			setValueBuffer("idasiento", datosAsiento.idasiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("coddivisa", curPM.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", tasaconvHaber);
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}
		if (!curPartida.commitBuffer())
			return false;

		valoresDefecto["haberdifcambio"] += parseFloat(haber);
	}

	return true;
}

function pagosMulti_generarPartidaBancoPM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	var ctaDebe:Array = [];
	ctaDebe.idsubcuenta = curPM.valueBuffer("idsubcuenta");
	ctaDebe.codsubcuenta = curPM.valueBuffer("codsubcuenta");

	var debe:Number = 0;
	var debeME:Number = 0;
	var tasaconvDebe:Number = 1;
	var diferenciaCambio:Number = 0;

	if (valoresDefecto.coddivisa == curPM.valueBuffer("coddivisa")) {
		debe = curPM.valueBuffer("importe");
		debeME = 0;
	} else {
		tasaconvDebe = curPM.valueBuffer("tasaconv");
		debe = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvDebe);
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
	}
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", "Pago recibos " + valoresDefecto["lista"] + " - " + valoresDefecto["nombrecliente"]);
		setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("coddivisa", curPM.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", tasaconvDebe);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

function pagosMulti_generarPartidaDifCambioPM(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	if (valoresDefecto.coddivisa == curPM.valueBuffer("coddivisa"))
		return true;

	var tasaconvDebe:Number = curPM.valueBuffer("tasaconv");
	var debe:Number = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvDebe);
	var tasaconvHaber:Number = valoresDefecto["tasaconvfact"];
	var haber:Number
	if (tasaconvHaber)
		haber = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvHaber);
	else
		haber = parseFloat(valoresDefecto["haberdifcambio"]);

	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	/** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado desde el momento de la emisión de la factura, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
	\end */
	var diferenciaCambio:Number = debe - haber;
	if (diferenciaCambio != 0) {
		var ctaDifCambio:Array = [];
		var debeDifCambio:Number = 0;
		var haberDifCambio:Number = 0;
		if (diferenciaCambio > 0) {
			ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMPOS", valoresDefecto.codejercicio);
			if (ctaDifCambio.error != 0)
				return false;
			debeDifCambio = 0;
			haberDifCambio = diferenciaCambio;
		} else {
			ctaDifCambio = flfacturac.iface.pub_datosCtaEspecial("CAMNEG", valoresDefecto.codejercicio);
			if (ctaDifCambio.error != 0)
				return false;
			diferenciaCambio = 0 - diferenciaCambio;
			debeDifCambio = diferenciaCambio;
			haberDifCambio = 0;
		}

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", "Pago recibos " + valoresDefecto["lista"] + " - " + valoresDefecto["nombrecliente"]);
			setValueBuffer("idsubcuenta", ctaDifCambio.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaDifCambio.codsubcuenta);
			setValueBuffer("idasiento", datosAsiento.idasiento);
			setValueBuffer("debe", debeDifCambio);
			setValueBuffer("haber", haberDifCambio);
			setValueBuffer("coddivisa", valoresDefecto.coddivisa);
			setValueBuffer("tasaconv", 1);
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", 0);
		}
		if (!curPartida.commitBuffer())
			return false;
	}
	return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function pagosMulti_afterCommit_pagosmulticli(curPM:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
		return true;

	switch (curPM.modeAccess()) {
		case curPM.Del: {
			if (curPM.isNull("idasiento"))
				return true;

			var idAsiento:Number = curPM.valueBuffer("idasiento");
			if (flfacturac.iface.pub_asientoBorrable(idAsiento) == false)
				return false;

			var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
			curAsiento.select("idasiento = " + idAsiento);
			if (curAsiento.first()) {
				curAsiento.setUnLock("editable", true);
				curAsiento.setModeAccess(curAsiento.Del);
				curAsiento.refreshBuffer();
				if (!curAsiento.commitBuffer())
					return false;
			}
			break;
		}
		case curPM.Edit: {
			if (curPM.valueBuffer("nogenerarasiento")) {
				var idAsientoAnterior:String = curPM.valueBufferCopy("idasiento");
				if (idAsientoAnterior && idAsientoAnterior != "") {
					if (!flfacturac.iface.pub_eliminarAsiento(idAsientoAnterior))
						return false;
				}
			}
			break;
		}
	}

	return true;
}
//// PAGOS MULTI ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

