/***************************************************************************
                 pasarelaspago.qs  -  description
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
class oficial extends interna 
{
	var parametros:Array;

	function oficial( context ) { interna( context ); } 
	function recargarParametros() {
		return this.ctx.oficial_recargarParametros();
	}
	function parametrosPasarelas(codPasarela:String):Boolean {
		return this.ctx.oficial_parametrosPasarelas(codPasarela);
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
	connect(this.child("pbnRecargarParametros"), "clicked()", this, "iface.recargarParametros");
}

//// INTERNA //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_recargarParametros()
{
	var util:FLUtil = new FLUtil();
	
	res = MessageBox.information(util.translate("scripts", "A continuación se recargará la lista de parámetros\n\n¿Continuar?"), MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
		
	var codPasarela:String = this.cursor().valueBuffer("codpasarela");
	if (!this.iface.parametrosPasarelas(codPasarela)) {
		MessageBox.information(util.translate("scripts", "No existe ninguna lista de parámetros para el código de pasarela establecido"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
	
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		var curP:FLSqlCursor = this.child("tdbParametros").cursor();
		curP.setModeAccess(curP.Insert);
		curP.commitBufferCursorRelation();
	}
	
	var curTab:FLSqlCursor = new FLSqlCursor("parametrospasarela");
	
	for (var i:Number = 0; i < this.iface.parametros.length; i++) {
		curTab.select("codpasarela = '" + codPasarela + "' AND parametro = '" + this.iface.parametros[i][0] + "'");
		if (curTab.first())
			curTab.setModeAccess(curTab.Edit);
		else
			curTab.setModeAccess(curTab.Insert);
			
		curTab.refreshBuffer();
		curTab.setValueBuffer("parametro", this.iface.parametros[i][0]);
		curTab.setValueBuffer("valor", this.iface.parametros[i][1]);
		curTab.setValueBuffer("codpasarela", codPasarela);
		curTab.commitBuffer();		
	}
	
	this.child("tdbParametros").refresh();
}


function oficial_parametrosPasarelas(codPasarela:String):Boolean
{
	switch(codPasarela) {
	
		case "paypal":
		
			this.iface.parametros =
				[
				["business",""],
				["page_style","PayPal"],
				["currency_code","EUR"],
				["lc","ES"],
				["bn","PP-BuyNowBF"]
			];
		
		break;
		
		default:
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
