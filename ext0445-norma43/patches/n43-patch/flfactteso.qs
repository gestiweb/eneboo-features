
/** @class_declaration norma43 */
/////////////////////////////////////////////////////////////////
//// NORMA 43////////////////////////////////////////////////////
class norma43 extends remesaProv /** %from: remesaProv */ {
    function norma43( context ) { remesaProv ( context ); }
    function afterCommit_pagosdevolcli(curPD) {
		return this.ctx.norma43_afterCommit_pagosdevolcli(curPD);
	}
	function afterCommit_pagosdevolprov(curPD) {
		return this.ctx.norma43_afterCommit_pagosdevolprov(curPD);
	}
	function comprobarMovimientoPDN43(curPD) {
		return this.ctx.norma43_comprobarMovimientoPDN43(curPD);
	}
}
//// NORMA 43////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition norma43 */
/////////////////////////////////////////////////////////////////
//// NORMA 43 ///////////////////////////////////////////////////
function norma43_afterCommit_pagosdevolcli(curPD)
{
	if (!this.iface.__afterCommit_pagosdevolcli(curPD)) {
		return false;
	}
	if (!this.iface.comprobarMovimientoPDN43(curPD)) {
		return false;
	}
	return true;
}

function norma43_afterCommit_pagosdevolprov(curPD)
{
	if (!this.iface.__afterCommit_pagosdevolprov(curPD)) {
		return false;
	}
	if (!this.iface.comprobarMovimientoPDN43(curPD)) {
		return false;
	}
	return true;
}

function norma43_comprobarMovimientoPDN43(curPD)
{
	if (curPD.modeAccess() != curPD.Del) {
		return true;
	}
	var util = new FLUtil;
	var accion = curPD.table();
	if (!util.sqlUpdate("n43_movimientos", "codcasacion,accioncasacion", "0,NULL", "accioncasacion = '" + accion + "' AND codcasacion = '" + curPD.valueBuffer("idpagodevol") + "'")) {
		return false;
	}
	return true;
}
//// NORMA 43 ///////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

