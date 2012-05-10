
/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends oficial /** %from: oficial */ {
    function modelo303( context ) { oficial ( context ); }
	function habilitarIVA(siOno:String) {
		return this.ctx.modelo303_habilitarIVA(siOno);
	}
	function validateForm():Boolean {
		return this.ctx.modelo303_validateForm();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_habilitarIVA(siOno)
{
debug("modelo303_habilitarIVA " + siOno);
	this.iface.__habilitarIVA(siOno);

	var util:FLUtil;

	switch(siOno) {
		case "si": {
			this.child("tbwPartida").setTabEnabled("modelo303", true);
			break;
		}
		case "no": {
			this.child("tbwPartida").setTabEnabled("modelo303", false);
			this.child("fdbCasilla303").setValue("");
			break;
		}
	}
}

function modelo303_validateForm():Boolean
{
	if (!this.iface.__validateForm()) {
		return false;
	}

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var casilla303:String = cursor.valueBuffer("casilla303");
	if (this.iface.idCuentaEsp == "IVASOP" || this.iface.idCuentaEsp == "IVAREP") {
		if (!casilla303 || casilla303 == "") {
			var res:Number = MessageBox.warning(util.translate("scripts", "Ha introducido una partida de IVA.¿Desea indicar la casilla asociada al modelo 303?"), MessageBox.Yes, MessageBox.No);
			if (res == MessageBox.Yes) {
				return false;
			}
		}
	}
	return true;
}

//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

