/***************************************************************************
                 co_modelo180.qs  -  description
                             -------------------
    begin                : mar mar 30 2009
    copyright            : (C) 2009 by InfoSiAL S.L.
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
		return this.ctx.interna_init(); 
	}
	function validateForm():Boolean {
		return this.ctx.interna_validateForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function establecerFechasPeriodo() {
		return this.ctx.oficial_establecerFechasPeriodo();
	}
	function comprobarFechas():String {
		return this.ctx.oficial_comprobarFechas();
	}
	function informarConDatosFiscales() {
		return this.ctx.oficial_informarConDatosFiscales();
	}
	function pbnCalcularValores() {
		return this.ctx.oficial_pbnCalcularValores();
	}
	function pbnVerDetalle() {
		return this.ctx.oficial_pbnVerDetalle();
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
/** \C El ejercicio por defecto al crear un nuevo modelo es el ejercicio marcado como actual en el formulario de empresa
\end */
function interna_init() 
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var hoy:Date = new Date();
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnCalcularValores"), "clicked()", this, "iface.pbnCalcularValores");
	connect(this.child("pbnVerDetalle"), "clicked()", this, "iface.pbnVerDetalle");
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.iface.informarConDatosFiscales();
	}
	
	this.iface.establecerFechasPeriodo();
	this.iface.bufferChanged("sustitutiva");
}

function interna_validateForm():Boolean
{
	if (!this.iface.comprobarFechas()) {
		return false;
	}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged( fN ) 
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	switch ( fN ) {
		case "sustitutiva": {
			if (cursor.valueBuffer("sustitutiva") == true) {
				this.child("fdbNumJustifAnt").setDisabled(false);
			} else {
				this.child("fdbNumJustifAnt").setValue("");
				this.child("fdbNumJustifAnt").setDisabled(true);
			}
			break;
		}
		case "codejercicio": {
			this.iface.establecerFechasPeriodo();
			break;
		}
	}
}


/** \D Establece las fechas de inicio y fin de año en función del año seleccionado
\end */
function oficial_establecerFechasPeriodo()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var fechaInicio:Date;
	var fechaFin:Date;
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var inicioEjercicio = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
		
	if (!inicioEjercicio) {
		return false;
	}
	
	fechaInicio.setYear(inicioEjercicio.getYear());
	fechaFin.setYear(inicioEjercicio.getYear());
	fechaInicio.setDate(1);
	fechaInicio.setMonth(1);
	fechaFin.setMonth(12);
	fechaFin.setDate(31);
	
	if (fechaInicio) {
		this.child("fdbFechaInicio").setValue(fechaInicio);
		this.child("fdbFechaFin").setValue(fechaFin);
	} else {
		cursor.setNull("fechainicio");
		cursor.setNull("fechafin");
	}
}

/** \D Comprueba que fechainicio < fechafin y que ambas pertenecen al ejercicio seleccionado

@return	True si la comprobación es buena, false en caso contrario
\end */
function oficial_comprobarFechas():Boolean
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicio:String = this.child("fdbCodEjercicio").value();
	var fechaInicio:String = this.child("fdbFechaInicio").value();
	var fechaFin:String = this.child("fdbFechaFin").value();

	if (util.daysTo(fechaInicio, fechaFin) < 0) {
		MessageBox.critical(util.translate("scripts", "La fecha de inicio debe ser menor que la de fin"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	var inicioEjercicio:String = util.sqlSelect("ejercicios", "fechainicio", "codejercicio = '" + codEjercicio + "'");
	var finEjercicio:String = util.sqlSelect("ejercicios", "fechafin", "codejercicio = '" + codEjercicio + "'");

	if ((util.daysTo(inicioEjercicio, fechaInicio) < 0) || (util.daysTo(fechaFin, finEjercicio) < 0)) {
		MessageBox.critical(util.translate("scripts", "Las fechas seleccionadas no corresponden al ejercicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

function oficial_pbnCalcularValores()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!util.sqlDelete("co_detalle180", "idmodelo = " + cursor.valueBuffer("idmodelo"))) {
		return false;
	}
	if (!this.child("tdbDetalle").cursor().commitBufferCursorRelation()) {
		return false;
	}

	var fechaInicio:String = cursor.valueBuffer("fechainicio");
	var fechaFin:String = cursor.valueBuffer("fechafin");
	var qryFacturasProv:FLSqlQuery = new FLSqlQuery();
	qryFacturasProv.setTablesList("facturasprov,proveedores");
	qryFacturasProv.setSelect("f.codproveedor,f.nombre,SUM(f.neto),SUM(f.totalirpf),p.cifnif");
	qryFacturasProv.setFrom("facturasprov f INNER JOIN proveedores p ON f.codproveedor = p.codproveedor");
	qryFacturasProv.setWhere("f.incluir115 = true AND f.fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "' GROUP BY f.codproveedor, f.nombre, p.cifnif");
	if (!qryFacturasProv.exec()) {
		return false;
	}

	var base:Number = 0;
	var retencion:Number = 0;
	while (qryFacturasProv.next()) {
		var curDetalle:FLSqlCursor = new FLSqlCursor("co_detalle180");
		curDetalle.setModeAccess(curDetalle.Insert);
		curDetalle.refreshBuffer();
		curDetalle.setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
		curDetalle.setValueBuffer("codproveedor", qryFacturasProv.value("f.codproveedor"));
		curDetalle.setValueBuffer("nifproveedor", qryFacturasProv.value("p.cifnif"));
		curDetalle.setValueBuffer("nifrepresentante", "");
		curDetalle.setValueBuffer("nombre", qryFacturasProv.value("f.nombre"));

		var codProvincia:String = util.sqlSelect("dirproveedores d INNER JOIN provincias p ON d.idprovincia = p.idprovincia", "codigo", "d.direccionppal = true AND d.codproveedor = '" + qryFacturasProv.value("f.codproveedor") + "'", "dirproveedores,provincias");

		if (codProvincia) {
			curDetalle.setValueBuffer("codprovincia", codProvincia);
		}

		curDetalle.setValueBuffer("base", qryFacturasProv.value("SUM(f.neto)"));

		var porRetencion:Number = util.sqlSelect("series s INNER JOIN proveedores p ON s.codserie = p.codserie", "s.irpf", "p.codproveedor = '" + qryFacturasProv.value("f.codproveedor") + "'", "series,proveedores");
		if (porRetencion) {
			curDetalle.setValueBuffer("porretencion", porRetencion);
		}

		curDetalle.setValueBuffer("retencion", qryFacturasProv.value("SUM(f.totalirpf)"));
		if (!curDetalle.commitBuffer()) {
			return false;
		}
		base += parseFloat(qryFacturasProv.value("SUM(f.neto)"));
		retencion += parseFloat(qryFacturasProv.value("SUM(f.totalirpf)"));
	}
	this.child("fdbNumPercep").setValue(qryFacturasProv.size());
	this.child("fdbBaseRetenciones").setValue(base);
	this.child("fdbRetenciones").setValue(retencion);
	this.child("tdbDetalle").refresh();
}

function oficial_pbnVerDetalle()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var codProveedor:String = this.child("tdbDetalle").cursor().valueBuffer("codproveedor");
	var fechaInicio:String = cursor.valueBuffer("fechainicio");
	var fechaFin:String = cursor.valueBuffer("fechafin");
	var f:Object = new FLFormSearchDB("co_facturasprov180");
	var curFacturas:FLSqlCursor = f.cursor();
	
	curFacturas.setMainFilter("incluir115 = true AND codproveedor = '" + codProveedor + "' AND fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "'");

	f.setMainWidget();
	if (f.exec()) {
		return false;
	}
}

function oficial_informarConDatosFiscales()
{
	var util:FLUtil = new FLUtil();
	var cifNif:String = util.sqlSelect("co_datosfiscales", "cifnif", "1 = 1");
	if (cifNif) {
		this.child("fdbCifNif").setValue(cifNif);
	}
	var apellidosRS:String = util.sqlSelect("co_datosfiscales", "apellidosrs", "1 = 1");
	if (apellidosRS) {
		this.child("fdbApellidosOrs").setValue(apellidosRS);
	}
	var personaFisica:Boolean = util.sqlSelect("co_datosfiscales", "personafisica", "1 = 1");
	if (personaFisica) {
		var nombrepf:String = util.sqlSelect("co_datosfiscales", "nombrepf", "1 = 1");
		if (nombrepf) {
			this.child("fdbNombre").setValue(nombrepf);
		}
	}
	var contacto:String = util.sqlSelect("co_datosfiscales", "nombre", "1 = 1");
	if (contacto) {
		this.child("fdbContacto").setValue(contacto);
	}
	var telefono:String = util.sqlSelect("co_datosfiscales", "telefono", "1 = 1");
	if (telefono) {
		this.child("fdbTelefContacto").setValue(telefono);
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
