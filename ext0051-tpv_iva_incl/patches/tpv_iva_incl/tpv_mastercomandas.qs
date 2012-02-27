
/** @class_declaration ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ///////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
    function ivaIncluido( context ) { oficial ( context ); }
	function imprimirTiquePOS(codComanda:String, impresora:String, qry:FLSqlQuery) {
		return this.ctx.ivaIncluido_imprimirTiquePOS(codComanda, impresora, qry);
	}
}
//// IVA INCLUIDO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ///////////////////////////////////////////////
function ivaIncluido_imprimirTiquePOS(codComanda:String, impresora:String, qryTicket:FLSqlQuery)
{
	var util:FLUtil = new FLUtil;
	flfact_tpv.iface.establecerImpresora(impresora);

	var primerRegistro:Boolean = true;
	var total:String;
	var agente:String;
	var totalLinea:Number;
	var pvpUnitarioIva:Number;
	var descripcion:String;
	var codColor:String;
	var formaPago:String;

	if (!qryTicket.exec()) {
		return false;
	}
	while (qryTicket.next()) {
		if (primerRegistro) {
			flfact_tpv.iface.impResaltar(true);
			flfact_tpv.iface.impSubrayar(true);
			flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.nombre"));
			flfact_tpv.iface.impResaltar(false);
			flfact_tpv.iface.impSubrayar(false);
			flfact_tpv.iface.impNuevaLinea();
			flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.direccion"));
			flfact_tpv.iface.impNuevaLinea();
			flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.ciudad"));
			flfact_tpv.iface.impNuevaLinea();
			flfact_tpv.iface.imprimirDatos("Telef.  ");
			flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.telefono"));
			flfact_tpv.iface.impNuevaLinea();
			flfact_tpv.iface.imprimirDatos("N.I.F.  ");
			flfact_tpv.iface.imprimirDatos(qryTicket.value("empresa.cifnif"));
			flfact_tpv.iface.impNuevaLinea(2);
			flfact_tpv.iface.imprimirDatos("Nº Tiquet: " + qryTicket.value("tpv_comandas.codigo"));
			flfact_tpv.iface.impNuevaLinea();
			flfact_tpv.iface.imprimirDatos("Fecha: " + util.dateAMDtoDMA(qryTicket.value("tpv_comandas.fecha")));
			var hora:String = qryTicket.value("tpv_comandas.hora").toString();
			hora = hora.right(8);
			hora = hora.left(5);
			flfact_tpv.iface.imprimirDatos("   Hora: " + hora);
			flfact_tpv.iface.impNuevaLinea(2);
			flfact_tpv.iface.imprimirDatos("DESCRIPCION", 20);
			flfact_tpv.iface.imprimirDatos("CANTIDAD", 10, 2);
			flfact_tpv.iface.imprimirDatos("IMPORTE", 10, 2);
			flfact_tpv.iface.impNuevaLinea();

			total = util.roundFieldValue(qryTicket.value("tpv_comandas.total"), "tpv_comandas", "total");
			agente = qryTicket.value("tpv_agentes.descripcion");
		}

		primerRegistro = false;

		cantidad = qryTicket.value("tpv_lineascomanda.cantidad");
		pvpUnitarioIva = qryTicket.value("tpv_lineascomanda.pvpunitarioiva");
		totalLinea = util.roundFieldValue(pvpUnitarioIva * cantidad, "tpv_comandas", "total");

		descripcion = qryTicket.value("tpv_lineascomanda.descripcion");

		flfact_tpv.iface.imprimirDatos(descripcion, 20);
		flfact_tpv.iface.imprimirDatos(cantidad, 10, 2);
		flfact_tpv.iface.imprimirDatos(totalLinea, 10, 2);
		flfact_tpv.iface.impNuevaLinea();
	}

	flfact_tpv.iface.impNuevaLinea();
	flfact_tpv.iface.imprimirDatos("Total Ticket.", 30);
	flfact_tpv.iface.imprimirDatos(total, 10,2);

	flfact_tpv.iface.impAlinearH(1);

	flfact_tpv.iface.impNuevaLinea(2);
	flfact_tpv.iface.imprimirDatos("*** I.V.A. INCLUIDO ***");
	flfact_tpv.iface.impNuevaLinea();
	flfact_tpv.iface.imprimirDatos("GRACIAS POR SU VISITA");
	flfact_tpv.iface.impAlinearH(0);
	flfact_tpv.iface.impNuevaLinea(2);
	flfact_tpv.iface.impSubrayar(true);
	flfact_tpv.iface.imprimirDatos("Le atendió:");
	flfact_tpv.iface.impSubrayar(false);
	flfact_tpv.iface.imprimirDatos("   " + agente);
	flfact_tpv.iface.impNuevaLinea();
	flfact_tpv.iface.impNuevaLinea(9);
	flfact_tpv.iface.impCortar();
	flfact_tpv.iface.flushImpresora();

	var printer:FLPosPrinter = new FLPosPrinter();
	printer.setPrinterName( impresora );
	printer.send( "ESC:1B,64,05,1B,69" );
	printer.flush();
}
//// IVA INCLUIDO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

