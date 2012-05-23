/***************************************************************************
                      pagaresprov.qs  -  description
                             -------------------
    begin                : lun ene 29 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() {
		this.ctx.interna_init();
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
	function calculateField(fN:String):String {
		return this.ctx.interna_calculateField(fN);
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var ejercicioActual:String;
	var bloqueoSubcuentaB:Boolean;
	var bloqueoSubcuentaP:Boolean;
	var contabActivada:Boolean;
	var longSubcuenta:Number;
	var posActualPuntoSubcuentaB:Number;
	var posActualPuntoSubcuentaP:Number;
	var tblResAsientos:QTable;
	var curPagosDev:FLSqlCursor;
	
    function oficial( context ) { interna( context ); } 
	function actualizarTotal() {
		return this.ctx.oficial_actualizarTotal();
	}
	function agregarRecibo():Boolean {
		return this.ctx.oficial_agregarRecibo();
	}
	function eliminarRecibo() {
		return this.ctx.oficial_eliminarRecibo();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function asociarReciboPagare(idRecibo:String, curPagare:FLSqlCursor):Boolean {
		return this.ctx.oficial_asociarReciboPagare(idRecibo, curPagare);
	}
	function excluirReciboPagare(idRecibo:String, idPagare:String):Boolean {
		return this.ctx.oficial_excluirReciboPagare(idRecibo, idPagare);
	}
	function datosPagosDev(idRecibo:String, curPagare:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosPagosDev(idRecibo, curPagare);
	}
	function cambiarEstado() {
		return this.ctx.oficial_cambiarEstado();
	}
	function commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.ctx.oficial_commonCalculateField(fN, cursor);
	}
	function habilitarRecibos() {
		return this.ctx.oficial_habilitarRecibos();
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
	function pub_asociarReciboPagare(idRecibo:String, curPagare:FLSqlCursor):Boolean {
		return this.asociarReciboPagare(idRecibo, curPagare);
	}
	function pub_excluirReciboPagare(idRecibo:String, idPagare:String):Boolean {
		return this.excluirReciboPagare(idRecibo, idPagare);
	}
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):String {
		return this.commonCalculateField(fN, cursor);
	}
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
/** \C Los campos de contabilidad sólo aparecen cuando se trabaja con contabilidad integrada
\end */
function interna_init()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;

	this.iface.contabActivada = sys.isLoadedModule("flcontppal") && util.sqlSelect("empresa", "contintegrada", "1 = 1");
	if (this.iface.contabActivada) {
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbIdSubcuentaB").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
		this.child("fdbIdSubcuentaP").setFilter("codejercicio = '" + 	this.iface.ejercicioActual + "'");
		this.iface.posActualPuntoSubcuentaB = -1;
		this.iface.posActualPuntoSubcuentaP = -1;
		this.iface.bloqueoSubcuentaB = false;
		this.iface.bloqueoSubcuentaP = false;
	} else {
		this.child("tbwPagare1").setTabEnabled("contabilidad", false);
	}

	connect(this.child("tbInsert"), "clicked()", this, "iface.agregarRecibo");
	connect(this.child("tbDelete"), "clicked()", this, "iface.eliminarRecibo");
	connect(this.child("tdbPagosPagareProv").cursor(), "cursorUpdated()", this, "iface.cambiarEstado");
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("tdbPagosPagareProv").cursor(), "bufferCommited()", this, "iface.habilitarRecibos");
		
/** \D Se muestran sólo los recibos del pagaré
\end */
	var tdbRecibos:FLTableDB = this.child("tdbRecibos");
/** \C La tabla de recibos se muestra en modo de sólo lectura
\end */
	tdbRecibos.setReadOnly(true);
	var mA = cursor.modeAccess();
	if (mA == cursor.Insert) {
		this.child("fdbCodDivisa").setValue(flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		this.child("fdbPrefijo").setValue(flfactppal.iface.pub_valorDefectoEmpresa("prefijopag"));
	}
	/*
	if (mA == cursor.Edit)
			this.child("fdbCodDivisa").setDisabled(true);
	this.iface.actualizarTotal();
	*/

	tdbRecibos.cursor().setMainFilter("idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idpagare = " + cursor.valueBuffer("idpagare") + ")");
	tdbRecibos.refresh();
	this.iface.actualizarTotal();
	//this.iface.cambiarEstado();

	if (cursor.valueBuffer("estado") == "Anulado") {
		this.child("gbxPagDev").setDisabled(true);
		this.child("tbInsert").setDisabled(true);
		this.child("tbDelete").setDisabled(true);
	}
	else {
		this.child("gbxPagDev").setDisabled(false);
		this.child("tbInsert").setDisabled(false);
		this.child("tbDelete").setDisabled(false);
	}
	
	this.iface.habilitarRecibos();
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	/** \C El Pagaré debe tener al menos un recibo
	\end */
	if (this.child("tdbRecibos").cursor().size() == 0) {
		MessageBox.warning(util.translate("scripts", "El Pagaré debe tener al menos un recibo."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

function interna_calculateField(fN:String):String
{
	return this.iface.commonCalculateField(fN, this.cursor());
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_actualizarTotal()
{
	this.child("fdbTotal").setValue(this.iface.calculateField("total"));
	if (this.child("tdbRecibos").cursor().size() > 0) {
		this.child("fdbCodCuenta").setDisabled(true);
		this.child("fdbCodDivisa").setDisabled(true);
		this.child("fdbFecha").setDisabled(true);
		this.child("gbxCuenta").setEnabled(false);
		this.child("fdbCodProveedor").setDisabled(true);
		
	} else {
		this.child("fdbCodCuenta").setDisabled(false);
		this.child("fdbCodDivisa").setDisabled(false);
		this.child("fdbFecha").setDisabled(false);
		this.child("gbxCuenta").setEnabled(true);
		this.child("fdbCodProveedor").setDisabled(false);
	}
}

/** \D Se agrega un recibo al Pagaré. Si la contabilidad está integrada se comprueba que se ha seleccionado una subcuenta
\end */
function oficial_agregarRecibo():Boolean
{
	var util:FLUtil = new FLUtil();
	
	if (!this.cursor().valueBuffer("codcuenta")) {
		MessageBox.warning(util.translate("scripts", "Debe indicar una cuenta bancaria"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

	if (!this.cursor().valueBuffer("codproveedor")) {
		MessageBox.warning(util.translate("scripts", "Debe indicar un proveedor"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}
	
	var cursor:FLSqlCursor = this.cursor();
	var f:Object = new FLFormSearchDB("seleccionrecibosprov");
	var curRecibos:FLSqlCursor = f.cursor();
	var fecha:String = cursor.valueBuffer("fecha");
		
	//var noGenerarAsiento:Boolean = cursor.valueBuffer("nogenerarasiento");

	if (cursor.modeAccess() != cursor.Browse)
		if (!cursor.checkIntegrity())
			return;

	/*
	if (this.iface.contabActivada && this.child("fdbCodSubcuenta").value().isEmpty()) {
		if (cursor.valueBuffer("nogenerarasiento") == false) {
			MessageBox.warning(util.translate("scripts", "Debe seleccionar una subcuenta a la que asignar el asiento de pago o devolución"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}
	*/

	curRecibos.select();
	if (!curRecibos.first())
		curRecibos.setModeAccess(curRecibos.Insert);
	else
		curRecibos.setModeAccess(curRecibos.Edit);
		
	f.setMainWidget();
	curRecibos.refreshBuffer();
	curRecibos.setValueBuffer("datos", "");
	curRecibos.setValueBuffer("filtro", "codproveedor = '" + cursor.valueBuffer("codproveedor") + "' AND estado IN ('Emitido', 'Devuelto') AND fecha <= '" + fecha + "'");
	var datos:String = f.exec("datos");
	if (!datos || datos == "") 
		return false;
	var recibos:Array = datos.toString().split(",");

	var cur:FLSqlCursor = new FLSqlCursor("empresa");
	for (var i:Number = 0; i < recibos.length; i++) {
		cur.transaction(false);
		try {
			if (this.iface.asociarReciboPagare(recibos[i], cursor)) {
				cur.commit();
			}
			else {
				cur.rollback();
			}
		}
		catch (e) {
			cur.rollback();
			MessageBox.critical(util.translate("scripts", "Hubo un error en la asociación del recibo a la remesa:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		}
	}
	this.child("tdbRecibos").refresh();
	this.iface.actualizarTotal();
}

/** \D Se elimina el recibo activo del Pagaré. El pago asociado al Pagaré debe ser el último asignado al recibo
\end */
function oficial_eliminarRecibo()
{
	if (!this.child("tdbRecibos").cursor().isValid())
		return;
	
	var recibo:String = this.child("tdbRecibos").cursor().valueBuffer("idrecibo");
	if (!this.iface.excluirReciboPagare(recibo, this.cursor().valueBuffer("idpagare")))
		return 

	this.child("tdbRecibos").refresh();
	this.iface.actualizarTotal();
}

function oficial_excluirReciboPagare(idRecibo:String, idPagare:String):Boolean
{
	var util:FLUtil = new FLUtil;
/*
	var cuentaValida:String = util.sqlSelect("recibosprov r LEFT OUTER JOIN cuentasbcopro c ON r.codcuenta = c.codcuenta", "c.codcuenta", "idrecibo = " + idRecibo, "recibosprov,cuentasbcopro");
	if (!cuentaValida) {
		var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);
		MessageBox.warning(util.translate("scripts", "La cuenta bancaria del recibo %1 no es una cuenta válida de la empresa.\nCambie o borre la cuenta antes de excluir el recibo del Pagaré.").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
*/
	var idUltimoPagare:String = util.sqlSelect("pagosdevolprov", "idpagare", "idrecibo = " + idRecibo + " ORDER BY fecha DESC, idpagodevol DESC")
	if (idUltimoPagare != idPagare) {
		var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);
		MessageBox.warning(util.translate("scripts", "Para excluir el recibo %1 del Pagaré debe eliminar antes la devolución que se produjo posteriormente").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var curRecibos:FLSqlCursor = new FLSqlCursor("recibosprov");
	var curPagosDev:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
	var curFactura:FLSqlCursor = new FLSqlCursor("facturasprov");
	var idfactura:Number;
	curRecibos.select("idrecibo = " + idRecibo);

	if (!curRecibos.first())
		return false;
	curRecibos.setModeAccess(curRecibos.Edit);
	curRecibos.refreshBuffer();
	
	idfactura = curRecibos.valueBuffer("idfactura");

// 	curFactura.select("idfactura = " + idfactura);
// 	if (curFactura.first())
// 		curFactura.setUnLock("editable", true);
	
	curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
	if (curPagosDev.last()) {
		curPagosDev.setModeAccess(curPagosDev.Del);
		curPagosDev.refreshBuffer();
		if (!curPagosDev.commitBuffer())
			return false;
	}
	curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
	if (curPagosDev.last())
		curPagosDev.setUnLock("editable", true);

	curRecibos.setValueBuffer("estado", formRecordrecibosprov.iface.pub_commonCalculateField("estado", curRecibos));
	if (!curRecibos.commitBuffer())
		return false;

	return true;
}

function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	switch (fN) {
		/** \C En contabilidad integrada, si el usuario pulsa la tecla del punto '.', --codsubcuenta-- se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
			\end */
		case "codsubcuentab": {
			if (!this.iface.bloqueoSubcuentaB) {
				this.iface.bloqueoSubcuentaB = true;
				this.iface.posActualPuntoSubcuentaB = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaB", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaB);
				this.iface.bloqueoSubcuentaB = false;
			}
			break;
		}
/*
		if (!this.iface.bloqueoSubcuentaB && this.child("fdbCodSubcuentaB").value().length == this.iface.longSubcuenta) {
			this.child("fdbIdSubcuentaB").setValue(this.iface.calculateField("idsubcuentab"));
		}
*/
		case "codsubcuentap": {
			if (!this.iface.bloqueoSubcuentaP) {
				this.iface.bloqueoSubcuentaP = true;
				this.iface.posActualPuntoSubcuentaP = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaP", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuentaP);
				this.iface.bloqueoSubcuentaP = false;
			}
			break;
		}
		/** \D Si el usuario selecciona una cuenta bancaria, se tomará su cuenta contable asociada como --codcuenta-- contable para el pago.
			\end */
		case "codcuenta": {
			this.child("fdbIdSubcuentaB").setValue(this.iface.calculateField("idsubcuentadefectob"));
			this.child("fdbIdSubcuentaP").setValue(this.iface.calculateField("idsubcuentadefectop"));
			this.child("fdbSecuencia").setValue(this.iface.calculateField("secuencia"));
			this.child("fdbDc").setValue(this.iface.calculateField("dc"));
			break;
		}
		case "codproveedor": {
			if(util.sqlSelect("factteso_general","contdirectapagare","1=1"))
				this.child("fdbIdSubcuentaP").setValue(this.iface.calculateField("idsubcuentadefectop"));
			break;
		}
		case "ctaentidad":
		case "ctaagencia":
		case "cuenta": {
			this.child("fdbDc").setValue(this.iface.calculateField("dc"));
			break;
		}
		case "nogenerarasiento": {
			if (cursor.valueBuffer("nogenerarasiento") == true) {
				this.child("fdbIdSubcuentaB").setValue("");
				this.child("fdbCodSubcuentaB").setValue("");
				this.child("fdbDesSubcuentaB").setValue("");
				cursor.setNull("idsubcuentab");
				cursor.setNull("codsubcuentab");
				this.child("fdbIdSubcuentaB").setDisabled(true);
				this.child("fdbCodSubcuentaB").setDisabled(true);
	
				this.child("fdbIdSubcuentaP").setValue("");
				this.child("fdbCodSubcuentaP").setValue("");
				this.child("fdbDesSubcuentaP").setValue("");
				cursor.setNull("idsubcuentap");
				cursor.setNull("codsubcuentap");
				this.child("fdbIdSubcuentaP").setDisabled(true);
				this.child("fdbCodSubcuentaP").setDisabled(true);
			} else {
				this.child("fdbIdSubcuentaB").setDisabled(false);
				this.child("fdbCodSubcuentaB").setDisabled(false);
				
				this.child("fdbIdSubcuentaP").setDisabled(false);
				this.child("fdbCodSubcuentaP").setDisabled(false);
			}
			break;
		}
		case "secuencia": {
			this.child("fdbSerie").setValue(this.iface.calculateField("serie"));
			this.child("fdbDCN").setValue(this.iface.calculateField("dcn"));
			this.child("fdbNumero").setValue(this.iface.calculateField("numero"));
			break;
		}
		case "prefijo": {
			this.child("fdbDCN").setValue(this.iface.calculateField("dcn"));
			this.child("fdbNumero").setValue(this.iface.calculateField("numero"));
			break;
		}
	}
}


/** \D Asocia un recibo a un Pagaré, marcándolo como Pagaré
@param	idRecibo: Identificador del recibo
@param	curPagare: Cursor posicionado en el Pagaré
@return	true si la asociación se realiza de forma correcta, false en caso contrario
\end */
function oficial_asociarReciboPagare(idRecibo:String, curPagare:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var idPagare:String = curPagare.valueBuffer("idpagare");
	
	if (util.sqlSelect("recibosprov", "coddivisa", "idrecibo = " + idRecibo) != curPagare.valueBuffer("coddivisa")) {
		MessageBox.warning(util.translate("scripts", "No es posible incluir el recibo.\nLa divisa del recibo y del Pagaré deben ser la misma."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

	/*
	var datosCuenta:Array = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "ctaentidad,ctaagencia,cuenta", "codcuenta = '" + curPagare.valueBuffer("codcuenta") + "'");
	if (datosCuenta.result != 1)
		return false;
	var dc:String = util.calcularDC(datosCuenta.ctaentidad + datosCuenta.ctaagencia) + util.calcularDC(datosCuenta.cuenta);
	*/

	var curRecibos:FLSqlCursor = new FLSqlCursor("recibosprov");
	var idFactura:Number;

	var fecha:String = curPagare.valueBuffer("fecha");
	if (!this.iface.curPagosDev)
		this.iface.curPagosDev = new FLSqlCursor("pagosdevolprov");
	this.iface.curPagosDev.select("idrecibo = " + idRecibo + " ORDER BY fecha,idpagodevol");
	if (this.iface.curPagosDev.last()) {
		if (util.daysTo(this.iface.curPagosDev.valueBuffer("fecha"), fecha) < 0) {
			var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + idRecibo);
			MessageBox.warning(util.translate("scripts", "Existen pagos o devoluciones con fecha igual o porterior a la del Pagaré para el recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	curRecibos.select("idrecibo = " + idRecibo);
	if (curRecibos.next()) {
		curRecibos.setActivatedCheckIntegrity(false);
		curRecibos.setModeAccess(curRecibos.Edit);
		curRecibos.refreshBuffer();
		//curRecibos.setValueBuffer("idpagare", idPagare);
		curRecibos.setValueBuffer("estado", "Pagaré");
		idFactura = curRecibos.valueBuffer("idfactura");
		curRecibos.commitBuffer();
	}

	if (this.iface.curPagosDev.last()) {
		this.iface.curPagosDev.setUnLock("editable", false);
	}
	this.iface.curPagosDev.setModeAccess(this.iface.curPagosDev.Insert);
	this.iface.curPagosDev.refreshBuffer();
	this.iface.curPagosDev.setValueBuffer("idrecibo", idRecibo);
	this.iface.curPagosDev.setValueBuffer("fecha", fecha);
	this.iface.curPagosDev.setValueBuffer("tipo", "Pagaré");
	this.iface.curPagosDev.setValueBuffer("codcuenta", curPagare.valueBuffer("codcuenta"));
/*
	this.iface.curPagosDev.setValueBuffer("ctaentidad", datosCuenta.ctaentidad);
	this.iface.curPagosDev.setValueBuffer("ctaagencia", datosCuenta.ctaagencia);
	this.iface.curPagosDev.setValueBuffer("dc", dc);
	this.iface.curPagosDev.setValueBuffer("cuenta", datosCuenta.cuenta);
*/
	this.iface.curPagosDev.setValueBuffer("idpagare", idPagare);

	var noGenerarAsiento:Boolean;
	if(util.sqlSelect("factteso_general","contdirectapagare","1=1"))
		noGenerarAsiento = true;
	else
		noGenerarAsiento = curPagare.valueBuffer("nogenerarasiento");

	this.iface.curPagosDev.setValueBuffer("nogenerarasiento", noGenerarAsiento);

	if(!noGenerarAsiento) {
		if (parseFloat(curPagare.valueBuffer("idsubcuentap")) == 0) {
			this.iface.curPagosDev.setNull("idsubcuenta");
			this.iface.curPagosDev.setNull("codsubcuenta");
		} else {
			this.iface.curPagosDev.setValueBuffer("idsubcuenta", curPagare.valueBuffer("idsubcuentap"));
			this.iface.curPagosDev.setValueBuffer("codsubcuenta", curPagare.valueBuffer("codsubcuentap"));
		}
	}

	if (!this.iface.datosPagosDev(idRecibo, curPagare))
		return false;

	if (!this.iface.curPagosDev.commitBuffer())
		return false;

	return true;
}

function oficial_datosPagosDev(idRecibo:String, curPagare:FLSqlCursor):Boolean
{
	return true;
}

/** \D
Cambia el valor del estado del recibo entre Emitido, Cobrado y Devuelto
\end */
function oficial_cambiarEstado()
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	var estado:String = this.iface.calculateField("estado");
	if (estado == "Anulado")
		return false;

	var estadoRecibos:String;
	this.child("fdbEstado").setValue(estado);
	switch (estado) {
		case "Emitido": {
			estadoRecibos = "Pagaré";
			break;
		}
		case "Devuelto": {
			estadoRecibos = "Devuelto";
			break;
		}
		case "Pagado": {
			estadoRecibos = "Pagado";
			break;
		}
	}
	if (!util.sqlUpdate("recibosprov", "estado", estadoRecibos, "idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idpagare = " + cursor.valueBuffer("idpagare") + ")"))
		return false;
}

function oficial_commonCalculateField(fN:String, cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();

	var res:String;
	switch (fN) {
		/** \D La subcuenta contable por defecto será la asociada a la cuenta bancaria. Si ésta está vacía, será la subcuenta correspondienta a Caja
				\end */
		case "idsubcuentadefectob": {
			if (this.iface.contabActivada) {
				var codSubcuenta:String = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + cursor. valueBuffer("codcuenta") + "'");
				if (codSubcuenta != false)
					res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
				else
					res = "";
			}
			break;
		}
		case "idsubcuentadefectop": {
			if (this.iface.contabActivada) {
				if(util.sqlSelect("factteso_general","contdirectapagare","1=1")) {
					var codProveedor:String = cursor.valueBuffer("codproveedor");
					if (!codProveedor || codProveedor == "")
						return "";
					
					var codSubcuenta:String = util.sqlSelect("co_subcuentasprov", "codsubcuenta", "codproveedor = '" + codProveedor + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
					if (codSubcuenta != false)
						res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
					else {
						MessageBox.warning(util.translate("scripts", "El proveedor %1 no tiene definida ninguna subcuenta en el ejercicio %2.\nEspecifique la subcuenta en la pestaña de contabilidad del formulario de proveedores").arg(codProveedor).arg(this.iface.ejercicioActual), MessageBox.Ok, MessageBox.NoButton);
						res = "";
					}
				}
				else {
					var codSubcuenta:String = util.sqlSelect("cuentasbanco", "codsubcuentap", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "'");
					if (codSubcuenta != false)
						res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
					else
						res = "";
				}
			}
			break;
		}
/*
		case "idsubcuenta":
			var codSubcuenta:String = cursor.valueBuffer("codsubcuenta").toString();
			if (codSubcuenta.length == this.iface.longSubcuenta)
				res = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
			break;
		case "codsubcuenta":
			res = "";
			if (cursor.valueBuffer("idsubcuenta"))
				res = util.sqlSelect("co_subcuentas", "codsubcuenta", "idsubcuenta = '" + cursor.valueBuffer("idsubcuenta") + "' AND codejercicio = '" + this.iface.ejercicioActual + "'");
			break;
*/
		case "total": {
			res = util.sqlSelect("recibosprov", "SUM(importe)", "idrecibo IN (SELECT idrecibo FROM pagosdevolprov WHERE idpagare = " + cursor.valueBuffer("idpagare") + ")")
			if (!res || isNaN(res))
				res = 0;
			break;
		}
		case "estado": {
			res = "Emitido";
			var curPagosDevol:FLSqlCursor = new FLSqlCursor("pagospagareprov");
			curPagosDevol.select("idpagare = '" + cursor.valueBuffer("idpagare") + "' ORDER BY fecha DESC, idpagodevol DESC");
			if (curPagosDevol.first()) {
				curPagosDevol.setModeAccess(curPagosDevol.Browse);
				curPagosDevol.refreshBuffer();
				if (curPagosDevol.valueBuffer("tipo") == "Pago")
					res = "Pagado";
				else
					res = "Devuelto";
			}
			break;
		}
		case "dcn": {
			var prefijo:String = cursor.valueBuffer("prefijo");
			var secuencia:Number = cursor.valueBuffer("secuencia");
			res = "";
			if (prefijo && prefijo != "" && secuencia && !isNaN(secuencia)) {
				if (prefijo.length == 4) {
					var numero:Number = parseFloat(prefijo + flfactppal.iface.pub_cerosIzquierda(secuencia, 7));
					res = numero % 7;
				}
			}
			break;
		}
		case "numero": {
			var prefijo:String = cursor.valueBuffer("prefijo");
			var secuencia:Number = parseFloat(cursor.valueBuffer("secuencia"));
			var dcn:String = cursor.valueBuffer("dcn");
			res = "";
			if (prefijo && prefijo != "" && !isNaN(secuencia) && secuencia) {
				if (prefijo.length == 4) {
					res = prefijo + flfactppal.iface.pub_cerosIzquierda(secuencia, 7) + " " + dcn
				}
			}
			break;
		}
		/** \C La secuencia es la siguiente a la última secuencia para la misma cuenta siempre que esté comprendida en algún tramo de números de pagaré.
		\end */
		case "secuencia": {
			res = 0;
			var qryTramos:FLSqlQuery = new FLSqlQuery;
			with (qryTramos) {
				setTablesList("tramospagare");
				setSelect("desde, hasta");
				setFrom("tramospagare");
				setWhere("codcuenta = '" + cursor.valueBuffer("codcuenta") + "' ORDER BY desde");
				setForwardOnly(true);
			}
			if (!qryTramos.exec())
				return false;

			var ultPagare:Number = util.sqlSelect("pagaresprov", "secuencia", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "' ORDER BY serie DESC, secuencia DESC");
			if (!ultPagare)
				ultPagare = 0;
			ultPagare = Math.round(ultPagare);

			var idPagare:String;
			while (qryTramos.next()) {
				var desde:Number = Math.round(parseFloat(qryTramos.value("desde")));
				var hasta:Number = Math.round(parseFloat(qryTramos.value("hasta")));
				if (ultPagare > hasta)
					continue;

				var i:Number;
				if (ultPagare > desde)
					i = ultPagare + 1;
				else
					i = desde;
				for (; i <= hasta; i++) {
					idPagare = util.sqlSelect("pagaresprov", "idpagare", "secuencia = " + i);
					if (!idPagare || idPagare == cursor.valueBuffer("idpagare"))
						break;
				}
				if (i <= hasta) {
					res = i;
					break;
				}
			}
			break;
		}
		case "serie": {
			res = util.sqlSelect("tramospagare", "serie", "codcuenta = '" + cursor.valueBuffer("codcuenta") + "' AND desde <= " + cursor.valueBuffer("secuencia") + " AND hasta >= " + cursor.valueBuffer("secuencia"));
			break;
		}
		case "dc": {
			var entidad = cursor.valueBuffer("ctaentidad");
			var agencia = cursor.valueBuffer("ctaagencia");
			var cuenta = cursor.valueBuffer("cuenta");
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() 
					&& entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var dc1 = util.calcularDC(entidad + agencia);
				var dc2 = util.calcularDC(cuenta);
				res = dc1 + dc2;
			}
			break;
		}
	}
	return res;
}

function oficial_habilitarRecibos()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("estado") == "Pagado") {
		this.child("gbxRecibos").setDisabled(true);
	} else {
		this.child("gbxRecibos").setDisabled(false);
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////










