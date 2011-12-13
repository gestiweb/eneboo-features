
/** @class_declaration dtoEspecial */
/////////////////////////////////////////////////////////////////
//// DTO ESPECIAL ///////////////////////////////////////////////
class dtoEspecial extends oficial /** %from: oficial */ {
    function dtoEspecial( context ) { oficial ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.dtoEspecial_commonCalculateField(fN, cursor);
	}
	function totalesPedido():Boolean {
		return this.ctx.dtoEspecial_totalesPedido();
	}
	function datosPedido(curPresupuesto:FLSqlCursor):Boolean {
		return this.ctx.dtoEspecial_datosPedido(curPresupuesto);
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
	*/
	case "totaliva": {
			var porDto:Number = cursor.valueBuffer("pordtoesp");
			if (!porDto || porDto == 0) {
				valor = this.iface.__commonCalculateField(fN, cursor);
				break;
			}
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * iva * (100 - " + porDto + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totaliva"));
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
			valor = util.sqlSelect("lineaspresupuestoscli", "SUM((pvptotal * recargo * (100 - " + porDto + ")) / 100 / 100)", "idpresupuesto = " + cursor.valueBuffer("idpresupuesto"));
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "totalrecargo"));
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
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "neto"));
			break;
		}
	/** \C
	El --dtoesp-- es el --netosindtoesp-- menos el porcentaje que marca el --pordtoesp--
	\end */
	case "dtoesp": {
			valor = (parseFloat(cursor.valueBuffer("netosindtoesp")) * parseFloat(cursor.valueBuffer("pordtoesp"))) / 100;
			valor = parseFloat(util.roundFieldValue(valor, "presupuestoscli", "dtoesp"));
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

/** \D Informa los datos de un pedido a partir de los de un presupuesto
@param	curPresupuesto: Cursor que contiene los datos a incluir en el pedido
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_datosPedido(curPresupuesto:FLSqlCursor):Boolean
{
	var fecha:String;
	if (curPresupuesto.action() == "pedidoscli") {
		var hoy:Date = new Date();
		fecha = hoy.toString();
	} else
		fecha = curPresupuesto.valueBuffer("fecha");

	with (this.iface.curPedido) {
		setValueBuffer("pordtoesp", curPresupuesto.valueBuffer("pordtoesp"));
	}

	if(!this.iface.__datosPedido(curPresupuesto))
		return false;

	return true;
}

/** \D Informa los datos de un pedido referentes a totales (I.V.A., neto, etc.)
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function dtoEspecial_totalesPedido():Boolean
{
	with (this.iface.curPedido) {
		setValueBuffer("netosindtoesp", formpedidoscli.iface.pub_commonCalculateField("netosindtoesp", this));
		setValueBuffer("dtoesp", formpedidoscli.iface.pub_commonCalculateField("dtoesp", this));
		setValueBuffer("neto", formpedidoscli.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidoscli.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidoscli.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidoscli.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}
//// DTO ESPECIAL ///////////////////////////////////////////////
//////////////////////////////////////////////////////////

