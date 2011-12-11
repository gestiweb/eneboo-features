
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial /** %from: oficial */ {
	function portes( context ) { oficial ( context ); }
	function generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.portes_generarPartidasVenta(curFactura, idAsiento, valoresDefecto);
	}
	function generarPartidasPortes(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.portes_generarPartidasPortes(curFactura, idAsiento, valoresDefecto);
	}
	function netoVentasFacturaCli(curFactura:FLSqlCursor):Number {
		return this.ctx.portes_netoVentasFacturaCli(curFactura);
	}
	function generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.portes_generarAsientoFacturaCli(curFactura);
	}
	function validarIvas(curDoc:FLSqlCursor):Boolean {
		return this.ctx.portes_validarIvas(curDoc);
	}
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de ventas, teniendo en cuenta los portes. Si existe una cuenta especial de portes y esta es distinta de la cuenta de ventas, se creará una partida aparte para los portes
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function portes_generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();

	if (!this.iface.__generarPartidasVenta(curFactura, idAsiento, valoresDefecto))
		return false;

	if (!this.iface.generarPartidasPortes(curFactura, idAsiento, valoresDefecto))
		return false;

	return true;

}

/** \D Genera la parte del asiento de factura correspondiente a la subcuenta de portes
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function portes_generarPartidasPortes(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean
{
	var util:FLUtil = new FLUtil();

	var netoPortes:Number = parseFloat(curFactura.valueBuffer("netoportes"));
	if (isNaN(netoPortes))
		netoPortes = 0;
	if (netoPortes == 0)
		return true;

	var ctaVentas:Array = this.iface.datosCtaVentas(valoresDefecto.codejercicio, curFactura.valueBuffer("codserie"));
	if (ctaVentas.error != 0) {
		MessageBox.warning(util.translate("scripts", "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial VENTAS"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var ctaPortes:Array = this.iface.datosCtaEspecial("PORTES", valoresDefecto.codejercicio);
	if (ctaPortes.error != 0) {
		MessageBox.warning(util.translate("scripts", "No se puede generar el asiento correspondiente a esta factura,\nantes debe asociar una cuenta contable a la cuenta especial PORTES"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var haber:Number = 0;
	var haberME:Number = 0;
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));

	var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
	if (ctaPortes.codsubcuenta == ctaVentas.codsubcuenta) {
		curPartida.select("idasiento = " + idAsiento + " AND codsubcuenta = '" + ctaVentas.codsubcuenta + "'");
		if (!curPartida.next()) {
			MessageBox.warning(util.translate("scripts", "No hay una partida asociada a la subcuenta %1 a la que añadir los portes").arg(ctaVentas.codsubcuenta), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		curPartida.setModeAccess(curPartida.Edit);
		curPartida.refreshBuffer();
		var haberVentas:Number = parseFloat(curPartida.valueBuffer("haber")) - parseFloat(curPartida.valueBuffer("debe"));
		if (monedaSistema) {
			haber = netoPortes + haberVentas;
			haberME = 0;
		} else {
			haber = (netoPortes + haberVentas) * parseFloat(curFactura.valueBuffer("tasaconv"));
			haber = util.roundFieldValue(haber, "co_partidas", "haber");
			haberME =  + haberVentas;
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
		with (curPartida) {
			setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
			setValueBuffer("idsubcuenta", ctaPortes.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaPortes.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}
	} else {
		if (monedaSistema) {
			haber = netoPortes;
			haberME = 0;
		} else {
			haber = netoPortes * parseFloat(curFactura.valueBuffer("tasaconv"));
			haber = util.roundFieldValue(haber, "co_partidas", "haber");
			haberME = netoPortes;
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("concepto", util.translate("scripts", "Nuestra factura ") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombrecliente"));
			setValueBuffer("idsubcuenta", ctaPortes.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaPortes.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}
	}
	if (!curPartida.commitBuffer())
		return false;
	return true;
}

function portes_netoVentasFacturaCli(curFactura:FLSqlCursor):Number
{
	return parseFloat(curFactura.valueBuffer("neto")) - parseFloat(curFactura.valueBuffer("netoportes"));
}

function portes_generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean
{
	/// Evita calcular el asiento cuando se hace el primer commit de la factura (antes de añadir las líneas). Esta generación falla si el albarán o documento origen contiene portes, y no es necesaria porque se vuelve a llamar a esta función en modo Edit.
	if (curFactura.modeAccess() == curFactura.Insert && curFactura.valueBuffer("automatica")) {
		return true;
	}

	if (!this.iface.__generarAsientoFacturaCli(curFactura)) {
		return false;
	}

	return true;
}

/** \D Comprueba que los porcentaje de IVA son los vigentes para el documento indicado
@param curDoc: Cursor posicionado en el documento
\end */
function portes_validarIvas(curDoc:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var tabla:String = curDoc.table();
	switch (tabla) {
		case "presupuestoscli":
		case "pedidoscli":
		case "albaranescli":
		case "facturascli": {
			var nombrePK:String = curDoc.primaryKey();
			var valorClave:String = curDoc.valueBuffer(nombrePK);

			var fecha:String = curDoc.valueBuffer("fecha");
			var codImpuesto:String, iva:Number, recargo:Number, valorActualIva:Number, valorActualRecargo:Number;
			codImpuesto = curDoc.valueBuffer("codimpuestoportes");
			if (codImpuesto && codImpuesto != "") {
				iva = curDoc.valueBuffer("ivaportes");
				if (!isNaN(iva) && iva != 0) {
					valorActualIva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha);
					if (valorActualIva != iva) {
						MessageBox.warning(util.translate("scripts", "El IVA de portes contiene un valor no adecuado a la fecha del documento."), MessageBox.Ok, MessageBox.NoButton);
						return -1;
					}
				}
				recargo = curDoc.valueBuffer("reportes");
				if (!isNaN(recargo) && recargo != 0) {
					valorActualRecargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha);
					if (valorActualRecargo != recargo) {
						MessageBox.warning(util.translate("scripts", "El Recargo de Equivalencia de portes contiene un valor no adecuado a la fecha del documento."), MessageBox.Ok, MessageBox.NoButton);
						return -1;
					}
				}
			}
		}
	}

	var res:Number = this.iface.__validarIvas(curDoc);
	return res;
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

