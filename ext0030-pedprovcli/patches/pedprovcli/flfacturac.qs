
/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends oficial /** %from: oficial */ {
    function pedProvCli( context ) { oficial ( context ); }
	function beforeCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_lineaspedidoscli(curLP);
	}
	function beforeCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_lineaspedidosprov(curLP);
	}
	function beforeCommit_pedidoscli(curPedido:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_pedidoscli(curPedido);
	}
	function beforeCommit_pedidosprov(curPedido:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_pedidosprov(curPedido);
	}
	function afterCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_afterCommit_lineaspedidoscli(curLP);
	}
	function afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_afterCommit_lineaspedidosprov(curLP);
	}
	function estadoPedidoCliProv(idPedido:String):String {
		return this.ctx.pedProvCli_estadoPedidoCliProv(idPedido);
	}
	function actualizarCampoPedidoPedCli(idPedido:String):Boolean {
		return this.ctx.pedProvCli_actualizarCampoPedidoPedCli(idPedido);
	}
	function actualizarEstadoPedidoProv(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_actualizarEstadoPedidoProv(idPedido, curAlbaran);
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPedCliProv */
/////////////////////////////////////////////////////////////////
//// PUB PED CLI PROV ///////////////////////////////////////////
class pubPedCliProv extends ifaceCtx /** %from: ifaceCtx */ {
	function pubPedCliProv( context ) { ifaceCtx( context ); }
	function pub_estadoPedidoCliProv(idPedido:String):String {
		return this.estadoPedidoCliProv(idPedido);
	}
}
//// PUB PED CLI PROV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
function pedProvCli_beforeCommit_pedidoscli(curPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
// 	if (!curPedido.isNull("idpedidoprov")) {
	var codPedidoProv:String = util.sqlSelect("pedidosprov p INNER JOIN lineaspedidosprov lp ON p.idpedido = lp.idpedido","p.codigo","lp.idlineacli IN (select idlinea FROM lineaspedidoscli WHERE idpedido = " + curPedido.valueBuffer("idpedido") + ")","pedidosprov,lineaspedidosprov");

	if (codPedidoProv) {
		var res:Number;
		switch (curPedido.modeAccess()) {
			/** \C Quita los datos del pedido de proveedor en caso de que ninguna de sus líneas esté asociada a dicho pedido.
			\end */
			case curPedido.Edit: {
				if (!util.sqlSelect("lineaspedidoscli", "idlinea", "idpedido = " + curPedido.valueBuffer("idpedido") + " AND idlineaprov IS NOT NULL")) {
					curPedido.setNull("codpedidoprov");
					curPedido.setNull("idpedidoprov");
				}
				break;
			}
			/** \C Avisa al usuario de que intenta borrar un pedido asociado a un pedido de proveedor. Si el usuario decide borrar el pedido, se eliminan las referencias del mismo en las correspondientes líneas de pedido de proveedor.
			\end */
			case curPedido.Del: {
				res = MessageBox.information(util.translate("scripts", "Va a eliminar un pedido asociado al pedido de proveedor ") + codPedidoProv + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
				if (res != MessageBox.Yes)
					return false;

				var curLineasCli:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
				curLineasCli.select("idpedido = " + curPedido.valueBuffer("idpedido"));
				while (curLineasCli.next()) {

					curLineasCli.setModeAccess(curLineasCli.Edit);
					curLineasCli.refreshBuffer();

					var idLineaProv:Number = util.sqlSelect("lineaspedidosprov","idlinea","idlineacli = " + curLineasCli.valueBuffer("idlinea"));

					if (!util.sqlUpdate("lineaspedidosprov", "idlineacli", "NULL", "idlinea = " + idLineaProv))
						return false;

					curLineasCli.setNull("idlineaprov");
					if (!curLineasCli.commitBuffer())
						return false;
				}
				break;
			}
		}
	}
	if (!interna_beforeCommit_pedidoscli(curPedido))
		return false;

	return true;
}

function pedProvCli_beforeCommit_pedidosprov(curPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var res:Number;
	switch (curPedido.modeAccess()) {
		/** \C Avisa al usuario de que intenta borrar un pedido asociado a uno o más pedidos de cliente. Si el usuario decide borrar el pedido, se eliminan las referencias del mismo en las correspondientes líneas de pedido de cliente.
		\end */
		case curPedido.Del: {
			var codPedidoCli:String = util.sqlSelect("lineaspedidosprov lp INNER JOIN lineaspedidoscli lc ON lp.idlineacli = lc.idlinea INNER JOIN pedidoscli p ON lc.idpedido = p.idpedido", "p.codigo", "lp.idpedido = " + curPedido.valueBuffer("idpedido") + " AND lp.idlineacli IS NOT NULL", "lineaspedidosprov,lineaspedidoscli,pedidoscli");
			if (!codPedidoCli)
				break;
			res = MessageBox.information(util.translate("scripts", "Va a eliminar un pedido asociado al menos al pedido de cliente ") + codPedidoCli + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;

// 			var curLineasProv:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
// 			curLineasProv.select("idpedido = " + curPedido.valueBuffer("idpedido"));
//
// 			var idLineaCli:String;
// 			var idPedidoCli:String;
// 			while (curLineasProv.next()) {
// 				curLineasProv.setModeAccess(curLineasProv.Edit);
// 				curLineasProv.refreshBuffer();
// 				idLineaCli = curLineasProv.valueBuffer("idlineacli");
// 				if (!idLineaCli || idLineaCli == 0)
// 					continue;
//
// 				if (!util.sqlUpdate("lineaspedidoscli", "idlineaprov", "NULL", "idlinea = " + idLineaCli))
// 					return false;
//
// 				curLineasProv.setNull("idlineacli");
// 				if (!curLineasProv.commitBuffer())
// 					return false;
//
// 				idPedidoCli = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + idLineaCli);
// 				if (!util.sqlSelect("lineaspedidoscli", "idlinea", "idpedido = " + idPedidoCli + " AND idlineaprov IS NOT NULL")) {
// 					if (!util.sqlUpdate("pedidoscli", "codpedidoprov,idpedidoprov", "NULL,NULL", "idpedido = " + idPedidoCli))
// 						return false;
// 				}
// 			}
			break;
		}
	}

	if (!interna_beforeCommit_pedidosprov(curPedido))
		return false;

	return true;
}


/** \C Avisa al usuario en caso de que intente modificar o borrar una línea de pedido de cliente asociada a una línea de pedido de proveedor
\end */
function pedProvCli_beforeCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var idLineaProv:Number = util.sqlSelect("lineaspedidosprov","idlinea","idlineacli = " + curLP.valueBuffer("idlinea"));

	if (idLineaProv) {
		var codPedidoProv:String = util.sqlSelect("pedidosprov p INNER JOIN lineaspedidosprov lp ON p.idpedido = lp.idpedido", "p.codigo", "lp.idlinea = " + idLineaProv, "pedidosprov,lineaspedidosprov");
		var res:Number;
		switch (curLP.modeAccess()) {
			case curLP.Edit: {
				if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia") || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad") || curLP.valueBuffer("cerrada") != curLP.valueBufferCopy("cerrada")) {
					res = MessageBox.information(util.translate("scripts", "Va a modificar una línea de pedido que está asociada al pedido de proveedor ") + codPedidoProv + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
					if (res != MessageBox.Yes)
						return false;
				}
				break;
			}
			case curLP.Del: {
				res = MessageBox.information(util.translate("scripts", "Va a eliminar una línea de pedido que está asociada al pedido de proveedor ") + codPedidoProv + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
				if (res != MessageBox.Yes)
					return false;
				if (!util.sqlUpdate("lineaspedidosprov", "idlineacli", "NULL", "idlinea = " + idLineaProv))
					return false;

				break;
			}
		}
	}

	/*
	if (!this.iface.__beforeCommit_lineaspedidoscli(curLP))
		return false;
	*/

	return true;
}

/** \C Avisa al usuario en caso de que intente modificar o borrar una línea de pedido de proveedor asociada a una línea de pedido de cliente
\end */
function pedProvCli_beforeCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!curLP.isNull("idlineacli")) {
		var res:Number;
		switch (curLP.modeAccess()) {
			case curLP.Insert: {
				var otraLinea:Number = util.sqlSelect("lineaspedidosprov","idlinea","idlineacli = " + curLP.valueBuffer("idlineacli") + " AND idlinea  <> " + curLP.valueBuffer("idlinea"));
				if (otraLinea) {
					var cliente:String = util.sqlSelect("pedidoscli p INNER JOIN lineaspedidoscli l ON l.idpedido = p.idpedido", "p.codigo", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli") + " - " + util.sqlSelect("pedidoscli p INNER JOIN lineaspedidoscli l ON l.idpedido = p.idpedido", "p.nombrecliente", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");
					var proveedor:String = util.sqlSelect("pedidosprov","codigo","idpedido = " + curLP.valueBuffer("idpedido")) + " - " + util.sqlSelect("pedidosprov","nombre","idpedido = " + curLP.valueBuffer("idpedido"));

					res = MessageBox.information(util.translate("scripts", "El pedido de cliente %1\nque intenta asociar ya está asociado al pedido de proveedor %2\n¿Desea continuar?").arg(cliente).arg(proveedor), MessageBox.Yes, MessageBox.No);
					if (res != MessageBox.Yes)
						return false;
				}
				break;
			}
			case curLP.Edit: {
				if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia") || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad") || curLP.valueBuffer("cerrada") != curLP.valueBufferCopy("cerrada")) {
					var codPedidoCli:String = util.sqlSelect("lineaspedidoscli l INNER JOIN pedidoscli p ON l.idpedido = p.idpedido", "p.codigo", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");

					res = MessageBox.information(util.translate("scripts", "Va a modificar una línea de pedido que está asociada al pedido de cliente ") + codPedidoCli + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
					if (res != MessageBox.Yes)
						return false;
				}
				break;
			}
			case curLP.Del: {
				var codPedidoCli:String = util.sqlSelect("lineaspedidoscli l INNER JOIN pedidoscli p ON l.idpedido = p.idpedido", "p.codigo", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");

				res = MessageBox.information(util.translate("scripts", "Va a eliminar una línea de pedido que está asociada al pedido de cliente ") + codPedidoCli + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
				if (res != MessageBox.Yes)
					return false;



				break;
			}
		}
	}
	/*
	if (!this.iface.__beforeCommit_lineaspedidosprov(curLP))
		return false;
	*/
	return true;
}

/** \C Actualiza el estado del campo  pedido para los pedidos de cliente asociados a la línea afectada
\end */
function pedProvCli_afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
debug("idLineaCli  = " + curLP.valueBuffer("idlineacli"));
	if (!curLP.isNull("idlineacli")) {
		var res:Number;
		switch (curLP.modeAccess()) {
			case curLP.Edit: {
				if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia") || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad") || curLP.valueBuffer("cerrada") != curLP.valueBufferCopy("cerrada")) {
					var idPedido:String = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + curLP.valueBuffer("idlineacli"));
					if (idPedido) {
						if (!this.iface.actualizarCampoPedidoPedCli(idPedido)) {
							return false;
						}
					}
				}
				break;
			}
			case curLP.Del: {
				var idPedidoCli:String = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + curLP.valueBuffer("idlineacli"));
debug("DEL idPedidoCli = " + idPedidoCli);
				if (!util.sqlUpdate("lineaspedidoscli", "idlineaprov", "NULL", "idlinea = " + curLP.valueBuffer("idlineacli"))) {
					return false;
				}
				if (idPedidoCli) {
					if (!util.sqlSelect("lineaspedidoscli", "idlinea", "idpedido = " + idPedidoCli + " AND idlineaprov IS NOT NULL")) {
						if (!util.sqlUpdate("pedidoscli", "codpedidoprov,idpedidoprov", "NULL,NULL", "idpedido = " + idPedidoCli)) {
							return false;
						}
					}
					if (!this.iface.actualizarCampoPedidoPedCli(idPedidoCli)) {
						return false;
					}
				}
				break;
			}
		}
	}

	if (!this.iface.__afterCommit_lineaspedidosprov(curLP)) {
		return false;
	}

	return true;
}

/** \D Actualiza el campo pedido de un pedido de cliente
@param	idPedido: Identificador del pedido de cliente
\end */
function pedProvCli_actualizarCampoPedidoPedCli(idPedido:String):Boolean
{
	var curPedido:FLSqlCursor = new FLSqlCursor("pedidoscli");
	curPedido.setActivatedCommitActions(false);
	curPedido.select("idpedido = " + idPedido);
	if (!curPedido.first()) {
		return false;
	}
	var editable:Boolean = curPedido.valueBuffer("editable");
	if (!editable) {
		curPedido.setUnLock("editable", true);
		curPedido.select("idpedido = " + idPedido);
		if (!curPedido.first()) {
			return false;
		}
	}

	var estado:String = this.iface.estadoPedidoCliProv(idPedido);
	if (!estado) {
		return false;
	}
	curPedido.setModeAccess(curPedido.Edit);
	curPedido.refreshBuffer();
	curPedido.setValueBuffer("pedido", estado);
	if (!curPedido.commitBuffer()) {
		return false;
	}

	if (!editable) {
		curPedido.select("idpedido = " + idPedido);
		if (!curPedido.first()) {
			return false;
		}
		curPedido.setUnLock("editable", false);
	}

	return true;
}

function pedProvCli_afterCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
/*
	var curPedido:FLSqlCursor = curLP.cursorRelation();
	if (!curPedido) {
*/
		var idPedido:String = curLP.valueBuffer("idpedido");
		var estadoPedido:String = this.iface.estadoPedidoCliProv(idPedido);
		if (!estadoPedido)
			return false;
		if (!util.sqlUpdate("pedidoscli", "pedido", estadoPedido, "idpedido = " + idPedido))
			return false;
//	}

	if (!this.iface.__afterCommit_lineaspedidoscli(curLP))
		return false;

	return true;
}

/** \C Indica si el pedido de cliente está pedido, no está pedido o está parcialmente pedido al proveedor \end */
function pedProvCli_estadoPedidoCliProv(idPedido:String):String
{
	var hayLineasCon:Boolean = false;
	var hayLineasSin:Boolean = false;
	var res:String = "";

	var qryLineas:FLSqlQuery = new FLSqlQuery();
	qryLineas.setTablesList("pedidoscli,lineaspedidoscli,lineaspedidosprov");
	qryLineas.setSelect("p.codalmacen, lpc.referencia, lpc.idlinea, lpc.cantidad, SUM(CASE WHEN lpp.cerrada THEN lpp.totalenalbaran ELSE lpp.cantidad END)");
	qryLineas.setFrom("pedidoscli p INNER JOIN lineaspedidoscli lpc ON p.idpedido = lpc.idpedido LEFT OUTER JOIN lineaspedidosprov lpp ON lpc.idlinea = lpp.idlineacli");
	qryLineas.setWhere("p.idpedido = " + idPedido + " GROUP BY p.codalmacen, lpc.referencia, lpc.idlinea, lpc.cantidad");
debug(qryLineas.sql());
	if ( !qryLineas.exec() ) {
		return "Sí";
	}
	var canCliente:Number, canProveedor:Number, canStock:Number;
	var referencia:String;
	while ( qryLineas.next() ) {
		referencia = qryLineas.value("lpc.referencia");
		if (!referencia || referencia == "") {
			continue;
		}
		canCliente = parseFloat(qryLineas.value("lpc.cantidad"));
		canProveedor = parseFloat(qryLineas.value("SUM(CASE WHEN lpp.cerrada THEN lpp.totalenalbaran ELSE lpp.cantidad END)"));
		if (isNaN(canProveedor)) {
			canProveedor = 0;
		}
		if (canProveedor >= canCliente) {
			hayLineasCon = true;
		} else {
			if (canProveedor > 0) {
				hayLineasCon = true;
			}
			hayLineasSin = true;
		}
	}

	if ( hayLineasSin && !hayLineasCon ) {
		res = "No";
	} else if ( !hayLineasSin && hayLineasCon ) {
		res = "Sí";
	} else {
		res = "Parcial";
	}

	return res;
}

function pedProvCli_actualizarEstadoPedidoProv(idPedido:Number, curAlbaran:FLSqlCursor):Boolean
{
	var util:FLUtil;

	var estado:String = this.iface.obtenerEstadoPedidoProv(idPedido);
	if (estado == "Sí" && util.sqlSelect("pedidosprov","abierto","idpedido = " + idPedido)) {
		var curPedido:FLSqlCursor = new FLSqlCursor("pedidosprov");
		curPedido.select("idpedido = " + idPedido);
		if (curPedido.first()) {
			curPedido.setModeAccess(curPedido.Edit);
			curPedido.refreshBuffer()
				curPedido.setValueBuffer("abierto", false);
			if (!curPedido.commitBuffer())
				return false;
		}
	}

	if(!this.iface.__actualizarEstadoPedidoProv(idPedido, curAlbaran))
		return false;

	return true;
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

