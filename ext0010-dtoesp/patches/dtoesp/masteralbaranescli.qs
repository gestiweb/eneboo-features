
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial /** %from: oficial */ {
    function dtoEspecial( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function totalesFactura():Boolean {
		return this.ctx.dtoEspecial_totalesFactura();
	}
	function datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.dtoEspecial_datosFactura(curAlbaran, where, datosAgrupacion);
	}
	function buscarPorDtoEsp(where:String):Number  {
		return this.ctx.dtoEspecial_buscarPorDtoEsp(where);
	}
}

/** @class_definition dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
function dtoEspecial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util = new FLUtil();
	var valor;
debug("Calculando " + fN);
	switch (fN) {
	/** \C
	El --totaliva-- es la suma del iva correspondiente a las líneas de factura
	*/
		case "totaliva": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totaliva"));
			break;
		}
	/** \C
	El --totarecargo-- es la suma del recargo correspondiente a las líneas de factura
	*/
		case "totalrecargo": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineasalbaranescli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idalbaran = " + cursor.valueBuffer("idalbaran"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "totalrecargo"));
			break;
		}
	/** \C
	El --netosindtoesp-- es la suma del pvp total de las líneas de factura
	*/
		case "netosindtoesp": {
			valor = this.iface.__commonCalculateField("neto", cursor);
			break;
		}
	/** \C
	El --neto-- es el --netosindtoesp-- menos el --dtoesp--
	*/
		case "neto": {
			valor = parseFloat(cursor.valueBuffer("netosindtoesp")) - parseFloat(cursor.valueBuffer("dtoesp"));
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	*/
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "dtoesp"));
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
			valor = parseFloat(util.roundFieldValue(valor, "albaranescli", "pordtoesp"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

/** \D Informa los datos de una factura referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesFactura():Boolean
{
	with(this.iface.curFactura) {
		setValueBuffer("netosindtoesp", formfacturascli.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formfacturascli.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formfacturascli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formfacturascli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formfacturascli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formfacturascli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formfacturascli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formfacturascli.iface.pub_commonCalculateField("totaleuros", this));
	}

	return true;
}

/** \D Informa los datos de una factura a partir de los de uno o varios albaranes
@param	curAlbaran: Cursor que contiene los datos a incluir en la factura
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_datosFactura(curAlbaran:FLSqlCursor,where:String,datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var porDtoEsp:Number = this.iface.buscarPorDtoEsp(where);
	if (porDtoEsp == -1) {
		MessageBox.critical(util.translate("scripts", "No es posible generar un único albarán para pedidos con distinto porcentaje de descuento especial"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var fecha:String;
	if (curAlbaran.action() == "albaranescli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curAlbaran.valueBuffer("fecha");

	with (this.iface.curFactura) {
		setValueBuffer("pordtoesp", porDtoEsp);
	}
	if(!this.iface.__datosFactura(curAlbaran, where, datosAgrupacion))
		return false;

	return true;
}

/** \D
Busca el porcentaje de descuento especial realizado a los albaranes que se agruparán en una factura. Si existen dos pedidos con distinto porcentaje devuelve un código de error.
@param where: Cláusula where para buscar los pedidos
@return porcenteje de descuento (-1 si hay error);
*/
function dtoEspecial_buscarPorDtoEsp(where:String):Number
{
	var util:FLUtil = new FLUtil;
	var porDtoEsp:Number = util.sqlSelect("albaranescli", "pordtoesp", where);
	var porDtoEsp2:Number = util.sqlSelect("albaranescli", "pordtoesp", where + " AND pordtoesp <> " + porDtoEsp);
	if (!porDtoEsp2 && isNaN(parseFloat(porDtoEsp2)))
		return porDtoEsp;
	else
		return -1;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

