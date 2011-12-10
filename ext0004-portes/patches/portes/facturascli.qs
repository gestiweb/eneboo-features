
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial /** %from: oficial */ {
    function portes( context ) { oficial ( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.portes_bufferChanged(fN);
	}
	function init() {
		return this.ctx.portes_init();
	}
	function controlIvaPortes() {
		return this.ctx.portes_controlIvaPortes();
	}
	function actualizarLineasIva(curFactura:FLSqlCursor):Boolean {
		return this.ctx.portes_actualizarLineasIva(curFactura);
	}
	function validateForm():Boolean {
		return this.ctx.portes_validateForm();
	}
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
function portes_init()
{
	this.iface.__init(); /// Se llama antes para que el bufferChanged esté conectado antes de establecer el impuesto.

	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			var codIvaPortes:String = flfactppal.iface.pub_valorDefectoEmpresa("codivaportes");
			if (codIvaPortes)
				this.child("fdbCodImpuestoPortes").setValue(codIvaPortes);
			this.iface.controlIvaPortes();
			break;
		}
		case cursor.Edit: {
			this.iface.controlIvaPortes();
			break;
		}
	}
}

function portes_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	switch (fN) {
		case "netoportes":
			this.child("tbnActualizarIva").enabled = true;
			this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
			this.child("fdbTotalIvaPortes").setValue(this.iface.calculateField("totalivaportes"));
			this.child("fdbTotalRePortes").setValue(this.iface.calculateField("totalreportes"));
			this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			this.child("fdbTotalPortes").setValue(this.iface.calculateField("totalportes"));
			break;

		case "ivaportes":
			this.child("tbnActualizarIva").enabled = true;
			this.child("fdbTotalIvaPortes").setValue(this.iface.calculateField("totalivaportes"));
			this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			this.child("fdbTotalPortes").setValue(this.iface.calculateField("totalportes"));
			break;

		case "codimpuestoportes":
			this.child("tbnActualizarIva").enabled = true;
			this.child("fdbRePortes").setValue(this.iface.calculateField("reportes"));
			this.child("fdbIvaPortes").setValue(this.iface.calculateField("ivaportes"));
			break;

		case "reportes":
			this.child("tbnActualizarIva").enabled = true;
			this.child("fdbTotalRePortes").setValue(this.iface.calculateField("totalreportes"));
			this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.child("fdbTotalPortes").setValue(this.iface.calculateField("totalportes"));
			break;

		case "codserie":
		case "codcliente":
			this.child("fdbRePortes").setValue(this.iface.calculateField("reportes"));
			this.iface.controlIvaPortes();
			this.iface.__bufferChanged(fN);
			break;

		default:
			this.iface.__bufferChanged(fN);
			break;
	}
}

/** \C Inhabilita los controles de IVA de portes si la factura no debe tener IVA
\end */
function portes_controlIvaPortes()
{
	if (flfacturac.iface.pub_tieneIvaDocCliente(this.cursor().valueBuffer("codserie"), this.cursor().valueBuffer("codcliente"))) {
		this.child("fdbCodImpuestoPortes").setDisabled(false);
		this.child("fdbIvaPortes").setDisabled(false);
		this.child("fdbRePortes").setDisabled(false);
	} else {
		this.child("fdbCodImpuestoPortes").setValue("");
		this.child("fdbIvaPortes").setValue(0);
		this.child("fdbRePortes").setValue(0);
		this.child("fdbCodImpuestoPortes").setDisabled(true);
		this.child("fdbIvaPortes").setDisabled(true);
		this.child("fdbRePortes").setDisabled(true);
	}
}

/** \D
Actualiza (borra y reconstruye) los datos referentes a la factura en la tabla de agrupaciones por IVA (lineasivafactcli)
@param curFactura: Cursor posicionado en la factura
\end */
function portes_actualizarLineasIva(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idFactura:String;
	try {
		idFactura = curFactura.valueBuffer("idfactura");
	} catch (e) {
		// Antes se recibía sólo idFactura
		MessageBox.critical(util.translate("scripts", "Hay un problema con la actualización de su personalización.\nPor favor, póngase en contacto con InfoSiAL para solucionarlo"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var totalPortes:Number = parseFloat(curFactura.valueBuffer("totalportes"));
	if (isNaN(totalPortes))
		totalPortes = 0;
	if (!totalPortes || totalPortes == 0)
		return this.iface.__actualizarLineasIva(curFactura);

	if (curFactura.modeAccess() == curFactura.Insert) {
		return true;
	}

	var porDto:Number = curFactura.valueBuffer("pordtoesp");
	if (!porDto || isNaN(porDto) == 0)
		porDto = 0;

	var netoExacto:Number = curFactura.valueBuffer("neto");
	var lineasSinIVA:Number = util.sqlSelect("lineasfacturascli", "SUM(pvptotal)", "idfactura = " + idFactura + " AND iva IS NULL");
	lineasSinIVA = (isNaN(lineasSinIVA) ? 0 : lineasSinIVA);
	netoExacto -= lineasSinIVA;
	netoExacto = util.roundFieldValue(netoExacto, "facturascli", "neto");

	var ivaExacto:Number = curFactura.valueBuffer("totaliva");
	var reExacto:Number = curFactura.valueBuffer("totalrecargo");
	if (!reExacto)
		reExacto = 0;

	if (!util.sqlDelete("lineasivafactcli", "idfactura = " + idFactura))
		return false;

	var codImpuestoAnt:Number = 0;
	var codImpuesto:Number = 0;
	var iva:Number;
	var recargo:Number;
	var totalNeto:Number = 0;
	var totalIva:Number = 0;
	var totalRecargo:Number = 0;
	var totalLinea:Number = 0;
	var acumNeto:Number = 0;
	var acumIva:Number = 0;
	var acumRecargo:Number = 0;

	var curLineaIva:FLSqlCursor = new FLSqlCursor("lineasivafactcli");
	var qryLineasFactura:FLSqlQuery = new FLSqlQuery;
	with (qryLineasFactura) {
		setTablesList("lineasfacturascli");
		setSelect("codimpuesto, iva, recargo, pvptotal");
		setFrom("lineasfacturascli");
		setWhere("idfactura = " + idFactura + " AND pvptotal <> 0 AND iva IS NOT NULL ORDER BY codimpuesto");
		setForwardOnly(true);
	}
	if (!qryLineasFactura.exec())
		return false;

	var regIva:String = flfacturac.iface.pub_regimenIVACliente(curFactura);

	while (qryLineasFactura.next()) {
		codImpuesto = qryLineasFactura.value("codimpuesto");
		if (codImpuestoAnt != 0 && codImpuestoAnt != codImpuesto) {
			totalNeto = (totalNeto * (100 - porDto)) / 100;
			totalNeto = util.roundFieldValue(totalNeto, "lineasivafactcli", "neto");
			totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactcli", "totaliva");
			totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactcli", "totalrecargo");
			totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
			totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");

			acumNeto += parseFloat(totalNeto);
			acumIva += parseFloat(totalIva);
			acumRecargo += parseFloat(totalRecargo);

			with(curLineaIva) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("idfactura", idFactura);
				setValueBuffer("codimpuesto", codImpuestoAnt);
				setValueBuffer("iva", iva);
				setValueBuffer("recargo", recargo);
				setValueBuffer("neto", totalNeto);
				setValueBuffer("totaliva", totalIva);
				setValueBuffer("totalrecargo", totalRecargo);
				setValueBuffer("totallinea", totalLinea);
			}
			if (!curLineaIva.commitBuffer())
					return false;
			totalNeto = 0;
		}
		codImpuestoAnt = codImpuesto;
		if (regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones") {
			iva = 0;
			recargo = 0;
		} else {
			iva = parseFloat(qryLineasFactura.value("iva"));
			recargo = parseFloat(qryLineasFactura.value("recargo"));
			if (isNaN(recargo)) {
				recargo = 0;
			}
		}
		totalNeto += parseFloat(qryLineasFactura.value("pvptotal"));
	}

	if (totalNeto != 0 && qryLineasFactura.size() > 0) {
		totalNeto = (totalNeto * (100 - porDto)) / 100;
		totalNeto = util.roundFieldValue(totalNeto, "lineasivafactcli", "neto");
		totalIva = util.roundFieldValue((iva * totalNeto) / 100, "lineasivafactcli", "totaliva");
		totalRecargo = util.roundFieldValue((recargo * totalNeto) / 100, "lineasivafactcli", "totalrecargo");
		totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
		totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");

		acumNeto += parseFloat(totalNeto);
		acumIva += parseFloat(totalIva);
		acumRecargo += parseFloat(totalRecargo);

		with(curLineaIva) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idfactura", idFactura);
			setValueBuffer("codimpuesto", codImpuestoAnt);
			setValueBuffer("iva", iva);
			setValueBuffer("recargo", recargo);
			setValueBuffer("neto", totalNeto);
			setValueBuffer("totaliva", totalIva);
			setValueBuffer("totalrecargo", totalRecargo);
			setValueBuffer("totallinea", totalLinea);
		}
		if (!curLineaIva.commitBuffer())
			return false;
	}

	curLineaIva.select("idfactura = " + idFactura + " AND codimpuesto = '" + curFactura.valueBuffer("codimpuestoportes") + "'");
	if (!curLineaIva.first()) {
		curLineaIva.setModeAccess(curLineaIva.Insert);
		curLineaIva.refreshBuffer();
		totalNeto = netoExacto - acumNeto;
		totalIva = ivaExacto - acumIva;
		totalRecargo = reExacto - acumRecargo;
		totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
	} else {
		curLineaIva.setModeAccess(curLineaIva.Edit);
		curLineaIva.refreshBuffer();
		totalNeto = netoExacto - acumNeto + parseFloat(curLineaIva.valueBuffer("neto"));
		totalIva = ivaExacto - acumIva + parseFloat(curLineaIva.valueBuffer("totaliva"));
		totalRecargo = reExacto - acumRecargo  + parseFloat(curLineaIva.valueBuffer("totalrecargo"));
		totalLinea = parseFloat(totalNeto) + parseFloat(totalIva) + parseFloat(totalRecargo);
	}
	totalNeto = util.roundFieldValue(totalNeto, "lineasivafactcli", "neto");
	totalIva = util.roundFieldValue(totalIva, "lineasivafactcli", "totaliva");
	totalRecargo = util.roundFieldValue(totalRecargo, "lineasivafactcli", "totalrecargo");
	totalLinea = util.roundFieldValue(totalLinea, "lineasivafactcli", "totallinea");

	with(curLineaIva) {
		setValueBuffer("idfactura", idFactura);
		setValueBuffer("codimpuesto", curFactura.valueBuffer("codimpuestoportes"));
		setValueBuffer("iva", curFactura.valueBuffer("ivaportes"));
		setValueBuffer("recargo", curFactura.valueBuffer("reportes"));
		setValueBuffer("neto", totalNeto);
		setValueBuffer("totaliva", totalIva);
		setValueBuffer("totalrecargo", totalRecargo);
		setValueBuffer("totallinea", totalLinea);
	}
	if (!curLineaIva.commitBuffer())
		return false;

	return true;
}

function portes_validateForm():Boolean
{
	if (!this.iface.__validateForm())
		return false;

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	/** \C No se permite guardar directamente una factura con portes
	\end */
	var totalPortes:Number = parseFloat(cursor.valueBuffer("totalportes"));
	if (!totalPortes || isNaN(totalPortes))
		totalPortes = 0;
	if (cursor.modeAccess() == cursor.Insert && totalPortes != 0) {
		MessageBox.warning(util.translate("scripts", "No puede guardar directamente una factura con portes.\nCree alguna línea o guarde la factura sin portes y vuelva a editarla"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return true;
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////

