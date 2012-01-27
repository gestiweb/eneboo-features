
/** @class_declaration remesasProv */
/////////////////////////////////////////////////////////////////
//// REMESAS_PROV ///////////////////////////////////////////////
class remesasProv extends proveed /** %from: proveed */ {
	function remesasProv( context ) { proveed ( context ); }
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.remesasProv_datosConceptoAsiento(cur);
	}
}
//// REMESAS_PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesasProv */
/////////////////////////////////////////////////////////////////
//// REMESAS_PROV ///////////////////////////////////////////////
function remesasProv_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "pagosdevolremprov": {
			if (cur.valueBuffer("tipo") == "Pago")
				datosAsiento.concepto = cur.valueBuffer("tipo") + " " + "remesa " + " " + cur.valueBuffer("idremesa");
			datosAsiento.tipoDocumento = "";
			datosAsiento.documento = "";
			break;
		}
		default: {
			datosAsiento = this.iface.__datosConceptoAsiento(cur);
			break;
		}
	}
	return datosAsiento;
}

//// REMESAS_PROV ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////

