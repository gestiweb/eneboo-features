
/** @class_declaration pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
class pagareProv extends oficial /** %from: oficial */ {
    var posActualPuntoSubcuentaP:Number;
	var bloqueoSubcuentaP:Boolean;
	function pagareProv( context ) { oficial ( context ); }
	function init() {
		this.ctx.pagareProv_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.pagareProv_bufferChanged(fN);
	}
}
//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagareProv */
/////////////////////////////////////////////////////////////////
//// PAGARE PROV ////////////////////////////////////////////////
function pagareProv_init()
{
	var cursor:FLSqlCursor = this.cursor();
	this.iface.__init();

	if (sys.isLoadedModule("flcontppal")) {
		this.iface.bloqueoSubcuentaP = false;
		this.iface.posActualPuntoSubcuentaP = -1;
		this.child("fdbIdSubcuentaP").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else {
		this.child("gbxPagares").enabled = false;
	}

	if (cursor.modeAccess() == cursor.Edit) {
		this.iface.bufferChanged("codsubcuentap");
	}
}

function pagareProv_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	if (fN == "codsubcuentap" && this.iface.contabilidadCargada) {
		if (!this.iface.bloqueoSubcuentaP) {
			this.iface.bloqueoSubcuentaP = true;
			this.iface.posActualPuntoSubcuentaP = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaP", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaP);
			this.iface.bloqueoSubcuentaP = false;
		}
	} else {
		this.iface.__bufferChanged(fN);
	}
}

//// PAGARE PROV ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

