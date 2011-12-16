
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends pgc2008 /** %from: oficial */
{
	function centrosCoste( context ) { pgc2008( context ); }
	function crearPyG():Boolean {
			return this.ctx.centrosCoste_crearPyG();
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////

function centrosCoste_crearPyG():Boolean
{
		var cursor:FLSqlCursor = this.cursor();
		var util:FLUtil = new FLUtil();

		var desdeAct:String;
		var hastaAct:String;
		var asientoPyG:Number = -1;
		var asientoPyGAnt:Number = -1;

		var desdeAnt:String;
		var hastaAnt:String;

		var centroCoste:String = cursor.valueBuffer("codcentro");
		var subCentroCoste:String = cursor.valueBuffer("codsubcentro");

		desdeAct = cursor.valueBuffer("d_co__asientos_fechaact");
		hastaAct = cursor.valueBuffer("h_co__asientos_fechaact");
		this.iface.ejAct = cursor.valueBuffer("i_co__subcuentas_codejercicioact");

		if (cursor.valueBuffer("ignorarcierre")) {
			asientoPyG = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + this.iface.ejAct + "'");
		}

		if (this.iface.mostrarEjAnt) {
			desdeAnt = cursor.valueBuffer("d_co__asientos_fechaant");
			hastaAnt = cursor.valueBuffer("h_co__asientos_fechaant");
			this.iface.ejAnt = cursor.valueBuffer("i_co__subcuentas_codejercicioant");
			if (cursor.valueBuffer("ignorarcierre"))
				asientoPyGAnt = util.sqlSelect("ejercicios", "idasientopyg", "codejercicio = '" + this.iface.ejAnt + "'");
		}

		flcontinfo.iface.pub_establecerEjerciciosPYG(this.iface.ejAct, this.iface.ejAnt, this.iface.mostrarEjAnt);

/** \D
La consulta es compleja y se ejecuta sobre varias tablas. Las líneas obtenidas son aquellas pertenecientes a las partidas cuya subcuenta está asociada a un código de balance (a través de la cuenta) de naturaleza DEBE o HABER. La consulta extrae la suma del saldo de las subcuentas agrupadas por cuenta. Se extrae además el ejercicio, que se utilzará en caso de comparar o consolidar dos ejercicios.
\end */
		var where:String;
		var q:FLSqlQuery = new FLSqlQuery();

		q.setTablesList
				("co_cuentas,co_codbalances,co_subcuentas,co_asientos,co_partidas");

		q.setFrom
				("co_codbalances INNER JOIN co_cuentas ON co_cuentas.codbalance = co_codbalances.codbalance INNER JOIN co_subcuentas ON co_subcuentas.idcuenta = co_cuentas.idcuenta INNER JOIN co_partidas ON co_subcuentas.idsubcuenta = co_partidas.idsubcuenta INNER JOIN co_asientos ON co_partidas.idasiento = co_asientos.idasiento");

		q.setSelect
				("co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3,	co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion, 	SUM(co_partidas.debe-co_partidas.haber), co_asientos.codejercicio");

		if (this.iface.mostrarEjAnt) {
				where = "(co_codbalances.naturaleza = '" + util.translate("MetaData", "DEBE") + "' OR co_codbalances.naturaleza = '" + util.translate("MetaData", "HABER") + "')"
						 + " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
						 " AND (co_asientos.idasiento <> '" + asientoPyG + "')" +
						 " AND (co_asientos.fecha >= '" + desdeAct + "')" +
						 " AND (co_asientos.fecha <= '" + hastaAct + "'))" +
						 " OR  ((co_asientos.codejercicio = '" + this.iface.ejAnt + "') " +
						 " AND (co_asientos.idasiento <> '" + asientoPyGAnt + "')" +
						 " AND (co_asientos.fecha >= '" + desdeAnt + "')" +
						 " AND (co_asientos.fecha <= '" + hastaAnt + "')) )" +
						 " GROUP BY co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion,  co_asientos.codejercicio ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta";
		} else {
				where = "(co_codbalances.naturaleza = '" + util.translate("MetaData", "DEBE") + "' OR co_codbalances.naturaleza = '" + util.translate("MetaData", "HABER") + "')"
						 + " AND ( ((co_asientos.codejercicio = '" + this.iface.ejAct + "') " +
						 " AND (co_asientos.idasiento <> '" + asientoPyG + "')" +
						 " AND (co_asientos.fecha >= '" + desdeAct + "')" +
						 " AND (co_asientos.fecha <= '" + hastaAct + "') ))" +
						 " GROUP BY co_codbalances.codbalance, co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_codbalances.descripcion1, co_codbalances.descripcion2, co_codbalances.descripcion3, co_cuentas.codcuenta, co_cuentas.descripcion,  co_asientos.codejercicio ORDER BY co_codbalances.naturaleza, co_codbalances.nivel1, co_codbalances.nivel2, co_codbalances.nivel3, co_cuentas.codcuenta";
		}

		if (centroCoste)
			where = "co_asientos.codcentro = '" + centroCoste + "' AND " + where;
		if (subCentroCoste)
			where = "co_asientos.codsubcentro = '" + subCentroCoste + "' AND " + where;

		q.setWhere(where);


		var util:FLUtil = new FLUtil();
		if (q.exec() == false) {
				MessageBox.critical(util.
														translate("scripts", "Falló la 1ª consulta"),
														MessageBox.Ok, MessageBox.NoButton,
														MessageBox.NoButton);
				return false;
		}

		var registro:Number = 0;
		var encontrados:Boolean = false;
		this.iface.datos = [];

/** \D
Los datos procedentes de la consulta se almacenan temporalmente en el array Datos
\end */
		while (q.next()) {

				encontrados = true;

				this.iface.datos[registro] = new Array(2);
				this.iface.datos[registro]["codbalance"] = q.value(0);
				this.iface.datos[registro]["naturaleza"] = q.value(1);
				this.iface.datos[registro]["nivel1"] = q.value(2);
				this.iface.datos[registro]["nivel2"] = q.value(3);
				this.iface.datos[registro]["nivel3"] = q.value(4);
				this.iface.datos[registro]["descripcion1"] = q.value(5);
				this.iface.datos[registro]["descripcion2"] = q.value(6);
				this.iface.datos[registro]["descripcion3"] = q.value(7);
				this.iface.datos[registro]["codcuenta"] = q.value(8);
				this.iface.datos[registro]["desccuenta"] = q.value(9);
				this.iface.datos[registro]["suma"] = q.value(10);
				this.iface.datos[registro]["codejercicio"] = q.value(11);

				// Control de variación de existencias.
				codCuenta = this.iface.datos[registro]["codcuenta"];
				if (codCuenta.left(2) == "71") {
					suma = flcontinfo.iface.pub_mudarCuentasExistencias(this.iface.datos[registro]);
					this.iface.datos[registro]["suma"] = suma;
				}

				if (q.value(1) == "HABER")
						this.iface.datos[registro]["suma"] = 0 - q.value(10);

				registro++;
		}

		if (!encontrados) {
				MessageBox.warning(util.
													 translate("scripts",
																		 "No hay registros que cumplan los criterios de búsqueda establecidos"),
													 MessageBox.Ok, MessageBox.NoButton,
													 MessageBox.NoButton);
				return false;
		}

		if (this.iface.datos.length == 0)
				return false;

		return true;
}

//// CENTROS COSTE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

