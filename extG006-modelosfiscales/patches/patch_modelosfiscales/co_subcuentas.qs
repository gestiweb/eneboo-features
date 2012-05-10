
/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends oficial /** %from: oficial */ {
    function modelo303( context ) { oficial ( context ); }
	function habilitarIVA() {
		return this.ctx.modelo303_habilitarIVA();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_habilitarIVA()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	this.iface.__habilitarIVA();

	if (util.sqlSelect("co_cuentas", "idcuentaesp",
			"idcuenta = '" + cursor.valueBuffer("idcuenta") + "'" +
			" AND (idcuentaesp = 'IVASOP' OR idcuentaesp = 'IVAREP')")) {
			this.child("fdbCasilla303").setDisabled(false);
			return;
	}

	this.child("fdbCasilla303").setValue("");
	this.child("fdbCasilla303").setDisabled(true);
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

