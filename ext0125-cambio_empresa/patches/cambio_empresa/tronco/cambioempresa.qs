/***************************************************************************
                 mastercambioempresa.qs  -  description
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
    function main() { this.ctx.interna_main(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
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

function interna_init() {}

function interna_main()
{
// 	sys.addDatabase("PostgreSQL","fede_recar","falbujer","m1254uf","aviion","5432","default");
// 	sys.reinit();
// 	return;

	var util:FLUtil = new FLUtil();
	var marks:String = util.readSettingEntry("DBA/marks");


	var dialog = new Dialog(util.translate ( "scripts", "Empresas" ), 0);
	dialog.caption = "Selecciona la empresa";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	
	
	var grupo1:GroupBox = new GroupBox;
	dialog.add( grupo1 );
	grupo1.title = util.translate ( "scripts", "Empresas guardadas" );
	
	var combo:ComboBox = new ComboBox;
	grupo1.add( combo );
	
	var listaEmpresas = marks.split("^e");
	combo.label = util.translate("scripts","Empresa");
	combo.itemList = listaEmpresas;
	combo.currentItem = "";
	
	var lePass0:LineEdit = new LineEdit;
	grupo1.add( lePass0 );
	lePass0.label = util.translate ( "scripts", "Contraseña" );
	lePass0.text = util.readSettingEntry("DBA/password");	
	
	
	
	var grupo2:GroupBox = new GroupBox;
	dialog.add( grupo2 );
	grupo2.title = util.translate ( "scripts", "Otra empresa" );
	
	var chkOtra:CheckBox = new CheckBox;
	grupo2.add( chkOtra );
	chkOtra.text = util.translate ( "scripts", "Conectar a esta empresa" );
	
	var leEmpresa:LineEdit = new LineEdit;
	grupo2.add( leEmpresa );
	leEmpresa.label = util.translate ( "scripts", "Empresa" );
	
	var leUsuario:LineEdit = new LineEdit;
	grupo2.add( leUsuario);
	leUsuario.label = util.translate ( "scripts", "Usuario" );
	leUsuario.text = util.readSettingEntry("DBA/username");
	
	var lePass:LineEdit = new LineEdit;
	grupo2.add( lePass );
	lePass.label = util.translate ( "scripts", "Contraseña" );
	lePass.text = util.readSettingEntry("DBA/password");
	
	var comboContro:LineEdit = new ComboBox;
	grupo2.add( comboContro );
	comboContro.label = util.translate ( "scripts", "Controlador" );
	comboContro.itemList = new Array("PostgreSQL", "MySQL");
	comboContro.currentItem = util.readSettingEntry("DBA/db");
		
	var leHost:LineEdit = new LineEdit;
	grupo2.add( leHost);
	leHost.label = util.translate ( "scripts", "Servidor" );
	leHost.text = util.readSettingEntry("DBA/hostname");
	
	var lePuerto:LineEdit = new LineEdit;
	grupo2.add( lePuerto );
	lePuerto.label = util.translate ( "scripts", "Puerto" );
	lePuerto.text = util.readSettingEntry("DBA/port");
	
	
	if(dialog.exec())
		debug(combo.currentItem);
	else
		return;
	
	var nombreBD:String;
	var usuario:String;
	var password:String	
	var driver:String;
	var host:String;
	var puerto:String;
	
	if (!chkOtra.checked) {				
		datosConn = combo.currentItem.split(":");
		nombreBD = datosConn[0];
		usuario = datosConn[1];
		driver = datosConn[2];
		host = datosConn[3];
		puerto = datosConn[4];		
		password = lePass0.text;		
	}
	else {
		nombreBD = leEmpresa.text;
		usuario = leUsuario.text;
		driver = comboContro.currentItem;
		host = leHost.text;
		puerto = lePuerto.text;		
		password = lePass.text;
	}

	var tipoDriver:String;
	if (sys.nameDriver().search("PSQL") > -1)
		tipoDriver = "PostgreSQL";
	else
		tipoDriver = "MySQL";

	if (host == sys.nameHost() && nombreBD == sys.nameBD() && driver == tipoDriver) {
		MessageBox.warning(util.translate("scripts",
			"Los datos de conexión son los de la presente base de datos\nDebe indicar los datos de conexión de otra base de datos"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (!driver || !nombreBD || !usuario || !host) {
		MessageBox.warning(util.translate("scripts",
			"Debe indicar el tipo de base de datos, nombre de la misma, usuario y servidor"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	debug(nombreBD);
	debug(usuario);
	debug(driver);
	debug(host);
	debug(puerto);
	debug(password);

// 	sys.addDatabase("PostgreSQL","fede_recar","falbujer","m1254uf","aviion","5432","default");
	if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, "default"))
		return;
		
	sys.reinit();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////