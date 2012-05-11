/***************************************************************************
                 noticias.qs  -  description
                             -------------------
    begin                : lun abr 26 2006
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	function oficial( context ) { interna( context ); } 
	function traducirTitulo() {
		return this.ctx.oficial_traducir("titulo");
	}
	function traducirTexto() {
		return this.ctx.oficial_traducir("texto");
	}
	function traducirResumen() {
		return this.ctx.oficial_traducir("resumen");
	}
	function seleccionarImagen() {
		return this.ctx.oficial_seleccionarImagen();
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

/** \D Cuando es una nueva no mostramos nada en la lista de familias hijas
*/
function interna_init()
{
	connect(this.child("pbnTradTitulo"), "clicked()", this, "iface.traducirTitulo");
	connect(this.child("pbnTradTexto"), "clicked()", this, "iface.traducirTexto");
	connect(this.child("pbnTradResumen"), "clicked()", this, "iface.traducirResumen");
	connect(this.child("pbnImagen"), "clicked()", this, "iface.seleccionarImagen");

	this.child("fdbResumen").setTextFormat(0);
	this.child("fdbTexto").setTextFormat(0);
}


//// INTERNA //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_traducir(campo)
{
	return flfactppal.iface.pub_traducir("noticias", campo, this.cursor().valueBuffer("id"));
}

function oficial_seleccionarImagen()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var archivo:String = FileDialog.getOpenFileName("*.jpg", util.translate("scripts","Elegir Fichero"));
			
	if (!archivo)
		return;
		
	var file = new File( archivo );

	// Abrir el fichero	de lectura
	try {
		file.open( File.ReadOnly );
	}
	catch (e) {
		MessageBox.warning(util.translate("scripts", "Se produjo el error siguiente al tratar de abrir el fichero de imagen:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	var rutaDestino:String = util.sqlSelect("opcionestv", "rutaweb", "1 = 1");
	rutaDestino += "images/noticias/" + cursor.valueBuffer("id") + ".jpg";

	var outfile = new File(rutaDestino);

	// Abrir el fichero	de escritura y copiar el contenido original
	try {
		outfile.open(File.WriteOnly);
		while (!file.eof)
			outfile.writeByte( file.readByte() );
	}
	catch (e) {
		MessageBox.warning(util.translate("scripts", "Se produjo el error siguiente al tratar de copiar el fichero de imagen:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	
	file.close();
	outfile.close();

	if (File.exists(rutaDestino)) {
		MessageBox.information(util.translate("scripts", "Se copió correctamente la imagen en la página web"), MessageBox.Ok, MessageBox.NoButton);
	}
	else {
		MessageBox.warning(util.translate("scripts", "No se pudo copiar la imagen en la página web"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}


	return true;	
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////