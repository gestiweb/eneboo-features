/***************************************************************************
                 lineasalbaranesclins.qs  -  description
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
	function validateForm() { return this.ctx.interna_validateForm(); }
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

function interna_init() {
}

function interna_validateForm():Boolean
{
	if (!this.cursor().valueBuffer("numserie"))
		return true;

	var util:FLUtil = new FLUtil();
	if (// Si existe un número de serie que no es de este albarán
		util.sqlSelect("numerosserie", "id", 
			"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
			" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
			" AND idalbaranventa <> " + this.cursor().cursorRelation().valueBuffer("idalbaran") +
			" AND vendido = 'true'")
		// Salvo que sea otra línea de este mismo remito
		|| util.sqlSelect("lineasalbaranescli", "idlinea", 
			"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
			" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
			" AND idlinea <> " + this.cursor().cursorRelation().valueBuffer("idlinea"))
		// Salvo que sea otra línea de ns de este mismo remito
		|| util.sqlSelect("lineasalbaranesclins", "idlinea", 
			"numserie = '" + this.cursor().valueBuffer("numserie") + "'" +
			" AND referencia = '" +	this.cursor().valueBuffer("referencia") + "'" +
			" AND idlinea <> " + this.cursor().valueBuffer("idlinea")))
	{
		MessageBox.warning(util.translate("scripts", "Este número de serie corresponde a un artículo ya vendido"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}	
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
