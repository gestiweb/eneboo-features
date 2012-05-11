
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends ivaIncluido {
    function fluxEcommerce( context ) { ivaIncluido ( context ); }
	function datosAlbaran(curPedido:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.fluxEcommerce_datosAlbaran(curPedido, where, datosAgrupacion);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////

function fluxEcommerce_datosAlbaran(curPedido:FLSqlCursor,where:String, datosAgrupacion:Array):Boolean
{
	if (!this.iface.__datosAlbaran(curPedido, where, datosAgrupacion))
		return false;

	var codDirEnv:Number;
	with (this.iface.curAlbaran) {
		setValueBuffer("nombre", curPedido.valueBuffer("nombre"));
		setValueBuffer("apellidos", curPedido.valueBuffer("apellidos"));
		setValueBuffer("empresa", curPedido.valueBuffer("empresa"));
		if (codDirEnv == 0) {
			setNull("coddirenv");
		} else {
			setValueBuffer("coddirenv", curPedido.valueBuffer("coddirenv"));
		}
		setValueBuffer("nombreenv", curPedido.valueBuffer("nombreenv"));
		setValueBuffer("apellidosenv", curPedido.valueBuffer("apellidosenv"));
		setValueBuffer("empresaenv", curPedido.valueBuffer("empresaenv"));
		setValueBuffer("direccionenv", curPedido.valueBuffer("direccionenv"));
		setValueBuffer("codpostalenv", curPedido.valueBuffer("codpostalenv"));
		setValueBuffer("ciudadenv", curPedido.valueBuffer("ciudadenv"));
		setValueBuffer("provinciaenv", curPedido.valueBuffer("provinciaenv"));
		setValueBuffer("apartadoenv", curPedido.valueBuffer("apartadoenv"));
		setValueBuffer("codpaisenv", curPedido.valueBuffer("codpaisenv"));
		setValueBuffer("codenvio", curPedido.valueBuffer("codenvio"));
	}

	return true;
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

