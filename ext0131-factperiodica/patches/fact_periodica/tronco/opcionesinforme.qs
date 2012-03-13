/***************************************************************************
                 opcionestv.qs  -  description
                             -------------------
    begin                : lun sep 21 2004
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

////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_declaration interna */
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
	function cambiarRutaTmp() { return this.ctx.oficial_cambiarRutaTmp() ;}
	function cambiarRutaPlantillas() { return this.ctx.oficial_cambiarRutaPlantillas() ;}
	function cambiarRutaOfertas() { return this.ctx.oficial_cambiarRutaOfertas() ;}
	function cambiarComandoWriter() { return this.ctx.oficial_cambiarComandoWriter() ;}
	function cambiarCodificacion(tipo) { return this.ctx.oficial_cambiarCodificacion(tipo) ;}
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function init() {
    this.iface.init();
}

function main() {
    this.iface.main();
}

function interna_init() 
{
	var util:FLUtil = new FLUtil();
	
	connect( this.child( "pbnCambiarRutaTmp" ), "clicked()", this, "iface.cambiarRutaTmp" );
	connect( this.child( "pbnCambiarRutaPlantillas" ), "clicked()", this, "iface.cambiarRutaPlantillas" );
	connect( this.child( "pbnCambiarRutaOfertas" ), "clicked()", this, "iface.cambiarRutaOfertas" );
	connect( this.child( "pbnCambiarComandoWriter" ), "clicked()", this, "iface.cambiarComandoWriter" );
	connect(this.child("btgCodificacion"), "clicked(int)", this, "iface.cambiarCodificacion");
	
	if (!util.readSettingEntry("scripts/flfacturac/rutaOfertasTmp"))
		util.writeSettingEntry("scripts/flfacturac/rutaOfertasTmp", "/tmp/");
		
	this.child("lblRutaTmp").text = util.readSettingEntry("scripts/flfacturac/rutaOfertasTmp");	
	this.child("lblRutaPlantillas").text = util.readSettingEntry("scripts/flfacturac/rutaOfertasPlantillas");
	this.child("lblRutaOfertas").text = util.readSettingEntry("scripts/flfacturac/rutaOfertasOfertas");
	this.child("lblComandoWriter").text = util.readSettingEntry("scripts/flfacturac/comandoWriter");
	
	if (util.readSettingEntry("scripts/flfacturac/encodingLocal") == "UTF")
		this.child("rbnUTF").checked = true;
	if (util.readSettingEntry("scripts/flfacturac/encodingLocal") == "ISO")
		this.child("rbnISO").checked = true;
}

function interna_main()
{
	var f = new FLFormSearchDB("opcionesinforme");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
			cursor.setModeAccess(cursor.Insert);
	else
			cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
					commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
					cursor.commit();
					commitOk = true;
			}
		}
		f.close();
	}
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_cambiarRutaTmp()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "Ruta al directorio temporal" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	this.child("lblRutaTmp").text = ruta;
	util.writeSettingEntry("scripts/flfacturac/rutaOfertasTmp", ruta);
}

function oficial_cambiarRutaPlantillas()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "Ruta a las plantillas" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	this.child("lblRutaPlantillas").text = ruta;
	util.writeSettingEntry("scripts/flfacturac/rutaOfertasPlantillas", ruta);
}

function oficial_cambiarRutaOfertas()
{
	var util:FLUtil = new FLUtil();
	var ruta:String = FileDialog.getExistingDirectory( util.translate( "scripts", "" ), util.translate( "scripts", "Ruta de destino para las ofertas" ) );
	
	if ( !File.isDir( ruta ) ) {
		MessageBox.information( util.translate( "scripts", "Ruta errónea" ),
								MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	this.child("lblRutaOfertas").text = ruta;
	util.writeSettingEntry("scripts/flfacturac/rutaOfertasOfertas", ruta);
}

function oficial_cambiarComandoWriter()
{
	var util:FLUtil = new FLUtil();
	var comando:String = Input.getText(util.translate( "scripts", "Comando de OpenOffice writer:" ));
	if (!comando)
		return;
	
	this.child("lblComandoWriter").text = comando;
	util.writeSettingEntry("scripts/flfacturac/comandoWriter", comando);
}

function oficial_cambiarCodificacion(tipo)
{
	var util:FLUtil = new FLUtil;
	switch(tipo) {

		case 1: //UTF
			util.writeSettingEntry("scripts/flfacturac/encodingLocal", "UTF");
		break;

		case 2: //haber
			util.writeSettingEntry("scripts/flfacturac/encodingLocal", "ISO");
		break;
	}
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
