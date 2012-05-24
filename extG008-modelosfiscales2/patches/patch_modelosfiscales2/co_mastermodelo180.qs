/***************************************************************************
                 co_mastermodelo180.qs  -  description
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

	nombreDato = util.translate("scripts", "Tipo de registro");
	if ((contenido.length + 1) !=  1) {
		return this.iface.errorAcumuladoControl(1, nombreDato);
	}
	contenido += "1";

	nombreDato = util.translate("scripts", "Modelo");
	if ((contenido.length + 1) !=  2) {
		return this.iface.errorAcumuladoControl(2, nombreDato);
	}
	contenido += "180";
	
	nombreDato = util.translate("scripts", "Ejercicio");
	if ((contenido.length + 1) !=  5) {
		return this.iface.errorAcumuladoControl(5, nombreDato);
	}
	temp = cursor.valueBuffer("fechainicio");
	contenido += temp.toString().left(4);

	nombreDato = util.translate("scripts", "NIF declarante");
	if ((contenido.length + 1) !=  9) {
		return this.iface.errorAcumuladoControl(9, nombreDato);
	}
	temp = cursor.valueBuffer("cifnif");
	temp = flcontmode.iface.pub_formatearTexto(temp);
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 9)) {
		return false;
	}
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 9); 

	nombreDato = util.translate("scripts", "Apellidos y nombre o razón social");
	if ((contenido.length + 1) !=  18) {
		return this.iface.errorAcumuladoControl(18, nombreDato);
	}
	temp = cursor.valueBuffer("apellidosrs");
	temp = flcontmode.iface.pub_formatearTexto(temp);
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 40))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 40); 
	
	nombreDato = util.translate("scripts", "Tipo de soporte");
	if ((contenido.length + 1) !=  58) {
		return this.iface.errorAcumuladoControl(58, nombreDato);
	}
	contenido += cursor.valueBuffer("tiposoporte");

	nombreDato = util.translate("scripts", "Teléfono");
	if ((contenido.length + 1) !=  59) {
		return this.iface.errorAcumuladoControl(59, nombreDato);
	}
	temp = cursor.valueBuffer("telfcontacto");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 9))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 9); 

	nombreDato = util.translate("scripts", "Persona de contacto");
	if ((contenido.length + 1) !=  68) {
		return this.iface.errorAcumuladoControl(68, nombreDato);
	}
	temp = cursor.valueBuffer("contacto");
	if (!flcontmode.iface.pub_verificarDato(temp, true, nombreDato, 40))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 40); 

	nombreDato = util.translate("scripts", "Nº justificante");
	if ((contenido.length + 1) !=  108) {
		return this.iface.errorAcumuladoControl(108, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("numjustificante"));
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 13))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp, 13); 

	nombreDato = util.translate("scripts", "Declaración complementaria");
	if ((contenido.length + 1) !=  121) {
		return this.iface.errorAcumuladoControl(121, nombreDato);
	}
	if (cursor.valueBuffer("complementaria")) {
		temp = "C";
	} else {
		temp = " ";
	}
	contenido += temp; 

	nombreDato = util.translate("scripts", "Declaración sustitutiva");
	if ((contenido.length + 1) !=  122) {
		return this.iface.errorAcumuladoControl(122, nombreDato);
	}
	if (cursor.valueBuffer("sustitutiva")) {
		temp = "S";
	} else {
		temp = " ";
	}
	contenido += temp; 

	nombreDato = util.translate("scripts", "Número de justificante de la declaración anterior");
	if ((contenido.length + 1) !=  123) {
		return this.iface.errorAcumuladoControl(123, nombreDato);
	}
	if (cursor.valueBuffer("sustitutiva")) {
		temp = parseFloat(cursor.valueBuffer("numjustifant"));
		if (!temp) {
			MessageBox.information(util.translate("scripts", "La declaración es sustitutiva.\nDebe informar el número de justificante de la declaración anterior."), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		temp = 0;
	}
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 13))
		return false;
	contenido += flfactppal.iface.pub_cerosIzquierda(temp, 13); 

	nombreDato = util.translate("scripts", "Número de perceptores");
	if ((contenido.length + 1) !=  136) {
		return this.iface.errorAcumuladoControl(136, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("perceptores"));
	contenido += flfactppal.iface.pub_cerosIzquierda(temp, 9);

	nombreDato = util.translate("scripts", "Base de las retenciones e ingresos a cuenta");
	if ((contenido.length + 1) !=  145) {
		return this.iface.errorAcumuladoControl(145, nombreDato);
	}
	var signo:String = "";
	temp = parseFloat(cursor.valueBuffer("baseretenciones"));
	if (temp >= 0) {
		signo = " ";
	} else {
		temp = numero * -1;
		signo = "N";
	}
	contenido+= signo;
	contenido += flcontmode.iface.pub_formatoNumero(temp, 13, 2); 
	
	nombreDato = util.translate("scripts", "Retenciones e ingresos a cuenta");
	if ((contenido.length + 1) !=  161) {
		return this.iface.errorAcumuladoControl(161, nombreDato);
	}
	temp = parseFloat(cursor.valueBuffer("retenciones"));
	contenido += flcontmode.iface.pub_formatoNumero(temp, 13, 2); 
	
	nombreDato = util.translate("scripts", "Blancos");
	if ((contenido.length + 1) !=  176) {
		return this.iface.errorAcumuladoControl(176, nombreDato);
	}
	contenido += flfactppal.iface.pub_espaciosDerecha("", 62);

	nombreDato = util.translate("scripts", "Sello electrónico");
	if ((contenido.length + 1) !=  238) {
		return this.iface.errorAcumuladoControl(238, nombreDato);
	}
	temp = cursor.valueBuffer("sello");
	if (!temp) {
		temp = "";
	}	
	if (!flcontmode.iface.pub_verificarDato(temp, false, nombreDato, 13))
		return false;
	contenido += flfactppal.iface.pub_espaciosDerecha(temp, 13); 
	contenido += "\n";

	var qryDetalle:FLSqlQuery = new FLSqlQuery();
	qryDetalle.setTablesList("co_detalle180");
	qryDetalle.setSelect("nifproveedor, nifrepresentante, codproveedor, nombre, codprovincia, base, porretencion, retencion, ejerdevengo, modalidad");
	qryDetalle.setFrom("co_detalle180");
	qryDetalle.setWhere("idmodelo = " + cursor.valueBuffer("idmodelo"));
	if (!qryDetalle.exec()) {
		return false;
	}
	var contenidoDetalle:String;
	while (qryDetalle.next()) {
		contenidoDetalle = "";

		nombreDato = util.translate("scripts", "Tipo de registro");
		if ((contenidoDetalle.length + 1) !=  1) {
			return this.iface.errorAcumuladoControl(1, nombreDato);
		}
		temp = "2";
		contenidoDetalle += temp;
		
		nombreDato = util.translate("scripts", "Modelo");
		if ((contenidoDetalle.length + 1) !=  2) {
			return this.iface.errorAcumuladoControl(2, nombreDato);
		}
		temp = "180";
		contenidoDetalle += temp;
		
		nombreDato = util.translate("scripts", "Ejercicio");
		if ((contenidoDetalle.length + 1) !=  5) {
			return this.iface.errorAcumuladoControl(5, nombreDato);
		}
		temp = cursor.valueBuffer("fechainicio");
		contenidoDetalle += temp.toString().left(4);
		
		nombreDato = util.translate("scripts", "NIF entidad declarante");
		if ((contenidoDetalle.length + 1) !=  9) {
			return this.iface.errorAcumuladoControl(9, nombreDato);
		}
		temp = cursor.valueBuffer("cifnif");
		temp = flcontmode.iface.pub_formatearTexto(temp);
		contenidoDetalle += flfactppal.iface.pub_espaciosDerecha(temp, 9);
		
		nombreDato = util.translate("scripts", "NIF perceptor");
		if ((contenidoDetalle.length + 1) !=  18) {
			return this.iface.errorAcumuladoControl(18, nombreDato);
		}
		temp = qryDetalle.value("nifproveedor");
		temp = flfactppal.iface.pub_espaciosDerecha(temp, 9);
		contenidoDetalle += temp;
		
		nombreDato = util.translate("scripts", "NIF del representante legal");
		if ((contenidoDetalle.length + 1) !=  27) {
			return this.iface.errorAcumuladoControl(27, nombreDato);
		}
		temp = qryDetalle.value("nifrepresentante");
		temp = flfactppal.iface.pub_espaciosDerecha(temp, 9);
		contenidoDetalle += temp;
		
		nombreDato = util.translate("scripts", "Apellidos y nombre o razón social del perceptor");
		if ((contenidoDetalle.length + 1) !=  36) {
			return this.iface.errorAcumuladoControl(36, nombreDato);
		}
		temp = qryDetalle.value("nombre");
debug(temp);
		temp = flcontmode.iface.pub_formatearTexto(temp);
debug(temp);
		temp = flfactppal.iface.pub_espaciosDerecha(temp, 40);
debug(temp+"/");
		contenidoDetalle += temp;
	
		nombreDato = util.translate("scripts", "Código de provincia");
		if ((contenidoDetalle.length + 1) !=  76) {
			return this.iface.errorAcumuladoControl(76, nombreDato);
		}
		temp = qryDetalle.value("codprovincia");
		temp = flfactppal.iface.pub_espaciosDerecha(temp, 2);
		contenidoDetalle += temp;

		nombreDato = util.translate("scripts", "Modalidad");
		if ((contenidoDetalle.length + 1) !=  78) {
			return this.iface.errorAcumuladoControl(78, nombreDato);
		}
		temp = qryDetalle.value("modalidad");
		temp = flfactppal.iface.pub_cerosIzquierda(temp, 1);

		contenidoDetalle += temp;

		nombreDato = util.translate("scripts", "Base de las retenciones e ingresos a cuenta");
		if ((contenidoDetalle.length + 1) !=  79) {
			return this.iface.errorAcumuladoControl(79, nombreDato);
		}
		var signo:String = "";
		temp = parseFloat(qryDetalle.value("base"));
		if (temp >= 0) {
			signo = " ";
		} else {
			temp = numero * -1;
			signo = "N";
		}
		contenidoDetalle += signo;
		contenidoDetalle += flcontmode.iface.pub_formatoNumero(temp, 11, 2); 

		nombreDato = util.translate("scripts", "% Retención");
		if ((contenidoDetalle.length + 1) !=  93) {
			return this.iface.errorAcumuladoControl(93, nombreDato);
		}
		temp = qryDetalle.value("porretencion");
		temp = flcontmode.iface.pub_formatoNumero(temp, 2, 2);
		contenidoDetalle += temp;

		nombreDato = util.translate("scripts", "Retenciones e ingresos a cuenta");
		if ((contenidoDetalle.length + 1) !=  97) {
			return this.iface.errorAcumuladoControl(97, nombreDato);
		}
		temp = parseFloat(qryDetalle.value("retencion"));
		contenidoDetalle += flcontmode.iface.pub_formatoNumero(temp, 11, 2); 

		nombreDato = util.translate("scripts", "Ejercicio devengo");
		if ((contenidoDetalle.length + 1) !=  110) {
			return this.iface.errorAcumuladoControl(110, nombreDato);
		}
		if (!qryDetalle.value("ejerdevengo")) {
			temp = 0;
		} else {
			temp = parseFloat(qryDetalle.value("ejerdevengo"));
		}
		contenidoDetalle += flfactppal.iface.pub_cerosIzquierda(temp, 4);

		nombreDato = util.translate("scripts", "Blancos");
		if ((contenidoDetalle.length + 1) !=  114) {
			return this.iface.errorAcumuladoControl(114, nombreDato);
		}
		contenidoDetalle += flfactppal.iface.pub_espaciosDerecha("", 137);
		contenidoDetalle += "\n";
		contenido += contenidoDetalle;
	}
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

