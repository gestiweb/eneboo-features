
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial /** %from: oficial */ {
    function barCode( context ) { oficial ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.barCode_datosLineaAlbaran(curLineaPedido);
	}
	function comprobarStockEnAlbaranado(curLineaPedido:FLSqlCursor, cantidad:Number):Array {
		return this.ctx.barCode_comprobarStockEnAlbaranado(curLineaPedido, cantidad);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends barCode /** %from: barCode */ {
    function rappel( context ) { barCode ( context ); }
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.rappel_datosLineaAlbaran(curLineaPedido);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////

/** \D Copia los datos de una línea de pedido en una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function barCode_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	with (this.iface.curLineaAlbaran) {
		setValueBuffer("barcode", curLineaPedido.valueBuffer("barcode"));
		setValueBuffer("talla", curLineaPedido.valueBuffer("talla"));
		setValueBuffer("color", curLineaPedido.valueBuffer("color"));
	}
	return true;
}

function barCode_comprobarStockEnAlbaranado(curLineaPedido:FLSqlCursor, cantidad:Number):Array
{
	var barCode:String = curLineaPedido.valueBuffer("barcode");

	if (!barCode)
		return this.iface.__comprobarStockEnAlbaranado(curLineaPedido, cantidad);

	var util:FLUtil = new FLUtil;
	var res:Array = [];

	res["haystock"] = true;
	res["cantidad"] = 0;
	res["ok"] = true;
	var referencia:String = curLineaPedido.valueBuffer("referencia");
	if (referencia && referencia != "") {
		var controlStock:Boolean = util.sqlSelect("articulos", "controlstock", "referencia = '" + referencia + "'");
		if (!controlStock) {
			var codAlmacen:String;
			if (curLineaPedido.cursorRelation())
				codAlmacen = curLineaPedido.cursorRelation().valueBuffer("codalmacen");
			else
				codAlmacen = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + curLineaPedido.valueBuffer("idpedido"));

			var cantidadStock:Number = parseFloat(util.sqlSelect("stocks", "cantidad", "barcode = '" + barCode + "' AND codalmacen = '" + codAlmacen + "'"));
			if (!cantidadStock || isNaN(cantidadStock))
				cantidadStock = 0;

			if (cantidadStock < cantidad) {
				res["haystock"] = false;
				var resCuestion:Number = MessageBox.warning(util.translate("scripts", "El artículo %1 con barcode %2 no permite ventas sin stocks.\nEstá albaranando más cantidad (%3) que la disponible (%4) ahora mismo en el almacén %5.\n¿Desea continuar dejando el pedido parcialmente albaranado?").arg(referencia).arg(barCode).arg(cantidad).arg(cantidadStock).arg(codAlmacen), MessageBox.No, MessageBox.Yes);
				if (resCuestion != MessageBox.Yes) {
					res["ok"] = false;
					return res;
				}
				if (cantidadStock < 0)
					cantidadStock = 0;
				res["cantidad"] = cantidadStock;
			}
		}
	}
	return res;
}

//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de pedido en una línea de albarán añadiendo el dato de descuento por rappel a una línea de albarán
@param	curLineaPedido: Cursor que contiene los datos a incluir en la línea de albarán
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function rappel_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	with (this.iface.curLineaAlbaran) {
		setValueBuffer("dtorappel", curLineaPedido.valueBuffer("dtorappel"));
	}

	if(!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	return true;
}

//// RAPPEL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

