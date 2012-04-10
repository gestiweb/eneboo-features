
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends medidas /** %from: oficial */ {
	var calculoStockBloqueado_:Boolean;
	var curMoviStock:FLSqlCursor;
	function articuloscomp( context ) { medidas ( context ); }
// 	function cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String):Boolean {
// 		return this.ctx.articuloscomp_cambiarStock(codAlmacen, referencia, variacion, campo);
// 	}
	function pvpCompuesto(referencia:String):Number {
		return this.ctx.articuloscomp_pvpCompuesto(referencia);
	}
	function beforeCommit_articulos(curArticulo:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_beforeCommit_articulos(curArticulo);
	}
	function actualizarUnidad(referencia:String,unidad:String):Boolean {
		return this.ctx.articuloscomp_actualizarUnidad(referencia,unidad);
	}
	function calcularFiltroReferencia(referencia:String):String {
		return this.ctx.articuloscomp_calcularFiltroReferencia(referencia);
	}
	function afterCommit_articuloscomp(curAC:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_afterCommit_articuloscomp(curAC);
	}
	function afterCommit_tiposopcionartcomp(curTOAC:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_afterCommit_tiposopcionartcomp(curTOAC);
	}
	function comprobarPadresVariables(referencia:String):Boolean {
		return this.ctx.articuloscomp_comprobarPadresVariables(referencia);
	}
	function beforeCommit_opcionesarticulocomp(curOP:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_beforeCommit_opcionesarticulocomp(curOP);
	}
	function datosArticulo(cursor:FLSqlCursor, codLote:String):Array {
		return this.ctx.articuloscomp_datosArticulo(cursor, codLote);
	}
	function establecerCantidad(curLinea:FLSqlCursor):Number {
		return this.ctx.articuloscomp_establecerCantidad(curLinea);
	}
	function dameDatosStockLinea(curLinea:FLSqlCursor, curArticuloComp:FLSqlCursor):Array {
		return this.ctx.articuloscomp_dameDatosStockLinea(curLinea, curArticuloComp);
	}
	function datosArticuloMS(datosArt:Array):Boolean {
		return this.ctx.articuloscomp_datosArticuloMS(datosArt);
	}
	function generarMoviStockComponentes(aDatosArt:Array, idProceso):Boolean {
		return this.ctx.articuloscomp_generarMoviStockComponentes(aDatosArt, idProceso);
	}
	function generarMoviStock(curLinea:FLSqlCursor, codLote:String, cantidad:Number, curArticuloComp:FLSqlCursor, idProceso:String):Boolean {
		return this.ctx.articuloscomp_generarMoviStock(curLinea, codLote, cantidad, curArticuloComp, idProceso);
	}
	function dameIdStock(codAlmacen:String, aDatosArt:Array):String {
		return this.ctx.articuloscomp_dameIdStock(codAlmacen, aDatosArt);
	}
	function creaRegMoviStock(curLinea:FLSqlCursor, aDatosArt:Array, aDatosStockLinea:Array, curArticuloComp:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_creaRegMoviStock(curLinea, aDatosArt, aDatosStockLinea, curArticuloComp);
	}
	function actualizarStocksMoviStock(curMS:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_actualizarStocksMoviStock(curMS);
	}
	function actualizarStockPteRecibir(idStock:Number):Boolean {
		return this.ctx.articuloscomp_actualizarStockPteRecibir(idStock);
	}
	function actualizarStockPteServir(idStock:Number):Boolean {
		return this.ctx.articuloscomp_actualizarStockPteServir(idStock);
	}
	function actualizarStock(idStock:Number):Boolean {
		return this.ctx.articuloscomp_actualizarStock(idStock);
	}
	function afterCommit_movistock(curMS:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_afterCommit_movistock(curMS);
	}
	function crearStock(codAlmacen:String, datosArt:Array):Number {
		return this.ctx.articuloscomp_crearStock(codAlmacen, datosArt);
	}
	function generarEstructura(curLinea:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_generarEstructura(curLinea);
	}
	function borrarEstructura(curLP:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_borrarEstructura(curLP);
	}
	function borrarMoviStock(curLinea:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_borrarMoviStock(curLinea);
	}
	function controlStockPresupuestosCli(curLP:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockPresupuestosCli(curLP);
	}
	function controlStockPedidosCli(curLP:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockPedidosCli(curLP);
	}
	function controlStockComandasCli(curLV:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockComandasCli(curLV);
	}
	function controlStockPedidosProv(curLP:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockPedidosProv(curLP);
	}
	function controlStockLineasTrans(curLTS:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockLineasTrans(curLTS);
	}
	function controlStockValesTPV(curLinea:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockValesTPV(curLinea);
	}
	function controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockAlbaranesCli(curLA);
	}
	function controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockAlbaranesProv(curLA);
	}
	function controlStockFacturasCli(curLF:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockFacturasCli(curLF);
	}
	function controlStockFacturasProv(curLF:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_controlStockFacturasProv(curLF);
	}
	function albaranarLineaPedCli(idLineaPedido:String, curLA:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_albaranarLineaPedCli(idLineaPedido, curLA);
	}
	function albaranarLineaPedProv(idLineaPedido:String, curLA:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_albaranarLineaPedProv(idLineaPedido, curLA);
	}
	function desalbaranarLineaPedCli(idLineaPedido:String, idLineaAlbaran:String):Boolean {
		return this.ctx.articuloscomp_desalbaranarLineaPedCli(idLineaPedido, idLineaAlbaran);
	}
	function desalbaranarLineaPedProv(idLineaPedido:String, idLineaAlbaran:String):Boolean {
		return this.ctx.articuloscomp_desalbaranarLineaPedProv(idLineaPedido, idLineaAlbaran);
	}
	function unificarMovPtePC(idLineaPedido:String):Boolean {
		return this.ctx.articuloscomp_unificarMovPtePC(idLineaPedido);
	}
	function unificarMovPtePP(idLineaPedido:String):Boolean {
		return this.ctx.articuloscomp_unificarMovPtePP(idLineaPedido);
	}
	function albaranarParcialLPC(idLineaPedido:String, curLA:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_albaranarParcialLPC(idLineaPedido, curLA);
	}
	function albaranarParcialLPP(idLineaPedido:String, curLA:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_albaranarParcialLPP(idLineaPedido, curLA);
	}
	function copiaDatosMoviStock(curMSOrigen:FLSqlCursor):Boolean {
		return this.ctx.articuloscomp_copiaDatosMoviStock(curMSOrigen);
	}
	function bloquearCalculoStock(bloquear:Boolean) {
		return this.ctx.articuloscomp_bloquearCalculoStock(bloquear);
	}
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubArticulosComp */
/////////////////////////////////////////////////////////////////
//// PUB_ARTICULOSCOMP //////////////////////////////////////////
class pubArticulosComp extends pubMedidas /** %from: ifaceCtx */ {
	function pubArticulosComp( context ) { pubMedidas( context ); }
	function pub_pvpCompuesto(referencia:String):Number {
		return this.pvpCompuesto(referencia);
	}
	function pub_calcularFiltroReferencia(referencia:String):String {
		return this.calcularFiltroReferencia(referencia);
	}
	function pub_bloquearCalculoStock(bloquear:Boolean) {
		return this.bloquearCalculoStock(bloquear);
	}
	function pub_datosArticulo(cursor:FLSqlCursor, codLote:String):Array {
		return this.datosArticulo(cursor, codLote);
	}
}
//// PUB_ARTICULOSCOMP //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
// function articuloscomp_cambiarStock(codAlmacen:String, referencia:String, variacion:Number, campo:String):Boolean
// {
// 	var util:FLUtil = new FLUtil();
//
// 	if (!util.sqlSelect("articuloscomp","refcompuesto","refcompuesto = '" + referencia + "'")){
// 		if (!this.iface.__cambiarStock(codAlmacen,referencia,variacion,campo))
// 			return false;
// 	} else {
// 		var qry:FLSqlQuery = new FLSqlQuery();
// 		qry.setTablesList("articuloscomp");
// 		qry.setSelect("refcomponente, cantidad");
// 		qry.setFrom("articuloscomp");
// 		qry.setWhere("refcompuesto = '" + referencia + "' AND (idtipoopcionart IS NULL OR idtipoopcionart = 0)");
//
// 		if (!qry.exec())
// 			return false;
//
// 		var refComp:String = "";
// 		var cantidad:Number = 0;
//
// 		while (qry.next()) {
// 			refComp = qry.value(0);
// 			cantidad = variacion * parseFloat(qry.value(1));
// 			if (!this.iface.cambiarStock(codAlmacen, refComp, cantidad, campo))
// 				return false;
// 		}
// 	}
//
// 	return true;
//
// }

/** \D Calcula el precio de un artículo compuesto como suma de los precios de sus componentes
@param	referencia: Referencia del artículo cuyo precio se desea calcular
@return: Precio calculado o false si hay error
\end */
function articuloscomp_pvpCompuesto(referencia:String):Number
{
	var util:FLUtil = new FLUtil();

	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("articuloscomp,articulos");
	qry.setSelect("SUM(a.pvp * ac.cantidad)");
	qry.setFrom("articuloscomp ac INNER JOIN articulos a ON ac.refcomponente = a.referencia");
	qry.setWhere("ac.refcompuesto = '" + referencia + "'");

	if(!qry.exec())
		return false;

	if (!qry.first())
		return false;

	var resultado:Number = util.roundFieldValue(qry.value(0), "articulos", "pvp");
	return resultado;
}

function articuloscomp_beforeCommit_articulos(curArticulo:FLSqlCursor):Boolean
{
	var util:FLUtil;

	switch(curArticulo.modeAccess()) {
		case curArticulo.Edit:
			var unidadAnterior:String = curArticulo.valueBufferCopy("codunidad");
			var unidadActual:String = curArticulo.valueBuffer("codunidad");
			if (unidadAnterior != unidadActual) {
				MessageBox.information(util.translate("scripts","Ha cambiado la unidad del artículo. Se va a actualizar esta unidad para los artículos compuestos."),MessageBox.Ok, MessageBox.NoButton);
				if (!this.iface.actualizarUnidad(curArticulo.valueBuffer("referencia"),unidadActual))
					return false;
			}
		case curArticulo.Insert:
			/// Parcheado ¿por qué hay que ponerloa a cero?
			// Si es un compuesto el stockminimo se pone a cero
// 			if (util.sqlSelect("articuloscomp","id","refcompuesto = '" + curArticulo.valueBuffer("referencia") + "'")) {
// 				if (curArticulo.valueBuffer("stockmin") != 0)
// 					curArticulo.setValueBuffer("stockmin", 0);
// 				if (curArticulo.valueBuffer("stockmax") != 0)
// 					curArticulo.setValueBuffer("stockmax", 0);
// 			}
		break;
	}

	return true;
}

function articuloscomp_actualizarUnidad(referencia:String,unidad:String):Boolean
{
	var curArticulosComp:FLSqlCursor = new FLSqlCursor("articuloscomp");
	curArticulosComp.select("refcomponente = '" + referencia + "'");
	if(!curArticulosComp.first())
		return true;

	do {
		curArticulosComp.setModeAccess(curArticulosComp.Edit);
		curArticulosComp.refreshBuffer();
		curArticulosComp.setValueBuffer("codunidad",unidad);
		if(!curArticulosComp.commitBuffer())
			return false;

	} while (curArticulosComp.next());

	return true;
}

function articuloscomp_calcularFiltroReferencia(referencia:String):String
{
	if (!referencia || referencia == "")
		return "";

	var lista:String = "'" + referencia + "'";
	var refCompuesto:String = referencia;

	if (refCompuesto && refCompuesto != "") {
		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("articuloscomp");
		q.setSelect("refcompuesto");
		q.setFrom("articuloscomp");
		q.setWhere("refcomponente = '" + refCompuesto + "'");
		if(!q.exec())
			return;

		while (q.next())
			lista = lista + ", " + this.iface.calcularFiltroReferencia(q.value("refcompuesto"));
	}

	return lista;
}

function articuloscomp_afterCommit_tiposopcionartcomp(curTOAC:FLSqlCursor):Boolean
{
	var util:FLUtil;

	var referencia:String = curTOAC.valueBuffer("referencia");
	var variable:Boolean = false;

	if(formRecordarticulos.iface.pub_esArticuloVariable(referencia)) {
		variable = true;
	}

	if(!util.sqlUpdate("articulos","variable",variable,"referencia = '" + referencia + "'"))
		return false;
	if(!this.iface.comprobarPadresVariables(referencia))
		return false;

	return true;
}

function articuloscomp_afterCommit_articuloscomp(curAC:FLSqlCursor):Boolean
{
	var util:FLUtil;

	var referencia:String = curAC.valueBuffer("refcompuesto");
	var variable:Boolean = false;

	if(formRecordarticulos.iface.pub_esArticuloVariable(referencia)) {
		variable = true;
	}

	if(!util.sqlUpdate("articulos","variable",variable,"referencia = '" + referencia + "'"))
		return false;

	if(!this.iface.comprobarPadresVariables(referencia))
		return false;

	return true;
}

function articuloscomp_comprobarPadresVariables(referencia:String):Boolean
{
	var util:FLUtil;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("articuloscomp");
	q.setSelect("refcompuesto");
	q.setFrom("articuloscomp");
	q.setWhere("refcomponente = '" + referencia + "'");
	if(!q.exec())
		return;

	var variable:Boolean;
	var refCompuesto:String
	while (q.next()) {
		refCompuesto = q.value("refcompuesto");
		variable = false;

		if(formRecordarticulos.iface.pub_esArticuloVariable(q.value("refcompuesto"))) {
			variable = true;
		}

		if(!util.sqlUpdate("articulos","variable",variable,"referencia = '" + refCompuesto + "'"))
			return false;
		if(!this.iface.comprobarPadresVariables(refCompuesto))
			return false;
	}

	return true;
}

function articuloscomp_beforeCommit_opcionesarticulocomp(curOP:FLSqlCursor):Boolean
{
	var util:FLUtil;

	if(curOP.modeAccess() == curOP.Insert || curOP.modeAccess() == curOP.Edit) {
		var idOpcion:Number = curOP.valueBuffer("idopcion");
		var idTipoOpcionArt:Number = curOP.valueBuffer("idtipoopcionart");
		var idOpcionArticulo:Number = curOP.valueBuffer("idopcionarticulo");

		if(util.sqlSelect("opcionesarticulocomp","idopcionarticulo","idopcion = " + idOpcion + " AND idtipoopcionart = " + idTipoOpcionArt + " AND idopcionarticulo <> " + idOpcionArticulo)) {
			MessageBox.warning(util.translate("scripts", "Ya existe una opción de este tipo para este artículo"), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	}

	return true;
}



/// //////////////////////
/** \D Genera la estructura de lotes de stock y salidas programadas asociada a los artículos pedidos
\end */
function articuloscomp_generarEstructura(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var referencia:String = curLinea.valueBuffer("referencia");
	if (!referencia || referencia == "") {
		return true;
	}

	if (!this.iface.generarMoviStock(curLinea, false)) {
		return false;
	}

	return true;
}

/** \D Función a sobrecargar por extensiones como la de barcodes
@param	cursor: Cursor que contiene los datos que identifican el artículo
@param	codLote: Código del lote del artículo
@return	array con datos identificativos del artículo
\end */
function articuloscomp_datosArticulo(cursor:FLSqlCursor, codLote:String):Array
{
	var util:FLUtil = new FLUtil;
	var res:Array = [];
	var referencia:String = "";

	switch (cursor.table()) {
		case "articuloscomp": {
			referencia = cursor.valueBuffer("refcomponente")
			break;
		}
		default: {
			referencia = cursor.valueBuffer("referencia")
			break;
		}
	}
	res["localizador"] = "referencia = '" + referencia + "'";
	res["referencia"] = referencia;

	return res;
}

/** Establece la cantidad de un movimiento de stock para pedidos parciales
\end */
function articuloscomp_establecerCantidad(curLinea:FLSqlCursor):Number
{
	var cantidad:Number;
	switch (curLinea.table()) {
		case "lineaspedidoscli":
		case "lineaspedidosprov": {
			if (curLinea.valueBuffer("cantidad") > curLinea.valueBuffer("totalenalbaran") && curLinea.valueBuffer("totalenalbaran") != 0) {
				cantidad = parseFloat(curLinea.valueBuffer("cantidad")) - parseFloat(curLinea.valueBuffer("totalenalbaran"));
			} else {
				cantidad = curLinea.valueBuffer("cantidad");
			}
			break;
		}
		default: {
			cantidad = curLinea.valueBuffer("cantidad");
			break;
		}
		return cantidad;
	}
	return cantidad;
}

/** \D Desactiva el cáculo de stocks al modificarse movimientos de stock. Usar con cuidado
\end */
function articuloscomp_bloquearCalculoStock(bloquear:Boolean)
{
	this.iface.calculoStockBloqueado_ = bloquear;
}

/** \D Obtiene los datos de almacén y fecha correspondientes a los movimientos asociados a una línea de facturación
@param	curLinea: Cursor de la línea
@param	curArticuloComp: Cursor de la composición
@return array con los datos:
\end */
function articuloscomp_dameDatosStockLinea(curLinea:FLSqlCursor, curArticuloComp):Array
{
debug("articuloscomp_dameDatosStockLinea");
	var util:FLUtil = new FLUtil;
	var aDatos:Array = [];
	var aAux:Array;
	var tabla:String = curLinea.table();
	var curRelation:FLSqlCursor = curLinea.cursorRelation();
	var tablaRel:String = curRelation ? curRelation.table() : "";
	var codAlmacen:String, hora:String;

	switch (tabla) {
		case "lineaspedidoscli": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			if (tablaRel == "pedidoscli") {
				aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
				aDatos.fechaPrev = curRelation.valueBuffer("fechasalida");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("pedidoscli", "codalmacen,fechasalida", "idpedido = " + curLinea.valueBuffer("idpedido"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmacen = aAux.codalmacen;
				aDatos.fechaPrev = aAux.fechasalida;
			}
			break;
		}
		case "lineaspedidosprov": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			if (tablaRel == "pedidosprov") {
				aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
				aDatos.fechaPrev = curRelation.valueBuffer("fechaentrada");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("pedidosprov", "codalmacen,fechaentrada", "idpedido = " + curLinea.valueBuffer("idpedido"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmacen = aAux.codalmacen;
				aDatos.fechaPrev = aAux.fechaentrada;
			}
			break;
		}
		case "tpv_lineascomanda": {
			aDatos.idLinea = curLinea.valueBuffer("idtpv_linea");
			if (tablaRel == "tpv_comandas") {
				aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
				aDatos.fechaReal = curRelation.valueBuffer("fecha");
				hora = curRelation.valueBuffer("hora");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("tpv_comandas", "codalmacen,fecha,hora", "idtpv_comanda = " + curLinea.valueBuffer("idtpv_comanda"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmacen = aAux.codalmacen;
				aDatos.fechaReal = aAux.fecha;
				hora = aAux.hora;
			}
			aDatos.horaReal = hora.toString().right(8);
			break;
		}
		case "tpv_lineasvale": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			aDatos.fechaReal = curLinea.valueBuffer("fecha");
			hora = curLinea.valueBuffer("hora");
			aDatos.horaReal = hora.toString().right(8);
			aDatos.codAlmacen = curLinea.valueBuffer("codalmacen");
			break;
		}
		case "lineasalbaranescli": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			if (tablaRel == "albaranescli") {
				aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
				aDatos.fechaReal = curRelation.valueBuffer("fecha");
				hora = curRelation.valueBuffer("hora");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("albaranescli", "codalmacen,fecha,hora", "idalbaran = " + curLinea.valueBuffer("idalbaran"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmacen = aAux.codalmacen;
				aDatos.fechaReal = aAux.fecha;
				hora = aAux.hora;
			}
			aDatos.horaReal = hora.toString().right(8);
			break;
		}
		case "lineasalbaranesprov": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			if (tablaRel == "albaranesprov") {
				aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
				aDatos.fechaReal = curRelation.valueBuffer("fecha");
				hora = curRelation.valueBuffer("hora");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("albaranesprov", "codalmacen,fecha,hora", "idalbaran = " + curLinea.valueBuffer("idalbaran"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmacen = aAux.codalmacen;
				aDatos.fechaReal = aAux.fecha;
				hora = aAux.hora;
			}
			aDatos.horaReal = hora.toString().right(8);
			break;
		}
		case "lineasfacturascli": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			if (tablaRel == "facturascli") {
				aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
				aDatos.fechaReal = curRelation.valueBuffer("fecha");
				hora = curRelation.valueBuffer("hora");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("facturascli", "codalmacen,fecha,hora", "idfactura = " + curLinea.valueBuffer("idfactura"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmacen = aAux.codalmacen;
				aDatos.fechaReal = aAux.fecha;
				hora = aAux.hora;
			}
			aDatos.horaReal = hora.toString().right(8);
			break;
		}
		case "lineasfacturasprov": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			if (tablaRel == "facturasprov") {
				aDatos.codAlmacen = curRelation.valueBuffer("codalmacen");
				aDatos.fechaReal = curRelation.valueBuffer("fecha");
				hora = curRelation.valueBuffer("hora");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("facturasprov", "codalmacen,fecha,hora", "idfactura = " + curLinea.valueBuffer("idfactura"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmacen = aAux.codalmacen;
				aDatos.fechaReal = aAux.fecha;
				hora = aAux.hora;
			}
			aDatos.horaReal = hora.toString().right(8);
			break;
		}
		case "lineastransstock": {
			aDatos.idLinea = curLinea.valueBuffer("idlinea");
			if (tablaRel == "transstock") {
				aDatos.codAlmaOrigen = curRelation.valueBuffer("codalmaorigen");
				aDatos.codAlmaDestino = curRelation.valueBuffer("codalmadestino");
				aDatos.fechaReal = curRelation.valueBuffer("fecha");
				hora = curRelation.valueBuffer("hora");
			} else {
				aAux = flfactppal.iface.pub_ejecutarQry("transstock", "codalmaorigen,codalmadestino,fecha,hora", "idtrans = " + curLinea.valueBuffer("idtrans"));
				if (aAux.result != 1) {
					return false;
				}
				aDatos.codAlmaOrigen = aAux.codalmaorigen;
				aDatos.codAlmaDestino = aAux.codalmadestino;
				aDatos.fechaReal = aAux.fecha;
				hora = aAux.hora;
			}
			aDatos.horaReal = hora.toString().right(8);
			break;
		}
		default: {
			aDatos = false;
		}
	}
	return aDatos;
}

function articuloscomp_datosArticuloMS(datosArt:Array):Boolean
{
	this.iface.curMoviStock.setValueBuffer("referencia", datosArt["referencia"]);
	return true;
}

/** Indica si hay que generar o no movimientos de stock para los componentes del artículo
@param	aDatosArt: Array con los datos de identificación del artículo
@param 	idProceso: Proceso al que asociar el movimiento
\end */
function articuloscomp_generarMoviStockComponentes(aDatosArt:Array, idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var generar:Boolean = false;
	if (util.sqlSelect("articulos a INNER JOIN articuloscomp ac ON a.referencia = ac.refcompuesto", "a.stockcomp", "a.referencia = '" + aDatosArt["referencia"] + "'", "articulos,articuloscomp")) {
		generar = true;
	}
	return generar;
}

/** Genera uno o más movimientos de stock asociados a una línea de documento de facturación
\end */
function articuloscomp_generarMoviStock(curLinea:FLSqlCursor, codLote:String, cantidad:Number, curArticuloComp:FLSqlCursor, idProceso:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var idLinea:String;
	var idPadre:String;
	var fechaPrev:String;
	var fechaReal:String;
	var horaReal:String;
	var codAlmacen:String;
	var codAlmacenOrigen:String;
	var codAlmacenDestino:String;
	var referencia:String;
	var datosArt:Array;

	var tabla:String = curLinea.table();

	switch (tabla) {
		case "lineaspedidoscli":
		case "lineaspedidosprov": {
			if (curLinea.valueBuffer("cerrada")) {
				return true;
			}
			break;
		}
	}
// 		case "lineaspresupuestoscli":
// 		case "lineasalbaranescli":
// 		case "tpv_lineascomanda":
// 		case "tpv_lineasvale":
// 		case "lotesstock":
// 		case "lineastransstock": {
			if (curArticuloComp) {
				datosArt = this.iface.datosArticulo(curArticuloComp);
			} else {
				datosArt = this.iface.datosArticulo(curLinea, codLote);
			}
			if (datosArt["referencia"] == "") {
				return true;
			}
			if (!cantidad || isNaN(cantidad)) {
				cantidad = this.iface.establecerCantidad(curLinea);
			}
			if (!cantidad) {
				return true;
			}
			/** Para artículos compuestos que no son fabricados, se crean tantos movimientos de stock como componentes haya */
			if (this.iface.generarMoviStockComponentes(datosArt, idProceso)) {
				var nuevaCantidad:Number;
				var curAC:FLSqlCursor = new FLSqlCursor("articuloscomp");
				curAC.select("refcompuesto = '" + datosArt["referencia"] + "'");
				while (curAC.next()) {
					curAC.setModeAccess(curAC.Browse);
					curAC.refreshBuffer();
					nuevaCantidad = cantidad * curAC.valueBuffer("cantidad");
					if (!this.iface.generarMoviStock(curLinea, codLote, nuevaCantidad, curAC)) {
						return false;
					}
				}
			}
			var aDatosStockLinea:Array = this.iface.dameDatosStockLinea(curLinea, curArticuloComp);
			if (!aDatosStockLinea) {
				return false;
			}
// 			idLinea = aDatosStockLinea.idLinea;
// 			switch (tabla) {
// 				case "lineaspresupuestoscli": {
// 					idPadre = curLinea.valueBuffer("idpresupuesto");
// 					fechaPrev = util.sqlSelect("presupuestoscli", "fechasalida", "idpresupuesto = " + idPadre);
// 					codAlmacen = this.iface.dameAlmacenLinea(curLinea);
//
//
// 					util.sqlSelect("presupuestoscli", "codalmacen", "idpresupuesto = " + idPadre);
// 					break;
// 				}
// 				case "lineaspedidoscli": {
// 					idPadre = curLinea.valueBuffer("idpedido");
// 					fechaPrev = util.sqlSelect("pedidoscli", "fechasalida", "idpedido = " + idPadre);
// 					codAlmacen = util.sqlSelect("pedidoscli", "codalmacen", "idpedido = " + idPadre);
// 					break;
// 				}
// 				case "tpv_lineascomanda": {
// 					idLinea = curLinea.valueBuffer("idtpv_linea");
// 					idPadre = curLinea.valueBuffer("idtpv_comanda");
// 					fechaReal = util.sqlSelect("tpv_comandas", "fecha", "idtpv_comanda = " + idPadre);
// 					codAlmacen = util.sqlSelect("tpv_comandas c INNER JOIN tpv_puntosventa pv ON c.codtpv_puntoventa = pv.codtpv_puntoventa", "pv.codalmacen", "idtpv_comanda = " + idPadre, "tpv_comandas,tpv_puntosventa");
// 					break;
// 				}
// 				case "tpv_lineasvale": {
// 					idPadre = curLinea.valueBuffer("refvale");
// 					fechaReal = util.sqlSelect("tpv_vales", "fechaemision", "referencia = '" + idPadre + "'");
// 					codAlmacen = curLinea.valueBuffer("codalmacen");
// 					break;
// 				}
// 				case "lineasalbaranescli": {
// 					idPadre = curLinea.valueBuffer("idalbaran");
// 					fechaReal = util.sqlSelect("albaranescli", "fecha", "idalbaran = " + idPadre);
// 					var hora:String = util.sqlSelect("albaranescli", "hora", "idalbaran = " + idPadre);
//
// 					hora = hora.toString();
// 					horaReal = hora.right(8);
// 					codAlmacen = util.sqlSelect("albaranescli", "codalmacen", "idalbaran = " + idPadre);
// 					break;
// 				}
// 				case "lineastransstock": {
// 					idPadre = curLinea.valueBuffer("idtrans");
// 					fechaPrev = util.sqlSelect("transstock", "fecha", "idtrans = " + idPadre);
// 					horaReal = util.sqlSelect("transstock", "hora", "idtrans = " + idPadre);
// 					codAlmacenOrigen = util.sqlSelect("transstock", "codalmaorigen", "idtrans = " + idPadre);
// 					codAlmacenDestino = util.sqlSelect("transstock", "codalmadestino", "idtrans = " + idPadre);
// 					break;
// 				}
// 				case "lotesstock": {
// 					fechaPrev = curLinea.valueBuffer("fechafabricacion");
// 					// Por ahora no se usa el campo fechafabricacion (fechaPrev se calcula a partir de la fecha de entrega del pedido, más adelante.
// 					if (!fechaPrev || fechaPrev == "") {
// 						var hoy:Date = new Date;
// 						fechaPrev = hoy.toString();
// 					}
// 					var diasAntelacion:Number = parseFloat(curArticuloComp.valueBuffer("diasantelacion"));
// 					if (diasAntelacion && !isNaN(diasAntelacion)) {
// 						diasAntelacion = diasAntelacion * -1;
// 						fechaPrev = util.addDays(fechaPrev, diasAntelacion);
// 					}
// 					codAlmacen = this.iface.almacenFabricacion(curLinea,curArticuloComp);
// 					break;
// 				}
// 				case "pr_procesos": {
// 					fechaPrev = util.sqlSelect("pr_tareas", "MAX(fechafinprev)", "idproceso = " + curLinea.valueBuffer("idproceso"));
// 					if (!fechaPrev || fechaPrev == "") {
//
// 						return false;
// 					}
// 					codAlmacen = this.iface.almacenFabricacion(curLinea);
// 					break;
// 				}
// 			}
// 			break;
// 		}
// 		case "lineaspedidosprov": {
// 			if(curLinea.valueBuffer("cerrada"))
// 				return true;
// 			datosArt = this.iface.datosArticulo(curLinea);
// 			if (datosArt["referencia"] == "")
// 				return true;
//
// 			if (!cantidad || isNaN(cantidad)) {
// 				cantidad = this.iface.establecerCantidad(curLinea);
// 			}
// 			if(!cantidad)
// 				return true;
// 			idLinea = curLinea.valueBuffer("idlinea");
// 			idPadre = curLinea.valueBuffer("idpedido");
// 			fechaPrev = util.sqlSelect("pedidosprov", "fechaentrada", "idpedido = " + idPadre);
// 			codAlmacen = util.sqlSelect("pedidosprov", "codalmacen", "idpedido = " + idPadre);
// 			break;
// 		}
// 		case "lineasalbaranesprov": {
// 			datosArt = this.iface.datosArticulo(curLinea);
// 			if (datosArt["referencia"] == "")
// 				return true;
// 			if (!cantidad || isNaN(cantidad)) {
// 				cantidad = this.iface.establecerCantidad(curLinea);
// 			}
// 			if(!cantidad)
// 				return true;
// 			idLinea = curLinea.valueBuffer("idlinea");
// 			idPadre = curLinea.valueBuffer("idalbaran");
// 			fechaReal = util.sqlSelect("albaranesprov", "fecha", "idalbaran = " + idPadre);
// 			var hora:String = util.sqlSelect("albaranesprov", "hora", "idalbaran = " + idPadre);
//
// 			hora = hora.toString();
// 			horaReal = hora.right(8);
// 			codAlmacen = util.sqlSelect("albaranesprov", "codalmacen", "idalbaran = " + idPadre);
// 			break;
// 		}
// 	}

// 	var idStock:String = false;
// 	var idStockDestino:String = false;

// 	if (tabla == "lineastransstock") {
// 		if (!aDatosStockLinea.codAlmaOrigen || aDatosStockLinea.codAlmaOrigen == "" || !aDatosStockLinea.codAlmaDestino || aDatosStockLinea.codAlmaDestino == "") {
// 			MessageBox.critical(util.translate("scripts", "Error: Intenta generar un movimiento de stock sin especificar el almacén asociado"), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 		idStock = util.sqlSelect("stocks", "idstock", datosArt["localizador"] + " AND codalmacen = '" + aDatosStockLinea.codAlmaOrigen + "'");
// 		if (!idStock) {
// 			idStock = this.iface.crearStock(aDatosStockLinea.codAlmaOrigen, datosArt);
// 		}
// 		if (!idStock || idStock == "") {
// 			MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el stock para el artículo %1 y el almacén %2").arg(datosArt["referencia"]).arg(aDatosStockLinea.codAlmaOrigen), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
//
// 		idStockDestino = util.sqlSelect("stocks", "idstock", datosArt["localizador"] + " AND codalmacen = '" + aDatosStockLinea.codAlmaDestino + "'");
// 		if (!idStockDestino || idStockDestino == "") {
// 			idStockDestino = this.iface.crearStock(aDatosStockLinea.codAlmaDestino, datosArt);
// 		}
// 		if (!idStockDestino || idStockDestino == "") {
// 			MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el stock para el artículo %1 y el almacén %2").arg(datosArt["referencia"]).arg(aDatosStockLinea.codAlmaDestino), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 	} else {
// 		if (!aDatosStockLinea.codAlmacen || aDatosStockLinea.codAlmacen == "") {
// 			MessageBox.critical(util.translate("scripts", "Error: Intenta generar un movimiento de stock sin especificar el almacén asociado"), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 		idStock = util.sqlSelect("stocks", "idstock", datosArt["localizador"] + " AND codalmacen = '" + aDatosStockLinea.codAlmacen + "'");
// 		if (!idStock || idStock == "") {
// 			idStock = this.iface.crearStock(aDatosStockLinea.codAlmacen, datosArt);
// 		}
// 		if (!idStock || idStock == "") {
// 			MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el stock para el artículo %1 y el almacén %2").arg(datosArt["referencia"]).arg(aDatosStockLinea.codAlmacen), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 	}

	if (!this.iface.curMoviStock) {
		this.iface.curMoviStock = new FLSqlCursor("movistock");
	}

	aDatosStockLinea.cantidad = cantidad;
	aDatosStockLinea.idProceso = idProceso;
	aDatosStockLinea.codLote = codLote;

	if (!this.iface.creaRegMoviStock(curLinea, datosArt, aDatosStockLinea, curArticuloComp)) {
		return false;
	}

// 	var modoAcceso:Number = this.iface.curMoviStock.modeAccess();
// 	if (tabla != "lineastransstock") {
// 		if (!this.iface.datosArticuloMS(datosArt)) {
// 			return false;
// 		}
// 		if (modoAcceso == this.iface.curMoviStock.Insert) {
// 			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
// 			if (codLote) {
// 				this.iface.curMoviStock.setValueBuffer("codlote", codLote);
// 			} else {
// 				this.iface.curMoviStock.setNull("codlote");
// 			}
// 		}
// 		if (!this.iface.curMoviStock.commitBuffer()) {
// 			MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el movimiento de stock para el artículo %1 y el almacén %2").arg(datosArt["referencia"]).arg(codAlmacen), MessageBox.Ok, MessageBox.NoButton);
// 			return false;
// 		}
// 	}

// 	switch (tabla) {
// 		case "lineaspresupuestoscli":
// 		case "lineaspedidoscli":
// 		case "lineaspedidosprov":
// 		case "lotesstock": {
// 			if (modoAcceso == this.iface.curMoviStock.Insert) {
// 				if (codLote && fechaPrev && fechaPrev != "") {
// 					if (!this.iface.comprobarFechaFabricacionLote(this.iface.curMoviStock))
// 						return false;
// 				}
// 			}
// 		}
// 		break;
// 	}
	return true;
}

function articuloscomp_dameIdStock(codAlmacen:String, aDatosArt:Array):String
{
	var util:FLUtil = new FLUtil;
	if (!codAlmacen || codAlmacen == "") {
		MessageBox.critical(util.translate("scripts", "Error: Intenta generar un movimiento de stock sin especificar el almacén asociado"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var idStock:String = util.sqlSelect("stocks", "idstock", aDatosArt["localizador"] + " AND codalmacen = '" + codAlmacen + "'");
	if (!idStock || idStock == "") {
		idStock = this.iface.crearStock(codAlmacen, aDatosArt);
	}
	if (!idStock || idStock == "") {
		MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el stock para el artículo %1 y el almacén %2").arg(aDatosArt["referencia"]).arg(codAlmacen), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	return idStock;
}

function articuloscomp_creaRegMoviStock(curLinea:FLSqlCursor, aDatosArt:Array, aDatosStockLinea:Array, curArticuloComp:FLSqlCursor):Boolean
{
	var tabla:String = curLinea.table();
	var cantidad:Number = aDatosStockLinea.cantidad;
	var idLinea:String = aDatosStockLinea.idLinea;
	var idStock:String;
	switch (tabla) {
		case "lineaspresupuestoscli": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad) * -1;
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("idlineapr", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "PTE");
			this.iface.curMoviStock.setValueBuffer("fechaprev", aDatosStockLinea.fechaPrev);
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "lineaspedidoscli": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad) * -1;
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("idlineapc", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "PTE");
			this.iface.curMoviStock.setValueBuffer("fechaprev", aDatosStockLinea.fechaPrev);
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "lineaspedidosprov": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad);
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("idlineapp", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "PTE");
			this.iface.curMoviStock.setValueBuffer("fechaprev", aDatosStockLinea.fechaPrev);
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "tpv_lineascomanda": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad) * -1;
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idlineaco", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "lineasalbaranescli": {
			cantidad = parseFloat(cantidad) * -1;
			var idLineaPedido:String = curLinea.valueBuffer("idlineapedido");
			if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
				this.iface.curMoviStock.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE' AND fechareal IS NULL");
				if (!curMoviStock.first()) {
					MessageBox.critical(util.translate("scripts", "No se encuentra un movimiento pendiente que albaranar"), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
				this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Edit);
				this.iface.curMoviStock.refreshBuffer();
				if (cantidad != parseFloat(this.iface.curMoviStock.valueBuffer("cantidad"))) {
					MessageBox.critical(util.translate("scripts", "Error de consistencia en línea de pedido %1.\nEl total albaranado no coincide con la cantidad del movimiento de stock pendiente").arg(idLineaPedido), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			} else {
				idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
				if (!idStock) {
					return false;
				}
				this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
				this.iface.curMoviStock.refreshBuffer();
				this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
				this.iface.curMoviStock.setValueBuffer("idstock", idStock);
				if (!this.iface.datosArticuloMS(aDatosArt)) {
					return false;
				}
			}
			this.iface.curMoviStock.setValueBuffer("idlineaac", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "lineasfacturascli": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad) * -1;
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idlineafc", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "lineasfacturasprov": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad);
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idlineafp", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "tpv_lineasvale": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad);
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idlineava", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "lineasalbaranesprov": {
			cantidad = parseFloat(cantidad);
			var idLineaPedido:String = curLinea.valueBuffer("idlineapedido");
			if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
				this.iface.curMoviStock.select("idlineapp = " + idLineaPedido + " AND estado = 'PTE' AND fechareal IS NULL");
				if (!this.iface.curMoviStock.first()) {
					MessageBox.critical(util.translate("scripts", "No se encuentra un movimiento pendiente que albaranar"), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
				this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Edit);
				this.iface.curMoviStock.refreshBuffer();
				if (cantidad != parseFloat(this.iface.curMoviStock.valueBuffer("cantidad"))) {
					MessageBox.critical(util.translate("scripts", "Error de consistencia en línea de pedido %1.\nEl total albaranado no coincide con la cantidad del movimiento de stock pendiente").arg(idLineaPedido), MessageBox.Ok, MessageBox.NoButton);
					return false;
				}
			} else {
				idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmacen, aDatosArt);
				if (!idStock) {
					return false;
				}
				this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
				this.iface.curMoviStock.refreshBuffer();
				this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
				this.iface.curMoviStock.setValueBuffer("idstock", idStock);
				if (!this.iface.datosArticuloMS(aDatosArt)) {
					return false;
				}
			}
			this.iface.curMoviStock.setValueBuffer("idlineaap", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				return false;
			}
			break;
		}
		case "lineastransstock": {
			idStock = this.iface.dameIdStock(aDatosStockLinea.codAlmaOrigen, aDatosArt);
			if (!idStock) {
				return false;
			}
			cantidad = parseFloat(cantidad);
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("idlineats", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			this.iface.curMoviStock.setValueBuffer("cantidad", (cantidad * -1));
			this.iface.curMoviStock.setValueBuffer("idstock", idStock);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el movimiento de stock para el artículo %1 y el almacén %2").arg(aDatosArt["referencia"]).arg(aDatosStockLinea.codAlmaOrigen), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}

			var idStockDestino:String = this.iface.dameIdStock(aDatosStockLinea.codAlmaDestino, aDatosArt);
			if (!idStockDestino) {
				return false;
			}
			this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
			this.iface.curMoviStock.refreshBuffer();
			this.iface.curMoviStock.setValueBuffer("idlineats", idLinea);
			this.iface.curMoviStock.setValueBuffer("estado", "HECHO");
			this.iface.curMoviStock.setValueBuffer("fechareal", aDatosStockLinea.fechaReal);
			this.iface.curMoviStock.setValueBuffer("horareal", aDatosStockLinea.horaReal);
			this.iface.curMoviStock.setValueBuffer("cantidad", cantidad);
			this.iface.curMoviStock.setValueBuffer("idstock", idStockDestino);
			if (!this.iface.datosArticuloMS(aDatosArt)) {
				return false;
			}
			if (aDatosStockLinea.codLote) {
				this.iface.curMoviStock.setValueBuffer("codlote", aDatosStockLinea.codLote);
			} else {
				this.iface.curMoviStock.setNull("codlote");
			}
			if (!this.iface.curMoviStock.commitBuffer()) {
				MessageBox.critical(util.translate("scripts", "Error: No pudo crearse el movimiento de stock para el artículo %1 y el almacén %2").arg(aDatosArt["referencia"]).arg(aDatosStockLinea.codAlmaDestino), MessageBox.Ok, MessageBox.NoButton);
				return false;
			}
			break;
		}
	}
	return true;
}

function articuloscomp_crearStock(codAlmacen:String, aDatosArt:Array):Number
{
	var util:FLUtil = new FLUtil;
	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	with(curStock) {
		setModeAccess(Insert);
		refreshBuffer();
		setValueBuffer("codalmacen", codAlmacen);
		setValueBuffer("referencia", aDatosArt["referencia"]);
		setValueBuffer("nombre", util.sqlSelect("almacenes", "nombre", "codalmacen = '" + codAlmacen + "'"));
		setValueBuffer("cantidad", 0);
		if (!commitBuffer())
			return false;
	}
	return curStock.valueBuffer("idstock");
}

function articuloscomp_afterCommit_movistock(curMS:FLSqlCursor):Boolean
{
	if (!this.iface.actualizarStocksMoviStock(curMS)) {
		return false;
	}
	return true;
}

function articuloscomp_actualizarStocksMoviStock(curMS:FLSqlCursor):Boolean
{
	if (this.iface.calculoStockBloqueado_) {
		return true;
	}

	var idStock:String =  curMS.valueBuffer("idstock");
	var estado:String = curMS.valueBuffer("estado");
	var cantidad:Number = curMS.valueBuffer("cantidad");

	switch (curMS.modeAccess()) {
		case curMS.Insert:
		case curMS.Del: {
			if (estado == "PTE") {
				if (cantidad > 0) {
					if (!this.iface.actualizarStockPteRecibir(idStock)) {
						return false;
					}
				}
				if (cantidad < 0) {
					if (!this.iface.actualizarStockPteServir(idStock)) {
						return false;
					}
				}
			} else {
				if (!this.iface.actualizarStock(idStock)) {
					return false;
				}
			}
			break;
		}
		case curMS.Edit: {
			var estadoPrevio:String = curMS.valueBufferCopy("estado");
			var cantidadPrevia:Number = curMS.valueBufferCopy("cantidad");
			if (estado != estadoPrevio) {
				if (estadoPrevio == "PTE") {
					if (cantidad > 0 || cantidadPrevia > 0) {
						if (!this.iface.actualizarStockPteRecibir(idStock)) {
							return false;
						}
					}
					if (cantidad < 0 || cantidadPrevia < 0) {
						if (!this.iface.actualizarStockPteServir(idStock)) {
							return false;
						}
					}
				} else {
					if (!this.iface.actualizarStock(idStock)) {
						return false;
					}
				}
			}
			if (estado == "PTE") {
				if (cantidad > 0 || cantidadPrevia > 0) {
					if (!this.iface.actualizarStockPteRecibir(idStock)) {
						return false;
					}
				}
				if (cantidad < 0 || cantidadPrevia < 0) {
					if (!this.iface.actualizarStockPteServir(idStock)) {
						return false;
					}
				}
			} else {
				if (!this.iface.actualizarStock(idStock)) {
					return false;
				}
			}
			break;
		}
	}
	return true;
}

function articuloscomp_actualizarStockPteRecibir(idStock:Number):Boolean
{
	var util:FLUtil = new FLUtil;

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("pterecibir", formRecordregstocks.iface.pub_commonCalculateField("pterecibir", curStock));
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

function articuloscomp_actualizarStockPteServir(idStock:Number):Boolean
{
	var util:FLUtil = new FLUtil;

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("reservada", formRecordregstocks.iface.pub_commonCalculateField("reservada", curStock));
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

function articuloscomp_actualizarStock(idStock:Number):Boolean
{
	var util:FLUtil = new FLUtil;

	var curStock:FLSqlCursor = new FLSqlCursor("stocks");
	curStock.select("idstock = " + idStock);
	if (!curStock.first()) {
		return false;
	}
	curStock.setModeAccess(curStock.Edit);
	curStock.refreshBuffer();
	curStock.setValueBuffer("cantidad", formRecordregstocks.iface.pub_commonCalculateField("cantidad", curStock));
	curStock.setValueBuffer("disponible", formRecordregstocks.iface.pub_commonCalculateField("disponible", curStock));
	if (!curStock.commitBuffer()) {
		return false;
	}
	return true;
}

function articuloscomp_controlStockPedidosCli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLP.valueBuffer("referencia") + "'")) {
		return true;
	}
	switch (curLP.modeAccess()) {
		case curLP.Insert: {
			if (!this.iface.generarEstructura(curLP)) {
				return false;
			}
			break;
		}
		case curLP.Edit: {
			var cantidad:String = curLP.valueBuffer("cantidad");
			var cantidadAnterior:String = curLP.valueBufferCopy("cantidad");
			var referencia:String = curLP.valueBuffer("referencia");
			var referenciaAnterior:String = curLP.valueBufferCopy("referencia");
			var cerrada:Boolean = curLP.valueBuffer("cerrada");
			var cerradaAnterior:Boolean = curLP.valueBufferCopy("cerrada");
			if (cantidad != cantidadAnterior || referencia != referenciaAnterior || cerrada != cerradaAnterior) {
				if (!this.iface.borrarEstructura(curLP)) {
					return false;
				}
				if (!this.iface.generarEstructura(curLP)) {
					return false;
				}
			}
			break;
		}
		case curLP.Del: {
			if (!this.iface.borrarEstructura(curLP)) {
				return false;
			}
			break;
		}
	}

	return true;
}

function articuloscomp_controlStockComandasCli(curLC:FLSqlCursor):Boolean
{
	switch (curLC.modeAccess()) {
		case curLC.Insert: {
			if (!this.iface.generarEstructura(curLC)) {
				return false;
			}
			break;
		}
		case curLC.Edit: {
			var cantidad:String = curLC.valueBuffer("cantidad");
			var cantidadAnterior:String = curLC.valueBufferCopy("cantidad");
			var referencia:String = curLC.valueBuffer("referencia");
			var referenciaAnterior:String = curLC.valueBufferCopy("referencia");
			if (cantidad != cantidadAnterior || referencia != referenciaAnterior) {
				if (!this.iface.borrarEstructura(curLC)) {
					return false;
				}
				if (!this.iface.generarEstructura(curLC)) {
					return false;
				}
			}
			break;
		}
		case curLC.Del: {
			if (!this.iface.borrarEstructura(curLC)) {
				return false;
			}
			break;
		}
	}
	return true;
}

function articuloscomp_controlStockValesTPV(curLV:FLSqlCursor):Boolean
{
	switch (curLV.modeAccess()) {
		case curLV.Insert: {
			if (!this.iface.generarEstructura(curLV)) {
				return false;
			}
			break;
		}
		case curLV.Edit: {
			var cantidad:String = curLV.valueBuffer("cantidad");
			var cantidadAnterior:String = curLV.valueBufferCopy("cantidad");
			var referencia:String = curLV.valueBuffer("referencia");
			var referenciaAnterior:String = curLV.valueBufferCopy("referencia");
			if (cantidad != cantidadAnterior || referencia != referenciaAnterior) {
				if (!this.iface.borrarEstructura(curLV)) {
					return false;
				}
				if (!this.iface.generarEstructura(curLV)) {
					return false;
				}
			}
			break;
		}
		case curLV.Del: {
			if (!this.iface.borrarEstructura(curLV)) {
				return false;
			}
			break;
		}
	}
	return true;
}

function articuloscomp_controlStockPedidosProv(curLP:FLSqlCursor):Boolean
{
	switch (curLP.modeAccess()) {
		case curLP.Insert: {
			if (!this.iface.generarEstructura(curLP)) {
				return false;
			}
			break;
		}
		case curLP.Edit: {
			var cantidad:String = curLP.valueBuffer("cantidad");
			var cantidadAnterior:String = curLP.valueBufferCopy("cantidad");
			var referencia:String = curLP.valueBuffer("referencia");
			var referenciaAnterior:String = curLP.valueBufferCopy("referencia");
			var cerrada:Boolean = curLP.valueBuffer("cerrada");
			var cerradaAnterior:Boolean = curLP.valueBufferCopy("cerrada");
			if (cantidad != cantidadAnterior || referencia != referenciaAnterior || cerrada != cerradaAnterior) {
				if (!this.iface.borrarEstructura(curLP)) {
					return false;
				}
				if (!this.iface.generarEstructura(curLP)) {
					return false;
				}
			}
			break;
		}
		case curLP.Del: {
			if (!this.iface.borrarEstructura(curLP)) {
				return false;
			}
			break;
		}
	}
	return true;
}

function articuloscomp_controlStockAlbaranesCli(curLA:FLSqlCursor):Boolean
{
	var idLineaPedido:String = curLA.valueBuffer("idlineapedido");
	var idLineaAlbaran:String = curLA.valueBuffer("idlinea");

	if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
		switch (curLA.modeAccess()) {
			case curLA.Insert: {
				if (!this.iface.albaranarLineaPedCli(idLineaPedido, curLA)) {
					return false;
				}
				break;
			}
			case curLA.Edit: {
				var cantidad:Number = parseFloat(curLA.valueBuffer("cantidad"));
				var cantidadPrevia:Number = parseFloat(curLA.valueBufferCopy("cantidad"));
				if (cantidad == cantidadPrevia) {
					break;
				}
				if (!this.iface.desalbaranarLineaPedCli(idLineaPedido, idLineaAlbaran)) {
					return false;
				}
				if (!this.iface.albaranarParcialLPC(idLineaPedido, curLA)) {
					return false;
				}
				break;
			}
			case curLA.Del: {
				if (!this.iface.desalbaranarLineaPedCli(idLineaPedido, idLineaAlbaran)) {
					return false;
				}
				break;
			}
		}
	} else {
		switch (curLA.modeAccess()) {
			case curLA.Insert: {
				if (!this.iface.generarEstructura(curLA)) {
					return false;
				}
				break;
			}
			case curLA.Edit: {
				var cantidad:String = curLA.valueBuffer("cantidad");
				var cantidadAnterior:String = curLA.valueBufferCopy("cantidad");
				var referencia:String = curLA.valueBuffer("referencia");
				var referenciaAnterior:String = curLA.valueBufferCopy("referencia");
				if (cantidad != cantidadAnterior || referencia != referenciaAnterior) {
					if (!this.iface.borrarEstructura(curLA)) {
						return false;
					}
					if (!this.iface.generarEstructura(curLA)) {
						return false;
					}
				}
				break;
			}
			case curLA.Del: {
				if (!this.iface.borrarEstructura(curLA)) {
					return false;
				}
				break;
			}
		}
	}
	return true;
}

function articuloscomp_controlStockAlbaranesProv(curLA:FLSqlCursor):Boolean
{
	var idLineaPedido:String = curLA.valueBuffer("idlineapedido");
	var idLineaAlbaran:String = curLA.valueBuffer("idlinea");

	if (idLineaPedido && idLineaPedido != "" && idLineaPedido != 0) {
		switch (curLA.modeAccess()) {
			case curLA.Insert: {
				if (!this.iface.albaranarLineaPedProv(idLineaPedido, curLA)) {
					return false;
				}
				break;
			}
			case curLA.Edit: {
				var cantidad:Number = parseFloat(curLA.valueBuffer("cantidad"));
				var cantidadPrevia:Number = parseFloat(curLA.valueBufferCopy("cantidad"));
				if (cantidad == cantidadPrevia) {
					break;
				}
				if (!this.iface.desalbaranarLineaPedProv(idLineaPedido, idLineaAlbaran)) {
					return false;
				}
				if (!this.iface.albaranarParcialLPP(idLineaPedido, curLA)) {
					return false;
				}
				break;
			}
			case curLA.Del: {
				if (!this.iface.desalbaranarLineaPedProv(idLineaPedido, idLineaAlbaran)) {
					return false;
				}
				break;
			}
		}
	} else {
		switch (curLA.modeAccess()) {
			case curLA.Insert: {
				if (!this.iface.generarEstructura(curLA)) {
					return false;
				}
				break;
			}
			case curLA.Edit: {
				var cantidad:String = curLA.valueBuffer("cantidad");
				var cantidadAnterior:String = curLA.valueBufferCopy("cantidad");
				var referencia:String = curLA.valueBuffer("referencia");
				var referenciaAnterior:String = curLA.valueBufferCopy("referencia");
				if (cantidad != cantidadAnterior || referencia != referenciaAnterior) {
					if (!this.iface.borrarEstructura(curLA)) {
						return false;
					}
					if (!this.iface.generarEstructura(curLA)) {
						return false;
					}
				}
				break;
			}
			case curLA.Del: {
				if (!this.iface.borrarEstructura(curLA)) {
					return false;
				}
				break;
			}
		}
	}
	return true;
}

function articuloscomp_controlStockFacturasCli(curLF:FLSqlCursor)
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
		return true;
	}
	if (util.sqlSelect("facturascli", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}
	switch (curLF.modeAccess()) {
		case curLF.Insert: {
			if (!this.iface.generarEstructura(curLF)) {
				return false;
			}
			break;
		}
		case curLF.Edit: {
			var cantidad:String = curLF.valueBuffer("cantidad");
			var cantidadAnterior:String = curLF.valueBufferCopy("cantidad");
			var referencia:String = curLF.valueBuffer("referencia");
			var referenciaAnterior:String = curLF.valueBufferCopy("referencia");
			if (cantidad != cantidadAnterior || referencia != referenciaAnterior) {
				if (!this.iface.borrarEstructura(curLF)) {
					return false;
				}
				if (!this.iface.generarEstructura(curLF)) {
					return false;
				}
			}
			break;
		}
		case curLF.Del: {
			if (!this.iface.borrarEstructura(curLF)) {
				return false;
			}
			break;
		}
	}
	return true;
}

function articuloscomp_controlStockFacturasProv(curLF:FLSqlCursor)
{
	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
		return true;
	}
	if (util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"))) {
		return true;
	}
	switch (curLF.modeAccess()) {
		case curLF.Insert: {
			if (!this.iface.generarEstructura(curLF)) {
				return false;
			}
			break;
		}
		case curLF.Edit: {
			var cantidad:String = curLF.valueBuffer("cantidad");
			var cantidadAnterior:String = curLF.valueBufferCopy("cantidad");
			var referencia:String = curLF.valueBuffer("referencia");
			var referenciaAnterior:String = curLF.valueBufferCopy("referencia");
			if (cantidad != cantidadAnterior || referencia != referenciaAnterior) {
				if (!this.iface.borrarEstructura(curLF)) {
					return false;
				}
				if (!this.iface.generarEstructura(curLF)) {
					return false;
				}
			}
			break;
		}
		case curLF.Del: {
			if (!this.iface.borrarEstructura(curLF)) {
				return false;
			}
			break;
		}
	}

	return true;
}

function articuloscomp_controlStockLineasTrans(curLTS:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("articulos", "nostock", "referencia = '" + curLTS.valueBuffer("referencia") + "'")) {
		return true;
	}
	switch (curLTS.modeAccess()) {
		case curLTS.Insert: {
			if (!this.iface.generarEstructura(curLTS)) {
				return false;
			}
			break;
		}
		case curLTS.Edit: {
			var cantidad:String = curLTS.valueBuffer("cantidad");
			var cantidadAnterior:String = curLTS.valueBufferCopy("cantidad");
			var referencia:String = curLTS.valueBuffer("referencia");
			var referenciaAnterior:String = curLTS.valueBufferCopy("referencia");
			if (cantidad != cantidadAnterior || referencia != referenciaAnterior) {
				if (!this.iface.borrarEstructura(curLTS)) {
					return false;
				}
				if (!this.iface.generarEstructura(curLTS)) {
					return false;
				}
			}
			break;
		}
		case curLTS.Del: {
			if (!this.iface.borrarEstructura(curLTS)) {
				return false;
			}
			break;
		}
	}

	return true;
}

/** \C Marca como HECHO los movimientos asociados a un línea de pedido, y los asocia a la línea de albarán
@param	idLineaPedido: Identificador de la línea de pedido
@param	curLA: Cursor posicionado en la línea de albarán
\end */
function articuloscomp_albaranarLineaPedCli(idLineaPedido:String, curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var idLineaAlbaran:String = curLA.valueBuffer("idlinea");
	var fechaAlbaran:String;
	var horaAlbaran:String;
	var curAlbaran:FLSqlCursor = curLA.cursorRelation();
	if (curAlbaran) {
		fechaAlbaran = curAlbaran.valueBuffer("fecha");
		horaAlbaran = curAlbaran.valueBuffer("hora");
	} else {
		fechaAlbaran = util.sqlSelect("albaranescli", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));
		horaAlbaran = util.sqlSelect("albaranescli", "hora", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	}
	if (!fechaAlbaran) {
		return false;
	}

	horaAlbaran = horaAlbaran.toString();
	var hora:String = horaAlbaran.right(8);

	var curMoviStock:FLSqlCursor = new FLSqlCursor("movistock");
	curMoviStock.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE'");
	while (curMoviStock.next()) {
		curMoviStock.setModeAccess(curMoviStock.Edit);
		curMoviStock.refreshBuffer();
		curMoviStock.setValueBuffer("estado", "HECHO");
		curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
		curMoviStock.setValueBuffer("horareal", hora);
		curMoviStock.setValueBuffer("idlineaac", idLineaAlbaran);
		if (!curMoviStock.commitBuffer()) {
			return false;
		}
	}
	return true;
}

/** \C Marca como HECHO los movimientos asociados a un línea de pedido, y los asocia a la línea de albarán
@param	idLineaPedido: Identificador de la línea de pedido
@param	curLA: Cursor posicionado en la línea de albarán
\end */
function articuloscomp_albaranarLineaPedProv(idLineaPedido:String, curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var idLineaAlbaran:String = curLA.valueBuffer("idlinea");
	var fechaAlbaran:String;
	var horaAlbaran:String;
	var curAlbaran:FLSqlCursor = curLA.cursorRelation();
	if (curAlbaran) {
		fechaAlbaran = curAlbaran.valueBuffer("fecha");
		horaAlbaran = curAlbaran.valueBuffer("hora");
	} else {
		fechaAlbaran = util.sqlSelect("albaranesprov", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));
		horaAlbaran = util.sqlSelect("albaranesprov", "hora", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	}
	if (!fechaAlbaran) {
		return false;
	}

	horaAlbaran = horaAlbaran.toString();
	var hora:String = horaAlbaran.right(8);

	var curMoviStock:FLSqlCursor = new FLSqlCursor("movistock");
	curMoviStock.select("idlineapp = " + idLineaPedido + " AND estado = 'PTE'");
	while (curMoviStock.next()) {
		curMoviStock.setModeAccess(curMoviStock.Edit);
		curMoviStock.refreshBuffer();
		curMoviStock.setValueBuffer("estado", "HECHO");
		curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
		curMoviStock.setValueBuffer("horareal", hora);
		curMoviStock.setValueBuffer("idlineaap", idLineaAlbaran);
		if (!curMoviStock.commitBuffer())
			return false;
	}
	return true;
}

/** \C Marca como PTE los movimientos asociados a un línea de albaran, y los desasocia de la línea. Si hay otros movimientos en estado PTE asociados a la línea de pedido, los unifica
@param	idLineaPedido: Identificador de la línea de pedido
@param	idLineaAlbaran: Identificador de la línea de albarán
\end */
function articuloscomp_desalbaranarLineaPedCli(idLineaPedido:String, idLineaAlbaran:String):Boolean
{
debug("articuloscomp_desalbaranarLineaPedCli");
	var util:FLUtil = new FLUtil;

	var curMoviStock:FLSqlCursor = new FLSqlCursor("movistock");
	curMoviStock.select("idlineaac = " + idLineaAlbaran);
	var idMovimientoPte:String;
	while (curMoviStock.next()) {
		curMoviStock.setModeAccess(curMoviStock.Edit);
		curMoviStock.refreshBuffer();
		curMoviStock.setValueBuffer("estado", "PTE");
		curMoviStock.setNull("fechareal");
		curMoviStock.setNull("horareal");
		curMoviStock.setNull("idlineaac");
		if (!curMoviStock.commitBuffer()) {
			return false;
		}
	}
	if (!this.iface.unificarMovPtePC(idLineaPedido)) {
		return false;
	}

	return true;
}

/** \C Marca como PTE los movimientos asociados a un línea de albaran, y los desasocia de la línea. Si hay otros movimientos en estado PTE asociados a la línea de pedido, los unifica
@param	idLineaPedido: Identificador de la línea de pedido
@param	idLineaAlbaran: Identificador de la línea de albarán
\end */
function articuloscomp_desalbaranarLineaPedProv(idLineaPedido:String, idLineaAlbaran:String):Boolean
{
	var util:FLUtil = new FLUtil;

	var curMoviStock:FLSqlCursor = new FLSqlCursor("movistock");
	curMoviStock.select("idlineaap = " + idLineaAlbaran);
	var idMovimientoPte:String;
	while (curMoviStock.next()) {
		curMoviStock.setModeAccess(curMoviStock.Edit);
		curMoviStock.refreshBuffer();
		curMoviStock.setValueBuffer("estado", "PTE");
		curMoviStock.setNull("fechareal");
		curMoviStock.setNull("horareal");
		curMoviStock.setNull("idlineaap");
		if (!curMoviStock.commitBuffer()) {
			return false;
		}
	}
	if (!this.iface.unificarMovPtePP(idLineaPedido)) {
		return false;
	}

	return true;
}

/** \C Unifica en un único movimiento todos los movimientos pendientes asociados a la misma línea de pedido y lote (para cada referencia -esto se usa cuando el artículo es compuesto-)
@param	idLineaPedido: Identificador de la línea de pedido
\end */
function articuloscomp_unificarMovPtePC(idLineaPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryReferencia:FLSqlQuery = new FLSqlQuery;
	with (qryReferencia) {
		setTablesList("movistock");
		setSelect("idstock, codlote, SUM(cantidad)");
		setFrom("movistock");
		setWhere("idlineapc = " + idLineaPedido + " AND estado = 'PTE' GROUP BY idstock, codlote");
		setForwardOnly(true);
	}
	if (!qryReferencia.exec()) {
		return false;
	}
	var cantidadPte:Number;
	var idMovimiento:String;
	var codLote:String;
	var whereMov:String;
	while (qryReferencia.next()) {
		cantidadPte = parseFloat(qryReferencia.value("SUM(cantidad)"));
		if (!cantidadPte || isNaN(cantidadPte)) {
			return true;
		}
		whereMov = "idlineapc = " + idLineaPedido + " AND estado = 'PTE' AND idstock = " + qryReferencia.value("idstock");
		codLote = qryReferencia.value("codlote");
		if (codLote && codLote != "") {
			whereMov += " AND codlote = '" + qryReferencia.value("codlote") + "'";
		}
		idMovimiento = util.sqlSelect("movistock", "idmovimiento", whereMov);
		if (!idMovimiento) {
			return true;
		}
		if (!util.sqlDelete("movistock", whereMov + " AND idmovimiento <> " + idMovimiento)) {
// 		"idlineapc = " + idLineaPedido + " AND estado = 'PTE' AND idmovimiento <> " + idMovimiento + " AND idstock = " + qryReferencia.value("idstock") + " AND codlote = '" + qryReferencia.value("codlote") + "'")) {
			return false;
		}
		if (!util.sqlUpdate("movistock", "cantidad", cantidadPte, "idmovimiento = " + idMovimiento)) {
			return false;
		}
	}
	return true;
}

/** \C Unifica en un único movimiento todos los movimientos pendientes asociados a una línea de pedido (para cada referencia -esto se usa cuando el artículo es compuesto-)
@param	idLineaPedido: Identificador de la línea de pedido
\end */
function articuloscomp_unificarMovPtePP(idLineaPedido:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryReferencia:FLSqlQuery = new FLSqlQuery;
	with (qryReferencia) {
		setTablesList("movistock");
		setSelect("idstock, codlote, SUM(cantidad)");
		setFrom("movistock");
		setWhere("idlineapp = " + idLineaPedido + " AND estado = 'PTE' GROUP BY idstock, codlote");
		setForwardOnly(true);
	}
	if (!qryReferencia.exec()) {
		return false;
	}
	var cantidadPte:Number;
	var idMovimiento:String;
	var codLote:String;
	var whereMov:String;
	while (qryReferencia.next()) {
		cantidadPte = parseFloat(qryReferencia.value("SUM(cantidad)"));
		if (!cantidadPte || isNaN(cantidadPte)) {
			return true;
		}
		whereMov = "idlineapp = " + idLineaPedido + " AND estado = 'PTE' AND idstock = " + qryReferencia.value("idstock");
		codLote = qryReferencia.value("codlote");
		if (codLote && codLote != "") {
			whereMov += " AND codlote = '" + qryReferencia.value("codlote") + "'";
		}
		idMovimiento = util.sqlSelect("movistock", "idmovimiento", whereMov);
		if (!idMovimiento) {
			return true;
		}
		if (!util.sqlDelete("movistock", whereMov + " AND idmovimiento <> " + idMovimiento)) {
// 		"idlineapp = " + idLineaPedido + " AND estado = 'PTE' AND idmovimiento <> " + idMovimiento + " AND idstock = " + qryReferencia.value("idstock"))) {
			return false;
		}
		if (!util.sqlUpdate("movistock", "cantidad", cantidadPte, "idmovimiento = " + idMovimiento)) {
			return false;
		}
	}
	return true;
}

/** \C Divide los movimientos pendientes de una línea de pedido y asocia la parte correspondiente a una línea de albarán
@param	idLineaPedido: Identificador de la línea de pedido
@param	curLA: Cursor posicionado en la línea de albarán
\end */
function articuloscomp_albaranarParcialLPC(idLineaPedido:String, curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curMoviStock)
		this.iface.curMoviStock = new FLSqlCursor("movistock");

	var cantidadPedido:Number = parseFloat(util.sqlSelect("lineaspedidoscli", "cantidad", "idlinea = "  + idLineaPedido));
debug("cantidadPedido = " + cantidadPedido);
	var fechaAlbaran:String;
	var horaAlbaran:String;
	var curAlbaran:FLSqlCursor = curLA.cursorRelation();
	if (curAlbaran) {
		fechaAlbaran = curAlbaran.valueBuffer("fecha");
		horaAlbaran = curAlbaran.valueBuffer("hora");
	}
	else {
		fechaAlbaran = util.sqlSelect("albaranescli", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));
		horaAlbaran = util.sqlSelect("albaranescli", "hora", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	}
	if (!fechaAlbaran) {
		return false;
	}
	horaAlbaran = horaAlbaran.toString();
	var hora:String = horaAlbaran.right(8);

	var curMSOrigen:FLSqlCursor = new FLSqlCursor("movistock");
	curMSOrigen.select("idlineapc = " + idLineaPedido + " AND estado = 'PTE'");
	var cantidadPte:Number;
	var cantidadAlb:Number;
	var factor:Number;
	var cantidadMovi:Number;
	while (curMSOrigen.next()) {
		curMSOrigen.setModeAccess(curMSOrigen.Edit);
		curMSOrigen.refreshBuffer();

		cantidadMovi = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineapc = "  + 	idLineaPedido + " AND idstock = " + curMSOrigen.valueBuffer("idstock")));
debug("cantidadMovi = " + cantidadMovi);
		if (isNaN(cantidadMovi)) {
			cantidadMovi = 0;
		}
		factor = cantidadMovi / cantidadPedido;

		cantidadPte = curMSOrigen.valueBuffer("cantidad");
		cantidadAlb = curLA.valueBuffer("cantidad") * factor;
		cantidadPte -= cantidadAlb;
		if (cantidadPte > 0) {
			MessageBox.warning(util.translate("scripts", "No puede establecer una cantidad albaranada superior a la cantidad de la línea de pedido asociada.\nSi realmente va a servir más cantidad que la pedida indíquelo en una nueva línea de albarán"), MessageBox.Ok,  MessageBox.NoButton);
			return false;
		}
		cantidadPte = util.roundFieldValue(cantidadPte, "movistock", "cantidad");
		cantidadAlb = util.roundFieldValue(cantidadAlb, "movistock", "cantidad");

		if (cantidadAlb == 0) {
			return false;
		}
		this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
		this.iface.curMoviStock.refreshBuffer();
		if (!this.iface.copiaDatosMoviStock(curMSOrigen)) {
			return false;
		}
		this.iface.curMoviStock.setValueBuffer("cantidad", cantidadAlb);
		this.iface.curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
		this.iface.curMoviStock.setValueBuffer("horareal", hora);
		this.iface.curMoviStock.setValueBuffer("idlineaac", curLA.valueBuffer("idlinea"));
		this.iface.curMoviStock.setValueBuffer("idlineapc", curMSOrigen.valueBuffer("idlineapc"));

		if (cantidadPte == 0) {
			curMSOrigen.setModeAccess(curMSOrigen.Del);
			curMSOrigen.refreshBuffer();
		} else {
			curMSOrigen.setValueBuffer("cantidad", cantidadPte);
		}

		if (!curMSOrigen.commitBuffer())
			return false;

		if (!this.iface.curMoviStock.commitBuffer())
			return false;
	}
	return true;
}

/** \C Divide los movimientos pendientes de una línea de pedido y asocia la parte correspondiente a una línea de albarán
@param	idLineaPedido: Identificador de la línea de pedido
@param	curLA: Cursor posicionado en la línea de albarán
\end */
function articuloscomp_albaranarParcialLPP(idLineaPedido:String, curLA:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	if (!this.iface.curMoviStock) {
		this.iface.curMoviStock = new FLSqlCursor("movistock");
	}
	var cantidadPedido:Number = parseFloat(util.sqlSelect("lineaspedidosprov", "cantidad", "idlinea = "  + idLineaPedido));

	var fechaAlbaran:String;
	var horaAlbaran:String;
	var curAlbaran:FLSqlCursor = curLA.cursorRelation();
	if (curAlbaran) {
		fechaAlbaran = curAlbaran.valueBuffer("fecha");
		horaAlbaran = curAlbaran.valueBuffer("hora");
	} else {
		fechaAlbaran = util.sqlSelect("albaranesprov", "fecha", "idalbaran = " + curLA.valueBuffer("idalbaran"));
		horaAlbaran = util.sqlSelect("albaranesprov", "hora", "idalbaran = " + curLA.valueBuffer("idalbaran"));
	}
	if (!fechaAlbaran) {
		return false;
	}
	horaAlbaran = horaAlbaran.toString();
	var hora:String = horaAlbaran.right(8);

	var curMSOrigen:FLSqlCursor = new FLSqlCursor("movistock");
	curMSOrigen.select("idlineapp = " + idLineaPedido + " AND estado = 'PTE'");
	var cantidadPte:Number;
	var cantidadAlb:Number;
	var factor:Number;
	var cantidadMovi:Number;
	while (curMSOrigen.next()) {
		curMSOrigen.setModeAccess(curMSOrigen.Edit);
		curMSOrigen.refreshBuffer();

		cantidadMovi = parseFloat(util.sqlSelect("movistock", "SUM(cantidad)", "idlineapp = "  + idLineaPedido + " AND idstock = " + curMSOrigen.valueBuffer("idstock")));
		if (isNaN(cantidadMovi)) {
			cantidadMovi = 0;
		}
		factor = cantidadMovi / cantidadPedido;

		cantidadPte = curMSOrigen.valueBuffer("cantidad");
		cantidadAlb = curLA.valueBuffer("cantidad") * factor;
		cantidadPte -= cantidadAlb;
		if (cantidadPte < 0) {
			MessageBox.warning(util.translate("scripts", "No puede establecer una cantidad albaranada superior a la cantidad de la línea de pedido asociada.\nSi realmente va a servir más cantidad que la pedida indíquelo en una nueva línea de albarán"), MessageBox.Ok,  MessageBox.NoButton);
			return false;
		}
		cantidadPte = util.roundFieldValue(cantidadPte, "movistock", "cantidad");
		cantidadAlb = util.roundFieldValue(cantidadAlb, "movistock", "cantidad");

		if (cantidadAlb == 0)
			return false;

		this.iface.curMoviStock.setModeAccess(this.iface.curMoviStock.Insert);
		this.iface.curMoviStock.refreshBuffer();

		if (!this.iface.copiaDatosMoviStock(curMSOrigen))
			return false;

		this.iface.curMoviStock.setValueBuffer("cantidad", cantidadAlb);
		this.iface.curMoviStock.setValueBuffer("fechareal", fechaAlbaran);
		this.iface.curMoviStock.setValueBuffer("horareal", hora);
		this.iface.curMoviStock.setValueBuffer("idlineaap", curLA.valueBuffer("idlinea"));
		this.iface.curMoviStock.setValueBuffer("idlineapp", curMSOrigen.valueBuffer("idlineapp"));

		if (cantidadPte == 0) {
			curMSOrigen.setModeAccess(curMSOrigen.Del);
			curMSOrigen.refreshBuffer();
		} else {
			curMSOrigen.setValueBuffer("cantidad", cantidadPte);
		}

		if (!curMSOrigen.commitBuffer())
			return false;

		if (!this.iface.curMoviStock.commitBuffer())
			return false;
	}
	return true;
}

function articuloscomp_copiaDatosMoviStock(curMSOrigen:FLSqlCursor):Boolean
{
	with (this.iface.curMoviStock) {
		setValueBuffer("referencia", curMSOrigen.valueBuffer("referencia"));
		setValueBuffer("estado", "HECHO");
		setValueBuffer("fechaprev", curMSOrigen.valueBuffer("fechaprev"));
		setValueBuffer("idstock", curMSOrigen.valueBuffer("idstock"));
		setValueBuffer("codlote", curMSOrigen.valueBuffer("codlote"));
		setValueBuffer("codloteprod", curMSOrigen.valueBuffer("codloteprod"));
	}
	if (curMSOrigen.isNull("idarticulocomp")) {
		this.iface.curMoviStock.setNull("idarticulocomp");
	} else {
		this.iface.curMoviStock.setValueBuffer("idarticulocomp", curMSOrigen.valueBuffer("idarticulocomp"));
	}
	if (curMSOrigen.isNull("idtipotareapro")) {
		this.iface.curMoviStock.setNull("idtipotareapro");
	} else {
		this.iface.curMoviStock.setValueBuffer("idtipotareapro", curMSOrigen.valueBuffer("idtipotareapro"));
	}

	return true;
}


/** \D Borra la estructura de lotes de stock y salidas programadas asociada a los artículos pedidos
\end */
function articuloscomp_borrarEstructura(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var referencia:String = curLinea.valueBuffer("referencia");
	if (!referencia || referencia == "") {
		return true;
	}
	if (!this.iface.borrarMoviStock(curLinea)) {
		return false;
	}
	return true;
}

/** \D Borra los movimientos de stock asociados a una línea de pedido
@param	idLinea: Identificador de la línea de pedido
@return	true si los movimientos se borrar correctamente, false en caso contrario
\end */
function articuloscomp_borrarMoviStock(curLinea:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var tabla:String = curLinea.table();
	var idLinea:String;

	switch (tabla) {
		case "lineaspresupuestoscli": {
			idLinea = curLinea.valueBuffer("idlinea");
			if (!util.sqlDelete("movistock", "idlineapr = " + idLinea))
				return false;
			break;
		}
		case "lineaspedidoscli": {
			idLinea = curLinea.valueBuffer("idlinea");
			if (!util.sqlDelete("movistock", "idlineapc = " + idLinea + " AND (idlineaac IS NULL OR idlineaac = 0)"))
				return false;
			break;
		}
		case "lineaspedidosprov": {
			idLinea = curLinea.valueBuffer("idlinea");
			if (!util.sqlDelete("movistock", "idlineapp = " + idLinea + " AND (idlineaap IS NULL OR idlineaap = 0)"))
				return false;
			break;
		}
		case "lineastransstock": {
			idLinea = curLinea.valueBuffer("idlinea");
			if (!util.sqlDelete("movistock", "idlineats = " + idLinea))
				return false;
			break;
		}
		case "tpv_lineascomanda": {
			idLinea = curLinea.valueBuffer("idtpv_linea");
			if (!util.sqlDelete("movistock", "idlineaco = " + idLinea))
				return false;
			break;
		}
		case "tpv_lineasvale": {
			idLinea = curLinea.valueBuffer("idlinea");
			if (!util.sqlDelete("movistock", "idlineava = " + idLinea))
				return false;
			break;
		}
		case "lineasalbaranescli": {
			idLinea = curLinea.valueBuffer("idlinea");
			var idLineaPedido:Number = parseFloat(curLinea.valueBuffer("idlineapedido"));

			if (!idLineaPedido || isNaN(idLineaPedido)) {
				if (!util.sqlDelete("movistock", "idlineaac = " + idLinea))
					return false;
			} else {
				if (!util.sqlUpdate("movistock", "idlineaac, fechareal, horareal, estado", "NULL,NULL,NULL,PTE", "idlineaac = " + idLinea))
					return false;
			}
			break;
		}
		case "lineasalbaranesprov": {
			idLinea = curLinea.valueBuffer("idlinea");
			var idLineaPedido:Number = parseFloat(curLinea.valueBuffer("idlineapedido"));
			if (!idLineaPedido || isNaN(idLineaPedido)) {
				if (!util.sqlDelete("movistock", "idlineaap = " + idLinea))
					return false;
			} else {
				if (!util.sqlUpdate("movistock", "idlineaap, fechareal, horareal, estado", "NULL,NULL,NULL,PTE", "idlineaap = " + idLinea))
					return false;
			}
			break;
		}
		case "lineasfacturascli": {
			idLinea = curLinea.valueBuffer("idlinea");
			if (!util.sqlDelete("movistock", "idlineafc = " + idLinea + " AND (idlineaac IS NULL OR idlineaac = 0)"))
				return false;
			break;
		}
		case "lineasfacturasprov": {
			idLinea = curLinea.valueBuffer("idlinea");
			if (!util.sqlDelete("movistock", "idlineafp = " + idLinea + " AND (idlineaap IS NULL OR idlineaap = 0)"))
				return false;
			break;
		}
	}

	return true;
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

