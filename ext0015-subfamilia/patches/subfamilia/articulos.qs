
/** @class_declaration sfamilia */
//////////////////////////////////////////////////////////////////
//// SUBFAMILIA //////////////////////////////////////////////////
class sfamilia extends oficial {
    function sfamilia( context ) { oficial( context ); } 
	function bufferChanged(fN:String){return this.ctx.sfamilia_bufferChanged(fN);}
	function calculateField(fN:String):Number{return this.ctx.sfamilia_calculateField(fN);}
	function validateForm():Boolean {return this.ctx.sfamilia_validateForm();}
}
//// SUBFAMILIA //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition sfamilia */
/////////////////////////////////////////////////////////////////
//// SUBFAMILIA /////////////////////////////////////////////////
function sfamilia_bufferChanged(fN:String)
{
	switch (fN) {
		case "codsubfamilia":
			this.child("fdbCodFamilia").setValue(this.iface.calculateField("codfamilia"));
			break;
		default:
			this.iface.__bufferChanged(fN);
	}
}

function sfamilia_calculateField(fN:String):Number
{
	var util:FLUtil = new FLUtil();
	var valor:Number;

	switch (fN) {
		case "codfamilia": {
			valor =  util.sqlSelect("subfamilias", "codfamilia", "codsubfamilia='" + this.cursor().valueBuffer("codsubfamilia") + "';");
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}

function sfamilia_validateForm():Boolean 
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (!this.iface.__validateForm())
		return false;
	
	var codFamilia:String = cursor.valueBuffer("codfamilia");
	var codSubfamilia:String = cursor.valueBuffer("codsubfamilia");
	
	if (!codFamilia || !codSubfamilia) return true;
	
	var codFamiliaSF:String = util.sqlSelect("subfamilias", "codfamilia", "codsubfamilia='" + codSubfamilia + "';");
	
	if (codFamiliaSF != codFamilia) {
		MessageBox.critical(util.translate("scripts", "La subfamilia no pertenece a la familia"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

//// SUBFAMILIA /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
