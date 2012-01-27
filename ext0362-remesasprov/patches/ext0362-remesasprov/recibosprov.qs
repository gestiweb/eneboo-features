
/** @class_declaration remesas */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
class remesas extends proveed /** %from: proveed */ {
    function remesas( context ) { proveed ( context ); }
	function cambiarEstado() {
		return this.ctx.remesas_cambiarEstado();
	}
}
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition remesas */
/////////////////////////////////////////////////////////////////
//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function remesas_cambiarEstado()
{
	this.iface.__cambiarEstado();
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	if (util.sqlSelect("pagosdevolprov", "idremesa", "idrecibo = " + cursor.valueBuffer("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC") != 0) {
		this.child("lblRemesado").text = "REMESADO";
		this.child("fdbFechav").setDisabled(true);
		this.child("fdbImporte").setDisabled(true);
		this.child("fdbCodCuenta").setDisabled(true);
		//this.child("coddir").setDisabled(true);
		this.child("tdbPagosDevolProv").setInsertOnly(true);
		this.child("pushButtonNext").close();
		this.child("pushButtonPrevious").close();
		this.child("pushButtonFirst").close();
		this.child("pushButtonLast").close();
	}
}

//// REMESAS DE RECIBOS DE PROVEEDOR ////////////////////////////
/////////////////////////////////////////////////////////////////

