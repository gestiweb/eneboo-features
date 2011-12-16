
/** @class_declaration gastoDevol */
/////////////////////////////////////////////////////////////////
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
class gastoDevol extends oficial /** %from: oficial */ {
	var bloqueoImporte_:Boolean;
	var bloqueoInit_:Boolean;
    function gastoDevol( context ) { oficial ( context ); }
	function init() {
		return this.ctx.gastoDevol_init();
	}
	function validateForm():Boolean {
		return this.ctx.gastoDevol_validateForm();
	}
	function habilitacionesPorEstado() {
		return this.ctx.gastoDevol_habilitacionesPorEstado();
	}
	function divisionRecibo() {
		return this.ctx.gastoDevol_divisionRecibo();
	}
	function copiarCampoReciboDiv(nombreCampo:String, cursor:FLSqlCursor, campoInformado:Array):Boolean {
		return this.ctx.gastoDevol_copiarCampoReciboDiv(nombreCampo, cursor, campoInformado);
	}
	function bufferChanged(fN:String) {
		return this.ctx.gastoDevol_bufferChanged(fN);
	}
	function calculateField(fN:String):String {
		return this.ctx.gastoDevol_calculateField(fN);
	}
	function cambiarEstado() {
		return this.ctx.gastoDevol_cambiarEstado();
	}
}
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition gastoDevol */
/////////////////////////////////////////////////////////////////
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
function gastoDevol_init()
{
	this.iface.bloqueoInit_ = true;
	this.iface.__init();
	this.iface.bloqueoInit_ = false;

	this.iface.bloqueoImporte_ = false;

	var cursor:FLSqlCursor = this.cursor();
// 	if (cursor.valueBuffer("estado") == "Devuelto") {
// 		this.child("gbxPagDev").setDisabled(false);
// 	}

	if (cursor.modeAccess() == cursor.Edit) {
		this.iface.importeInicial = parseFloat(cursor.valueBuffer("importesingd"));
debug("this.iface.importeInicial = " + this.iface.importeInicial );
		if (isNaN(this.iface.importeInicial) || this.iface.importeInicial == 0) {
			/// Esto es para cuando el recibo se abre por primera vez tras instalar la extensión
			this.iface.importeInicial = parseFloat(cursor.valueBuffer("importe"));
debug("2this.iface.importeInicial = " + this.iface.importeInicial );
		}
		this.iface.habilitacionesPorEstado();
	}
}

function gastoDevol_habilitacionesPorEstado()
{
	var cursor:FLSqlCursor = this.cursor();
	this.child("fdbGastoDevol").setDisabled(true);

	if (cursor.valueBuffer("estado") == "Devuelto" || cursor.valueBuffer("estado") == "Emitido") {
		this.child("fdbImporte").setDisabled(false);
	} else {
		this.child("fdbImporte").setDisabled(true);
	}
}

function gastoDevol_divisionRecibo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	/** \C
	Si el importe ha disminuido, genera un recibo complementario por la diferencia
	\end */
	var importeActual = parseFloat(this.cursor().valueBuffer("importesingd"));
	if (importeActual != this.iface.importeInicial) {
		var cursor = form.cursor();
		var tasaConv = parseFloat(util.sqlSelect("facturascli", "tasaconv", "idfactura = " + cursor.valueBuffer("idfactura")));

		cursor.setValueBuffer("importeeuros", importeActual * tasaConv);

		if (!this.iface.curReciboDiv) {
			this.iface.curReciboDiv = new FLSqlCursor("reciboscli");
		}
		this.iface.curReciboDiv.setModeAccess(this.iface.curReciboDiv.Insert);
		this.iface.curReciboDiv.refreshBuffer();

		var camposRecibo:Array = util.nombreCampos("reciboscli");
		var totalCampos:Number = camposRecibo[0];

		var campoInformado:Array = [];
		for (var i:Number = 1; i <= totalCampos; i++) {
			campoInformado[camposRecibo[i]] = false;
		}
		for (var i:Number = 1; i <= totalCampos; i++) {
			if (!this.iface.copiarCampoReciboDiv(camposRecibo[i], cursor, campoInformado)) {
				return false;
			}
		}
		this.iface.curReciboDiv.commitBuffer();
	}
}

/** \D En la división del recibo no se copia el gasto por devolución, ya que éste queda integramente en el recibo original
@param	nombreCampo: Nombre del campo a copiar
@param	cursor: Cursor con los datos del recibo original
@param	campoInformado: Array que contiene los campos ya informados
\end */
function gastoDevol_copiarCampoReciboDiv(nombreCampo:String, cursor:FLSqlCursor, campoInformado:Array):Boolean
{
	var util:FLUtil = new FLUtil;

	if (campoInformado[nombreCampo]) {
		return true;
	}
	var nulo:Boolean =false;

	var cursor:FLSqlCursor = this.cursor();
	switch (nombreCampo) {
		case "texto": {
			if (!campoInformado["coddivisa"]) {
				if (!this.iface.copiarCampoReciboDiv("coddivisa", cursor, campoInformado)) {
					return false;
				}
			}
			if (!campoInformado["importe"]) {
				if (!this.iface.copiarCampoReciboDiv("importe", cursor, campoInformado)) {
					return false;
				}
			}
			var moneda = util.sqlSelect("divisas", "descripcion", "coddivisa = '" + cursor.valueBuffer("coddivisa") + "'");
			valor = util.enLetraMoneda(this.iface.curReciboDiv.valueBuffer("importe"), moneda);
			break;
		}
		case "importesingd": {
			valor = this.iface.importeInicial - parseFloat(cursor.valueBuffer("importesingd"));
			break;
		}
		case "importe": {
			valor = this.iface.importeInicial - parseFloat(cursor.valueBuffer("importesingd"));
			break;
		}
		case "gastodevol": {
			valor = 0;
			break;
		}
		default: {
			if (!this.iface.__copiarCampoReciboDiv(nombreCampo, cursor, campoInformado)) {
				return false;
			}
			return true;
		}
	}
	if (nulo) {
		this.iface.curReciboDiv.setNull(nombreCampo);
	} else {
		this.iface.curReciboDiv.setValueBuffer(nombreCampo, valor);
	}
	campoInformado[nombreCampo] = true;

	return true;
}

function gastoDevol_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "importe": {
			this.child("fdbTexto").setValue(this.iface.calculateField("texto"));
			this.child("gbxPagDev").setDisabled(true);
			if (!this.iface.bloqueoImporte_) {
				this.iface.bloqueoImporte_ = true;
				cursor.setValueBuffer("importesingd", this.iface.calculateField("importesingd"));
				this.iface.bloqueoImporte_ = false;
			}
			break;
		}
		case "gastodevol":
		case "importesingd": {
			if (!this.iface.bloqueoImporte_) {
				this.iface.bloqueoImporte_ = true;
				this.child("fdbImporte").setValue(this.iface.calculateField("importe"));
				this.iface.bloqueoImporte_ = false;
			}
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}

function gastoDevol_validateForm():Boolean
{
	if (!this.iface.__validateForm()) {
		return false;
	}
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var importeSinGD:Number = parseFloat(cursor.valueBuffer("importesingd"));
debug("importeSinGD  =" + importeSinGD);
	if (isNaN(importeSinGD) || importeSinGD == 0) {
		this.iface.bloqueoImporte_ = true;
debug("importeSinGD  calculado " + this.iface.calculateField("importesingd"));
		cursor.setValueBuffer("importesingd", this.iface.calculateField("importesingd"));
		this.iface.bloqueoImporte_ = false;
	}

	return true;
}

function gastoDevol_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch (fN) {
		case "importesingd": {
			valor = cursor.valueBuffer("importe") - cursor.valueBuffer("gastodevol");
			break;
		}
		case "importe": {
// 			var importeSinRec:Number = parseFloat(cursor.valueBuffer("importesingd"));
// 			if (importeSinRec) {
// 				valor = importeSinRec + parseFloat(cursor.valueBuffer("gastodevol"));
// 			} else {
// 				valor = cursor.valueBuffer("importe");
// 			}
			valor = this.iface.importeInicial + parseFloat(cursor.valueBuffer("gastodevol"));
			break;
		}
		case "gastodevol": {
			valor = util.sqlSelect("pagosdevolcli", "SUM(gastodevol)", "idrecibo = " + cursor.valueBuffer("idrecibo") + " AND tipo = 'Devolución'");
			if (!valor) {
				valor = 0;
			}
			break;
		}
		default: {
			valor = this.iface.__calculateField(fN);
		}
	}
	return valor;
}

function gastoDevol_cambiarEstado()
{
	this.iface.__cambiarEstado();
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	this.iface.habilitacionesPorEstado();

	if (!this.iface.bloqueoInit_) {
		this.child("fdbGastoDevol").setValue(this.iface.calculateField("gastodevol"));
		this.child("fdbImporte").setValue(this.iface.calculateField("importe"));
	}
}
//// GASTOS POR DEVOLUCIÓN //////////////////////////////////////
/////////////////////////////////////////////////////////////////

