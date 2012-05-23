
/** @class_declaration funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUNNUMSERIE ///////////////////////////////////////////
class funNumSerie extends oficial {
    function funNumSerie( context ) { oficial ( context ); }
	function datosLineaVenta():Boolean {
		return this.ctx.funNumSerie_datosLineaVenta();
	}
	function calculateField(fN:String):String {
		return this.ctx.funNumSerie_calculateField(fN);
	}
}
//// FUNNUMSERIE ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUNNUMSERIE////////////////////////////////////////////
/** |D Establece los datos de la línea de ventas a crear mediante la inserción rápida. Si lo que se inserta como referencia es un número de serie, se comprueba que el número no esté vendido y se ajusta la línea de venta con el dato
\end */
function funNumSerie_datosLineaVenta():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var qryNumSerie:FLSqlQuery = new FLSqlQuery();
	with (qryNumSerie) {
		setTablesList("numerosserie,articulos");
		setSelect("ns.numserie, ns.referencia, ns.idfacturaventa, ns.vendido, a.descripcion, a.pvp");
		setFrom("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia");
		setWhere("ns.numserie = '" + cursor.valueBuffer("referencia") + "'")
		setForwardOnly(true);
	}
	if (!qryNumSerie.exec())
		return false;

	if (!qryNumSerie.first())
		return this.iface.__datosLineaVenta();

	if (qryNumSerie.value("ns.vendido")) {
		MessageBox.warning(util.translate("scripts", "Este número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	if (util.sqlSelect("tpv_lineascomanda", "idtpv_linea", "numserie = '" + qryNumSerie.value("ns.numserie") + "'")) {
		MessageBox.warning(util.translate("scripts", "Este número de serie ya está incluido en la venta actual"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	if (parseFloat(this.iface.txtCanArticulo.text) != 1) {
		MessageBox.warning(util.translate("scripts", "Si establece un número de serie la cantidad debe ser siempre 1"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	this.iface.__datosLineaVenta();
	this.iface.curLineas.setValueBuffer("referencia", qryNumSerie.value("ns.referencia"));
	this.iface.curLineas.setValueBuffer("numserie", qryNumSerie.value("ns.numserie"));
	
	return true;
}

/** \D Los datos del artículo se buscan primero suponiendo que la referencia es un número de serie. Si no se encuantran se buscan de la forma normal
\end */
function funNumSerie_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		case "desarticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.descripcion", "ns.numserie = '" + cursor.valueBuffer("referencia") + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			if (!valor)
				valor = "";
			break;
		}
		case "pvparticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.pvp", "ns.numserie = '" + cursor.valueBuffer("referencia") + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			break;
		}
		case "ivaarticulo": {
			valor = util.sqlSelect("numerosserie ns INNER JOIN articulos a ON ns.referencia = a.referencia", "a.codimpuesto", "ns.numserie = '" + cursor.valueBuffer("referencia") + "'", "articulos,numerosserie");
			if (!valor)
				valor = this.iface.__calculateField(fN);
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}
//// FUNNUMSERIE////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

