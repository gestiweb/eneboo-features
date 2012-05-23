
/** @class_declaration funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
class funNumSerie extends oficial {
	function funNumSerie( context ) { oficial ( context ); }
	function copiaLineaPedido(curLineaPedido:FLSqlCursor, idAlbaran:Number):Number {
		return this.ctx.funNumSerie_copiaLineaPedido(curLineaPedido, idAlbaran);
	}
	function datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_datosLineaAlbaran(curLineaPedido);
	}
}
//// FUN_NUMEROS_SERIE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/** \D
Copia una líneas de un pedido en su remito asociado. Si se trata de una línea de
número de serie genera tantas líneas de cantidad 1 como cantidad hay en la línea.
@param curdPedido: Cursor posicionado en la línea de pedido a copiar
@param idAlbaran: Identificador del remito
@return identificador de la línea de remito creada si no hay error. FALSE en otro caso.
\end */
function funNumSerie_copiaLineaPedido(curLineaPedido:FLSqlCursor, idAlbaran:Number):Number
{
	var util:FLUtil = new FLUtil();
	
	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLineaPedido.valueBuffer("referencia") + "'"))
		return this.iface.__copiaLineaPedido(curLineaPedido, idAlbaran);

	if (!this.iface.curLineaAlbaran)
		this.iface.curLineaAlbaran = new FLSqlCursor("lineasalbaranescli");
	
	var cantidad:Number = parseFloat(curLineaPedido.valueBuffer("cantidad"));
	var cantidadServida:Number = parseFloat(curLineaPedido.valueBuffer("totalenalbaran"));
	
	for (var i:Number = cantidadServida; i < cantidad; i++) {
	
		with (this.iface.curLineaAlbaran) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idalbaran", idAlbaran);
		}
		
		if (!this.iface.datosLineaAlbaran(curLineaPedido))
			return false;
			
		if (!this.iface.curLineaAlbaran.commitBuffer())
			return false;
	}
	
	curLineaPedido.setValueBuffer("cantidad", cantidad);
	
	return this.iface.curLineaAlbaran.valueBuffer("idlinea");
}

function funNumSerie_datosLineaAlbaran(curLineaPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if(!this.iface.__datosLineaAlbaran(curLineaPedido))
		return false;

	var pvpSinDto:Number = parseFloat(curLineaPedido.valueBuffer("pvpunitario"));

	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLineaPedido.valueBuffer("referencia") + "'"))
		with (this.iface.curLineaAlbaran) {
			setValueBuffer("cantidad", 1);
			setValueBuffer("pvpsindto", pvpSinDto);
			setValueBuffer("pvptotal", parseFloat(formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this)));
		}

	return true;
}


//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

