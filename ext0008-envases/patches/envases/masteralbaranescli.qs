
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial /** %from: oficial */ {
    function envases( context ) { oficial ( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.envases_datosLineaFactura(curLineaAlbaran);
	}
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
/** \D Copia los datos de una línea de albarán en una línea de factura añadiendo los datos relativos al envase (--codenvase--, --valormetrico-- y --canenvases--)
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function envases_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	with (this.iface.curLineaFactura) {
		setValueBuffer("valormetrico", curLineaAlbaran.valueBuffer("valormetrico"));
		setValueBuffer("canenvases", curLineaAlbaran.valueBuffer("canenvases"));
		setValueBuffer("codenvase", curLineaAlbaran.valueBuffer("codenvase"));
	}

	if(!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	return true;
}


//// ENVASES ////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

