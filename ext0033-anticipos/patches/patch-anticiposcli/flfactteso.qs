
/** @class_declaration anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
class anticipos extends gastoDevol /** %from: oficial */ {
	function anticipos( context ) { gastoDevol( context ); }
	function afterCommit_anticiposcli(curA:FLSqlCursor):Boolean {
		return this.ctx.anticipos_afterCommit_anticiposcli(curA);
	}
	function beforeCommit_anticiposcli(curA:FLSqlCursor):Boolean {
		return this.ctx.anticipos_beforeCommit_anticiposcli(curA);
	}
	function generarReciboAnticipo(curFactura:FLSqlCursor, numRecibo:String, idAnticipo:Number, datosCuentaDom:Array):Boolean {
		return this.ctx.anticipos_generarReciboAnticipo(curFactura, numRecibo, idAnticipo, datosCuentaDom);
	}
	function regenerarRecibosCli(cursor:FLSqlCursor):Boolean {
		return this.ctx.anticipos_regenerarRecibosCli(cursor);
	}
}
//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
/** \C Se elimina, si es posible, el asiento contable asociado al anticipo
\end */
function anticipos_afterCommit_anticiposcli(curA):Boolean
{
	var util:FLUtil = new FLUtil();
	if (sys.isLoadedModule("flcontppal") == false || util.sqlSelect("empresa", "contintegrada", "1 = 1") == false)
		return true;

	if (curA.modeAccess() == curA.Del) {
		if (curA.isNull("idasiento"))
			return true;

		var idAsiento:Number = curA.valueBuffer("idasiento");
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

/** \C Se crea o se regenera, si es posible, el asiento contable asociado al anticipo
\end */
function anticipos_beforeCommit_anticiposcli(curA):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!sys.isLoadedModule("flcontppal") || curA.valueBuffer("nogenerarasiento") || !util.sqlSelect("empresa", "contintegrada", "1 = 1"))
		return true;

	if (curA.modeAccess() != curA.Insert && curA.modeAccess() != curA.Edit)
		return true;

	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var datosDoc:Array = flfacturac.iface.pub_datosDocFacturacion(curA.valueBuffer("fecha"), codEjercicio, "pagosdevolcli");
	if (!datosDoc.ok)
		return false;
	if (datosDoc.modificaciones == true) {
		codEjercicio = datosDoc.codEjercicio;
		curA.setValueBuffer("fecha", datosDoc.fecha);
	}
	var datosAsiento:Array = [];
	var valoresDefecto:Array;
	valoresDefecto["codejercicio"] = codEjercicio;
	valoresDefecto["coddivisa"] = util.sqlSelect("empresa", "coddivisa", "1 = 1");
	datosAsiento = flfacturac.iface.pub_regenerarAsiento(curA, valoresDefecto);
	if (datosAsiento.error == true)
		return false;

	var ctaDebe:Array = [];
	var ctaHaber:Array = [];
	var codCliente = util.sqlSelect( "pedidoscli", "codcliente", "idpedido = " + curA.valueBuffer( "idpedido" ) );
	ctaHaber = flfactppal.iface.pub_datosCtaCliente( codCliente, valoresDefecto);
	if (ctaHaber.error != 0)
		return false;

	ctaDebe.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + curA.valueBuffer("codsubcuenta") + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
	if (!ctaDebe.idsubcuenta) {
		MessageBox.warning(util.translate("scripts", "No existe la subcuenta para el ejercicio seleccionado:") + "\n" + curA.valueBuffer("codsubcuenta") + "\n" + valoresDefecto.codejercicio, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	ctaDebe.codsubcuenta = curA.valueBuffer("codsubcuenta");

	var debe:Number = 0;
	var haber:Number = 0;
	var debeME:Number = 0;
	var haberME:Number = 0;
	var tasaconvDebe:Number = 1;
	var tasaconvHaber:Number = 1;
	var diferenciaCambio:Number = 0;
	var pedido:Array = flfactppal.iface.pub_ejecutarQry("pedidoscli", "coddivisa,codigo,tasaconv,nombrecliente", "idpedido = " + curA.valueBuffer("idpedido"));
	if (pedido.result != 1)
		return false;

	if (valoresDefecto.coddivisa == pedido.coddivisa) {
		debe = curA.valueBuffer("importe");
		debeME = 0;
		haber = debe;
		haberMe = 0;
	} else {
		tasaconvDebe = curA.valueBuffer("tasaconv");
		tasaconvHaber = pedido.tasaconv;
		debe = parseFloat(curA.valueBuffer("importe")) * parseFloat(tasaconvDebe);
		debeME = parseFloat(curA.valueBuffer("importe"));
		haber = parseFloat(curA.valueBuffer("importe")) * parseFloat(tasaconvHaber);
		haberME = parseFloat(curA.valueBuffer("importe"));
		diferenciaCambio = debe - haber;
		if (util.buildNumber(diferenciaCambio, "f", 2) == "0.00" || util.buildNumber(diferenciaCambio, "f", 2) == "-0.00") {
			diferenciaCambio = 0;
			debe = haber;
		}
	}

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", "Anticipo pedido " + curA.valueBuffer( "codigo" ) + " - " + pedido.nombrecliente);
		setValueBuffer("idsubcuenta", ctaDebe.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDebe.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("coddivisa", pedido.coddivisa);
		setValueBuffer("tasaconv", tasaconvDebe);
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
	if (!curPartida.commitBuffer())
		return false;

	with(curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", "Anticipo pedido " + curA.valueBuffer( "codigo" ) + " - " + pedido.nombrecliente);
		setValueBuffer("idsubcuenta", ctaHaber.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaHaber.codsubcuenta);
		setValueBuffer("idasiento", datosAsiento.idasiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", pedido.coddivisa);
		setValueBuffer("tasaconv", tasaconvHaber);
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
	if (!curPartida.commitBuffer())
			return false;

	/** \C En el caso de que la divisa sea extranjera y la tasa de cambio haya variado, la diferencia se imputará a la correspondiente cuenta de diferencias de cambio.
		\end */
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

		with(curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", "Anticipo pedido " + curA.valueBuffer( "codigo" ) + " - " + pedido.nombrecliente);
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
	curA.setValueBuffer("idasiento", datosAsiento.idasiento);
	return true;
}

function anticipos_generarReciboAnticipo(curFactura:FLSqlCursor, numRecibo:String, idAnticipo:Number, datosCuentaDom:Array):Boolean
{
	var anticipo:Array = flfactppal.iface.pub_ejecutarQry("anticiposcli", "importe,fecha", "idanticipo = " + idAnticipo );
	if ( anticipo.result != 1 )
		return false;

	var util:FLUtil = new FLUtil();
	var importeEuros:Number  = anticipo.importe * parseFloat(curFactura.valueBuffer("tasaconv"));
	var divisa:String = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + curFactura.valueBuffer("coddivisa") + "'");

	var codDir:String = curFactura.valueBuffer("coddir");
	var curRecibo:FLSqlCursor = new FLSqlCursor("reciboscli");
	with(curRecibo) {
		setModeAccess(curRecibo.Insert);
		refreshBuffer();
		setValueBuffer("numero", numRecibo);
		setValueBuffer("idfactura", curFactura.valueBuffer("idfactura"));
		setValueBuffer("importe", anticipo.importe);
		setValueBuffer("texto", util.enLetraMoneda(anticipo.importe, divisa));
		setValueBuffer("importeeuros", importeEuros);
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("codigo", curFactura.valueBuffer("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
		setValueBuffer("codcliente", curFactura.valueBuffer("codcliente"));
		setValueBuffer("nombrecliente", curFactura.valueBuffer("nombrecliente"));
		setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
		if (!codDir || codDir == 0) {
			setNull("coddir");
		} else {
			setValueBuffer("coddir", codDir);
		}
		setValueBuffer("direccion", curFactura.valueBuffer("direccion"));
		setValueBuffer("codpostal", curFactura.valueBuffer("codpostal"));
		setValueBuffer("ciudad", curFactura.valueBuffer("ciudad"));
		setValueBuffer("provincia", curFactura.valueBuffer("provincia"));
		setValueBuffer("codpais", curFactura.valueBuffer("codpais"));
		setValueBuffer("fecha", curFactura.valueBuffer("fecha"));

		if (datosCuentaDom.error == 0) {
			setValueBuffer("codcuenta", datosCuentaDom.codcuenta);
			setValueBuffer("descripcion", datosCuentaDom.descripcion);
			setValueBuffer("ctaentidad", datosCuentaDom.ctaentidad);
			setValueBuffer("ctaagencia", datosCuentaDom.ctaagencia);
			setValueBuffer("cuenta", datosCuentaDom.cuenta);
			setValueBuffer("dc", datosCuentaDom.dc);
		}
		setValueBuffer("fechav", anticipo.fecha);
		setValueBuffer("estado", "Pagado");
		setValueBuffer("idanticipo", idAnticipo);
	}
	if (!curRecibo.commitBuffer())
			return false;

	return true;
}

function anticipos_regenerarRecibosCli(cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	var contActiva:Boolean = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");

	var idFactura:Number = cursor.valueBuffer("idfactura");
	var total:Number = parseFloat(cursor.valueBuffer("total"));

	if (!util.sqlSelect("anticiposcli a inner join pedidoscli p on a.idpedido=p.idpedido inner join lineasalbaranescli la on la.idpedido=p.idpedido inner join albaranescli ab on ab.idalbaran=la.idalbaran inner join facturascli f on f.idfactura=ab.idfactura", "idanticipo,importe", "f.idfactura = " + idFactura + " group by idanticipo,importe",  "anticiposcli,pedidoscli,lineasalbaranescli,albaranescli,facturascli"))
		return this.iface.__regenerarRecibosCli(cursor);

	if (!this.iface.borrarRecibosCli(idFactura))
		return false;

	if (total == 0)
		return true;

	var codPago:String = cursor.valueBuffer("codpago");
	var codCliente:String = cursor.valueBuffer("codcliente");

	var emitirComo:String = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");
	var datosCuentaDom = this.iface.obtenerDatosCuentaDom(codCliente);
	if (datosCuentaDom.error == 2)
		return false;

	var numRecibo:Number = 1;
	var numPlazo:Number = 1;
	var importe:Number;
	var diasAplazado:Number;
	var fechaVencimiento:String;
	var datosCuentaEmp:Array = false;
	var datosSubcuentaEmp:Array = false;
	var hayAnticipos:Boolean = false;

	if (emitirComo == "Pagados") {
		emitirComo = "Pagado";
		datosCuentaEmp = this.iface.obtenerDatosCuentaEmp(codCliente, codPago);
		if (datosCuentaEmp.error == 2)
			return false;
		if (contActiva) {
			datosSubcuentaEmp = this.iface.obtenerDatosSubcuentaEmp(datosCuentaEmp);
			if (datosSubcuentaEmp.error == 2)
				return false;
		}
	} else
		emitirComo = "Emitido";

	var importeAcumulado:Number = 0;
	var curPlazos:FLSqlCursor = new FLSqlCursor("plazos");
	curPlazos.select("codpago = '" + codPago + "'  ORDER BY dias");
	if(curPlazos.size() == 0){
		MessageBox.warning(util.translate("scripts", "No se pueden generar los recibos, la forma de pago ") + codPago + util.translate("scripts", "no tiene plazos de pago asociados"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	/** \C En el caso de que existan anticipos crea un recibo como pagado para cada uno de ellos.
		\end */
	qryAnticipos = new FLSqlQuery();
	qryAnticipos.setTablesList("anticiposcli,pedidoscli,lineasalbaranescli,albaranescli,facturascli");
	qryAnticipos.setSelect("idanticipo,importe");
	qryAnticipos.setFrom("anticiposcli a inner join pedidoscli p on a.idpedido=p.idpedido inner join lineasalbaranescli la on la.idpedido=p.idpedido inner join albaranescli ab on ab.idalbaran=la.idalbaran inner join facturascli f on f.idfactura=ab.idfactura");
	qryAnticipos.setWhere("f.idfactura = " + idFactura + " group by idanticipo,importe");

	if (!qryAnticipos.exec())
		return false;

	while (qryAnticipos.next()) {
		if ( !this.iface.generarReciboAnticipo(cursor, numRecibo, qryAnticipos.value(0), datosCuentaDom) )
			return false;
		total -= parseFloat( qryAnticipos.value(1) );
		numRecibo++;
		hayAnticipos = true;
	}

	if (total > 0) {
		while (curPlazos.next()) {
			diasAplazado = curPlazos.valueBuffer("dias");
			importe = (total * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
			if ( curPlazos.at() == ( curPlazos.size() - 1 ) )
				importe = total - importeAcumulado;
			else {
				importe = Math.round( importe );
				importeAcumulado += importe;
			}
			if ( importe < 0 )
				break;
			fechaVencimiento = this.iface.calcFechaVencimientoCli(cursor, numPlazo, diasAplazado);
			if (!this.iface.generarReciboCli(cursor, numRecibo, importe, fechaVencimiento, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp))
				return false;
			numRecibo++;
			numPlazo++;
		}
	}

	if (emitirComo == "Pagado") {
		if (!this.iface.calcularEstadoFacturaCli(false, idFactura))
			return false;
	}

	if (cursor.valueBuffer("codcliente"))
		if (sys.isLoadedModule("flfactteso"))
			this.iface.actualizarRiesgoCliente(codCliente);

	return true;
}
//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

