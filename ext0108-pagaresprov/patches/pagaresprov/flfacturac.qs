
/** @class_declaration pagaresProv */
/////////////////////////////////////////////////////////////////
//// PAGARES_PROV //////////////////////////////////////////////
class pagaresProv extends proveed /** %from: proveed */ {
	function pagaresProv( context ) { proveed ( context ); }
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.pagaresProv_datosConceptoAsiento(cur);
	}
}
//// PAGARES_PROV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagaresProv */
/////////////////////////////////////////////////////////////////
//// PAGARES_PROV ///////////////////////////////////////////////
function pagaresProv_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "pagosdevolprov": {
			if (cur.valueBuffer("tipo") == "Pagaré" || cur.valueBuffer("tipo") == "Pag.Anulado") {
				var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
				var nombreProv:String = util.sqlSelect("recibosprov", "nombreproveedor", "idrecibo = " + cur.valueBuffer("idrecibo"));

				datosAsiento.concepto = "Pagaré recibo " + codRecibo;
				datosAsiento.documento = "";
				datosAsiento.tipoDocumento = "";
			}
			else {
				datosAsiento = this.iface.__datosConceptoAsiento(cur);
			}

			break;
		}
		case "pagospagareprov": {
			var numeroPag:String = util.sqlSelect("pagaresprov", "numero", "idpagare = " + cur.valueBuffer("idpagare"));
			var nombreProv:String = util.sqlSelect("pagaresprov", "nombreproveedor", "idpagare = " + cur.valueBuffer("idpagare"));

			datosAsiento.concepto = "Pago pagaré prov. " + numeroPag + " - " + nombreProv;
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

//// PAGARES_PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

