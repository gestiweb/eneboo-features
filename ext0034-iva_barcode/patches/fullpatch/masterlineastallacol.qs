/***************************************************************************
                 masterlineastallacol.qs  -  description
                             -------------------
    begin                : jue sep 21 2006
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
	var tablaLineasTC:FLTable;
	var arrayLineasTC:Array;
	var bloqueoCantidad:Boolean;
    function oficial( context ) { interna( context ); }
	function bufferChanged(fN:String) {
		return this.ctx.oficial_bufferChanged(fN);
	}
	function actualizarTabla() {
		return this.ctx.oficial_actualizarTabla();
	}
	function insertar() {
		return this.ctx.oficial_insertar();
	}
	function nuevaFila() {
		return this.ctx.oficial_nuevaFila();
	}
	function refrescarTablaTC(tblTallaColor:FLTable, arrayTC:Array, cursor:FLSqlCursor):Array {
		return this.ctx.oficial_refrescarTablaTC(tblTallaColor, arrayTC, cursor);
	}
	function calcularCantidad() {
		return this.ctx.oficial_calcularCantidad();
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
/** \C lineaspedidosprov
\end */
function interna_init()
{
	this.iface.tablaLineasTC = this.child("tblAtributos");
	this.iface.arrayLineasTC = [];
	var cursor:FLSqlCursor = this.cursor();
	connect (cursor, "bufferChanged(QString)", this, "iface.bufferChanged");
	connect (this.child("pbnInsertar"), "clicked()", this, "iface.insertar");
	connect (this.child("tbnNuevaFila"), "clicked()", this, "iface.nuevaFila");
	connect (this.iface.tablaLineasTC, "valueChanged(int, int)", this, "iface.calcularCantidad");
	
	this.child("pushButtonAccept").setEnabled(false);
	var referencia:String = cursor.valueBuffer("referencia")
	if (referencia && referencia != "") {
		this.child("fdbReferencia").setValue("");
		this.child("fdbReferencia").setValue(referencia);
	}
	
	switch (cursor.modeAccess()) {
		case cursor.Browse: {
			this.child("pbnInsertar").enabled = false;
			break;
		}
	}
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
		case "referencia": {
			this.iface.actualizarTabla(true);
			this.child("fdbPvpUnitario").setValue(formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", cursor));
			this.child("fdbCodImpuesto").setValue(formRecordlineaspedidosprov.iface.pub_commonCalculateField("codimpuesto", cursor));
			break;
		}
		case "barcode": {
			break;
		}
		default: {
			formRecordlineaspedidosprov.iface.pub_commonBufferChanged(fN, this);
		}
	}
}

/** \D Si el almacén y la referencia son válidos, carga los datos de stock actuales
@param inicio: Indica si la tabla debe cargarse con los datos de líneas ya introducidas
\end */
function oficial_actualizarTabla(inicio:Boolean)
{
	var util:FLUtil = new FLUtil;
	var cursor:FLSqlCursor = this.cursor();
	var referencia = cursor.valueBuffer("referencia");
	if (!referencia || referencia == "")
		return false;

	if (!util.sqlSelect("articulos", "referencia", "referencia = '" + referencia + "'"))
		return false;

	var arrayTCPrevio:Array = this.iface.arrayLineasTC;

	this.iface.bloqueoCantidad = true;
	this.iface.arrayLineasTC = this.iface.refrescarTablaTC(this.iface.tablaLineasTC, this.iface.arrayLineasTC, cursor);
	this.iface.bloqueoCantidad = false;
	this.iface.calcularCantidad();
	
	if (inicio) {
	
	}
}

/** \D Compone una tabla de tantas filas como tallas y tantas columnas como colores hay definidos para el artículo seleccionado, indicando en cada celda la cantidad existente para la combinación talla / color en el almacén seleccionado */
function oficial_refrescarTablaTC(tblTallaColor:FLTable, arrayTC:Array, cursor:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var referencia:String = cursor.valueBuffer("referencia");
	
	if (!referencia || referencia == "")
		return;
	
	var numFilas:Number = tblTallaColor.numRows();
	var numColumnas:Number;
	
	for (var i:Number = (numFilas - 1); i >= 0; i--)
		tblTallaColor.removeRow(i);
	
	var codGrupoTalla:String = util.sqlSelect("articulos", "codgrupotalla", "referencia = '" + referencia + "'");
	var listaTallas:String = "";
	var tallas:Array = [];
	var qryTallas:FLSqlQuery = new FLSqlQuery;
	if (codGrupoTalla && codGrupoTalla != "") {
		qryTallas.setTablesList("tallas");
		qryTallas.setSelect("codtalla");
		qryTallas.setFrom("tallas");
		qryTallas.setWhere("codgrupotalla = '" + codGrupoTalla + "'");
	} else {
		qryTallas.setTablesList("atributosarticulos");
		qryTallas.setSelect("talla");
		qryTallas.setFrom("atributosarticulos");
		qryTallas.setWhere("referencia = '" + referencia + "' GROUP BY talla ORDER BY talla");
	}
	qryTallas.setForwardOnly(true);
	if (!qryTallas.exec())
		return;
	numColumnas = 0;
	while (qryTallas.next()) {
		tallas[numColumnas++] = qryTallas.value(0);
		if (listaTallas)
			listaTallas += "/";
		listaTallas += qryTallas.value(0);
	}
	tblTallaColor.setNumCols(numColumnas);
	tblTallaColor.setColumnLabels("/", listaTallas);
	
	var listaColores:String = "";
	var colores:Array = [];
	var qryColores:FLSqlQuery = new FLSqlQuery;
	qryColores.setTablesList("coloresarticulo");
	qryColores.setSelect("codcolor");
	qryColores.setFrom("coloresarticulo");
	qryColores.setWhere("referencia = '" + referencia + "' ORDER BY codcolor");
	if (!qryColores.exec())
		return;
	numFilas = 0;
	while (qryColores.next()) {
		colores[numFilas++] = qryColores.value("codcolor");
		if (listaColores)
			listaColores += "/";
		listaColores += qryColores.value("codcolor");
	}
	tblTallaColor.insertRows(0, numFilas);
	tblTallaColor.setRowLabels("/", listaColores);
	
	if (arrayTC)
		delete arrayTC;
	arrayTC = new Array(numFilas);
	for (var i:Number = 0; i < numFilas; i++) {
		arrayTC[i] = new Array(numColumnas);
		for (var k:Number = 0; k < numColumnas; k++) {
			arrayTC[i][k] = new Array(3);
			arrayTC[i][k]["cantidad"] = 0;
			arrayTC[i][k]["barcode"] = false;
			arrayTC[i][k]["talla"] = tallas[k];
			arrayTC[i][k]["color"] = colores[i];
			arrayTC[i][k]["idlineapedido"] = 0;
			arrayTC[i][k]["idpedido"] = 0;
		}
	}
	
	var qryLineas:FLSqlQuery = new FLSqlQuery;
	qryLineas.setTablesList(cursor.valueBuffer("tabla"));
	qryLineas.setSelect("talla, color, SUM(cantidad), COUNT(idlinea)");
	qryLineas.setFrom(cursor.valueBuffer("tabla"));
	qryLineas.setWhere(cursor.valueBuffer("campopadre") + " = " + cursor.valueBuffer("valorcampopadre") + " AND referencia = '" + referencia + "' GROUP BY referencia, talla, color");
	if (!qryLineas.exec())
		return false;

	while (qryLineas.next()) {
		for (numFilas = 0; numFilas < colores.length; numFilas++) {
			if (colores[numFilas] == qryLineas.value("color"))
				break;
		}
		if (numFilas == colores.length)
			continue;
		
		for (numColumnas = 0; numColumnas < tallas.length; numColumnas++) {
			if (tallas[numColumnas ] == qryLineas.value("talla"))
				break;
		}
		if (numColumnas == tallas.length)
			continue;

		tblTallaColor.setText(numFilas, numColumnas, qryLineas.value("SUM(cantidad)"));
		arrayTC[numFilas][numColumnas]["barcode"] = util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND talla = '" + qryLineas.value("talla") + "' AND color = '" + qryLineas.value("color") + "'");
		arrayTC[numFilas][numColumnas]["talla"] = qryLineas.value("talla");
		arrayTC[numFilas][numColumnas]["color"] = qryLineas.value("color");

		// Gestión de albaranes que provienen de pedidos (posible generación de pedidos parciales)
		if (cursor.valueBuffer("tabla") == "lineasalbaranesprov") {
			if (qryLineas.value("COUNT(idlinea)") > 1) {
				if (util.sqlSelect("lineasalbaranesprov", "idlinea", "idalbaran = " + cursor.valueBuffer("valorcampopadre") + " AND barcode = '" + arrayTC[numFilas][numColumnas]["barcode"] + "' AND idlineapedido <> 0 AND idlineapedido IS NOT NULL")) {
					MessageBox.warning(util.translate("scripts", "Existe más de una línea con artículos de la combinación %1 + %2.\nAl menos una de estas línea procede de un pedido de proveedor.\nNo es posible editar las cantidades de prendas desde este formulario, hágalo desde cada línea individual para evitar ambigüedades.").arg(qryLineas.value("talla")).arg(qryLineas.value("color")), MessageBox.Ok, MessageBox.NoButton);
					this.child("pbnInsertar").enabled = false;
					return false;
				}
			} else {
				var qryLineaPedido:FLSqlQuery = new FLSqlQuery;
				with (qryLineaPedido) {
					setTablesList("lineasalbaranesprov");
					setSelect("idlineapedido, idpedido");
					setFrom("lineasalbaranesprov");
					setWhere("idalbaran = " + cursor.valueBuffer("valorcampopadre") + " AND barcode = '" + arrayTC[numFilas][numColumnas]["barcode"] + "'");
					setForwardOnly(true);
				}
				if (!qryLineaPedido.exec())
					return false;

				if (!qryLineaPedido.first())
					return false;

				var idLineaPedido:String = qryLineaPedido.value("idlineapedido");
				if (!idLineaPedido)
					idLineaPedido = 0;
				arrayTC[numFilas][numColumnas]["idlineapedido"] = idLineaPedido;
				
				var idPedido:String = qryLineaPedido.value("idpedido");
				if (!idPedido)
					idPedido = 0;
				arrayTC[numFilas][numColumnas]["idpedido"] = idPedido;
			}
		}
	}
	return arrayTC;
}


function oficial_insertar()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;
	var datos:String = "";
	var nuevaCantidad:Number;
	var referencia:String = cursor.valueBuffer("referencia");
	var costeInicial:Number = cursor.valueBuffer("pvpunitario");
	var texto:String;
	var codTalla:String;
	var codColor:String;
	var barCode:String;
	var coste:Number;
	var preguntar:Boolean = true;
	var usarCosteProv:Boolean = false;
	for (var fila:Number = 0; fila < this.iface.tablaLineasTC.numRows(); fila++) {
		for (var columna:Number = 0; columna < this.iface.arrayLineasTC[fila].length; columna++) {
			texto = parseFloat(this.iface.tablaLineasTC.text(fila, columna))
			if (!texto || texto == "")
				continue;
			nuevaCantidad = parseFloat(texto);
			if (isNaN(nuevaCantidad))
				continue;
			if (nuevaCantidad == 0)
				continue;
			
			barCode = false;
			viejaCantidad = 0;
			barCode = this.iface.arrayLineasTC[fila][columna]["barcode"];
			codTalla = this.iface.arrayLineasTC[fila][columna]["talla"];
			codColor = this.iface.arrayLineasTC[fila][columna]["color"];
			if (!barCode) {
				barCode = flfactalma.iface.pub_construirBarcode(referencia, codTalla, codColor);
			}
			
			cursor.setValueBuffer("barcode", barCode);
			coste = formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", cursor);
debug(coste);
debug(costeInicial);
			if (preguntar && parseFloat(coste) != parseFloat(costeInicial)) {
				var dialog = new Dialog;
				dialog.caption = util.translate("scripts", "Aviso");
				dialog.okButtonText = util.translate("scripts", "Aceptar");
				dialog.cancelButtonText = util.translate("scripts", "Cancelar");
				
				var texto = new TextEdit;
				texto.text = util.translate("scripts", "El coste del barcode %1 (talla %2, color %3) %4 es distinto del coste por proveedor asignado %5\n¿Qué desea hacer?").arg(barCode).arg(codTalla).arg(codColor).arg(util.roundFieldValue(costeInicial, "lineastallacol", "pvpunitario")).arg(util.roundFieldValue(coste, "barcodeprov", "coste"));
				dialog.add( texto );
				
				var gbxOpciones = new GroupBox;
				var rbnOp1 = new RadioButton;
				rbnOp1.text = util.translate("scripts", "Usar el coste indicado (%1)").arg(util.roundFieldValue(costeInicial, "lineastallacol", "pvpunitario"));
				rbnOp1.checked = true;
				gbxOpciones.add(rbnOp1);

				var rbnOp2 = new RadioButton;
				rbnOp2.text = util.translate("scripts", "Usar el coste por proveedor (%1)").arg(util.roundFieldValue(coste, "barcodeprov", "coste"));
				gbxOpciones.add(rbnOp2);
				dialog.add(gbxOpciones);

				var chkTodos = new CheckBox;
				chkTodos.text = util.translate("scripts", "Aplicar respuesta a los demás barcodes");
				chkTodos.checked = true;
				dialog.add(chkTodos);
				
				if( !dialog.exec() )
					return;
				
				if (chkTodos.checked)
					preguntar = false;
				if (rbnOp1.checked)
					usarCosteProv = false;
				else
					usarCosteProv = true;
			}
			if (!usarCosteProv)
				coste = costeInicial;

			if (datos != "")
				datos += ";"
			datos += barCode + "," + codTalla + "," + codColor + "," + nuevaCantidad + "," + coste;
			if (cursor.valueBuffer("tabla") == "lineasalbaranesprov") {
				datos += "," + this.iface.arrayLineasTC[fila][columna]["idlineapedido"];
				datos += "," + this.iface.arrayLineasTC[fila][columna]["idpedido"];
			}
debug(datos);
		}
	}

	cursor.setValueBuffer("datos", datos);
	this.child("pushButtonAccept").setEnabled(true);
	this.child("pushButtonAccept").animateClick();
}

/** \D Construye el barcode componiendo el código como referencia + codTalla + codColor
@param	referencia: Referencia del artículo
@param	codTalla: Código de talla
@param	codColor: Código de color
@retrun barCode
\end */
function oficial_construirBarcode(referencia:Sring, codTalla:String, codColor:String):String
{
	return referencia + codTalla + codColor; 
}

function oficial_nuevaFila()
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String = cursor.valueBuffer("referencia");
	if (!referencia || referencia == "")
		return;
	
	var res:Number = MessageBox.information(util.translate("scripts", "Si modifica la tabla de tallas y colores perderá los datos que haya modificado en la misma. ¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return false;

	if (!flfactalma.iface.pub_pedirColor(referencia))
		return false;

	this.iface.bloqueoCantidad = true;
	this.iface.arrayLineasTC = this.iface.refrescarTablaTC(this.iface.tablaLineasTC, this.iface.arrayLineasTC, cursor);
	this.iface.bloqueoCantidad = false;
	this.iface.calcularCantidad();
}

/** \D Calcula y modifica el valor del campo cantidad como suma de las cantidades introducidas en la tabla
\end */
function oficial_calcularCantidad()
{
	if (this.iface.bloqueoCantidad)
		return;

	if (!this.iface.arrayLineasTC || this.iface.arrayLineasTC.length == 0) {
		this.child("fdbCantidad").setValue(0);
		return;
	}

	var numCols:Number = this.iface.arrayLineasTC[0].length;
	var valor:Number = 0;
	var temp:Number;
	for (var fila:Number = 0; fila < this.iface.tablaLineasTC.numRows(); fila++) {
		for (var col:Number = 0; col < numCols; col++) {
			temp = parseFloat(this.iface.tablaLineasTC.text(fila, col));
			if (!isNaN(temp))
				valor += temp;
		}
	}
	this.child("fdbCantidad").setValue(valor);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
