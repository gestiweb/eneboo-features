/***************************************************************************
                 articulosatributos.qs  -  description
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
	var tdbStocks:FLTableDB;
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	} 
	function generarAtributosTarifas() { 
		return this.ctx.oficial_generarAtributosTarifas();
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
	this.iface.tdbStocks = this.child("tdbStocks");
	this.iface.tdbStocks.setReadOnly(true);

	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	
	// No se puede crear desde fuera del artículo
	if (!cursor.cursorRelation()) {
		MessageBox.warning(util.translate("scripts", "Sólo es posible crear o editar un barcode desde el artículo al que pertenece"), MessageBox.Ok, MessageBox.NoButton);
		this.child("pushButtonCancel").animateClick();
		return;
	}
	
	var codGrupoTalla:String = cursor.cursorRelation().valueBuffer("codgrupotalla");
	if (codGrupoTalla && codGrupoTalla != "")
		this.child("fdbTalla").setFilter("codgrupotalla = '" + codGrupoTalla  + "'");

	connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	this.iface.bufferChanged("pvpespecial");
	
	connect(this.child("pbnGenerarAtributosTarifas"), "clicked()", this, "iface.generarAtributosTarifas");
	if (this.cursor().modeAccess() == this.cursor().Browse)
		this.child("pbnGenerarAtributosTarifas").enabled = false;
}

function interna_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	/** \C Si la talla escogida para el barcode no está en el grupo de tallas del artículo, se avisa al usuario
	\end */
	var codGrupoTalla:String = cursor.cursorRelation().valueBuffer("codgrupotalla");
	if (codGrupoTalla && codGrupoTalla != "") {
		var codGrupoActual:String = util.sqlSelect("tallas", "codgrupotalla", "codtalla = '" + cursor.valueBuffer("talla") + "'");
		if (codGrupoActual != codGrupoTalla) {
			if (!codGrupoActual || codGrupoActual == "")
				codGrupoActual = util.translate("scripts", "Sin especificar");
			var res:Number = MessageBox.information(util.translate("scripts", "El grupo al que pertenece la talla seleccionada (%1) no coincide con el grupo de tallas asociado al artículo (%2).\n¿Desea continuar?").arg(codGrupoActual).arg(codGrupoTalla), MessageBox.No, MessageBox.Yes);
			if (res != MessageBox.Yes)
				return false;
		}
	}
	/** \C Si el color seleccionado no está en la lista de colores, en nuevo color se incluye en la lista
	\end */
	if (!util.sqlSelect("coloresarticulo", "codcolor", "referencia = '" + cursor.valueBuffer("referencia") + "' AND codcolor = '" + cursor.valueBuffer("color") + "'")) {
		var res:Number = MessageBox.information(util.translate("scripts", "El color seleccionado (%1) no está asociado al artículo.\n¿Desea continuar y asociar este color al artículo?").arg(cursor.valueBuffer("color")), MessageBox.No, MessageBox.Yes);
		if (res != MessageBox.Yes)
			return false;
		var curColoresArt:FLSqlCursor = new FLSqlCursor("coloresarticulo");
		with (curColoresArt) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("referencia", cursor.valueBuffer("referencia"));
			setValueBuffer("codcolor", cursor.valueBuffer("color"));
			setValueBuffer("descolor", util.sqlSelect("colores", "descripcion", "codcolor = '" + cursor.valueBuffer("color") + "'"));
			if (!commitBuffer())
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
function oficial_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	switch (fN) {
		case "pvpespecial": {
			if (cursor.valueBuffer("pvpespecial")) {
				this.child("fdbPvp").setDisabled(false);
			} else {
				this.child("fdbPvp").setDisabled(true);
			}
			break;
		}
	}
}

function oficial_generarAtributosTarifas()
{
	var cursor:FLSqlCursor = this.cursor();
	var barcode:String = cursor.valueBuffer("barcode");
	var pvp:Number;
	 
	if (cursor.valueBuffer("pvpespecial")) 
		pvp = cursor.valueBuffer("pvp");
	else
		pvp = cursor.cursorRelation().valueBuffer("pvp");
		
	var codTarifa:String;
	var incLineal:Number;
	var incPorcentual:Number;
	var pvpTarifa:Number;

	var curArtTar:FLSqlCursor = this.child("tdbAtributosTarifas").cursor()
	var qryTarifas:FLSqlQuery = new FLSqlQuery();

	qryTarifas.setTablesList("tarifas");
	qryTarifas.setSelect("codtarifa,inclineal,incporcentual");
	qryTarifas.setFrom("tarifas");
	
	qryTarifas.exec();
	while (qryTarifas.next()) {
		codTarifa = qryTarifas.value(0);
		with(curArtTar) {
			select("barcode = '" + barcode + "' AND codtarifa = '" + codTarifa + "'");
			if (first()) {
				setModeAccess(Del);
				refreshBuffer();
				commitBuffer();
			} 
		}
	}
	
	qryTarifas.exec();
	while (qryTarifas.next()) {
		codTarifa = qryTarifas.value(0);
		incLineal = parseFloat(qryTarifas.value(1));
		incPorcentual = parseFloat(qryTarifas.value(2));
		pvpTarifa = ((pvp * (100 + incPorcentual)) / 100) + incLineal;
		with(curArtTar) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("barcode", barcode);
			setValueBuffer("codtarifa", codTarifa);
			setValueBuffer("pvp", pvpTarifa);
			commitBuffer();
		}
	}
	
	this.child("tdbAtributosTarifas").refresh();
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
