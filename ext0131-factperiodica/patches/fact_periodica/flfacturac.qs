
/** @class_declaration factPeriodica */
//////////////////////////////////////////////////////////////////
//// FACTURACION_PERIODICA /////////////////////////////////////////////////////
class factPeriodica extends funServiciosCli /** %from: oficial */ {
	function factPeriodica( context ) { funServiciosCli( context ); }
	function beforeCommit_facturascli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.factPeriodica_beforeCommit_facturascli(curFactura);
	}
	function beforeCommit_periodoscontratos(curFactura:FLSqlCursor):Boolean {
		return this.ctx.factPeriodica_beforeCommit_periodoscontratos(curFactura);
	}
}
//// FACTURACION_PERIODICA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition factPeriodica */
/////////////////////////////////////////////////////////////////
//// FACTURACION_PERIODICA /////////////////////////////////////////////////

/** \D Si la factura está asociada a un periodo o periodos y se elimina,
se desvincula el periodo
*/
function factPeriodica_beforeCommit_facturascli(curFactura:FLSqlCursor):Boolean
{
	if (curFactura.modeAccess() == curFactura.Del) {
		var curTab:FLSqlCursor = new FLSqlCursor("periodoscontratos");
		curTab.select("idfactura = " + curFactura.valueBuffer("idfactura"));
		while(curTab.next()) {
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
			curTab.setNull("idfactura");
			curTab.setValueBuffer("facturado", false);
			if (!curTab.commitBuffer()) {
				return false;
			}
		}
	}

	return this.iface.__beforeCommit_facturascli(curFactura);
}

/** \D Si la el periodo está facturado no se puede eliminar
*/
function factPeriodica_beforeCommit_periodoscontratos(curP:FLSqlCursor):Boolean
{
	if (curP.modeAccess() == curP.Del) {
		var util:FLUtil = new FLUtil();
		if (util.sqlSelect("facturascli", "idfactura", "idfactura = " + curP.valueBuffer("idfactura"))) {
			MessageBox.warning(util.translate("scripts", "Para eliminar el período debe eliminar antes la factura asociada"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	return true;
}

//// FACTURACION_PERIODICA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

