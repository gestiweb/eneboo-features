
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial /** %from: oficial */ {
    function portes( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.portes_commonCalculateField(fN, cursor);
	}
	function copiadatosFactura(curFactura:FLSqlCursor):Boolean {
		return this.ctx.portes_copiadatosFactura(curFactura);
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
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "neto"));
			break;
		}

		case "totaliva":{
			var totalIvaPortes:Number = parseFloat(cursor.valueBuffer("totalivaportes"));
			valor = this.iface.__commonCalculateField(fN, cursor);
			valor += totalIvaPortes;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totaliva"));
			break;
		}

		case "totalrecargo":{
			var totalRePortes:Number = parseFloat(cursor.valueBuffer("totalreportes"));
			valor = this.iface.__commonCalculateField(fN, cursor);
			valor += totalRePortes;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalrecargo"));
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
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalivaportes"));
			break;
		}

		case "reportes": {
			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + cursor.valueBuffer("codcliente") + "'");
			if (aplicarRecEq) {
				valor = flfacturac.iface.pub_campoImpuesto("recargo", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
			} else {
				valor = 0;
			}
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "reportes"));
			break;
		}

		case "ivaportes": {
			valor = flfacturac.iface.pub_campoImpuesto("iva", cursor.valueBuffer("codimpuestoportes"), cursor.valueBuffer("fecha"));
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "ivaportes"));
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
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalreportes"));
			break;
		}

		case "totalportes":{
			var portes:Number = parseFloat(cursor.valueBuffer("netoportes"));
			var totalIvaPortes:Number = parseFloat(cursor.valueBuffer("totalivaportes"));
			var totalRePortes:Number = parseFloat(cursor.valueBuffer("totalreportes"));
			valor = portes + totalIvaPortes + totalRePortes;
			valor = parseFloat(util.roundFieldValue(valor, "facturascli", "totalportes"));
			break;
		}

		default:{
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

function portes_copiadatosFactura(curFactura:FLSqlCursor):Boolean
{
	if(!this.iface.__copiadatosFactura(curFactura))
		return false;

	with (this.iface.curFactura) {
		setValueBuffer("netoportes", curFactura.valueBuffer("netoportes"));
		setValueBuffer("codimpuestoportes", curFactura.valueBuffer("codimpuestoportes"));
		setValueBuffer("ivaportes", curFactura.valueBuffer("ivaportes"));
		setValueBuffer("reportes", curFactura.valueBuffer("reportes"));
	}
	return true;
}

function portes_totalesFactura():Boolean
{
	with(this.iface.curFactura) {
		setValueBuffer("totalivaportes", formfacturascli.iface.pub_commonCalculateField("totalivaportes", this));
		setValueBuffer("totalreportes", formfacturascli.iface.pub_commonCalculateField("totalreportes", this));
		setValueBuffer("totalportes", formfacturascli.iface.pub_commonCalculateField("totalportes", this));
	}
	this.iface.__totalesFactura();

	return true;
}

//// PORTES /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

