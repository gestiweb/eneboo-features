
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial {
    function barCode( context ) { oficial ( context ); }
    function init() {
		return this.ctx.barCode_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.barCode_bufferChanged(fN);
	}
	function calculateField(fN:String):String {
		return this.ctx.barCode_calculateField(fN);
	}
	function refrescarStock() {
		return this.ctx.barCode_refrescarStock();
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
		this.child("fdbBarCode").setFilter("");
	else
		this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");

	switch (cursor.modeAccess()) {
		case cursor.Edit: {
			this.child("fdbBarCode").setDisabled(true);
			break;
		}
	}
}

function barCode_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "barcode": {
			this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
			this.iface.refrescarStock();
			break;
		}
		case "referencia": {
			if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
				this.child("fdbBarCode").setFilter("");
			else
				this.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
			this.iface.__bufferChanged(fN);
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}

function barCode_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "referencia": {
			valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN);
		}
	}
	return valor;
}

/** \D Muestra las cantidades inicial y final para los almacenes de origen y destino
\end */
function barCode_refrescarStock()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var codAlmaOrigen:String = cursor.cursorRelation().valueBuffer("codalmaorigen");
	var codAlmaDestino:String = cursor.cursorRelation().valueBuffer("codalmadestino");
	this.child("lblAlmacenOrigen").text = util.translate("scripts", "Almacén origen (%1)").arg(codAlmaOrigen);
	this.child("lblAlmacenDestino").text = util.translate("scripts", "Almacén destino (%1)").arg(codAlmaDestino);
		
	var barCode:String = cursor.valueBuffer("barcode");
	if (!barCode || barCode == "") {
		var referencia:String = cursor.valueBuffer("referencia");
		if (referencia && referencia != "") {
			if (util.sqlSelect("articulos", "referencia", "referencia = '" + referencia + "'") && !util.sqlSelect("atributosarticulos", "referencia", "referencia = '" + referencia + "'"))
			this.iface.__refrescarStock();
		} else {
			this.child("lblCanInicialOrigen").text = "-";
			this.child("lblCanFinalOrigen").text = "-";
			this.child("lblCanInicialDestino").text = "-";
			this.child("lblCanFinalDestino").text = "-";
		}
		return;
	}

	var cantidad:Number = parseFloat(cursor.valueBuffer("cantidad"));
	if (!cantidad || cantidad== "") {
		cantidad = 0;
	}

	var cantidadOrigen:Number = util.sqlSelect("stocks", "cantidad", "codalmacen = '" + codAlmaOrigen + "' AND barcode = '" + barCode + "'");
	if (!cantidadOrigen || isNaN(cantidadOrigen))
		cantidadOrigen = 0;
	cantidadOrigen += parseFloat(this.iface.canPrevia);
 
	this.child("lblCanInicialOrigen").text = cantidadOrigen;
	this.child("lblCanFinalOrigen").text = cantidadOrigen - cantidad;

	var cantidadDestino:Number = util.sqlSelect("stocks", "cantidad", "codalmacen = '" + codAlmaDestino + "' AND barcode = '" + barCode + "'");
	if (!cantidadDestino || isNaN(cantidadDestino))
		cantidadDestino = 0;
	cantidadDestino -= parseFloat(this.iface.canPrevia);

	this.child("lblCanInicialDestino").text = cantidadDestino;
	this.child("lblCanFinalDestino").text = cantidadDestino + cantidad;
}

//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////
