/***************************************************************************
                 co_modelo115.qs  -  description
                             -------------------
    begin                : jue mar 26 2009
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
    function calculateField(fN:String):String { 
		return this.ctx.interna_calculateField(fN); 
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
	function habilitarPeriodo() {
		return this.ctx.oficial_habilitarPeriodo();
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
	
	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnCalcularValores"), "clicked()", this, "iface.pbnCalcularValores");
	connect(this.child("pbnVerDetalle"), "clicked()", this, "iface.pbnVerDetalle");
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.child("fdbCodEjercicio").setValue(flfactppal.iface.pub_ejercicioActual());
		this.iface.informarConDatosFiscales();
	}
	
	this.iface.habilitarPeriodo();
	this.iface.establecerFechasPeriodo();
	this.iface.bufferChanged("complementaria");
}

function interna_validateForm():Boolean
{
	if (!this.iface.comprobarFechas()) {
		return false;
	}
}

function interna_calculateField(fN:String):String
{
	var valor:String;
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	switch (fN) {
		case "dc": {
			var entidad:String = cursor.valueBuffer("entidad");
			var agencia:String = cursor.valueBuffer("agencia");
			var cuenta:String = cursor.valueBuffer("cuenta");
			
			if (!entidad) entidad = "";
			if (!agencia) agencia = "";
			if (!cuenta) cuenta = "";
			
			if ( !entidad.isEmpty() && !agencia.isEmpty() && ! cuenta.isEmpty() && entidad.length == 4 && agencia.length == 4 && cuenta.length == 10 ) {
				var dc1:String = util.calcularDC(entidad + agencia);
				var dc2:String = util.calcularDC(cuenta);
				valor = dc1 + dc2;
			}
			break;
		}
		case "resultado": {
			valor = parseFloat(cursor.valueBuffer("retenciones")) - parseFloat(cursor.valueBuffer("adeducir"));
			break;
		}
	}
	return valor;
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
		case "tipoperiodo": {
			this.iface.habilitarPeriodo();
			this.iface.establecerFechasPeriodo();
		}
		case "mes":
		case "trimestre": {
			this.iface.establecerFechasPeriodo();
			break;
		}
		case "agencia":
		case "entidad": 
		case "cuenta": {
			this.child("fdbDc").setValue(this.iface.calculateField("dc"));
			break;
		}
		case "complementaria": {
			if (cursor.valueBuffer("complementaria") == true) {
				this.child("fdbCodigoAnterior").setDisabled(false);
				this.child("fdbNumJustifAnt").setDisabled(false);
				this.child("fdbAdeducir").setDisabled(false);
			} else {
				this.child("fdbCodigoAnterior").setValue("");
				this.child("fdbNumJustifAnt").setValue("");
				this.child("fdbAdeducir").setValue("");
				this.child("fdbCodigoAnterior").setDisabled(true);
				this.child("fdbNumJustifAnt").setDisabled(true);
				this.child("fdbAdeducir").setDisabled(true);
			}
			break;
		}
		case "retenciones":
		case "adeducir": {
			this.child("fdbResultado").setValue(this.iface.calculateField("resultado"));	
			break;
		}
		case "resultado": {
			this.child("fdbIngreso").setValue(this.iface.calculateField("resultado"));	
			break;
		}
	}
}	


/** \D Establece las fechas de inicio y fin de trimestre en función del trimestre seleccionado
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
	
	switch (cursor.valueBuffer("tipoperiodo")) {
		case "Trimestre": {
			switch (cursor.valueBuffer("trimestre")) {
				case "1T": {
					fechaInicio.setMonth(1);
					fechaFin.setMonth(3);
					fechaFin.setDate(31);
					break;
				}
				case "2T": {
					fechaInicio.setMonth(4);
					fechaFin.setMonth(6);
					fechaFin.setDate(30);
					break;
				}
				case "3T":
					fechaInicio.setMonth(7);
					fechaFin.setMonth(9);
					fechaFin.setDate(30);
					break;
				case "4T": {
					fechaInicio.setMonth(10);
					fechaFin.setMonth(12);
					fechaFin.setDate(31);
					break;
				}
				default: {
					fechaInicio = false;
				}
			}
			break;
		}
		case "Mes": {
			switch (cursor.valueBuffer("mes")) {
				case "Enero": {
					fechaInicio.setMonth(1);
					fechaFin.setMonth(1);
					fechaFin.setDate(31);
					break;
				}
				case "Febrero": {
					fechaInicio.setMonth(2);
					fechaFin.setMonth(2);
					fechaFin.setDate(28);
					break;
				}
				case "Marzo": {
					fechaInicio.setMonth(3);
					fechaFin.setMonth(3);
					fechaFin.setDate(31);
					break;
				}
				case "Abril": {
					fechaInicio.setMonth(4);
					fechaFin.setMonth(4);
					fechaFin.setDate(30);
					break;
				}
				case "Mayo": {
					fechaInicio.setMonth(5);
					fechaFin.setMonth(5);
					fechaFin.setDate(31);
					break;
				}
				case "Junio": {
					fechaInicio.setMonth(6);
					fechaFin.setMonth(6);
					fechaFin.setDate(30);
					break;
				}
				case "Julio": {
					fechaInicio.setMonth(7);
					fechaFin.setMonth(7);
					fechaFin.setDate(31);
					break;
				}
				case "Agosto": {
					fechaInicio.setMonth(8);
					fechaFin.setMonth(8);
					fechaFin.setDate(31);
					break;
				}
				case "Septiembre": {
					fechaInicio.setMonth(9);
					fechaFin.setMonth(9);
					fechaFin.setDate(30);
					break;
				}
				case "Octubre": {
					fechaInicio.setMonth(10);
					fechaFin.setMonth(10);
					fechaFin.setDate(31);
					break;
				}
				case "Noviembre": {
					fechaInicio.setMonth(11);
					fechaFin.setMonth(11);
					fechaFin.setDate(30);
					break;
				}
				case "Diciembre": {
					fechaInicio.setMonth(12);
					fechaFin.setMonth(12);
					fechaFin.setDate(31);
					break;
				}
				default: {
					fechaInicio = false;
				}
			}
			break;
		}
	}
	
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

function oficial_habilitarPeriodo()
{
	var cursor:FLSqlCursor = this.cursor();

	if (cursor.valueBuffer("tipoperiodo") == "Mes") {
		this.child("fdbMes").setShowAlias(true);
		this.child("fdbMes").setShowEditor(true);
		this.child("fdbTrimestre").setShowAlias(false);
		this.child("fdbTrimestre").setShowEditor(false);
	} else {
		this.child("fdbTrimestre").setShowAlias(true);
		this.child("fdbTrimestre").setShowEditor(true);
		this.child("fdbMes").setShowAlias(false);
		this.child("fdbMes").setShowEditor(false);
	}
}

function oficial_pbnCalcularValores()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!util.sqlDelete("co_detalle115", "idmodelo = " + cursor.valueBuffer("idmodelo"))) {
		return false;
	}
	if (!this.child("tdbDetalle").cursor().commitBufferCursorRelation()) {
		return false;
	}

	var fechaInicio:String = cursor.valueBuffer("fechainicio");
	var fechaFin:String = cursor.valueBuffer("fechafin");
	var qryFacturasProv:FLSqlQuery = new FLSqlQuery();
	qryFacturasProv.setTablesList("facturasprov");
	qryFacturasProv.setSelect("codproveedor,nombre,SUM(neto),SUM(totalirpf)");
	qryFacturasProv.setFrom("facturasprov");
	qryFacturasProv.setWhere("incluir115 = true AND fecha BETWEEN '" + fechaInicio + "' AND '" + fechaFin + "' GROUP BY codproveedor, nombre");
	if (!qryFacturasProv.exec()) {
		return false;
	}

	var base:Number = 0;
	var retencion:Number = 0;
	while (qryFacturasProv.next()) {
		var curDetalle:FLSqlCursor = new FLSqlCursor("co_detalle115");
		curDetalle.setModeAccess(curDetalle.Insert);
		curDetalle.refreshBuffer();
		curDetalle.setValueBuffer("idmodelo", cursor.valueBuffer("idmodelo"));
		curDetalle.setValueBuffer("codproveedor", qryFacturasProv.value("codproveedor"));
		curDetalle.setValueBuffer("nombre", qryFacturasProv.value("nombre"));
		curDetalle.setValueBuffer("base", qryFacturasProv.value("SUM(neto)"));
		curDetalle.setValueBuffer("retencion", qryFacturasProv.value("SUM(totalirpf)"));
		if (!curDetalle.commitBuffer()) {
			return false;
		}
		base += parseFloat(qryFacturasProv.value("SUM(neto)"));
		retencion += parseFloat(qryFacturasProv.value("SUM(totalirpf)"));
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
	var f:Object = new FLFormSearchDB("co_facturasprov115");
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
		var primerAp:String = util.sqlSelect("co_datosfiscales", "apellidospf", "1 = 1");
		if (primerAp) {
			this.child("fdbComienzoAp").setValue(primerAp.left(4));
		}
	}
	var codTipoVia:String = util.sqlSelect("co_datosfiscales", "codtipovia", "1 = 1");
	if (codTipoVia) {
		this.child("fdbCodTipoVia").setValue(codTipoVia);
	}
	var nombreVia:String = util.sqlSelect("co_datosfiscales", "nombrevia", "1 = 1");
	if (nombreVia) {
		this.child("fdbNombreVia").setValue(nombreVia);
	}
	var numero:String = util.sqlSelect("co_datosfiscales", "numero", "1 = 1");
	if (numero) {
		this.child("fdbNumero").setValue(numero);
	}
	var escalera:String = util.sqlSelect("co_datosfiscales", "escalera", "1 = 1");
	if (escalera) {
		this.child("fdbEscalera").setValue(escalera);
	}
	var piso:String = util.sqlSelect("co_datosfiscales", "piso", "1 = 1");
	if (piso) {
		this.child("fdbPiso").setValue(piso);
	}
	var puerta:String = util.sqlSelect("co_datosfiscales", "puerta", "1 = 1");
	if (puerta) {
		this.child("fdbPuerta").setValue(puerta);
	}
	var codPostal:String = util.sqlSelect("co_datosfiscales", "codpos", "1 = 1");
	if (codPostal) {
		this.child("fdbCodPostal").setValue(codPostal);
	}
	var municipio:String = util.sqlSelect("co_datosfiscales", "municipio", "1 = 1");
	if (municipio) {
		this.child("fdbMunicipio").setValue(municipio);
	}
	var idProvincia:String = util.sqlSelect("co_datosfiscales", "idprovincia", "1 = 1");
	if (idProvincia) {
		this.child("fdbIdProvincia").setValue(idProvincia);
	}
	var codProvincia:String = util.sqlSelect("co_datosfiscales", "codprovincia", "1 = 1");
	if (codProvincia) {
		this.child("fdbCodProvincia").setValue(codProvincia);
	}
	var provincia:String = util.sqlSelect("co_datosfiscales", "provincia", "1 = 1");
	if (provincia) {
		this.child("fdbProvincia").setValue(provincia);
	}
	var contacto:String = util.sqlSelect("co_datosfiscales", "nombre", "1 = 1");
	if (contacto) {
		this.child("fdbContacto").setValue(contacto);
	}
	var telefono:String = util.sqlSelect("co_datosfiscales", "telefono", "1 = 1");
	if (telefono) {
		this.child("fdbTelefono").setValue(telefono);
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
