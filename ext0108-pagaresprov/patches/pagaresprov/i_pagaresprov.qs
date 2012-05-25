/***************************************************************************
                 i_pagaresprov.qs  -  description
                             -------------------
    begin                : vie feb 01 2007
    copyright            : (C) 2007 by InfoSiAL S.L.
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
	function bufferChanged(fN:String) { this.ctx.oficial_bufferChanged(fN); }
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
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	
	switch(fN){
		/** \C Si cambia el intervalo se recalculan las fechas.
		\end */
		case "codintervaloe": {
			var intervalo:Array = [];
			if (cursor.valueBuffer("codintervaloe")) {
				intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervaloe"));
				cursor.setValueBuffer("d_pagaresprov_fecha", intervalo.desde);
				cursor.setValueBuffer("h_pagaresprov_fecha", intervalo.hasta);
			}
			break;
		}
		case "codintervalov": {
			var intervalo:Array = [];
			if (cursor.valueBuffer("codintervalov")) {
				intervalo = flfactppal.iface.pub_calcularIntervalo(cursor.valueBuffer("codintervalov"));
				cursor.setValueBuffer("d_pagaresprov_fechav", intervalo.desde);
				cursor.setValueBuffer("h_pagaresprov_fechav", intervalo.hasta);
			}
			break; 
		}
		/*
		case "codcuenta": {
			var codCuenta:String = cursor.valueBuffer("codcuenta");
			if (codCuenta && codCuenta != "")
				this.child("fdbNumero").setFilter("codcuenta = '" + codCuenta + "'");
			else
				this.child("fdbNumero").setFilter("");
		}
		*/
	}

}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
