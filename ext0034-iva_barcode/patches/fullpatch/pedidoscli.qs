
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial {
    function barCode( context ) { oficial ( context ); }
	function init() {
		return this.ctx.barCode_init();
	}
	function lineasTallaColor_clicked() {
		return this.ctx.barCode_lineasTallaColor_clicked();
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_init()
{
	this.iface.__init();
	connect(this.child("tbnTallasCol"), "clicked()", this, "iface.lineasTallaColor_clicked");
}

function barCode_lineasTallaColor_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String;

	var curLineas:FLSqlCursor = this.child("tdbLineasPedidosCli").cursor();
	referencia = curLineas.valueBuffer("referencia");
	var habilitar:Boolean = true;
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			curLineas.setModeAccess(curLineas.Insert);
			if (!curLineas.refreshBuffer())
				return false;
			if (!curLineas.commitBufferCursorRelation())
				return false;
			break;
		}
		case cursor.Browse: {
			habilitar = false;
			break;
		}
	}

	if (!formRecordalbaranescli.iface.pub_lineasTallaColor("lineaspedidoscli", "idpedido", cursor.valueBuffer("idpedido"), referencia, habilitar))
		return;

	this.iface.calcularTotales();
	this.child("tdbLineasPedidosCli").refresh();
}

//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

