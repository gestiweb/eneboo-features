
/** @class_declaration cambioIva */
/////////////////////////////////////////////////////////////////
//// CAMBIO IVA /////////////////////////////////////////////////
class cambioIva extends oficial {
    function cambioIva( context ) { oficial ( context ); }
    function validateForm():Boolean {
		return this.ctx.cambioIva_validateForm();
	}
}
//// CAMBIO IVA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition cambioIva */
//////////////////////////////////////////////////////////////////
//// CAMBIO IVA //////////////////////////////////////////////////
function cambioIva_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (!this.iface.__validateForm()) {
		return false;
	}
	var valIva:Number = flfacturac.iface.pub_validarIvas(cursor);
	switch (valIva) {
		case 1: {
			this.iface.calcularTotales();
			MessageBox.information(util.translate("scripts", "Valores de IVA y totales actualizados. Verifíquelos y guarde el formulario"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		case -1: {
			return false;
		}
	}

	return true;
}
//// CAMBIO IVA //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

