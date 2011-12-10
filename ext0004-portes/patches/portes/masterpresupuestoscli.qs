
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial /** %from: oficial */ {
    function portes( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.portes_commonCalculateField(fN, cursor);
	}
	function totalesPedido():Boolean {
		return this.ctx.portes_totalesPedido();
	}
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.portes_datosPedido(curPresupuesto);
	}
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
function portes_commonCalculateField(fN:String, cursor:FLSqlCursor)
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {

		case "neto":{
			var netoPortes:Number = parseFloat(cursor.valueBuffer("netoportes"));
			valor = this.iface.__commonCalculateField(fN, cursor);
			valor += netoPortes;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "neto"));
			break;
		}

		case "totaliva": {
			var totalIvaPortes:Number = parseFloat(cursor.valueBuffer("totalivaportes"));
			valor = this.iface.__commonCalculateField(fN, cursor);
			valor += totalIvaPortes;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totaliva"));
			break;
		}

		case "totalrecargo":{
			var totalRePortes:Number = parseFloat(cursor.valueBuffer("totalreportes"));
			valor = this.iface.__commonCalculateField(fN, cursor);
			valor += totalRePortes;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalrecargo"));
			break;
		}

		case "totalivaportes": {
			var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
			if (regIva == "U.E." || regIva == "Exento") {
				valor = 0;
				break;
			}
			var portes:Number = parseFloat(cursor.valueBuffer("netoportes"));
			var ivaportes:Number = parseFloat(cursor.valueBuffer("ivaportes"));
			valor = (portes * ivaportes) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalivaportes"));
			break;
		}

		case "reportes": {
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
			if (aplicarRecEq) {
				valor = flfacturac.iface.pub_campoImpuesto("recargo", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
			} else {
				valor = 0;
			}
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "reportes"));
			break;
		}

		case "ivaportes": {
			valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "ivaportes"));
			break;
		}
		case "totalreportes": {
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
			if (aplicarRecEq) {
				var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
				if (regIva == "U.E." || regIva == "Exento") {
					valor = 0;
					break;
				}
				var portes:Number = parseFloat(cursor.valueBuffer("netoportes"));
				var reportes:Number = parseFloat(cursor.valueBuffer("reportes"));
				valor = (portes * reportes) / 100;
			} else
				valor = 0;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalreportes"));
			break;
		}

		case "totalportes":{
			var portes:Number = parseFloat(cursor.valueBuffer("netoportes"));
			var totalIvaPortes:Number = parseFloat(cursor.valueBuffer("totalivaportes"));
			var totalRePortes:Number = parseFloat(cursor.valueBuffer("totalreportes"));
			valor = portes + totalIvaPortes + totalRePortes;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalportes"));
			break;
		}

		default:{
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}
/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function portes_totalesPedido():Boolean
{
	this.iface.curPedido.setValueBuffer("totalivaportes", formpedidoscli.iface.commonCalculateField("totalivaportes", this.iface.curPedido));
	this.iface.curPedido.setValueBuffer("totalreportes", formpedidoscli.iface.commonCalculateField("totalreportes", this.iface.curPedido));
	this.iface.curPedido.setValueBuffer("totalportes", formpedidoscli.iface.commonCalculateField("totalportes", this.iface.curPedido));

	if (!this.iface.__totalesPedido()) {
		return false;
	}
	/** with (this.iface.curPedido) {
		setValueBuffer("codigo", formpedidoscli.iface.pub_commonCalculateField("codigo", this));
	} Quitado porque no le veo sentido Antonio */
	return true;
}



/** \D Informa los datos de un pedido a partir de los de un presupuesto
@param	curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function portes_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	if (!this.iface.__datosPedido(curPresupuesto)) {
		return false;
	}
	var codImpuesto:String = curPresupuesto.valueBuffer("codimpuestoportes");
	var iva:Number, recargo:Number;
	this.iface.curPedido.setValueBuffer("netoportes", curPresupuesto.valueBuffer("netoportes"));
	this.iface.curPedido.setValueBuffer("codimpuestoportes", codImpuesto);
	if (curPresupuesto.isNull("ivaportes")) {
		this.iface.curPedido.setNull("ivaportes");
	} else {
		iva = curPresupuesto.valueBuffer("ivaportes");
		if (iva != 0 && codImpuesto && codImpuesto != "") {
			iva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, this.iface.curPedido.valueBuffer("fecha"));
		}
		this.iface.curPedido.setValueBuffer("ivaportes", iva);
	}
	if (curPresupuesto.isNull("reportes")) {
		this.iface.curPedido.setNull("reportes");
	} else {
		recargo = curPresupuesto.valueBuffer("reportes");
		if (recargo != 0 && codImpuesto && codImpuesto != "") {
			recargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, this.iface.curPedido.valueBuffer("fecha"));
		}
		this.iface.curPedido.setValueBuffer("reportes", recargo);
	}

	return true;
}
//// PORTES /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

