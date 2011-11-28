
/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC2008 ////////////////////////////////////////////////////
class pgc2008 extends oficial {
    function pgc2008( context ) { oficial ( context ); }
	function lanzar() {
		return this.ctx.pgc2008_lanzar();
	}
}
//// PGC2008 ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC2008 ////////////////////////////////////////////////////
function pgc2008_lanzar()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor()
	if (!cursor.isValid()) {
		return;
	}

	var ejercicioActual:String = cursor.valueBuffer("i_co__subcuentas_codejercicioact");
	var planContable:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + ejercicioActual + "'");
	if (planContable == "08") {
		MessageBox.information(util.translate("scripts", "El plan contable del ejercicio actual es 2008.\nPara mostrar este informe deberá hacerlo desde la opción 'Cuentas anuales' seleccionando el tipo 'Perdidas y ganancias'"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	} else {
		this.iface.__lanzar();
	}
}

//// PGC2008 ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
