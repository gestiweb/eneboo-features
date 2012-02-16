
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends ivaIncluido /** %from: ivaIncluido */ {
    function fluxEcommerce( context ) { ivaIncluido ( context ); }
	function datosFactura(curAlbaran:FLSqlCursor, where:String, datosAgrupacion:Array):Boolean {
		return this.ctx.fluxEcommerce_datosFactura(curAlbaran, where, datosAgrupacion);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////

function fluxEcommerce_datosFactura(curAlbaran:FLSqlCursor,where:String, datosAgrupacion:Array):Boolean
{
	if (!this.iface.__datosFactura(curAlbaran, where, datosAgrupacion))
		return false;

	var codDirEnv:Number;
	with (this.iface.curFactura) {
		setValueBuffer("nombre", curAlbaran.valueBuffer("nombre"));
		setValueBuffer("apellidos", curAlbaran.valueBuffer("apellidos"));
		setValueBuffer("empresa", curAlbaran.valueBuffer("empresa"));
		if (codDirEnv == 0) {
			setNull("coddirenv");
		} else {
			setValueBuffer("coddirenv", curPedido.valueBuffer("coddirenv"));
		}
		setValueBuffer("nombreenv", curAlbaran.valueBuffer("nombreenv"));
		setValueBuffer("apellidosenv", curAlbaran.valueBuffer("apellidosenv"));
		setValueBuffer("empresaenv", curAlbaran.valueBuffer("empresaenv"));
		setValueBuffer("direccionenv", curAlbaran.valueBuffer("direccionenv"));
		setValueBuffer("codpostalenv", curAlbaran.valueBuffer("codpostalenv"));
		setValueBuffer("ciudadenv", curAlbaran.valueBuffer("ciudadenv"));
		setValueBuffer("provinciaenv", curAlbaran.valueBuffer("provinciaenv"));
		setValueBuffer("apartadoenv", curAlbaran.valueBuffer("apartadoenv"));
		setValueBuffer("codpaisenv", curAlbaran.valueBuffer("codpaisenv"));
		setValueBuffer("codenvio", curAlbaran.valueBuffer("codenvio"));
	}

	return true;
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

