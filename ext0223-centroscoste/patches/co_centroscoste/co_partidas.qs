
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
    function init() { this.ctx.centrosCoste_init(); }
	function validateForm():Boolean { return this.ctx.centrosCoste_validateForm(); }
    function controlCentroCoste() {
    	this.ctx.centrosCoste_controlCentroCoste();
    }
    function comprobarImporteCC():Boolean {
    	return this.ctx.centrosCoste_comprobarImporteCC();
    }
	function bufferChanged(fN) {
		return this.ctx.centrosCoste_bufferChanged(fN);
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////

function centrosCoste_init()
{
	this.iface.__init();
	this.iface.controlCentroCoste();
}

function centrosCoste_comprobarImporteCC():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var totalCC = util.sqlSelect("co_partidascc", "sum(importe)", "idpartida = " + cursor.valueBuffer("idpartida"));
	var totalP = parseFloat(cursor.valueBuffer("debe")) + parseFloat(cursor.valueBuffer("haber"));

	if (parseFloat(totalCC) > parseFloat(totalP)) {
		MessageBox.warning(util.translate("scripts", "El total de los importes por centros de coste no puede superar al valor del debe o haber"), MessageBox.Ok, MessageBox.NoButton);
	  	return false;
	}

	return true;
}

function centrosCoste_validateForm():Boolean
{
	if (!this.iface.__validateForm())
		return false;

	if(!this.iface.comprobarImporteCC())
		return false;

	return true;
}

function centrosCoste_controlCentroCoste()
{
	var util:FLUtil = new FLUtil();

	var idSubcuenta = this.cursor().valueBuffer("idsubcuenta");
	if (!idSubcuenta) {
		this.child("tbwCC").setTabEnabled("centroscoste", false);
		return;
	}

	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();

	// PGC 2008?
	if (util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicio + "'") != "08") {
		this.child("tbwCC").setTabEnabled("centroscoste", false);
		return;
	}

	var codGrupo:String = util.sqlSelect("co_subcuentas s INNER JOIN co_cuentas c ON s.idcuenta=c.idcuenta INNER JOIN co_epigrafes e ON c.idepigrafe = e.idepigrafe INNER JOIN co_gruposepigrafes ge ON e.idgrupo=ge.idgrupo", "ge.codgrupo", "ge.codgrupo in ('6','7','8','9') AND s.idsubcuenta = " + idSubcuenta, "co_subcuentas,co_cuentas,co_epigrafes,co_gruposepigrafes");
	if(codGrupo)
		this.child("tbwCC").setTabEnabled("centroscoste", true);
	else {

		if (util.sqlSelect("co_partidascc", "idpartida", "idpartida = " + this.cursor().valueBuffer("idpartida"))) {
			MessageBox.warning(util.translate("scripts", "Ha seleccionado una subcuenta que no admite centros de coste.\nLos centros asociados a la partida se eliminarán"), MessageBox.Ok, MessageBox.NoButton);
			util.sqlDelete("co_partidascc", "idpartida = " + this.cursor().valueBuffer("idpartida"));
		}

		this.child("tbwCC").setTabEnabled("centroscoste", false);
	}
}

function centrosCoste_bufferChanged(fN)
{
	this.iface.__bufferChanged(fN);

	switch(fN) {
		case "idsubcuenta":
			this.iface.controlCentroCoste();
	}
}

//// CENTROS COSTE //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

