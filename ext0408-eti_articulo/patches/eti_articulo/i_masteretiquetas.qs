/***************************************************************************
                 i_masterinventario.qs  -  description
                             -------------------
    begin                : vie abr 4 2008
    copyright		: (C) 2008 by Pablo A. Llanos
    email                	: pllanos@ed-ar.com.ar
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
		function obtenerOrden(nivel:Number, cursor:FLSqlCursor):String {
				return this.ctx.oficial_obtenerOrden(nivel, cursor);
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
	var cursor:FLSqlCursor = this.cursor();
	var seleccion:String = cursor.valueBuffer("id");
	if (!seleccion) {
		return false;
	}
	
	var qryLineas:FLSqlQuery = new FLSqlQuery();
	with (qryLineas) {
		setTablesList("i_etiquetas,articulos");
		setSelect("i_etiquetas.id,i_etiquetas.i_articulos_codfamilia,i_etiquetas.h_articulos_referencia,i_etiquetas.d_articulos_referencia,articulos.referencia,articulos.descripcion,articulos.codbarras,articulos.pvp");
		setFrom("i_etiquetas,articulos LEFT OUTER JOIN familias ON familias.codfamilia = articulos.codfamilia");
		setWhere("i_etiquetas.id = " + seleccion + " AND articulos.referencia BETWEEN i_etiquetas.d_articulos_referencia AND i_etiquetas.h_articulos_referencia ORDER BY articulos.referencia");
		setForwardOnly(true);
	}
	if (!qryLineas.exec()) {
		return false;
	}

	var cantidad:Number = Input.getNumber(util.translate("scripts", "Nº etiquetas por articulo"), 1, 0, 1, 100000, util.translate("scripts", "Imprimir etiquetas"));
	if (!cantidad) {
		return false;
	}

	var xmlKD:FLDomDocument = new FLDomDocument;
	xmlKD.setContent("<!DOCTYPE KUGAR_DATA><KugarData/>");
	var eRow:FLDomElement;
	while (qryLineas.next()) {
		for (var i:Number = 0; i < cantidad; i++) {
			eRow = xmlKD.createElement("Row");
			eRow.setAttribute("barcode", qryLineas.value("articulos.codbarras"));
			eRow.setAttribute("referencia", qryLineas.value("articulos.referencia"));
			eRow.setAttribute("descripcion", qryLineas.value("articulos.descripcion"));
			eRow.setAttribute("pvp", qryLineas.value("articulos.pvp"));
			eRow.setAttribute("level", 0);
			xmlKD.firstChild().appendChild(eRow);
		}
	}
	if (!flfactalma.iface.pub_lanzarEtiArticulo(xmlKD)) {
		return false;
	}
}


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
