
/** @class_declaration remesaProv */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
class remesaProv extends proveed /** %from: proveed */ {
    function remesaProv( context ) { proveed ( context ); }
	function beforeCommit_remesasprov(curRemesa:FLSqlCursor):Boolean {
		return this.ctx.remesaProv_beforeCommit_remesasprov(curRemesa);
	}
	function generarPartidasEFCOGP(curPR:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, remesa:Array):Boolean {
		return this.ctx.remesaProv_generarPartidasEFCOGP(curPR, valoresDefecto, datosAsiento, remesa);
	}
	function generarAsientoPagoRemesaProv(curPR:FLSqlCursor):Boolean {
		return this.ctx.remesaProv_generarAsientoPagoRemesaProv(curPR);
	}
	function generarPartidasBancoRemProv(curPR:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, remesa:Array):Boolean {
		return this.ctx.remesaProv_generarPartidasBancoRemProv(curPR, valoresDefecto, datosAsiento, remesa);
	}
	function beforeCommit_pagosdevolremprov(curPR:FLSqlCursor):Boolean {
		return this.ctx.remesaProv_beforeCommit_pagosdevolremprov(curPR);
	}
	function afterCommit_pagosdevolremprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.remesaProv_afterCommit_pagosdevolremprov(curPD);
	}
}
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesaProv */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
function remesaProv_beforeCommit_remesasprov(curRemesa:FLSqlCursor):Boolean
{

	switch (curRemesa.modeAccess()) {
		/** \C La remesa puede borrarse si todos los pagos asociados pueden ser excluidos
		\end */
		case curRemesa.Del: {
			var idRemesa:Number = curRemesa.valueBuffer("idremesa");
			var qryRecibos:FLSqlQuery = new FLSqlQuery;
			qryRecibos.setTablesList("pagosdevolprov");
			qryRecibos.setSelect("DISTINCT(idrecibo)");
			qryRecibos.setFrom("pagosdevolprov");
			qryRecibos.setWhere("idremesa = " + idRemesa);
			if (!qryRecibos.exec())
				return false;
			while (qryRecibos.next()) {
				if (!formRecordremesasprov.iface.pub_excluirReciboRemesa(qryRecibos.value(0), idRemesa))
					return false;
			}
		}
	}
	return true;
}
/**
@param	curPR: Cursor del pago de la remesa de proveedor
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function remesaProv_generarPartidasEFCOGP(curPR:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, remesa:Array):Boolean
{
	var util:FLUtil = new FLUtil();

	var haber:Number = 0;
	var haberME:Number = 0;
	var ctaHaber:Array = [];
	ctaHaber.codsubcuenta = util.sqlSelect("cuentasbanco","codsubcuentaecgp","codcuenta = '" + remesa.codcuenta + "'");

	if (!ctaHaber.codsubcuenta || ctaHaber.codsubcuenta == "") {
		MessageBox.warning(util.translate("scripts", "No tiene definida de efectos comerciales de gestión de pago para la cuenta %1").arg(remesa.codcuenta), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaDebe.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	debe = remesa.total;
	debeME = 0;
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", curPR.valueBuffer("tipo") + " " + util.translate("scripts", "remesa") + " " + remesa.idremesa);
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}

	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \Genera o regenera el asiento contable asociado a un pago de una remesa de proveedor
@param	curPR: Cursor posicionado en el pago cuyo asiento se va a regenerar
@return	true si la regeneración se realiza correctamente, false en caso contrario
\end */
function remesaProv_generarAsientoPagoRemesaProv(curPR:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curPR.modeAccess() != curPR.Insert && curPR.modeAccess() != curPR.Edit)
		return true;

	if (curPR.valueBuffer("nogenerarasiento")) {
		curPR.setNull("idasiento");
		return true;
	}
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curPR.valueBuffer("fecha"), codEjercicio, "pagosdevolremprov");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		curPR.setValueBuffer("fecha", datosDoc.fecha);
	}

	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");

	datosAsiento = flfacturac.iface.pub_regenerarAsiento(curPR, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	var remesa:Array = flfactppal.iface.pub_ejecutarQry("remesasprov", "coddivisa,total,fecha,idremesa,codsubcuenta,codcuenta", "idremesa = " + curPR.valueBuffer("idremesa"));
		if (remesa.result != 1)
			return false;

	if (curPR.valueBuffer("tipo") == "Pago") {
		if (!this.iface.generarPartidasEFCOGP(curPR, valoresDefecto, datosAsiento, remesa))
			return false;

		if (!this.iface.generarPartidasBancoRemProv(curPR, valoresDefecto, datosAsiento, remesa))
			return false;
	}
	curPR.setValueBuffer("idasiento", datosAsiento.idasiento);
	if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento))
		return false;

	return true;
}

/** \D Genera la partida correspondiente al banco o a caja del asiento de pago de la remesa de proveedor
@param	curPR: Cursor del pago de la remesa de proveedor
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@param	recibo: Array con los datos del recibo de proveedor asociado al pago de la remesa
@return	true si la generación es correcta, false en caso contrario
\end */
function remesaProv_generarPartidasBancoRemProv(curPR:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, remesa:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaHaber:Array = [];
	ctaHaber.codsubcuenta = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + remesa.codcuenta + "'");
	ctaHaber.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaHaber.codsubcuenta + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaHaber.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No tiene definida la subcuenta %1 en el ejercicio %2.\nAntes de dar el pago debe crear la subcuenta o modificar el ejercicio").arg(ctaHaber.codsubcuenta).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;
	var tasaconvHaber:Number = 1;
	if (valoresDefecto.coddivisa == remesa.coddivisa) {
		haber = parseFloat(remesa.total);
		haberME = 0;
	} else {
		tasaconvHaber = curPR.valueBuffer("tasaconv");
		haber = parseFloat(remesa.total) * parseFloat(tasaconvHaber);
		haberME = parseFloat(remesa.total);
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", curPR.valueBuffer("tipo") + " " + util.translate("scripts", "remesa") + " " + remesa.idremesa);
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", remesa.coddivisa);
		setValueBuffer("tasaconv", tasaconvHaber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \C Se regenera, si es posible, el asiento contable asociado al pago de una remesa de proveedor
\end */
function remesaProv_beforeCommit_pagosdevolremprov(curPR:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontppal") && flfactppal.iface.pub_valorDefectoEmpresa("contintegrada") && !curPR.valueBuffer("nogenerarasiento")) {
		if (!this.iface.generarAsientoPagoRemesaProv(curPR))
			return false;
	}

	return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function remesaProv_afterCommit_pagosdevolremprov(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
		return true;

	switch (curPD.modeAccess()) {
		case curPD.Del: {
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
			break;
		}
		case curPD.Edit: {
			if (curPD.valueBuffer("nogenerarasiento")) {
				var idAsientoAnterior:String = curPD.valueBufferCopy("idasiento");
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
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
////////////////////////////////////////////////////////////////

