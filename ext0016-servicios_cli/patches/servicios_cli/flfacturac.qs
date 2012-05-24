
/** @class_declaration funServiciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
class funServiciosCli extends oficial /** %from: oficial */ {
	function funServiciosCli( context ) { oficial ( context ); }
	function afterCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.funServiciosCli_afterCommit_albaranescli(curAlbaran);
	}
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
/** \C Si el albarán se borra se actualizan los pedidos asociados
\end */
function funServiciosCli_afterCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__afterCommit_albaranescli(curAlbaran)) {
		return false;
	}
	switch (curAlbaran.modeAccess()) {
		case curAlbaran.Del: {
			var idAlbaran:Number = curAlbaran.valueBuffer("idalbaran");
			if (idAlbaran) {
				var curServicio:FLSqlCursor = new FLSqlCursor("servicioscli");
				curServicio.select("idalbaran = " + idAlbaran);
				if (curServicio.first()) {
					curServicio.setUnLock("editable", true);
					curServicio.select("idalbaran = " + idAlbaran);
					curServicio.first();
					curServicio.setModeAccess(curServicio.Edit);
					curServicio.refreshBuffer();
					curServicio.setValueBuffer("idalbaran", "");
					curServicio.commitBuffer();
				}
			}
			break;
		}
	}
	return true;
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

