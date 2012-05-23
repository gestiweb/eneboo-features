
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	var tblNS:QTable;
	var tbwNS:Object;
	function funNumSerie( context ) { oficial( context ); } 
	function init() { this.ctx.funNumSerie_init(); }
	function bufferChanged(fN:String) { return this.ctx.funNumSerie_bufferChanged(fN); }
	function controlCampos() { this.ctx.funNumSerie_controlCampos(); }
	function guardarNS() { this.ctx.funNumSerie_guardarNS(); }
	function borrarNS() { this.ctx.funNumSerie_borrarNS(); }
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

function funNumSerie_init()
{
	this.iface.controlCampos();
	this.iface.__init();

	if (this.cursor().modeAccess() == this.cursor().Edit ) {
		if (this.cursor().valueBuffer("nostock")) {
			this.child("tbwArticulo").setTabEnabled("series", false);
		} else {
			this.child("tbwArticulo").setTabEnabled("series", true);
		}
	}

	this.iface.tblNS = this.child("tblNS");
	this.iface.tbwNS = this.child("tbwNS");
	
	connect(this.child("pbnGuardarNS"), "clicked()", this, "iface.guardarNS()");
	connect(this.child("pbnBorrarNS"), "clicked()", this, "iface.borrarNS()");
	connect(this.child("tdbNumerosSerie").cursor(), "cursorUpdated()", this, "iface.calcularStockFisico()");
}

function funNumSerie_bufferChanged(fN:String)
{
	switch (fN) {
		case "controlnumserie":
			this.iface.controlCampos();
		break;
	}
	
	return this.iface.__bufferChanged(fN);
}

function funNumSerie_controlCampos()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("controlnumserie")) {
		cursor.setValueBuffer("controlstock", false);
		this.child("fdbNoStock").setDisabled(true);
		this.child("gbxNumSerie").setDisabled(false);
		this.child("gbxNumSerieRap").setDisabled(false);
	}
	else {
		this.child("fdbNoStock").setDisabled(false);
		this.child("gbxNumSerie").setDisabled(true);
		this.child("gbxNumSerieRap").setDisabled(true);
	}
}

function funNumSerie_guardarNS()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Insert) {
		var curAA:FLSqlCursor = this.child("tdbNumerosSerie").cursor();
		curAA.setModeAccess(curAA.Insert);
		curAA.commitBufferCursorRelation();
	}

	var util:FLUtil = new FLUtil();
	
	var referencia:String = this.cursor().valueBuffer("referencia");
	if (!referencia)
		return;
	
	var codAlmacen:String = this.cursor().valueBuffer("codalmacenns");
	if (!util.sqlSelect("almacenes", "codalmacen", "codalmacen = '" + codAlmacen + "'")) {
		MessageBox.information(util.translate("scripts", "Debe establecerse un almacén válido para los nuevos números de serie"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	res = MessageBox.information(util.translate("scripts", "A continuación se introducirán los números de serie\n¿continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	var numSerie:String;
	var curTab:FLSqlCursor = new FLSqlCursor("numerosserie");
	
	var nuevos:Number = 0;
	var repetidos:String = "";

	for (numNS = 0; numNS < this.iface.tblNS.numRows(); numNS++) {
	
		if(!this.iface.tblNS.text(numNS, 0))
			continue;
	
		numSerie = this.iface.tblNS.text(numNS, 0);
		
		curTab.select("numserie = '" + numSerie + "' AND referencia = '" + referencia + "'");
		if (curTab.first()) {
			repetidos += "\n" + numSerie;
			this.iface.tblNS.setText(numNS, 0, "");
			continue;
		}
		else {
			curTab.setModeAccess(curTab.Insert);
			curTab.refreshBuffer();
			curTab.setValueBuffer("referencia", referencia);
			curTab.setValueBuffer("numserie", numSerie);
			curTab.setValueBuffer("codalmacen", codAlmacen);
			curTab.commitBuffer();
			nuevos++;
		}
		
		this.iface.tblNS.setText(numNS, 0, "");
	}
	
	if (repetidos)
		MessageBox.information(util.translate("scripts", "Los siguientes números de serie no se han podido introducir porque ya existen:\n\n") + repetidos, MessageBox.Ok, MessageBox.NoButton);
	
	if (nuevos) {
		MessageBox.information(util.translate("scripts", "Se insertaron %0 nuevos números de serie").arg(nuevos), MessageBox.Ok, MessageBox.NoButton);
		this.iface.tbwNS.showPage("numserie");
		this.child("tdbNumerosSerie").refresh();
	}
	else
		MessageBox.information(util.translate("scripts", "No se encontaron nuevos números de serie"), MessageBox.Ok, MessageBox.NoButton);

	this.iface.calcularStockFisico();
}

function funNumSerie_borrarNS()
{
	var util:FLUtil = new FLUtil();
	
	res = MessageBox.information(util.translate("scripts", "Se vaciará la lista\n¿continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	for (numNS = 0; numNS < this.iface.tblNS.numRows(); numNS++)
		this.iface.tbwNS.setText(numNS, 0, "");
}


//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

