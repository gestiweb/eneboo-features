
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	var numSerie:String;
	function funNumSerie( context ) { oficial( context ); } 	
	function init() { return this.ctx.funNumSerie_init(); }
	function validateForm() { return this.ctx.funNumSerie_validateForm(); }
	function bufferChanged(fN:String) { return this.ctx.funNumSerie_bufferChanged(fN); }
	function controlCantidad(cantidadAuno:Boolean) { return this.ctx.funNumSerie_controlCantidad(cantidadAuno); }
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

function funNumSerie_init()
{
// 	this.iface.__init();
	
	var cursor:FLSqlCursor = this.cursor();

	this.child("tbwLinea").setTabEnabled("numserie", false);
	if (cursor.modeAccess() == cursor.Edit) {
		this.iface.controlCantidad(true);
		if (cursor.valueBuffer("numserie"))
			this.child("fdbNumSerie").setDisabled(true);
		this.child("fdbReferencia").setDisabled(true);
	}

	this.iface.numSerie = cursor.valueBuffer("numserie");

	this.iface.__init();
}

function funNumSerie_bufferChanged(fN:String)
{
	switch (fN) {
		case "referencia":
			this.iface.controlCantidad(true);
		break;
	}
	
	return this.iface.__bufferChanged(fN);
}

function funNumSerie_controlCantidad(cantidadAuno:Boolean)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	/* Por defecto habilitamos campo cantidad. Si se controla por número de serie (o por lotes, en la clase extendida), deshabilitamos */
	this.child("fdbCantidad").setDisabled(false);

	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'")) {
		if (cantidadAuno) 
			cursor.setValueBuffer("cantidad", 1);
		this.child("fdbCantidad").setDisabled(true);
		this.child("tbwLinea").setTabEnabled("numserie", true);
		this.child("fdbNumSerie").setDisabled(false);
	}
	else {
// 		this.child("fdbCantidad").setDisabled(false);
		this.child("fdbNumSerie").setDisabled(true);
		this.child("tbwLinea").setTabEnabled("numserie", false);
	}
}

/** \D Controla que el número de serie no está duplicado, sólamente cuando no ha cambiado en la
edición
*/
function funNumSerie_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	if (this.iface.numSerie != cursor.valueBuffer("numserie")) {
	
		switch(cursor.modeAccess()) {
			
			case cursor.Insert:
			case cursor.Edit:
				var util:FLUtil = new FLUtil;
				if (util.sqlSelect("numerosserie", "numserie", "referencia = '" + cursor.valueBuffer("referencia") + "' AND numserie = '" + cursor.valueBuffer("numserie") + "'")) {
					MessageBox.warning(util.translate("scripts", "Este número de serie ya existe para el artículo ") + cursor.valueBuffer("referencia"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
					return false;
				}
				break;
		}
	}

	return this.iface.__validateForm();
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
