
/** @class_declaration compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
class compRecibos extends proveed /** %from: oficial */ {
	var curReciboPos:FLSqlCursor;
	var curReciboNeg:FLSqlCursor;
	var curReciboNeg2:FLSqlCursor;

	function compRecibos( context ) { proveed( context ); }
	function regenerarRecibosCli(cursor:FLSqlCursor):Boolean {
		return this.ctx.compRecibos_regenerarRecibosCli(cursor);
	}
	function compensarRecibosCli(curFactura:FLSqlCursor):Number {
		return this.ctx.compRecibos_compensarRecibosCli(curFactura);
	}
	function compensarReciboCli(idRecibo:String, curFactura:FLSqlCursor, sinCompensar:Number):Number {
		return this.ctx.compRecibos_compensarReciboCli(idRecibo, curFactura, sinCompensar);
	}
	function afterCommit_reciboscli(curRecibo:FLSqlCursor):Boolean {
		return this.ctx.compRecibos_afterCommit_reciboscli(curRecibo);
	}
	function calcularEstadoFacturaCli(idRecibo:String, idFactura:String):Boolean {
		return this.ctx.compRecibos_calcularEstadoFacturaCli(idRecibo, idFactura);
	}
	function datosReciboPos(curFactura:FLSqlCursor):Boolean {
		return this.ctx.compRecibos_datosReciboPos(curFactura);
	}
	function datosReciboNeg(curFactura:FLSqlCursor):Boolean {
		return this.ctx.compRecibos_datosReciboNeg(curFactura);
	}
	function datosReciboNeg2(curFactura:FLSqlCursor):Boolean {
		return this.ctx.compRecibos_datosReciboNeg2(curFactura);
	}
}
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition compRecibos */
/////////////////////////////////////////////////////////////////
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
function compRecibos_regenerarRecibosCli(cursor:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var total:Number = cursor.valueBuffer("total");
	var idFactura:Number = cursor.valueBuffer("idfactura");

	if (!this.iface.borrarRecibosCli(idFactura))
		return false;

	if (total != 0) {
		total = this.iface.compensarRecibosCli(cursor);
		if (isNaN(total)) {
			return false;
		}
	}

	var contActiva:Boolean = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");

	if (total == 0)
		return true;

	var codPago:String = cursor.valueBuffer("codpago");
	var codCliente:String = cursor.valueBuffer("codcliente");

	var emitirComo:String = util.sqlSelect("formaspago", "genrecibos", "codpago = '" + codPago + "'");
	var datosCuentaDom = this.iface.obtenerDatosCuentaDom(codCliente);
	if (datosCuentaDom.error == 2)
		return false;

	var numRecibo:Number = parseFloat(util.sqlSelect("reciboscli", "numero", "idfactura = " + idFactura + " ORDER BY numero DESC"));
	if (!numRecibo)
		numRecibo = 0;
	numRecibo++;

	var numPlazo:Number = 1;
	var importe:Number;
	var diasAplazado:Number;
	var fechaVencimiento:String;
	var datosCuentaEmp:Array = false;
	var datosSubcuentaEmp:Array = false;

	if (emitirComo == "Pagados") {
		emitirComo = "Pagado";
		/* \D Si los recibos deben emitirse como pagados, se generarán los registros de pago asociados a cada recibo. Si el módulo Principal de contabilidad está cargado, se generará el correspondienta asiento. La subcuenta contable del Debe del apunte corresponderá a la subcuenta contable asociada a la cuenta corriente correspondiente a la forma de pago de la factura. Si dicha cuenta corriente no está especificada, la subcuenta contable del Debe del asiento será la correspondiente a la cuenta especial Caja.
		\end */
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
	while (curPlazos.next()) {
		diasAplazado = curPlazos.valueBuffer("dias");
		importe = (total * parseFloat(curPlazos.valueBuffer("aplazado"))) / 100;
		if ( curPlazos.at() == ( curPlazos.size() - 1 ) )
			importe = total - importeAcumulado;
		else {
			importe = Math.round( importe );
			importeAcumulado += importe;
		}
		fechaVencimiento = this.iface.calcFechaVencimientoCli(cursor, numPlazo, diasAplazado);
debug("fechaVencimiento2 = " + fechaVencimiento);
		if (!this.iface.generarReciboCli(cursor, numRecibo, importe, fechaVencimiento, emitirComo, datosCuentaDom, datosCuentaEmp, datosSubcuentaEmp))
			return false;
		numRecibo++;
		numPlazo++;
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

/** \C Busca recibos con importe negativo para el cliente de la factura. Si los encuentra, ofrece al usuario la posibilidad de compensar la factura total o parcialmente con dichos recibos.
@param	curFactura: Cursor de la factura a compensar
@return	Importe que queda sin compensar o false si hay error
\end */
function compRecibos_compensarRecibosCli(curFactura:FLSqlCursor):Number
{
	var sinCompensar:Number = parseFloat(curFactura.valueBuffer("total"));

	var codCliente:String = curFactura.valueBuffer("codcliente");
	if (!codCliente || codCliente == "")
		return sinCompensar;

	var whereImporte:String;
	if (sinCompensar > 0) {
		whereImporte = " AND importe < 0";
	} else {
		whereImporte = " AND importe > 0";
	}

	var util:FLUtil = new FLUtil();
	var qryACompensar:FLSqlQuery = new FLSqlQuery;
	qryACompensar.setTablesList("reciboscli");
	qryACompensar.setSelect("codigo, fecha, fechav, importe, idrecibo");
	qryACompensar.setFrom("reciboscli");
	qryACompensar.setWhere("codcliente = '" + codCliente + "' AND estado = 'Emitido'" + whereImporte);
	if (!qryACompensar.exec())
		return -1;

	var codigo:Array = [];
	var fecha:Array = [];
	var fechav:Array = [];
	var importe:Array = [];
	var id:Array = [];
	var i:Number;
	while (qryACompensar.next()) {
		codigo[i] = qryACompensar.value(0);
		fecha[i] = qryACompensar.value(1);
		fechav[i] = qryACompensar.value(2);
		importe[i] = qryACompensar.value(3);
		id[i] = qryACompensar.value(4);
		i++;
	}
	if (i == 0)
		return sinCompensar;

	if (flfactteso.iface.pub_automataActivado())
		return sinCompensar;

	var dialog:Dialog = new Dialog;
	dialog.okButtonText = util.translate("scripts","Aceptar");
	dialog.cancelButtonText = util.translate("scripts","Cancelar");

	var lblMensaje = new Label;
	lblMensaje.text = util.translate("scripts", "Para el cliente de la factura existe uno o más recibos por compensar.\nSeleccione los recibos que desee compensar\n\n         Código                             Emisión       Vencimiento   Importe")
	dialog.add(lblMensaje);

	var bgroup:GroupBox = new GroupBox;
	dialog.add(bgroup);
	var ckB:Array = [];
	var valorFecha:String;
	var valorFechav:String;
	for (var j:Number = 0; j < codigo.length; j++) {
		ckB[j] = new CheckBox;
		bgroup.add(ckB[j]);
		valorFecha = fecha[j].toString();
		valorFechav = fechav[j].toString();
		ckB[j].text = codigo[j] + "    " + valorFecha.left(10) + "    " + valorFecha.left(10) + "    " + util.roundFieldValue(importe[j], "reciboscli", "importe");
		ckB[j].checked = false;
	}

	if (!dialog.exec())
		return sinCompensar;

	var compPositivo:Boolean = (sinCompensar > 0);
	for (var j:Number = 0; j < codigo.length; j++) {
		if (ckB[j].checked == true) {
			sinCompensar = this.iface.compensarReciboCli(id[j], curFactura, sinCompensar);
			if (isNaN(sinCompensar)) {
				return false;
			}
			if ((compPositivo && sinCompensar <= 0) || (!compPositivo && sinCompensar >= 0)) {
				break;
			}
		}
	}
	if (sinCompensar < 0.009 && sinCompensar > -0.009)
		sinCompensar = 0;

	return sinCompensar;
}

/** \C Compensa parte o la totalidad de un recibo con el importe de una nueva factura
@param	idRecibo: Identificador del recibo a compensar
@param	curFactura: Cursor de la factura que compensa el recibo
@param	sinCompensar: Parte del total de la factura sin compensar antes de compensar el recibo
@return	Parte del total de la factura sin compensar después de compensar el recibo o -1 si hay un error
\end */

function compRecibos_compensarReciboCli(idRecibo:String, curFactura:FLSqlCursor, sinCompensar:Number):Number
{
	var util:FLUtil = new FLUtil();

	var compPositivo:Boolean = (sinCompensar >= 0);

	if (!this.iface.curReciboNeg) {
		this.iface.curReciboNeg = new FLSqlCursor("reciboscli");
	}
	this.iface.curReciboNeg.select("idrecibo = " + idRecibo);
	if (!this.iface.curReciboNeg.first()) {
		return false;
	}
	this.iface.curReciboNeg.setModeAccess(this.iface.curReciboNeg.Edit);
	if (!this.iface.curReciboNeg.refreshBuffer()) {
		return false;
	}
	var importeNeg:Number = parseFloat(this.iface.curReciboNeg.valueBuffer("importe"));
	var importeComp:Number;
	if (compPositivo) {
		if ((sinCompensar + importeNeg) >= 0) {
			importeComp = importeNeg * -1;
		} else {
			importeComp = sinCompensar;
		}
	} else {
		if ((sinCompensar + importeNeg) <= 0) {
			importeComp = importeNeg * -1;
		} else {
			importeComp = sinCompensar;
		}
	}
	var importeRecibo:Number;
	var importeReciboEuros:Number;

	var numRecibo:Number = parseFloat(util.sqlSelect("reciboscli", "numero", "idfactura = " + curFactura.valueBuffer("idfactura") + " ORDER BY numero DESC"));
	if (!numRecibo)
		numRecibo = 0;
	numRecibo++;

	var tasaConvPos:Number = parseFloat(curFactura.valueBuffer("tasaconv"));
	var moneda:String = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + curFactura.valueBuffer("coddivisa") + "'");
	var diasAplazado:Number = util.sqlSelect("plazos", "dias", "codpago = '" + curFactura.valueBuffer("copago") + "' ORDER BY dias");
	if (isNaN(diasAplazado)) {
		diasAplazado = 0;
	}
debug("diasAplazado " + diasAplazado);
	var fechaVencimiento = this.iface.calcFechaVencimientoCli(curFactura, 1, diasAplazado);
	if (!fechaVencimiento) {
		fechaVencimiento = curFactura.valueBuffer("fecha");
	}
debug("fechaVencimiento " + fechaVencimiento);

	if (!this.iface.curReciboPos) {
		this.iface.curReciboPos = new FLSqlCursor("reciboscli");
	}
	this.iface.curReciboPos.setModeAccess(this.iface.curReciboPos.Insert);
	this.iface.curReciboPos.refreshBuffer()
	this.iface.curReciboPos.setValueBuffer("numero", numRecibo);
	this.iface.curReciboPos.setValueBuffer("idfactura", curFactura.valueBuffer("idFactura"));
	this.iface.curReciboPos.setValueBuffer("importe", importeComp);
	this.iface.curReciboPos.setValueBuffer("importeeuros", importeComp * tasaConvPos);
	this.iface.curReciboPos.setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
	this.iface.curReciboPos.setValueBuffer("codigo", curFactura.valueBuffer("codigo") + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
	this.iface.curReciboPos.setValueBuffer("codcliente", curFactura.valueBuffer("codcliente"));
	this.iface.curReciboPos.setValueBuffer("nombrecliente", curFactura.valueBuffer("nombrecliente"));
	this.iface.curReciboPos.setValueBuffer("cifnif", curFactura.valueBuffer("cifnif"));
	this.iface.curReciboPos.setValueBuffer("coddir", curFactura.valueBuffer("coddir"));
	this.iface.curReciboPos.setValueBuffer("direccion", curFactura.valueBuffer("direccion"));
	this.iface.curReciboPos.setValueBuffer("codpostal", curFactura.valueBuffer("codpostal"));
	this.iface.curReciboPos.setValueBuffer("ciudad", curFactura.valueBuffer("ciudad"));
	this.iface.curReciboPos.setValueBuffer("provincia", curFactura.valueBuffer("provincia"));
	this.iface.curReciboPos.setValueBuffer("codpais", curFactura.valueBuffer("codpais"));
	this.iface.curReciboPos.setValueBuffer("fecha", curFactura.valueBuffer("fecha"));
	this.iface.curReciboPos.setValueBuffer("fechav", curFactura.valueBuffer("fecha"));
	this.iface.curReciboPos.setValueBuffer("estado", "Compensado");
	this.iface.curReciboPos.setValueBuffer("texto", util.enLetraMoneda(importeComp, moneda));
	this.iface.curReciboPos.setValueBuffer("idrecibocomp", this.iface.curReciboNeg.valueBuffer("idrecibo"));

	if (!this.iface.datosReciboPos(curFactura)) {
		return -1;
	}
	if (!this.iface.curReciboPos.commitBuffer()) {
		return -1;
	}
	var idReciboPos:String = this.iface.curReciboPos.valueBuffer("idrecibo")

	if ((compPositivo && (sinCompensar + importeNeg) >= 0) || (!compPositivo && (sinCompensar + importeNeg) <= 0)) {
		this.iface.curReciboNeg.setValueBuffer("estado", "Compensado");
		this.iface.curReciboNeg.setValueBuffer("idrecibocomp", idReciboPos);
		if (!this.iface.curReciboNeg.commitBuffer()) {
			return -1;
		}
		sinCompensar += importeNeg;
	} else {
		var tasaConvNeg:Number = parseFloat(util.sqlSelect("facturascli", "tasaconv", "idfactura = " + this.iface.curReciboNeg.valueBuffer("idfactura")));
		numRecibo = parseFloat(this.iface.curReciboNeg.valueBuffer("numero"));
		this.iface.curReciboNeg.setValueBuffer("estado", "Compensado");
		this.iface.curReciboNeg.setValueBuffer("idrecibocomp", idReciboPos);
		this.iface.curReciboNeg.setValueBuffer("importe", (importeComp * -1));
		this.iface.curReciboNeg.setValueBuffer("importeeuros", (importeComp * tasaConvNeg * -1));
		this.iface.curReciboNeg.setValueBuffer("texto", util.enLetraMoneda((importeComp * -1), moneda));

		if (!this.iface.datosReciboNeg(curFactura)) {
			return -1;
		}
		if (!this.iface.curReciboNeg.commitBuffer()) {
			return -1;
		}
		numRecibo = parseFloat(util.sqlSelect("reciboscli", "numero", "idfactura = " + this.iface.curReciboNeg.valueBuffer("idfactura") + " ORDER BY numero DESC"));
		if (!numRecibo) {
			numRecibo = 0;
		}
		numRecibo++;

		if (!this.iface.curReciboNeg2) {
			this.iface.curReciboNeg2 = new FLSqlCursor("reciboscli");
		}
		this.iface.curReciboNeg2.setModeAccess(this.iface.curReciboNeg2.Insert);
		this.iface.curReciboNeg2.refreshBuffer();
		this.iface.curReciboNeg2.setValueBuffer("numero", numRecibo);
		this.iface.curReciboNeg2.setValueBuffer("idfactura", this.iface.curReciboNeg.valueBuffer("idfactura"));
		this.iface.curReciboNeg2.setValueBuffer("importe", (sinCompensar + importeNeg));
		this.iface.curReciboNeg2.setValueBuffer("importeeuros", (sinCompensar + importeNeg) * tasaConvNeg);
		this.iface.curReciboNeg2.setValueBuffer("coddivisa", this.iface.curReciboNeg.valueBuffer("coddivisa"));
		this.iface.curReciboNeg2.setValueBuffer("codigo", (this.iface.curReciboNeg.valueBuffer("codigo")).left(12) + "-" + flfacturac.iface.pub_cerosIzquierda(numRecibo, 2));
		this.iface.curReciboNeg2.setValueBuffer("codcliente", this.iface.curReciboNeg.valueBuffer("codcliente"));
		this.iface.curReciboNeg2.setValueBuffer("nombrecliente", this.iface.curReciboNeg.valueBuffer("nombrecliente"));
		this.iface.curReciboNeg2.setValueBuffer("cifnif", this.iface.curReciboNeg.valueBuffer("cifnif"));
		this.iface.curReciboNeg2.setValueBuffer("coddir", this.iface.curReciboNeg.valueBuffer("coddir"));
		this.iface.curReciboNeg2.setValueBuffer("direccion", this.iface.curReciboNeg.valueBuffer("direccion"));
		this.iface.curReciboNeg2.setValueBuffer("codpostal", this.iface.curReciboNeg.valueBuffer("codpostal"));
		this.iface.curReciboNeg2.setValueBuffer("ciudad", this.iface.curReciboNeg.valueBuffer("ciudad"));
		this.iface.curReciboNeg2.setValueBuffer("provincia", this.iface.curReciboNeg.valueBuffer("provincia"));
		this.iface.curReciboNeg2.setValueBuffer("codpais", this.iface.curReciboNeg.valueBuffer("codpais"));
		this.iface.curReciboNeg2.setValueBuffer("fecha", this.iface.curReciboNeg.valueBuffer("fecha"));
		this.iface.curReciboNeg2.setValueBuffer("fechav", fechaVencimiento);
		this.iface.curReciboNeg2.setValueBuffer("estado", "Emitido");
		this.iface.curReciboNeg2.setValueBuffer("texto", util.enLetraMoneda((sinCompensar + importeNeg), moneda));

		if (!this.iface.datosReciboNeg2(curFactura)) {
			return -1;
		}
		if (!this.iface.curReciboNeg2.commitBuffer()) {
			return -1;
		}
		sinCompensar = 0;
	}
	return sinCompensar;
}

function compRecibos_datosReciboPos(curFactura:FLSqlCursor):Boolean
{
	var codCliente:String = curFactura.valueBuffer("codcliente");
	var datosCuentaDom = this.iface.obtenerDatosCuentaDom(codCliente);
	switch (datosCuentaDom.error) {
		case 2: {
			return false;
		}
		case 0: {
			this.iface.curReciboPos.setValueBuffer("codcuenta", datosCuentaDom.codcuenta);
			this.iface.curReciboPos.setValueBuffer("descripcion", datosCuentaDom.descripcion);
			this.iface.curReciboPos.setValueBuffer("ctaentidad", datosCuentaDom.ctaentidad);
			this.iface.curReciboPos.setValueBuffer("ctaagencia", datosCuentaDom.ctaagencia);
			this.iface.curReciboPos.setValueBuffer("cuenta", datosCuentaDom.cuenta);
			this.iface.curReciboPos.setValueBuffer("dc", datosCuentaDom.dc);
			break;
		}
	}
	return true;
}

function compRecibos_datosReciboNeg(curFactura:FLSqlCursor):Boolean
{
	return true;
}

function compRecibos_datosReciboNeg2(curFactura:FLSqlCursor):Boolean
{
	var codCliente:String = curFactura.valueBuffer("codcliente");
	var datosCuentaDom = this.iface.obtenerDatosCuentaDom(codCliente);
	switch (datosCuentaDom.error) {
		case 2: {
			return false;
		}
		case 0: {
			this.iface.curReciboNeg2.setValueBuffer("codcuenta", datosCuentaDom.codcuenta);
			this.iface.curReciboNeg2.setValueBuffer("descripcion", datosCuentaDom.descripcion);
			this.iface.curReciboNeg2.setValueBuffer("ctaentidad", datosCuentaDom.ctaentidad);
			this.iface.curReciboNeg2.setValueBuffer("ctaagencia", datosCuentaDom.ctaagencia);
			this.iface.curReciboNeg2.setValueBuffer("cuenta", datosCuentaDom.cuenta);
			this.iface.curReciboNeg2.setValueBuffer("dc", datosCuentaDom.dc);
			break;
		}
	}
	return true;
}

/** \C Si se borra un recibo compensado, se marca su recibo relacionado como Emitido
\end */
function compRecibos_afterCommit_reciboscli(curRecibo:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.__afterCommit_reciboscli(curRecibo)) {
		return false;
	}

	switch(curRecibo.modeAccess()) {
		case curRecibo.Insert:
		case curRecibo.Edit: {
			if (curRecibo.valueBuffer("estado") == "Compensado" || curRecibo.valueBufferCopy("estado") == "Compensado") {
				if (!this.iface.calcularEstadoFacturaCli(curRecibo.valueBuffer("idrecibo")))
					return false;
			}
		break;
		}
		case curRecibo.Del: {
			if (curRecibo.valueBuffer("estado") == "Compensado") {
				if (!this.iface.calcularEstadoFacturaCli(curRecibo.valueBuffer("idrecibo")))
					return false;

				if (parseFloat(curRecibo.valueBuffer("importe")) < 0) {
					var codReciboComp:String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + curRecibo.valueBuffer("idrecibocomp"));
					var res:Number = MessageBox.warning(util.translate("scripts", "Va a borrar el recibo ") + curRecibo.valueBuffer("codigo") + util.translate("scripts", " que está compensado con el recibo ") + codReciboComp + util.translate("scripts", "\nEl recibo compensado pasará a estado Emitido. ¿Desea continuar?"), MessageBox.Yes, MessageBox.No)
					if (res != MessageBox.Yes)
						return false;
				}
				if (!util.sqlUpdate("reciboscli", "estado,idrecibocomp", "Emitido,NULL", "idrecibo = " + curRecibo.valueBuffer("idrecibocomp")))
					return false;
			}
			break;
		}
	}
	return true;
}

/** \C Si la factura tiene asociado algún recibo Compensado, no será editable
@param	idRecibo: Identificador de uno de los recibos asociados a la factura
@param	idFactura: Identificador de la factura
\end */
function compRecibos_calcularEstadoFacturaCli(idRecibo:String, idFactura:String):Boolean
{
	var util:FLUtil = new FLUtil();
	if (!idFactura)
		idFactura = util.sqlSelect("reciboscli", "idfactura", "idrecibo = " + idRecibo);

	if (util.sqlSelect("reciboscli", "idrecibo", "idfactura = " + idFactura + " AND estado = 'Compensado'")) {
		var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
		curFactura.select("idfactura = " + idFactura);
		curFactura.first();
		curFactura.setUnLock("editable", false);
	} else
		return this.iface.__calcularEstadoFacturaCli(idRecibo, idFactura);

	return true;
}
//// COMPENSACIÓN DE RECIBOS ////////////////////////////////////
/////////////////////////////////////////////////////////////////

