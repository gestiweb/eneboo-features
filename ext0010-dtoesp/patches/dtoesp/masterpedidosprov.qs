
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial /** %from: oficial */ {
    function dtoEspecial( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function totalesAlbaran():Boolean {
		return this.ctx.dtoEspecial_totalesAlbaran();
	}
	function datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.dtoEspecial_datosAlbaran(curPedido, where, datosAgrupacion);
	}
	function buscarPorDtoEsp(where:String):Number {
		return this.ctx.dtoEspecial_buscarPorDtoEsp(where);
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
		case "totaliva": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineaspedidosprov", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totaliva"));
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
			valor = util.sqlSelect("lineaspedidosprov", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpedido = " + cursor.valueBuffer("idpedido"));
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "totalrecargo"));
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
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
		case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "dtoesp"));
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
			valor = parseFloat(util.roundFieldValue(valor, "pedidosprov", "pordtoesp"));
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
		}
	}
	return valor;
}

/** \D Informa los datos de un albarán a partir de los de uno o varios pedidos
@param	curPedido: Cursor que contiene los datos a incluir en el albarán
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean
{
	var util:FLUtil = new FLUtil();
	var porDtoEsp:Number = this.iface.buscarPorDtoEsp(where);
	if (porDtoEsp == -1) {
		MessageBox.critical(util.translate("scripts", "No es posible generar un único albarán para pedidos con distinto porcentaje de descuento especial"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var fecha:String;
	if (curPedido.action() == "pedidosprov") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPedido.valueBuffer("fecha");

	with (this.iface.curAlbaran) {
		setValueBuffer("pordtoesp", porDtoEsp);
	}

	if(!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
		return false;

	return true;
}

/** \D Informa los datos de un albarán referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesAlbaran():Boolean
{
	with (this.iface.curAlbaran) {
		setValueBuffer("netosindtoesp", formalbaranesprov.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formalbaranesprov.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formalbaranesprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formalbaranesprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formalbaranesprov.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formalbaranesprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formalbaranesprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formalbaranesprov.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}


/** \D
Busca el porcentaje de descuento especial realizado a los pedidos que se agruparán en un albarán. Si existen dos pedidos con distinto porcentaje devuelve un código de error.
@param where: Cláusula where para buscar los pedidos
@return porcenteje de descuento (-1 si hay error);
\end */
function dtoEspecial_buscarPorDtoEsp(where:String):Number
{
	var util:FLUtil = new FLUtil;
	var porDtoEsp:Number = util.sqlSelect("pedidosprov", "pordtoesp", where);
	var porDtoEsp2:Number = util.sqlSelect("pedidosprov", "pordtoesp", where + "AND pordtoesp <> " + porDtoEsp);
	if (!porDtoEsp2 && isNaN(parseFloat(porDtoEsp2)))
		return porDtoEsp;
	else
		return -1;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

