/***************************************************************************
                 i_masterservicioscli.qs  -  description
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
		function lanzar() {
				return this.ctx.oficial_lanzar();
		}
		function obtenerOrden(nivel:Number, cursor:FLSqlCursor, tabla:String):String {
				return this.ctx.oficial_obtenerOrden(nivel, cursor, tabla);
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
		function pub_obtenerOrden(nivel:Number, cursor:FLSqlCursor, tabla:String):String {
				return this.obtenerOrden(nivel, cursor, tabla);
		}
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
		connect (this.child("toolButtonPrint"), "clicked()", this, "iface.lanzar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_lanzar()
{
		var util:FLUtil = new FLUtil;
		var cursor:FLSqlCursor = this.cursor()
		var seleccion:String = cursor.valueBuffer("id");
		if (!seleccion)
				return;
		var nombreInforme:String = cursor.action();
		var orderBy:String = "";
		var o:String = "";
		for (var i:Number = 1; i < 3; i++) {
				o = this.iface.obtenerOrden(i, cursor, "servicioscli");
				if (o) {
						if (orderBy == "")
								orderBy = o;
						else
								orderBy += ", " + o;
				}
		}
		
		var tipoServicio = cursor.valueBuffer("tiposervicio");
		var filtro:String = "1=1";
		switch(tipoServicio) {
			case util.translate("scripts", "No mantenimiento"):
				filtro += " AND servicioscli.contratomant = false";
			break
			case util.translate("scripts", "Mantenimiento"):
				filtro += " AND servicioscli.contratomant = true";
			break
		}
		
		flfactinfo.iface.pub_lanzarInforme(cursor, nombreInforme, orderBy, "", false, false, filtro);
}


function oficial_obtenerOrden(nivel:Number, cursor:FLSqlCursor, tabla:String):String
{
	var ret:String = "";
	var orden:String = cursor.valueBuffer("orden" + nivel.toString());
	switch(nivel) {
			case 1:
			case 2: {
					switch(orden) {
						case "Número": {
							ret += tabla + ".numservicio";
							break;
						}
						case "Cod.Cliente": {
							ret += tabla + ".codcliente";
							break;
						}
						case "Cliente": {
							ret += tabla + ".nombrecliente";
							break;
						}
						case "Fecha": {
							ret += tabla + ".fecha";
							break;
						}
						case "Total": {
							ret += tabla + ".total";
							break;
						}
					}
					break;
			}
			break;
	}
	if (ret != "") {
			var tipoOrden:String = cursor.valueBuffer("tipoorden" + nivel.toString());
			switch(tipoOrden) {
					case "Descendente": {
							ret += " DESC";
							break;
					}
			}
	}

	if (nivel == 2 && orden != "Número") {
			if (ret == "")
					ret += tabla + ".numservicio";
			else
					ret += ", " + tabla + ".numservicio";
	}

	return ret;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
