
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
	function lanzar() {
		return this.ctx.centrosCoste_lanzar();
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////

function centrosCoste_lanzar()
{
	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid())
			return;

	var idInforme:Number = cursor.valueBuffer("id");

	var q:FLSqlQuery = new FLSqlQuery;

	q.setTablesList("co_i_centrosfacturasemi");
	q.setFrom("co_i_centrosfacturasemi");
	q.setSelect("codcentro");
	q.setWhere("idinforme = " + idInforme);
	if (!q.exec())
		return;

	if (!q.size())
		return this.iface.__lanzar();

	var listaCentros:String = "";
	while (q.next()) {
		if (listaCentros)
			listaCentros += ",";
		listaCentros += "'" + q.value(0) + "'";
	}

	q.setTablesList("co_i_subcentrosfacturasemi");
	q.setFrom("co_i_subcentrosfacturasemi");
	q.setSelect("codsubcentro");
	q.setWhere("idinforme = " + idInforme);
	if (!q.exec())
		return;

	var listaSubcentros:String = "";
	while (q.next()) {
		if (listaSubcentros)
			listaSubcentros += ",";
		listaSubcentros += "'" + q.value(0) + "'";
	}

	var masWhere:String;
	if (listaSubcentros)
		masWhere = " AND co_partidascc.codsubcentro IN (" + listaSubcentros + ")";
	else
		masWhere = " AND co_partidascc.codcentro IN (" + listaCentros + ")";

	var nombreInforme:String = cursor.action();
	var nombreReport:String = nombreInforme;
	var conIva:Boolean = cursor.valueBuffer("coniva");

	var orderBy:String;
	if (cursor.valueBuffer("numeracionauto")) {
			nombreReport = nombreReport + "_n";
			flcontinfo.iface.pub_resetearNumFactura(parseFloat(cursor.valueBuffer("numdesde")));

			orderBy = "co_partidas.codserie, co_asientos.fecha, co_partidas.idasiento";
	} else
		orderBy = "co_partidas.codserie, co_partidas.factura, co_asientos.fecha, co_partidas.idasiento";

	var ctaIVAEUE:Array = flfacturac.iface.pub_datosCtaEspecial("IVAEUE", cursor.valueBuffer("i_co__cuentas_codejercicio"));
	if (ctaIVAEUE.error == 0) {
		masWhere += " AND (co_cuentas.idcuentaesp = 'IVAREP' OR sc1.idsubcuenta = " + ctaIVAEUE["idsubcuenta"] + ")";
	} else {
		masWhere += " AND co_cuentas.idcuentaesp = 'IVAREP'";
	}

	if(conIva)
		masWhere += " AND co_partidas.iva <> 0";

	var groupBy:String = "co_partidas.idcontrapartida,empresa.nombre,co_partidas.codserie, co_partidas.factura,co_asientos.fecha,co_asientos.numero,co_asientos.idasiento,co_asientos.codejercicio,co_partidas.idsubcuenta,co_partidas.codcontrapartida, sc2.descripcion, co_partidas.cifnif,co_partidas.iva,co_partidas.recargo,co_partidas.idasiento";

	masWhere += " AND (series.siniva IS NULL OR series.siniva = false)";
	flcontinfo.iface.pub_lanzarInforme(cursor, "co_i_facturasemi_cc", "co_i_facturasemi_cc", orderBy, groupBy, masWhere, cursor.valueBuffer("id"));
}

//// CENTROS COSTE /////////////////////////////////////////////
////////////////////////////////////////////////////////////////

