
/** @class_declaration traspasoSubcta */
/////////////////////////////////////////////////////////////////
//// TRASPASO SUBCUENTA ///////////////////////////////////////////////
class traspasoSubcta extends oficial /** %from: oficial */ {
    function traspasoSubcta( context ) { oficial ( context ); }
	function init() { this.ctx.traspasoSubcta_init(); }
	function traspasarScta() { return this.ctx.traspasoSubcta_traspasarScta() }
}
//// TRASPASO SUBCUENTA ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition traspasoSubcta */
//////////////////////////////////////////////////////////////////
//// TRASPASO SUBCUENTA ////////////////////////////////////////////////

function traspasoSubcta_init()
{
	connect(this.child("pbnTraspaso"), "clicked()", this, "iface.traspasarScta");
	this.iface.__init();
}

function traspasoSubcta_traspasarScta()
{
	var f = new FLFormSearchDB("co_traspasosubcta");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
					commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
					cursor.commit();
					commitOk = true;
			}
		}
		f.close();
	}

	this.iface.tdbRecords.refresh();
}

//// TRASPASO SUBCUENTA ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

