
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends oficial /** %from: oficial */ {
    function fluxEcommerce( context ) { oficial ( context ); }

	function beforeCommit_formaspago(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_formaspago(cursor);
	}
	function beforeCommit_empresa(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_empresa(cursor);
	}
	function beforeCommit_paises(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_paises(cursor);
	}
	function beforeCommit_gruposclientes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_gruposclientes(cursor);
	}
	function beforeCommit_clientes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_clientes(cursor);
	}



	function setModificado(cursor:FLSqlCursor)  {
		return this.ctx.fluxEcommerce_setModificado(cursor);
	}



	function afterCommit_formaspago(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_formaspago(cursor);
	}
	function afterCommit_paises(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_paises(cursor);
	}
	function afterCommit_gruposclientes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_gruposclientes(cursor);
	}
	function afterCommit_clientes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_clientes(cursor);
	}



	function registrarDel(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_registrarDel(cursor);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////

function fluxEcommerce_beforeCommit_formaspago(cursor:FLSqlCursor):Boolean {
	this.iface.setModificado(cursor);
}

function fluxEcommerce_beforeCommit_paises(cursor:FLSqlCursor):Boolean {
	this.iface.setModificado(cursor);
}

function fluxEcommerce_beforeCommit_empresa(cursor:FLSqlCursor):Boolean {
	this.iface.setModificado(cursor);
}

function fluxEcommerce_beforeCommit_gruposclientes(cursor:FLSqlCursor):Boolean {
	this.iface.setModificado(cursor);
}

function fluxEcommerce_beforeCommit_clientes(cursor:FLSqlCursor):Boolean {
	if (cursor.valueBuffer("clienteweb"))
		this.iface.setModificado(cursor);
	return this.iface.__beforeCommit_clientes(cursor);
}



function fluxEcommerce_afterCommit_formaspago(cursor:FLSqlCursor):Boolean {
	this.iface.registrarDel(cursor);
}

function fluxEcommerce_afterCommit_paises(cursor:FLSqlCursor):Boolean {
	this.iface.registrarDel(cursor);
}

function fluxEcommerce_afterCommit_gruposclientes(cursor:FLSqlCursor):Boolean {
	this.iface.registrarDel(cursor);
}

function fluxEcommerce_afterCommit_clientes(cursor:FLSqlCursor):Boolean {
	if (cursor.valueBuffer("clienteweb"))
		this.iface.registrarDel(cursor);
	return this.iface.__afterCommit_clientes(cursor);
}



function fluxEcommerce_setModificado(cursor:FLSqlCursor) {
	if (cursor.isModifiedBuffer() && !cursor.valueBufferCopy("modificado"))
		cursor.setValueBuffer("modificado", true);
}

/** \D Guarda el registro en la tabla de eliminados. Se utiliza para eliminar
registros en la base de datos remota
*/
function fluxEcommerce_registrarDel(cursor:FLSqlCursor)
{
	if (cursor.modeAccess() != cursor.Del)
		return true;

	var tabla:String = cursor.table();
	var valorClave = cursor.valueBuffer(cursor.primaryKey());

	var curTab:FLSqlCursor = new FLSqlCursor("registrosdel");
	curTab.select("tabla = '" + tabla + "' AND idcampo = '" + valorClave + "'");

	if (curTab.first())
		return true;

	curTab.setModeAccess(curTab.Insert);
	curTab.refreshBuffer();
	curTab.setValueBuffer("tabla", tabla);
	curTab.setValueBuffer("idcampo", valorClave);
	curTab.commitBuffer();
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

