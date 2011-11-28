
/** @class_declaration proveed */
//////////////////////////////////////////////////////////////////
//// PROVEED /////////////////////////////////////////////////////
class proveed extends oficial {
    var curReciboProv:FLSqlCursor;
	
	function proveed( context ) { oficial( context ); } 
	function tienePagosDevProv(idRecibo:Number):Boolean {
		return this.ctx.proveed_tienePagosDevProv(idRecibo);
	}
	function regenerarRecibosProv(cursor:FLSqlCursor, forzarEmitirComo:String):Boolean {
		return this.ctx.proveed_regenerarRecibosProv(cursor, forzarEmitirComo);
	}
	function afterCommit_pagosdevolprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.proveed_afterCommit_pagosdevolprov(curPD);
	}
	function beforeCommit_pagosdevolprov(curPD:FLSqlCursor):Boolean {
		return this.ctx.proveed_beforeCommit_pagosdevolprov(curPD);
	}
	function calcFechaVencimientoProv(curFactura:FLSqlCursor, numPlazo:Number, diasAplazado:Number):String {
		return this.ctx.proveed_calcFechaVencimientoProv(curFactura, numPlazo, diasAplazado);
	}
	function datosReciboProv():Boolean {
		return this.ctx.proveed_datosReciboProv();
	}
	function cambiaUltimoPagoProv(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean {
		return this.ctx.proveed_cambiaUltimoPagoProv(idRecibo, idPagoDevol, unlock);
	}
	function calcularEstadoFacturaProv(idRecibo:String, idFactura:String):Boolean {
		return this.ctx.proveed_calcularEstadoFacturaProv(idRecibo, idFactura);
	}
	function borrarRecibosProv(idFactura:Number):Boolean {
		return this.ctx.proveed_borrarRecibosProv(idFactura);
	}
	function generarPartidasProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean {
		return this.ctx.proveed_generarPartidasProv(curPD, valoresDefecto, datosAsiento, recibo);
	}
	function generarPartidasBancoProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean {
		return this.ctx.proveed_generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo);
	}
	function generarPartidasCambioProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean {
		return this.ctx.proveed_generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo);
	}
	function generarAsientoPagoDevolProv(curPD:FLSqlCursor):Boolean {
		return this.ctx.proveed_generarAsientoPagoDevolProv(curPD);
	}
	function codCuentaPagoProv(curFactura:FLSqlCursor):String {
		return this.ctx.proveed_codCuentaPagoProv(curFactura);
	}
	function siGenerarRecibosProv(curFactura:FLSqlCursor, masCampos:Array):Boolean {
		return this.ctx.provee_siGenerarRecibosProv(curFactura, masCampos);
	}
	function obtenerDatosCuentaDomProv(codProveedor:String):Array {
		return this.ctx.provee_obtenerDatosCuentaDomProv(codProveedor);
	}
}
//// PROVEED /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pubProveed */
/////////////////////////////////////////////////////////////////
//// PUB PROVEEDORES ////////////////////////////////////////////
class pubProveed extends ifaceCtx {
	function pubProveed( context ) { ifaceCtx( context ); }
	function pub_calcularEstadoFacturaProv(idRecibo:String, idFactura:String):Boolean {
		return this.calcularEstadoFacturaProv(idRecibo, idFactura);
	}
}
//// PUB PROVEEDORES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
/** \D
Indica si un determinado recibo tiene pagos y/o devoluciones asociadas.
@param idRecibo: Identificador del recibo
@return True: Tiene, False: No tiene
\end */
function proveed_tienePagosDevProv(idRecibo:Number):Boolean
{
	var curPagosDev:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	curPagosDev.select("idrecibo = " + idRecibo);
	return curPagosDev.next();
}

function proveed_regenerarRecibosProv(cursor:FLSqlCursor, forzarEmitirComo:String):Boolean
{
	if (!this.iface.siGenerarRecibosProv(cursor)) {
		return true;
	}

	var util:FLUtil = new FLUtil();
	var contActiva:Boolean = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
	var idFactura:Number = cursor.valueBuffer("idfactura");
	
	if (!this.iface.curReciboProv) {
		this.iface.curReciboProv = new FLSqlCursor("recibosprov");
	}
	if (!this.iface.borrarRecibosProv(idFactura)) {
		return false;
	}
	if (parseFloat(cursor.valueBuffer("total")) == 0) {
		return true;
	}

	var codPago:String = cursor.valueBuffer("codpago");
	var emitirComo:String;
	if (forzarEmitirComo) {
		emitirComo = forzarEmitirComo;
	} else {
		emitirComo = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");
	}
	
	var codProveedor:String = cursor.valueBuffer("codproveedor");
	var datosCuentaDom = this.iface.obtenerDatosCuentaDomProv(codProveedor);
	if (datosCuentaDom.error == 2) {
		return false;
	}
	
	var total:Number = parseFloat(cursor.valueBuffer("total"));
	var idRecibo:Number;
	var numRecibo:Number = 1;
	var importeRecibo:Number, importeEuros:Number;
	var diasAplazado:Number, fechaVencimiento:String;
	var tasaConv:Number = parseFloat(cursor.valueBuffer("tasaconv"));
	var divisa:String = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
	
	var codCuentaEmp:String = "";
	var desCuentaEmp:String = "";
	var ctaEntidadEmp:String = "";
	var ctaAgenciaEmp:String = "";
	var dCEmp:String = "";
	var cuentaEmp:String = "";
	var codSubcuentaEmp:String = "";
	var idSubcuentaEmp:String = "";
	if (emitirComo == "Pagados") {
		emitirComo = "Pagado";
		/*D Si los recibos deben emitirse como pagados, se generarán los registros de pago asociados a cada recibo. Si el módulo Principal de contabilidad está cargado, se generará el correspondienta asiento. La subcuenta contable del Debe del apunte corresponderá a la subcuenta contable asociada a la cuenta corriente correspondiente a la cuenta de pago del proveedor, o en su defecto a la forma de pago de la factura. Si dicha cuenta corriente no está especificada, la subcuenta contable del Debe del asiento será la correspondiente a la cuenta especial Caja.
		\end */
		codCuentaEmp = this.iface.codCuentaPagoProv(cursor);

		if (!codCuentaEmp) {
			codCuentaEmp = util.sqlSelect("proveedores", "codcuentapago", "codproveedor = '" + codProveedor + "'");
		}
		if (!codCuentaEmp) {
			codCuentaEmp = util.sqlSelect("formaspago", "codcuenta", "codpago = '" + codPago + "'");
		}
		var datosCuentaEmp:Array = [];
		if (codCuentaEmp.toString().isEmpty()) {
			if (contActiva) {
				var qrySubcuenta:FLSqlQuery = new FLSqlQuery();
				with (qrySubcuenta) {
					setTablesList("co_cuentas,co_subcuentas");
					setSelect("s.idsubcuenta, s.codsubcuenta");
					setFrom("co_cuentas c INNER JOIN co_subcuentas s ON c.idcuenta = s.idcuenta");
					setWhere("c.codejercicio = '" + cursor.valueBuffer("codejercicio") + "'" + " AND c.idcuentaesp = 'CAJA'");
				}
				if (!qrySubcuenta.exec()) {
					return false;
				}
				if (!qrySubcuenta.first())
					return false;
				idSubcuentaEmp = qrySubcuenta.value(0);
				codSubcuentaEmp = qrySubcuenta.value(1);
			}
		} else {
			datosCuentaEmp = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "descripcion,ctaentidad,ctaagencia,cuenta,codsubcuenta", "codcuenta = '" + codCuentaEmp + "'");
			idSubcuentaEmp = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + datosCuentaEmp.codsubcuenta + "'" + " AND codejercicio = '" + cursor.valueBuffer("codEjercicio") + "'");
			desCuentaEmp = datosCuentaEmp.descripcion;
			ctaEntidadEmp = datosCuentaEmp.ctaentidad;
			ctaAgenciaEmp = datosCuentaEmp.ctaagencia;
			cuentaEmp = datosCuentaEmp.cuenta;
			var dc1:String = util.calcularDC(ctaEntidadEmp + ctaAgenciaEmp);
			var dc2:String = util.calcularDC(cuentaEmp);
			dCEmp = dc1 + dc2;
			codSubcuentaEmp =  datosCuentaEmp.codsubcuenta;
		}
	} else
		emitirComo = "Emitido";
	var numPlazo:Number = 1;
	var curPlazos:FLSqlCursor = new FLSqlCursor("plazos");
	var importeAcumulado:Number = 0;
	curPlazos.select("codpago = '" + codPago + "' ORDER BY dias");
	while (curPlazos.next()) {
		if ( curPlazos.at() == ( curPlazos.size() - 1 ) ) {
			importeRecibo = parseFloat(total) - parseFloat(importeAcumulado);
		} else {
			importeRecibo = (parseFloat(total) * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
		}
		importeRecibo = util.roundFieldValue(importeRecibo, "recibosprov","importe");
		importeAcumulado = parseFloat(importeAcumulado) + parseFloat(importeRecibo);

		importeEuros = importeRecibo * tasaConv;
		diasAplazado = curPlazos.valueBuffer("dias");
		
		with (this.iface.curReciboProv) {
			setModeAccess(Insert); 
			refreshBuffer();
			setValueBuffer("numero", numRecibo);
			setValueBuffer("idfactura", idFactura);
			setValueBuffer("importe", importeRecibo);
			setValueBuffer("texto", util.enLetraMoneda(importeRecibo, divisa));
			setValueBuffer("importeeuros", importeEuros);
			setValueBuffer("coddivisa", cursor.valueBuffer("coddivisa"));
			setValueBuffer("codigo", cursor.valueBuffer("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
			setValueBuffer("codproveedor", codProveedor);
			setValueBuffer("nombreproveedor", cursor.valueBuffer("nombre"));
			setValueBuffer("cifnif", cursor.valueBuffer("cifnif"));
			setValueBuffer("fecha", cursor.valueBuffer("fecha"));
			setValueBuffer("estado", emitirComo);

			if (datosCuentaDom.error == 0) {
				setValueBuffer("codcuenta", datosCuentaDom.codcuenta);
				setValueBuffer("descripcion", datosCuentaDom.descripcion);
				setValueBuffer("ctaentidad", datosCuentaDom.ctaentidad);
				setValueBuffer("ctaagencia", datosCuentaDom.ctaagencia);
				setValueBuffer("cuenta", datosCuentaDom.cuenta);
				setValueBuffer("dc", datosCuentaDom.dc);
			}
		}
		if (codProveedor && codProveedor != "") {
			var qryDir:FLSqlQuery = new FLSqlQuery;
			with (qryDir) {
				setTablesList("dirproveedores");
				setSelect("id, direccion, ciudad, codpostal, provincia, codpais");
				setFrom("dirproveedores");
				setWhere("codproveedor = '" + codProveedor + "' AND direccionppal = true");
				setForwardOnly(true);
			}
			if (!qryDir.exec())
				return false;
			if (qryDir.first()) {
				with (this.iface.curReciboProv) {
					setValueBuffer("coddir", qryDir.value("id"));
					setValueBuffer("direccion", qryDir.value("direccion"));
					setValueBuffer("ciudad", qryDir.value("ciudad"));
					setValueBuffer("codpostal", qryDir.value("codpostal"));
					setValueBuffer("provincia", qryDir.value("provincia"));
					setValueBuffer("codpais", qryDir.value("codpais"));
				}
			}
		}

		fechaVencimiento = this.iface.calcFechaVencimientoProv(cursor, numPlazo, diasAplazado);
		this.iface.curReciboProv.setValueBuffer("fechav", fechaVencimiento);
		
		if (!this.iface.datosReciboProv())
			return false;
		
		if (!this.iface.curReciboProv.commitBuffer())
			return false;

		if (emitirComo == "Pagado") {
			idRecibo = this.iface.curReciboProv.valueBuffer("idrecibo");
				
			var curPago:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
			with(curPago) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("idrecibo", idRecibo);
				setValueBuffer("tipo", "Pago");
				setValueBuffer("fecha", cursor.valueBuffer("fecha"));
				setValueBuffer("codcuenta", codCuentaEmp);
				setValueBuffer("descripcion", desCuentaEmp);
				setValueBuffer("ctaentidad", ctaEntidadEmp);
				setValueBuffer("ctaagencia", ctaAgenciaEmp);
				setValueBuffer("dc", dCEmp);
				setValueBuffer("cuenta", cuentaEmp);
				setValueBuffer("codsubcuenta", codSubcuentaEmp);
				setValueBuffer("idSubcuenta", idSubcuentaEmp);
				setValueBuffer("tasaconv", cursor.valueBuffer("tasaconv"));
			}

			if (!curPago.commitBuffer())
				return false;
		}
		numRecibo++;
	}

	if (emitirComo == "Pagado") {
		if (!this.iface.calcularEstadoFacturaProv(false, idFactura))
			return false;
	}

	return true;
}

/** \C Se elimina, si es posible, el asiento contable asociado al pago o devolución
\end */
function proveed_afterCommit_pagosdevolprov(curPD:FLSqlCursor):Boolean
{
	var idRecibo:String = curPD.valueBuffer("idrecibo");
	
	/** \C Se cambia el pago anterior al actual para que sólo el último sea editable
	\end */
	switch (curPD.modeAccess()) {
		case curPD.Insert:
		case curPD.Edit: {
			if (!this.iface.cambiaUltimoPagoProv(idRecibo, curPD.valueBuffer("idpagodevol"), false))
			return false;
			break;
		}
		case curPD.Del: {
			if (!this.iface.cambiaUltimoPagoProv(idRecibo, curPD.valueBuffer("idpagodevol"), true))
			return false;
			break;
		}
	}
		
	if (!this.iface.calcularEstadoFacturaProv(idRecibo))
		return false;

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

/** \C Se regenera, si es posible, el asiento contable asociado al pago o devolución
\end */
function proveed_beforeCommit_pagosdevolprov(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1") && !curPD.valueBuffer("nogenerarasiento")) {
		if (!this.iface.generarAsientoPagoDevolProv(curPD))
			return false;
	}
	return true;
}

function proveed_generarAsientoPagoDevolProv(curPD:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curPD.modeAccess() != curPD.Insert && curPD.modeAccess() != curPD.Edit)
		return true;

	if (curPD.valueBuffer("nogenerarasiento")) {
		curPD.setNull("idasiento");
		return true;
	}

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
				throw util.translate("scripts", "Error al obtener la partida de proveedor");
			}
			if (!this.iface.generarPartidasBancoProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al obtener la partida de banco");
			}
			if (!this.iface.generarPartidasCambioProv(curPD, valoresDefecto, datosAsiento, recibo)) {
				throw util.translate("scripts", "Error al obtener la partida de diferencias por cambio");
			}
		} else {
			/** \D En el caso de dar una devolución, las subcuentas del asiento contable serán las inversas al asiento contable correspondiente al último pago
			\end */
			var idAsientoPago:Number = util.sqlSelect("pagosdevolprov", "idasiento", "idrecibo = " + curPD.valueBuffer("idrecibo") + " AND  tipo = 'Pago' ORDER BY fecha DESC");
			if (this.iface.generarAsientoInverso(datosAsiento.idasiento, idAsientoPago, datosAsiento.concepto, valoresDefecto.codejercicio) == false) {
				throw util.translate("scripts", "Error al generar el asiento inverso al pago");
			}
		}
	
		curPD.setValueBuffer("idasiento", datosAsiento.idasiento);
	
		if (!flcontppal.iface.pub_comprobarAsiento(datosAsiento.idasiento)) {
			throw util.translate("scripts", "Error al comprobar el asiento");
		}
	} catch (e) {
		curTransaccion.rollback();
		var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		MessageBox.warning(util.translate("scripts", "Error al generar el asiento correspondiente a %1 del recibo %2:").arg(curPD.valueBuffer("tipo")).arg(codRecibo) + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	curTransaccion.commit();

	return true;
}

/** \D Genera la partida correspondiente al proveedor del asiento de pago
@param	curPD: Cursor del pago o devolución
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@param	recibo: Array con los datos del recibo asociado al pago
@return	true si la generación es correcta, false en caso contrario
\end */
function proveed_generarPartidasProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var ctaDebe:Array = [];
	var codEjercicioFac:String;

	/** \C La cuenta del debe del asiento de pago será la misma cuenta de tipo PROVEE que se usó para realizar el asiento de la correspondiente factura
	\end */
	var idAsientoFactura:Number = util.sqlSelect("recibosprov r INNER JOIN facturasprov f" + " ON r.idfactura = f.idfactura", "f.idasiento", "r.idrecibo = " + curPD.valueBuffer("idrecibo"), "facturasprov,recibosprov");
	if (!idAsientoFactura) {
		codEjercicioFac = false;
	} else {
		codEjercicioFac = util.sqlSelect("co_asientos", "codejercicio", "idasiento = " + idAsientoFactura);
	}
	if (codEjercicioFac == valoresDefecto.codejercicio) {
		ctaDebe.codsubcuenta = util.sqlSelect("co_partidas p" + " INNER JOIN co_subcuentas s ON p.idsubcuenta = s.idsubcuenta" + " INNER JOIN co_cuentas c ON c.idcuenta = s.idcuenta", "s.codsubcuenta", "p.idasiento = " + idAsientoFactura + " AND c.idcuentaesp = 'PROVEE'", "co_partidas,co_subcuentas,co_cuentas");
	
		if (!ctaDebe.codsubcuenta) {
			MessageBox.warning(util.translate("scripts", "No se ha encontrado la subcuenta de proveedor del asiento contable correspondiente a la factura a pagar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	} else {
		var codProveedor:String = util.sqlSelect("recibosprov", "codproveedor", "idrecibo = " + curPD.valueBuffer("idrecibo"));
		if (codProveedor && codProveedor != "") {
			ctaDebe.codsubcuenta = util.sqlSelect("co_subcuentasprov", "codsubcuenta", "codproveedor = '" + codProveedor + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
			if (!ctaDebe.codsubcuenta) {
				MessageBox.warning(util.translate("scripts", "El proveedor %1 no tiene definida ninguna subcuenta en el ejercicio %2.\nEspecifique la subcuenta en la pestaña de contabilidad del formulario de proveedores").arg(codProveedor).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		} else {
			ctaDebe = flfacturac.iface.pub_datosCtaEspecial("PROVEE", valoresDefecto.codejercicio);
			if (!ctaDebe.codsubcuenta) {
				MessageBox.warning(util.translate("scripts", "No tiene definida ninguna cuenta de tipo PROVEE.\nDebe crear este tipo especial y asociarlo a una cuenta\nen el módulo principal de contabilidad"), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
		}
	}

	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + ctaDebe.codsubcuenta +  "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaDebe.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder realizar el pago debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	var debe:Number = 0;
	var debeME:Number = 0;
	var tasaconvDebe:Number = 1;
	
	if (valoresDefecto.coddivisa == recibo.coddivisa) {
		debe = parseFloat(recibo.importe);
		debeME = 0;
	} else {
		tasaconvDebe = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");
		debe = parseFloat(recibo.importeeuros);
		debeME = parseFloat(recibo.importe);
	}

	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");


	var esAbono:Boolean = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		try {
			setValueBuffer("concepto", datosAsiento.concepto);
		} catch (e) {
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
		}
		setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		if (esAbono) {
			setValueBuffer("debe", 0);
			setValueBuffer("haber", debe * -1);
		} else {
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
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

function proveed_generarPartidasBancoProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean
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
	var tasaconvHaber:Number = 1;

	if (valoresDefecto.coddivisa == recibo.coddivisa) {
		haber = parseFloat(recibo.importe);
		haberMe = 0;
	} else {
		tasaconvHaber = curPD.valueBuffer("tasaconv");
		haber = parseFloat(recibo.importe) * parseFloat(tasaconvHaber);
		haberME = parseFloat(recibo.importe);
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var esAbono:Boolean = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "deabono", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");
	
	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		try {
			setValueBuffer("concepto", datosAsiento.concepto);
		} catch (e) {
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
		}
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		if (esAbono) {
			setValueBuffer("debe", haber * -1);
			setValueBuffer("haber", 0);
		} else {
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
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

/** \D Genera, si es necesario, la partida de diferecias positivas o negativas de cambio
@param	curPD: Cursor del pago o devolución
@param	valoresDefecto: Array de valores por defecto (ejercicio, divisa, etc.)
@param	datosAsiento: Array con los datos del asiento
@param	recibo: Array con los datos del recibo asociado al pago
@return	true si la generación es correcta, false en caso contrario
\end */
function proveed_generarPartidasCambioProv(curPD:FLSqlCursor, valoresDefecto:Array, datosAsiento:Array, recibo:Array):Boolean
{
	/** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado desde el momento de la emisión de la factura, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
	\end */
	if (valoresDefecto.coddivisa == recibo.coddivisa)
		return true;

	var util:FLUtil = new FLUtil();
	var debe:Number = 0;
	var haber:Number = 0;
	var tasaconvDebe:Number = 1;
	var tasaconvHaber:Number = 1;
	var diferenciaCambio:Number = 0;
		
		
	tasaconvHaber = curPD.valueBuffer("tasaconv");
	tasaconvDebe = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura ", "tasaconv", "idrecibo = " + curPD.valueBuffer("idrecibo"), "recibosprov,facturasprov");
	haber = parseFloat(recibo.importe) * parseFloat(tasaconvHaber);
	haber = util.roundFieldValue(haber, "co_partidas", "haber");

	debe = parseFloat(recibo.importeeuros);
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	diferenciaCambio = debe - haber;
	if (util.buildNumber(diferenciaCambio, "f", 2) == "0.00" || util.buildNumber(diferenciaCambio, "f", 2) == "-0.00") {
		diferenciaCambio = 0;
		return true;
	}
	diferenciaCambio = util.roundFieldValue(diferenciaCambio, "co_partidas", "haber");

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

	/// Esto lo usan algunas extensiones
	if (curPD.valueBuffer("tipo") == "Devolución") {
		var aux:Number = debeDifCambio;
		debeDifCambio = haberDifCambio;
		haberDifCambio = aux;
	}

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		try {
			setValueBuffer("concepto", datosAsiento.concepto);
		} catch (e) {
			setValueBuffer("concepto", curPD.valueBuffer("tipo") + " recibo prov. " + recibo.codigo + " - " + recibo.nombreproveedor);
		}
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

	return true;
}

/** \D Calcula la fecha de vencimiento de un recibo de proveedor, como la fecha de facturación más los días del plazo correspondiente
@param curFactura: Cursor posicionado en el registro de facturas correspondiente a la factura
@param numPlazo: Número del plazo actual
@param diasAplazado: Días de aplazamiento del pago
@return Fecha de vencimiento
\end */
function proveed_calcFechaVencimientoProv(curFactura:FLSqlCursor, numPlazo:Number, diasAplazado:Number):String
{
	var util:FLUtil = new FLUtil; 
	return util.addDays(curFactura.valueBuffer("fecha"), diasAplazado);
}

/* \D Función para sobrecargar. Sirve para añadir al cursor del recibo los datos que añada la extensión
\end */
function proveed_datosReciboProv():Boolean
{
	return true;
}

/** \D Cambia la el estado del último pago anterior al especificado, de forma que se mantenga como único pago editable el último de todos
@param	idRecibo: Identificador del recibo al que pertenecen los pagos tratados
@param	idPagoDevol: Identificador del pago que ha cambiado
@param	unlock: Indicador de si el últim pago debe ser editable o no
@return	true si la verificación del estado es correcta, false en caso contrario
\end */
function proveed_cambiaUltimoPagoProv(idRecibo:String, idPagoDevol:String, unlock:Boolean):Boolean
{
	var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	curPagosDevol.select("idrecibo = " + idRecibo + " AND idpagodevol <> " + idPagoDevol + " ORDER BY fecha, idpagodevol");
	if (curPagosDevol.last())
		curPagosDevol.setUnLock("editable", unlock);
	
	return true;
}

/** \D Cambia la factura relacionada con un recibo a editable o no editable en función de si tiene pagos asociados o no
@param	idRecibo: Identificador de un recibo asociado a la factura
@param	idFactura: Identificador de la factura
@return	true si la verificación del estado es correcta, false en caso contrario
\end */
function proveed_calcularEstadoFacturaProv(idRecibo:String, idFactura:String):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!idFactura)
		idFactura = util.sqlSelect("recibosprov", "idfactura", "idrecibo = " + idRecibo);

	var qryPagos:FLSqlQuery = new FLSqlQuery();
	qryPagos.setTablesList("recibosprov,pagosdevolprov");
	qryPagos.setSelect("p.idpagodevol");
	qryPagos.setFrom("recibosprov r INNER JOIN pagosdevolprov p ON r.idrecibo = p.idrecibo");
	qryPagos.setWhere("r.idfactura = " + idFactura);
	try { qryPagos.setForwardOnly( true ); } catch (e) {}
	if (!qryPagos.exec())
		return false;

	var curFactura:FLSqlCursor = new FLSqlCursor("facturasprov");
	curFactura.select("idfactura = " + idFactura);
	curFactura.first();
	if (qryPagos.size() == 0)
		curFactura.setUnLock("editable", true);
	else
		curFactura.setUnLock("editable", false);
	return true
}

/* \D Borra los recibos asociados a una factura.

@param idFactura: Identificador de la factura de la que provienen los recibos
@return False si hay error o si el recibo no se puede borrar, true si los recibos se borran correctamente
\end */
function proveed_borrarRecibosProv(idFactura:Number):Boolean
{
	var curRecibos = new FLSqlCursor("recibosprov");
	curRecibos.select("idfactura = " + idFactura);
	while (curRecibos.next()) {
		curRecibos.setModeAccess(curRecibos.Browse);
		curRecibos.refreshBuffer();
		if (this.iface.tienePagosDevProv(curRecibos.valueBuffer("idrecibo"))) {
			return false;
		}
	}
	curRecibos.select("idfactura = " + idFactura);
	while (curRecibos.next()) {
		curRecibos.setModeAccess(curRecibos.Del);
		curRecibos.refreshBuffer();
		if (!curRecibos.commitBuffer())
			return false;
	}
	return true;
}

/** Para sobrecargar en extensiones
*/
function proveed_codCuentaPagoProv(curFactura:FLSqlCursor):String 
{
	return "";
}

function provee_siGenerarRecibosProv(curFactura:FLSqlCursor, masCampos:Array):Boolean 
{
 	var camposAcomprobar = new Array("codproveedor","total","codpago","fecha");
	
	for (var i:Number = 0; i < camposAcomprobar.length; i++)
		if (curFactura.valueBuffer(camposAcomprobar[i]) != curFactura.valueBufferCopy(camposAcomprobar[i]))
			return true;
	
	if (masCampos) {
		for (i = 0; i < masCampos.length; i++)
			if (curFactura.valueBuffer(masCampos[i]) != curFactura.valueBufferCopy(masCampos[i]))
				return true;
	}
	
	return false;
}

/** \D Obtiene los datos de la cuenta de domiciliación de un proveedor

@param codProveedor: Identificador del cliente
@return Array con los datos de la cuenta o false si no existe o hay un error. Los elementos de este array son:
	descripcion: Descripcion de la cuenta
	ctaentidad: Código de entidad bancaria
	ctaagencia: Código de oficina
	cuenta: Número de cuenta
	dc: Dígitos de control
	codcuenta: Código de la cuenta en la tabla de cuentas
	error: 0.Sin error 1.Datos no encontrados 2.Error
\end */
function provee_obtenerDatosCuentaDomProv(codProveedor:String):Array
{
	var datosCuentaDom:Array = [];
	var util:FLUtil = new FLUtil;
	var domiciliarEn:String = util.sqlSelect("proveedores", "codcuentadom", "codproveedor= '" + codProveedor + "'");

	if (domiciliarEn != "") {
		datosCuentaDom = flfactppal.iface.pub_ejecutarQry("cuentasbcopro", "descripcion,ctaentidad,ctaagencia,cuenta,codcuenta", "codcuenta = '" + domiciliarEn + "'");
		switch (datosCuentaDom.result) {
		case -1:
			datosCuentaDom.error = 1;
			break;
		case 0:
			datosCuentaDom.error = 2;
			break;
		case 1:
			datosCuentaDom.dc = util.calcularDC(datosCuentaDom.ctaentidad + datosCuentaDom.ctaagencia) + util.calcularDC(datosCuentaDom.cuenta);
			datosCuentaDom.error = 0;
			break;
		}
	} else {
		datosCuentaDom.error = 1;
	}

	return datosCuentaDom;
}

//// PROVEED ////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////