
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	function funNumSerie( context ) { oficial( context ); } 	
	function init() { return this.ctx.funNumSerie_init(); }
	function validateForm():Boolean { return this.ctx.funNumSerie_validateForm(); }
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
	if (cursor.modeAccess() == cursor.Edit)
		this.iface.controlCantidad(true);

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
	// agregamos el control de artículos por lotes aquí, para unificar el funcionamiento
//	else if (util.sqlSelect("articulos", "porlotes", "referencia = '" + cursor.valueBuffer("referencia") + "'")) {
//		this.child("fdbCantidad").setDisabled(true);
//	}
	else {
// 		this.child("fdbCantidad").setDisabled(false);
		this.child("tbwLinea").setTabEnabled("numserie", false);
		this.child("fdbNumSerie").setDisabled(true);
	}
}

function funNumSerie_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();

	if (this.cursor().valueBuffer("numserie")) {
	
		// Si es factura de abono se permite sólo la devolución
		if (this.cursor().cursorRelation().valueBuffer("decredito")) {
			if (// Si existe el número de serie no vendido
				util.sqlSelect("numerosserie", "id", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND vendido = false")
				// Salvo que sea otra línea de esta misma factura
				|| util.sqlSelect("lineasfacturascli", "idlinea", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND idfactura = '" +	this.cursor().valueBuffer("idfactura") + "'" +
					" AND idlinea <> " + this.cursor().valueBuffer("idlinea")))
			{
				MessageBox.warning(util.translate("scripts", "En notas de crédito sólo pueden incluirse números de serie previamente vendidos"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}
		
		else {
			if (// Si existe un número de serie que no es de esta factura
				util.sqlSelect("numerosserie", "id", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND idfacturaventa <> " + this.cursor().valueBuffer("idfactura") +
					" AND vendido = 'true'")
				// Salvo que sea otra línea de esta misma factura
				|| util.sqlSelect("lineasfacturascli", "idlinea", 
					"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
					" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
					" AND idfactura = '" +	this.cursor().valueBuffer("idfactura") + "'" +
					" AND idlinea <> " + this.cursor().valueBuffer("idlinea")))
			{
				MessageBox.warning(util.translate("scripts", "Este número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}
	}
	
	return this.iface.__validateForm();
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

