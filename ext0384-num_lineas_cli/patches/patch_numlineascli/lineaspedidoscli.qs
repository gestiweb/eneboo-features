
/** @class_declaration numLinea */
/////////////////////////////////////////////////////////////////
//// NUMEROS DE LÍNEA ///////////////////////////////////////////
class numLinea extends oficial /** %from: oficial */ {
    function numLinea( context ) { oficial ( context ); }
	function init() {
		return this.ctx.numLinea_init();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.numLinea_commonCalculateField(fN, cursor);
	}
}
//// NUMEROS DE LÍNEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition numLinea */
/////////////////////////////////////////////////////////////////
//// NÚMEROS DE LÍNEA ///////////////////////////////////////////
function numLinea_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			this.child("fdbNumLinea").setValue(this.iface.calculateField("numlinea"));
			break;
		}
	}
}

function numLinea_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;

	switch (fN) {
		case "numlinea": {
			var tabla:String = cursor.table();
			var idTabla:String;
			var campoId:String;
			switch (tabla) {
				case "lineaspresupuestoscli": {
					campoId = "idpresupuesto";
					idTabla = cursor.valueBuffer("idpresupuesto");
					break;
				}
				case "lineaspedidoscli": {
					campoId = "idpedido";
					idTabla = cursor.valueBuffer("idpedido");
					break;
				}
				case "lineasalbaranescli": {
					campoId = "idalbaran";
					idTabla = cursor.valueBuffer("idalbaran");
					break;
				}
				case "lineasfacturascli": {
					campoId = "idfactura";
					idTabla = cursor.valueBuffer("idfactura");
					break;
				}
			}
			valor = parseInt(util.sqlSelect(tabla, "numlinea", campoId + " = " + idTabla + " ORDER BY numlinea DESC"));
			if (isNaN(valor)) {
				valor = 0;
			}
			valor++;
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN, cursor);
		}
	}
	return valor;
}

//// NÚMEROS DE LÍNEA ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

