
/** @class_declaration portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
class portes extends oficial /** %from: oficial */ {
    function portes( context ) { oficial ( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.portes_bufferChanged(fN);
	}
	function init() {
		return this.ctx.portes_init();
	}
	function controlIvaPortes() {
		return this.ctx.portes_controlIvaPortes();
	}
}
//// PORTES /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition portes */
/////////////////////////////////////////////////////////////////
//// PORTES /////////////////////////////////////////////////////
function portes_init()
{
	this.iface.__init(); /// Se llama antes para que el bufferChanged esté conectado antes de establecer el impuesto.

	var cursor:FLSqlCursor = this.cursor();
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			var codIvaPortes:String = flfactppal.iface.pub_valorDefectoEmpresa("codivaportes");
			if (codIvaPortes)
				this.child("fdbCodImpuestoPortes").setValue(codIvaPortes);
			this.iface.controlIvaPortes();
			break;
		}
		case cursor.Edit: {
			this.iface.controlIvaPortes();
			break;
		}
	}
}

function portes_bufferChanged(fN:String)
{
	var util:FLUtil = new FLUtil;
	switch (fN) {
		case "netoportes":
			this.child("fdbNeto").setValue(this.iface.calculateField("neto"));
			this.child("fdbTotalIvaPortes").setValue(this.iface.calculateField("totalivaportes"));
			this.child("fdbTotalRePortes").setValue(this.iface.calculateField("totalreportes"));
			this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			this.child("fdbTotalPortes").setValue(this.iface.calculateField("totalportes"));
			break;

		case "ivaportes":
			this.child("fdbTotalIvaPortes").setValue(this.iface.calculateField("totalivaportes"));
			this.child("fdbTotalIva").setValue(this.iface.calculateField("totaliva"));
			this.child("fdbTotalPortes").setValue(this.iface.calculateField("totalportes"));
			break;

		case "codimpuestoportes":
			this.child("fdbRePortes").setValue(this.iface.calculateField("reportes"));
			this.child("fdbIvaPortes").setValue(this.iface.calculateField("ivaportes"));
			break;

		case "reportes":
			this.child("fdbTotalRePortes").setValue(this.iface.calculateField("totalreportes"));
			this.child("fdbTotalRecargo").setValue(this.iface.calculateField("totalrecargo"));
			this.child("fdbTotalPortes").setValue(this.iface.calculateField("totalportes"));
			break;

		case "codserie":
		case "codcliente":
			this.child("fdbRePortes").setValue(this.iface.calculateField("reportes"));
			this.iface.controlIvaPortes();
			this.iface.__bufferChanged(fN);
			break;

		default:
			this.iface.__bufferChanged(fN);
			break;
	}
}

/** \C Inhabilita los controles de IVA de portes si el presupuesto no debe tener IVA
\end */
function portes_controlIvaPortes()
{
	if (flfacturac.iface.pub_tieneIvaDocCliente(this.cursor().valueBuffer("codserie"), this.cursor().valueBuffer("codcliente"))) {
		this.child("fdbCodImpuestoPortes").setDisabled(false);
		this.child("fdbIvaPortes").setDisabled(false);
		this.child("fdbRePortes").setDisabled(false);
	} else {
		this.child("fdbCodImpuestoPortes").setValue("");
		this.child("fdbIvaPortes").setValue(0);
		this.child("fdbRePortes").setValue(0);
		this.child("fdbCodImpuestoPortes").setDisabled(true);
		this.child("fdbIvaPortes").setDisabled(true);
		this.child("fdbRePortes").setDisabled(true);
	}
}

//// PORTES /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////

