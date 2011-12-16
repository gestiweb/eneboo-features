
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
	function regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array):Array {
		return this.ctx.centrosCoste_regenerarAsiento(curFactura, valoresDefecto);
	}
	function generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_generarAsientoFacturaCli(curFactura);
	}
	function generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_generarAsientoFacturaProv(curFactura);
	}
	function crearPartidasCC(curFactura:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_crearPartidasCC(curFactura);
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////

function centrosCoste_regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array):Array
{
	var asiento:Array = this.iface.__regenerarAsiento(curFactura, valoresDefecto);

	if (asiento.error)
		return asiento;

	if (!curFactura.valueBuffer("codcentro"))
		return asiento;

	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	var idAsiento:Number = asiento.idasiento;

	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.setUnLock("editable", true);

	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.setModeAccess(curAsiento.Edit);
	curAsiento.refreshBuffer();
	curAsiento.setValueBuffer("codcentro", curFactura.valueBuffer("codcentro"));
	curAsiento.setValueBuffer("codsubcentro", curFactura.valueBuffer("codsubcentro"));

	if (!curAsiento.commitBuffer()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.setUnLock("editable", false);

	asiento.error = false;
	return asiento;
}

function centrosCoste_generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean
{
	if (!this.iface.__generarAsientoFacturaCli(curFactura))
		return false;

	this.iface.crearPartidasCC(curFactura);
}

function centrosCoste_generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean
{
	if (!this.iface.__generarAsientoFacturaProv(curFactura))
		return false;

	this.iface.crearPartidasCC(curFactura);
}

function centrosCoste_crearPartidasCC(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var tabla:String = curFactura.table();
	if (tabla != "facturascli" && tabla != "facturasprov")
		return true;

	var idAsiento:Number = curFactura.valueBuffer("idasiento");
	if (!idAsiento)
		return true;

	var tablaLineas:String = "lineas" + tabla;
	var datosCta:Array;
	debug(tabla);
	switch (tabla) {
		case "facturascli":
			idPartida = util.sqlSelect("co_partidas", "idpartida", "idasiento = " + idAsiento + " and codsubcuenta like '7%'");
		break;
		case "facturasprov":
			idPartida = util.sqlSelect("co_partidas", "idpartida", "idasiento = " + idAsiento + " and codsubcuenta like '6%'");
		break;
	}

	if (!idPartida)
		return;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList(tablaLineas);
	q.setSelect("codcentro,codsubcentro,sum(pvptotal)");
	q.setFrom(tablaLineas);
	q.setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " GROUP BY codcentro,codsubcentro");

	q.exec();

	util.sqlDelete("co_partidascc", "idpartida = " + idPartida);

	var curTab:FLSqlCursor = new FLSqlCursor("co_partidascc");

	while(q.next()) {

		if (!q.value(0))
			continue;

		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("idpartida", idPartida);
		curTab.setValueBuffer("codcentro", q.value(0));
		if (q.value(1))
			curTab.setValueBuffer("codsubcentro", q.value(1));
		curTab.setValueBuffer("importe", q.value(2));
		curTab.commitBuffer();
	}

	return true;
}

//// CENTROS COSTE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

