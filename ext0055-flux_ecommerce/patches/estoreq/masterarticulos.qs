
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends ivaIncluido /** %from: ivaIncluido */ {
    function fluxEcommerce( context ) { ivaIncluido ( context ); }
	function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
		return this.ctx.fluxEcommerce_datosArticulo(cursor,referencia);
	}
	function copiarAnexosArticulo(nuevaReferencia:String):Boolean {
		return this.ctx.fluxEcommerce_copiarAnexosArticulo(nuevaReferencia);
	}
	function copiarTablaAtributosArticulos(nuevaReferencia:String):Boolean {
		return this.ctx.fluxEcommerce_copiarTablaAtributosArticulos(nuevaReferencia);
	}
		function copiarAtributoArticulo(id:Number,referencia:String):Number {
		return this.ctx.fluxEcommerce_copiarAtributoArticulo(id,referencia);
	}
	function datosAtributoArticulo(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean {
		return this.ctx.fluxEcommerce_datosAtributoArticulo(cursor,cursorNuevo,referencia);
	}
	function copiarTablaAccesoriosArticulos(nuevaReferencia:String):Boolean {
		return this.ctx.fluxEcommerce_copiarTablaAccesoriosArticulos(nuevaReferencia);
	}
		function copiarAccesorioArticulo(id:Number,referencia:String):Number {
		return this.ctx.fluxEcommerce_copiarAccesorioArticulo(id,referencia);
	}
	function datosAccesorioArticulo(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean {
		return this.ctx.fluxEcommerce_datosAccesorioArticulo(cursor,cursorNuevo,referencia);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE /////////////////////////////////////////////

function fluxEcommerce_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean
{
	if (!this.iface.__datosArticulo(cursor,referencia))
		return false

	cursor.setValueBuffer("codfabricante",this.iface.curArticulo.valueBuffer("codfabricante"));
	cursor.setValueBuffer("publico",this.iface.curArticulo.valueBuffer("publico"));
	cursor.setValueBuffer("descpublica",this.iface.curArticulo.valueBuffer("descpublica"));
	cursor.setValueBuffer("fechapub",this.iface.curArticulo.valueBuffer("fechapub"));
	cursor.setValueBuffer("fechaimagen",this.iface.curArticulo.valueBuffer("fechaimagen"));
	cursor.setValueBuffer("codplazoenvio",this.iface.curArticulo.valueBuffer("codplazoenvio"));
	cursor.setValueBuffer("enportada",this.iface.curArticulo.valueBuffer("enportada"));
	cursor.setValueBuffer("ordenportada",this.iface.curArticulo.valueBuffer("ordenportada"));
	cursor.setValueBuffer("enoferta",this.iface.curArticulo.valueBuffer("enoferta"));
	cursor.setValueBuffer("codtarifa",this.iface.curArticulo.valueBuffer("codtarifa"));
	cursor.setValueBuffer("pvpoferta",this.iface.curArticulo.valueBuffer("pvpoferta"));
	cursor.setValueBuffer("pvpoferta",this.iface.curArticulo.valueBuffer("pvpoferta"));
	cursor.setValueBuffer("tipoimagen",this.iface.curArticulo.valueBuffer("tipoimagen"));
	cursor.setValueBuffer("modificado",this.iface.curArticulo.valueBuffer("modificado"));

	return true;
}

function fluxEcommerce_copiarAnexosArticulo(nuevaReferencia:String):Boolean
{
	if (!this.iface.__copiarAnexosArticulo(nuevaReferencia))
		return false;

	if (!this.iface.copiarTablaAtributosArticulos(nuevaReferencia))
		return false;

	if (!this.iface.copiarTablaAccesoriosArticulos(nuevaReferencia))
		return false;

	return true;
}

function fluxEcommerce_copiarTablaAtributosArticulos(nuevaReferencia:String):Boolean
{
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("atributosart");
	q.setSelect("id");
	q.setFrom("atributosart");
	q.setWhere("referencia = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");

	if (!q.exec())
		return false;

	while (q.next()) {
		if (!this.iface.copiarAtributoArticulo(q.value("id"),nuevaReferencia))
			return false;
	}

	return true;
}

function fluxEcommerce_copiarAtributoArticulo(id:Number,referencia:String):Number
{
	var curAtributoArticulo:FLSqlCursor = new FLSqlCursor("atributosart");
	curAtributoArticulo.select("id = " + id);
	if (!curAtributoArticulo.first())
		return false;
	curAtributoArticulo.setModeAccess(curAtributoArticulo.Edit);
	curAtributoArticulo.refreshBuffer();

	var curAtributoArticuloNuevo:FLSqlCursor = new FLSqlCursor("atributosart");
	curAtributoArticuloNuevo.setModeAccess(curAtributoArticuloNuevo.Insert);
	curAtributoArticuloNuevo.refreshBuffer();

	if (!this.iface.datosAtributoArticulo(curAtributoArticulo,curAtributoArticuloNuevo,referencia))
		return false;

	if (!curAtributoArticuloNuevo.commitBuffer())
		return false;

	var idNuevo:Number = curAtributoArticuloNuevo.valueBuffer("id");

	return idNuevo;
}

function fluxEcommerce_datosAtributoArticulo(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean
{
	cursorNuevo.setValueBuffer("referencia",referencia);
	cursorNuevo.setValueBuffer("codatributo",cursor.valueBuffer("codatributo"));
	cursorNuevo.setValueBuffer("valor",cursor.valueBuffer("valor"));
	cursorNuevo.setValueBuffer("modificado",cursor.valueBuffer("modificado"));

	return true;
}

function fluxEcommerce_copiarTablaAccesoriosArticulos(nuevaReferencia:String):Boolean
{
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("accesoriosart");
	q.setSelect("id");
	q.setFrom("accesoriosart");
	q.setWhere("referenciappal = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");

	if (!q.exec())
		return false;

	while (q.next()) {
		if (!this.iface.copiarAccesorioArticulo(q.value("id"),nuevaReferencia))
			return false;
	}

	return true;
}

function fluxEcommerce_copiarAccesorioArticulo(id:Number,referencia:String):Number
{
	var curAccesorioArticulo:FLSqlCursor = new FLSqlCursor("accesoriosart");
	curAccesorioArticulo.select("id = " + id);
	if (!curAccesorioArticulo.first())
		return false;
	curAccesorioArticulo.setModeAccess(curAccesorioArticulo.Edit);
	curAccesorioArticulo.refreshBuffer();

	var curAccesorioArticuloNuevo:FLSqlCursor = new FLSqlCursor("accesoriosart");
	curAccesorioArticuloNuevo.setModeAccess(curAccesorioArticuloNuevo.Insert);
	curAccesorioArticuloNuevo.refreshBuffer();

	if (!this.iface.datosAccesorioArticulo(curAccesorioArticulo,curAccesorioArticuloNuevo,referencia))
		return false;

	if (!curAccesorioArticuloNuevo.commitBuffer())
		return false;

	var idNuevo:Number = curAccesorioArticuloNuevo.valueBuffer("id");

	return idNuevo;
}

function fluxEcommerce_datosAccesorioArticulo(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean
{
	cursorNuevo.setValueBuffer("referenciappal",referencia);
	cursorNuevo.setValueBuffer("referenciaacc",cursor.valueBuffer("referenciaacc"));
	cursorNuevo.setValueBuffer("orden",cursor.valueBuffer("orden"));
	cursorNuevo.setValueBuffer("modificado",cursor.valueBuffer("modificado"));

	return true;
}
//// FLUX ECOMMERCE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

