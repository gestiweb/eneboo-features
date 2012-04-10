
/** @class_declaration pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTI /////////////////////////////////////////////////
class pagosMulti extends oficial /** %from: oficial */ {
	function pagosMulti( context ) { oficial ( context ); }
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.pagosMulti_datosConceptoAsiento(cur);
	}
}
//// PAGOS_MULTIPLES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTI /////////////////////////////////////////////////
function pagosMulti_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "pagosmulticli": {
			var listaRecibos:String = "";
			var qryRecibos:FLSqlQuery = new FLSqlQuery();
			qryRecibos.setTablesList("reciboscli,pagosdevolcli");
			qryRecibos.setSelect("r.codigo, r.nombrecliente");
			qryRecibos.setFrom("pagosdevolcli p INNER JOIN reciboscli r ON p.idrecibo = r.idrecibo ")
			qryRecibos.setWhere("p.idpagomulti = " + cur.valueBuffer("idpagomulti"));
			qryRecibos.setForwardOnly( true );

			if (!qryRecibos.exec())
				return false;

			while (qryRecibos.next()) {
				if (listaRecibos != "")
					listaRecibos += ", ";
				listaRecibos += qryRecibos.value("r.codigo");
				nombreCliente = util.sqlSelect("clientes", "nombre", "codcliente = '" + cur.valueBuffer("codcliente") + "'");;
			}

			datosAsiento.concepto = "Pago recibos " + listaRecibos + " - " + nombreCliente;
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
			break;
		}
		default: {
			datosAsiento = this.iface.__datosConceptoAsiento(cur);
		}
	}
	return datosAsiento;
}
//// PAGOSMULTI //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

