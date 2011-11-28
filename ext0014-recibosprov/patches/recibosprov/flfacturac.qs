
/** @class_declaration proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
class proveed extends oficial {
	function proveed( context ) { oficial ( context ); }
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.proveed_datosConceptoAsiento(cur);
	}
}
//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////




/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
function proveed_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "pagosdevolprov": {
			var numFactura:String = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "f.numproveedor", "r.idrecibo = " + cur.valueBuffer("idrecibo"), "recibosprov,facturasprov");
			if (numFactura && numFactura != "") {
				numFactura = " (Fra. " + numFactura + ")";
			} else {
				numFactura = "";
			}
			var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
			var nombreProv:String = util.sqlSelect("recibosprov", "nombreproveedor", "idrecibo = " + cur.valueBuffer("idrecibo"));

			if (cur.valueBuffer("tipo") == "Pago") {
				datosAsiento.concepto = "Pago " + " recibo prov. " + codRecibo + numFactura + " - " + nombreProv;
			}
			if (cur.valueBuffer("tipo") == "Devolución") {
				datosAsiento.concepto = "Devolución recibo " + codRecibo + numFactura + " - " + nombreProv;;
			}
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
			break;
		}
		default: {
			datosAsiento = this.iface.__datosConceptoAsiento(cur);
			break;
		}
	}
	return datosAsiento;
}



//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



