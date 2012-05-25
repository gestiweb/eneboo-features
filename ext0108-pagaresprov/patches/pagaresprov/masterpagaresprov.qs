/***************************************************************************
                 masterpagaresprov.qs  -  description
                             -------------------
    begin                : mie ene 31 2006
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
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	var pbnAPagare:Object;
	var tbnImprimir:Object;
	var tdbRecords:FLTableDB;
	var curPagare:FLSqlCursor;
	var pbnAnularPagare:Object;

    function oficial( context ) { interna( context ); } 
	function imprimir() {
		return this.ctx.oficial_imprimir();
	}
	function asociarAPagare() {
		return this.ctx.oficial_asociarAPagare();
	}
	function whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.ctx.oficial_whereAgrupacion(curAgrupar);
	}
	function generarPagare(where:String, curRecibo:FLSqlCursor, curAgrupar:FLSqlCursor):Number {
		return this.ctx.oficial_generarPagare(where, curRecibo, curAgrupar);
	}
	function datosPagare(curRecibo:FLSqlCursor, where:String, curAgrupar:FLSqlCursor):Boolean {
		return this.ctx.oficial_datosPagare(curRecibo, where, curAgrupar);
	}
	function totalesPagare():Boolean {
		return this.ctx.oficial_totalesPagare();
	}
	function botonAnular() {
		return this.ctx.oficial_botonAnular();
	}
	function anularPagare_clicked() {
		return this.ctx.oficial_anularPagare_clicked();
	}
	function anularPagare():Boolean {
		return this.ctx.oficial_anularPagare();
	}
	function quitarPagareAnulado():Boolean {
		return this.ctx.oficial_quitarPagareAnulado();
	}
	function marcarImpreso(filtro:String):Boolean {
		return this.ctx.oficial_marcarImpreso(filtro);
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
	function pub_whereAgrupacion(curAgrupar:FLSqlCursor):String {
		return this.whereAgrupacion(curAgrupar);
	}
	function pub_marcarImpreso(filtro:String):Boolean {
		return this.marcarImpreso(filtro);
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
/** \C
Este es el formulario maestro de facturas a cliente.
\end */
function interna_init()
{
	this.iface.pbnAnularPagare = this.child("pbnAnularPagare");
	this.iface.pbnAPagare = this.child("pbnAsociarAPagare");
	this.iface.tbnImprimir = this.child("toolButtonPrint");
	this.iface.tdbRecords= this.child("tableDBRecords");

	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
	connect(this.iface.pbnAPagare, "clicked()", this, "iface.asociarAPagare()");
	connect(this.iface.tdbRecords, "currentChanged()", this, "iface.botonAnular()");
	connect(this.iface.pbnAnularPagare, "clicked()", this, "iface.anularPagare_clicked()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \C
Al pulsar el botón imprimir se lanzará el informe correspondiente al pagaré seleccionado (en caso de que el módulo de informes esté cargado)
\end */
function oficial_imprimir()
{
	if (sys.isLoadedModule("flfactinfo")) {
		var util:FLUtil = new FLUtil;
		var numero:String = this.cursor().valueBuffer("numero");
		
		var curImprimir:FLSqlCursor = new FLSqlCursor("i_pagaresprov");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("i_pagaresprov_numero", numero);
		flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pagaresprov");

		this.iface.marcarImpreso("numero = '" + numero + "'");
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");

}

function oficial_marcarImpreso(filtro:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var res:Number = MessageBox.information(util.translate("scripts", "¿Desea marcar el/los pagarés del informe como Impresos?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes) {
		return true;
	}
	var curPagare:FLSqlCursor = new FLSqlCursor("pagaresprov");
	curPagare.setActivatedCommitActions(false);
	curPagare.select(filtro);
	while (curPagare.next()) {
		curPagare.setModeAccess(curPagare.Edit);
		curPagare.refreshBuffer();
		curPagare.setValueBuffer("impreso", true);
		if (!curPagare.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** \C
Al pulsar el botón de asociar a factura se abre la ventana de agrupar albaranes de cliente
\end */
function oficial_asociarAPagare()
{
	var util:FLUtil = new FLUtil;
	var f:Object = new FLFormSearchDB("agruparrecpagprov");
	var cursor:FLSqlCursor = f.cursor();
	var where:String;
	var codProveedor:String;
	var fechaV:String;
	
	cursor.setActivatedCheckIntegrity(false);
	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var acpt:String = f.exec("id");
	if (acpt) {
		cursor.commitBuffer();
		var curAgruparRecibos:FLSqlCursor = new FLSqlCursor("agruparrecpagprov");
		curAgruparRecibos.select();
		if (curAgruparRecibos.first()) {
			where = this.iface.whereAgrupacion(curAgruparRecibos);
			var excepciones:String = curAgruparRecibos.valueBuffer("excepciones");
			if (!excepciones.isEmpty())
				where += " AND idrecibo NOT IN (" + excepciones + ")";

			var fechaVPagare:Date = cursor.valueBuffer("fechav");
			var agruparPorFV:Boolean = true;
			if (cursor.valueBuffer("sinfechav"))
				agruparPorFV = false;
			var qryAgruparRecibos:FLSqlCursor = new FLSqlQuery;
			qryAgruparRecibos.setTablesList("recibosprov");
			if (agruparPorFV) {
				qryAgruparRecibos.setSelect("codproveedor");
				qryAgruparRecibos.setWhere(where + " GROUP BY codproveedor");
			} else {
				qryAgruparRecibos.setSelect("codproveedor,fechav");
				qryAgruparRecibos.setWhere(where + " GROUP BY codproveedor,fechav");
			}
			qryAgruparRecibos.setFrom("recibosprov");

			if (!qryAgruparRecibos.exec())
				return;

			var totalProveedores:Number = qryAgruparRecibos.size();
			util.createProgressDialog(util.translate("scripts", "Generando pagarés"), totalProveedores);
			util.setProgress(1);
			var j:Number = 0;
			
			var curRecibo:FLSqlCursor = new FLSqlCursor("recibosprov");
			var wherePagare:String;
			while (qryAgruparRecibos.next()) {
				codProveedor = qryAgruparRecibos.value("codproveedor");
				if (agruparPorFV) {
					wherePagare = where + " AND codproveedor = '" + codProveedor + "'";
				} else {
					fechaV = qryAgruparRecibos.value("fechav");
					wherePagare = where + " AND codproveedor = '" + codProveedor + "'" + " AND fechav = '" + fechaV.toString().left(10) + "'";
				}
				curRecibo.transaction(false);
				curRecibo.select(wherePagare);
				if (!curRecibo.first()) {
					curRecibo.rollback();
					util.destroyProgressDialog();
					return;
				}
				//curRecibo.setValueBuffer("fechav", curAgruparRecibos.valueBuffer("fechav"));
				if (this.iface.generarPagare(wherePagare, curRecibo, cursor)) {
					curRecibo.commit();
				} else {
					MessageBox.warning(util.translate("scripts", "Falló la inserción del pagaré correspondiente al proveedor: %1").arg(codProveedor), MessageBox.Ok, MessageBox.NoButton);
					curRecibo.rollback();
					util.destroyProgressDialog();
					return;
				}
				util.setProgress(++j);
			}
			util.setProgress(totalProveedores);
			util.destroyProgressDialog();
		}

		f.close();
		this.iface.tdbRecords.refresh();
	}
}

/** \D
Construye la sentencia WHERE de la consulta que buscará los albaranes a agrupar
@param curAgrupar: Cursor de la tabla agruparrecibosprov que contiene los valores de los criterios de búsqueda
@return Sentencia where
\end */
function oficial_whereAgrupacion(curAgrupar:FLSqlCursor):String
{
	var codProveedor:String = curAgrupar.valueBuffer("codproveedor");
	var fechaVDesde:String = curAgrupar.valueBuffer("fechavdesde");
	var fechaVHasta:String = curAgrupar.valueBuffer("fechavhasta");
	var where:String = "estado IN ('Emitido', 'Devuelto')";
	if (codProveedor && codProveedor != "")
		where += " AND codproveedor = '" + codProveedor + "'";
	if (fechaVDesde && fechaVDesde != "")
		where += " AND fechav >= '" + fechaVDesde + "'";
	if (fechaVHasta && fechaVHasta != "")
		where += " AND fechav <= '" + fechaVHasta + "'";

	return where;
}

/** \D
Genera la factura asociada a uno o más albaranes
@param where: Sentencia where para la consulta de búsqueda de los albaranes a agrupar
@param curRecibo: Cursor con los datos principales que se copiarán del albarán a la factura
@param curAgrupar: Cursor con algunos de los datos del pagaré a generar
@return True: Copia realizada con éxito, False: Error
\end */
function oficial_generarPagare(where:String, curRecibo:FLSqlCursor, curAgrupar:FLSqlCursor):Number
{
	if (!this.iface.curPagare)
		this.iface.curPagare = new FLSqlCursor("pagaresprov");
	
	this.iface.curPagare.setModeAccess(this.iface.curPagare.Insert);
	this.iface.curPagare.refreshBuffer();
	
	if (!this.iface.datosPagare(curRecibo, where, curAgrupar))
		return false;
	
	if (!this.iface.curPagare.commitBuffer()) {
		return false;
	}
	
	var idPagare:Number = this.iface.curPagare.valueBuffer("idpagare");
	
	var curRecibos:FLSqlCursor = new FLSqlCursor("recibosprov");
	curRecibos.select(where);
	var idRecibo:Number;
	while (curRecibos.next()) {
		curRecibos.setModeAccess(curRecibos.Browse);
		curRecibos.refreshBuffer();
		idRecibo = curRecibos.valueBuffer("idrecibo");
		if (!formRecordpagaresprov.iface.pub_asociarReciboPagare(idRecibo, this.iface.curPagare)) {
			return false;
		}
	}

	this.iface.curPagare.select("idpagare = " + idPagare);
	if (this.iface.curPagare.first()) {
		this.iface.curPagare.setModeAccess(this.iface.curPagare.Edit);
		this.iface.curPagare.refreshBuffer();
		
		if (!this.iface.totalesPagare())
			return false;
		
		if (this.iface.curPagare.commitBuffer() == false)
			return false;
	}
	return idPagare;
}

/** \D Informa los datos de una factura a partir de los de uno o varios albaranes
@param	curRecibo: Cursor que contiene algunos de los datos a incluir en el pagaré
@param	curAgrupar: Cursor que contiene algunos de los datos a incluir en el pagaré
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_datosPagare(curRecibo:FLSqlCursor, where:String, curAgrupar:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();
debug("where = " + where );
debug(curRecibo.valueBuffer("codigo"));
debug(curRecibo.valueBuffer("fechav"));
	var codEjercicio:String = flfactppal.iface.pub_ejercicioActual();
	var contabilidad = flfactppal.iface.pub_valorDefectoEmpresa("contintegrada");
	var fechaV:String;
	if (curAgrupar.valueBuffer("sinfechav"))
		fechaV = curRecibo.valueBuffer("fechav");
	else
		fechaV = curAgrupar.valueBuffer("fechav");

	var codCuenta:String = curAgrupar.valueBuffer("codcuenta");

	var datosCuenta:Array = flfactppal.iface.pub_ejecutarQry("cuentasbanco", "ctaentidad,ctaagencia,cuenta", "codcuenta = '" + codCuenta + "'");
	if (datosCuenta.result != 1)
		return false;
	var dc:String = util.calcularDC(datosCuenta.ctaentidad + datosCuenta.ctaagencia) + util.calcularDC(datosCuenta.cuenta);
	
	var codSubcuentaB:String = "";
	var idSubcuentaB:String = "";
	var codSubcuentaP:String = "";
	var idSubcuentaP:String = "";
	if (contabilidad && sys.isLoadedModule("flcontppal")) {
		codSubcuentaB = util.sqlSelect("cuentasbanco", "codsubcuenta", "codcuenta = '" + codCuenta + "'");
		if (!codSubcuentaB) {
			MessageBox.warning(util.translate("scripts", "La cuenta bancaria %1 no tiene cuenta contable asignada").arg(codCuenta), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		idSubcuentaB = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuentaB + "' AND codejercicio = '" + codEjercicio + "'");
		if (!idSubcuentaB) {
			MessageBox.warning(util.translate("scripts", "No hay ninguna subcuenta definida con el valor %1 para el ejercicio %2").arg(codSubcuentaB).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		codSubcuentaP = util.sqlSelect("cuentasbanco", "codsubcuentap", "codcuenta = '" + codCuenta + "'");
		if (!codSubcuentaP) {
			MessageBox.warning(util.translate("scripts", "La cuenta bancaria %1 no tiene cuenta contable de pagarés asignada").arg(codCuenta), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		idSubcuentaP = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuentaP + "' AND codejercicio = '" + codEjercicio + "'");
		if (!idSubcuentaP) {
			MessageBox.warning(util.translate("scripts", "No hay ninguna subcuenta definida con el valor %1 para el ejercicio %2").arg(codSubcuentaP).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	var secuencia:Number;
	with (this.iface.curPagare) {
		setValueBuffer("codcuenta", codCuenta);
		setValueBuffer("prefijo", flfactppal.iface.pub_valorDefectoEmpresa("prefijopag"));
		secuencia = formRecordpagaresprov.iface.pub_commonCalculateField("secuencia", this);
		if (!secuencia || isNaN(secuencia)) {
			MessageBox.warning(util.translate("scripts", "No se ha podido obtener el número de secuencia para la cuenta bancaria %1.\nVerifique que los rangos de secuencia de esta cuenta son suficientes").arg(codCuenta), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		setValueBuffer("secuencia", secuencia);
		setValueBuffer("serie", formRecordpagaresprov.iface.pub_commonCalculateField("serie", this));
		setValueBuffer("dcn", formRecordpagaresprov.iface.pub_commonCalculateField("dcn", this));
		setValueBuffer("numero", formRecordpagaresprov.iface.pub_commonCalculateField("numero", this));
		setValueBuffer("codproveedor", curRecibo.valueBuffer("codproveedor"));
		setValueBuffer("nombreproveedor", curRecibo.valueBuffer("nombreproveedor"));
		setValueBuffer("fecha", curAgrupar.valueBuffer("fechae"));
		setValueBuffer("fechav", fechaV);
debug("fecha = " + curAgrupar.valueBuffer("fechae"));
debug("fechaV = " + fechaV);
		setValueBuffer("ctaentidad", datosCuenta.ctaentidad);
		setValueBuffer("ctaagencia", datosCuenta.ctaagencia);
		setValueBuffer("dc", dc);
		setValueBuffer("cuenta", datosCuenta.cuenta);
		if (codSubcuentaB != "") {
			setValueBuffer("codsubcuentab",  codSubcuentaB);
			setValueBuffer("idsubcuentab",  idSubcuentaB);
			setValueBuffer("codsubcuentap",  codSubcuentaP);
			setValueBuffer("idsubcuentap",  idSubcuentaP);
		}
		setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		setValueBuffer("estado", "Emitido");
	}
	return true;
}

/** \D Informa los datos de un pagaré referentes a totales
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function oficial_totalesPagare():Boolean
{
	with (this.iface.curPagare) {
		setValueBuffer("total", formRecordpagaresprov.iface.pub_commonCalculateField("total", this));
	}
	return true;
}

function oficial_botonAnular()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("estado") == "Emitido") {
		this.iface.pbnAnularPagare.enabled = true;
		this.iface.pbnAnularPagare.text = "Anular";
	}
	else if (cursor.valueBuffer("estado") == "Anulado") {
		this.iface.pbnAnularPagare.enabled = true;
		this.iface.pbnAnularPagare.text = "No Anular";
	}
	else {
		this.iface.pbnAnularPagare.enabled = false;
		this.iface.pbnAnularPagare.text = "--";
	}
}

function oficial_anularPagare_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("estado") == "Emitido") {
		var res:Number = MessageBox.information(util.translate("scripts", "Va a anular el pagaré número:%1\n¿Está seguro?").arg(cursor.valueBuffer("numero")), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes)
			return false;
	
		cursor.transaction(false);
	
		try {
			if (!this.iface.anularPagare()) {
				cursor.rollback();
				return false;
			}
			cursor.commit();
		}
		catch (e) {
			cursor.rollback();
			MessageBox.critical(util.translate("scripts","Hubo un error al anular el pagaré: ") + e, MessageBox.Ok, MessageBox.NoButton);
		}
		return false;
	}
	
	if (cursor.valueBuffer("estado") == "Anulado") {
		var res:Number = MessageBox.information(util.translate("scripts", "Va quitar el pagaré número:%1\ncomo anulado. ¿Está seguro?").arg(cursor.valueBuffer("numero")), MessageBox.Yes, MessageBox.No);
		if (res != MessageBox.Yes)
			return false;
	
		cursor.transaction(false);
	
		try {
			if (!this.iface.quitarPagareAnulado()) {
				cursor.rollback();
				return false;
			}
			cursor.commit();
		}
		catch (e) {
			cursor.rollback();
			MessageBox.critical(util.translate("scripts","Hubo un error al quitar el pagaré como anulado: ") + e, MessageBox.Ok, MessageBox.NoButton);
		}
		return false;
	}
}

function oficial_anularPagare():Boolean
{
	var cursor:FLSqlCursor = this.cursor();

	var qryRecibos:FLSqlCursor = new FLSqlQuery;
	qryRecibos.setTablesList("pagosdevolprov");
	qryRecibos.setSelect("idrecibo");
	qryRecibos.setFrom("pagosdevolprov");
	qryRecibos.setWhere("idpagare = " + cursor.valueBuffer("idpagare"));

	if (!qryRecibos.exec())
		return false;

	var hoy:Date = new Date();
	while (qryRecibos.next()) {
		var curPago:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
		curPago.setModeAccess(curPago.Insert);
		curPago.refreshBuffer();
		curPago.setValueBuffer("fecha", hoy);
		curPago.setValueBuffer("tipo", "Pag.Anulado");
		curPago.setValueBuffer("idrecibo", qryRecibos.value("idrecibo"));
		curPago.setValueBuffer("idpagare", cursor.valueBuffer("idpagare"));
		
		if(!curPago.commitBuffer())
			return false;

		var curRecibo:FLSqlCursor = new FLSqlCursor("recibosprov");
		curRecibo.select("idrecibo = " + qryRecibos.value("idrecibo"));
		if (!curRecibo.first())
			return false;
		curRecibo.setModeAccess(curRecibo.Edit);
		curRecibo.refreshBuffer();
		curRecibo.setValueBuffer("estado", "Emitido");
		if(!curRecibo.commitBuffer())
			return false;
	}
	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
	cursor.setValueBuffer("estado", "Anulado");
	if (!cursor.commitBuffer())
		return false;

	return true;
}

function oficial_quitarPagareAnulado():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var codRecibo:String;

	var qryRecibos:FLSqlCursor = new FLSqlQuery;
	qryRecibos.setTablesList("pagosdevolprov");
	qryRecibos.setSelect("idrecibo");
	qryRecibos.setFrom("pagosdevolprov");
	qryRecibos.setWhere("idpagare = " + cursor.valueBuffer("idpagare") + " AND tipo = 'Pag.Anulado'");

	if (!qryRecibos.exec())
		return false;

	while (qryRecibos.next()) {
 		var idPagoDevol:String = util.sqlSelect("pagosdevolprov", "idpagodevol", "idrecibo = " + qryRecibos.value("idrecibo") + " ORDER BY fecha DESC, idpagodevol DESC");
		if (!idPagoDevol || idPagoDevol == "") {
			codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + qryRecibos.value("idrecibo"));
			MessageBox.information(util.translate("scripts", "No hay pagos asociados al recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}

 		var tipo:String = util.sqlSelect("pagosdevolprov", "tipo", "idpagodevol = " + idPagoDevol);
		if (tipo != "Pag.Anulado") {
			codRecibo = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + qryRecibos.value("idrecibo"));
			MessageBox.information(util.translate("scripts", "No hay pagos del tipo Pag.Anulado asociados al recibo %1").arg(codRecibo), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
		var curPago:FLSqlCursor = new FLSqlCursor("pagosdevolprov");
		curPago.select("idpagodevol = " + idPagoDevol);
		if (!curPago.first())
			return false;
		curPago.setModeAccess(curPago.Del);
		curPago.refreshBuffer();
		
		if(!curPago.commitBuffer())
			return false;

		var curRecibo:FLSqlCursor = new FLSqlCursor("recibosprov");
		curRecibo.select("idrecibo = " + qryRecibos.value("idrecibo"));
		if (!curRecibo.first())
			return false;
		curRecibo.setModeAccess(curRecibo.Edit);
		curRecibo.refreshBuffer();
		curRecibo.setValueBuffer("estado", "Pagaré");
		if(!curRecibo.commitBuffer())
			return false;

	}
	cursor.setModeAccess(cursor.Edit);
	cursor.refreshBuffer();
	cursor.setValueBuffer("estado", "Emitido");
	if (!cursor.commitBuffer())
		return false;

	return true;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
