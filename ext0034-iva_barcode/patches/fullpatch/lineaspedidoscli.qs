
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends ivaIncluido {
    function barCode( context ) { ivaIncluido ( context ); }
    function init() {
		return this.ctx.barCode_init();
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

		case "referencia":
			valor = util.sqlSelect("atributosarticulos", "referencia", "barcode = '" + cursor.valueBuffer("barcode") + "'");
		break;

		case "pvpunitario":

			var codCliente:String = util.sqlSelect(tablaPadre, "codcliente", wherePadre);
			var barcode:String = cursor.valueBuffer("barcode");
			var referencia:String = cursor.valueBuffer("referencia");
			var codTarifa:String = this.iface.obtenerTarifa(codCliente, cursor);
			var tasaConv:Number = util.sqlSelect(tablaPadre, "tasaconv", wherePadre);

			// 1. Barcode con tarifa?
			if (codTarifa)
				valor = util.sqlSelect("atributostarifas", "pvp", "barcode = '" + barcode + "' AND codtarifa = '" + codTarifa + "'");

			// 2. Barcode con precio especial?
			if (!valor) {
				var qryBarcode:FLSqlQuery = new FLSqlQuery();
				with (qryBarcode) {
					setTablesList("atributosarticulos");
					setSelect("pvp");
					setFrom("atributosarticulos");
					setWhere("pvpespecial = true AND barcode = '" + barcode + "'");
					setForwardOnly(true);
				}
				if (!qryBarcode.exec())
					return false;

				// 3. Precio normal del artículo
				if (!qryBarcode.first())
					return this.iface.__commonCalculateField(fN, cursor);
				else {
					valor = qryBarcode.value("pvp");
				}
			}

			valor = parseFloat(valor) / tasaConv;

		break;

		default:
			valor = this.iface.__commonCalculateField(fN, cursor);

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
		case "lineastallacolcli": {
			datos.where  = cursor.valueBuffer("campopadre") + " = " + cursor.valueBuffer("valorcampopadre");
			switch (cursor.valueBuffer("tabla")) {
				case "lineaspresupuestoscli": {
					datos.tabla = "presupuestoscli";
					break;
				}
				case "lineaspedidoscli": {
					datos.tabla = "pedidoscli";
					break;
				}
				case "lineasalbaranescli": {
					datos.tabla = "albaranescli";
					break;
				}
				case "lineasfacturascli": {
					datos.tabla = "facturascli";
					break;
				}
			}
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

