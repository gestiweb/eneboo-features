
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial /** %from: oficial */ {
    function dtoEspecial( context ) { oficial ( context ); }
	function init() { return this.ctx.dtoEspecial_init(); }
	function generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.dtoEspecial_generarPartidasVenta(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasCompra(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean {
		return this.ctx.dtoEspecial_generarPartidasCompra(curFactura, idAsiento, valoresDefecto, concepto);
	}
	function generarPartidasIVACli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean {
		return this.ctx.dtoEspecial_generarPartidasIVACli(curFactura, idAsiento, valoresDefecto, ctaCliente);
	}
	function generarPartidasIVAProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaProveedor:Array, concepto:String):Boolean {
		return this.ctx.dtoEspecial_generarPartidasIVAProv(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto);
	}
	function generarPartidasDtoEspCli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.dtoEspecial_generarPartidasDtoEspCli(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasDtoEspProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean {
		return this.ctx.dtoEspecial_generarPartidasDtoEspProv(curFactura, idAsiento, valoresDefecto, concepto);
	}
	function esClienteNacional(codCliente:String):Boolean {
		return this.ctx.dtoEspecial_esClienteNacional(codCliente);
	}
	function esProveedorNacional(codProveedor:String):Boolean {
		return this.ctx.dtoEspecial_esProveedorNacional(codProveedor);
	}
	function datosCtaDto(codEjercicio:String, esClienteNacional:Boolean, tipoSujeto:String):Array {
		return this.ctx.dtoEspecial_datosCtaDto(codEjercicio, esClienteNacional, tipoSujeto);
	}
	function netoComprasFacturaProv(curFactura:FLSqlCursor):Number {
		return this.ctx.dtoEspecial_netoComprasFacturaProv(curFactura);
	}
	function netoVentasFacturaCli(curFactura:FLSqlCursor):Number {
		return this.ctx.dtoEspecial_netoVentasFacturaCli(curFactura);
	}
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
//////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ////////////////////////////////////////////////
function dtoEspecial_init()
{
	if (!sys.isLoadedModule("flcontppal"))
		return;

	var cursor:FLSqlCursor = new FLSqlCursor("empresa");
	var util:FLUtil = new FLUtil();
	cursor.select();
	if(!util.sqlSelect("co_cuentasesp","idcuentaesp","idcuentaesp = 'DESNAC'")){
		MessageBox.information(util.translate("scripts",
			"Se crearán algunas cuentas especiales para empezar a trabajar."),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			var cursor:FLSqlCursor = new FLSqlCursor("co_cuentasesp");

			var cuentas:Array =
				[["DESNAC", "Descuento especial para clientes nacionales"],
				["DESINT", "Descuento especial para clientes internacionales"],
				["DENAPR", "Descuento especial para proveedores nacionales"],
				["DEINPR", "Descuento especial para proveedores internacionales"]];
			for (var i:Number = 0; i < cuentas.length; i++) {
				with(cursor) {
					setModeAccess(cursor.Insert);
					refreshBuffer();
					setValueBuffer("idcuentaesp", cuentas[i][0]);
					setValueBuffer("descripcion", cuentas[i][1]);
					commitBuffer();
				}
			}
			delete cursor;
	}
}

function dtoEspecial_generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	if (!this.iface.generarPartidasDtoEspCli(curFactura, idAsiento, valoresDefecto))
		return false;


	if (!this.iface.__generarPartidasVenta(curFactura, idAsiento, valoresDefecto))
		return false;

	return true;

// 	var ctaVentas:Array = this.iface.datosCtaVentas(valoresDefecto.codejercicio, curFactura.valueBuffer("codserie"));
// 	if (ctaVentas.error != 0)
// 		return false;
//
// 	var util:FLUtil = new FLUtil();
// 	var haber:Number = 0;
// 	var haberME:Number = 0;
// 	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
// 	if (monedaSistema) {
// 		haber = curFactura.valueBuffer("netosindtoesp");
// 		haberME = 0;
// 	} else {
// 		haber = util.sqlSelect("co_partidas", "SUM(debe - haber)", "idasiento = " + idAsiento);
// 		haberME = curFactura.valueBuffer("neto");
// 	}
// 	haber = util.roundFieldValue(haber, "co_partidas", "haber");
// 	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
//
// 	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
// 	with (curPartida) {
// 		setModeAccess(curPartida.Insert);
// 		refreshBuffer();
// 		setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
// 		setValueBuffer("idsubcuenta", ctaVentas.idsubcuenta);
// 		setValueBuffer("codsubcuenta", ctaVentas.codsubcuenta);
// 		setValueBuffer("idasiento", idAsiento);
// 		setValueBuffer("debe", 0);
// 		setValueBuffer("haber", haber);
// 		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
// 		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
// 		setValueBuffer("debeME", 0);
// 		setValueBuffer("haberME", haberME);
// 	}
// 	if (!curPartida.commitBuffer())
// 		return false;
//
// 	return true;
}

/** \D Genera las partidas de descuento y de compras parte del asiento de factura de proveedor
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function dtoEspecial_generarPartidasCompra(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean
{
	if (!this.iface.generarPartidasDtoEspProv(curFactura, idAsiento, valoresDefecto, concepto))
		return false;

	return this.iface.__generarPartidasCompra(curFactura, idAsiento, valoresDefecto, concepto);
}


/** \D Genera la parte del asiento de factura correspondiente al descuento especial de la factura de un cliente
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function dtoEspecial_generarPartidasDtoEspCli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	if (parseFloat(curFactura.valueBuffer("dtoesp")) == 0)
		return true;

	var util:FLUtil = new FLUtil();
	var clienteNacional:Boolean = this.iface.esClienteNacional(curFactura.valueBuffer("codcliente"));

	var ctaDtoEsp:Array = this.iface.datosCtaDto(valoresDefecto.codejercicio, clienteNacional, "CLI");

	if (ctaDtoEsp.error != 0)
		return false;

	var debe:Number = 0;
	var debeME:Number = 0;
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		debe = curFactura.valueBuffer("dtoesp");
		debeME = 0;
	} else {
		debe = parseFloat(curFactura.valueBuffer("dtoesp")) * parseFloat(curFactura.valueBuffer("tasaconv"));
		debeME = curFactura.valueBuffer("neto");
	}
	debe = util.roundFieldValue(debe, "co_partidas", "debe");
	debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
		setValueBuffer("idsubcuenta", ctaDtoEsp.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDtoEsp.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", debe);
		setValueBuffer("haber", 0);
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("debeME", debeME);
		setValueBuffer("haberME", 0);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Genera la parte del asiento de factura correspondiente al descuento especial de la factura de un proveedor
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function dtoEspecial_generarPartidasDtoEspProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean
{
	if (parseFloat(curFactura.valueBuffer("dtoesp")) == 0)
		return true;

	var util:FLUtil = new FLUtil();
	var proveedorNacional:Boolean = this.iface.esProveedorNacional(curFactura.valueBuffer("codproveedor"));

	var ctaDtoEsp:Array = this.iface.datosCtaDto(valoresDefecto.codejercicio, proveedorNacional, "PROV");

	if (ctaDtoEsp.error != 0)
		return false;

	var haber:Number = 0;
	var haberME:Number = 0;
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	if (monedaSistema) {
		haber = curFactura.valueBuffer("dtoesp");
		haberME = 0;
	} else {
		haber = parseFloat(curFactura.valueBuffer("dtoesp")) * parseFloat(curFactura.valueBuffer("tasaconv"));
		haberME = curFactura.valueBuffer("neto");
	}
	haber = util.roundFieldValue(haber, "co_partidas", "haber");
	haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	with (curPartida) {
		setModeAccess(curPartida.Insert);
		refreshBuffer();
		setValueBuffer("concepto", concepto);
		setValueBuffer("idsubcuenta", ctaDtoEsp.idsubcuenta);
		setValueBuffer("codsubcuenta", ctaDtoEsp.codsubcuenta);
		setValueBuffer("idasiento", idAsiento);
		setValueBuffer("debe", 0);
		setValueBuffer("haber", haber);
		setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
		setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
		setValueBuffer("debeME", 0);
		setValueBuffer("haberME", haberME);
	}
	if (!curPartida.commitBuffer())
		return false;

	return true;
}

/** \D Calcula y genera las partidas de IVA y de recargo de equivalencia cuando la factura de cliente tiene establecido un descuento especial. Si esto ocurre, el IVA y el recargo de todas las líneas de factura tienen el mismo valor
\end */
function dtoEspecial_generarPartidasIVACli(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaCliente:Array):Boolean
{
	//if (parseFloat(curFactura.valueBuffer("dtoesp")) == 0)
		return this.iface.__generarPartidasIVACli(curFactura, idAsiento, valoresDefecto, ctaCliente);

	var util:FLUtil = new FLUtil();
	var haber:Number = 0;
	var haberME:Number = 0;
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));

	var codImpuesto:String = util.sqlSelect("lineasfacturascli", "codimpuesto",  "idfactura = " + curFactura.valueBuffer("idfactura"));

	var neto:Number = parseFloat(curFactura.valueBuffer("netosindtoesp")) - parseFloat(curFactura.valueBuffer("dtoesp"));
	// Sustituye a var neto:Number = parseFloat(curFactura.valueBuffer("neto")); para facilitar compatibilidad con extensión de Portes
	var iva:Number = util.sqlSelect("lineasivafactcli", "iva", "idfactura = " + curFactura.valueBuffer("idfactura"));
	if (!iva)
		iva = 0;

	var recargo:Number = util.sqlSelect("lineasivafactcli", "recargo", "idfactura = " + curFactura.valueBuffer("idfactura"));
	if (!recargo)
		recargo = 0;

	if (iva) {
		if (monedaSistema) {
			haberME = 0;
			haber = neto * iva / 100;
		} else {
			haberME = neto * iva / 100;
			haber = haberME * parseFloat(curFactura.valueBuffer("tasaconv"));
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

		var ctaIvaRep:Array = this.iface.datosCtaIVA("IVAREP", valoresDefecto.codejercicio, codImpuesto);
		if (ctaIvaRep.error != 0)
			return false;

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
			setValueBuffer("idsubcuenta", ctaIvaRep.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaIvaRep.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("baseimponible", curFactura.valueBuffer("neto"));
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
			setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
			setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
			setValueBuffer("tipodocumento", "Factura de cliente");
			setValueBuffer("documento", curFactura.valueBuffer("codigo"));
			setValueBuffer("factura", curFactura.valueBuffer("numero"));
			setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
		}
		if (!curPartida.commitBuffer())
			return false;
	}

	var recargo:Number = util.sqlSelect("lineasivafactcli", "recargo", "idfactura = " + curFactura.valueBuffer("idfactura"));
	if (!recargo)
		recargo = 0;
	if (recargo) {
		if (monedaSistema) {
			haberME = 0;
			haber = neto * recargo / 100;
		} else {
			haberME = neto * recargo / 100;
			haber = haberME * parseFloat(curFactura.valueBuffer("tasaconv"));
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");

		var ctaIvaRep = this.iface.datosCtaIVA("IVARRE", valoresDefecto.codejercicio, codImpuesto);
		if (ctaIvaRep.error != 0) {
			ctaIvaRep = this.iface.datosCtaIVA("IVAACR", valoresDefecto.codejercicio, codImpuesto);
			if (ctaIvaRep.error != 0) {
				return false;
			}
		}

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
			setValueBuffer("idsubcuenta", ctaIvaRep.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaIvaRep.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("baseimponible", curFactura.valueBuffer("neto"));
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("idcontrapartida", ctaCliente.idsubcuenta);
			setValueBuffer("codcontrapartida", ctaCliente.codsubcuenta);
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
			setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
			setValueBuffer("tipodocumento", "Factura de cliente");
			setValueBuffer("documento", curFactura.valueBuffer("codigo"));
			setValueBuffer("factura", curFactura.valueBuffer("numero"));
			setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
		}
		if (!curPartida.commitBuffer())
			return false;
	}
	return true;
}

/** \D Calcula y genera las partidas de IVA y de recargo de equivalencia cuando la factura de proveedor tiene establecido un descuento especial. Si esto ocurre, el IVA y el recargo de todas las líneas de factura tienen el mismo valor
\end */
function dtoEspecial_generarPartidasIVAProv(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, ctaProveedor:Array, concepto:String):Boolean
{
	//if (parseFloat(curFactura.valueBuffer("dtoesp")) == 0)
		return this.iface.__generarPartidasIVAProv(curFactura, idAsiento, valoresDefecto, ctaProveedor, concepto);

	var util:FLUtil = new FLUtil();
	var haber:Number = 0;
	var haberME:Number = 0;
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));

	var codImpuesto:String = util.sqlSelect("lineasfacturasprov", "codimpuesto",  "idfactura = " + curFactura.valueBuffer("idfactura"));

	var neto:Number = parseFloat(curFactura.valueBuffer("neto"));
	var iva:Number = util.sqlSelect("lineasivafactprov", "iva", "idfactura = " + curFactura.valueBuffer("idfactura"));
	if (!iva)
		iva = 0;

	var recargo:Number = util.sqlSelect("lineasivafactprov", "recargo", "idfactura = " + curFactura.valueBuffer("idfactura"));
	if (!recargo)
		recargo = 0;

	if (iva) {
		if (monedaSistema) {
			debeME = 0;
			debe = neto * iva / 100;
		} else {
			debeME = neto * iva / 100;
			debe = debeME * parseFloat(curFactura.valueBuffer("tasaconv"));
		}
		debe = util.roundFieldValue(debe, "co_partidas", "haber");
		debeME = util.roundFieldValue(debeME, "co_partidas", "haberme");

		var regimenIVA:String = util.sqlSelect("proveedores","regimeniva","codproveedor = '" + curFactura.valueBuffer("codproveedor") + "'");
		var codCuentaEspIVA:String;

		switch(regimenIVA) {
			case util.translate("scripts", "UE"):
				codCuentaEspIVA = "IVASUE";
				break;
			case util.translate("scripts", "General"):
			case util.translate("scripts", "Exento"):
			case util.translate("scripts", "Exportaciones"):
				codCuentaEspIVA = "IVASOP";
				break;
			default:
				codCuentaEspIVA = "IVASOP";
		}

		var ctaIvaSop:Array = this.iface.datosCtaIVA(codCuentaEspIVA, valoresDefecto.codejercicio, codImpuesto);
		if (ctaIvaSop.error != 0) {
			MessageBox.warning(util.translate("scripts", "Esta factura pertenece al régimen IVA tipo %1.\nNo existe ninguna cuenta contable marcada como tipo especial %2\n\nDebe asociar una cuenta contable a dicho tipo especial en el módulo Principal del área Financiera").arg(regimenIVA).arg(codCuentaEspIVA), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", concepto);
			setValueBuffer("idsubcuenta", ctaIvaSop.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaIvaSop.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
			setValueBuffer("baseimponible", curFactura.valueBuffer("neto"));
			setValueBuffer("iva", iva);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
			setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
			setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
			setValueBuffer("tipodocumento", "Factura de proveedor");
			setValueBuffer("documento", curFactura.valueBuffer("codigo"));
			setValueBuffer("factura", curFactura.valueBuffer("numero"));
			setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
		}
		if (!curPartida.commitBuffer())
			return false;

		// Otra partida de haber de IVA sobre una cuenta 477 para compensar en UE
		if (regimenIVA == util.translate("scripts", "UE")) {

			haber = debe;
			haberME = debeME;
			codCuentaEspIVA = "IVARUE";
			var ctaIvaSop:Array = this.iface.datosCtaIVA(codCuentaEspIVA, valoresDefecto.codejercicio, codImpuesto);
			if (ctaIvaSop.error != 0) {
				MessageBox.warning(util.translate("scripts", "Esta factura pertenece al régimen IVA tipo %1.\nNo existe ninguna cuenta contable marcada como tipo especial %1\n\nDebe asociar una cuenta contable a dicho tipo especial en el módulo Principal del área Financiera").arg(regimenIVA).arg(codCuentaEspIVA), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
			var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
			with (curPartida) {
				setModeAccess(curPartida.Insert);
				refreshBuffer();
				setValueBuffer("concepto", concepto);
				setValueBuffer("idsubcuenta", ctaIvaSop.idsubcuenta);
				setValueBuffer("codsubcuenta", ctaIvaSop.codsubcuenta);
				setValueBuffer("idasiento", idAsiento);
				setValueBuffer("debe", 0);
				setValueBuffer("haber", haber);
				setValueBuffer("baseimponible", curFactura.valueBuffer("neto"));
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
				setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
				setValueBuffer("idcontrapartida", ctaProveedor.idsubcuenta);
				setValueBuffer("codcontrapartida", ctaProveedor.codsubcuenta);
				setValueBuffer("debeME", 0);
				setValueBuffer("haberME", haberME);
				setValueBuffer("codserie", curFactura.valueBuffer("codserie"));
				setValueBuffer("tipodocumento", "Factura de proveedor");
				setValueBuffer("documento", curFactura.valueBuffer("codigo"));
				setValueBuffer("factura", curFactura.valueBuffer("numero"));
				setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
			}
			if (!curPartida.commitBuffer())
				return false;
		}
	}

	if (recargo) {
		if (monedaSistema) {
			debeME = 0;
			debe = neto * recargo / 100;
		} else {
			debeME = neto * recargo / 100;
			debe = debeME * parseFloat(curFactura.valueBuffer("tasaconv"));
		}
		debe = util.roundFieldValue(debe, "co_partidas", "debe");
		debeME = util.roundFieldValue(debeME, "co_partidas", "debeme");

		var ctaIvaSop = this.iface.datosCtaIVA("IVADEU", valoresDefecto.codejercicio, codImpuesto);
		if (ctaIvaSop.error != 0)
			return false;

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", concepto);
			setValueBuffer("idsubcuenta", ctaIvaSop.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaIvaSop.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", debe);
			setValueBuffer("haber", 0);
			setValueBuffer("baseimponible", curFactura.valueBuffer("neto"));
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", debeME);
			setValueBuffer("haberME", 0);
		}
		if (!curPartida.commitBuffer())
			return false;
	}
	return true;
}

/** \D Indica si el cliente considerado es nacional o no. Un cliente es nacional cuando el país de su domicilio de facturación coincide con el país del domicilio del registro de la tabla empresa. En caso de que alguno de los datos no exista, el cliente se toma como nacional
@param codCliente: Código de cliente
@return True si el cliente es nacional, false si no lo es
\end */
function dtoEspecial_esClienteNacional(codCliente:String):Boolean
{
	if (!codCliente || codCliente == "")
		return true;

	var util:FLUtil = new FLUtil();
	var codPais:String = util.sqlSelect("dirclientes", "codpais",  "codcliente = '" + codCliente + "' AND domfacturacion = true");
	var codPaisEmpresa:String = util.sqlSelect("empresa", "codpais", "1 = 1");
	if (!codPaisEmpresa) {
		MessageBox.warning(util.translate("scripts",  "No tiene especificado el país de su empresa.\nEsto es necesario para establecer si el cliente actual es nacional o no.\nEl cliente será tomado como nacional"), MessageBox.Ok, MessageBox.NoButton);
		return true;
	}
	if (codPais && codPais != "" && codPais != codPaisEmpresa)
		return false;

	return true;
}

/** \D Indica si el proveedor considerado es nacional o no. Un cliente es nacional cuando el país de su domicilio principal coincide con el país del domicilio del registro de la tabla empresa.
@param codProveedor: Código de proveedor
@return True si el cliente es nacional, false si no lo es
\end */
function dtoEspecial_esProveedorNacional(codProveedor:String):Boolean
{
	if (!codProveedor || codProveedor == "")
		return true;

	var util:FLUtil = new FLUtil();
	var codPais:String = util.sqlSelect("dirproveedores", "codpais",  "codproveedor = '" + codProveedor + "' AND direccionppal = true");
	var codPaisEmpresa:String = util.sqlSelect("empresa", "codpais", "1 = 1");
	if (!codPaisEmpresa) {
		MessageBox.warning(util.translate("scripts", "No tiene especificado el país de su empresa.\nEsto es necesario para establecer si el proveedor actual es nacional o no.\nEl proveedor será tomado como nacional"), MessageBox.Ok, MessageBox.NoButton);
		return true;
	}
	if (codPais && codPais != "" && codPais != codPaisEmpresa)
		return false;

	return true;
}

/** \D Devuelve el código e id de la subcuenta de descuento correspondiente a un deteminado sujeto (cliente o proveedor)
@param codEjercicio: Ejercicio actual
@param esNacional: Indicador de si se debe usar la subcuenta de descuentos nacionales o internacionales
@param tipoSujeto: Indicador de tipo de sujeto: CLI = cliente, PROV = proveedor
@return Los datos componen un vector de tres valores:
error: 0.Sin error 1.Datos no encontrados 2.Error al ejecutar la query
idsubcuenta: Identificador de la subcuenta
codsubcuenta: Código de la subcuenta
\end */
function dtoEspecial_datosCtaDto(codEjercicio:String, esNacional:Boolean, tipoSujeto:String):Array
{
	var util:FLUtil = new FLUtil();
	var datosCta:Array;
	switch (tipoSujeto) {
		case "CLI": {
			if (esNacional){
				datosCta = this.iface.datosCtaEspecial("DESNAC", codEjercicio);
				if (datosCta.error != 0)
					MessageBox.warning(util.translate("scripts", "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial DESNAC"), MessageBox.Ok, MessageBox.NoButton);
			}
			else {
				datosCta = this.iface.datosCtaEspecial("DESINT", codEjercicio);
				if (datosCta.error != 0)
					MessageBox.warning(util.translate("scripts",  "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial DESINT"), MessageBox.Ok, MessageBox.NoButton);
			}
			break;
		}
		case "PROV": {
			if (esNacional) {
				datosCta = this.iface.datosCtaEspecial("DENAPR", codEjercicio);
				if (datosCta.error != 0)
					MessageBox.warning(util.translate("scripts",  "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial DENAPR"), MessageBox.Ok, MessageBox.NoButton);
			} else {
				datosCta = this.iface.datosCtaEspecial("DEINPR", codEjercicio);
				if (datosCta.error != 0)
					MessageBox.warning(util.translate("scripts",  "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial DEINPR"), MessageBox.Ok, MessageBox.NoButton);
			}
			break;
		}
	}
	return datosCta;
}

function dtoEspecial_netoComprasFacturaProv(curFactura:FLSqlCursor):Number
{
	return parseFloat(curFactura.valueBuffer("netosindtoesp"));
}

function dtoEspecial_netoVentasFacturaCli(curFactura:FLSqlCursor):Number
{
	return parseFloat(curFactura.valueBuffer("netosindtoesp"));
}

//// DTO ESPECIAL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////

