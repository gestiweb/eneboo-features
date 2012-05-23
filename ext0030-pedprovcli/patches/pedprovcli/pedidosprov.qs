
/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends oficial /** %from: oficial */ {
    function pedProvCli( context ) { oficial( context ); }
	function init() {
		return this.ctx.pedProvCli_init();
	}
	function tbnPedidosCli_clicked() {
		return this.ctx.pedProvCli_tbnPedidosCli_clicked();
	}
	function asociarPedidoCli(idPedidoCli:String, curPedidoProv:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_asociarPedidoCli(idPedidoCli, curPedidoProv);
	}
	function actualizarCodPedidoCli() {
		return this.ctx.pedProvCli_actualizarCodPedidoCli();
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
	connect(this.child("tbnPedidosCli"), "clicked()", this, "iface.tbnPedidosCli_clicked");
	this.iface.actualizarCodPedidoCli();
}

function pedProvCli_tbnPedidosCli_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.modeAccess() == cursor.Insert) {
		var curLineas:FLSqlCursor = this.child("tdbArticulosPedProv").cursor();
		curLineas.setModeAccess(curLineas.Insert);
		if (!curLineas.commitBufferCursorRelation())
			return false;
	}

	var f:Object = new FLFormSearchDB("buscapedcli");
	var curPedidosCli:FLSqlCursor = f.cursor();

	curPedidosCli.setMainFilter(formpedidosprov.iface.filtroPedidosCli());
	f.setMainWidget();
	var idPedido:String = f.exec("idpedido");
	if (idPedido) {

		var codPedidoProv:String = util.sqlSelect("pedidoscli", "codpedidoprov", "idpedido = " + idPedido + " AND idpedidoprov <> " + this.cursor().valueBuffer("idpedido"));
		if (codPedidoProv) {
			res = MessageBox.warning(util.translate("scripts", "Este pedido de cliente ya se encuentra asociado al pedido de proveedor %0\n¿Desea continuar?").arg(codPedidoProv), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
			if (res != MessageBox.Yes)
				return false;
		}

		if (!this.iface.asociarPedidoCli(idPedido, cursor))
			return false;

		this.iface.actualizarCodPedidoCli();
	}

	this.iface.calcularTotales();
	this.child("tdbArticulosPedProv").refresh();

}

/** \D Asocia las líneas de un pedido de cliente a un pedido de proveedor
@param	idPedidoCli: Identificador del pedido de cliente
@param	curPedidoProv: Cursor posicionado sobre el pedido de proveedor
@return	true si la asociación se realiza de forma correcta, false si hay error
\end */
function pedProvCli_asociarPedidoCli(idPedidoCli:String, curPedidoProv:FLSqlCursor):Boolean
{


	if (!formpedidosprov.iface.pub_copiarLineasPedidoProvCli(idPedidoCli, curPedidoProv.valueBuffer("idpedido")))
		return false;

	if(!formpedidosprov.iface.pub_asociarPedidoProvCli(idPedidoCli,curPedidoProv.valueBuffer("idpedido")))
		return false;


	return true;
}

function pedProvCli_actualizarCodPedidoCli()
{
	var util:FLUtil = new FLUtil();

	var qryPedidos:FLSqlQuery = new FLSqlQuery();
	qryPedidos.setTablesList("pedidoscli,lineaspedidoscli,lineaspedidosprov");
	qryPedidos.setSelect("pc.codigo");
	qryPedidos.setFrom("pedidoscli pc INNER JOIN lineaspedidoscli lpc on pc.idpedido = lpc.idpedido INNER JOIN lineaspedidosprov lpp ON lpc.idlinea = lpp.idlineacli");
	qryPedidos.setWhere("lpp.idpedido = " + this.cursor().valueBuffer("idpedido"));

	if (!qryPedidos.exec())
		return false;

	var pedidos:String = "";
	while (qryPedidos.next()) {
		if(pedidos.find(qryPedidos.value("pc.codigo")) >= 0)
			continue;
		if(pedidos != "")
			pedidos += ", ";
		pedidos += qryPedidos.value("pc.codigo");
	}

	if (pedidos && pedidos != "")
		this.child("leCodPedidoCli").text = pedidos;
}

//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

