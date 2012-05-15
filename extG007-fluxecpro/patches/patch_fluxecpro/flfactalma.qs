
/** @class_declaration traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
class traducciones extends fluxEcommerce /** %from: oficial */ {
	var valoresTradActual:Array;
	function traducciones( context ) { fluxEcommerce ( context ); }
	function traducir(tabla:String, campo:String, idCampo:String) {
		return this.ctx.traducciones_traducir(tabla, campo, idCampo);
	}
	function valoresTrad(tabla:String, campo:String, idCampo:String) {
		return this.ctx.traducciones_valoresTrad(tabla, campo, idCampo);
	}
	function afterCommit_articulos(curArticulo:FLSqlCursor):Boolean {
		return this.ctx.traducciones_afterCommit_articulos(curArticulo);
	}
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration fluxecPro */
/////////////////////////////////////////////////////////////////
//// FLUX EC PRO /////////////////////////////////////////////////
class fluxecPro extends traducciones /** %from: fluxEcommerce */ {
    function fluxecPro( context ) { traducciones ( context ); }
	function setModificado(cursor:FLSqlCursor)  {
		return this.ctx.fluxecPro_setModificado(cursor);
	}
}
//// FLUX EC PRO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubTraducciones */
/////////////////////////////////////////////////////////////////
//// PUB_TRADUCCIONES //////////////////////////////////////////
class pubTraducciones extends head /** %from: head */ {
	function pubTraducciones( context ) { head( context ); }
	function pub_traducir(tabla:String, campo:String, idCampo:String) {
		return this.traducir(tabla, campo, idCampo);
	}
	function pub_valoresTrad(tabla:String, campo:String, idCampo:String) {
		return this.valoresTrad(tabla, campo, idCampo);
	}
}

//// PUB_TRADUCCIONES //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
function traducciones_traducir(tabla:String, campo:String, idCampo:String)
{
	return flfactppal.iface.pub_traducir(tabla, campo, idCampo);
}

function traducciones_valoresTrad(tabla:String, campo:String, idCampo:String)
{
	return flfactppal.iface.valoresTrad(tabla, campo, idCampo);
}

function traducciones_afterCommit_articulos(curArticulo:FlSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
	if (curArticulo.modeAccess() == curArticulo.Del) {
		if (!util.sqlDelete("traducciones", "idcampo = '" + curArticulo.valueBuffer("referencia") + "'")) {
			return false;
		}
	}
	return true;
}

//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxecPro */
//////////////////////////////////////////////////////////////////
//// FLUX EC PRO //////////////////////////////////////////////////

function fluxecPro_setModificado(cursor:FLSqlCursor) {

	if (!cursor.isModifiedBuffer() || cursor.valueBufferCopy("modificado"))
		return true;

	var tabla:String = cursor.table();

	switch(tabla) {

		// Solo se marcan para coordinar los que son publicos (usamos valueBufferCopy por si se ha actualizado de publico a no publico)
		case "articulos":
			if (cursor.valueBufferCopy("publico") || cursor.valueBuffer("publico"))
				cursor.setValueBuffer("modificado", true);
			else
				return true;
		break;

		// Tablas relacionadas. Solamente los registros de articulos publicos
		case "stocks":
		case "articuloscomp":
		case "articulostarifas":
		case "formasenvio":
		 	var util:FLUtil = new FLUtil();
			if (!util.sqlSelect("articulos", "publico", "referencia = '" + cursor.valueBuffer("referencia") + "'"))
				return true;
		break;
	}

	cursor.setValueBuffer("modificado", true);

	return true;
}

//// FLUX EC PRO //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

