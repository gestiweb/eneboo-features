/***************************************************************************
                 periodos.qs  -  description
                             -------------------
    begin                : jue abr 29 2010
    copyright            : (C) 2010 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
    function establecerFechaInicial() { 
		return this.ctx.oficial_establecerFechaInicial(); 
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
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	
	if (cursor.modeAccess() == cursor.Insert) {
		this.iface.establecerFechaInicial();
	}
}

function interna_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	if (cursor.valueBuffer("fechahasta")) {
		if (util.daysTo(cursor.valueBuffer("fechadesde"), cursor.valueBuffer("fechahasta")) < 0) {
			MessageBox.information(util.translate("scripts", "La fecha de inicio del periodo no puede ser superior a la fecha fin"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_establecerFechaInicial()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("periodos");
	qry.setSelect("fechahasta");
	qry.setFrom("periodos");
	qry.setWhere("codimpuesto = '" + cursor.valueBuffer("codimpuesto") + "' ORDER BY fechadesde DESC");
	try { qry.setForwardOnly( true ); } catch (e) {}
	if (!qry.exec()){
	   return false;
	}
	if (!qry.first()) {
		this.child("fdbFechaDesde").setValue("1900-01-01");
	} else {
		if (qry.value("fechahasta")) {
			this.child("fdbFechaDesde").setValue(util.addDays(qry.value("fechahasta"), 1));
		}
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
