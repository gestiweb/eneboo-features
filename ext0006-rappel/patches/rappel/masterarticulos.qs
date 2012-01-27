
/** @class_declaration rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
class rappel extends oficial /** %from: oficial */ {
	var curRappelArticulo:FLSqlCursor;
	var curRappelProvArt:FLSqlCursor;
    function rappel( context ) { oficial ( context ); }
	function copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.rappel_copiarAnexosArticulo(refOriginal, refNueva);
	}
	function copiarTablaRappelArticulos(refOriginal:String, refNueva:String):Boolean {
		return this.ctx.rappel_copiarTablaRappelArticulos(refOriginal, refNueva);
	}
	function datosRappelArticulo(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.rappel_datosRappelArticulo(cursor, campo);
	}
// 	function copiarTablaArticulosProv(nuevaReferencia:String):Boolean {
// 		return this.ctx.rappel_copiarTablaArticulosProv(nuevaReferencia);
// 	}
	function copiarTablaRappelProvArt(idArticuloProvOrigen:String, idArticuloProvNuevo:String):Boolean {
		return this.ctx.rappel_copiarTablaRappelProvArt(idArticuloProvOrigen, idArticuloProvNuevo);
	}
	function datosRappelProvArt(cursor:FLSqlCursor, campo:String):Boolean {
		return this.ctx.rappel_datosRappelProvArt(cursor, campo);
	}
	function copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean {
		return this.ctx.rappel_copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo);
	}
}
//// RAPPEL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition rappel */
/////////////////////////////////////////////////////////////////
//// RAPPEL /////////////////////////////////////////////////////
function rappel_copiarAnexosArticulo(refOriginal:String, refNueva:String):Boolean
{
	if (!this.iface.__copiarAnexosArticulo(refOriginal, refNueva)) {
		return false;
	}
	if (!this.iface.copiarTablaRappelArticulos(refOriginal, refNueva)) {
		return false;
	}
	return true;
}

function rappel_copiarTablaRappelArticulos(refOriginal:String, refNueva:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curRappelArticulo) {
		this.iface.curRappelArticulo = new FLSqlCursor("rappelarticulos");
	}

	var campos:Array = util.nombreCampos("rappelarticulos");
	var totalCampos:Number = campos[0];

	var curRappelArticuloOrigen:FLSqlCursor = new FLSqlCursor("rappelarticulos");
	curRappelArticuloOrigen.select("referencia = '" + refOriginal + "'");
	while (curRappelArticuloOrigen.next()) {
		this.iface.curRappelArticulo.setModeAccess(this.iface.curRappelArticulo.Insert);
		this.iface.curRappelArticulo.refreshBuffer();
		this.iface.curRappelArticulo.setValueBuffer("referencia", refNueva);

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosRappelArticulo(curRappelArticuloOrigen, campos[i])) {
				return false;
			}
		}

		if (!this.iface.curRappelArticulo.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function rappel_datosRappelArticulo(cursorOrigen:FLSqlCursor,campo:String):Boolean
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
				this.iface.curRappelArticulo.setNull(campo);
			} else {
				this.iface.curRappelArticulo.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}

	return true;
}

// function rappel_copiarTablaArticulosProv(nuevaReferencia:String):Boolean
// {
// 	var util:FLUtil;
//
// 	this.iface.curArticuloProv = new FLSqlCursor("articulosprov");
// 	this.iface.curArticuloProv.select("referencia = '" + this.iface.curArticulo.valueBuffer("referencia") + "'");
//
// 	var curArticuloProvNuevo:FLSqlCursor = new FLSqlCursor("articulosprov");
// 	var campos:Array = util.nombreCampos("articulosprov");
// 	var totalCampos:Number = campos[0];
//
// 	while (this.iface.curArticuloProv.next()) {
// 		curArticuloProvNuevo.setModeAccess(curArticuloProvNuevo.Insert);
// 		curArticuloProvNuevo.refreshBuffer();
// 		curArticuloProvNuevo.setValueBuffer("referencia", nuevaReferencia);
//
// 		for (var i:Number = 1; i <= totalCampos; i++) {
// 			if (!this.iface.datosArticuloProv(curArticuloProvNuevo,campos[i]))
// 				return false;
// 		}
//
// 		if (!curArticuloProvNuevo.commitBuffer())
// 			return false;
//
// 		var idArticuloProvNuevo:Number = curArticuloProvNuevo.valueBuffer("id");
// 		if(!idArticuloProvNuevo)
// 			return false;
// 		if(!this.iface.copiarTablaRappelProvArt(idArticuloProvNuevo))
// 			return false;
// 	}
//
// 	return true;
// }

function rappel_copiarTablaRappelProvArt(idArticuloProvOrigen:String, idArticuloProvNuevo:String):Boolean
{
	var util:FLUtil;

	if (!this.iface.curRappelProvArt) {
		this.iface.curRappelProvArt = new FLSqlCursor("rappelprovart");
	}

	var campos:Array = util.nombreCampos("rappelarticulos");
	var totalCampos:Number = campos[0];

	var curRappelProvArtOrigen:FLSqlCursor = new FLSqlCursor("rappelprovart");
	curRappelProvArtOrigen.select("id = '" + idArticuloProvOrigen + "'");
	while (curRappelProvArtOrigen.next()) {
		this.iface.curRappelProvArt.setModeAccess(this.iface.curRappelProvArt.Insert);
		this.iface.curRappelProvArt.refreshBuffer();
		this.iface.curRappelProvArt.setValueBuffer("id", idArticuloProvNuevo);

		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.datosRappelProvArt(curRappelProvArtOrigen,campos[i])) {
				return false;
			}
		}

		if (!this.iface.curRappelProvArt.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function rappel_datosRappelProvArt(cursorOrigen:FLSqlCursor,campo:String):Boolean
{
	if (!campo || campo == "") {
		return false;
	}
	switch (campo) {
		case "id":
		case "idrappel": {
			return true;
			break;
		}
		default: {
			if (cursorOrigen.isNull(campo)) {
				this.iface.curRappelProvArt.setNull(campo);
			} else {
				this.iface.curRappelProvArt.setValueBuffer(campo, cursorOrigen.valueBuffer(campo));
			}
		}
	}

	return true;
}

function rappel_copiarAnexosArticuloProv(idArtProvOrigen:String, idArtProvNuevo:String):Boolean
{
	if (!this.iface.__copiarAnexosArticuloProv(idArtProvOrigen, idArtProvNuevo)) {
		return false;
	}

	if (!this.iface.copiarTablaRappelProvArt(idArtProvOrigen, idArtProvNuevo)) {
		return false;
	}
	return true;
}
//// RAPPEL /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////

