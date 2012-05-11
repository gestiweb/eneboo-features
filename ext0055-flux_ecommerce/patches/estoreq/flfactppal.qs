
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends traducciones {
    function fluxEcommerce( context ) { traducciones ( context ); }

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
	function beforeCommit_idiomas(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_idiomas(cursor);
	}
	function afterCommit_idiomas(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_idiomas(cursor);
	}
	function beforeCommit_traducciones(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_traducciones(cursor);
	}
	function afterCommit_traducciones(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_traducciones(cursor);
	}
	function idiomaDefecto():String {
		return this.ctx.fluxEcommerce_idiomaDefecto();
	}
	function ordenIdiomas():String {
		return this.ctx.fluxEcommerce_ordenIdiomas();
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

function fluxEcommerce_beforeCommit_idiomas(cursor:FLSqlCursor):Boolean {
	if (!this.iface.__beforeCommit_idiomas(cursor)) {
		return false;
	}
	return this.iface.setModificado(cursor);
}

function fluxEcommerce_afterCommit_idiomas(cursor:FLSqlCursor):Boolean {
	if (!this.iface.__afterCommit_idiomas(cursor)) {
		return false;
	}
	return this.iface.registrarDel(cursor);
}

function fluxEcommerce_beforeCommit_traducciones(cursor:FLSqlCursor):Boolean {
	if (!this.iface.__beforeCommit_traducciones(cursor)) {
		return false;
	}
	return this.iface.setModificado(cursor);
}

function fluxEcommerce_afterCommit_traducciones(cursor:FLSqlCursor):Boolean {
	if (!this.iface.__afterCommit_traducciones(cursor)) {
		return false;
	}
	return this.iface.registrarDel(cursor);
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

function fluxEcommerce_idiomaDefecto():String
{
	var util:FLUtil = new FLUtil();
	var idiomaDefecto:String = util.sqlSelect("opcionestv", "codidiomadefecto", "1=1");
	return idiomaDefecto;
}

function fluxEcommerce_ordenIdiomas():String
{
	return " ORDER BY orden";
}


//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

