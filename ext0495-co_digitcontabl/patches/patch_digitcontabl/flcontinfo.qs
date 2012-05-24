
/** @class_declaration digitContable */
/////////////////////////////////////////////////////////////////
//// DIGIT_CONTABLE /////////////////////////////////////////////
class digitContable extends pgc2008 /** %from: pgc2008 */ {
    function digitContable( context ) { pgc2008 ( context ); }
	function cabeceraInforme(nodo:FLDomNode, campo:String):String {
		return this.ctx.digitContable_cabeceraInforme(nodo, campo);
	}
}
//// DIGIT_CONTABLE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubDigitContable */
/////////////////////////////////////////////////////////////////
//// PUB_DIGIT_CONTABLE /////////////////////////////////////////
class pubDigitContable extends pubPgc2008 /** %from: head */ {
    function pubDigitContable( context ) { pubPgc2008( context ); }
	function pub_cabeceraInforme(nodo:FLDomNode, campo:String):String {
		return this.cabeceraInforme(nodo, campo);
	}
}

//// PUB_DIGIT_CONTABLE /////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition digitContable */
/////////////////////////////////////////////////////////////////
//// DIGIT_CONTABLE /////////////////////////////////////////////
function digitContable_cabeceraInforme(nodo:FLDomNode, campo:String):String
{
	var texCampo:String = new String(campo);

	var util:FLUtil = new FLUtil();
	var desc:String;
	var ejAct:String, ejAnt:String;

	var texto:String;
	var sep:String = "       ";

	var qCondiciones:FLSqlQuery = new FLSqlQuery();
	qCondiciones.setTablesList(this.iface.nombreInformeActual);
	qCondiciones.setFrom(this.iface.nombreInformeActual);
	qCondiciones.setWhere("id = " + this.iface.idInformeActual);

	switch (campo) {
		case "balancesit": {
			qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,d_co__asientos_fechaact,h_co__asientos_fechaact,i_co__subcuentas_codejercicioant,d_co__asientos_fechaant,h_co__asientos_fechaant");
			if (!qCondiciones.exec())
				return "";
			if (!qCondiciones.first())
				return "";

			desc = qCondiciones.value(0);
			ejAct = qCondiciones.value(1);

			fchDesde = qCondiciones.value(2).toString().left(10);
			fchHasta = qCondiciones.value(3).toString().left(10);
			fchDesde = util.dateAMDtoDMA(fchDesde);
			fchHasta = util.dateAMDtoDMA(fchHasta);

			ejAnt = qCondiciones.value(4);
			fchDesdeAnt = qCondiciones.value(5);
			fchHastaAnt = qCondiciones.value(6);
			fchDesdeAnt = util.dateAMDtoDMA(fchDesdeAnt);
			fchHastaAnt = util.dateAMDtoDMA(fchHastaAnt);

			texto = "[ " + desc + " ]" + sep + "Ej. " + ejAct + " | Periodo: " + fchDesde + " - " + fchHasta;
			break;
		}
		case "balancepyg08": {
			qCondiciones.setTablesList("co_i_cuentasanuales");
			qCondiciones.setFrom("co_i_cuentasanuales");
			qCondiciones.setSelect("descripcion,i_co__subcuentas_codejercicioact,d_co__asientos_fechaact,h_co__asientos_fechaact");

			if (!qCondiciones.exec())
				return "";
			if (!qCondiciones.first())
				return "";

			desc = qCondiciones.value(0);
			ejAct = qCondiciones.value(1);
			fchDesde = qCondiciones.value(2).toString().left(10);
			fchHasta = qCondiciones.value(3).toString().left(10);
			fchDesde = util.dateAMDtoDMA(fchDesde);
			fchHasta = util.dateAMDtoDMA(fchHasta);

			texto = "[ " + desc + " ]" + sep + "Ejercicio " + ejAct + " | Periodo: " + fchDesde + " - " + fchHasta;
			break;
		}
		default: {
			return this.iface.__cabeceraInforme(nodo, campo);
		}
	}

	if (!texto)
		texto = "";

	return texto;
}

//// DIGIT_CONTABLE /////////////////////////////////////////////
//////////////////////////////////////////////////////////////

