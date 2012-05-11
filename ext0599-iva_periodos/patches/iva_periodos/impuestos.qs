
/** @class_declaration cambioIva */
/////////////////////////////////////////////////////////////////
//// CAMBIO_IVA /////////////////////////////////////////////////
class cambioIva extends oficial /** %from: oficial */ {
    function cambioIva( context ) { oficial ( context ); }
	function init() {
		return this.ctx.cambioIva_init();
	}
	function calcularValores() {
		return this.ctx.cambioIva_calcularValores();
	}
	function validateForm():Boolean {
		return this.ctx.cambioIva_validateForm();
	}
	function comprobarFechasPeriodos():Boolean {
		return this.ctx.cambioIva_comprobarFechasPeriodos();
	}
}
//// CAMBIO_IVA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition cambioIva */
/////////////////////////////////////////////////////////////////
//// CAMBIO_IVA /////////////////////////////////////////////////
function cambioIva_init():Boolean
{
	connect(this.child("tdbPeriodos").cursor(), "bufferCommited()", this, "iface.calcularValores");
}

function cambioIva_validateForm():Boolean
{
	if (!this.iface.__validateForm()) {
		return false;
	}

	if (!this.iface.comprobarFechasPeriodos()) {
		return false;
	}

	return true;
}

function cambioIva_calcularValores()
{
	var cursor:FLSqlCursor = this.cursor();
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("periodos");
	qry.setSelect("iva,recargo");
	qry.setFrom("periodos");
	qry.setWhere("codimpuesto = '" + cursor.valueBuffer("codimpuesto") + "' ORDER BY fechadesde DESC");
	try { qry.setForwardOnly( true ); } catch (e) {}
	if (!qry.exec()){
	   return false;
	}
	if (qry.first()) {
		this.child("fdbIva").setValue(qry.value("iva"));
		this.child("fdbRecargo").setValue(qry.value("recargo"));
	} else {
		this.child("fdbIva").setValue(0);
		this.child("fdbRecargo").setValue(0);
	}
}

function cambioIva_comprobarFechasPeriodos():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("periodos");
	qry.setSelect("fechadesde,fechahasta");
	qry.setFrom("periodos");
	qry.setWhere("codimpuesto = '" + cursor.valueBuffer("codimpuesto") + "'");
	try { qry.setForwardOnly( true ); } catch (e) {}
	if (!qry.exec()){
	   return false;
	}
	var fechaFinAnterior:String;
	var iva:Number;
	var recargo:Number;
	while (qry.next()) {
		if (!fechaFinAnterior) {
			fechaFinAnterior = qry.value("fechahasta");
			continue;
		}
		if (qry.value("fechadesde") != util.addDays(fechaFinAnterior, 1)) {
			MessageBox.information(util.translate("scripts", "La fecha de inicio de un periodo debe ser el día siguiente de la fecha fin del periodo anterior"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		fechaFinAnterior = qry.value("fechahasta");
	}

	return true;
}

//// CAMBIO_IVA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

