
/** @class_declaration envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
class envases extends oficial /** %from: oficial */ {
    function envases( context ) { oficial ( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.envases_bufferChanged(fN);
	}
	function calculateField(fN:String):String {
		return this.ctx.envases_calculateField(fN);
	}
	function refrescarStock() {
		return this.ctx.envases_refrescarStock();
	}
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envases */
/////////////////////////////////////////////////////////////////
//// ENVASES ////////////////////////////////////////////////////
function envases_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "codenvase": {
			this.child("fdbReferencia").setValue(this.iface.calculateField("referencia"));
			break;
		}
		case "cantenvases":
		case "valormetrico": {
			this.child("fdbCantidad").setValue(this.iface.calculateField("cantidad"));
			break;
		}
		default: {
 			this.iface.__bufferChanged(fN);
			break;
		}
	}
}

function envases_calculateField(fN:String):String
{
	var util:FLUtil;
	var valor:String = "";

	switch(fN) {
		case "referencia": {
			var codEnvase:String = this.cursor().valueBuffer("codenvase");
			if(!codEnvase || codEnvase == "") {
				break;
			}
			valor = util.sqlSelect("envases","referencia","codenvase = '" + codEnvase + "'");
			if(!valor)
				valor = "";
			break;
		}
		case "cantidad": {
			valor = "0";
			var envases:Number = parseFloat(this.cursor().valueBuffer("cantenvases"));
			if(!envases)
				break;
			var valorMet:Number = parseFloat(this.cursor().valueBuffer("valormetrico"));
			if(!valorMet)
				break;
			valor = parseFloat(envases*valorMet).toString();
			break;
		}
	}
	return valor;
}

function envases_refrescarStock()
{
	this.iface.__refrescarStock();

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var referencia:String = cursor.valueBuffer("referencia");

	if (!referencia || referencia == "") {
		this.child("lblCanInicialOrigenE").text = "-";
		this.child("lblCanFinalOrigenE").text = "-";
		this.child("lblCanInicialDestinoE").text = "-";
		this.child("lblCanFinalDestinoE").text = "-";
		return;
	}

	var valorMet:Number = parseFloat(cursor.valueBuffer("valormetrico"));
	if (!valorMet || valorMet== "") {
		valorMet = 1;
	}

	this.child("lblCanInicialOrigenE").text = parseFloat(this.child("lblCanInicialOrigen").text)/valorMet;
	this.child("lblCanFinalOrigenE").text = parseFloat(this.child("lblCanFinalOrigen").text)/valorMet;

	this.child("lblCanInicialDestinoE").text = parseFloat(this.child("lblCanInicialDestino").text)/valorMet;
	this.child("lblCanFinalDestinoE").text = parseFloat(this.child("lblCanFinalDestino").text)/valorMet;
}
//// ENVASES ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

