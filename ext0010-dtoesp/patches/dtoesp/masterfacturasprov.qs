
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial /** %from: oficial */
{
    function dtoEspecial( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function copiadatosFactura(curFactura:FLSqlCursor):Boolean {
		return this.ctx.dtoEspecial_copiadatosFactura(curFactura);
	}
	function totalesFactura():Boolean {
		return this.ctx.dtoEspecial_totalesFactura();
	}
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
function dtoEspecial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util = new FLUtil();
	var valor;

	switch (fN) {
	/** \C
	El --totaliva-- es la suma del iva correspondiente a las líneas de factura
	\end */
		case "totaliva":{
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineasfacturasprov", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totaliva"));
			break;
		}
	/** \C
	El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
	\end */
		case "totalrecargo":{
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineasfacturasprov", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idfactura = " + cursor.valueBuffer("idfactura"));
			valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "totalrecargo"));
			break;
		}
	/** \C
	El --netosindtoesp-- es la suma del pvp total de las líneas de factura
	\end */
		case "netosindtoesp":{
			valor = this.iface.__commonCalculateField("neto", cursor);
			break;
		}
	/** \C
	El --neto-- es el --netosindtoesp-- menos el --dtoesp--
	\end */
		case "neto": {
			valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
			valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "facturasprov", "dtoesp"));
			break;
		}
	/** \C
	El --pordtoesp-- es el --dtoesp-- entre el --netosindtoesp-- por 100
	\end */
		case "pordtoesp": {
			if (parseFloat(cursor.valueBuffer("netosindtoesp")) != 0) {
				valor = (parseFloat(cursor.valueBuffer("dtoesp")) / parseFloat(cursor.valueBuffer("netosindtoesp"))) * 100;
			} else {
				valor = cursor.valueBuffer("pordtoesp");
			}
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "pordtoesp"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

function dtoEspecial_copiadatosFactura(curFactura:FLSqlCursor):Boolean
{
	if (!this.iface.__copiadatosFactura(curFactura))
		return false

	this.iface.curFactura.setValueBuffer("pordtoesp", curFactura.valueBuffer("pordtoesp"));
	this.iface.curFactura.setValueBuffer("dtoesp", curFactura.valueBuffer("dtoesp"));

	return true;
}

function dtoEspecial_totalesFactura():Boolean
{
	this.iface.curFactura.setValueBuffer("netosindtoesp", formfacturasprov.iface.pub_commonCalculateField("netosindtoesp", this.iface.curFactura));

	return  this.iface.__totalesFactura();
}

//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

