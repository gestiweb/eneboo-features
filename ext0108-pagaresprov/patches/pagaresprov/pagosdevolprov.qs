
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARES PROV ///////////////////////////////////////////////
class pagareProv extends proveed /** %from: proveed */ {
    function pagareProv( context ) { proveed ( context ); }
	function init() {
		return this.ctx.pagareProv_init();
	}
}
//// PAGARES PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
function pagareProv_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var idPagare:String = cursor.valueBuffer("idpagare");
	if (idPagare && idPagare != "") {
		var numPagare:String = util.sqlSelect("pagaresprov", "numero", "idpagare = " + idPagare);
		if (numPagare) {
			this.child("lblPagare").text = util.translate("scripts", "En pagaré: %1").arg(numPagare);
		}
	}
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

