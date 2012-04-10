
/** @class_declaration pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI PROVEEDORES ////////////////////////////////////
class pagosMultiProv extends proveed /** %from: oficial */ {
    function pagosMultiProv( context ) { proveed ( context ); }
	function cambiaUltimoPagoProv(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean {
		return this.ctx.pagosMultiProv_cambiaUltimoPagoProv(idRecibo, idPagoDevol, unlock);
	}
	function beforeCommit_pagosmultiprov(curPM:FLSqlCursor):Boolean {
		return this.ctx.pagosMultiProv_beforeCommit_pagosmultiprov(curPM);
	}
	function generarAsientoPagoMultiProv(curPM:FLSqlCursor):Boolean {
		return this.ctx.pagosMultiProv_generarAsientoPagoMultiProv(curPM);
	}
	function generarPartidasPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMultiProv_generarPartidasPMProv(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidaProveedorPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMultiProv_generarPartidaProveedorPMProv(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidaBancoPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMultiProv_generarPartidaBancoPMProv(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidaDifCambioPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMultiProv_generarPartidaDifCambioPMProv(curPM, valoresDefecto, datosAsiento);
	}
	function generarPartidasFacProveedorPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean {
		return this.ctx.pagosMultiProv_generarPartidasFacProveedorPMProv(curPM, valoresDefecto, datosAsiento);
	}
	function afterCommit_pagosmultiprov(curPM:FLSqlCursor):Boolean {
		return this.ctx.pagosMultiProv_afterCommit_pagosmultiprov(curPM);
	}
}
//// PAGOS MULTI PROVEEDORES ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOS MULTI PROVEEDOR //////////////////////////////////////

/** \D Cambia la el estado del último pago anterior al especificado, de forma que se mantenga como único pago editable el último de todos. Si el pago anterior proviene de un pago múltiple, no pasa a ser editable
@param	idRecibo: Identificador del recibo al que pertenecen los pagos tratados
@param	idPagoDevol: Identificador del pago que ha cambiado
@param	unlock: Indicador de si el últim pago debe ser editable o no
@return	true si la verificación del estado es correcta, false en caso contrario
\end */
function pagosMultiProv_cambiaUltimoPagoProv(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean
{
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
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
function pagosMultiProv_beforeCommit_pagosmultiprov(curPM:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	switch (curPM.modeAccess()) {
		case curPM.Del: {
			var idPagoMulti:String = curPM.valueBuffer("idpagomulti");
			var qryPagos:FLSqlQuery = new FLSqlQuery();
			qryPagos.setTablesList("pagosdevolprov");
			qryPagos.setSelect("idrecibo");
			qryPagos.setFrom("pagosdevolprov");
			qryPagos.setWhere("idpagomulti = " + idPagoMulti);
			try { qryPagos.setForwardOnly( true ); } catch (e) {}
			if (!qryPagos.exec())
				return false;

			while (qryPagos.next()) {
				if (!formRecordpagosmultiprov.iface.pub_excluirDePagoMulti(idPagoMulti, qryPagos.value(0)))
					return false;
			}
			break;
		}
	}
	if (sys.isLoadedModule("flcontppal") && !curPM.valueBuffer("nogenerarasiento") && util.sqlSelect("empresa", "contintegrada", "1 = 1")) {
		if (!this.iface.generarAsientoPagoMultiProv(curPM))
			return false;
	}

	return true;
}

/** \Genera o regenera el asiento contable asociado a un pago múltiple de recibos
@param	curPM: Cursor posicionado en el pago múltiple
@return	true si la regeneración se realiza correctamente, false en caso contrario
\end */
function pagosMultiProv_generarAsientoPagoMultiProv(curPM:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curPM.modeAccess() != curPM.Insert && curPM.modeAccess() != curPM.Edit)
		return true;

	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPM.valueBuffer("fecha"), codEjercicio, "pagosdevolprov");
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
		/** \C La cuenta del debe del asiento de pago será la misma cuenta de tipo PROVEE que se usó para realizar el asiento de las correspondientes facturas. Todos los asientos deben estar asignados a la misma subcuenta de proveedor
		\end */
		var qryAsientos:FLSqlQuery = new FLSqlQuery();
		qryAsientos.setTablesList("facturasprov,recibosprov,pagosdevolprov");
		qryAsientos.setSelect("f.idasiento, r.codigo, f.tasaconv, f.nombre, r.importeeuros");
		qryAsientos.setFrom("pagosdevolprov p INNER JOIN recibosprov r ON p.idrecibo = r.idrecibo INNER JOIN facturasprov f ON f.idfactura = r.idfactura")
		qryAsientos.setWhere("p.idpagomulti = " + curPM.valueBuffer("idpagomulti"));
		qryAsientos.setForwardOnly( true );
		if (!qryAsientos.exec()) {
			throw util.translate("scripts", "Error al obtener los datos del pago múltiple");
		}
		var listaRecibos:String = "";
		var nombreProv:String = "";
		var codSubcuentaDebePrevia:String = "";
		var codSubcuentaDebe:String = "";
		var tasaConvFactPrevia:Number = -1;
		var tasaConvFact:Number = -1;
		var tasasConvIguales:Boolean = true;
		var importeEuros:Number = 0;

		while (qryAsientos.next()) {
			codSubcuentaDebe = util.sqlSelect("co_partidas p" +
			" INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta" +
			" INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta",
			"s.codsubcuenta",
			"p.idasiento = " + qryAsientos.value(0) + " AND c.idcuentaesp = 'PROVEE'",
			"co_partidas,co_subcuentas,co_cuentas");

			if (!codSubcuentaDebe) {
				throw util.translate("scripts", "No se ha encontrado la subcuenta de proveedor del asiento contable correspondiente a la factura del recibo %1").arg(qryAsientos.value(1));
			}

			if (codSubcuentaDebePrevia == "")
				codSubcuentaDebePrevia = codSubcuentaDebe;
			if (codSubcuentaDebePrevia != codSubcuentaDebe) {
				throw util.translate("scripts", "No puede generarse el asiento correspondiente al pago múltiple porque los asientos asociados a las facturas que\ngeneraron los recibos están asociados a distintas cuentas de proveedor");
			}
			codSubcuentaDebePrevia = codSubcuentaDebe;

			if (tasasConvIguales) {
				tasaConvFact = parseFloat(qryAsientos.value("f.tasaconv"));
				tasaConvFact = util.roundFieldValue(tasaConvFact, "facturasprov", "tasaconv");
				if (tasaConvFactPrevia == -1)
					tasaConvFactPrevia = tasaConvFact;

				if (tasaConvFactPrevia != tasaConvFact)
					tasasConvIguales = false;

				tasaConvFactPrevia = tasaConvFact;
			}
			if (listaRecibos != "") {
				listaRecibos += ", ";
			}
			listaRecibos += qryAsientos.value("r.codigo");
			nombreProv = qryAsientos.value("f.nombre");

			importeEuros += parseFloat(qryAsientos.value("r.importeeuros"));
		}

		if (!tasasConvIguales) {
			tasaConvFact = false;
		}

		valoresDefecto["codsubcuentaproveedor"] = codSubcuentaDebe;
		valoresDefecto["tasaconvfact"] = tasaConvFact;
		valoresDefecto["lista"] = listaRecibos;
		valoresDefecto["nombreprov"] = nombreProv;

		if (!this.iface.generarPartidasPMProv(curPM, valoresDefecto, datosAsiento)) {
			throw util.translate("scripts", "Error al obtener los las partidas del pago múltiple");
		}
		curPM.setValueBuffer("idasiento", datosAsiento.idasiento);
		if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
			throw util.translate("scripts", "Error al comprobar el asiento");
		}
	} catch (e) {
		curTransaccion.rollback();
		MessageBox.warning(util.translate("scripts", "Error al generar el asiento de pago múltiple:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	curTransaccion.commit();

	return true;
}

function pagosMultiProv_generarPartidasPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.generarPartidaProveedorPMProv(curPM, valoresDefecto, datosAsiento))
		return false;

	if (!this.iface.generarPartidaBancoPMProv(curPM, valoresDefecto, datosAsiento))
		return false;

	if (!this.iface.generarPartidaDifCambioPMProv(curPM, valoresDefecto, datosAsiento))
		return false;

	return true;
}

function pagosMultiProv_generarPartidaProveedorPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	if (valoresDefecto.coddivisa != curPM.valueBuffer("coddivisa")) {
		if (!valoresDefecto["tasaconvfact"]) {
			return this.iface.generarPartidasFacProveedorPMProv(curPM, valoresDefecto, datosAsiento);
		}
	}

	var util:FLUtil = new FLUtil;

	var ctaDebe:Array = [];
	var debe:Number = 0;
	var debeME:Number = 0;
	var tasaconvDebe:Number = 1;

	ctaDebe.codsubcuenta = valoresDefecto["codsubcuentaproveedor"];
	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaDebe.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (valoresDefecto.coddivisa == curPM.valueBuffer("coddivisa")) {
		debe = curPM.valueBuffer("importe");
		debeMe = 0;
	} else {
		tasaconvDebe = valoresDefecto["tasaconvfact"];
		debe = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvDebe)
		debeME = parseFloat(curPM.valueBuffer("importe"));
	}
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", "Pago recibos " + valoresDefecto["lista"] + " - " + valoresDefecto["nombreprov"]);
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

/** \D Genera las partidas de proveedor, una por recibo, para el caso de que la divisa sea extranjera y haya distintas tasas de conversión entre los recibos
\end */
function pagosMultiProv_generarPartidasFacProveedorPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	var ctaDebe:Array = [];
	var debe:Number = 0;
	var debeME:Number = 0;
	var tasaconvDebe:Number = 1;

	ctaDebe.codsubcuenta = valoresDefecto["codsubcuentaproveedor"];
	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaDebe.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	valoresDefecto["debedifcambio"] = 0;
	var qryRecibos:FLSqlQuery = new FLSqlQuery;
	with (qryRecibos) {
		setTablesList("recibosprov,facturasprov,pagosdevolprov");
		setSelect("r.importe, f.tasaconv, r.codigo");
		setFrom("pagosdevolprov pd INNER JOIN recibosprov r ON pd.idrecibo = r.idrecibo INNER JOIN facturasprov f ON r.idfactura = f.idfactura");
		setWhere("pd.idpagomulti = " + curPM.valueBuffer("idpagomulti"));
		setForwardOnly(true);
	}
	if (!qryRecibos.exec())
		return false;

	while (qryRecibos.next()) {
		tasaconvDebe = qryRecibos.value("f.tasaconv");
		debe = parseFloat(qryRecibos.value("r.importe")) * parseFloat(tasaconvDebe)
		debeME = parseFloat(qryRecibos.value("r.importe"));

		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", util.translate("scripts", "Pago recibo %1 - %2").arg(qryRecibos.value("r.codigo")).arg(valoresDefecto["nombreprov"]));
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

		valoresDefecto["debedifcambio"] += parseFloat(debe);
	}

	return true;
}

function pagosMultiProv_generarPartidaBancoPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	var ctaHaber:Array = [];
	ctaHaber.idsubcuenta = curPM.valueBuffer("idsubcuenta");
	ctaHaber.codsubcuenta = curPM.valueBuffer("codsubcuenta");

	var haber:Number = 0;
	var haberME:Number = 0;
	var tasaconvHaber:Number = 1;

	if (valoresDefecto.coddivisa == curPM.valueBuffer("coddivisa")) {
		haber = curPM.valueBuffer("importe");
		haberME = 0;
	} else {
		tasaconvHaber= curPM.valueBuffer("tasaconv");
		haber = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvHaber);
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", "Pago recibos " + valoresDefecto["lista"] + " - " + valoresDefecto["nombreprov"]);
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

function pagosMultiProv_generarPartidaDifCambioPMProv(curPM:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	if (valoresDefecto.coddivisa == curPM.valueBuffer("coddivisa"))
		return true;

	var tasaconvHaber:Number = curPM.valueBuffer("tasaconv");
	var haber:Number = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvHaber);
	var tasaconvDebe:Number = valoresDefecto["tasaconvfact"];
	var debe:Number
	if (tasaconvDebe)
		debe = parseFloat(curPM.valueBuffer("importe")) * parseFloat(tasaconvDebe)
	else
		debe = parseFloat(valoresDefecto["debedifcambio"]);

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
			setValueBuffer("concepto", "Pago recibos " + valoresDefecto["lista"] + " - " + valoresDefecto["nombreprov"]);
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
function pagosMultiProv_afterCommit_pagosmultiprov(curPM:FLSqlCursor):Boolean
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
//// PAGOS MULTI PROVEEDOR //////////////////////////////////////
/////////////////////////////////////////////////////////////////

