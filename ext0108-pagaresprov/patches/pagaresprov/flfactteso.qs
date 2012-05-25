
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
class pagareProv extends proveed /** %from: proveed */ {
    function pagareProv( context ) { proveed ( context ); }
	function generarAsientoPagoDevolProv(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_generarAsientoPagoDevolProv(curPD);
	}
	function beforeCommit_pagaresprov(curPagare:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_beforeCommit_pagaresprov(curPagare);
	}
	function beforeCommit_pagospagareprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_beforeCommit_pagospagareprov(curPD);
	}
	function afterCommit_pagospagareprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_afterCommit_pagospagareprov(curPD);
	}
	function generarPartidasBancoPagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean {
		return this.ctx.pagareProv_generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare);
	}
	function generarPartidasPtePagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean {
		return this.ctx.pagareProv_generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare);
	}
	function generarAsientoPagoPagareProv(curPD:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_generarAsientoPagoPagareProv(curPD);
	}
	function cambiaUltimoPagoPagProv(idPagare:String, idPagoDevol:String, unlock:Boolean):Boolean {
		return this.ctx.pagareProv_cambiaUltimoPagoPagProv(idPagare, idPagoDevol, unlock);
	}
	function comprobarFechasPagares(curPagare:FLSqlCursor):Boolean {
		return this.ctx.pagareProv_comprobarFechasPagares(curPagare);
	}
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
function pagareProv_generarAsientoPagoDevolProv(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
		return true;

	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPD.valueBuffer("fecha"), codEjercicio, "pagosdevolprov");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		curPD.setValueBuffer("fecha", datosDoc.fecha);
	}

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);
	try {
		datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
		if (datosAsiento.error == true) {
			throw util.translate("scripts", "Error al regenerar el asiento");
		}
		if (curPD.valueBuffer("tipo") == "Pago") {
			var recibo:Array = flfactppal.iface.pub_ejecutarQry("recibosprov", "coddivisa,importe,importeeuros,idfactura,codigo,nombreproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
			if (recibo.result != 1) {
				throw util.translate("scripts", "Error al obtener los datos del recibo");
			}
			if (!this.iface.generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al generar la partida de proveedor");
			}
			if (!this.iface.generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al generar la partida de banco");
			}
			if (!this.iface.generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al generar la partida de diferencias por cambio");
			}
		} else if (curPD.valueBuffer("tipo") == "Pagaré") {
			var recibo:Array = flfactppal.iface.pub_ejecutarQry("recibosprov", "coddivisa,importe,importeeuros,idfactura,codigo,nombreproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
			if (recibo.result != 1) {
				throw util.translate("scripts", "Error al obtener los datos del recibo");
			}
			if (!this.iface.generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al generar la partida de proveedor");
			}
			if (!this.iface.generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al generar la partida de banco");
			}
			if (!this.iface.generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al generar la partida de diferencias por cambio");
			}
		} else if (curPD.valueBuffer("tipo") == "Pag.Anulado") {
			/** \D En el caso de anular un pago con pagaré, las subcuentas del asiento contable serán las inversas al asiento contable correspondiente al último pago con pagaré
			\end */
			var idAsientoPago:Number = util.sqlSelect("pagosdevolprov", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pagaré' ORDER BY fecha DESC");
			if (this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, datosAsiento.concepto, valoresDefecto.codejercicio) == false) {
				throw util.translate("scripts", "Error al generar el asiento inverso");
			}
		} else {
			/** \D En el caso de dar una devolución, las subcuentas del asiento contable serán las inversas al asiento contable correspondiente al último pago
			\end */
			var idAsientoPago:Number = util.sqlSelect("pagosdevolprov", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
			if (this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, datosAsiento.concepto, valoresDefecto.codejercicio) == false) {
				throw util.translate("scripts", "Error al generar el asiento inverso");
			}
		}

		if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
			throw util.translate("scripts", "Error al comprobar el asiento");
		}
		curPD.setValueBuffer("idasiento", datosAsiento.idasiento);
	} catch (e) {
		curTransaccion.rollback();
		var codRecibo:String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		MessageBox.warning(util.translate("scripts", "Error al generar el asiento correspondiente a %1 del recibo %2:").arg(curPD.valueBuffer("tipo")).arg(codRecibo) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	curTransaccion.commit();

	return true;
}

function pagareProv_beforeCommit_pagaresprov(curPagare:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	switch (curPagare.modeAccess()) {
		/** \C El pagaré puede borrarse si todos los recibos asociados pueden ser excluidos
		\end */
		case curPagare.Del: {
			if (curPagare.valueBuffer("estado") != "Emitido") {
				MessageBox.warning(util.translate("scripts", "No puede borrar un pagaré en estado %1.\nSi realmente quiere borrarlo debe eliminar los pagos y devoluciones").arg(curPagare.valueBuffer("estado")), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			var idPagare:Number = curPagare.valueBuffer("idpagare");
			var qryRecibos:FLSqlQuery = new FLSqlQuery;
			qryRecibos.setTablesList("pagosdevolprov");
			qryRecibos.setSelect("DISTINCT(idrecibo)");
			qryRecibos.setFrom("pagosdevolprov");
			qryRecibos.setWhere("idpagare = " + idPagare);
			qryRecibos.setForwardOnly(true);
			if (!qryRecibos.exec())
				return false;
			while (qryRecibos.next()) {
				if (!formRecordpagaresprov.iface.pub_excluirReciboPagare(qryRecibos.value(0), idPagare))
					return false;
			}
		}
		case curPagare.Insert:
		case curPagare.Edit: {
			if (!this.iface.comprobarFechasPagares(curPagare))
				return false;

			if (curPagare.valueBuffer("numero") == "") {
				MessageBox.warning(util.translate("scripts", "El pagaré debe tener un número establecido"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			if (util.sqlSelect("pagaresprov", "idpagare", "numero = '" + curPagare.valueBuffer("numero") + "' AND idpagare <> " + curPagare.valueBuffer("idpagare"))) {
				MessageBox.warning(util.translate("scripts", "Ya existe un pagaré con el número %1").arg(curPagare.valueBuffer("numero")), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}
	return true;
}

function pagareProv_beforeCommit_pagospagareprov(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (sys.isLoadedModule("flcontppal") && !curPD.valueBuffer("nogenerarasiento") && util.sqlSelect("empresa", "contintegrada", "1 = 1")) {
		if (!this.iface.generarAsientoPagoPagareProv(curPD))
			return false;
	}

	return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function pagareProv_afterCommit_pagospagareprov(curPD:FLSqlCursor):Boolean
{
	var idPagare:String = curPD.valueBuffer("idpagare");

	/** \C Se cambia el pago anterior al actual para que sólo el último sea editable
	\end */
	switch (curPD.modeAccess()) {
		case curPD.Insert:
		case curPD.Edit: {
			if (!this.iface.cambiaUltimoPagoPagProv(idPagare, curPD.valueBuffer("idpagodevol"), false))
			return false;
			break;
		}
		case curPD.Del: {
			if (!this.iface.cambiaUltimoPagoPagProv(idPagare, curPD.valueBuffer("idpagodevol"), true))
			return false;
			break;
		}
	}

	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
		return true;

	if (curPD.modeAccess() == curPD.Del) {
		if (curPD.isNull("idasiento"))
			return true;

		var idAsiento:Number = curPD.valueBuffer("idasiento");
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
	}
	return true;
}

function pagareProv_generarAsientoPagoPagareProv(curPD:FLSqlCursor):Boolean
{
debug(1);
	var util:FLUtil = new FLUtil();
	if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit) {
		return true;
	}
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPD.valueBuffer("fecha"), codEjercicio, "pagosdevolprov");
	if (!datosDoc.ok) {
		return false;
	}
debug(2);
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		curPD.setValueBuffer("fecha", datosDoc.fecha);
	}

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

	var curTransaccion:FLSqlCursor = new FLSqlCursor("empresa");
	curTransaccion.transaction(false);
	try {
debug(3);
		datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPD, valoresDefecto);
		if (datosAsiento.error == true) {
			throw util.translate("scripts", "Error al regenerar el asiento");
		}
		if (curPD.valueBuffer("tipo") == "Pago") {
debug(4);
			var pagare:Array = flfactppal.iface.pub_ejecutarQry("pagaresprov", "numero,total,nombreproveedor,coddivisa,codsubcuentap", "idpagare = " + curPD.valueBuffer("idpagare"));
debug(5);
			if (pagare.result != 1) {
				throw util.translate("scripts", "Error al obtener los datos del pagaré");
			}
debug(6);
			if (!this.iface.generarPartidasPtePagProv(curPD, valoresDefecto, datosAsiento, pagare)) {
				throw util.translate("scripts", "Error al obtener la partida pendiente de pago");
			}
debug(7);
			if (!this.iface.generarPartidasBancoPagProv(curPD, valoresDefecto, datosAsiento, pagare)) {
				throw util.translate("scripts", "Error al obtener la partida de banco");
			}
debug(8);
		} else {
			/** \D En el caso de dar una devolución, las subcuentas del asiento contable serán las inversas al asiento contable correspondiente al último pago
			\end */
			var idAsientoPago:Number = util.sqlSelect("pagospagareprov", "idasiento", "idpagare = " + curPD.valueBuffer("idpagare") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
			var numPagare:String = util.sqlSelect("pagaresprov", "numero", "idpagare = " + curPD.valueBuffer("idpagare"));
			if (!this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, curPD.valueBuffer("tipo") + " pagare " + numPagare, valoresDefecto.codejercicio)) {
				throw util.translate("scripts", "Error al obtener el asiento inverso");
			}
		}

		if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
			throw util.translate("scripts", "Error al comprobar el asiento");
		}
debug(9);
		curPD.setValueBuffer("idasiento", datosAsiento.idasiento);
	} catch (e) {
		curTransaccion.rollback();
		var codPagare:String = util.sqlSelect("pagaresprov", "numero", "idpagare = " + curPD.valueBuffer("idpagare"));
		MessageBox.warning(util.translate("scripts", "Error al generar el asiento correspondiente a pago del pagaré %1:").arg(codPagare) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
debug(10);
	curTransaccion.commit();

	return true;
}

function pagareProv_generarPartidasBancoPagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaHaber:Array = [];

	ctaHaber.codsubcuenta = curPD.valueBuffer("codsubcuenta");
	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;

	haber = pagare.total;
	haberMe = 0;
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", curPD.valueBuffer("tipo") + " pagaré prov. " + pagare.numero + " - " + pagare.nombreproveedor);
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", pagare.coddivisa);
		setValueBuffer("tasaconv", 1);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la partida correspondiente a la subcuenta de efectos pendientes de pago
@param	curPD: Cursor del pago o devolución
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@param	pagare: Array con los datos del pagaré asociado al pago
@return	true si la generación es correcta, false en caso contrario
\end */
function pagareProv_generarPartidasPtePagProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, pagare:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaDebe:Array = [];

	var idPagare:Number = curPD.valueBuffer("idpagare");

	ctaDebe.codsubcuenta = pagare.codsubcuentap;
	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var debe:Number = 0;
	var debeME:Number = 0;
	var tasaconvDebe:Number = 1;

	var codCuentaBanco:String = util.sqlSelect("pagaresprov","codcuenta","idpagare = " + idPagare);
	var codSubcuentaPBanco:String = util.sqlSelect("cuentasbanco", "codsubcuentap", "codcuenta = '" + codCuentaBanco + "'");

	if(pagare.codsubcuentap == codSubcuentaPBanco)
		debe = util.sqlSelect("pagosdevolprov pd INNER JOIN co_partidas p ON pd.idasiento = p.idasiento", "SUM(haber - debe)", "pd.idpagare = " + idPagare + " AND p.codsubcuenta = '" + pagare.codsubcuentap + "'", "pagosdevolprov,co_subcuentas");
	else
		debe = util.sqlSelect("pagosdevolprov pd INNER JOIN recibosprov r ON pd.idrecibo = r.idrecibo", "SUM(r.importe)", "pd.idpagare = " + idPagare, "pagosdevolprov,recibosprov");

	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	if (parseFloat(debe) != parseFloat(pagare.total)) {
		MessageBox.warning(util.translate("script", "Error: La suma de pagos de los recibos en el pagaré (%1)\nno coincide con el total del pagaré (%2)").arg(util.roundFieldValue(debe, "co_partidas", "debe")).arg(util.roundFieldValue(pagare.total, "co_partidas", "debe")), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", curPD.valueBuffer("tipo") + " pagaré prov. " + pagare.numero + " - " + pagare.nombreproveedor);
		setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("coddivisa", pagare.coddivisa);
		setValueBuffer("tasaconv", tasaconvDebe);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}


/** \D Cambia la el estado del último pago anterior al especificado, de forma que se mantenga como único pago editable el último de todos
@param	idPagare: Identificador del pagaré al que pertenecen los pagos tratados
@param	idPagoDevol: Identificador del pago que ha cambiado
@param	unlock: Indicador de si el últim pago debe ser editable o no
@return	true si la verificación del estado es correcta, false en caso contrario
\end */
function pagareProv_cambiaUltimoPagoPagProv(idPagare:String, idPagoDevol:String, unlock:Boolean):Boolean
{
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagospagareprov");
	curPagosDevol.select("idpagare = " + idPagare + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
	if (curPagosDevol.last())
		curPagosDevol.setUnLock("editable", unlock);

	return true;
}

function pagareProv_comprobarFechasPagares(curPagare:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	if (util.daysTo(curPagare.valueBuffer("fecha"), curPagare.valueBuffer("fechav")) < 0) {
		MessageBox.warning(util.translate("scripts", "La fecha de emisión debe ser menor o igual a la fecha de vencimiento"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

