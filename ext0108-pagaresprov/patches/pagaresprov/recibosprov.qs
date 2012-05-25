
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARES PROV ///////////////////////////////////////////////
class pagareProv extends proveed /** %from: proveed */ {
    function pagareProv( context ) { proveed ( context ); }
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.pagareProv_commonCalculateField(fN, cursor);
	}
	function cambiarEstado() {
		return this.ctx.pagareProv_cambiarEstado();
	}
}
//// PAGARES PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function pagareProv_cambiarEstado()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.__cambiarEstado();

	if (util.sqlSelect("pagosdevolprov", "idpagare", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC") != 0) {
		this.child("lblRemesado").text = "EN PAGARÉ";
		this.child("fdbFechav").setDisabled(true);
		this.child("fdbImporte").setDisabled(true);
		this.child("fdbCodCuenta").setDisabled(true);
		this.child("fdbCodDir").setDisabled(true);
		this.child("tdbPagosDevolProv").setInsertOnly(true);
		this.child("pushButtonNext").close();
		this.child("pushButtonPrevious").close();
		this.child("pushButtonFirst").close();
		this.child("pushButtonLast").close();
	}
}

function pagareProv_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var valor:String;
	switch (fN) {
		case "estado": {
			valor = "Emitido";
			var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
			curPagosDevol.select("idrecibo = '" + cursor.valueBuffer("idrecibo") + "' ORDER BY fecha DESC, idpagodevol DESC");
			if (curPagosDevol.first()) {
				curPagosDevol.setModeAccess(curPagosDevol.Browse);
				curPagosDevol.refreshBuffer();
				var tipo:String = curPagosDevol.valueBuffer("tipo").toString();
				switch (tipo) {
					case "Pago": {
						valor = "Pagado";
						break;
					}
					case "Pagaré": {
						var estadoPagare:String = util.sqlSelect("pagaresprov", "estado", "idpagare = " + curPagosDevol.valueBuffer("idpagare"));
						switch (estadoPagare) {
							case "Pagado": {
								valor = "Pagado";
								break;
							}
							case "Devuelto": {
								valor = "Devuelto";
								break;
							}
							default: {
								valor = "Pagaré";
							}
						}
						break;
					}
					case "Pag.Anulado": {
						valor = "Emitido";
						break;
					}
					default: {
						valor = "Devuelto";
						break;
					}
				}
			}
			break;
		}
		default: {
			valor = this.iface.__commonCalculateField(fN);
		}
	}
	return valor;
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

