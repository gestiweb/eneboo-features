
/** @class_declaration funServiciosCli */
///////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI ////////////////////////////////////////////
class funServiciosCli extends oficial /** %from: oficial */ {
	function funServiciosCli( context ) { oficial( context ); }
	function init() {
		return this.ctx.funServiciosCli_init();
	}
	function imprimirServ() {
		return this.ctx.funServiciosCli_imprimirServ();
	}
}
//// FUN_SERVICIOS_CLI ////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// FUN_SERVICIOS_CLI /////////////////////////////////////////////////

function funServiciosCli_init()
{
	if(this.cursor().action() == "i_resfacturascli")
		this.child("toolButtonPrintServ").close()
	else
		connect(this.child("toolButtonPrintServ"), "clicked()", this, "iface.imprimirServ");
	this.iface.__init();
}

function funServiciosCli_imprimirServ()
{
	var cursor:FLSqlCursor = this.cursor();
	var pI:Array = [];
	pI["nombreInforme"] = false;
	pI["orderBy"] = false;
	pI["whereFijo"] = false;

	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion)
		return false;

	pI.nombreInforme = "i_facturascli_serv";
	pI.orderBy = "";
	var o:String = "";
	for (var i:Number = 1; i < 3; i++) {
		o = formi_albaranescli.iface.pub_obtenerOrden(i, cursor, "facturascli");
		if (o) {
			if (pI.orderBy == "")
				pI.orderBy = o;
			else
				pI.orderBy += ", " + o;
		}
	}

	if (pI.orderBy)
		pI.orderBy += ",";
	pI.orderBy += " lineasalbaranescli.idalbaran, lineasalbaranescli.referencia, lineasalbaranescli.idlinea";

	if (cursor.valueBuffer("codintervalo")) {
		var intervalo:Array = [];
		intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalo"));
		cursor.setValueBuffer("d_facturascli_fecha", intervalo.desde);
		cursor.setValueBuffer("h_facturascli_fecha", intervalo.hasta);
	}

	var where:String = "";
	if (cursor.valueBuffer("deabono")) {
		where = "facturascli.deabono";
	}
	if (cursor.valueBuffer("filtrarimportes")) {
		if (!cursor.isNull("desdeimporte")) {
			if (where != "") {
				where += " AND ";
			}
			where += "facturascli.total >= " + cursor.valueBuffer("desdeimporte");
		}
		if (!cursor.isNull("hastaimporte")) {
			if (where != "") {
				where += " AND ";
			}
			where += "facturascli.total <= " + cursor.valueBuffer("hastaimporte");
		}
	}
	pI.whereFijo = where;

	flfactinfo.iface.pub_lanzarInforme(cursor, pI.nombreInforme, pI.orderBy, "", false, false, pI.whereFijo);
}
//// FUN_SERVICIOS_CLI ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

