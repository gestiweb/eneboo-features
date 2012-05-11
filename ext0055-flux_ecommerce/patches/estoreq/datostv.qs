/***************************************************************************
                 datostv.qs  -  description
                             -------------------
    begin                : lun sep 21 2004
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
    function main() { this.ctx.interna_main(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	
	var conexion:String;
	var tablas:Array;
	var tablasGenerales:Array;
	
    function oficial( context ) { interna( context ); } 
	
	function conectar():Boolean {
		return this.ctx.oficial_conectar();
	}
	function desconectar():Boolean {
		return this.ctx.oficial_desconectar();
	}
	
	function subirDatos():Boolean {
		return this.ctx.oficial_subirDatos();
	}
	function bajarDatos():Boolean {
		return this.ctx.oficial_bajarDatos();
	}
	function importarTabla(tabla:String, nomTabla:String):Number {
		return this.ctx.oficial_importarTabla(tabla, nomTabla);
	}
	function exportarTabla(tabla:String, nomTabla:String, tablaGeneral:Boolean):Number {
		return this.ctx.oficial_exportarTabla(tabla, nomTabla, tablaGeneral);
	}
	function importarPedidos():Number {
		return this.ctx.oficial_importarPedidos();
	}
	function actualizarPedidos():Number {
		return this.ctx.oficial_actualizarPedidos();
	}
	function obtenerListaCampos(tabla:String):Array {
		return this.ctx.oficial_obtenerListaCampos(tabla);
	}
	function eliminarObsoletos(tabla:String):Number {
		return this.ctx.oficial_eliminarObsoletos(tabla);
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

////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

/** @class_definition interna */
//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function init() {
    this.iface.init();
}

function main() {
    this.iface.main();
}

function interna_init() 
{
	this.iface.conexion = "remota";
	connect( this.child( "pbnUp" ), "clicked()", this, "iface.subirDatos" );
	connect( this.child( "pbnDown" ), "clicked()", this, "iface.bajarDatos" );

	if (!this.cursor().valueBuffer("esquemaactualizado")) {
		this.child("fdbSubirTodo").setValue(true);
		this.child("fdbSubirTodo").setDisabled(true);
	}

	this.iface.tablasGenerales = new Array(
		"impuestos",
		"series",
		"ejercicios",
		"divisas"
	);
	
	this.iface.tablas = new Array(
		"idiomas",
		"infogeneral",
		"modulosweb",
		"noticias",
		"traducciones",
		"fabricantes",
		"faqs",

		"galeriasimagenes",
		"imagenes",
		"tarifas",
		"gruposclientes",
		"almacenes",
		"gruposatributos",
		"familias",
		"plazosenvio",
		"articulos",
		"atributos",
		"atributosart",
		"accesoriosart",
		"formasenvio",
		"pasarelaspago",
		"parametrospasarela",
		"formaspago",
		"opcionestv",

		"paises",
		"provincias",
		"clientes",
		"empresa"
	);
}

function interna_main()
{
	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("opcionestv", "arquitectura", "1=1") == util.translate("scripts", "Unificada")) {
		MessageBox.information(util.translate("scripts", "Las actualizaciones de datos están sólo disponibles\npara configuraciones de bases de datos distribuidas\n\nEn esta configuración no son necesarias"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}

	var f = new FLFormSearchDB("datostv");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
					commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
					cursor.commit();
					commitOk = true;
			}
		}
		f.close();
	}
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_subirDatos()
{
	var util:FLUtil = new FLUtil();
	
	var res = MessageBox.information(util.translate("scripts", "A continuación se establecerá una conexión con la base de datos remota\ny se actualizarán los artículos y otros datos que hayan sido modificados\n\n¿Desea continuar?"),
		MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return false;

	if (this.cursor().valueBuffer("subirtodo")) {
		res = MessageBox.information(util.translate("scripts", "Ha indicado la opción de Actualizar todos los datos.\nSe actualizarán todos los datos, no sólo los modificados\n\n¿Está seguro?"),
			MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
		if (res != MessageBox.Yes)
			return false;
	}

	if (!this.iface.conectar())
		return false;
	
	var msgResumen:String = util.translate("scripts", "Resultados:\n");
	var numExportados:Number;
	var numEliminados:Number;
	var totalExportados:Number = 0;

	// Tablas generales si es necesario
	if (this.cursor().valueBuffer("subirtodo")) {
		for (var i:Number = 0; i < this.iface.tablasGenerales.length; i++) {
			numExportados = this.iface.exportarTabla(this.iface.tablasGenerales[i], this.iface.tablasGenerales[i], true);
			if (numExportados > 0)
				msgResumen += "\n" + this.iface.tablasGenerales[i] + "   " + 
					util.translate("scripts", "Modificados o nuevos: ") + numExportados;
	
			totalExportados += numExportados;
		}
	}

	for (var i:Number = 0; i < this.iface.tablas.length; i++) {
	
		numExportados = this.iface.exportarTabla(this.iface.tablas[i], this.iface.tablas[i]);
		if (numExportados > 0)
			msgResumen += "\n" + this.iface.tablas[i] + "   " + 
				util.translate("scripts", "Modificados o nuevos: ") + numExportados;

		totalExportados += numExportados;
	}

	for (var i:Number = this.iface.tablas.length - 1; i >= 0; i--) {
	
		numEliminados = this.iface.eliminarObsoletos(this.iface.tablas[i]);
		if (numEliminados > 0)
			msgResumen += "\n" + this.iface.tablas[i] + "   " + 
				util.translate("scripts", "Eliminados: ") + numEliminados;

		totalExportados += numEliminados;
	}

 	numPedidos = this.iface.actualizarPedidos();
 	if (numPedidos > 0) {
 		totalExportados += numPedidos;
 		msgResumen += "\n" + util.translate("scripts", "Pedidos actualizados: ") + numPedidos;
 	}

	if (totalExportados > 0)
		MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
	else
		MessageBox.information(util.translate("scripts", "No se encontraron registros para actualizar"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

	this.iface.desconectar();
	
	if (!this.cursor().valueBuffer("esquemaactualizado")) {
		this.cursor().setValueBuffer("esquemaactualizado", true);
		this.child("pushButtonAccept").animateClick();
	}
}

function oficial_bajarDatos()
{
	var util:FLUtil = new FLUtil();
	
	var res = MessageBox.information(util.translate("scripts", "A continuación se establecerá una conexión con la base de datos remota\ny se descargarán los nuevos clientes y pedidos\n\n¿Desea continuar?"),
		MessageBox.Yes, MessageBox.No, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return false;
	
	if (!this.iface.conectar())
		return false;
	
	var msgResumen:String = util.translate("scripts", "Registros nuevos o actualizados:\n");

	var numImportados:Number = this.iface.importarTabla("clientes", "Clientes");
	msgResumen += "\n" + util.translate("scripts", "Clientes") + ": " + numImportados;

	numImportados = this.iface.importarTabla("dirclientes", "Direcciones de Clientes");
	msgResumen += "\n" + util.translate("scripts", "Direcciones de clientes") + ": " + numImportados;

	numImportados = this.iface.importarPedidos();
	msgResumen += "\n\n" + util.translate("scripts", "Pedidos") + ": " + numImportados;

	MessageBox.information(msgResumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

	this.iface.desconectar();
	this.child("pushButtonAccept").animateClick();
}

function oficial_conectar() 
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();

	var driver:String = cursor.valueBuffer("driver");
	var nombreBD:String = cursor.valueBuffer("nombrebd");
	var usuario:String = cursor.valueBuffer("usuario");
	var host:String = cursor.valueBuffer("host");
	var puerto:String = cursor.valueBuffer("puerto");

	var tipoDriver:String;
	if (sys.nameDriver().search("PSQL") > -1)
		tipoDriver = "PostgreSQL";
	else
		tipoDriver = "MySQL";

	if (host == sys.nameHost() && nombreBD == sys.nameBD() && driver == tipoDriver) {
		MessageBox.warning(util.translate("scripts",
			"Los datos de conexión son los de la presente base de datos\nDebe indicar los datos de conexión de la base de datos remota"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	if (!driver || !nombreBD || !usuario || !host) {
		MessageBox.warning(util.translate("scripts",
			"Debe indicar el tipo de base de datos, nombre de la misma, usuario y servidor"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	var password:String = Input.getText( util.translate("scripts", "Password de conexión (en caso necesario)") );

	util.createProgressDialog( util.translate( "scripts", "Conectando..." ), 10);
	util.setProgress(2);

	if (!sys.addDatabase(driver, nombreBD, usuario, password, host, puerto, this.iface.conexion)) {
		util.destroyProgressDialog();
		return false;
	}
		
	util.destroyProgressDialog();
	return true;
}

function oficial_desconectar() 
{
	var cursor:FLSqlCursor = this.cursor();
	var nombreBD:String = cursor.valueBuffer("nombrebd");
	
	if (!sys.removeDatabase(this.iface.conexion));
		return false;
		
	return true;
}

function oficial_importarTabla(tabla:String, nomTabla:String)
{
	var util:FLUtil = new FLUtil();

	var curLoc:FLSqlCursor = new FLSqlCursor(tabla);
  	var curRem:FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

	var campoClave:String = curLoc.primaryKey();
	var listaCampos:Array = this.iface.obtenerListaCampos(tabla);

	var valorClave;
	var paso:Number = 0;
	var importados:Number = 0;
	var modificado:Boolean;
 	var valor;

 	curRem.select("modificado = true");
	util.createProgressDialog( util.translate( "scripts", "Importando " ) + nomTabla, curRem.size());
	util.setProgress(1);

 	while (curRem.next()) {
		util.setProgress(paso++);
		modificado = false;

 		valorClave = curRem.valueBuffer(campoClave);
		curLoc.select(campoClave + " = '" + valorClave + "'");

		// Actualizacion (si toca)
		if (curLoc.first()) {
			if (curRem.valueBuffer("modificado")) {
				curLoc.setModeAccess(curLoc.Edit);
				modificado = true;
				
				// Si ya está en local, lo actualizamos en remoto como no modificado
				curRem.setModeAccess(curLoc.Edit);
				curRem.refreshBuffer();
				curRem.setValueBuffer("modificado", false);
				if (!curRem.commitBuffer())
					debug(util.translate("scripts",	"Error al actualizar la tabla local %0 en el código/id " ).arg(tabla) + valorClave);
			}
			else {
				continue;
			}
		}
		else {
			curLoc.setModeAccess(curLoc.Insert);
		}

		curLoc.refreshBuffer();

		// Bucle de campos
		for(var i = 0; i < listaCampos.length; i++) {

			// Excepciones *****************
			if ((listaCampos[i] == "coddir" || listaCampos[i] == "coddirenv") && tabla == "pedidoscli")
				continue;

			if (listaCampos[i] == "idprovincia")
				continue;

			valor = curRem.valueBuffer(listaCampos[i]);
			curLoc.setValueBuffer(listaCampos[i], valor);
		}

		debug(curLoc.valueBuffer("codcliente"));

		// El local queda sin modificar
		curLoc.setValueBuffer("modificado", false);

		// OK local
		if (curLoc.commitBuffer())
			importados++;

		// Error
		else {
			debug(util.translate("scripts",	"Error al importar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
		}

	}

	util.destroyProgressDialog();

	return importados;
}

function oficial_importarPedidos()
{
	var util:FLUtil = new FLUtil();

	// Pedidos
	var curLoc:FLSqlCursor = new FLSqlCursor("pedidoscli");
  	var curRem:FLSqlCursor = new FLSqlCursor("pedidoscli", this.iface.conexion);
	var campoClave:String = "codigo";
	var listaCampos:Array = this.iface.obtenerListaCampos("pedidoscli");

	var curLocL:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
  	var curRemL:FLSqlCursor = new FLSqlCursor("lineaspedidoscli", this.iface.conexion);
	var listaCamposL:Array = this.iface.obtenerListaCampos("lineaspedidoscli");

	var valorClave;
	var idPedido:Number;
	var paso:Number = 0;
	var importados:Number = 0;

 	curRem.select("modificado = true");
	util.createProgressDialog( util.translate( "scripts", "Importando pedidos" ), curRem.size());
	util.setProgress(1);

 	while (curRem.next()) {

		util.setProgress(paso++);
		modificado = false;

 		valorClave = curRem.valueBuffer(campoClave);
		curLoc.select(campoClave + " = '" + valorClave + "'");

		if (curLoc.first()) {
			// Si ya está en local, lo actualizamos en remoto como no modificado
			curRem.setModeAccess(curLoc.Edit);
			curRem.refreshBuffer();
			curRem.setValueBuffer("modificado", false);
			if (!curRem.commitBuffer())
				debug(util.translate("scripts",	"Error al actualizar la tabla remota pedidoscli en el código/id " ) + valorClave);
			continue;
		}

		curLoc.setModeAccess(curLoc.Insert);
		curLoc.refreshBuffer();

		// Bucle de campos
		for(var i = 0; i < listaCampos.length; i++) {

			// Excepciones *****************
			if ((listaCampos[i] == "coddir" || listaCampos[i] == "coddirenv" || listaCampos[i] == "idpedido"))
				continue;

			if (listaCampos[i] == "idprovincia")
				continue;

			curLoc.setValueBuffer(listaCampos[i], curRem.valueBuffer(listaCampos[i]));
		}

		if (curLoc.commitBuffer())
			importados++;
		else
			debug(util.translate("scripts",	"Error al importar el pedido " ) + valorClave);

		
		idPedidoRem = curRem.valueBuffer("idpedido");
		idPedidoLoc = curLoc.valueBuffer("idpedido");

		// Lineas *******************
	 	curRemL.select("idpedido = " + idPedidoRem);
	 	while (curRemL.next()) {

			curLocL.setModeAccess(curLocL.Insert);
			curLocL.refreshBuffer();

			for(var iL = 0; iL < listaCamposL.length; iL++) {

				// Excepciones *****************
				if (listaCamposL[iL] == "idlinea") continue;

				curLocL.setValueBuffer(listaCamposL[iL], curRemL.valueBuffer(listaCamposL[iL]));
			}

			curLocL.setValueBuffer("idpedido", idPedidoLoc);

			if (!curLocL.commitBuffer())
				debug(util.translate("scripts",	"Error al importar en la línea de pedido para el pedido " ) + valorClave);
		}


	}
		
	util.destroyProgressDialog();

	return importados;
}


function oficial_exportarTabla(tabla:String, nomTabla:String, tablaGeneral:Boolean)
{
	var util:FLUtil = new FLUtil();

	var curLoc:FLSqlCursor = new FLSqlCursor(tabla);
  	var curRem:FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

	var campoClave:String = curLoc.primaryKey();
	var listaCampos:Array = this.iface.obtenerListaCampos(tabla);

	var valorClave;
	var paso:Number = 0;
	var exportados:Number = 0;
	var eliminados:Number = 0;

	if (this.cursor().valueBuffer("subirtodo"))
	 	curLoc.select();
	else
	 	curLoc.select("modificado = true");

	if (curLoc.size() == 0) 
		return 0;
		
	if (tabla == "clientes")
		curRem.setActivatedCheckIntegrity(false);

	util.createProgressDialog( util.translate( "scripts", "Exportando " ) + nomTabla, curLoc.size());
	util.setProgress(1);

 	while (curLoc.next()) {

		util.setProgress(paso++);

 		valorClave = curLoc.valueBuffer(campoClave);

		curRem.select(campoClave + " = '" + valorClave + "'");

		// Actualizacion (si toca)
		if (curRem.first()) {

			if (this.cursor().valueBuffer("subirtodo")) {
				curRem.setModeAccess(curRem.Edit);
			}
			else {
				if (curLoc.valueBuffer("modificado"))
					curRem.setModeAccess(curRem.Edit);
				else
					continue;
			}

		}
		else {
			curRem.setModeAccess(curRem.Insert);
		}

		curRem.refreshBuffer();

		// Bucle de campos
		for(var i = 0; i < listaCampos.length; i++) {
		
			campo = listaCampos[i];
		
			// excepciones
			if (tabla == "formaspago" && campo == "codcuenta")
				continue;
		
			if ((campo.left(11) == "idsubcuenta" || campo == "idprovincia") && !curLoc.valueBuffer(campo))
				curRem.setNull(campo);
			else			
				curRem.setValueBuffer(campo, curLoc.valueBuffer(campo));
		}

		// OK remoto
		if (curRem.commitBuffer() && !tablaGeneral) {

			// Actualizamos el local como no modificado
			curLoc.setModeAccess(curLoc.Edit);
			curLoc.refreshBuffer();
			curLoc.setValueBuffer("modificado", false);
			if (!curLoc.commitBuffer())
				debug(util.translate("scripts",	"Error al actualizar la tabla local %0 el código/id " ).arg(tabla) + valorClave);

			exportados++;
		}

		// Error
		else {
			debug(util.translate("scripts",	"Error al exportar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
		}

	}

	util.destroyProgressDialog();

	return exportados;
}



function oficial_actualizarPedidos():Number
{
	var util:FLUtil = new FLUtil();

	var tabla:String = "pedidoscli";
	var curLoc:FLSqlCursor = new FLSqlCursor(tabla);
	var curLocMod:FLSqlCursor = new FLSqlCursor(tabla + "_mod");
  	var curRem:FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);

	var campoClave:String = "codigo";
	var listaCampos = new Array("servido","fechasalida");

	var valorClave;
	var paso:Number = 0;
	var exportados:Number = 0;
	var bloqueado:Boolean;

 	curLocMod.select();

	if (curLocMod.size() == 0) 
		return 0;

	util.createProgressDialog( util.translate( "scripts", "Actualizando pedidos" ), curLocMod.size());
	util.setProgress(1);

 	while (curLocMod.next()) {

		util.setProgress(paso++);
 		
 		valorClave = curLocMod.valueBuffer(campoClave);
		debug(valorClave);

	 	curLoc.select(campoClave + " = '" + valorClave + "'");
		curRem.select(campoClave + " = '" + valorClave + "'");

		// Si no existe el pedido en local, se borra la referencia en la tabla de modificados
		if (!curLoc.first()) {
			curLocMod.setModeAccess(curLocMod.Del);
			curLocMod.refreshBuffer();
			curLocMod.commitBuffer();
			continue;
		}

		// Actualizacion (si toca)
		if (!curRem.first()) 
			continue;

		curRem.setModeAccess(curRem.Edit);
		curRem.refreshBuffer();

		// Bucle de campos
		for(var i = 0; i < listaCampos.length; i++) {
			curRem.setValueBuffer(listaCampos[i], curLoc.valueBuffer(listaCampos[i]));
		}

		// OK remoto. Borramos el registro en la tabla de modificados
		if (curRem.commitBuffer()) {
			curLocMod.setModeAccess(curLocMod.Del);
			curLocMod.refreshBuffer();
			curLocMod.commitBuffer();
			exportados++;
		}

		// Error
		else {
			debug(util.translate("scripts",	"Error al exportar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
		}

	}

	util.destroyProgressDialog();

	return exportados;
}

/** \D Elimina los registros en remoto que han sido eliminados en local previamente
*/
function oficial_eliminarObsoletos(tabla:String):Number
{
	var util:FLUtil = new FLUtil();

	var curDel:FLSqlCursor = new FLSqlCursor("registrosdel");
  	var curRem:FLSqlCursor = new FLSqlCursor(tabla, this.iface.conexion);
	var campoClave:String = curRem.primaryKey();
	var eliminados:Number = 0;
	var paso:Number = 0;

	curDel.setForwardOnly(true);
	curDel.select("tabla = '" + tabla + "'");
	util.createProgressDialog( util.translate( "scripts", "Eliminando obsoletos de " ) + tabla, curDel.size());
	var valorClave;
	while(curDel.next()) {

		util.setProgress(paso++);
		valorClave = curDel.valueBuffer("idcampo");
		curRem.select(campoClave + " = '" + valorClave + "'");
		if (curRem.first()) {
			curRem.setModeAccess(curRem.Del);
			curRem.refreshBuffer();
			if (curRem.commitBuffer()) {
				eliminados++;
				curDel.setModeAccess(curDel.Del);
				curDel.refreshBuffer();
				if (!curDel.commitBuffer()) {
					debug(util.translate("scripts",	"Error al eliminar en la tabla de registro eliminados %0 el código/id " ).arg(tabla) + valorClave);
			        }
			}
			else {
				debug(util.translate("scripts",	"Error al eliminar en la tabla remota %0 el código/id " ).arg(tabla) + valorClave);
			}
		}

		// Eliminamos una entrada obsoleta en registrosdel
		else {
			curDel.setModeAccess(curDel.Del);
			curDel.refreshBuffer();
			if (!curDel.commitBuffer()) {
				debug(util.translate("scripts",	"Error al eliminar en la tabla de registro eliminados %0 el código/id " ).arg(tabla) + valorClave);
   		        }
		}

	}
	util.destroyProgressDialog();

	return eliminados;
}

function oficial_obtenerListaCampos(tabla:String):Array
{
	var util:FLUtil = new FLUtil();
	var contenido:String = util.sqlSelect("flfiles", "contenido", "nombre = '" + tabla + ".mtd'");
	
	var xmlContenido = new FLDomDocument();
	xmlContenido.setContent(contenido);
	
	var listaCampos:FLDomNodeList;
	listaCampos= xmlContenido.elementsByTagName("field");
	
	var arrayCampos:Array = [];
	var paso:Number = 0;
	for(var i = 0; i < listaCampos.length(); i++) {
		if (!listaCampos.item(i).namedItem("name")) 
			continue;
		arrayCampos[paso] = listaCampos.item(i).namedItem("name").toElement().text();
		paso++;
	}
	return arrayCampos;
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
