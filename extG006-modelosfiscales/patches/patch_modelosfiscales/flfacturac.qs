
/** @class_declaration modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
class modelo347 extends oficial /** %from: oficial */ {
	function modelo347( context ) { oficial ( context ); }
	function datosAsientoRegenerado(cur:FLSqlCursor, valoresDefecto:Array):Boolean {
		return this.ctx.modelo347_datosAsientoRegenerado(cur, valoresDefecto);
	}
	function cambiarCampoRegistroBloqueado(tabla:String, campoClave:String, valorClave:String, campo:String, valor:String, campoUnlock:String):Boolean {
		return this.ctx.modelo347_cambiarCampoRegistroBloqueado(tabla, campoClave, valorClave, campo, valor, campoUnlock);
	}
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubModelo347 */
/////////////////////////////////////////////////////////////////
//// PUB MODELO 347 /////////////////////////////////////////////
class pubModelo347 extends ifaceCtx /** %from: ifaceCtx */ {
	function pubModelo347( context ) { ifaceCtx( context ); }
	function pub_cambiarCampoRegistroBloqueado(tabla:String, campoClave:String, valorClave:String, campo:String, valor:String, campoUnlock:String):Boolean {
		return this.cambiarCampoRegistroBloqueado(tabla, campoClave, valorClave, campo, valor, campoUnlock);
	}
}
//// PUB MODELO 347 /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo347 */
/////////////////////////////////////////////////////////////////
//// MODELO 347 /////////////////////////////////////////////////
function modelo347_datosAsientoRegenerado(cur:FLSqlCursor, valoresDefecto:Array):Boolean
{
	switch (cur.table()) {
		case "facturascli":
		case "facturasprov": {
			this.iface.curAsiento_.setValueBuffer("nomodelo347", cur.valueBuffer("nomodelo347"));
			break;
		}
	}
	return true;
}

function modelo347_cambiarCampoRegistroBloqueado(tabla:String, campoClave:String, valorClave:String, campo:String, valor:String, campoUnlock:String):Boolean
{
	var cursor:FLSqlCursor = new FLSqlCursor(tabla);
	cursor.setActivatedCommitActions(false);
	cursor.setActivatedCheckIntegrity(false);
	var whereRegistro:String = campoClave + " = " + valorClave;
	cursor.select(whereRegistro);
	if (!cursor.first()) {
		return false;
	}
	var editable:Boolean = cursor.valueBuffer(campoUnlock);
	if (!editable) {
		cursor.setUnLock(campoUnlock, true);
		cursor.select(whereRegistro);
		if (!cursor.first()) {
			return false;
		}
	}
	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
	cursor.setValueBuffer(campo, valor);
	if (!cursor.commitBuffer()) {
		return false;
	}
	if (!editable) {
		cursor.select(whereRegistro);
		if (!cursor.first()) {
			return false;
		}
		cursor.setUnLock(campoUnlock, false);
	}
	return true;
}
//// MODELO 347 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

