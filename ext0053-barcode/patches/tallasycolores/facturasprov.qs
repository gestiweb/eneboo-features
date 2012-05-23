
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

	var curLineas:FLSqlCursor = this.child("tdbLineasFacturasProv").cursor();
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
		case cursor.Edit: {
			if (cursor.valueBuffer("automatica"))
				habilitar = false;
			break;
		}
		case cursor.Browse: {
			habilitar = false;
			break;
		}
	}

	if (!formRecordalbaranesprov.iface.pub_lineasTallaColor("lineasfacturasprov", "idfactura", cursor.valueBuffer("idfactura"), referencia, habilitar))
		return;

	this.iface.calcularTotales();
	this.child("tdbLineasFacturasProv").refresh();
}

//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

