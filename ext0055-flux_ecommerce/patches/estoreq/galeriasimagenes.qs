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
	function traducirDescripcion() {
		return this.ctx.oficial_traducir("descripcion");
	}
	function leerDeDir() {
		return this.ctx.oficial_leerDeDir();
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
	connect(this.child("pbnTradDescripcion"), "clicked()", this, "iface.traducirDescripcion");
	connect(this.child("pbnLeerDeDir"), "clicked()", this, "iface.leerDeDir");
	
}


//// INTERNA //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_traducir(campo)
{
	return flfactppal.iface.pub_traducir("galeriasimagenes", campo, this.cursor().valueBuffer("codgaleria"));
}

function oficial_leerDeDir()
{
	var util:FLUtil = new FLUtil();
	
	var codGaleria:String = this.cursor().valueBuffer("codgaleria");
	if (!codGaleria)
		return;
		
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		var curI:FLSqlCursor = this.child("tdbImagenes").cursor();
		curI.setModeAccess(curI.Insert);
		curI.commitBufferCursorRelation();
	}
		
	
	var titGaleria:String = this.cursor().valueBuffer("titulo");
	
	var imagenes:Array = FileDialog.getOpenFileNames( "", "*.jpg;*.JPG*;*.png;*.PNG;*.gif;*.GIF", util.translate( "scripts", "Selecciona las Imágenes" ));
	if (!imagenes)
		return;
		
	var orden:Number = util.sqlSelect("imagenes", "max(orden)", "codgaleria = '" + codGaleria + "'");
	if (!orden)
		orden = 0;
		
	imagenes.sort();
		
	var curTab:FLSqlCursor = new FLSqlCursor("imagenes");
	for (i=0; i<imagenes.length;i++) {
	
		fichImagen = imagenes[i];
		file = new File(fichImagen);			
		fichImagen = file.name;
	
		curTab.select("fichero = '" + fichImagen + "'");
		if (curTab.first())
			continue;
			
		orden++;
			
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codimagen", util.nextCounter("codimagen", curTab));
		curTab.setValueBuffer("fichero", fichImagen);
		curTab.setValueBuffer("codgaleria", codGaleria);
		curTab.setValueBuffer("titulo", titGaleria + " " + orden);
		curTab.setValueBuffer("publico", titGaleria + " " + orden);
		curTab.setValueBuffer("orden", orden);
		curTab.commitBuffer();
	}
	
	this.child("tdbImagenes").refresh();
}



//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////