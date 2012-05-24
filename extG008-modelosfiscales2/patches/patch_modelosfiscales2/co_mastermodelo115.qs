/***************************************************************************
                 co_mastermodelo115.qs  -  description
                             -------------------
    begin                : vie mar 27 2009
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); }
	function presTelematica() {
		return this.ctx.oficial_presTelematica();
	}
	function errorAcumuladoControl(acumuladoControl:Number, nombreDato:String):Boolean {
		return this.ctx.oficial_errorAcumuladoControl(acumuladoControl, nombreDato);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
function interna_init()
{
	this.child("toolButtonPrint").close();
	connect (this.child("toolButtonAeat"), "clicked()", this, "iface.presTelematica()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Genera un fichero para realizar la presentación telemática del modelo 
\end */
function oficial_presTelematica()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.isValid())
		return;
	
	var nombreFichero:String = FileDialog.getSaveFileName("*.*");
	if (!nombreFichero) {
		return;
	}
		
	var acumuladoControl:Number = 1;
	var nombreDato:String;
	var contenido:String = "";
	var file:Object = new File(nombreFichero);
	file.open(File.WriteOnly);

	nombreDato = util.translate("scripts", "Modelo");
	if ((contenido.length + 1) !=  1) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += "115";
	
	nombreDato = util.translate("scripts", "Página");
	if ((contenido.length + 1) !=  4) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += "01";
	
	nombreDato = util.translate("scripts", "Indicador de página complementaria");
	if ((contenido.length + 1) !=  6) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	contenido += " ";
	
	nombreDato = util.translate("scripts", "Tipo de declaración");
	if ((contenido.length + 1) !=  7) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	var temp:String = cursor.valueBuffer("idtipodec");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 1)) {
		return false;
	}
	contenido += temp;

	nombreDato = util.translate("scripts", "Código administración");
	if ((contenido.length + 1) !=  8) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("codadmon");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 5)) {
		return false;
	}
	contenido += flfactppal.iface.pub_cerosIzquierda(parseFloat(temp), 5);

	nombreDato = util.translate("scripts", "NIF");
	if ((contenido.length + 1) !=  13) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cifnif");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 9)) {
		return false;
	}
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 9); 

	nombreDato = util.translate("scripts", "Comienzo del primer apellido en personas físicas");
	if ((contenido.length + 1) !=  22) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("comienzoapell");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 4)) {
		return false;
	}
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Apellidos o razón social");
	if ((contenido.length + 1) !=  26) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("apellidosrs");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 30))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 30); 
	
	nombreDato = util.translate("scripts", "Nombre");
	if ((contenido.length + 1) !=  56) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("nombre");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 15))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 15); 
	
	nombreDato = util.translate("scripts", "Sigla vía");
	if ((contenido.length + 1) !=  71) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("codtipovia");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 
	
	nombreDato = util.translate("scripts", "Nombre de la vía pública");
	if ((contenido.length + 1) !=  73) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("nombrevia");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 17))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 17); 

	nombreDato = util.translate("scripts", "Número vía pública");
	if ((contenido.length + 1) !=  90) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("numero");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Escalera");
	if ((contenido.length + 1) !=  94) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("escalera");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 

	nombreDato = util.translate("scripts", "Piso");
	if ((contenido.length + 1) !=  96) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("piso");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 

	nombreDato = util.translate("scripts", "Puerta");
	if ((contenido.length + 1) !=  98) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("puerta");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 

	nombreDato = util.translate("scripts", "Teléfono");
	if ((contenido.length + 1) !=  100) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("telefono");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 9))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 9); 

	nombreDato = util.translate("scripts", "Municipio");
	if ((contenido.length + 1) !=  109) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("municipio");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 20))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 20); 

	nombreDato = util.translate("scripts", "Provincia");
	if ((contenido.length + 1) !=  129) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("provincia");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 15))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 15); 

	nombreDato = util.translate("scripts", "Código postal");
	if ((contenido.length + 1) !=  144) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("codpos");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 5))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 5); 

	nombreDato = util.translate("scripts", "Ejercicio");
	if ((contenido.length + 1) !=  149) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechainicio");
	contenido += temp.toString().left(4);
	
	nombreDato = util.translate("scripts", "Período");
	if ((contenido.length + 1) !=  153) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	if (cursor.valueBuffer("tipoperiodo") == "Trimestre") {
		temp = cursor.valueBuffer("trimestre");
		if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 2))
			return false;
	} else {
		temp = cursor.valueBuffer("fechainicio");
		temp = temp.toString().left(7);
		temp = temp.right(2);
	}
	contenido += temp; 

	nombreDato = util.translate("scripts", "Número de perceptores [1]");
	if ((contenido.length + 1) !=  155) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("perceptores");
	contenido += flcontmode.iface.pub_formatoNumero(parseFloat(temp), 6, 0);
	
	nombreDato = util.translate("scripts", "Base de las retenciones e ingresos a cuenta [2]");
	if ((contenido.length + 1) !=  161) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("baseretenciones"));
	contenido += flcontmode.iface.pub_formatoNumero(temp, 11, 2); 
	
	nombreDato = util.translate("scripts", "Retenciones e ingresos a cuenta [3]");
	if ((contenido.length + 1) !=  174) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("retenciones"));
	contenido += flcontmode.iface.pub_formatoNumero(temp, 11, 2); 
	
	nombreDato = util.translate("scripts", "A deducir [4]");
	if ((contenido.length + 1) !=  187) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("adeducir"));
	contenido += flcontmode.iface.pub_formatoNumero(temp, 11, 2); 

	nombreDato = util.translate("scripts", "Resultado a ingresar [5]");
	if ((contenido.length + 1) !=  200) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("resultado"));
	contenido += flcontmode.iface.pub_formatoNumero(temp, 11, 2); 

	nombreDato = util.translate("scripts", "Código electrónico declaración anterior");
	if ((contenido.length + 1) !=  213) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("codigoant");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 16))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 16); 
	
	nombreDato = util.translate("scripts", "Nº de justificante de la declaración anterior");
	if ((contenido.length + 1) !=  229) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("numjustifant");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 13))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 13); 
	
	nombreDato = util.translate("scripts", "Persona de contacto");
	if ((contenido.length + 1) !=  242) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("contacto");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 100))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 100); 

	nombreDato = util.translate("scripts", "Teléfono");
	if ((contenido.length + 1) !=  342) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("telfcontacto");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 9))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 9); 

	nombreDato = util.translate("scripts", "Observaciones");
	if ((contenido.length + 1) !=  351) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("observaciones");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 350))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 350); 

	nombreDato = util.translate("scripts", "Forma de pago - En efectivo");
	if ((contenido.length + 1) !=  701) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	if (cursor.valueBuffer("formapago") == "En efectivo") {
		temp = "X";
	} else {
		temp = " ";
	}
	contenido += temp;

	nombreDato = util.translate("scripts", "Forma de pago - E.C. adeudo a cuenta");
	if ((contenido.length + 1) !=  702) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	if (cursor.valueBuffer("formapago") == "Adeudo en cuenta") {
		temp = "X";
	} else if (cursor.valueBuffer("formapago") == "Domiciliación") {
		temp = "D";
	} else {
		temp = " ";
	}
	contenido += temp;

	nombreDato = util.translate("scripts", "Importe del ingreso");
	if ((contenido.length + 1) !=  703) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("ingreso"));
	contenido += flcontmode.iface.pub_formatoNumero(temp, 11, 2); 

	nombreDato = util.translate("scripts", "Código cuenta cliente - Entidad");
	if ((contenido.length + 1) !=  716) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("entidad");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Código cuenta cliente - Agencia");
	if ((contenido.length + 1) !=  720) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("agencia");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 4))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 4); 

	nombreDato = util.translate("scripts", "Código cuenta cliente - DC");
	if ((contenido.length + 1) !=  724) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("dc");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 2))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 2); 

	nombreDato = util.translate("scripts", "Código cuenta cliente - Cuenta");
	if ((contenido.length + 1) !=  726) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("cuenta");
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 10))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 10); 
	
	nombreDato = util.translate("scripts", "Fecha: Día");
	if ((contenido.length + 1) !=  736) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp.getDate(), 2);

	nombreDato = util.translate("scripts", "Fecha: Mes");
	if ((contenido.length + 1) !=  738) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(flcontmode.iface.pub_mesPorIndice(temp.getMonth()), 10);

	nombreDato = util.translate("scripts", "Fecha: Año");
	if ((contenido.length + 1) !=  748) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = cursor.valueBuffer("fechafirma");
	if (!flcontmode.iface.pub_verificarDato(temp, false, util.translate("scripts", "Fecha firma"), 19))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp.getYear(), 4);
	
	nombreDato = util.translate("scripts", "Fin de registro");
	if ((contenido.length + 1) != 752) {
		return this.iface.errorAcumuladoControl(contenido.length + 1, nombreDato);
	}
	temp = "\r\n";
	contenido += temp;
	
	file.write(contenido);
	file.close();

	MessageBox.information(util.translate("scripts", "El fichero se ha generado en :\n\n" + nombreFichero + "\n\n"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_errorAcumuladoControl(acumuladoControl:Number, nombreDato:String):Boolean
{
	var util:FLUtil = new FLUtil;
	MessageBox.warning(util.translate("scripts", "Error al crear el fichero: El dato %1 no comienza en la posición %2").arg(nombreDato).arg(acumuladoControl), MessageBox.Ok, MessageBox.NoButton);
	return false;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
