
/***************************************************************************
                 co_traspasoejer.qs  -  description
                             -------------------
    begin                : jue may 17 2007
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
    function validateForm() { return this.ctx.interna_validateForm(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	var cambioPGC:Boolean;
    function oficial( context ) { interna( context ); } 
	function traspaso() {
		return this.ctx.oficial_traspaso() 
	}
    function ejercicioVacio() {
    	return this.ctx.oficial_ejercicioVacio();
    }
    function compatibilidadPlanes():Boolean {
    	return this.ctx.oficial_compatibilidadPlanes();
    }
    function comprobarSaldosHuerfanos():Boolean {
    	return this.ctx.oficial_comprobarSaldosHuerfanos();
    }    
    function traspasoSecuencias() {
    	return this.ctx.oficial_traspasoSecuencias();
    }
	function actualizarSaldos() {
		return this.ctx.oficial_actualizarSaldos();
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
	connect(this.child("pbnTraspaso"), "clicked()", this, "iface.traspaso");
}

function interna_validateForm():Boolean
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicioOri:String = this.child("fdbCodEjercicioOri").value();
	var codEjercicioDes:String = this.child("fdbCodEjercicioDes").value();
	
	if (!util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicioOri + "'")) {
		MessageBox.warning(util.translate("scripts", 
				"No existe el ejercicio origen"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
		
	if (!util.sqlSelect("ejercicios", "codejercicio", "codejercicio = '" + codEjercicioDes + "'")) {
		MessageBox.warning(util.translate("scripts", 
				"No existe el ejercicio destino"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
		
	var datosOri:Array = flfactppal.iface.ejecutarQry("ejercicios", "fechainicio,fechafin,longsubcuenta", "codejercicio = '" + codEjercicioOri + "'");
	if (datosOri.result < 1) {
		MessageBox.warning(util.translate("scripts", 
				"El ejercicio origen no es válido"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
		
	var datosDes:Array = flfactppal.iface.ejecutarQry("ejercicios", "fechainicio,fechafin,longsubcuenta", "codejercicio = '" + codEjercicioDes + "'");
	if (datosDes.result < 1) {
		MessageBox.warning(util.translate("scripts", 
				"El ejercicio destino no es válido"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
		
	if (datosOri.fechainicio != datosDes.fechainicio || datosOri.fechafin != datosDes.fechafin) {
		MessageBox.warning(util.translate("scripts", 
				"Las fechas de inicio y fin de ambos ejercicios deben ser iguales"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
				
	return true;
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_traspaso()
{
	this.iface.cambioPGC = false;

	if (!this.iface.validateForm())
		return;

	if (!this.iface.ejercicioVacio())
		return;
		
	var util:FLUtil = new FLUtil();
	
	// Comprobación si hay PGC 08
    if (util.sqlSelect("flfiles", "nombre", "nombre = 'co_gruposepigrafes.mtd'"))
		if (!this.iface.compatibilidadPlanes())
			return;

	var util:FLUtil = new FLUtil();
	
	var codEjercicioOri:String = this.child("fdbCodEjercicioOri").value();
	var codEjercicioDes:String = this.child("fdbCodEjercicioDes").value();
	
	var curTab:FLSqlCursor;
	var tabla:String, codigo:String, idAsiento:Number, codSubcuenta:String;
	var paso:Number;
	
	// 1. Facturación
	tablas = [ "presupuestoscli", "pedidoscli", "albaranescli", "facturascli", "pedidosprov", "albaranesprov", "facturasprov" ];
    for ( i = 0; i < tablas.length; i++ ) {
        
        tabla = tablas[i];
        if (!util.sqlSelect("flfiles", "nombre", "nombre = '" + tabla + ".mtd'"))
        	continue;
        	
        debug(tabla);
        
        campoLock = "editable";
        if (tabla == "albaranescli" || tabla == "albaranesprov")
	        campoLock = "ptefactura";
			        
        curTab = new FLSqlCursor(tabla);
		curTab.setActivatedCommitActions(false);
		
		curTab.select("codejercicio = '" + codEjercicioOri + "'");
		
        campoClave = curTab.primaryKey();
        	
		util.createProgressDialog( util.translate( "scripts", "Traspasando " ) + tabla, curTab.size() );
		paso = 0;
		
		while(curTab.next()) {
		
			util.setProgress(paso++);
			
			var id:Number = curTab.valueBuffer(campoClave);
			var locked:Boolean = curTab.isLocked();
			var cur:FLSqlCursor = new FLSqlCursor(tabla);
	
			cur.setActivatedCommitActions( false );
			cur.select(campoClave  + "=" + id);
			if (locked) {
					if (cur.first())
							cur.setUnLock(campoLock, true);
			}
	
			cur.select(campoClave  + "=" + id);
			cur.setModeAccess(cur.Edit);
			if (cur.first()) {
			
				codigo = cur.valueBuffer("codigo");
				codigo = codigo.toString().right(codigo.length - 4);
				codigo = codEjercicioDes + codigo;
			
				cur.setValueBuffer("codejercicio", codEjercicioDes);
				cur.setValueBuffer("codigo", codigo);
				if (!cur.commitBuffer()) {
						rollback = true;
						break;
				}
			
				cur.select(campoClave  + "=" + id);
				if (locked) {
						if (cur.first())
								cur.setUnLock(campoLock, false);
				}
			}
		}		
        
		util.destroyProgressDialog();
    }

	
	// 2. Tesorería
	tablas = [ "reciboscli", "recibosprov" ];
    for ( i = 0; i < tablas.length; i++ ) {
        
        tabla = tablas[i];
        if (!util.sqlSelect("flfiles", "nombre", "nombre = '" + tabla + ".mtd'"))
        	continue;
        	
        debug(tabla);
        	
        curTab = new FLSqlCursor(tabla);
		curTab.setActivatedCommitActions(false);
		
		curTab.select();
		
		util.createProgressDialog( util.translate( "scripts", "Traspasando " ) + tabla, curTab.size() );
		paso = 0;
		
		while(curTab.next()) {
		
			util.setProgress(paso++);
			
			debug(tabla + " " + paso);
			
			codigo = curTab.valueBuffer("codigo");
			
			codEjercicio = codigo.toString().left(4);
			if (codEjercicio != codEjercicioOri)
				continue;
			
			codigo = codigo.toString().right(codigo.length - 4);
			codigo = codEjercicioDes + codigo;
			
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
			curTab.setValueBuffer("codigo", codigo);
  			curTab.commitBuffer();
		}		
        
		util.destroyProgressDialog();
    }

	
	
	// 2. Asientos y partidas
	tablas = [ "co_asientos" ];
    for ( i = 0; i < tablas.length; i++ ) {
        
        tabla = tablas[i];
        if (!util.sqlSelect("flfiles", "nombre", "nombre = '" + tabla + ".mtd'"))
        	continue;
        	
        debug(tabla);
        	
        curTab = new FLSqlCursor(tabla);
		curTab.setActivatedCommitActions(false);
		
        curTabP = new FLSqlCursor("co_partidas");
		curTabP.setActivatedCommitActions(false);
		
		curTab.select("codejercicio = '" + codEjercicioOri + "'");
		
		util.createProgressDialog( util.translate( "scripts", "Traspasando " ) + tabla, curTab.size() );
		paso = 0;
		
		while(curTab.next()) {
		
			util.setProgress(paso++);
			
			var idAsiento:Number = curTab.valueBuffer("idasiento");
			var locked:Boolean = curTab.isLocked();
			var cur:FLSqlCursor = new FLSqlCursor("co_asientos");
	
			cur.setActivatedCommitActions( false );
			cur.select("idasiento = " + idAsiento);
			if (locked) {
					if (cur.first())
							cur.setUnLock("editable", true);
			}
	
			cur.select("idasiento = " + idAsiento);
			cur.setModeAccess(cur.Edit);
			if (cur.first()) {
			
			
				curTabP.select("idasiento = " + idAsiento);
				while(curTabP.next()) {
				
					codSubcuenta = curTabP.valueBuffer("codsubcuenta");
					
					debug("subcuenta " + codSubcuenta);
					
					// Cambio de PGC?
					if (this.iface.cambioPGC)
						codSubcuenta = flcontppal.iface.convertirCodSubcuenta(codEjercicioOri, codSubcuenta);
								
					idSubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicioDes + "'");
					
					if (!idSubcuenta) {
						debug("Error al actualizar la idsubcuenta para la partida " + curTabP.valueBuffer("idpartida"));
						continue;
					}
				
					curTabP.setModeAccess(curTabP.Edit);
					curTabP.refreshBuffer();
					curTabP.setValueBuffer("idsubcuenta", idSubcuenta);
					curTabP.setValueBuffer("codsubcuenta", codSubcuenta);
					curTabP.commitBuffer();
				}
			
				cur.setValueBuffer("codejercicio", codEjercicioDes);
				if (!cur.commitBuffer()) {
						rollback = true;
						break;
				}
			
				cur.select("idasiento = " + idAsiento);
				if (locked) {
						if (cur.first())
								cur.setUnLock("editable", false);
				}
			}
	
		}        
		util.destroyProgressDialog();
    }
	
	this.iface.actualizarSaldos();
	this.iface.traspasoSecuencias();
	
	MessageBox.information ( util.translate( "scripts", "Proceso finalizado.\n\nPara guardar los cambios debe aceptar el formulario\nSi cancela el formulario se cancelará el traspaso"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_subcuentaEq(codSubcuenta:String, codEjercicioOri:String, codEjercicioDes:String):Number
{
	var util:FLUtil = new FLUtil();
	var idSubcuentaDes:Number;
	
	debug("de " + codSubcuenta + " a " + flcontppal.iface.convertirCodSubcuenta(codEjercicioOri, codSubcuenta));
	
    	
    return idSubcuentaDes;
}

function oficial_traspasoSecuencias()
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicioOri:String = this.child("fdbCodEjercicioOri").value();
	var codEjercicioDes:String = this.child("fdbCodEjercicioDes").value();
	
	util.sqlDelete("secuenciasejercicios", "codejercicio = '" + codEjercicioDes + "'");
 	util.sqlUpdate("secuenciasejercicios", "codejercicio", codEjercicioDes, "codejercicio = '" + codEjercicioOri + "'");
	
	
	var numAsientoOri:Number = util.sqlSelect("co_secuencias", "valorout", "codejercicio = '" + codEjercicioDes + "'")
	
	util.sqlUpdate("co_secuencias", "valorout", numAsientoOri, "codejercicio = '" + codEjercicioDes + "'");
	util.sqlUpdate("co_secuencias", "valorout", 1, "codejercicio = '" + codEjercicioOri + "'");
}


function oficial_ejercicioVacio():Boolean
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicioDes:String = this.child("fdbCodEjercicioDes").value();
	var vacio:Boolean = true;
	
	tablas = [  "presupuestoscli", "pedidoscli",	"albaranescli",	"facturascli",
				"pedidosprov", "albaranesprov", "facturasprov",
				"co_asientos" ];
    
    for ( i = 0; i < tablas.length; i++ ) {
    	
    	tabla = tablas[i];
        if (util.sqlSelect(tabla, "count(codejercicio)", "codejercicio = '" + codEjercicioDes + "'")) {
        	vacio = false;
        	break;
        }
	}
	
	if (!vacio) {
		MessageBox.warning(util.translate("scripts", 
				"El ejercicio destino ha de estar vacío en facturación y contabilidad"),
				MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	
	return true;
}


function oficial_compatibilidadPlanes():Boolean
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicioOri:String = this.child("fdbCodEjercicioOri").value();
	var codEjercicioDes:String = this.child("fdbCodEjercicioDes").value();
	
	var planContableDes:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicioDes + "'");
	var planContableOri:String = util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicioOri + "'");
	
	// Si se pasa del 90 al 08 hay que comprobar cuentas huérfanas
	if (planContableDes == "08" && planContableOri != "08") {
		if (!this.iface.comprobarSaldosHuerfanos())
			return false;
		this.iface.cambioPGC = true;
	}
	
	// No se puede pasar del 08 al 90
	if (planContableDes != "08" && planContableOri == "08") {
		MessageBox.information(util.translate("scripts", "No es posible traspasar de un ejercicio con PGC 90 a uno con PGC 08"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

/** Si cambiamos de un PGC 90 a uno 08 hay que comprobar saldos huérfanos
*/
function oficial_comprobarSaldosHuerfanos():Boolean
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	var codEjercicio:String = this.child("fdbCodEjercicioOri").value();
	
	var datos:Array = flcontppal.iface.datosCuentasHuerfanas();
	var saldos:String = "";
	var saldo:Number;
			
	util.createProgressDialog(util.translate("scripts", "Comprobando cuentas"), datos.length);
	
	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		
		// ¿Hay correspondencia?
		if (util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + datos[i][0] + "'"))
			continue;
		
		with(curCbl) {
		
			select("codcuenta = '" + datos[i][0] + "' and codejercicio = '" + codEjercicio + "'");
			while (next()) {
				setModeAccess(curCbl.Browse);
				refreshBuffer();
				
				saldo = curCbl.valueBuffer("saldo");
				if (parseFloat(saldo))
					saldos += "\n" + curCbl.valueBuffer("codsubcuenta") + " - " + util.buildNumber(saldo, "f", 2);
			}
				
		}
	}
	
	util.destroyProgressDialog();
	
	if (saldos) {
		MessageBox.information(util.translate("scripts",
		"Algunas subcuentas que ya no existen en el nuevo PGC tienen saldos\nen el ejercicio origen.\nDeberá trasladar el saldo de estas subcuentas a otras y repetir el proceso,\no bien crear un registro de correspondencia en las opciones de configuración\ndel módulo principal de contabilidad\n\nLas subcuentas y sus saldos son:") + "\n" + saldos,
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}
	
	return true;
}

function oficial_actualizarSaldos()
{
	var util:FLUtil = new FLUtil();
	
	var codEjercicio:String = this.child("fdbCodEjercicioDes").value();
	var numSubcuentas:Number = util.sqlSelect("co_subcuentas", "count(idsubcuenta)", "codejercicio = '" + codEjercicio + "'");
	var paso:Number = 0;
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("co_subcuentas");
	q.setFrom("co_subcuentas");
	q.setSelect("idsubcuenta");
	q.setWhere("codejercicio = '" + codEjercicio + "'")
	
	if (!q.exec()) { 
		MessageBox.warning( util.translate( "scripts", "Se produjo un error en la consulta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return false;
	}
	
	util.createProgressDialog( util.translate( "scripts",
							"Calculando saldos de las Subcuentas..." ), numSubcuentas );
	
	while(q.next()) {
		flcontppal.iface.pub_calcularSaldo(q.value(0));
		util.setProgress(paso++);
	}

	util.destroyProgressDialog();

	MessageBox.information ( util.translate( "scripts", "Proceso finalizado. Subcuentas actualizadas: " + paso), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

