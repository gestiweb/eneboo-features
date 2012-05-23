
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	function funNumSerie( context ) { oficial( context ); }
	function init() {
		return this.ctx.funNumSerie_init();
	}
	function validateForm():Boolean {
	              return this.ctx.funNumSerie_validateForm();
	}
	function bufferChanged(fN:String) {
		return this.ctx.funNumSerie_bufferChanged(fN);
	}
	function controlCantidad(cantidadAuno:Boolean) {
		return this.ctx.funNumSerie_controlCantidad(cantidadAuno);
	}
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
function funNumSerie_init()
{
	this.iface.__init();
	
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Edit)
		this.iface.controlCantidad(true);
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
	
	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'")) {
		if (cantidadAuno) 
			cursor.setValueBuffer("cantidad", 1);
		this.child("fdbCantidad").setDisabled(true);
		this.child("fdbNumSerie").setDisabled(false);
	}
	else {
		this.child("fdbCantidad").setDisabled(false);
		this.child("fdbNumSerie").setDisabled(true);
	}
}

function funNumSerie_validateForm():Boolean
{
	if (!this.cursor().valueBuffer("numserie"))
		return true;

	var util:FLUtil = new FLUtil();
//	var idFactura:String = this.cursor().cursorRelation().valueBuffer("iddocumento");
	if (// Si existe un número de serie que no es de este remito
		util.sqlSelect("numerosserie", "id", 
			"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
			" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
//			" AND idfacturaventa <> " + idFactura +
			" AND vendido = 'true'")
		// Salvo que sea otra línea de este mismo remito
		|| util.sqlSelect("tpv_lineascomanda", "idtpv_linea", 
			"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
			" AND idtpv_linea <> " + this.cursor().valueBuffer("idtpv_linea")))
	{
		MessageBox.warning(util.translate("scripts", "Este número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	return true;
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////

