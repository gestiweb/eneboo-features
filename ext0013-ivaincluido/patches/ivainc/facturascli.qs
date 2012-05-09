
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial {
    function ivaIncluido( context ) { oficial( context ); }
	function calcularTotales() {
		return this.ctx.ivaIncluido_calcularTotales();
	}
	function comprobarRedondeoIVA(cursor:FLSqlCursor, pk:String) {
		return this.ctx.ivaIncluido_comprobarRedondeoIVA(cursor, pk);
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////

function ivaIncluido_calcularTotales()
{
	this.iface.__calcularTotales();

	this.iface.comprobarRedondeoIVA(this.cursor(), "idfactura");
}

function ivaIncluido_comprobarRedondeoIVA(cursor:FLSqlCursor, pk:String)
{
	var regIva:String = flfacturac.iface.pub_regimenIVACliente(cursor);
	if (regIva == "U.E." || regIva == "Exento" || regIva == "Exportaciones"){
		return;
	}

	// Si hay portes o descuento, no habra errores de redondeo al recalcularse iva y totales
	var portes:Number = parseFloat(cursor.valueBuffer("totalportes"));
	if (!isNaN(portes) && portes != 0) return;

	var dtoEspecial:Number = parseFloat(cursor.valueBuffer("dtoesp"));
	if (!isNaN(dtoEspecial) && dtoEspecial != 0) return;


	var util:FLUtil = new FLUtil();
	var tabla:String = "lineas" + cursor.table();

	var id:Number = cursor.valueBuffer(pk);
	var neto:Number = util.sqlSelect(tabla, "sum((pvpunitario*cantidad)-dtolineal-((pvpunitario*cantidad)*dtopor/100))", pk + " = " + id);
	var iva:Number = util.sqlSelect(tabla, "sum(((pvpunitario*cantidad)-dtolineal-((pvpunitario*cantidad)*dtopor/100))*iva/100)", pk + " = " + id);

	// Comparamos la suma exacta redondeada a 2 con la suma de neto + iva
	var totalExacto = Math.round(100 * (parseFloat(neto) + parseFloat(iva)))/100;
	var totalActual = parseFloat(cursor.valueBuffer("neto")) + parseFloat(cursor.valueBuffer("totaliva"));

	debug(totalExacto + "|" + totalActual)

	var dif:Number = parseFloat(totalActual) - parseFloat(totalExacto);
	if (dif != 0) {
		var nuevoValor:Number = parseFloat(cursor.valueBuffer("totaliva")) - dif;
		nuevoValor = util.roundFieldValue(nuevoValor, cursor.table(), "totaliva");
		cursor.setValueBuffer("totaliva", nuevoValor);
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
