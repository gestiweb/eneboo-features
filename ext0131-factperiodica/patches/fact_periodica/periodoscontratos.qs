/***************************************************************************
                 se_mastercontratos.qs  -  description
                             -------------------
    begin                : lun jun 20 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
    function validateForm() { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
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
function interna_init()
{
    var cursor:FLSqlCursor = this.cursor();
    var util:FLUtil = new FLUtil;
    
    var codCliente:String = util.sqlSelect("contratos", "codcliente", "codigo = '" + this.child("fdbCodContrato").value() + "'");
    cursor.setValueBuffer("codcliente", codCliente);
}

function interna_validateForm()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;

	var fechaInicio:String = cursor.valueBuffer("fechainicio");
	var fechaFin:String = cursor.valueBuffer("fechafin");
	
	if (fechaInicio > fechaFin) {
		MessageBox.warning(util.translate("scripts","La fecha de fin no puede ser menor que la fecha de inicio"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	if (util.sqlSelect("periodoscontratos", "id", 
		"codcontrato = '" + cursor.valueBuffer("codcontrato") + "' AND " + 
		"id <> " + cursor.valueBuffer("id") + " AND " + 
		"((fechainicio <= '" + fechaInicio + "' AND fechafin >= '" + fechaInicio + "') OR " +
		"(fechainicio <= '" + fechaFin + "' AND fechafin >= '" + fechaFin + "'))")) {
				MessageBox.critical(util.translate("scripts","Este período se superpone a uno ya existente"),MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
	}
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
/////////////////////////////////////////////////////////////////
