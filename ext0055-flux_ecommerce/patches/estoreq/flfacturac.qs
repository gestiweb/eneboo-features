
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends ivaIncluido /** %from: oficial */ {
    function fluxEcommerce( context ) { ivaIncluido ( context ); }

	function beforeCommit_pedidoscli(curPedido:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_pedidoscli(curPedido);
	}

	function setModificado(cursor:FLSqlCursor)  {
		return this.ctx.fluxEcommerce_setModificado(cursor);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////

function fluxEcommerce_beforeCommit_pedidoscli(cursor:FLSqlCursor):Boolean
{
	if (!this.iface.__beforeCommit_pedidoscli(cursor))
		return false;

	/** \C Los pedidos web modificados en local se registran
	*/
	if (cursor.valueBuffer("pedidoweb") && cursor.modeAccess() == cursor.Edit) {
		var curTab:FLSqlCursor = new FLSqlCursor("pedidoscli_mod");
		var codigo = cursor.valueBuffer("codigo");
		curTab.select("codigo = '" + codigo + "'");
		if (!curTab.first()) {
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("codigo", codigo);
			if (!curTab.commitBuffer())
				return false;
		}
	}
	return true;
}

function fluxEcommerce_setModificado(cursor:FLSqlCursor)
{
	if (cursor.isModifiedBuffer() && !cursor.valueBufferCopy("modificado"))
		cursor.setValueBuffer("modificado", true);
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

