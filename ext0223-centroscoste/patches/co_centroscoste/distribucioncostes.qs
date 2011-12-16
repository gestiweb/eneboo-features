/***************************************************************************
                 distribucioncostes.qs  -  description
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
	var tblCentros:QTable;
	var tblSubcentros:QTable;
	function oficial( context ) { interna( context ); } 
	function reloadCostes(noAviso:Boolean) {
		return this.ctx.oficial_reloadCostes(noAviso); 
	}
	function distribuirCostes() {
		return this.ctx.oficial_distribuirCostes(); 
	}
	function agregarCentro() {
		return this.ctx.oficial_agregarCentro(); 
	}
	function agregarSubcentro() {
		return this.ctx.oficial_agregarSubcentro(); 
	}
	function borrarCentro() {
		return this.ctx.oficial_borrarCentro(); 
	}
	function borrarTodosCentro() {
		return this.ctx.oficial_borrarTodosCentro(); 
	}
	function changedPor(fil:Number, col:Number) {
		return this.ctx.oficial_changedPor(fil, col); 
	}
	function calculoPorcentajeReparto() {
		return this.ctx.oficial_calculoPorcentajeReparto(); 
	}
	function calculoTotalReparto() {
		return this.ctx.oficial_calculoTotalReparto(); 
	}
	function cargarLineas() {
		return this.ctx.oficial_cargarLineas(); 
	}
	function guardarLineas() {
		return this.ctx.oficial_guardarLineas(); 
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
	this.iface.tblCentros = this.child("tblCentros");
	connect(this.child("pbnInsertC"), "clicked()", this, "iface.agregarCentro");
	connect(this.child("pbnInsertSC"), "clicked()", this, "iface.agregarSubcentro");
	connect(this.child("pbnDeleteRow"), "clicked()", this, "iface.borrarCentro");
	connect(this.child("pbnDeleteAll"), "clicked()", this, "iface.borrarTodosCentro");
	
	connect(this.child("pbnReloadCostes"), "clicked()", this, "iface.reloadCostes()");
	connect(this.child("pbnDistribuirCostes"), "clicked()", this, "iface.distribuirCostes()");
 	
 	connect(this.iface.tblCentros, "valueChanged(int,int)", this, "iface.changedPor");

	this.iface.tblCentros.setColumnReadOnly(0, true);
	this.iface.tblCentros.setColumnReadOnly(1, true);
	this.iface.tblCentros.setColumnReadOnly(2, true);
	this.iface.tblCentros.setColumnReadOnly(3, true);
	this.iface.tblCentros.setColumnReadOnly(4, true);
	
	this.child("fdbPorcentajeReparto").setDisabled(true);
	this.child("fdbTotalReparto").setDisabled(true);
	this.child("fdbCosteTotalRep").setDisabled(true);
	
	if (this.cursor().modeAccess() == this.cursor().Edit) {
		this.iface.cargarLineas();
		if (this.cursor().valueBuffer("estado") == "Completado") {
			this.child("gbxCentros").setDisabled(true);
			this.child("gbxFechas").setDisabled(true);
		}
	}
		
	if (this.iface.tblCentros.numRows())
		this.child("gbxCentro").setDisabled(true);
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_agregarCentro():Boolean
{
	var util:FLUtil = new FLUtil();
	
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		MessageBox.information( util.translate( "scripts", "Debe guardar el formulario y a continuación repetir el proceso" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}

	var cursor:FLSqlCursor = this.cursor();
	var codCentroOri:String = cursor.valueBuffer("codcentro");
	
	if (!codCentroOri) {
		MessageBox.information( util.translate( "scripts", "Debe especificar al menos el centro de coste e origen" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	
	var listaCentros:String = "'" + codCentroOri + "'";
	var filtro:String = "";


	for (c = 0; c < this.iface.tblCentros.numRows(); c++) {
		listaCentros += ",";
		listaCentros += "'" + this.iface.tblCentros.text(c, 0) + "'";
	}
	
	if (listaCentros)
		filtro = "codcentro NOT IN (" + listaCentros + ")";
	
	var f:Object = new FLFormSearchDB("co_i_seleccioncentroscoste");
	var curCentros:FLSqlCursor = f.cursor();

	if (cursor.modeAccess() != cursor.Browse)
		if (!cursor.checkIntegrity())
			return;

	curCentros.select();
	if (!curCentros.first())
		curCentros.setModeAccess(curCentros.Insert);
	else
		curCentros.setModeAccess(curCentros.Edit);
		
	f.setMainWidget();
	curCentros.refreshBuffer();
	curCentros.setValueBuffer("datos", "");
	curCentros.setValueBuffer("filtro", filtro);

	var ret = f.exec( "datos" );

	if ( !f.accepted() )
		return false;

	var datos:String = new String( ret );

	if ( datos.isEmpty() ) 
		return false;

	var regExp:RegExp = new RegExp( "'" );
	regExp.global = true;
	datos = datos.replace( regExp, "" );

	var centros:Array = datos.split(",");
	
	fila = 0;
	
	util.createProgressDialog( util.translate( "scripts", "Actualizando centros" ), centros.length );
	for (var i:Number = 0; i < centros.length; i++) {	
		codCentro = centros[i];	
		util.setProgress(fila + 1);
		nomCentro = util.sqlSelect("centroscoste", "descripcion", "codcentro = '" + codCentro + "'");
		this.iface.tblCentros.insertRows(fila, 1);
		this.iface.tblCentros.setText(fila, 0, codCentro);
		this.iface.tblCentros.setText(fila, 1, nomCentro);
		this.iface.tblCentros.setText(fila, 3, util.translate( "scripts", "TODOS" ));
		fila++;
	}
	util.destroyProgressDialog();

	if (!this.iface.tblCentros.numRows())
		this.iface.reloadCostes(true);
	else
		this.iface.guardarLineas();

	this.child("gbxCentro").setDisabled(true);
}

function oficial_agregarSubcentro():Boolean
{
	var util:FLUtil = new FLUtil();
	
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		MessageBox.information( util.translate( "scripts", "Debe guardar el formulario y a continuación repetir el proceso" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}

	var cursor:FLSqlCursor = this.cursor();
	var codCentroOri:String = cursor.valueBuffer("codcentro");
	var codSubcentroOri:String = cursor.valueBuffer("codsubcentro");
	
	if (!codCentroOri) {
		MessageBox.information( util.translate( "scripts", "Debe especificar al menos el centro de coste e origen" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	
	var filtro:String = "1 = 1";
	
	// Excluir subcentros ya seleccionados
	var listaSubcentros:String;
	if (codSubcentroOri)
	listaSubcentros = "'" + codSubcentroOri + "'";
	for (c = 0; c < this.iface.tblCentros.numRows(); c++) {
		if (listaSubcentros)
			listaSubcentros += ",";
		listaSubcentros += "'" + this.iface.tblCentros.text(c, 2) + "'";
	}
	
	if (listaSubcentros)
		filtro += " AND codsubcentro NOT IN (" + listaSubcentros + ")";
	
	
	// Excluir subcentros de centros completos ya seleccionados
	var listaCentros:String = "";
	if (codCentroOri && !codSubcentroOri)
	listaCentros = "'" + codCentroOri + "'";
	for (c = 0; c < this.iface.tblCentros.numRows(); c++) {
		if (this.iface.tblCentros.text(c, 2))
			continue;
		if (listaCentros)
			listaCentros += ",";
		listaCentros += "'" + this.iface.tblCentros.text(c, 0) + "'";
	}
	
	if (listaCentros)
		filtro += " AND codcentro NOT IN (" + listaCentros + ")";
	
	
	var f:Object = new FLFormSearchDB("co_i_seleccionsubcentroscoste");
	var curSubcentros:FLSqlCursor = f.cursor();

	if (cursor.modeAccess() != cursor.Browse)
		if (!cursor.checkIntegrity())
			return;

	curSubcentros.select();
	if (!curSubcentros.first())
		curSubcentros.setModeAccess(curSubcentros.Insert);
	else
		curSubcentros.setModeAccess(curSubcentros.Edit);
		
	f.setMainWidget();
	curSubcentros.refreshBuffer();
	curSubcentros.setValueBuffer("datos", "");
	curSubcentros.setValueBuffer("filtro", filtro);

	var ret = f.exec( "datos" );

	if ( !f.accepted() )
		return false;

	var datos:String = new String( ret );

	if ( datos.isEmpty() ) 
		return false;

	var regExp:RegExp = new RegExp( "'" );
	regExp.global = true;
	datos = datos.replace( regExp, "" );

	var centros:Array = datos.split(",");
	
	fila = 0;
	
	util.createProgressDialog( util.translate( "scripts", "Actualizando centros" ), centros.length );
	for (var i:Number = 0; i < centros.length; i++) {	
		codSubcentro = centros[i];	
		util.setProgress(fila + 1);
		
		datosSubcentro = flfactppal.iface.pub_ejecutarQry("subcentroscoste", "codsubcentro,descripcion,codcentro", "codsubcentro = '" + codSubcentro + "'");
		
		nomCentro = util.sqlSelect("centroscoste", "descripcion", "codcentro = '" + datosSubcentro.codcentro + "'");
		this.iface.tblCentros.insertRows(fila, 1);
		this.iface.tblCentros.setText(fila, 0, datosSubcentro.codcentro);
		this.iface.tblCentros.setText(fila, 1, nomCentro);
		this.iface.tblCentros.setText(fila, 2, datosSubcentro.codsubcentro);
		this.iface.tblCentros.setText(fila, 3, datosSubcentro.descripcion);
		fila++;
	}
	util.destroyProgressDialog();

	if (!this.iface.tblCentros.numRows())
		this.iface.reloadCostes(true);
	else
		this.iface.guardarLineas();
		
	this.child("gbxCentro").setDisabled(true);
}

function oficial_reloadCostes(noAviso:Boolean)
{
	var util:FLUtil = new FLUtil();
	
	if (this.iface.tblCentros.numRows() == 0) {
		MessageBox.information( util.translate( "scripts", "No se han especificado centros de destino" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}

	if (!noAviso) {
		var res = MessageBox.warning( util.translate( "scripts", "A continuación se recargarán los datos de reparto\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
		if ( res != MessageBox.Yes )
			return;
	}

	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var codCentroOri:String = cursor.valueBuffer("codcentro");
	var codSubCentroOri:String = cursor.valueBuffer("codsubcentro");
	var listaCentros:String = "";
	var listaSubcentros:String = "";
	
	var filtro:String = "";

	for (c = 0; c < this.iface.tblCentros.numRows(); c++) {
		if (c > 0)
			listaCentros += ",";
		listaCentros += this.iface.tblCentros.text(c, 0);
		if (c > 0)
			listaSubcentros += ",";
		listaSubcentros += this.iface.tblCentros.text(c, 2);
	}

	var where:String = " a.fecha >= '" + cursor.valueBuffer("fechainicio") + "' and a.fecha <= '" + cursor.valueBuffer("fechafin") + "'";
	where += " AND (p.codsubcuenta like '6%' OR p.codsubcuenta like '8%')";
	where += " AND a.codejercicio = '" + flfactppal.iface.pub_ejercicioActual() + "'";
	
	var centros:Array = listaCentros.split(",");
	var subcentros:Array = listaSubcentros.split(",");
	var costeCentro:Number, porCosteCentroRep:Number, costeCentroRep:Number;
	
	fila = 0;
	
	var	costeTotalAcum:Number = 0;
	
	var whereRep:String =  where + " AND pcc.codcentro = '" + codCentroOri + "'";
	var whereSC:String;
	if (codSubCentroOri)
		whereRep += " AND pcc.codsubcentro = '" + codSubCentroOri + "'";
		
	debug(whereRep);

	var	costeTotalRep:Number = util.sqlSelect("co_partidascc pcc inner join co_partidas p on pcc.idpartida = p.idpartida inner join co_asientos a on p.idasiento = a.idasiento", "sum(pcc.importe)", whereRep, "co_partidascc,co_partidas,co_asientos");
	
	if (!costeTotalRep)
		costeTotalRep = 0;

	cursor.setValueBuffer("costetotalrep", costeTotalRep);
	
	util.createProgressDialog( util.translate( "scripts", "Calculado costes" ), centros.length );
	for (var i:Number = 0; i < centros.length; i++) {	
		
		util.setProgress(fila + 1);
		
		codCentro = centros[i];	
		codSubcentro = subcentros[i];
		whereSC = "";
		if (codSubcentro)
			whereSC = " AND pcc.codsubcentro = '" + codSubcentro + "'";
		
		costeCentroAcum = util.sqlSelect("co_partidascc pcc inner join co_partidas p on pcc.idpartida = p.idpartida inner join co_asientos a on p.idasiento = a.idasiento", "sum(pcc.importe)", "pcc.codcentro = '" + codCentro + "'" + whereSC + " AND " + where, "co_partidascc,co_partidas,co_asientos");
		if (!costeCentroAcum)
			costeCentroAcum = 0;
		costeTotalAcum += parseFloat(costeCentroAcum);
	}
	
	util.destroyProgressDialog();
	
	
	util.createProgressDialog( util.translate( "scripts", "Actualizando centros" ), centros.length );
	for (var i:Number = 0; i < centros.length; i++) {
		
		util.setProgress(fila + 1);
		
		codCentro = centros[i];	
		codSubcentro = subcentros[i];
		whereSC = "";
		if (codSubcentro)
			whereSC = " AND pcc.codsubcentro = '" + codSubcentro + "'";
		
		costeCentroAcum = util.sqlSelect("co_partidascc pcc inner join co_partidas p on pcc.idpartida = p.idpartida inner join co_asientos a on p.idasiento = a.idasiento", "sum(pcc.importe)", "pcc.codcentro = '" + codCentro + "'" + whereSC + " AND " + where, "co_partidascc,co_partidas,co_asientos");
		if (!costeCentroAcum)
			costeCentroAcum = 0;
			
		if (costeTotalAcum) {
			porCosteCentroRep = 100 * parseFloat(costeCentroAcum) / parseFloat(costeTotalAcum);
			porCosteCentroRep = util.buildNumber(porCosteCentroRep, "f", 3);
			costeCentroRep = parseFloat(porCosteCentroRep) * parseFloat(costeTotalRep) / 100;
			costeCentroRep = util.buildNumber(costeCentroRep, "f", 3);
		}
		else {
			porCosteCentroRep = 0;
			costeCentroRep = 0;
		}
		
		this.iface.tblCentros.setText(fila, 4, costeCentroAcum);
		this.iface.tblCentros.setText(fila, 5, porCosteCentroRep);
		this.iface.tblCentros.setText(fila, 6, costeCentroRep);
		
		fila++;
	}
	util.destroyProgressDialog();
	
	this.iface.calculoPorcentajeReparto();
	
	this.child("gbxCentro").setDisabled(true);
	this.child("gbxFechas").setDisabled(true);
}

function oficial_distribuirCostes()
{
	var util:FLUtil = new FLUtil();
	
	var cursor:FLSqlCursor = this.cursor();
	if (!cursor.valueBuffer("costetotalrep")) {
		MessageBox.information( util.translate( "scripts", "El centro/subcentro de origen no tienen costes a repartir" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	
	var codCentroOri:String = cursor.valueBuffer("codcentro");
	var codSubcentroOri:String = cursor.valueBuffer("codsubcentro");
	
	if (!util.sqlSelect("centroscoste", "codcentro", "codcentro = '" + codCentroOri + "'")) {
		MessageBox.information( util.translate( "scripts", "El centro de coste de origen no es válido" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	
	if (codSubcentroOri && !util.sqlSelect("subcentroscoste", "codsubcentro", "codsubcentro = '" + codSubcentroOri + "'")) {
		MessageBox.information( util.translate( "scripts", "El subcentro de coste de origen no es válido" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	
	if (this.iface.tblCentros.numRows() == 0) {
		MessageBox.information( util.translate( "scripts", "No se han especificado centros de destino" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}

	if (parseFloat(cursor.valueBuffer("costetotalrep")) < parseFloat(cursor.valueBuffer("totalreparto"))) {
		MessageBox.information( util.translate( "scripts", "El total a distribuir no puede exeder el máximo a distribuir" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	
	var res = MessageBox.warning( util.translate( "scripts", "A continuación se realizará el reparto de costes. Esta acción no puede deshacerse\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes )
		return;


	var porcentajesReparto:Array = [];
	var numCentros:Number = 0;
	for (c = 0; c < this.iface.tblCentros.numRows(); c++) {
		if (!this.iface.tblCentros.text(c, 3))
			continue;
			
		porcentajesReparto[numCentros] = new Array(3);
		porcentajesReparto[numCentros]["codcentro"] = this.iface.tblCentros.text(c, 0);
		porcentajesReparto[numCentros]["codsubcentro"] = this.iface.tblCentros.text(c, 2);
		porcentajesReparto[numCentros]["porcentaje"] = this.iface.tblCentros.text(c, 5);
		
		numCentros++;
	}
	
	if (!numCentros) {
		MessageBox.information( util.translate( "scripts", "Debe haber al menos un porcentaje positivo" ), MessageBox.Ok, MessageBox.NoButton );
		return;
	}
	
	var q:FLSqlQuery = new FLSqlQuery();
	
	var where:String = " a.fecha >= '" + cursor.valueBuffer("fechainicio") + "' and a.fecha <= '" + cursor.valueBuffer("fechafin") + "'";
	where += " AND (p.codsubcuenta like '6%' OR p.codsubcuenta like '8%')";
	where += " AND a.codejercicio = '" + flfactppal.iface.pub_ejercicioActual() + "'";
	where += " AND pcc.codcentro = '" + codCentroOri + "'";
	if (codSubcentroOri)
		where += " AND pcc.codsubcentro = '" + codSubcentroOri + "'";
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("co_partidascc,co_partidas,co_asientos");
	q.setFrom("co_partidascc pcc inner join co_partidas p on pcc.idpartida = p.idpartida inner join co_asientos a on p.idasiento = a.idasiento");
	q.setSelect("pcc.idpartidacc,pcc.importe,pcc.idpartida");
	q.setWhere(where);
	
	debug(q.sql());
	
	if (!q.exec())
		return;
	
	var curTab:FLSqlCursor = new FLSqlCursor("co_partidascc");
	var idPartida:Number;
	var importe:Number;
	var codCentro:String, codSubcentro:String;
	
	while(q.next()) {
	
		importe = q.value(1);
		idPartida = q.value(2);
	
		debug("Partida " + q.value(0));
		debug("Importe " + q.value(1));
		
		for(i = 0; i < porcentajesReparto.length; i++) {
		
			codCentro = porcentajesReparto[i]["codcentro"];
			codSubcentro = porcentajesReparto[i]["codsubcentro"];
			valor = importe * porcentajesReparto[i]["porcentaje"] / 100;
			debug(codCentro + " " + valor);
			
			curTab.select("idpartida = " + idPartida + " AND codcentro = '" + codCentro + "' AND codsubcentro = '" + codSubcentro + "'" );
			if (curTab.first()) {
				curTab.setModeAccess(curTab.Edit);
				curTab.refreshBuffer();
				curTab.setValueBuffer("importe", parseFloat(curTab.valueBuffer("importe")) + parseFloat(valor));
				curTab.commitBuffer();
			}
			else {
				curTab.setModeAccess(curTab.Insert);
				curTab.refreshBuffer();
				curTab.setValueBuffer("idpartida", idPartida);
				curTab.setValueBuffer("codcentro", codCentro);
				curTab.setValueBuffer("codsubcentro", codSubcentro);
				curTab.setValueBuffer("importe", parseFloat(valor));
				curTab.commitBuffer();
			}
		
			// Restar importe de origen. Si el resultado es cero, se borra la linea
			curTab.select("idpartidacc = " + q.value(0));
			if (curTab.first()) {
				nuevoImporte = parseFloat(curTab.valueBuffer("importe")) - parseFloat(valor);
				debug("NI " + nuevoImporte);
				if (nuevoImporte) {
					curTab.setModeAccess(curTab.Edit);
					curTab.refreshBuffer();
					curTab.setValueBuffer("importe", nuevoImporte);
				}
				else {
					curTab.setModeAccess(curTab.Del);
					curTab.refreshBuffer();
				}
				curTab.commitBuffer();
			}
		}
	}
		
	this.iface.guardarLineas();
	cursor.setValueBuffer("estado", "Completado");
	this.child("gbxCentros").setDisabled(true);
	this.child("gbxFechas").setDisabled(true);
	
	MessageBox.information( util.translate( "scripts", "Se completó el reparto de costes. Debe aceptar el formulario para que los cambios tengan efecto" ), MessageBox.Ok, MessageBox.NoButton );
}


function oficial_borrarCentro():Boolean
{
	var fila:Number = this.iface.tblCentros.currentRow();
	if (fila != 0 && !fila)
		return;
		
	this.iface.tblCentros.removeRow(fila);
	
	if (this.iface.tblCentros.numRows())
		this.iface.tblCentros.selectRow(fila);		

	this.iface.calculoPorcentajeReparto();
	
	if (!this.iface.tblCentros.numRows()) {
		this.child("gbxCentro").setDisabled(false);
		this.child("gbxFechas").setDisabled(false);
	}
}

function oficial_borrarTodosCentro():Boolean
{
	var util:FLUtil = new FLUtil();
	
	if (!this.iface.tblCentros.numRows())
		return;
	
	var res = MessageBox.warning( util.translate( "scripts", "Se quitarán todos los centros\n\n¿Continuar?" ), MessageBox.No, MessageBox.Yes, MessageBox.NoButton );
	if ( res != MessageBox.Yes )
		return;
	
	var numRows:Number = this.iface.tblCentros.numRows();
	for (c = 0; c < numRows; c++)
		this.iface.tblCentros.removeRow(0);

	this.iface.calculoPorcentajeReparto();
	
	this.child("gbxCentro").setDisabled(false);
	this.child("gbxFechas").setDisabled(false);
}

function oficial_changedPor(fil:Number, col:Number)
{
	var util:FLUtil = new FLUtil();
	
	switch(col) {
		case 5:
			costeCentroRep = parseFloat(this.iface.tblCentros.text(fil, 5)) * parseFloat(this.cursor().valueBuffer("costetotalrep")) / 100;
			if (!costeCentroRep)
				costeCentroRep = 0;
			costeCentroRep = util.buildNumber(costeCentroRep, "f", 3);
			this.iface.tblCentros.setText(fil, 6, costeCentroRep);
			this.iface.calculoPorcentajeReparto();
		break;
		case 6:
			porCosteCentroRep = parseFloat(this.iface.tblCentros.text(fil, 6)) / parseFloat(this.cursor().valueBuffer("costetotalrep")) * 100;
			if (!porCosteCentroRep)
				porCosteCentroRep = 0;
			porCosteCentroRep = util.buildNumber(porCosteCentroRep, "f", 3);
			this.iface.tblCentros.setText(fil, 5, porCosteCentroRep);
			this.iface.calculoTotalReparto();
		break;
	}
}

function oficial_calculoPorcentajeReparto()
{
	var porcentaje:Number = 0;

	for (c = 0; c < this.iface.tblCentros.numRows(); c++)
		porcentaje += parseFloat(this.iface.tblCentros.text(c, 5));

	this.cursor().setValueBuffer("porcentajereparto", porcentaje);
	this.iface.calculoTotalReparto();
	
	this.iface.guardarLineas();
}

function oficial_calculoTotalReparto()
{
	var total:Number = 0;

	for (c = 0; c < this.iface.tblCentros.numRows(); c++)
		total += parseFloat(this.iface.tblCentros.text(c, 6));

	this.cursor().setValueBuffer("totalreparto", total);
}

function oficial_guardarLineas()
{
	var util:FLUtil = new FLUtil();
	var idDist:Number = this.cursor().valueBuffer("id");
	var curTab:FLSqlCursor = new FLSqlCursor("lineasdistribucioncostes");
	
	util.sqlDelete("lineasdistribucioncostes", "iddistribucion = " + idDist);
	
	for (c = 0; c < this.iface.tblCentros.numRows(); c++) {
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("iddistribucion", idDist);
		curTab.setValueBuffer("codcentro", this.iface.tblCentros.text(c, 0));
		curTab.setValueBuffer("descripcioncentro", this.iface.tblCentros.text(c, 1));
		curTab.setValueBuffer("codsubcentro", this.iface.tblCentros.text(c, 2));
		curTab.setValueBuffer("descripcionsubcentro", this.iface.tblCentros.text(c, 3));
		curTab.setValueBuffer("costeacumulado", this.iface.tblCentros.text(c, 4));
		curTab.setValueBuffer("pordistribucioncoste", this.iface.tblCentros.text(c, 5));
		curTab.setValueBuffer("distribucioncoste", this.iface.tblCentros.text(c, 6));
		curTab.commitBuffer();
	}
}

function oficial_cargarLineas()
{
	var idDist:Number = this.cursor().valueBuffer("id");
	var curTab:FLSqlCursor = new FLSqlCursor("lineasdistribucioncostes");
	var fila:Number = 0;
	
	curTab.select("iddistribucion = " + idDist);
	while(curTab.next()) {
		this.iface.tblCentros.insertRows(fila, 1);
		this.iface.tblCentros.setText(fila, 0, curTab.valueBuffer("codcentro"));
		this.iface.tblCentros.setText(fila, 1, curTab.valueBuffer("descripcioncentro"));
		this.iface.tblCentros.setText(fila, 2, curTab.valueBuffer("codsubcentro"));
		this.iface.tblCentros.setText(fila, 3, curTab.valueBuffer("descripcionsubcentro"));
		this.iface.tblCentros.setText(fila, 4, curTab.valueBuffer("costeacumulado"));
		this.iface.tblCentros.setText(fila, 5, curTab.valueBuffer("pordistribucioncoste"));
		this.iface.tblCentros.setText(fila, 6, curTab.valueBuffer("distribucioncoste"));
		fila++;
	}
}



//// OFICIAL /////////////////////////////////
//////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
////////////////////////////////////////////////////////////