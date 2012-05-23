
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
    function funNumSerie( context ) { oficial( context ); }
	function init() {
		this.ctx.funNumSerie_init();
	}
	function bufferChanged(fN:String) {
		this.ctx.funNumSerie_bufferChanged(fN);
	}
	function validateForm():Boolean {
		return this.ctx.funNumSerie_validateForm();
	}
	function refrescarStock() {
		this.ctx.funNumSerie_refrescarStock();
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

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	switch (cursor.modeAccess()) {
		case cursor.Edit: {
			this.child("fdbNumSerie").setDisabled(true);
			if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'"))
				this.child("fdbCantidad").setDisabled(true);
			break;
		}
	}
}

function funNumSerie_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	switch (fN) {
		case "referencia": {
			if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'")) {
				this.child("fdbCantidad").setDisabled(false);
				this.child("fdbNumSerie").setValue("");
				this.child("fdbNumSerie").setDisabled(true);
			} else {
				cursor.setValueBuffer("cantidad", 1);
				this.child("fdbCantidad").setDisabled(true);
				this.child("fdbNumSerie").setDisabled(false);
			}
			this.iface.__bufferChanged(fN);
			break;
		}
		case "numserie": {
			this.iface.refrescarStock();
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}

function funNumSerie_validateForm():Boolean
{
	if (!this.iface.__validateForm())
		return false;

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + cursor.valueBuffer("referencia") + "'"))
		return true;

	var numSerie:String = cursor.valueBuffer("numserie");
	if (!numSerie) {
		MessageBox.warning(util.translate("scripts", "Debe ingresar el número de serie del artículo."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (!util.sqlSelect("numerosserie", "id", "numserie = '" + numSerie + "' AND referencia = '" + cursor.valueBuffer("referencia") + "'")) {
		MessageBox.warning(util.translate("scripts", "El número de serie y el artículo especificados no coinciden"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if ( util.sqlSelect("numerosserie", "codalmacen", "numserie = '" + numSerie + "' AND referencia = '" + cursor.valueBuffer("referencia") + "'") != cursor.cursorRelation().valueBuffer("codalmaorigen")) {
		MessageBox.warning(util.translate("scripts", "El número de serie no pertenece al almacén origen"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if ( util.sqlSelect("numerosserie", "vendido", "numserie = '" + numSerie + "' AND referencia = '" + cursor.valueBuffer("referencia") + "'")) {
		MessageBox.warning(util.translate("scripts", "El número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return true;
}

/** \D Muestra las cantidades inicial y final para los almacenes de origen y destino
\end */
function funNumSerie_refrescarStock()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codAlmaOrigen:String = cursor.cursorRelation().valueBuffer("codalmaorigen");
	var codAlmaDestino:String = cursor.cursorRelation().valueBuffer("codalmadestino");
	this.child("lblAlmacenOrigen").text = util.translate("scripts", "Almacén origen (%1)").arg(codAlmaOrigen);
	this.child("lblAlmacenDestino").text = util.translate("scripts", "Almacén destino (%1)").arg(codAlmaDestino);
	
	var referencia:String = cursor.valueBuffer("referencia");
	if (!referencia || referencia == "") {
		this.child("lblCanInicialOrigen").text = "-";
		this.child("lblCanFinalOrigen").text = "-";
		this.child("lblCanInicialDestino").text = "-";
		this.child("lblCanFinalDestino").text = "-";
		return;
	}

	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + referencia + "'"))
		return this.iface.__refrescarStock();

	var cantidad:Number = parseFloat(cursor.valueBuffer("cantidad"));
	if (!cantidad || cantidad== "") {
		cantidad = 0;
	}

	var cantidadOrigen:Number = util.sqlSelect("numerosserie", "COUNT(*)", "codalmacen = '" + codAlmaOrigen + "' AND referencia = '" + referencia + "'");
	if (!cantidadOrigen || isNaN(cantidadOrigen))
		cantidadOrigen = 0;
	cantidadOrigen += parseFloat(this.iface.canPrevia);
 
	this.child("lblCanInicialOrigen").text = cantidadOrigen;
	this.child("lblCanFinalOrigen").text = cantidadOrigen - cantidad;

	var cantidadDestino:Number = util.sqlSelect("numerosserie", "COUNT(*)", "codalmacen = '" + codAlmaDestino + "' AND referencia = '" + referencia + "'");
	if (!cantidadDestino || isNaN(cantidadDestino))
		cantidadDestino = 0;
	cantidadDestino -= parseFloat(this.iface.canPrevia);

	this.child("lblCanInicialDestino").text = cantidadDestino;
	this.child("lblCanFinalDestino").text = cantidadDestino + cantidad;
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

