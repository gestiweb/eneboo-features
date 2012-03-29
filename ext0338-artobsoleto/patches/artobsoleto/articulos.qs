
/** @class_declaration artObsoletos */
/////////////////////////////////////////////////////////////////
//// ART OBSOLETOS //////////////////////////////////////////////
class artObsoletos extends oficial /** %from: oficial */
{
	function artObsoletos( context ) { oficial ( context ); }
	function calculateField(fN:String) {
		return this.ctx.artObsoletos_calculateField(fN);
	}
	function bufferChanged(fN:String) {
		return this.ctx.artObsoletos_bufferChanged(fN);
	}
	function validateForm():Boolean {
		return this.ctx.artObsoletos_validateForm();
	}
}
//// ART OBSOLETOS //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artObsoletos */
/////////////////////////////////////////////////////////////////
//// ART OBSOLETOS //////////////////////////////////////////////

function artObsoletos_bufferChanged(fN:String)
{
  	this.iface.__bufferChanged();

	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		case "obsoleto": {
			var fecha:String = this.iface.calculateField("fechaobsoleto");
			debug("fecha -> " + fecha);
			this.child("fdbFechaObsoleto").setValue(fecha);
			if (fecha == "NAN") {
				cursor.setNull("fechaobsoleto");
			}
			break;
		}
	}
}

function artObsoletos_calculateField(fN:String):String
{
	this.iface.__calculateField();

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var res:String;

	switch (fN) {
		case "fechaobsoleto": {
			if (cursor.valueBuffer("obsoleto")) {
				var hoy:Date = new Date;
				res = hoy.toString();
			} else
				res = "NAN";
			break;
		}
	}
	return res;
}

function artObsoletos_validateForm():Boolean
{
	this.iface.__validateForm();

	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	/** \C Si el artículo está obsoleto, la fecha de comienzo de la baja debe estar informada
	\end */
	if (cursor.valueBuffer("obsoleto") && cursor.isNull("fechaobsoleto")) {
		MessageBox.warning(util.translate("scripts", "Si el artículo está obsoleto debº1e introducir la correspondiente fecha de inicio de la baja"), MessageBox.Ok, MessageBox.NoButton)
		return false;
	}

	return true;
}

//// ART OBSOLETOS //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

