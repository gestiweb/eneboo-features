
/** @class_declaration ctaVentaArt */
//////////////////////////////////////////////////////////////////
//// CTA_VENTA_ART////////////////////////////////////////////////
class ctaVentaArt extends oficial /** %from: oficial */ {
	function ctaVentaArt( context ) { oficial ( context ); }
	function generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.ctaVentaArt_generarPartidasVenta(curFactura, idAsiento, valoresDefecto);
	}
	function subcuentaVentas(referencia:String, codEjercicio:String):Array {
		return this.ctx.ctaVentaArt_subcuentaVentas(referencia, codEjercicio);
	}
}
//// CTA_VENTA_ART////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ctaVentaArt */
/////////////////////////////////////////////////////////////////
//// CTA_VENTA_ART////////////////////////////////////////////////

/** \D Genera la parte del asiento de factura de proveedor correspondiente a la subcuenta de ventas
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	concepto: Concepto de la partida
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function ctaVentaArt_generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean
{
	var ctaVentas:Array = [];
	var util:FLUtil = new FLUtil();
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	var haber:Number = 0;
	var haberME:Number = 0;
	var idUltimaPartida:Number = 0;

	/** \C En el asiento correspondiente a las facturas de proveedor, se generarán tantas partidas de compra como subcuentas distintas existan en las líneas de factura
	\end */
	var qrySubcuentas:FLSqlQuery = new FLSqlQuery();
	with (qrySubcuentas) {
		setTablesList("lineasfacturascli");
		setSelect("codsubcuenta, SUM(pvptotal)");
		setFrom("lineasfacturascli");
		setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " GROUP BY codsubcuenta");
	}
	if (!qrySubcuentas.exec())
			return false;

	var ultimaSubcuenta:Number = qrySubcuentas.size();
	if (ultimaSubcuenta == 0) {
		return this.iface.__generarPartidasVenta(curFactura, idAsiento, valoresDefecto, concepto);
	}

	var neto:Number = this.iface.netoVentasFacturaCli(curFactura);;
	neto = util.roundFieldValue(neto, "facturascli", "neto");
	var iSubcuenta:Number = 1;
	var totalHaber:Number = 0;

	while (qrySubcuentas.next()) {
		if (qrySubcuentas.value(0) == "" || !qrySubcuentas.value(0)) {
			ctaVentas = this.iface.datosCtaVentas(valoresDefecto.codejercicio, curFactura.valueBuffer("codserie"));
			if (ctaVentas.error != 0)
				return false;
		} else {
			ctaVentas.codsubcuenta = qrySubcuentas.value(0);
			ctaVentas.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + qrySubcuentas.value(0) + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
			if (!ctaVentas.idsubcuenta) {
				MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaVentas.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder crear la factura debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}

		if (monedaSistema) {
			haber = parseFloat(qrySubcuentas.value(1));
			haberME = 0;
		} else {
			haber = parseFloat(qrySubcuentas.value(1)) * parseFloat(curFactura.valueBuffer("tasaconv"));
			haberME = parseFloat(qrySubcuentas.value(1));
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
		totalHaber += parseFloat(haber);

		/// Necesario cuando se tiene la extensión de IVA incluido porque el sumatorio de redondeos agrupados por subcuenta puede no coincidir con el sumatorio total hecho en el campo Neto.
		if (iSubcuenta == ultimaSubcuenta) {
			var dif:Number = parseFloat(neto) - parseFloat(totalHaber);
			if (dif > -0.011 && dif != 0 && dif < 0.011) {
				if (monedaSistema) {
					haber = parseFloat(haber) + parseFloat(dif);
					haberME = 0;
				} else {
					haber = (parseFloat(haber) + parseFloat(dif)) * parseFloat(curFactura.valueBuffer("tasaconv"));
					haberME = parseFloat(haber) + parseFloat(dif);
				}
				haber = util.roundFieldValue(haber, "co_partidas", "haber");
				haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
			}
		}

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("idsubcuenta", ctaVentas.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaVentas.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

		if (!curPartida.commitBuffer())
			return false;

		idUltimaPartida = curPartida.valueBuffer("idpartida");
		iSubcuenta++;
	}

	/** \C En los asientos de factura de cliente, y en el caso de que se use moneda extranjera, la última partida de compras tiene un saldo tal que haga que el asiento cuadre perfectamente. Esto evita errores de redondeo de conversión de moneda entre las partidas del asiento.
	\end */
	if (!monedaSistema) {
		haber = util.sqlSelect("co_partidas", "SUM(debe - haber)", "idasiento = " + idAsiento + " AND idpartida <> " + idUltimaPartida);
		if (!haber)
			return false;
		if (!util.sqlUpdate("co_partidas", "haber", haber, "idpartida = " + idUltimaPartida))
			return false;
	}

	return true;
}

/** \D Obtiene la cuenta de ventas de un artículo para el ejercicio actual
@param	referencia: Referencia del artículo
@return	Array con los siguientes valores:
	* Código de subcuenta
	* Identificador interno de la subcuenta
\end */
function ctaVentaArt_subcuentaVentas(referencia:String, codEjercicio:String):Array
{
	var util:FLUtil = new FLUtil;
	var subcuenta:Array = [];
	subcuenta.codsubcuenta = util.sqlSelect("articulos", "codsubcuentaven", "referencia = '" + referencia + "'");
	if (subcuenta.codsubcuenta && subcuenta.codsubcuenta != "") {
		if (!codEjercicio) {
			codEjercicio = flfactppal.iface.pub_ejercicioActual();
		}
		subcuenta.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + subcuenta.codsubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
		if (!subcuenta.idsubcuenta) {
// 			MessageBox.warning(util.translate("scripts", "No se ha encontrado la subcuenta de ventas %1 correspondiente al artículo %2 en el ejercicio %3.\nSe usará la subcuenta de ventas asociada a la cuenta especial VENTAS.").arg(subcuenta.codsubcuenta).arg(referencia).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		return false;
	}
	return subcuenta;
}
//// CTA_VENTA_ART///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

