
/** @class_declaration modelos */
/////////////////////////////////////////////////////////////////
//// MODELOS FISCALES ///////////////////////////////////////////
class modelos extends oficial /** %from: oficial */ {
    function modelos( context ) { oficial ( context ); }
	function init() {
		return this.ctx.modelos_init();
	}
	function habilitarPestanaModelos() {
		return this.ctx.modelos_habilitarPestanaModelos();
	}
}
//// MODELOS FISCALES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends modelos /** %from: modelos */ {
    function modelo347( context ) { modelos ( context ); }
	function init() {
		return this.ctx.modelo347_init();
	}
	function habilitarPestanaModelos() {
		return this.ctx.modelo347_habilitarPestanaModelos();
	}
	function bufferChanged(fN:String) {
		return this.ctx.modelo347_bufferChanged(fN);
	}
	function bufferChanged(fN:String) {
		return this.ctx.modelo347_bufferChanged(fN);
	}
	function habilitar347() {
		return this.ctx.modelo347_habilitar347();
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelos */
/////////////////////////////////////////////////////////////////
//// MODELOS FISCALES ///////////////////////////////////////////
function modelos_init()
{
	this.iface.__init();
	this.iface.habilitarPestanaModelos();
}

function modelos_habilitarPestanaModelos()
{
	this.child("tbwAsiento").setTabEnabled("modelos", false);
}
//// MODELOS FISCALES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_init()
{
	this.iface.__init();
	this.iface.habilitar347();
}

function modelo347_habilitarPestanaModelos()
{
	return true;
}

function modelo347_bufferChanged(fN:String)
{
	switch (fN) {
		case "tipodocumento": {
			this.iface.habilitar347();
			this.iface.__bufferChanged(fN);
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
			break;
		}
	}
}

function modelo347_habilitar347()
{
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.valueBuffer("tipodocumento")) {
		case "Factura de cliente":
		case "Factura de proveedor": {
			this.child("fdbNoModelo347").setDisabled(false);
			break;
		}
		default: {
			this.child("fdbNoModelo347").setDisabled(true);
			break;
		}
	}
}
//// MODELO 347 /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

