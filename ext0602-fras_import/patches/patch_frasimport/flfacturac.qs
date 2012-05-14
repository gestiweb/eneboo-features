
/** @class_declaration frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
class frasImport extends oficial /** %from: oficial */ {
	function frasImport( context ) { oficial ( context ); }
	function datosPartidaFactura(curPartida:FLSqlCursor, curFactura:FLSqlCursor, tipo:String, concepto:String) {
		return this.ctx.frasImport_datosPartidaFactura(curPartida, curFactura, tipo, concepto);
	}
}
//// FRAS IMPORT ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition frasImport */
/////////////////////////////////////////////////////////////////
//// FRAS IMPORT ////////////////////////////////////////////////
function frasImport_datosPartidaFactura(curPartida:FLSqlCursor, curFactura:FLSqlCursor, tipo:String, concepto:String)
{
	var util:FLUtil = new FLUtil();
	var tipoespecial:String = util.sqlSelect("co_subcuentas", "idcuentaesp", "codsubcuenta = '" + curPartida.valueBuffer("codsubcuenta") + "'");
	if (tipoespecial == "IVASIM") {
		if (!curFactura.valueBuffer("idfacturaimport")) {
			MessageBox.information(util.translate("scripts", "Se ha generado una partida de IVA sop. importación \ny la factura no tiene ninguna asociada como factura de importación"), MessageBox.Ok, MessageBox.NoButton);
			this.iface.__datosPartidaFactura(curPartida, curFactura, tipo, concepto);
			return false;
		}

		if (concepto) {
			curPartida.setValueBuffer("concepto", concepto);
		} else {
			curPartida.setValueBuffer("concepto", util.translate("scripts", "Su factura") + curFactura.valueBuffer("codigo") + " - " + curFactura.valueBuffer("nombre"));
		}
		curPartida.setValueBuffer("tipodocumento", "Factura de proveedor");
		curPartida.setValueBuffer("documento", curFactura.valueBuffer("dua"));
		curPartida.setValueBuffer("baseimponible", curFactura.valueBuffer("baseimport"));
		curPartida.setValueBuffer("iva", curFactura.valueBuffer("tipoivaimport"));

		//Datos de la contrapartida
		var codProveedor:String = util.sqlSelect("facturasprov", "codproveedor", "idfactura = " + curFactura.valueBuffer("idfacturaimport"));
		var codSubcuentaProv:String = util.sqlSelect("co_subcuentasprov", "codsubcuenta", "codproveedor = '" + codProveedor + "' AND codejercicio = '" + curFactura.valueBuffer("codejercicio") + "'");
		if (!codSubcuentaProv) {
			MessageBox.information(util.translate("scripts", "No existe la subcuenta asociada al proveedor %1 para el ejercicio %2.\nEs necesaria para generar la partida de IVA importación").arg(codProveedor).arg(curFactura.valueBuffer("codejercicio")), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		var idSubcuentaProv:String;
		if (codSubcuentaProv) {
			idSubcuentaProv = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuentaProv + "' AND codejercicio = '" + curFactura.valueBuffer("codejercicio") + "'");
		}
		var cifProv:String = util.sqlSelect("facturasprov", "cifnif", "idfactura = " + curFactura.valueBuffer("idfacturaimport"));
		curPartida.setValueBuffer("cifnif", cifProv);
		curPartida.setValueBuffer("idcontrapartida", idSubcuentaProv);
		curPartida.setValueBuffer("codcontrapartida", codSubcuentaProv);

		curPartida.setValueBuffer("codserie", curFactura.valueBuffer("codserie"));

	} else {
		this.iface.__datosPartidaFactura(curPartida, curFactura, tipo, concepto);
	}
}

//// FRAS IMPORT /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

