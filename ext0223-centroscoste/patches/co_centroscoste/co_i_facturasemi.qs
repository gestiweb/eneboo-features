
/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends oficial /** %from: oficial */
{
	function centrosCoste( context ) { oficial( context ); }
    function init() { this.ctx.centrosCoste_init(); }

	function agregarCentro():Boolean {
		return this.ctx.centrosCoste_agregarCentro();
	}
	function eliminarCentro() {
		return this.ctx.centrosCoste_eliminarCentro();
	}
	function eliminarTodosCentro() {
		return this.ctx.centrosCoste_eliminarTodosCentro();
	}
	function agregarSubcentro():Boolean {
		return this.ctx.centrosCoste_agregarSubcentro();
	}
	function eliminarSubcentro() {
		return this.ctx.centrosCoste_eliminarSubcentro();
	}
	function eliminarTodosSubcentro() {
		return this.ctx.centrosCoste_eliminarTodosSubcentro();
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

	connect(this.child("tbInsertC"), "clicked()", this, "iface.agregarCentro");
	connect(this.child("tbDeleteC"), "clicked()", this, "iface.eliminarCentro");
	connect(this.child("pbnQuitarTodosC"), "clicked()", this, "iface.eliminarTodosCentro");
	connect(this.child("tbInsertSC"), "clicked()", this, "iface.agregarSubcentro");
	connect(this.child("tbDeleteSC"), "clicked()", this, "iface.eliminarSubcentro");
	connect(this.child("pbnQuitarTodosSC"), "clicked()", this, "iface.eliminarTodosSubcentro");
}

function centrosCoste_agregarCentro():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		var curP:FLSqlCursor = this.child("tdbCentros").cursor();
		curP.setModeAccess(curP.Insert);
		curP.commitBufferCursorRelation();
	}

	flcontinfo.iface.agregarCentro(cursor, "facturasemi");
	this.child("tdbCentros").refresh();
}

function centrosCoste_eliminarCentro()
{
	if (!this.child("tdbCentros").cursor().isValid())
		return;

	var codCentro:String = this.child("tdbCentros").cursor().valueBuffer("codcentro");
	flcontinfo.iface.eliminarCentro(this.cursor(), codCentro, "facturasemi");

	this.child("tdbCentros").refresh();
	this.child("tdbSubcentros").refresh();
}

function centrosCoste_eliminarTodosCentro()
{
	var util:FLUtil = new FLUtil();
	var res = MessageBox.warning( util.translate( "scripts", "Se quitarán todos los centros y sus subcentros\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes )
		return;

	flcontinfo.iface.eliminarCentro(this.cursor(), "", "facturasemi");

	this.child("tdbCentros").refresh();
	this.child("tdbSubcentros").refresh();
}

function centrosCoste_agregarSubcentro():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		var curP:FLSqlCursor = this.child("tdbSubcentros").cursor();
		curP.setModeAccess(curP.Insert);
		curP.commitBufferCursorRelation();
	}

	flcontinfo.iface.agregarSubcentro(cursor, "facturasemi");
	this.child("tdbSubcentros").refresh();
}

function centrosCoste_eliminarSubcentro()
{
	if (!this.child("tdbSubcentros").cursor().isValid())
		return;

	var codSubcentro:String = this.child("tdbSubcentros").cursor().valueBuffer("codsubcentro");

	flcontinfo.iface.eliminarSubcentro(this.cursor(), codSubcentro, "facturasemi");

	this.child("tdbSubcentros").refresh();
}

function centrosCoste_eliminarTodosSubcentro()
{
	var util:FLUtil = new FLUtil();
	var res = MessageBox.warning( util.translate( "scripts", "Se quitarán todos los subcentros\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes )
		return;

	flcontinfo.iface.eliminarSubcentro(this.cursor(), "", "facturasemi");

	this.child("tdbSubcentros").refresh();
}

//// CENTROS COSTE /////////////////////////////////////////////
////////////////////////////////////////////////////////////////

