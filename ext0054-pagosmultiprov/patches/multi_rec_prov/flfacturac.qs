
/** @class_declaration pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTIPROV /////////////////////////////////////////////
class pagosMultiProv extends proveed /** %from: proveed */ {
	function pagosMultiProv( context ) { proveed ( context ); }
// 	function regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array {
// 		return this.ctx.pagosMultiProv_regenerarAsiento(cur, valoresDefecto);
// 	}
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.pagosMultiProv_datosConceptoAsiento(cur);
	}
}
//// PAGOSMULTIPROV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTIPROV /////////////////////////////////////////////
// function pagosMultiProv_regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array
// {
// 	var util:FLUtil = new FLUtil;
// 	var asiento:Array = [];
// 	var idAsiento:Number = cur.valueBuffer("idasiento");
// 	if (cur.isNull("idasiento")) {
//
// 		var concepto:String;
// 		var documento:String;
// 		var tipoDocumento:String;
//
// 		switch (cur.table()) {
// 			case "facturascli": {
// 				concepto = "Nuestra factura " + cur.valueBuffer("codigo") + " - " + cur.valueBuffer("nombrecliente");
// 				documento = cur.valueBuffer("codigo");
// 				tipoDocumento = "Factura de cliente";
// 				break;
// 			}
// 			case "facturasprov": {
// 				concepto = "Su factura " + cur.valueBuffer("codigo") + " - " + cur.valueBuffer("nombre");
// 				documento = cur.valueBuffer("codigo");
// 				tipoDocumento = "Factura de proveedor";
// 				break;
// 			}
// 			case "pagosdevolcli": {
// 				var codRecibo:String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
// 				var nombreCli:String = util.sqlSelect("reciboscli", "nombrecliente", "idrecibo = " + cur.valueBuffer("idrecibo"));
//
// 				if (cur.valueBuffer("tipo") == "Pago")
// 					concepto = "Pago recibo " + codRecibo + " - " + nombreCli;
// 				else
// 					concepto = "Devolución recibo " + codRecibo;
//
// 				tipoDocumento = "Recibo";
// 				break;
// 			}
// 			case "pagosdevolrem": {
// 				if (cur.valueBuffer("tipo") == "Pago")
// 					concepto = cur.valueBuffer("tipo") + " " + "remesa" + " " + cur.valueBuffer("idremesa");
//
// 				break;
// 			}
// 			case "pagosdevolprov": {
// 				var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
// 				var nombreProv:String = util.sqlSelect("recibosprov", "nombreproveedor", "idrecibo = " + cur.valueBuffer("idrecibo"));
//
// 				if (cur.valueBuffer("tipo") == "Pago")
// 					concepto = "Pago " + " recibo prov. " + codRecibo + " - " + nombreProv;
// 				break;
// 			}
// 			case "pagosmultiprov": {
// 				var listaRecibos:String = "";
// 				var nombreProveedor:String;
// 				var qryRecibos:FLSqlQuery = new FLSqlQuery();
// 				qryRecibos.setTablesList("recibosprov,pagosdevolprov");
// 				qryRecibos.setSelect("r.codigo, r.nombreproveedor");
// 				qryRecibos.setFrom("pagosdevolprov p INNER JOIN recibosprov r ON p.idrecibo = r.idrecibo ")
// 				qryRecibos.setWhere("p.idpagomulti = " + cur.valueBuffer("idpagomulti"));
// 				qryRecibos.setForwardOnly( true );
//
// 				if (!qryRecibos.exec())
// 					return false;
//
// 				while (qryRecibos.next()) {
// 					if (listaRecibos != "")
// 						listaRecibos += ", ";
// 					listaRecibos += qryRecibos.value("r.codigo");
// 					nombreProveedor = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + cur.valueBuffer("codproveedor") + "'");
// 				}
// 				concepto = "Pago recibos " + listaRecibos + " - " + nombreProveedor;
// 				break;
// 			}
// 		}
//
//
// 		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
// 		//var numAsiento:Number = util.sqlSelect("co_asientos", "MAX(numero)",  "codejercicio = '" + valoresDefecto.codejercicio + "'");
// 		//numAsiento++;
// 		with (curAsiento) {
// 			setModeAccess(curAsiento.Insert);
// 			refreshBuffer();
// 			setValueBuffer("numero", 0);
// 			setValueBuffer("fecha", cur.valueBuffer("fecha"));
// 			setValueBuffer("codejercicio", valoresDefecto.codejercicio);
// 			setValueBuffer("concepto", concepto);
// 			setValueBuffer("tipodocumento", tipoDocumento);
// 			setValueBuffer("documento", documento);
// 		}
//
// 		if (!curAsiento.commitBuffer()) {
// 			asiento.error = true;
// 			return asiento;
// 		}
// 		asiento.idasiento = curAsiento.valueBuffer("idasiento");
// 		asiento.numero = curAsiento.valueBuffer("numero");
// 		asiento.fecha = curAsiento.valueBuffer("fecha");
// 		curAsiento.select("idasiento = " + asiento.idasiento);
// 		curAsiento.first();
// 		curAsiento.setUnLock("editable", false);
// 	} else {
// 		if (!this.iface.asientoBorrable(idAsiento)) {
// 			asiento.error = true;
// 			return asiento;
// 		}
//
// 		if (cur.valueBuffer("fecha") != cur.valueBufferCopy("fecha")) {
// 			var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
// 			curAsiento.select("idasiento = " + idAsiento);
// 			if (!curAsiento.first()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.setUnLock("editable", true);
//
// 			curAsiento.select("idasiento = " + idAsiento);
// 			if (!curAsiento.first()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.setModeAccess(curAsiento.Edit);
// 			curAsiento.refreshBuffer();
// 			curAsiento.setValueBuffer("fecha", cur.valueBuffer("fecha"));
//
// 			if (!curAsiento.commitBuffer()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.select("idasiento = " + idAsiento);
// 			if (!curAsiento.first()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.setUnLock("editable", false);
// 		}
//
// 		asiento = flfactppal.iface.pub_ejecutarQry("co_asientos", "idasiento,numero,fecha,codejercicio", "idasiento = '" + idAsiento + "'");
// 		if (asiento.codejercicio != valoresDefecto.codejercicio) {
// 			MessageBox.warning(util.translate("scripts", "Está intentando regenerar un asiento del ejercicio %1 en el ejercicio %2.\nVerifique que su ejercicio actual es correcto. Si lo es y está actualizando un pago, bórrelo y vuélvalo a crear.").arg(asiento.codejercicio).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
// 			asiento.error = true;
// 			return asiento;
// 		}
// 		var curPartidas = new FLSqlCursor("co_partidas");
// 		curPartidas.select("idasiento = " + idAsiento);
// 		while (curPartidas.next()) {
// 			curPartidas.setModeAccess(curPartidas.Del);
// 			curPartidas.refreshBuffer();
// 			if (!curPartidas.commitBuffer()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 		}
// 	}
//
// 	asiento.error = false;
// 	return asiento;
// }

function pagosMultiProv_datosConceptoAsiento(cur:FLSqlCursor):Array
{
debug("pagosMultiProv_datosConceptoAsiento");

	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];
debug(cur.table());
	switch (cur.table()) {
		case "pagosmultiprov": {
			var listaRecibos:String = "";
			var nombreProveedor:String;
			var qryRecibos:FLSqlQuery = new FLSqlQuery();
			qryRecibos.setTablesList("recibosprov,pagosdevolprov");
			qryRecibos.setSelect("r.codigo, r.nombreproveedor");
			qryRecibos.setFrom("pagosdevolprov p INNER JOIN recibosprov r ON p.idrecibo = r.idrecibo ")
			qryRecibos.setWhere("p.idpagomulti = " + cur.valueBuffer("idpagomulti"));
			qryRecibos.setForwardOnly( true );

			if (!qryRecibos.exec())
				return false;

			while (qryRecibos.next()) {
debug("Recibo = " + qryRecibos.value("r.codigo"));
				if (listaRecibos != "")
					listaRecibos += ", ";
				listaRecibos += qryRecibos.value("r.codigo");
			}
			nombreProveedor = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + cur.valueBuffer("codproveedor") + "'");
			datosAsiento.concepto = "Pago recibos " + listaRecibos + " - " + nombreProveedor;
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
//// PAGOSMULTIPROV /////////////////////////////////////////////
////////////////////////////////////////////////////////////////

