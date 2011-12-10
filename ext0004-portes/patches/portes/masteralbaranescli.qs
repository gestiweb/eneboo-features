
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial /** %from: oficial */ {
    function portes( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.portes_commonCalculateField(fN, cursor);
	}
	function datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.portes_datosFactura(curAlbaran, where, datosAgrupacion);
	}
	function totalesFactura():Boolean {
		return this.ctx.portes_totalesFactura();
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
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "neto"));
			break;
		}

		case "totaliva":{
			var totalIvaPortes:Number = parseFloat(cursor.valueBuffer("totalivaportes"));
			valor = this.iface.__commonCalculateField(fN, cursor);
			valor += totalIvaPortes;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totaliva"));
			break;
		}

		case "totalrecargo":{
			var totalRePortes:Number = parseFloat(cursor.valueBuffer("totalreportes"));
			valor = this.iface.__commonCalculateField(fN, cursor);
			valor += totalRePortes;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalrecargo"));
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
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalivaportes"));
			break;
		}

		case "reportes": {
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
			if (aplicarRecEq) {
				valor = flfacturac.iface.pub_campoImpuesto("recargo", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
			}
			else
				valor = 0;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "reportes"));
			break;
		}

		case "ivaportes": {
			valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "ivaportes"));
			break;
		}

		case "totalreportes":{
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
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalreportes"));
			break;
		}

		case "totalportes":{
			var portes:Number = parseFloat(cursor.valueBuffer("netoportes"));
			var totalIvaPortes:Number = parseFloat(cursor.valueBuffer("totalivaportes"));
			var totalRePortes:Number = parseFloat(cursor.valueBuffer("totalreportes"));
			valor = portes + totalIvaPortes + totalRePortes;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalportes"));
			break;
		}

		default:{
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

/** \D Informa los datos de una factura a partir de los de uno o varios albaranes
@param	curAlbaran: Cursor que contiene los datos a incluir en la factura
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function portes_datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!this.iface.__datosFactura(curAlbaran, where, datosAgrupacion)) {
		return false;
	}
	var netoPortes:Number = util.sqlSelect("albaranescli", "SUM(netoportes)", where);
	if (isNaN(netoPortes)) {
		netoPortes = 0;
	}
	netoPortes = util.roundFieldValue(netoPortes, "facturascli", "netoportes");
	var codImpuesto:String = curAlbaran.valueBuffer("codimpuestoportes");
	var iva:Number, recargo:Number;
	this.iface.curFactura.setValueBuffer("netoportes", netoPortes);
	this.iface.curFactura.setValueBuffer("codimpuestoportes", codImpuesto);
	if (curAlbaran.isNull("ivaportes")) {
		this.iface.curFactura.setNull("ivaportes");
	} else {
		iva = curAlbaran.valueBuffer("ivaportes");
		if (iva != 0 && codImpuesto && codImpuesto != "") {
			iva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, this.iface.curFactura.valueBuffer("fecha"));
		}
		this.iface.curFactura.setValueBuffer("ivaportes", iva);
	}
	if (curAlbaran.isNull("reportes")) {
		this.iface.curFactura.setNull("reportes");
	} else {
		recargo = curAlbaran.valueBuffer("reportes");
		if (recargo != 0 && codImpuesto && codImpuesto != "") {
			recargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, this.iface.curFactura.valueBuffer("fecha"));
		}
		this.iface.curFactura.setValueBuffer("reportes", recargo);
	}

	return true;
}

/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.) de portes
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function portes_totalesFactura():Boolean
{
	with (this.iface.curFactura) {
		setValueBuffer("totalivaportes", formfacturascli.iface.pub_commonCalculateField("totalivaportes", this));
		setValueBuffer("totalreportes", formfacturascli.iface.pub_commonCalculateField("totalreportes", this));
		setValueBuffer("totalportes", formfacturascli.iface.pub_commonCalculateField("totalportes", this));
	}
	if (!this.iface.__totalesFactura()) {
		return false;
	}

	return true;
}
//// PORTES /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

