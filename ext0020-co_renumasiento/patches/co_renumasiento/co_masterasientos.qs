
/** @class_declaration renAsientos */
//////////////////////////////////////////////////////////////////
//// renAsientos ////////////////////////////////////////////////
class renAsientos extends oficial {
    function renAsientos( context ) { oficial( context ); } 
	function init() {
		return this.ctx.renAsientos_init();
	}
	function renumerarAsientos() {
		return this.ctx.renAsientos_renumerarAsientos();
	}
}
//// renAsientos/////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration renAsientosPub */
//////////////////////////////////////////////////////////////////
//// renAsientos_PUB/////////////////////////////////////////////
class renAsientosPub extends ifaceCtx {
    function renAsientosPub( context ) { ifaceCtx( context ); } 
		
	function pub_renumerarAsientos() {
		return this.renumerarAsientos();
	}
}
//// renAsientos_PUB/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition renAsientos */
//////////////////////////////////////////////////////////////////
//// renAsientos/////////////////////////////////////////////////
function renAsientos_init()
{
	this.iface.__init();
	connect(this.child("pbnRenum"), "clicked()", this, "iface.renumerarAsientos()");
}

function renAsientos_renumerarAsientos()
{
	var util:FLUtil = new FLUtil();
	var desEjercicio:String = util.sqlSelect("ejercicios", "nombre", "codejercicio = '" + this.iface.ejercicioActual + "'");
	var res:Number = MessageBox.information(util.translate("scripts", "Se va a proceder a renumerar todos los asientos del diario correspondientes al ejercicio:\n%1 - %2.\n\n¿Desea continuar?").arg(this.iface.ejercicioActual).arg(desEjercicio), MessageBox.No, MessageBox.Yes);

	if (res != MessageBox.Yes)
		return;
	
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var numAsiento:Number = 1;
	var rollback:Boolean = false;
	
	var curAsientos:FLSqlCursor = new FLSqlCursor("co_asientos");
	curAsientos.setActivatedCommitActions(false);
	curAsientos.select("codejercicio = '" + codEjercicio + "' order by fecha");
	var cursorBloqueado:FLSqlCursor = new FLSqlCursor("co_asientos");

	var i:Number = 0;
	util.createProgressDialog(util.translate("scripts", "Renumerando asientos..."), curAsientos.size());
	util.setProgress(0);

	var idAsiento:Number;
	
	curAsientos.transaction(false);
		
	while (curAsientos.next()) {
	
		idAsiento = curAsientos.valueBuffer("idasiento");
		
		if (curAsientos.valueBuffer("editable") == true) {
			curAsientos.setModeAccess(curAsientos.Edit);
			curAsientos.refreshBuffer();
			curAsientos.setValueBuffer("numero", numAsiento);
			if (!curAsientos.commitBuffer()) {
				debug("error en el asiento " + idAsiento);
				rollback = true;
				break;
			}
		} else {
			cursorBloqueado.setActivatedCommitActions(false);
			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setUnLock("editable", true);

			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setModeAccess(curAsientos.Edit);
			cursorBloqueado.refreshBuffer();
			cursorBloqueado.setValueBuffer("numero", numAsiento);
			if (!cursorBloqueado.commitBuffer()) {
				debug("error en el asiento bloq" + idAsiento);
				rollback = true;
				break;
			}

			cursorBloqueado.select("idasiento = " + idAsiento);
			cursorBloqueado.first();
			cursorBloqueado.setUnLock("editable", false);
			
		}
		numAsiento++;
		
		util.setProgress(i++);
	}

	
	
	var siguienteAsiento:Number = numAsiento;
	if (!rollback) {
		if (util.sqlSelect("co_secuencias", "idsecuencia", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento' AND valorout IS NOT NULL")) {
			if (!util.sqlUpdate("co_secuencias", "valorout", siguienteAsiento, "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'"))
				rollback = true;
		} else {
			if (!util.sqlUpdate("co_secuencias", "valor", siguienteAsiento, "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'"))
				rollback = true;
		}
	}

	if (rollback)
			curAsientos.rollback();
	else {
		curAsientos.commit();
	}

	util.destroyProgressDialog();

	this.iface.tdbRecords.refresh();

	var totalAsientos:Number = util.sqlSelect("co_asientos", "COUNT(idasiento)", "codejercicio = '" + this.iface.ejercicioActual + "'");
	var ultimoAsiento:Number = util.sqlSelect("co_asientos", "numero", "codejercicio = '" + this.iface.ejercicioActual + "' ORDER BY numero DESC");
	if (totalAsientos != ultimoAsiento) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error en la renumeración:\nEl total de asientos (%1) no coincide con el número del último asiento (%2).\nVuelva a realizar la renumeración.").arg(totalAsientos).arg(ultimoAsiento), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	var proxSecuencia:Number;
	if (util.sqlSelect("co_secuencias", "idsecuencia", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento' AND valorout IS NOT NULL")) {
		proxSecuencia = util.sqlSelect("co_secuencias", "valorout", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'");
	} else {
		proxSecuencia = util.sqlSelect("co_secuencias", "valor", "codejercicio = '" + this.iface.ejercicioActual + "' AND nombre = 'nasiento'");
	}
	if (proxSecuencia != ++ultimoAsiento) {
		MessageBox.warning(util.translate("scripts", "Ha habido un error en la renumeración:\nEl siguiente número de asiento en la secuencia (%1) no coincide con el número del último asiento más uno (%2).\nVuelva a realizar la renumeración.").arg(proxSecuencia).arg(ultimoAsiento), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	MessageBox.information(util.translate("scripts", "Renumeración completada correctamente."), MessageBox.Ok, MessageBox.NoButton);
}
//// renAsientos ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////