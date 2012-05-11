
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends ivaIncluido {
	var curAtributoArticulo:FLSqlCursor;
	var curAccesorioArticulo:FLSqlCursor;
    function fluxEcommerce( context ) { ivaIncluido ( context ); }
// 	function datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean {
// 		return this.ctx.fluxEcommerce_datosArticulo(cursor,referencia);
// 	}
	function copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.fluxEcommerce_copiarAnexosArticulo(refOriginal, refNueva);
	}
// 	function copiarTablaAtributosArticulos(nuevaReferencia:String):Boolean {
// 		return this.ctx.fluxEcommerce_copiarTablaAtributosArticulos(nuevaReferencia);
// 	}
	function copiarAtributosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.fluxEcommerce_copiarAtributosArticulo(refOriginal, refNueva);
	}
	function datosAtributoArticulo(cursor:FLSqlCursor,cursorNuevo:FLSqlCursor,referencia:String):Boolean {
		return this.ctx.fluxEcommerce_datosAtributoArticulo(cursor,cursorNuevo,referencia);
	}
// 	function copiarTablaAccesoriosArticulos(nuevaReferencia:String):Boolean {
// 		return this.ctx.fluxEcommerce_copiarTablaAccesoriosArticulos(nuevaReferencia);
// 	}
	function copiarAccesoriosArticulo(refOriginal:String, refNueva:String):Number {
		return this.ctx.fluxEcommerce_copiarAccesoriosArticulo(refOriginal, refNueva);
	}
	function datosAccesorioArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean {
		return this.ctx.fluxEcommerce_datosAccesorioArticulo(cursorOrigen, campo);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE /////////////////////////////////////////////

// function fluxEcommerce_datosArticulo(cursor:FLSqlCursor,referencia:String):Boolean
// {
// 	if (!this.iface.__datosArticulo(cursor,referencia))
// 		return false
//
// 	cursor.setValueBuffer("codfabricante",this.iface.curArticulo.valueBuffer("codfabricante"));
// 	cursor.setValueBuffer("publico",this.iface.curArticulo.valueBuffer("publico"));
// 	cursor.setValueBuffer("descpublica",this.iface.curArticulo.valueBuffer("descpublica"));
// 	cursor.setValueBuffer("fechapub",this.iface.curArticulo.valueBuffer("fechapub"));
// 	cursor.setValueBuffer("fechaimagen",this.iface.curArticulo.valueBuffer("fechaimagen"));
// 	cursor.setValueBuffer("codplazoenvio",this.iface.curArticulo.valueBuffer("codplazoenvio"));
// 	cursor.setValueBuffer("enportada",this.iface.curArticulo.valueBuffer("enportada"));
// 	cursor.setValueBuffer("ordenportada",this.iface.curArticulo.valueBuffer("ordenportada"));
// 	cursor.setValueBuffer("enoferta",this.iface.curArticulo.valueBuffer("enoferta"));
// 	cursor.setValueBuffer("codtarifa",this.iface.curArticulo.valueBuffer("codtarifa"));
// 	cursor.setValueBuffer("pvpoferta",this.iface.curArticulo.valueBuffer("pvpoferta"));
// 	cursor.setValueBuffer("pvpoferta",this.iface.curArticulo.valueBuffer("pvpoferta"));
// 	cursor.setValueBuffer("tipoimagen",this.iface.curArticulo.valueBuffer("tipoimagen"));
// 	cursor.setValueBuffer("modificado",this.iface.curArticulo.valueBuffer("modificado"));
//
// 	return true;
// }

function fluxEcommerce_copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean
{
	if (!this.iface.__copiarAnexosArticulo(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarAtributosArticulo(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarAccesoriosArticulo(refOriginal, refNueva)) {
		return false;
	}
	return true;
}

// function fluxEcommerce_copiarTablaAtributosArticulos(refOriginal:String, refNueva:String):Boolean
// {
// 	var q:FLSqlQuery = new FLSqlQuery();
// 	q.setTablesList("atributosart");
// 	q.setSelect("id");
// 	q.setFrom("atributosart");
// 	q.setWhere("referencia = '" + refOriginal + "'");
//
// 	if (!q.exec()) {
// 		return false;
// 	}
// 	while (q.next()) {
// 		if (!this.iface.copiarAtributosArticulo(q.value("id"), refNueva)) {
// 			return false;
// 		}
// 	}
//
// 	return true;
// }

function fluxEcommerce_copiarAtributosArticulo(refOriginal:String, refNueva:String):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curAtributoArticulo) {
		this.iface.curAtributoArticulo = new FLSqlCursor("atributosart");
	}

	var campos:Array = util.nombreCampos("atributosart");
	var totalCampos:Number = campos[0];

	var curAtributoArticuloOrigen:FLSqlCursor = new FLSqlCursor("atributosart");
	curAtributoArticuloOrigen.select("referencia = '" + refOriginal + "'");
	while (curAtributoArticuloOrigen.next()) {
		this.iface.curAtributoArticulo.setModeAccess(this.iface.curAtributoArticulo.Insert);
		this.iface.curAtributoArticulo.refreshBuffer();
		this.iface.curAtributoArticulo.setValueBuffer("referencia", refNueva);

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosAtributoArticulo(curAtributoArticuloOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curAtributoArticulo.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function fluxEcommerce_datosAtributoArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referencia": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curAtributoArticulo.setNull(campo);
			} else {
				this.iface.curAtributoArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;
}
// 	cursorNuevo.setValueBuffer("referencia",referencia);
// 	cursorNuevo.setValueBuffer("codatributo",cursor.valueBuffer("codatributo"));
// 	cursorNuevo.setValueBuffer("valor",cursor.valueBuffer("valor"));
// 	cursorNuevo.setValueBuffer("modificado",cursor.valueBuffer("modificado"));
//
// 	return true;
// }

// function fluxEcommerce_copiarTablaAccesoriosArticulos(nuevaReferencia:String):Boolean
// {
// 	var q:FLSqlQuery = new FLSqlQuery();
// 	q.setTablesList("accesoriosart");
// 	q.setSelect("id");
// 	q.setFrom("accesoriosart");
// 	q.setWhere("referenciappal = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");
//
// 	if (!q.exec())
// 		return false;
//
// 	while (q.next()) {
// 		if (!this.iface.copiarAccesoriosArticulo(q.value("id"),nuevaReferencia))
// 			return false;
// 	}
//
// 	return true;
// }

function fluxEcommerce_copiarAccesoriosArticulo(refOriginal:String, refNueva:String):Number
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curAccesorioArticulo) {
		this.iface.curAccesorioArticulo = new FLSqlCursor("accesoriosart");
	}

	var campos:Array = util.nombreCampos("accesoriosart");
	var totalCampos:Number = campos[0];

	var curAccesorioArticuloOrigen:FLSqlCursor = new FLSqlCursor("accesoriosart");
	curAccesorioArticuloOrigen.select("referenciappal = '" + refOriginal + "'");
	while (curAccesorioArticuloOrigen.next()) {
		this.iface.curAccesorioArticulo.setModeAccess(this.iface.curAccesorioArticulo.Insert);
		this.iface.curAccesorioArticulo.refreshBuffer();
		this.iface.curAccesorioArticulo.setValueBuffer("referenciappal", refNueva);

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosAccesorioArticulo(curAccesorioArticuloOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curAccesorioArticulo.commitBuffer()) {
			return false;
		}
	}

	return true;

// 	var curAccesorioArticulo:FLSqlCursor = new FLSqlCursor("accesoriosart");
// 	curAccesorioArticulo.select("id = " + id);
// 	if (!curAccesorioArticulo.first())
// 		return false;
// 	curAccesorioArticulo.setModeAccess(curAccesorioArticulo.Edit);
// 	curAccesorioArticulo.refreshBuffer();
//
// 	var curAccesorioArticuloNuevo:FLSqlCursor = new FLSqlCursor("accesoriosart");
// 	curAccesorioArticuloNuevo.setModeAccess(curAccesorioArticuloNuevo.Insert);
// 	curAccesorioArticuloNuevo.refreshBuffer();
//
// 	if (!this.iface.datosAccesorioArticulo(curAccesorioArticulo,curAccesorioArticuloNuevo,referencia))
// 		return false;
//
// 	if (!curAccesorioArticuloNuevo.commitBuffer())
// 		return false;
//
// 	var idNuevo:Number = curAccesorioArticuloNuevo.valueBuffer("id");
//
// 	return idNuevo;
}

function fluxEcommerce_datosAccesorioArticulo(cursorOrigen:FLSqlCursor, campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "referenciappal": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curAccesorioArticulo.setNull(campo);
			} else {
				this.iface.curAccesorioArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}
	return true;

// 	cursorNuevo.setValueBuffer("referenciappal",referencia);
// 	cursorNuevo.setValueBuffer("referenciaacc",cursor.valueBuffer("referenciaacc"));
// 	cursorNuevo.setValueBuffer("orden",cursor.valueBuffer("orden"));
// 	cursorNuevo.setValueBuffer("modificado",cursor.valueBuffer("modificado"));
//
// 	return true;
}
//// FLUX ECOMMERCE /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

