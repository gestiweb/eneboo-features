
/** @class_declaration liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES //////////////////////////////////////////////////
class liqAgentes extends oficial /** %from: oficial */ {
	function liqAgentes( context ) { oficial( context ); }
	function validateForm():Boolean {
		return this.ctx.liqAgentes_validateForm();
	}
}
//// LIQAGENTES ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
//////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////////
function liqAgentes_validateForm():Boolean
{
	if (!this.iface.__validateForm()) {
		return false;
	}

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var codLiquidacion:String = cursor.valueBuffer("codliquidacion");
	if(cursor.modeAccess() == cursor.Edit && codLiquidacion){
		var res:Number =MessageBox.warning(util.translate("scripts", "La factura que intenta modificar pertenece a la liquidación ") + codLiquidacion + util.translate("scripts", "\n¿Desea continuar?"),MessageBox.Yes, MessageBox.No,MessageBox.NoButton);
		if(res != MessageBox.Yes)
			return false;

		var curLiq:FLSqlCursor = new FLSqlCursor("liquidaciones");
		curLiq.select("codliquidacion = '" + cursor.valueBuffer("codliquidacion") + "'");
		if (!curLiq.first())
			return false;

		curLiq.setModeAccess(curLiq.Edit);
		curLiq.refreshBuffer();
		curLiq.setValueBuffer("total", formRecordliquidaciones.iface.pub_commonCalculateField("total", curLiq));
		if (!curLiq.commitBuffer())
			return false;
	}

	return true;

}

//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

