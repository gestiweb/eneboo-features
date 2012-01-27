
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial /** %from: oficial */ {
    function barCode( context ) { oficial ( context ); }
	function init() {
		this.ctx.barCode_init();
	}
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.barCode_commonBufferChanged(fN, miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.barCode_commonCalculateField(fN, cursor);
	}
	function datosTablaPadre(cursor:FLSqlCursor):Array {
		return this.ctx.barCode_datosTablaPadre(cursor);
	}
	function validateForm():Boolean {
		return this.ctx.barCode_validateForm();
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends barCode /** %from: barCode */ {
    function rappel( context ) { barCode ( context ); }
	function init() {
		return this.ctx.rappel_init();
	}
	function commonBufferChanged(fN:String, miForm:Object) {
		return this.ctx.rappel_commonBufferChanged(fN, miForm);
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.rappel_commonCalculateField(fN, cursor);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
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
}

function barCode_commonBufferChanged(fN:String, miForm:Object)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = miForm.cursor();
	switch (fN) {
		case "barcode": {
			miForm.child("fdbReferencia").setValue(this.iface.commonCalculateField("referencia", cursor));
			miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", cursor));
			break;
		}
		case "referencia": {
			if (cursor.valueBuffer("referencia") == "" || cursor.isNull("referencia"))
				miForm.child("fdbBarCode").setFilter("");
			else
				miForm.child("fdbBarCode").setFilter("referencia = '" + cursor.valueBuffer("referencia") + "'");
			this.iface.__commonBufferChanged(fN, miForm);
			break;
		}
		default: {
			this.iface.__commonBufferChanged(fN, miForm);
		}
	}
}

function barCode_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	var datosTP:Array = this.iface.datosTablaPadre(cursor);
	if (!datosTP)
		return false;
	var wherePadre:String = datosTP.where;
	var tablaPadre:String = datosTP.tabla;

	switch (fN) {
		case "referencia": {
			valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
			break;
		}
		case "pvpunitario": {
			var codProveedor:String = util.sqlSelect(tablaPadre, "codproveedor", wherePadre);
			var codDivisa:String = util.sqlSelect(tablaPadre, "coddivisa", wherePadre);
			var qryBarcode:FLSqlQuery = new FLSqlQuery();
			with (qryBarcode) {
				setTablesList("barcodeprov");
				setSelect("coste");
				setFrom("barcodeprov");
				setWhere("barcode = '" + cursor.valueBuffer("barcode") + "' AND codproveedor = '" + codProveedor + "' AND coddivisa = '" + codDivisa + "'");
				setForwardOnly(true);
			}
			if (!qryBarcode.exec())
				return false;

			if (!qryBarcode.first())
				valor = this.iface.__commonCalculateField(fN, cursor);
			else {
				valor = qryBarcode.value("coste");
				var tasaConv:Number = util.sqlSelect(tablaPadre, "tasaconv", wherePadre);
				valor = parseFloat(valor) / tasaConv;
			}
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
		}

	}
	return valor;
}

/** \D Devuelve la tabla padre de la tabla parámetro, así como la cláusula where necesaria para localizar el registro padre
@param	cursor: Cursor cuyo padre se busca
@return	Array formado por:
	* where: Cláusula where
	* tabla: Nombre de la tabla padre
o false si hay error
\end */
function barCode_datosTablaPadre(cursor:FLSqlCursor):Array
{
	var datos:Array;
	switch (cursor.table()) {
		case "lineastallacol": {
			datos.where  = cursor.valueBuffer("campopadre") + " = " + cursor.valueBuffer("valorcampopadre");
			switch (cursor.valueBuffer("tabla")) {
				case "lineaspedidosprov": {
					datos.tabla = "pedidosprov";
					break;
				}
				case "lineasalbaranesprov": {
					datos.tabla = "albaranesprov";
					break;
				}
				case "lineasfacturasprov": {
					datos.tabla = "facturasprov";
					break;
				}
			}
			var qryDatos:FLSqlQuery = new FLSqlQuery;
			qryDatos.setTablesList(datos.tabla);
			qryDatos.setSelect("coddivisa, codproveedor, fecha");
			qryDatos.setFrom(datos.tabla);
			qryDatos.setWhere(datos.where);
			qryDatos.setForwardOnly(true);
			if (!qryDatos.exec()) {
				return false;
			}
			if (!qryDatos.first()) {
				return false;
			}
			datos["coddivisa"] = qryDatos.value("coddivisa");
			datos["codproveedor"] = qryDatos.value("codproveedor");
			datos["fecha"] = qryDatos.value("fecha");
			break;
		}
		default: {
			datos = this.iface.__datosTablaPadre(cursor);
		}
	}
	return datos;
}

function barCode_validateForm():Boolean
{
	if (!this.iface.__validateForm())
		return false;

	var cursor:FLSqlCursor = this.cursor();

	if (!flfacturac.iface.pub_validarLinea(cursor))
		return false;

	return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_init()
{
	this.iface.__init();
	this.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", this.cursor()));
}

function rappel_commonBufferChanged(fN:String, miForm:Object)
{
	var util:FLUtil = new FLUtil();
	switch (fN) {
		case "referencia":
			miForm.child("fdbPvpUnitario").setValue(this.iface.commonCalculateField("pvpunitario", miForm.cursor()));
			var serie:String = miForm.cursor().cursorRelation().valueBuffer("codserie");
			var sinIva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
			if(sinIva == false)
				miForm.child("fdbCodImpuesto").setValue(this.iface.commonCalculateField("codimpuesto", miForm.cursor()));
			miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
			break;
		case "dtorappel":
			miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
			break;
		case "cantidad":
			miForm.child("fdbPvpSinDto").setValue(this.iface.commonCalculateField("pvpsindto", miForm.cursor()));
			miForm.child("fdbDtoRappel").setValue(this.iface.commonCalculateField("dtorappel", miForm.cursor()));
			break;
		case "pvpsindto":
			miForm.child("fdbPvpTotal").setValue(this.iface.commonCalculateField("pvptotal", miForm.cursor()));
			miForm.child("lblDtoPor").setText(this.iface.commonCalculateField("lbldtopor", miForm.cursor()));
			miForm.child("lblDtoRappel").setText(this.iface.commonCalculateField("lbldtorappel", miForm.cursor()));
			break;
		default:
			this.iface.__commonBufferChanged(fN, miForm);
			break;
	}
}

function rappel_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var datosTP:Array = this.iface.datosTablaPadre(cursor);
	if (!datosTP)
		return false;
	var wherePadre:String = datosTP.where;
	var tablaPadre:String = datosTP.tabla;

	var valor:String;
	switch (fN) {
		case "dtorappel":
			var cantidad:String = cursor.valueBuffer("cantidad");
			cantidad = parseFloat(cantidad);
			if (!cantidad || cantidad < 0) {
				valor = 0;
				break;
			}
			var codProveedor:String = util.sqlSelect(tablaPadre, "codproveedor", wherePadre);
			var referencia:String = cursor.valueBuffer("referencia");
			valor = flfactppal.iface.pub_valorQuery( "articulosprov,rappelprovart", "descuento", "articulosprov inner join rappelprovart on articulosprov.id = rappelprovart.id", "articulosprov.referencia = '" + referencia + "' AND articulosprov.codproveedor = '" + codProveedor + "' AND limiteinferior <= " + cantidad + " AND limitesuperior >= " + cantidad );
			if (!valor)
				valor = 0;
			break;
		case "lbldtorappel":
			valor = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
			break;
		case "pvptotal":
			var dtoPor:Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtopor"))) / 100;
			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidosprov", "pvpsindto");
			var dtoRappel:Number = (parseFloat(cursor.valueBuffer("pvpsindto")) * parseFloat(cursor.valueBuffer("dtorappel"))) / 100;
			dtoRappel = util.roundFieldValue(dtoRappel, "lineaspedidosprov", "pvpsindto");
			valor = parseFloat(cursor.valueBuffer("pvpsindto")) - dtoPor - parseFloat(cursor.valueBuffer("dtolineal")) - dtoRappel;
			break;
		default:
			valor = this.iface.__commonCalculateField(fN, cursor);
			break;
	}
	return valor;
}

//// RAPPEL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

