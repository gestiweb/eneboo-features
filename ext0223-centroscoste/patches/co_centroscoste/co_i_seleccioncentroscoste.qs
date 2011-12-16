/**************************************************************************
                 co_i_seleccioncentroscoste.qs  -  description
                             -------------------
    begin                : mar feb 21 2006
    copyright            : (C) 2006 by InfoSiAL S.L.
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
	var tdbCentros:Object;
	var tdbCentrosSel:Object;
	
    function oficial( context ) { interna( context ); } 
	function seleccionar(noRefresco:Boolean) {
		return this.ctx.oficial_seleccionar(noRefresco);
	}
	function quitar(noRefresco:Boolean) {
		return this.ctx.oficial_quitar(noRefresco);
	}
	function seleccionarTodos() {
		return this.ctx.oficial_seleccionarTodos();
	}
	function quitarTodos() {
		return this.ctx.oficial_quitarTodos();
	}
	function refrescarTablas() {
		return this.ctx.oficial_refrescarTablas();
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
/** \C
Este formulario muestra una lista de centros de cliente que cumplen un determinado filtro, y permite al usuario seleccionar uno o más centros de la lista
\end */
function interna_init()
{
	this.iface.tdbCentros = this.child("tdbCentros");
	this.iface.tdbCentrosSel = this.child("tdbCentrosSel");
	
	this.iface.tdbCentros.setReadOnly(true);
	this.iface.tdbCentrosSel.setReadOnly(true);
	
	var filtro:String = this.cursor().valueBuffer("filtro");
	if (filtro && filtro != "") {
		this.iface.tdbCentros.cursor().setMainFilter(filtro);
		this.iface.tdbCentrosSel.cursor().setMainFilter(filtro);
	}
	this.iface.refrescarTablas();

	connect(this.iface.tdbCentros.cursor(), "recordChoosed()", this, "iface.seleccionar()");
	connect(this.iface.tdbCentrosSel.cursor(), "recordChoosed()", this, "iface.quitar()");
	connect(this.child("pbnSeleccionar"), "clicked()", this, "iface.seleccionar()");
	connect(this.child("pbnQuitar"), "clicked()", this, "iface.quitar()");
	connect(this.child("pbnSeleccionarTodos"), "clicked()", this, "iface.seleccionarTodos()");
	connect(this.child("pbnQuitarTodos"), "clicked()", this, "iface.quitarTodos()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
/** \D Refresca las tablas, en función del filtro y de los datos seleccionados hasta el momento
*/
function oficial_refrescarTablas()
{
	var datos:String = this.cursor().valueBuffer("datos");
	var filtro:String = this.cursor().valueBuffer("filtro");
	if (filtro && filtro != "")
		filtro += " AND ";

	if (!datos || datos == "") {
		this.iface.tdbCentros.cursor().setMainFilter(filtro + "1 = 1");
		this.iface.tdbCentrosSel.cursor().setMainFilter(filtro + "1 = 2");
	} else {
		this.iface.tdbCentros.cursor().setMainFilter(filtro + "codcentro NOT IN (" + datos + ")");
		this.iface.tdbCentrosSel.cursor().setMainFilter(filtro + "codcentro IN (" + datos + ")");
	}
	this.iface.tdbCentros.refresh();
	this.iface.tdbCentrosSel.refresh();
}

/** \D Incluye un recibo en la lista de datos
*/
function oficial_seleccionar(noRefresco:Boolean)
{
	var cursor:FLSqlCursor = this.cursor();
	var datos:String = cursor.valueBuffer("datos");
	var codCentro:String = this.iface.tdbCentros.cursor().valueBuffer("codcentro");
	if (!codCentro)
		return;
	if (!datos || datos == "")
		datos = "'" + codCentro + "'";
	else
		datos += ",'" + codCentro + "'";
		
	cursor.setValueBuffer("datos", datos);
	
	if (!noRefresco)
		this.iface.refrescarTablas();
}

/** \D Quita un recibo de la lista de datos
*/
function oficial_quitar(noRefresco:Boolean)
{
	var cursor:FLSqlCursor = this.cursor();
	var datos:String = new String( cursor.valueBuffer("datos") );
	var codCentro:String = this.iface.tdbCentrosSel.cursor().valueBuffer("codcentro");
	if (!codCentro)
		return;
	
	if (!datos || datos == "")
		return;
	var centros:Array = datos.split(",");
	var datosNuevos:String = "";
	for (var i:Number = 0; i < centros.length; i++) {
		if (centros[i] != "'" + codCentro + "'") {
			if (datosNuevos == "") 
				datosNuevos = centros[i];
			else
				datosNuevos += "," + centros[i];
		}
	}
	cursor.setValueBuffer("datos", datosNuevos);
	if (!noRefresco)
		this.iface.refrescarTablas();
}

function oficial_seleccionarTodos()
{
	var util:FLUtil = new FLUtil();
	
	var res = MessageBox.warning( util.translate( "scripts", "Se seleccionarán todos los centros\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes )
		return;
	
	var curTab:FLSqlCursor = this.iface.tdbCentros.cursor();
	curTab.select();
	if (!curTab.size())
		return;
	
	var paso:Number = 1;
	util.createProgressDialog( util.translate( "scripts", "Seleccionando centros" ), curTab.size() );
	
	curTab.first();
	this.iface.seleccionar(true);
	util.setProgress(paso++);
	
	while(curTab.next()) {
		this.iface.seleccionar(true);
		util.setProgress(paso++);
	}

	util.destroyProgressDialog();
	this.iface.refrescarTablas();
}

function oficial_quitarTodos()
{
	var util:FLUtil = new FLUtil();
	
	var res = MessageBox.warning( util.translate( "scripts", "Se quitarán todos los centros\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes )
		return;
	
	var curTab:FLSqlCursor = this.iface.tdbCentrosSel.cursor();
	curTab.select();
	if (!curTab.size())
		return;
	
	var paso:Number = 1;
	util.createProgressDialog( util.translate( "scripts", "Quitando centros" ), curTab.size() );
	
	curTab.first();
	this.iface.quitar(true);
	util.setProgress(paso++);
	
	while(curTab.next()) {
		this.iface.quitar(true);
		util.setProgress(paso++);
	}

	util.destroyProgressDialog();
	this.iface.refrescarTablas();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
