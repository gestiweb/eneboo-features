
/** @class_declaration ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
class ivaIncluido extends oficial /** %from: oficial */ {
    function ivaIncluido( context ) { oficial( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.ivaIncluido_datosLineaFactura(curLineaAlbaran);
	}
	function totalesFactura():Boolean {
		return this.ctx.ivaIncluido_totalesFactura();
	}
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
//////////////////////////////////////////////////////////////////
//// IVAINCLUIDO /////////////////////////////////////////////////////
/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function ivaIncluido_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__datosLineaFactura(curLineaAlbaran)) {
		return false;
	}
	with (this.iface.curLineaFactura) {
		setValueBuffer("ivaincluido", curLineaAlbaran.valueBuffer("ivaincluido"));
		setValueBuffer("pvpunitarioiva", curLineaAlbaran.valueBuffer("pvpunitarioiva"));
	}
	/// El cambio puede deberse a que la fecha del nuevo documento esté asociada a un tipo de IVA distinto del documento origens
	if (curLineaAlbaran.valueBuffer("iva") != this.iface.curLineaFactura.valueBuffer("iva")) {
		if (this.iface.curLineaFactura.valueBuffer("ivaincluido")) {
			this.iface.curLineaFactura.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaFactura));
			this.iface.curLineaFactura.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaFactura));
		}
	}

	return true;
}

function ivaIncluido_totalesFactura():Boolean
{
	this.iface.__totalesFactura();

	// Comprobar redondeo y recalcular totales
	formRecordfacturascli.iface.comprobarRedondeoIVA(this.iface.curFactura, "idfactura")
	with (this.iface.curFactura) {
		setValueBuffer("total", formpedidoscli.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidoscli.iface.pub_commonCalculateField("totaleuros", this));
	}
	return true;
}
//// IVAINCLUIDO /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

