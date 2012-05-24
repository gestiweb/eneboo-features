/**************************************************************************
                 tiposcontrato.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
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
	function calculateCounter():String { return this.ctx.interna_calculateCounter(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function informarCampos() {
		return this.ctx.oficial_informarCampos();
	}
	function valoresCampos():String {
		return this.ctx.oficial_valoresCampos();
	}
	function establecerDocPlantilla() {
		return this.ctx.oficial_establecerDocPlantilla();
	}
	function abrirDocPlantilla() {
		return this.ctx.oficial_abrirDocPlantilla();
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

function interna_init()
{
	connect( this.child( "pbnEstablecerDocPlantilla" ), "clicked()", this, "iface.establecerDocPlantilla" );
	connect( this.child( "pbnAbrirDocPlantilla" ), "clicked()", this, "iface.abrirDocPlantilla" );
	this.iface.informarCampos();
}

function interna_calculateCounter()
{
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerDocPlantilla()
{
	var util:FLUtil = new FLUtil();
	var rutaPlantillas:String = util.readSettingEntry("scripts/flfacturac/rutaOfertasPlantillas");
	
	if ( !File.isDir( rutaPlantillas ) ) {
		MessageBox.information( util.translate( "scripts", "No se ha establecido una ruta correcta a las plantillas" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	var ficheros:Array = FileDialog.getOpenFileNames( rutaPlantillas, "*.odt;*.ott", util.translate("scripts", "Fichero de plantilla"));
	if (!ficheros)
		return;

	if (ficheros.length == 0) {
		return;
	}
		
	var objetoFich = new File(ficheros[0]);		
	this.child("fdbPlantilla").setValue(objetoFich.name);
}

function oficial_abrirDocPlantilla()
{
	var util:FLUtil = new FLUtil();
	var rutaPlantillas:String = util.readSettingEntry("scripts/flfacturac/rutaOfertasPlantillas");
	
	if ( !File.isDir( rutaPlantillas ) ) {
		MessageBox.information( util.translate( "scripts", "No se ha establecido una ruta correcta a las plantillas" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	var fichero:String = this.child("fdbPlantilla").value();
	if (!fichero) {
		MessageBox.information( util.translate( "scripts", "No se ha establecido el fichero" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
		
	if (!File.exists(rutaPlantillas + fichero)) {
		MessageBox.information( util.translate( "scripts", "No se encontró el fichero" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	var comandoOOW:String = util.readSettingEntry("scripts/flfacturac/comandoWriter");
	if (!comandoOOW) {
		MessageBox.warning( util.translate( "scripts", "No se ha establecido el comando de OpenOffice de documentos de texto\nPuede establecerlo en las opciones de informes" ), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	comando = new Array(comandoOOW, rutaPlantillas + fichero);
	var proceso = new Process();
	proceso.arguments = comando;
	try {
		proceso.start();
	}
	catch (e) {
		MessageBox.critical(comando + "\n\n" + util.translate("scripts", "Falló la ejecución del comando"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
}

function oficial_informarCampos()
{
	this.child("lblCampos").text = this.iface.valoresCampos();
}

function oficial_valoresCampos():String
{
	var util:FLUtil = new FLUtil;
	var campos:String = "";
	
	campos += util.translate("scripts", "%1: Nombre del cliente").arg("NOMBRE_CLIENTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: NIF/CIF del cliente").arg("NIF_CLIENTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: Priodicidad del contrato").arg("PERIODICIDAD");
	campos += "\n";
	campos += util.translate("scripts", "%1: Importe del contrato").arg("IMPORTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: Fecha de inicio del contrato").arg("FECHA_INICIO");
	campos += "\n";
	campos += util.translate("scripts", "%1: Tipo de contrato").arg("TIPO");
	campos += "\n";
	campos += util.translate("scripts", "%1: Descripción del contrato").arg("DESCRIPCION");
	campos += "\n";
	campos += util.translate("scripts", "%1: Observaciones del contrato").arg("OBSERVACIONES");
	campos += "\n";
	campos += util.translate("scripts", "%1: Condiciones del contrato").arg("CONDICIONES");
	campos += "\n";
	campos += util.translate("scripts", "%1: Dirección del cliente").arg("DIR_CLIENTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: Ciudad del cliente").arg("CIUDAD_CLIENTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: Provinicia del cliente").arg("PROVINCIA_CLIENTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: País del cliente").arg("PAIS_CLIENTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: Cuenta domiciliación del cliente").arg("CUENTA_PAGO_CLIENTE");
	campos += "\n";
	campos += util.translate("scripts", "%1: Fecha actual").arg("FECHA");
	return campos;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
