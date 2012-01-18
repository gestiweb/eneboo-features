/***************************************************************************
                      vdisco58.qs  -  description
                             -------------------
    begin                : vie abr 23 2004
    copyright            : (C) 2005 by InfoSiAL S.L.
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
	function acceptedForm() {
		return this.ctx.interna_acceptedForm();
	}
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); }
	function establecerFichero() {
		return this.ctx.oficial_establecerFichero();
	}
	function cabeceraPresentador():String {
		return this.ctx.oficial_cabeceraPresentador();
	}
	function cabeceraOrdenante():String {
		return this.ctx.oficial_cabeceraOrdenante();
	}
	function individualObligatorio(query:FLSqlQuery):String {
		return this.ctx.oficial_individualObligatorio(query);
	}
	function registroDomicilio(query:FLSqlQuery):String {
		return this.ctx.oficial_registroDomicilio(query);
	}
	function totalOrdenante(nRecibos:Number):String {
		return this.ctx.oficial_totalOrdenante(nRecibos);
	}
	function totalGeneral(nRecibos:Number):String {
		return this.ctx.oficial_totalGeneral(nRecibos);
	}
	function conceptoIO(qryRecibos:FLSqlQuery):String {
		return this.ctx.oficial_conceptoIO(qryRecibos);
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
/** \D No de muestran los botones estándar de un formulario de registro
*/
function init()
{
	return this.iface.init();
}
function validateForm():Boolean
{
	return this.iface.validateForm();
}
function acceptedForm()
{
	return this.iface.acceptedForm();
}

function interna_init()
{
	this.child("fdbDivisa").setDisabled(true);
	this.child("pushButtonAcceptContinue").close();
	this.child("pushButtonFirst").close();
	this.child("pushButtonLast").close();
	this.child("pushButtonNext").close();
	this.child("pushButtonPrevious").close();
	connect(this.child("pbExaminar"), "clicked()", this, "iface.establecerFichero");
}

/** \C El nombre del fichero de destino debe indicarse
*/
function interna_validateForm()
{
	if (this.child("leFichero").text.isEmpty()) {
		var util:FLUtil = new FLUtil();
		MessageBox.warning(util. translate("scripts", "Hay que indicar el fichero."), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	if (!flfactteso.iface.pub_comprobarCuentasDom(this.cursor().valueBuffer("idremesa")))
		return false;
		
	return true;
}

/** \C Se genera el fichero de texto con los datos de la remesa en el fichero especificado
*/
function interna_acceptedForm()
{
	var file = new File(this.child("leFichero").text);
	file.open(File.WriteOnly);

	file.write(this.iface.cabeceraPresentador() + "\r\n");
	file.write(this.iface.cabeceraOrdenante() + "\r\n");

	var cursor:FLSqlCursor = this.cursor();
	var qryRecibos:FLSqlQuery = new FLSqlQuery();
	if (this.child("chkAgruparCliente").checked) {
		with (qryRecibos) {
			setTablesList("reciboscli");
			setSelect("SUM(importe), fechav, codcliente, cifnif, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta, fecha, direccion, ciudad, codpostal");
			setFrom("reciboscli");
// 			setWhere("idremesa = " + cursor.valueBuffer("idremesa") + " GROUP BY fechav, codcliente, cifnif, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta, fecha, direccion, ciudad, codpostal");
			setWhere("idrecibo IN (SELECT pd.idrecibo FROM pagosdevolcli pd WHERE pd.idremesa = " + cursor.valueBuffer("idremesa") + ") GROUP BY fechav, codcliente, cifnif, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta, fecha, direccion, ciudad, codpostal");
			setForwardOnly(true);
		}
	} else {
		with (qryRecibos) {
			setTablesList("reciboscli");
			setSelect("importe, codigo, fechav, codcliente, cifnif, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta, fecha, direccion, ciudad, codpostal");
			setFrom("reciboscli");
// 			setWhere("idremesa = " + cursor.valueBuffer("idremesa"));
			setWhere("idrecibo IN (SELECT pd.idrecibo FROM pagosdevolcli pd WHERE pd.idremesa = " + cursor.valueBuffer("idremesa") + ")");
			setForwardOnly(true);
		}
	}
	if (!qryRecibos.exec()) {
		return false;
	}

	var individualObligatorio:String = "";
	var registroDomicilio:String = "";

	while (qryRecibos.next()) {
		individualObligatorio = this.iface.individualObligatorio(qryRecibos);
		file.write(individualObligatorio + "\r\n");
		
		registroDomicilio = this.iface.registroDomicilio(qryRecibos);
		if (registroDomicilio != "") {
			file.write(registroDomicilio + "\r\n");
		}
	}

	file.write(this.iface.totalOrdenante(qryRecibos.size()) + "\r\n");
	file.write(this.iface.totalGeneral(qryRecibos.size()) + "\r\n");

	file.close();

	// Genera copia del fichero en codificacion ISO
    // ### Por hacer: Incluir mas codificaciones
    file.open( File.ReadOnly );
    var content = file.read();
    file.close();

    var fileIso = new File( this.child("leFichero").text + ".iso8859" );

    fileIso.open(File.WriteOnly);
    fileIso.write( sys.fromUnicode( content, "ISO-8859-15" ) );
    fileIso.close();

	var util:FLUtil = new FLUtil();
	MessageBox.information(util.translate("scripts", "Generado fichero de recibos en :\n\n" + this.child("leFichero").text + "\n\n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerFichero()
{
	this.child("leFichero").text = FileDialog.getSaveFileName("*.*");
}

/** \D Crea el texto de cabecera con los datos del presentador de la remesa

@return Texto con los dato para ser volcados a fichero
*/
function oficial_cabeceraPresentador():String
{
	var util:FLUtil = new FLUtil();
	var reg:String = "5170";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
	var codcuenta:String = this.cursor().valueBuffer("codcuenta");
	var entidad:String = util.sqlSelect("cuentasbanco", "ctaentidad", "codcuenta = '" + codcuenta + "'");
	var agencia:String = util.sqlSelect("cuentasbanco", "ctaagencia", "codcuenta = '" + codcuenta + "'");
	var sufijo:String = util.sqlSelect("cuentasbanco", "sufijoi", "codcuenta = '" + codcuenta + "'");
	sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
	var date:Date = new Date();
	var fecha:String = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(),2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);

	reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
	reg += fecha;
	reg += flfactppal.iface.pub_espaciosDerecha("", 6);
	reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40).left(40);
	reg += flfactppal.iface.pub_espaciosDerecha("", 20);
	reg += entidad + agencia;
	reg += flfactppal.iface.pub_espaciosDerecha("", 66);
	return reg;
}

/** \D Crea el texto de cabecera con los datos del ordenante de la remesa

@return Texto con los dato para ser volcados a fichero
*/
function oficial_cabeceraOrdenante():String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var reg:String = "5370";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
	var codcuenta:String = cursor.valueBuffer("codcuenta");
	var entidad:String = util.sqlSelect("cuentasbanco", "ctaentidad", "codcuenta = '" + codcuenta + "'");
	var agencia:String = util.sqlSelect("cuentasbanco", "ctaagencia", "codcuenta = '" + codcuenta + "'");
	var cuenta:String = util.sqlSelect("cuentasbanco", "cuenta", "codcuenta = '" + codcuenta + "'");
	var sufijo:String = util.sqlSelect("cuentasbanco", "sufijoi", "codcuenta = '" + codcuenta + "'");
	sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
	var date:Date = new Date();
	var fecha = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);

	var dc1:String = util.calcularDC(entidad + agencia);
	var dc2:String = util.calcularDC(cuenta);

	reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
	reg += fecha;
	reg += flfactppal.iface.pub_espaciosDerecha("", 6);
	reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40).left(40);
	reg += entidad + agencia + dc1 + dc2 + cuenta;
	reg += flfactppal.iface.pub_espaciosDerecha("", 8);
	reg += "06";
	reg += flfactppal.iface.pub_espaciosDerecha("", 52);
	reg += flfactppal.iface.pub_espaciosDerecha(this.child("leCodINE").text, 9).left(9);
	reg += flfactppal.iface.pub_espaciosDerecha("", 3);
	return reg;
}

/** \D Crea el texto de cabecera con los datos del presentador de la remesa

@param query query de un recibo
@return Texto con los dato para ser volcados a fichero
*/
function oficial_individualObligatorio(query:FLSqlQuery):String
{
debug("consulta   " + query.sql());
	var util:FLUtil = new FLUtil();
	var reg:String = "5670";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	var ref:String = query.value("cifnif").right(12);
	var nombre:String = query.value("nombrecliente");
	var entidad:String = flfactppal.iface.pub_cerosIzquierda(query.value("ctaentidad"), 4);
	var agencia:String = flfactppal.iface.pub_cerosIzquierda(query.value("ctaagencia"), 4);
	var dc:String = flfactppal.iface.pub_cerosIzquierda(query.value("dc"), 2);
	var cuenta:String = flfactppal.iface.pub_cerosIzquierda(query.value("cuenta"), 10);
	var codcuenta:String = this.cursor().valueBuffer("codcuenta");
	var sufijo:String = util.sqlSelect("cuentasbanco", "sufijoi", "codcuenta = '" + codcuenta + "'");
	sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
	var importe:Number;
	if (this.child("chkAgruparCliente").checked) {
		importe = Math.round(query.value("SUM(importe)") * 100);
	} else {
		importe = Math.round(query.value("importe") * 100);
	}
	var concepto = this.iface.conceptoIO(query);
	concepto = flfactppal.iface.pub_espaciosDerecha(concepto, 40).left(40);

	var date:Date = new Date( query.value("fechav") );
	var fechav:String = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) + flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);

	reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
	reg += flfactppal.iface.pub_espaciosDerecha(ref, 12);
	reg += flfactppal.iface.pub_espaciosDerecha(nombre, 40).left(40);
	reg += entidad + agencia + dc + cuenta;
	reg += flfactppal.iface.pub_cerosIzquierda(importe, 10).right(10);
	reg += flfactppal.iface.pub_cerosIzquierda(0, 16);
	reg += concepto;
	reg += fechav;
	reg += flfactppal.iface.pub_espaciosDerecha("", 2);
	return reg;
}

function oficial_registroDomicilio(query:FLSqlQuery):String
{
	var util:FLUtil = new FLUtil();
	var reg:String = "5676";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	var ref:String = query.value("cifnif").right(12);
	var nombre:String = query.value("nombrecliente");
	var agencia:String = query.value("ctaagencia");
	var codcuenta:String = this.cursor().valueBuffer("codcuenta");
	var sufijo:String = util.sqlSelect("cuentasbanco", "sufijoi", "codcuenta = '" + codcuenta + "'");
	sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
	var concepto:String = "Rcbo. " + query.value("codigo");
	concepto = flfactppal.iface.pub_espaciosDerecha(concepto, 40).left(40);
	var date:Date = new Date( query.value("fecha") );
	var fecha = flfactppal.iface.pub_cerosIzquierda(date.getDate().toString(), 2) +
			flfactppal.iface.pub_cerosIzquierda(date.getMonth().toString(), 2) + date.getYear().toString().right(2);
	var dirDeudor:String = query.value("direccion");
	var plazaDeudor:String = query.value("ciudad");
	var cpDeudor:String = query.value("codpostal");
	var plaza:String = flfactppal.iface.pub_valorDefectoEmpresa("ciudad");
	var cp:String = flfactppal.iface.pub_valorDefectoEmpresa("codpostal");


	reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
	reg += flfactppal.iface.pub_espaciosDerecha(ref, 12);
	reg += flfactppal.iface.pub_espaciosDerecha(dirDeudor, 40).left(40);
	reg += flfactppal.iface.pub_espaciosDerecha(plazaDeudor, 35).left(35);
	reg += flfactppal.iface.pub_cerosIzquierda(cpDeudor, 5).left(5);
	reg += flfactppal.iface.pub_espaciosDerecha(plaza, 38).left(38);
	reg += flfactppal.iface.pub_cerosIzquierda(cp, 2).left(2);
	reg += fecha;
	reg += flfactppal.iface.pub_espaciosDerecha("", 8);
	return reg;
}

/** \D Calcula el total del valor de recibos para el ordenante

@param nRecibos Número de recibos
@return Texto con el total para ser volcado a disco
*/
function oficial_totalOrdenante(nRecibos:Number):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var reg:String = "5870";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
	var codcuenta:String = cursor.valueBuffer("codcuenta");
	var sufijo:String = util.sqlSelect("cuentasbanco", "sufijoi", "codcuenta = '" + codcuenta + "'");
	sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
	var total:Number = Math.round(cursor.valueBuffer("total") * 100);

	reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
	reg += flfactppal.iface.pub_espaciosDerecha("", 72);
	reg += flfactppal.iface.pub_cerosIzquierda(total, 10).right(10);
	reg += flfactppal.iface.pub_espaciosDerecha("", 6);
	reg += flfactppal.iface.pub_cerosIzquierda(nRecibos, 10).right(10);
	reg += flfactppal.iface.pub_cerosIzquierda((nRecibos * 2) + 2, 10).right(10);
	reg += flfactppal.iface.pub_espaciosDerecha("", 38);
	return reg;
}

/** \D Calcula el total del valor de recibos general

@param nRecibos Número de recibos
@return Texto con el total para ser volcado a disco
*/
function oficial_totalGeneral(nRecibos:Number):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var reg:String = "5970";
	var cifnif:String = flfactppal.iface.pub_valorDefectoEmpresa("cifnif");
	var nombre:String = flfactppal.iface.pub_valorDefectoEmpresa("nombre");
	var codcuenta:String = cursor.valueBuffer("codcuenta");
	var sufijo:String = util.sqlSelect("cuentasbanco", "sufijoi", "codcuenta = '" + codcuenta + "'");
	sufijo = flfactppal.iface.pub_cerosIzquierda(sufijo, 3);
	var total:Number = Math.round(cursor.valueBuffer("total") * 100);

	reg += flfactppal.iface.pub_cerosIzquierda(cifnif + sufijo, 12).right(12);
	reg += flfactppal.iface.pub_espaciosDerecha("", 52);
	reg += flfactppal.iface.pub_cerosIzquierda(1, 4);
	reg += flfactppal.iface.pub_espaciosDerecha("", 16);
	reg += flfactppal.iface.pub_cerosIzquierda(total, 10).right(10);
	reg += flfactppal.iface.pub_espaciosDerecha("", 6);
	reg += flfactppal.iface.pub_cerosIzquierda(nRecibos, 10).right(10);
	reg += flfactppal.iface.pub_cerosIzquierda((nRecibos * 2) + 4, 10).right(10);
	reg += flfactppal.iface.pub_espaciosDerecha("", 38);
	return reg;
}

function oficial_conceptoIO(qryRecibos:FLSqlQuery):String
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();

	var concepto:String = "";
	if (this.child("chkAgruparCliente").checked) {
		concepto = "Fra";
		var qryFras:FLSqlQuery = new FLSqlQuery;
		with (qryFras) {
			setTablesList("reciboscli");
			setSelect("idfactura");
			setFrom("reciboscli");
			setWhere("idremesa = " + cursor.valueBuffer("idremesa") + " AND codcliente = '" + qryRecibos.value("codcliente") + "' AND codcuenta = '" + qryRecibos.value("codcuenta") + "' GROUP BY idfactura");
			setForwardOnly(true);
		}
		if (!qryFras.exec()) {
			return false;
		}
		while (qryFras.next()) {
			var numFactura:String = util.sqlSelect("facturascli", "numero", "idfactura = " + qryFras.value("idfactura"));
			if (!numFactura) {
				numFactura = "";
			}
			if (concepto.length + numFactura.toString().length + 1 > 40) {
				break;
			}
			if (concepto == "Fra") {
				concepto += " " + numFactura;
			} else {
				concepto += "," + numFactura;
			}
		}
	} else {
		concepto = "R." + qryRecibos.value("codigo");
	}
	return concepto;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
