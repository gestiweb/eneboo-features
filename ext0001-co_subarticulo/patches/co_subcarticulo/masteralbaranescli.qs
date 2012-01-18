
/** @class_declaration ctaVentasArt */
//////////////////////////////////////////////////////////////////
//// CTA_VENTAS_ART //////////////////////////////////////////////
class ctaVentasArt extends oficial /** %from: oficial */ {
	function ctaVentasArt( context ) { oficial( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return ctaVentasArt_datosLineaFactura(curLineaAlbaran);
	}
}
//// CTA_VENTAS_ART //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ctaVentasArt */
/////////////////////////////////////////////////////////////////
//// CTA_VENTAS_ART /////////////////////////////////////////////
/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ctaVentasArt_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	var util:FLUtil = new FLUtil;

	var codEjercicio:String = util.sqlSelect("facturascli", "codejercicio", "idfactura = " + this.iface.curLineaFactura.valueBuffer("idfactura"));

	var subcuentaVentas:Array = flfacturac.iface.pub_subcuentaVentas(curLineaAlbaran.valueBuffer("referencia"), codEjercicio);
	if (subcuentaVentas) {
		with (this.iface.curLineaFactura) {
			setValueBuffer("codsubcuenta", subcuentaVentas.codsubcuenta);
			setValueBuffer("idsubcuenta", subcuentaVentas.idsubcuenta);
		}
	}
	return true;
}

//// CTA_VENTAS_ART /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

