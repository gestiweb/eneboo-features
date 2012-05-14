/***************************************************************************
                 lineasservicioscli.qs  -  description
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
	function calculateField(fN:String):String { return this.ctx.interna_calculateField(fN); }
	function acceptedForm() { return this.ctx.interna_acceptedForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
    function oficial( context ) { interna( context ); } 
	function desconectar() {
		return this.ctx.oficial_desconectar();
	}
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
// 	function obtenerTarifa(codCliente:String):String {
// 		return this.ctx.oficial_obtenerTarifa(codCliente);
// 	}
// 	function calculateField(fN:String):String {
// 		return this.ctx.oficial_calculateField(fN);
// 	}
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
Este formulario realiza la gestión de las líneas de servicios a clientes.
\end */
function interna_init()
{
		var util:FLUtil = new FLUtil();
		var cursor:FLSqlCursor = this.cursor();
		connect(cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
		connect(this, "closed()", this, "iface.desconectar");

		var irpf:Number = util.sqlSelect("series", "irpf", "codserie = '" + cursor.cursorRelation().valueBuffer("codserie") + "'");
		if (!irpf)
			irpf = 0;

		if (cursor.modeAccess() == cursor.Insert) {
			this.child("fdbIRPF").setValue(irpf);
			this.child("fdbDtoPor").setValue(this.iface.calculateField("dtopor"));
		}

		this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
		
		var serie:String = cursor.cursorRelation().valueBuffer("codserie");
		var siniva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
		if(siniva){
			this.child("fdbCodImpuesto").setDisabled(true);
			this.child("fdbIva").setDisabled(true);
			this.child("fdbRecargo").setDisabled(true);
			cursor.setValueBuffer("codimpuesto","");
			cursor.setValueBuffer("iva",0);
			cursor.setValueBuffer("recargo",0);
		}
}

/** \C
Los campos calculados de este formulario son los mismos que los del formulario de líneas de pedido a cliente
\end */
function interna_calculateField(fN:String):String
{
		return formRecordlineaspedidoscli.iface.pub_commonCalculateField(fN, this.cursor());
}

function interna_acceptedForm()
{
		var cursor:FLSqlCursor = this.cursor();
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_desconectar()
{
	disconnect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
}

/** \C
Las dependencias entre controles de este formulario son las mismas que las del formulario de líneas de pedido a cliente
\end \end */
function oficial_bufferChanged(fN:String)
{
	formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
}
// function oficial_bufferChanged(fN:String)
// {
// 	formRecordlineaspedidoscli.iface.pub_commonBufferChanged(fN, form);
// 	switch (fN) {
// 	case "referencia":{
// 			this.child("fdbPvpUnitario").setValue(this.iface.calculateField("pvpunitario"));
// 			this.child("fdbCodImpuesto").setValue(this.iface.calculateField("codimpuesto"));
// 			break;
// 		}
// 	case "codimpuesto":{
// 			this.child("fdbIva").setValue(this.iface.calculateField("iva"));
// 			this.child("fdbRecargo").setValue(this.iface.calculateField("recargo"));
// 			break;
// 		}
// 	case "cantidad":
// 	case "pvpunitario":{
// 			this.child("fdbPvpSinDto").setValue(this.iface.calculateField("pvpsindto"));
// 			break;
// 		}
// 	case "pvpsindto":
// 	case "dtopor":{
// 			this.child("lblDtoPor").setText(this.iface.calculateField("lbldtopor"));
// 		}
// 	case "dtolineal":{
// 			this.child("fdbPvpTotal").setValue(this.iface.calculateField("pvptotal"));
// 			break;
// 		}
// 	}
// }

/** \D Obtiene la tarifa asociada a un cliente
@param codCliente: código del cliente
@return Código de la tarifa asociada o false si no tiene ninguna tarifa asociada
\end */
// function oficial_obtenerTarifa(codCliente:String):String
// {
// 	var util:FLUtil = new FLUtil;
// 	return util.sqlSelect("clientes c INNER JOIN gruposclientes gc ON c.codgrupo = gc.codgrupo", "gc.codtarifa", "codcliente = '" + codCliente + "'", "clientes,gruposclientes");
// }
/*
function oficial_calculateField(fN:String):String
{
	return formRecordlineaspedidoscli.iface.pub_commonCalculateField(fN, this.cursor());*/
// 	var util:FLUtil = new FLUtil();
// 	var cursor:FLSqlCursor = this.cursor();
// 	
// 	var valor:String;
// 	switch (fN) {
// 		case "pvpunitario":{
// 			var codCliente:String = util.sqlSelect("servicioscli", "codcliente", "idservicio = " + cursor.valueBuffer("idservicio"));
// 			var referencia:String = cursor.valueBuffer("referencia");
// 			var codTarifa:String = this.iface.obtenerTarifa(codCliente);
// 			if (codTarifa)
// 				valor = util.sqlSelect("articulostarifas", "pvp", "referencia = '" + referencia + "' AND codtarifa = '" + codTarifa + "'");
// 			if (!valor)
// 				valor = util.sqlSelect("articulos", "pvp", "referencia = '" + referencia + "'");
// 			var tasaConv:Number = util.sqlSelect("servicioscli", "tasaconv", "idservicio = " + cursor.valueBuffer("idservicio"));
// 			valor = parseFloat(valor) / tasaConv;
// 			break;
// 		}
// 		case "pvpsindto":{
// 			valor = parseFloat(cursor.valueBuffer("pvpunitario")) * parseFloat(cursor.valueBuffer("cantidad"));
// 			valor = util.roundFieldValue(valor, "lineaspedidoscli", "pvpsindto");
// 			break;
// 		}
// 		case "iva":{
// 			valor = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + cursor.valueBuffer("codimpuesto") + "'");
// 			break;
// 		}
// 		case "lbldtopor":{
// 			valor = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
// 			valor = util.roundFieldValue(valor, "lineaspedidoscli", "pvpsindto");
// 			break;
// 		}
// 		case "pvptotal":{
// 			var dtoPor:Number = (cursor.valueBuffer("pvpsindto") * cursor.valueBuffer("dtopor")) / 100;
// 			dtoPor = util.roundFieldValue(dtoPor, "lineaspedidoscli", "pvpsindto");
// 			valor = cursor.valueBuffer("pvpsindto") - parseFloat(dtoPor) - cursor.valueBuffer("dtolineal");
// 			break;
// 		}
// 		case "dtopor":{
// 			var codCliente:String = util.sqlSelect("servicioscli", "codcliente", "idservicio = " + cursor.valueBuffer("idservicio"));
// 			valor = flfactppal.iface.pub_valorQuery("descuentosclientes,descuentos", "SUM(d.dto)", "descuentosclientes dc INNER JOIN descuentos d ON dc.coddescuento = d.coddescuento", "dc.codcliente = '" + codCliente + "';");
// 			break;
// 		}
// 		case "recargo":{
// 			var codCliente:String = util.sqlSelect("servicioscli", "codcliente", "idservicio = " + cursor.valueBuffer("idservicio"));
// 			var aplicarRecEq:Boolean = util.sqlSelect("clientes", "recargo", "codcliente = '" + codCliente + "'");
// 			if (aplicarRecEq == true) {
// 				valor = util.sqlSelect("impuestos", "recargo", "codimpuesto = '" + cursor.valueBuffer("codimpuesto") + "'");
// 			}
// 			break;
// 		}
// 		case "codimpuesto": {
// 			var codCliente:String = util.sqlSelect("servicioscli", "codcliente", "idservicio = " + cursor.valueBuffer("idservicio"));
// 			var codSerie:String = util.sqlSelect("servicioscli", "codserie", "idservicio = " + cursor.valueBuffer("idservicio"));
// 			if (flfacturac.iface.pub_tieneIvaDocCliente(codSerie, codCliente))
// 				valor = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + cursor.valueBuffer("referencia") + "'");
// 			else
// 				valor = "";
// 			break;
// 		}
// 	}
// 	return valor;
// }


//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
