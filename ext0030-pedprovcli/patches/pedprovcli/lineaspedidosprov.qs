
/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends oficial /** %from: oficial */ {
    function pedProvCli( context ) { oficial ( context ); }
	function init() {
		return this.ctx.pedProvCli_init();
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedProvCli*/
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
function pedProvCli_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Edit:
		case cursor.Browse: {
			var codPedidoCli:String = util.sqlSelect("lineaspedidoscli lp INNER JOIN pedidoscli p ON lp.idpedido = p.idpedido", "p.codigo", "lp.idlinea = " + cursor.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");
			if (codPedidoCli)
				this.child("lblPedidoCli").text = util.translate("scripts", "Pedido de cliente: ") + codPedidoCli;
			break;
		}
	}
}

//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

