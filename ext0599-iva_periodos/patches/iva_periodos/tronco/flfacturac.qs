
/** @class_declaration pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTI /////////////////////////////////////////////////
class pagosMulti extends oficial {
	function pagosMulti( context ) { oficial ( context ); }
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.pagosMulti_datosConceptoAsiento(cur);
	}
}
//// PAGOS_MULTIPLES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration centrosCoste */
//////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////
class centrosCoste extends pagosMulti
{
	function centrosCoste( context ) { pagosMulti( context ); }
	function regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array):Array {
		return this.ctx.centrosCoste_regenerarAsiento(curFactura, valoresDefecto);
	}
	function generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_generarAsientoFacturaCli(curFactura);
	}
	function generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_generarAsientoFacturaProv(curFactura);
	}
	function crearPartidasCC(curFactura:FLSqlCursor):Boolean {
		return this.ctx.centrosCoste_crearPartidasCC(curFactura);
	}
}
//// CENTROS COSTE /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration cambioIva */
/////////////////////////////////////////////////////////////////
//// CAMBIO_IVA /////////////////////////////////////////////////
class cambioIva extends centrosCoste {
	var curLineaDoc_:FLSqlCursor;
	function cambioIva( context ) { centrosCoste ( context ); }
	function campoImpuesto(campo:String, codImpuesto:String, fecha:String):Number {
		return this.ctx.cambioIva_campoImpuesto(campo, codImpuesto, fecha);
	}
	function datosImpuesto(codImpuesto:String, fecha:String):Array {
		return this.ctx.cambioIva_datosImpuesto(codImpuesto, fecha);
	}
	function validarIvas(curDoc:FLSqlCursor):Boolean {
		return this.ctx.cambioIva_validarIvas(curDoc);
	}
	function actualizarIvaLineasFecha(tabla:String, nombrePK:String, valorClave:String, fecha:String):Boolean {
		return this.ctx.cambioIva_actualizarIvaLineasFecha(tabla, nombrePK, valorClave, fecha);
	}
	function datosLineaDocIva():Boolean {
		return this.ctx.cambioIva_datosLineaDocIva();
	}
}
//// CAMBIO_IVA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
class liqAgentes extends cambioIva {
	function liqAgentes( context ) { cambioIva ( context ); }
	function afterCommit_facturasprov(curFactura:FLSqlCursor):Boolean {
		return this.ctx.liqAgentes_afterCommit_facturasprov(curFactura);
	}
}
//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration factPeriodica */
//////////////////////////////////////////////////////////////////
//// FACTURACION_PERIODICA /////////////////////////////////////////////////////
class factPeriodica extends liqAgentes {
	function factPeriodica( context ) { liqAgentes( context ); }
	function beforeCommit_facturascli(curFactura:FLSqlCursor):Boolean {
		return this.ctx.factPeriodica_beforeCommit_facturascli(curFactura);
	}
	function beforeCommit_periodoscontratos(curFactura:FLSqlCursor):Boolean {
		return this.ctx.factPeriodica_beforeCommit_periodoscontratos(curFactura);
	}
}
//// FACTURACION_PERIODICA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends factPeriodica {
    function pedProvCli( context ) { factPeriodica ( context ); }
	function beforeCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_lineaspedidoscli(curLP);
	}
	function beforeCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_lineaspedidosprov(curLP);
	}
	function beforeCommit_pedidoscli(curPedido:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_pedidoscli(curPedido);
	}
	function beforeCommit_pedidosprov(curPedido:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_beforeCommit_pedidosprov(curPedido);
	}
	function afterCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_afterCommit_lineaspedidoscli(curLP);
	}
	function afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_afterCommit_lineaspedidosprov(curLP);
	}
	function estadoPedidoCliProv(idPedido:String):String {
		return this.ctx.pedProvCli_estadoPedidoCliProv(idPedido);
	}
	function actualizarCampoPedidoPedCli(idPedido:String):Boolean {
		return this.ctx.pedProvCli_actualizarCampoPedidoPedCli(idPedido);
	}
	function actualizarEstadoPedidoProv(idPedido:Number, curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.pedProvCli_actualizarEstadoPedidoProv(idPedido, curAlbaran);
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
class proveed extends pedProvCli {
	function proveed( context ) { pedProvCli ( context ); }
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.proveed_datosConceptoAsiento(cur);
	}
}
//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTIPROV /////////////////////////////////////////////
class pagosMultiProv extends proveed {
	function pagosMultiProv( context ) { proveed ( context ); }
// 	function regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array {
// 		return this.ctx.pagosMultiProv_regenerarAsiento(cur, valoresDefecto);
// 	}
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.pagosMultiProv_datosConceptoAsiento(cur);
	}
}
//// PAGOSMULTIPROV /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pagaresProv */
/////////////////////////////////////////////////////////////////
//// PAGARES_PROV //////////////////////////////////////////////
class pagaresProv extends pagosMultiProv {
	function pagaresProv( context ) { pagosMultiProv ( context ); }
	function datosConceptoAsiento(cur:FLSqlCursor):Array {
		return this.ctx.pagaresProv_datosConceptoAsiento(cur);
	}
}
//// PAGARES_PROV //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ///////////////////////////////////////////////
class ivaIncluido extends pagaresProv {
	function ivaIncluido( context ) { pagaresProv ( context ); }
	function datosLineaDocIva():Boolean {
		return this.ctx.ivaIncluido_datosLineaDocIva();
	}
}
//// IVA INCLUIDO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration funServiciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
class funServiciosCli extends ivaIncluido {
	function funServiciosCli( context ) { ivaIncluido ( context ); }
	function afterCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean {
		return this.ctx.funServiciosCli_afterCommit_albaranescli(curAlbaran);
	}
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ctaVentaArt */
//////////////////////////////////////////////////////////////////
//// CTA_VENTA_ART////////////////////////////////////////////////
class ctaVentaArt extends funServiciosCli {
	function ctaVentaArt( context ) { funServiciosCli ( context ); }
	function generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array):Boolean {
		return this.ctx.ctaVentaArt_generarPartidasVenta(curFactura, idAsiento, valoresDefecto);
	}
	function subcuentaVentas(referencia:String, codEjercicio:String):Array {
		return this.ctx.ctaVentaArt_subcuentaVentas(referencia, codEjercicio);
	}
}
//// CTA_VENTA_ART////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends ctaVentaArt {
	function funNumSerie( context ) { ctaVentaArt( context ); }
	function afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasalbaranesprov(curLA);
	}
	function afterCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasfacturasprov(curLF);
	}
	function afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasalbaranescli(curLA);
	}
	function afterCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasfacturascli(curLF);
	}
	function beforeCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_beforeCommit_lineasfacturascli(curLF);
	}
	function beforeCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_beforeCommit_lineasfacturasprov(curLF);
	}
	function actualizarLineaPedidoCli(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.funNumSerie_actualizarLineaPedidoCli(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function actualizarLineaPedidoProv(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.funNumSerie_actualizarLineaPedidoProv(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration pubCambioIva */
/////////////////////////////////////////////////////////////////
//// PUB CAMBIO IVA /////////////////////////////////////////////
class pubCambioIva extends ifaceCtx {
	function pubCambioIva( context ) { ifaceCtx( context ); }
	function pub_validarIvas(curDoc:FLSqlCursor):Boolean {
		return this.validarIvas(curDoc);
	}
}
//// PUB CAMBIO IVA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration  pubPedCliProv */
/////////////////////////////////////////////////////////////////
//// PUB PED CLI PROV ///////////////////////////////////////////
class pubPedCliProv extends pubCambioIva {
	function pubPedCliProv( context ) { pubCambioIva( context ); }
	function pub_estadoPedidoCliProv(idPedido:String):String {
		return this.estadoPedidoCliProv(idPedido);
	}
}
//// PUB PED CLI PROV ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMulti */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTI /////////////////////////////////////////////////
function pagosMulti_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "pagosmulticli": {
			var listaRecibos:String = "";
			var qryRecibos:FLSqlQuery = new FLSqlQuery();
			qryRecibos.setTablesList("reciboscli,pagosdevolcli");
			qryRecibos.setSelect("r.codigo, r.nombrecliente");
			qryRecibos.setFrom("pagosdevolcli p INNER JOIN reciboscli r ON p.idrecibo = r.idrecibo ")
			qryRecibos.setWhere("p.idpagomulti = " + cur.valueBuffer("idpagomulti"));
			qryRecibos.setForwardOnly( true );

			if (!qryRecibos.exec())
				return false;

			while (qryRecibos.next()) {
				if (listaRecibos != "")
					listaRecibos += ", ";
				listaRecibos += qryRecibos.value("r.codigo");
				nombreCliente = util.sqlSelect("clientes", "nombre", "codcliente = '" + cur.valueBuffer("codcliente") + "'");;
			}

			datosAsiento.concepto = "Pago recibos " + listaRecibos + " - " + nombreCliente;
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
			break;
		}
		default: {
			datosAsiento = this.iface.__datosConceptoAsiento(cur);
		}
	}
	return datosAsiento;
}
//// PAGOSMULTI //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition centrosCoste */
/////////////////////////////////////////////////////////////////
//// CENTROS COSTE /////////////////////////////////////////////////

function centrosCoste_regenerarAsiento(curFactura:FLSqlCursor, valoresDefecto:Array):Array
{
	var asiento:Array = this.iface.__regenerarAsiento(curFactura, valoresDefecto);

	if (asiento.error)
		return asiento;

	if (!curFactura.valueBuffer("codcentro"))
		return asiento;

	var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
	var idAsiento:Number = asiento.idasiento;

	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.setUnLock("editable", true);

	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.setModeAccess(curAsiento.Edit);
	curAsiento.refreshBuffer();
	curAsiento.setValueBuffer("codcentro", curFactura.valueBuffer("codcentro"));
	curAsiento.setValueBuffer("codsubcentro", curFactura.valueBuffer("codsubcentro"));

	if (!curAsiento.commitBuffer()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.select("idasiento = " + idAsiento);
	if (!curAsiento.first()) {
		asiento.error = true;
		return asiento;
	}
	curAsiento.setUnLock("editable", false);

	asiento.error = false;
	return asiento;
}

function centrosCoste_generarAsientoFacturaCli(curFactura:FLSqlCursor):Boolean
{
	if (!this.iface.__generarAsientoFacturaCli(curFactura))
		return false;

	this.iface.crearPartidasCC(curFactura);
}

function centrosCoste_generarAsientoFacturaProv(curFactura:FLSqlCursor):Boolean
{
	if (!this.iface.__generarAsientoFacturaProv(curFactura))
		return false;

	this.iface.crearPartidasCC(curFactura);
}

function centrosCoste_crearPartidasCC(curFactura:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil();

	var tabla:String = curFactura.table();
	if (tabla != "facturascli" && tabla != "facturasprov")
		return true;

	var idAsiento:Number = curFactura.valueBuffer("idasiento");
	if (!idAsiento)
		return true;

	var tablaLineas:String = "lineas" + tabla;
	var datosCta:Array;
	debug(tabla);
	switch (tabla) {
		case "facturascli":
			idPartida = util.sqlSelect("co_partidas", "idpartida", "idasiento = " + idAsiento + " and codsubcuenta like '7%'");
		break;
		case "facturasprov":
			idPartida = util.sqlSelect("co_partidas", "idpartida", "idasiento = " + idAsiento + " and codsubcuenta like '6%'");
		break;
	}

	if (!idPartida)
		return;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList(tablaLineas);
	q.setSelect("codcentro,codsubcentro,sum(pvptotal)");
	q.setFrom(tablaLineas);
	q.setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " GROUP BY codcentro,codsubcentro");

	q.exec();

	util.sqlDelete("co_partidascc", "idpartida = " + idPartida);

	var curTab:FLSqlCursor = new FLSqlCursor("co_partidascc");

	while(q.next()) {

		if (!q.value(0))
			continue;

		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("idpartida", idPartida);
		curTab.setValueBuffer("codcentro", q.value(0));
		if (q.value(1))
			curTab.setValueBuffer("codsubcentro", q.value(1));
		curTab.setValueBuffer("importe", q.value(2));
		curTab.commitBuffer();
	}

	return true;
}

//// CENTROS COSTE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition cambioIva */
/////////////////////////////////////////////////////////////////
//// CAMBIO_IVA /////////////////////////////////////////////////
function cambioIva_campoImpuesto(campo:String, codImpuesto:String, fecha:String):Number
{
	var util:FLUtil = new FLUtil;
	var valor:Number;
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("periodos");
	qry.setSelect("fechadesde, fechahasta, iva, recargo");
	qry.setFrom("periodos");
	qry.setWhere("codimpuesto = '" + codImpuesto + "' AND fechadesde <= '" + fecha + "'");
	try { qry.setForwardOnly( true ); } catch (e) {}

	if (!qry.exec()) {
		return false;
	}
	var iva:Number;
	var recargo:Number;
	while (qry.next()) {
		if (qry.value("fechahasta") && (util.daysTo(fecha,qry.value("fechahasta")) < 0)) {
			continue;
		}
		iva = qry.value("iva");
		recargo = qry.value("recargo");
	}

	if (campo == "iva") {
		valor = iva;
	}
	if (campo == "recargo") {
		valor = recargo;
	}
	return valor;
}

function cambioIva_datosImpuesto(codImpuesto:String, fecha:String):Array
{
	var util:FLUtil = new FLUtil;
	var datosImpuesto:Array;
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("periodos");
	qry.setSelect("fechadesde, fechahasta, iva, recargo");
	qry.setFrom("periodos");
	qry.setWhere("codimpuesto = '" + codImpuesto + "' AND fechadesde <= '" + fecha + "'");
	try { qry.setForwardOnly( true ); } catch (e) {}

	if (!qry.exec()) {
		return false;
	}
	var iva:Number;
	var recargo:Number;
	while (qry.next()) {
		if (qry.value("fechahasta") && (util.daysTo(fecha,qry.value("fechahasta")) < 0)) {
			continue;
		}
		iva = qry.value("iva");
		recargo = qry.value("recargo");
	}

	datosImpuesto.iva = iva;
	datosImpuesto.recargo = recargo;
	return datosImpuesto;
}

/** \D Comprueba que los porcentaje de IVA son los vigentes para el documento indicado
@param curDoc: Cursor posicionado en el documento
\end */
function cambioIva_validarIvas(curDoc:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var tabla:String = curDoc.table();
	var nombrePK:String = curDoc.primaryKey();
	var valorClave:String = curDoc.valueBuffer(nombrePK);
	var tablaLineas:String;
	switch (tabla) {
		case "presupuestoscli": { tablaLineas = "lineaspresupuestoscli"; break; }
		case "pedidoscli": { tablaLineas = "lineaspedidoscli"; break; }
		case "albaranescli": { tablaLineas = "lineasalbaranescli"; break; }
		case "facturascli": { tablaLineas = "lineasfacturascli"; break; }
		case "pedidosprov": { tablaLineas = "lineaspedidosprov"; break; }
		case "albaranesprov": { tablaLineas = "lineasalbaranesprov"; break; }
		case "facturasprov": { tablaLineas = "lineasfacturasprov"; break; }
		default: { return -1; }
	}
	var qryLineas:FLSqlQuery = new FLSqlQuery();
	qryLineas.setTablesList(tablaLineas);
	qryLineas.setSelect("codimpuesto, iva, recargo");
	qryLineas.setFrom(tablaLineas);
	qryLineas.setWhere(nombrePK + " = " + valorClave + " GROUP BY codimpuesto, iva, recargo");
	qryLineas.setForwardOnly(true);
	if (!qryLineas.exec()) {
		return false;
	}
	var fecha:String = curDoc.valueBuffer("fecha");
	var codImpuesto:String, iva:Number, recargo:Number, valorActualIva:Number, valorActualRecargo:Number;
	while (qryLineas.next()) {
		codImpuesto = qryLineas.value("codimpuesto");
		if (!codImpuesto || codImpuesto == "") {
			continue;
		}
		iva = qryLineas.value("iva");
		if (!isNaN(iva) && iva != 0) {
			valorActualIva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha);
			if (valorActualIva != iva) {
				var res:Number = MessageBox.warning(util.translate("scripts", "Alguna de las líneas contiene un valor de IVA no adecuado a la fecha del documento.\n¿Desea recalcular automáticamente estos valores?"), MessageBox.Yes, MessageBox.No, MessageBox.Ignore);
				switch (res) {
					case MessageBox.Yes: {
						if (!this.iface.actualizarIvaLineasFecha(tablaLineas, nombrePK, valorClave, fecha)) {
							return -1;
						}
						return 1;
					}
					case MessageBox.No: {
						return -1;
					}
					case MessageBox.Ignore: {
						return 0;
					}
				}
			}
		}
		recargo = qryLineas.value("recargo");
		if (!isNaN(recargo) && recargo != 0) {
			valorActualRecargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha);
			if (valorActualRecargo != recargo) {
				var res:Number = MessageBox.warning(util.translate("scripts", "Alguna de las líneas contiene un valor de Recargo de Equivalencia no adecuado a la fecha del documento.\n¿Desea recalcular automáticamente estos valores?"), MessageBox.Yes, MessageBox.No, MessageBox.Ignore);
				switch (res) {
					case MessageBox.Yes: {
						if (!this.iface.actualizarIvaLineasFecha(tablaLineas, nombrePK, valorClave, fecha)) {
							return -1;
						}
						return 1;
					}
					case MessageBox.No: {
						return -1;
					}
					case MessageBox.Ignore: {
						return 0;
					}
				}
			}
		}
	}

	return 0;
}

function cambioIva_actualizarIvaLineasFecha(tabla:String, nombrePK:String, valorClave:String, fecha:String):Boolean
{
	if (this.iface.curLineaDoc_) {
		delete this.iface.curLineaDoc_;
	}
	this.iface.curLineaDoc_ = new FLSqlCursor(tabla);
	this.iface.curLineaDoc_.setActivatedCommitActions(false);
	this.iface.curLineaDoc_.setActivatedCheckIntegrity(false);
	this.iface.curLineaDoc_.select(nombrePK + " = " + valorClave);

	var codImpuesto:String, iva:Number, recargo:Number, valorActualIva:Number, valorActualRecargo:Number;
	var cambiado:Boolean;
	while (this.iface.curLineaDoc_.next()) {
		cambiado = false;
		this.iface.curLineaDoc_.setModeAccess(this.iface.curLineaDoc_.Edit);
		this.iface.curLineaDoc_.refreshBuffer();
		codImpuesto = this.iface.curLineaDoc_.valueBuffer("codimpuesto");
		if (!codImpuesto || codImpuesto == "") {
			continue;
		}
		iva = this.iface.curLineaDoc_.valueBuffer("iva");
		if (!isNaN(iva) && iva != 0) {
			valorActualIva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha);
			if (valorActualIva != iva) {
				this.iface.curLineaDoc_.setValueBuffer("iva", valorActualIva);
				cambiado = true;
			}
		}
		recargo = this.iface.curLineaDoc_.valueBuffer("recargo");
		if (!isNaN(recargo) && recargo != 0) {
			valorActualRecargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha);
			if (valorActualRecargo != recargo) {
				this.iface.curLineaDoc_.setValueBuffer("recargo", valorActualRecargo);
				cambiado = true;
			}
		}
		if (cambiado) {
			if (!this.iface.datosLineaDocIva()) {
				return false;
			}
			if (!this.iface.curLineaDoc_.commitBuffer()) {
				return false;
			}
		}
	}
	return true;
}

function cambioIva_datosLineaDocIva():Boolean
{
	return true;
}
//// CAMBIO_IVA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
function liqAgentes_afterCommit_facturasprov(curFactura:FLSqlCursor):Boolean
{
	if(!this.iface.__afterCommit_facturasprov(curFactura))
		return false;

	var util:FLUtil;

	if(curFactura.modeAccess() == curFactura.Del) {
		var codLiquidacion:String = util.sqlSelect("liquidaciones","codliquidacion","codfactura = '" + curFactura.valueBuffer("codigo") + "'");
		if(codLiquidacion && codLiquidacion != "") {
			if(!util.sqlUpdate("liquidaciones","codfactura","","codliquidacion = '" + codLiquidacion + "'"))
				return false;
		}
	}

	return true;
}
//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition factPeriodica */
/////////////////////////////////////////////////////////////////
//// FACTURACION_PERIODICA /////////////////////////////////////////////////

/** \D Si la factura está asociada a un periodo o periodos y se elimina,
se desvincula el periodo
*/
function factPeriodica_beforeCommit_facturascli(curFactura:FLSqlCursor):Boolean
{
	if (curFactura.modeAccess() == curFactura.Del) {
		var curTab:FLSqlCursor = new FLSqlCursor("periodoscontratos");
		curTab.select("idfactura = " + curFactura.valueBuffer("idfactura"));
		while(curTab.next()) {
			curTab.setModeAccess(curTab.Edit);
			curTab.refreshBuffer();
			curTab.setNull("idfactura");
			curTab.setValueBuffer("facturado", false);
			if (!curTab.commitBuffer()) {
				return false;
			}
		}
	}

	return this.iface.__beforeCommit_facturascli(curFactura);
}

/** \D Si la el periodo está facturado no se puede eliminar
*/
function factPeriodica_beforeCommit_periodoscontratos(curP:FLSqlCursor):Boolean
{
	if (curP.modeAccess() == curP.Del) {
		var util:FLUtil = new FLUtil();
		if (util.sqlSelect("facturascli", "idfactura", "idfactura = " + curP.valueBuffer("idfactura"))) {
			MessageBox.warning(util.translate("scripts", "Para eliminar el período debe eliminar antes la factura asociada"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	return true;
}

//// FACTURACION_PERIODICA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
function pedProvCli_beforeCommit_pedidoscli(curPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
// 	if (!curPedido.isNull("idpedidoprov")) {
	var codPedidoProv:String = util.sqlSelect("pedidosprov p INNER JOIN lineaspedidosprov lp ON p.idpedido = lp.idpedido","p.codigo","lp.idlineacli IN (select idlinea FROM lineaspedidoscli WHERE idpedido = " + curPedido.valueBuffer("idpedido") + ")","pedidosprov,lineaspedidosprov");

	if (codPedidoProv) {
		var res:Number;
		switch (curPedido.modeAccess()) {
			/** \C Quita los datos del pedido de proveedor en caso de que ninguna de sus líneas esté asociada a dicho pedido.
			\end */
			case curPedido.Edit: {
				if (!util.sqlSelect("lineaspedidoscli", "idlinea", "idpedido = " + curPedido.valueBuffer("idpedido") + " AND idlineaprov IS NOT NULL")) {
					curPedido.setNull("codpedidoprov");
					curPedido.setNull("idpedidoprov");
				}
				break;
			}
			/** \C Avisa al usuario de que intenta borrar un pedido asociado a un pedido de proveedor. Si el usuario decide borrar el pedido, se eliminan las referencias del mismo en las correspondientes líneas de pedido de proveedor.
			\end */
			case curPedido.Del: {
				res = MessageBox.information(util.translate("scripts", "Va a eliminar un pedido asociado al pedido de proveedor ") + codPedidoProv + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
				if (res != MessageBox.Yes)
					return false;

				var curLineasCli:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
				curLineasCli.select("idpedido = " + curPedido.valueBuffer("idpedido"));
				while (curLineasCli.next()) {

					curLineasCli.setModeAccess(curLineasCli.Edit);
					curLineasCli.refreshBuffer();

					var idLineaProv:Number = util.sqlSelect("lineaspedidosprov","idlinea","idlineacli = " + curLineasCli.valueBuffer("idlinea"));

					if (!util.sqlUpdate("lineaspedidosprov", "idlineacli", "NULL", "idlinea = " + idLineaProv))
						return false;

					curLineasCli.setNull("idlineaprov");
					if (!curLineasCli.commitBuffer())
						return false;
				}
				break;
			}
		}
	}
	if (!interna_beforeCommit_pedidoscli(curPedido))
		return false;

	return true;
}

function pedProvCli_beforeCommit_pedidosprov(curPedido:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var res:Number;
	switch (curPedido.modeAccess()) {
		/** \C Avisa al usuario de que intenta borrar un pedido asociado a uno o más pedidos de cliente. Si el usuario decide borrar el pedido, se eliminan las referencias del mismo en las correspondientes líneas de pedido de cliente.
		\end */
		case curPedido.Del: {
			var codPedidoCli:String = util.sqlSelect("lineaspedidosprov lp INNER JOIN lineaspedidoscli lc ON lp.idlineacli = lc.idlinea INNER JOIN pedidoscli p ON lc.idpedido = p.idpedido", "p.codigo", "lp.idpedido = " + curPedido.valueBuffer("idpedido") + " AND lp.idlineacli IS NOT NULL", "lineaspedidosprov,lineaspedidoscli,pedidoscli");
			if (!codPedidoCli)
				break;
			res = MessageBox.information(util.translate("scripts", "Va a eliminar un pedido asociado al menos al pedido de cliente ") + codPedidoCli + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes)
				return false;

// 			var curLineasProv:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
// 			curLineasProv.select("idpedido = " + curPedido.valueBuffer("idpedido"));
//
// 			var idLineaCli:String;
// 			var idPedidoCli:String;
// 			while (curLineasProv.next()) {
// 				curLineasProv.setModeAccess(curLineasProv.Edit);
// 				curLineasProv.refreshBuffer();
// 				idLineaCli = curLineasProv.valueBuffer("idlineacli");
// 				if (!idLineaCli || idLineaCli == 0)
// 					continue;
//
// 				if (!util.sqlUpdate("lineaspedidoscli", "idlineaprov", "NULL", "idlinea = " + idLineaCli))
// 					return false;
//
// 				curLineasProv.setNull("idlineacli");
// 				if (!curLineasProv.commitBuffer())
// 					return false;
//
// 				idPedidoCli = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + idLineaCli);
// 				if (!util.sqlSelect("lineaspedidoscli", "idlinea", "idpedido = " + idPedidoCli + " AND idlineaprov IS NOT NULL")) {
// 					if (!util.sqlUpdate("pedidoscli", "codpedidoprov,idpedidoprov", "NULL,NULL", "idpedido = " + idPedidoCli))
// 						return false;
// 				}
// 			}
			break;
		}
	}

	if (!interna_beforeCommit_pedidosprov(curPedido))
		return false;

	return true;
}


/** \C Avisa al usuario en caso de que intente modificar o borrar una línea de pedido de cliente asociada a una línea de pedido de proveedor
\end */
function pedProvCli_beforeCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;

	var idLineaProv:Number = util.sqlSelect("lineaspedidosprov","idlinea","idlineacli = " + curLP.valueBuffer("idlinea"));

	if (idLineaProv) {
		var codPedidoProv:String = util.sqlSelect("pedidosprov p INNER JOIN lineaspedidosprov lp ON p.idpedido = lp.idpedido", "p.codigo", "lp.idlinea = " + idLineaProv, "pedidosprov,lineaspedidosprov");
		var res:Number;
		switch (curLP.modeAccess()) {
			case curLP.Edit: {
				if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia") || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad") || curLP.valueBuffer("cerrada") != curLP.valueBufferCopy("cerrada")) {
					res = MessageBox.information(util.translate("scripts", "Va a modificar una línea de pedido que está asociada al pedido de proveedor ") + codPedidoProv + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
					if (res != MessageBox.Yes)
						return false;
				}
				break;
			}
			case curLP.Del: {
				res = MessageBox.information(util.translate("scripts", "Va a eliminar una línea de pedido que está asociada al pedido de proveedor ") + codPedidoProv + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
				if (res != MessageBox.Yes)
					return false;
				if (!util.sqlUpdate("lineaspedidosprov", "idlineacli", "NULL", "idlinea = " + idLineaProv))
					return false;

				break;
			}
		}
	}

	/*
	if (!this.iface.__beforeCommit_lineaspedidoscli(curLP))
		return false;
	*/

	return true;
}

/** \C Avisa al usuario en caso de que intente modificar o borrar una línea de pedido de proveedor asociada a una línea de pedido de cliente
\end */
function pedProvCli_beforeCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	if (!curLP.isNull("idlineacli")) {
		var res:Number;
		switch (curLP.modeAccess()) {
			case curLP.Insert: {
				var otraLinea:Number = util.sqlSelect("lineaspedidosprov","idlinea","idlineacli = " + curLP.valueBuffer("idlineacli") + " AND idlinea  <> " + curLP.valueBuffer("idlinea"));
				if (otraLinea) {
					var cliente:String = util.sqlSelect("pedidoscli p INNER JOIN lineaspedidoscli l ON l.idpedido = p.idpedido", "p.codigo", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli") + " - " + util.sqlSelect("pedidoscli p INNER JOIN lineaspedidoscli l ON l.idpedido = p.idpedido", "p.nombrecliente", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");
					var proveedor:String = util.sqlSelect("pedidosprov","codigo","idpedido = " + curLP.valueBuffer("idpedido")) + " - " + util.sqlSelect("pedidosprov","nombre","idpedido = " + curLP.valueBuffer("idpedido"));

					res = MessageBox.information(util.translate("scripts", "El pedido de cliente %1\nque intenta asociar ya está asociado al pedido de proveedor %2\n¿Desea continuar?").arg(cliente).arg(proveedor), MessageBox.Yes, MessageBox.No);
					if (res != MessageBox.Yes)
						return false;
				}
				break;
			}
			case curLP.Edit: {
				if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia") || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad") || curLP.valueBuffer("cerrada") != curLP.valueBufferCopy("cerrada")) {
					var codPedidoCli:String = util.sqlSelect("lineaspedidoscli l INNER JOIN pedidoscli p ON l.idpedido = p.idpedido", "p.codigo", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");

					res = MessageBox.information(util.translate("scripts", "Va a modificar una línea de pedido que está asociada al pedido de cliente ") + codPedidoCli + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
					if (res != MessageBox.Yes)
						return false;
				}
				break;
			}
			case curLP.Del: {
				var codPedidoCli:String = util.sqlSelect("lineaspedidoscli l INNER JOIN pedidoscli p ON l.idpedido = p.idpedido", "p.codigo", "idlinea = " + curLP.valueBuffer("idlineacli"), "lineaspedidoscli,pedidoscli");

				res = MessageBox.information(util.translate("scripts", "Va a eliminar una línea de pedido que está asociada al pedido de cliente ") + codPedidoCli + util.translate("scripts", "\n¿Desea continuar?"), MessageBox.Yes, MessageBox.No);
				if (res != MessageBox.Yes)
					return false;



				break;
			}
		}
	}
	/*
	if (!this.iface.__beforeCommit_lineaspedidosprov(curLP))
		return false;
	*/
	return true;
}

/** \C Actualiza el estado del campo  pedido para los pedidos de cliente asociados a la línea afectada
\end */
function pedProvCli_afterCommit_lineaspedidosprov(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
debug("idLineaCli  = " + curLP.valueBuffer("idlineacli"));
	if (!curLP.isNull("idlineacli")) {
		var res:Number;
		switch (curLP.modeAccess()) {
			case curLP.Edit: {
				if (curLP.valueBuffer("referencia") != curLP.valueBufferCopy("referencia") || curLP.valueBuffer("cantidad") != curLP.valueBufferCopy("cantidad") || curLP.valueBuffer("cerrada") != curLP.valueBufferCopy("cerrada")) {
					var idPedido:String = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + curLP.valueBuffer("idlineacli"));
					if (idPedido) {
						if (!this.iface.actualizarCampoPedidoPedCli(idPedido)) {
							return false;
						}
					}
				}
				break;
			}
			case curLP.Del: {
				var idPedidoCli:String = util.sqlSelect("lineaspedidoscli", "idpedido", "idlinea = " + curLP.valueBuffer("idlineacli"));
debug("DEL idPedidoCli = " + idPedidoCli);
				if (!util.sqlUpdate("lineaspedidoscli", "idlineaprov", "NULL", "idlinea = " + curLP.valueBuffer("idlineacli"))) {
					return false;
				}
				if (idPedidoCli) {
					if (!util.sqlSelect("lineaspedidoscli", "idlinea", "idpedido = " + idPedidoCli + " AND idlineaprov IS NOT NULL")) {
						if (!util.sqlUpdate("pedidoscli", "codpedidoprov,idpedidoprov", "NULL,NULL", "idpedido = " + idPedidoCli)) {
							return false;
						}
					}
					if (!this.iface.actualizarCampoPedidoPedCli(idPedidoCli)) {
						return false;
					}
				}
				break;
			}
		}
	}

	if (!this.iface.__afterCommit_lineaspedidosprov(curLP)) {
		return false;
	}

	return true;
}

/** \D Actualiza el campo pedido de un pedido de cliente
@param	idPedido: Identificador del pedido de cliente
\end */
function pedProvCli_actualizarCampoPedidoPedCli(idPedido:String):Boolean
{
	var curPedido:FLSqlCursor = new FLSqlCursor("pedidoscli");
	curPedido.setActivatedCommitActions(false);
	curPedido.select("idpedido = " + idPedido);
	if (!curPedido.first()) {
		return false;
	}
	var editable:Boolean = curPedido.valueBuffer("editable");
	if (!editable) {
		curPedido.setUnLock("editable", true);
		curPedido.select("idpedido = " + idPedido);
		if (!curPedido.first()) {
			return false;
		}
	}

	var estado:String = this.iface.estadoPedidoCliProv(idPedido);
	if (!estado) {
		return false;
	}
	curPedido.setModeAccess(curPedido.Edit);
	curPedido.refreshBuffer();
	curPedido.setValueBuffer("pedido", estado);
	if (!curPedido.commitBuffer()) {
		return false;
	}

	if (!editable) {
		curPedido.select("idpedido = " + idPedido);
		if (!curPedido.first()) {
			return false;
		}
		curPedido.setUnLock("editable", false);
	}

	return true;
}

function pedProvCli_afterCommit_lineaspedidoscli(curLP:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
/*
	var curPedido:FLSqlCursor = curLP.cursorRelation();
	if (!curPedido) {
*/
		var idPedido:String = curLP.valueBuffer("idpedido");
		var estadoPedido:String = this.iface.estadoPedidoCliProv(idPedido);
		if (!estadoPedido)
			return false;
		if (!util.sqlUpdate("pedidoscli", "pedido", estadoPedido, "idpedido = " + idPedido))
			return false;
//	}

	if (!this.iface.__afterCommit_lineaspedidoscli(curLP))
		return false;

	return true;
}

/** \C Indica si el pedido de cliente está pedido, no está pedido o está parcialmente pedido al proveedor \end */
function pedProvCli_estadoPedidoCliProv(idPedido:String):String
{
	var hayLineasCon:Boolean = false;
	var hayLineasSin:Boolean = false;
	var res:String = "";

	var qryLineas:FLSqlQuery = new FLSqlQuery();
	qryLineas.setTablesList("pedidoscli,lineaspedidoscli,lineaspedidosprov");
	qryLineas.setSelect("p.codalmacen, lpc.referencia, lpc.idlinea, lpc.cantidad, SUM(CASE WHEN lpp.cerrada THEN lpp.totalenalbaran ELSE lpp.cantidad END)");
	qryLineas.setFrom("pedidoscli p INNER JOIN lineaspedidoscli lpc ON p.idpedido = lpc.idpedido LEFT OUTER JOIN lineaspedidosprov lpp ON lpc.idlinea = lpp.idlineacli");
	qryLineas.setWhere("p.idpedido = " + idPedido + " GROUP BY p.codalmacen, lpc.referencia, lpc.idlinea, lpc.cantidad");
debug(qryLineas.sql());
	if ( !qryLineas.exec() ) {
		return "Sí";
	}
	var canCliente:Number, canProveedor:Number, canStock:Number;
	var referencia:String;
	while ( qryLineas.next() ) {
		referencia = qryLineas.value("lpc.referencia");
		if (!referencia || referencia == "") {
			continue;
		}
		canCliente = parseFloat(qryLineas.value("lpc.cantidad"));
		canProveedor = parseFloat(qryLineas.value("SUM(CASE WHEN lpp.cerrada THEN lpp.totalenalbaran ELSE lpp.cantidad END)"));
		if (isNaN(canProveedor)) {
			canProveedor = 0;
		}
		if (canProveedor >= canCliente) {
			hayLineasCon = true;
		} else {
			if (canProveedor > 0) {
				hayLineasCon = true;
			}
			hayLineasSin = true;
		}
	}

	if ( hayLineasSin && !hayLineasCon ) {
		res = "No";
	} else if ( !hayLineasSin && hayLineasCon ) {
		res = "Sí";
	} else {
		res = "Parcial";
	}

	return res;
}

function pedProvCli_actualizarEstadoPedidoProv(idPedido:Number, curAlbaran:FLSqlCursor):Boolean
{
	var util:FLUtil;

	var estado:String = this.iface.obtenerEstadoPedidoProv(idPedido);
	if (estado == "Sí" && util.sqlSelect("pedidosprov","abierto","idpedido = " + idPedido)) {
		var curPedido:FLSqlCursor = new FLSqlCursor("pedidosprov");
		curPedido.select("idpedido = " + idPedido);
		if (curPedido.first()) {
			curPedido.setModeAccess(curPedido.Edit);
			curPedido.refreshBuffer()
				curPedido.setValueBuffer("abierto", false);
			if (!curPedido.commitBuffer())
				return false;
		}
	}

	if(!this.iface.__actualizarEstadoPedidoProv(idPedido, curAlbaran))
		return false;

	return true;
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition proveed */
/////////////////////////////////////////////////////////////////
//// PROVEED ////////////////////////////////////////////////////
function proveed_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "pagosdevolprov": {
			var numFactura:String = util.sqlSelect("recibosprov r INNER JOIN facturasprov f ON r.idfactura = f.idfactura", "f.numproveedor", "r.idrecibo = " + cur.valueBuffer("idrecibo"), "recibosprov,facturasprov");
			if (numFactura && numFactura != "") {
				numFactura = " (Fra. " + numFactura + ")";
			} else {
				numFactura = "";
			}
			var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
			var nombreProv:String = util.sqlSelect("recibosprov", "nombreproveedor", "idrecibo = " + cur.valueBuffer("idrecibo"));

			if (cur.valueBuffer("tipo") == "Pago") {
				datosAsiento.concepto = "Pago " + " recibo prov. " + codRecibo + numFactura + " - " + nombreProv;
			}
			if (cur.valueBuffer("tipo") == "Devolución") {
				datosAsiento.concepto = "Devolución recibo " + codRecibo + numFactura + " - " + nombreProv;;
			}
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
			break;
		}
		default: {
			datosAsiento = this.iface.__datosConceptoAsiento(cur);
			break;
		}
	}
	return datosAsiento;
}



//// PROVEED ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pagosMultiProv */
/////////////////////////////////////////////////////////////////
//// PAGOSMULTIPROV /////////////////////////////////////////////
// function pagosMultiProv_regenerarAsiento(cur:FLSqlCursor, valoresDefecto:Array):Array
// {
// 	var util:FLUtil = new FLUtil;
// 	var asiento:Array = [];
// 	var idAsiento:Number = cur.valueBuffer("idasiento");
// 	if (cur.isNull("idasiento")) {
//
// 		var concepto:String;
// 		var documento:String;
// 		var tipoDocumento:String;
//
// 		switch (cur.table()) {
// 			case "facturascli": {
// 				concepto = "Nuestra factura " + cur.valueBuffer("codigo") + " - " + cur.valueBuffer("nombrecliente");
// 				documento = cur.valueBuffer("codigo");
// 				tipoDocumento = "Factura de cliente";
// 				break;
// 			}
// 			case "facturasprov": {
// 				concepto = "Su factura " + cur.valueBuffer("codigo") + " - " + cur.valueBuffer("nombre");
// 				documento = cur.valueBuffer("codigo");
// 				tipoDocumento = "Factura de proveedor";
// 				break;
// 			}
// 			case "pagosdevolcli": {
// 				var codRecibo:String = util.sqlSelect("reciboscli", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
// 				var nombreCli:String = util.sqlSelect("reciboscli", "nombrecliente", "idrecibo = " + cur.valueBuffer("idrecibo"));
//
// 				if (cur.valueBuffer("tipo") == "Pago")
// 					concepto = "Pago recibo " + codRecibo + " - " + nombreCli;
// 				else
// 					concepto = "Devolución recibo " + codRecibo;
//
// 				tipoDocumento = "Recibo";
// 				break;
// 			}
// 			case "pagosdevolrem": {
// 				if (cur.valueBuffer("tipo") == "Pago")
// 					concepto = cur.valueBuffer("tipo") + " " + "remesa" + " " + cur.valueBuffer("idremesa");
//
// 				break;
// 			}
// 			case "pagosdevolprov": {
// 				var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
// 				var nombreProv:String = util.sqlSelect("recibosprov", "nombreproveedor", "idrecibo = " + cur.valueBuffer("idrecibo"));
//
// 				if (cur.valueBuffer("tipo") == "Pago")
// 					concepto = "Pago " + " recibo prov. " + codRecibo + " - " + nombreProv;
// 				break;
// 			}
// 			case "pagosmultiprov": {
// 				var listaRecibos:String = "";
// 				var nombreProveedor:String;
// 				var qryRecibos:FLSqlQuery = new FLSqlQuery();
// 				qryRecibos.setTablesList("recibosprov,pagosdevolprov");
// 				qryRecibos.setSelect("r.codigo, r.nombreproveedor");
// 				qryRecibos.setFrom("pagosdevolprov p INNER JOIN recibosprov r ON p.idrecibo = r.idrecibo ")
// 				qryRecibos.setWhere("p.idpagomulti = " + cur.valueBuffer("idpagomulti"));
// 				qryRecibos.setForwardOnly( true );
//
// 				if (!qryRecibos.exec())
// 					return false;
//
// 				while (qryRecibos.next()) {
// 					if (listaRecibos != "")
// 						listaRecibos += ", ";
// 					listaRecibos += qryRecibos.value("r.codigo");
// 					nombreProveedor = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + cur.valueBuffer("codproveedor") + "'");
// 				}
// 				concepto = "Pago recibos " + listaRecibos + " - " + nombreProveedor;
// 				break;
// 			}
// 		}
//
//
// 		var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
// 		//var numAsiento:Number = util.sqlSelect("co_asientos", "MAX(numero)",  "codejercicio = '" + valoresDefecto.codejercicio + "'");
// 		//numAsiento++;
// 		with (curAsiento) {
// 			setModeAccess(curAsiento.Insert);
// 			refreshBuffer();
// 			setValueBuffer("numero", 0);
// 			setValueBuffer("fecha", cur.valueBuffer("fecha"));
// 			setValueBuffer("codejercicio", valoresDefecto.codejercicio);
// 			setValueBuffer("concepto", concepto);
// 			setValueBuffer("tipodocumento", tipoDocumento);
// 			setValueBuffer("documento", documento);
// 		}
//
// 		if (!curAsiento.commitBuffer()) {
// 			asiento.error = true;
// 			return asiento;
// 		}
// 		asiento.idasiento = curAsiento.valueBuffer("idasiento");
// 		asiento.numero = curAsiento.valueBuffer("numero");
// 		asiento.fecha = curAsiento.valueBuffer("fecha");
// 		curAsiento.select("idasiento = " + asiento.idasiento);
// 		curAsiento.first();
// 		curAsiento.setUnLock("editable", false);
// 	} else {
// 		if (!this.iface.asientoBorrable(idAsiento)) {
// 			asiento.error = true;
// 			return asiento;
// 		}
//
// 		if (cur.valueBuffer("fecha") != cur.valueBufferCopy("fecha")) {
// 			var curAsiento:FLSqlCursor = new FLSqlCursor("co_asientos");
// 			curAsiento.select("idasiento = " + idAsiento);
// 			if (!curAsiento.first()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.setUnLock("editable", true);
//
// 			curAsiento.select("idasiento = " + idAsiento);
// 			if (!curAsiento.first()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.setModeAccess(curAsiento.Edit);
// 			curAsiento.refreshBuffer();
// 			curAsiento.setValueBuffer("fecha", cur.valueBuffer("fecha"));
//
// 			if (!curAsiento.commitBuffer()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.select("idasiento = " + idAsiento);
// 			if (!curAsiento.first()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 			curAsiento.setUnLock("editable", false);
// 		}
//
// 		asiento = flfactppal.iface.pub_ejecutarQry("co_asientos", "idasiento,numero,fecha,codejercicio", "idasiento = '" + idAsiento + "'");
// 		if (asiento.codejercicio != valoresDefecto.codejercicio) {
// 			MessageBox.warning(util.translate("scripts", "Está intentando regenerar un asiento del ejercicio %1 en el ejercicio %2.\nVerifique que su ejercicio actual es correcto. Si lo es y está actualizando un pago, bórrelo y vuélvalo a crear.").arg(asiento.codejercicio).arg(valoresDefecto.codejercicio), MessageBox.Ok, MessageBox.NoButton);
// 			asiento.error = true;
// 			return asiento;
// 		}
// 		var curPartidas = new FLSqlCursor("co_partidas");
// 		curPartidas.select("idasiento = " + idAsiento);
// 		while (curPartidas.next()) {
// 			curPartidas.setModeAccess(curPartidas.Del);
// 			curPartidas.refreshBuffer();
// 			if (!curPartidas.commitBuffer()) {
// 				asiento.error = true;
// 				return asiento;
// 			}
// 		}
// 	}
//
// 	asiento.error = false;
// 	return asiento;
// }

function pagosMultiProv_datosConceptoAsiento(cur:FLSqlCursor):Array
{
debug("pagosMultiProv_datosConceptoAsiento");

	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];
debug(cur.table());
	switch (cur.table()) {
		case "pagosmultiprov": {
			var listaRecibos:String = "";
			var nombreProveedor:String;
			var qryRecibos:FLSqlQuery = new FLSqlQuery();
			qryRecibos.setTablesList("recibosprov,pagosdevolprov");
			qryRecibos.setSelect("r.codigo, r.nombreproveedor");
			qryRecibos.setFrom("pagosdevolprov p INNER JOIN recibosprov r ON p.idrecibo = r.idrecibo ")
			qryRecibos.setWhere("p.idpagomulti = " + cur.valueBuffer("idpagomulti"));
			qryRecibos.setForwardOnly( true );

			if (!qryRecibos.exec())
				return false;

			while (qryRecibos.next()) {
debug("Recibo = " + qryRecibos.value("r.codigo"));
				if (listaRecibos != "")
					listaRecibos += ", ";
				listaRecibos += qryRecibos.value("r.codigo");
			}
			nombreProveedor = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + cur.valueBuffer("codproveedor") + "'");
			datosAsiento.concepto = "Pago recibos " + listaRecibos + " - " + nombreProveedor;
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
			break;
		}
		default: {
			datosAsiento = this.iface.__datosConceptoAsiento(cur);
		}
	}
	return datosAsiento;
}
//// PAGOSMULTIPROV /////////////////////////////////////////////
////////////////////////////////////////////////////////////////

/** @class_definition pagaresProv */
/////////////////////////////////////////////////////////////////
//// PAGARES_PROV ///////////////////////////////////////////////
function pagaresProv_datosConceptoAsiento(cur:FLSqlCursor):Array
{
	var util:FLUtil = new FLUtil;
	var datosAsiento:Array = [];

	switch (cur.table()) {
		case "pagosdevolprov": {
			if (cur.valueBuffer("tipo") == "Pagaré" || cur.valueBuffer("tipo") == "Pag.Anulado") {
				var codRecibo:String = util.sqlSelect("recibosprov", "codigo", "idrecibo = " + cur.valueBuffer("idrecibo"));
				var nombreProv:String = util.sqlSelect("recibosprov", "nombreproveedor", "idrecibo = " + cur.valueBuffer("idrecibo"));

				datosAsiento.concepto = "Pagaré recibo " + codRecibo;
				datosAsiento.documento = "";
				datosAsiento.tipoDocumento = "";
			}
			else {
				datosAsiento = this.iface.__datosConceptoAsiento(cur);
			}

			break;
		}
		case "pagospagareprov": {
			var numeroPag:String = util.sqlSelect("pagaresprov", "numero", "idpagare = " + cur.valueBuffer("idpagare"));
			var nombreProv:String = util.sqlSelect("pagaresprov", "nombreproveedor", "idpagare = " + cur.valueBuffer("idpagare"));

			datosAsiento.concepto = "Pago pagaré prov. " + numeroPag + " - " + nombreProv;
			datosAsiento.documento = "";
			datosAsiento.tipoDocumento = "";
			break;
		}
		default: {
			datosAsiento = this.iface.__datosConceptoAsiento(cur);
			break;
		}
	}
	return datosAsiento;
}

//// PAGARES_PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ivaIncluido */
/////////////////////////////////////////////////////////////////
//// IVA INCLUIDO ///////////////////////////////////////////////
function ivaIncluido_datosLineaDocIva():Boolean
{
	if (!this.iface.__datosLineaDocIva()) {
		return false;
	}
	switch (this.iface.curLineaDoc_.table()) {
		case "lineaspresupuestoscli":
		case "lineaspedidoscli":
		case "lineasalbaranescli":
		case "lineasfacturascli": {
			if (this.iface.curLineaDoc_.valueBuffer("ivaincluido")) {
				this.iface.curLineaDoc_.setValueBuffer("pvpunitario", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitario2", this.iface.curLineaDoc_));
			} else {
				this.iface.curLineaDoc_.setValueBuffer("pvpunitarioiva", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpunitarioiva2", this.iface.curLineaDoc_));
			}
			this.iface.curLineaDoc_.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLineaDoc_));
			this.iface.curLineaDoc_.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLineaDoc_));
			break;
		}
	}

	return true;
}
//// IVA INCLUIDO ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funServiciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
/** \C Si el albarán se borra se actualizan los pedidos asociados
\end */
function funServiciosCli_afterCommit_albaranescli(curAlbaran:FLSqlCursor):Boolean
{
	if (!this.iface.__afterCommit_albaranescli(curAlbaran)) {
		return false;
	}
	switch (curAlbaran.modeAccess()) {
		case curAlbaran.Del: {
			var idAlbaran:Number = curAlbaran.valueBuffer("idalbaran");
			if (idAlbaran) {
				var curServicio:FLSqlCursor = new FLSqlCursor("servicioscli");
				curServicio.select("idalbaran = " + idAlbaran);
				if (curServicio.first()) {
					curServicio.setUnLock("editable", true);
					curServicio.select("idalbaran = " + idAlbaran);
					curServicio.first();
					curServicio.setModeAccess(curServicio.Edit);
					curServicio.refreshBuffer();
					curServicio.setValueBuffer("idalbaran", "");
					curServicio.commitBuffer();
				}
			}
			break;
		}
	}
	return true;
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition ctaVentaArt */
/////////////////////////////////////////////////////////////////
//// CTA_VENTA_ART////////////////////////////////////////////////

/** \D Genera la parte del asiento de factura de proveedor correspondiente a la subcuenta de ventas
@param	curFactura: Cursor de la factura
@param	idAsiento: Id del asiento asociado
@param	valoresDefecto: Array con los valores por defecto de ejercicio y divisa
@param	concepto: Concepto de la partida
@return	VERDADERO si no hay error, FALSO en otro caso
\end */
function ctaVentaArt_generarPartidasVenta(curFactura:FLSqlCursor, idAsiento:Number, valoresDefecto:Array, concepto:String):Boolean
{
	var ctaVentas:Array = [];
	var util:FLUtil = new FLUtil();
	var monedaSistema:Boolean = (valoresDefecto.coddivisa == curFactura.valueBuffer("coddivisa"));
	var haber:Number = 0;
	var haberME:Number = 0;
	var idUltimaPartida:Number = 0;

	/** \C En el asiento correspondiente a las facturas de proveedor, se generarán tantas partidas de compra como subcuentas distintas existan en las líneas de factura
	\end */
	var qrySubcuentas:FLSqlQuery = new FLSqlQuery();
	with (qrySubcuentas) {
		setTablesList("lineasfacturascli");
		setSelect("codsubcuenta, SUM(pvptotal)");
		setFrom("lineasfacturascli");
		setWhere("idfactura = " + curFactura.valueBuffer("idfactura") + " GROUP BY codsubcuenta");
	}
	if (!qrySubcuentas.exec())
			return false;

	var ultimaSubcuenta:Number = qrySubcuentas.size();
	if (ultimaSubcuenta == 0) {
		return this.iface.__generarPartidasVenta(curFactura, idAsiento, valoresDefecto, concepto);
	}

	var neto:Number = this.iface.netoVentasFacturaCli(curFactura);;
	neto = util.roundFieldValue(neto, "facturascli", "neto");
	var iSubcuenta:Number = 1;
	var totalHaber:Number = 0;

	while (qrySubcuentas.next()) {
		if (qrySubcuentas.value(0) == "" || !qrySubcuentas.value(0)) {
			ctaVentas = this.iface.datosCtaVentas(valoresDefecto.codejercicio, curFactura.valueBuffer("codserie"));
			if (ctaVentas.error != 0)
				return false;
		} else {
			ctaVentas.codsubcuenta = qrySubcuentas.value(0);
			ctaVentas.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + qrySubcuentas.value(0) + "' AND codejercicio = '" + valoresDefecto.codejercicio + "'");
			if (!ctaVentas.idsubcuenta) {
				MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + ctaVentas.codsubcuenta + util.translate("scripts", " correspondiente al ejercicio ") + valoresDefecto.codejercicio + util.translate("scripts", ".\nPara poder crear la factura debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
				return false;
			}
		}

		if (monedaSistema) {
			haber = parseFloat(qrySubcuentas.value(1));
			haberME = 0;
		} else {
			haber = parseFloat(qrySubcuentas.value(1)) * parseFloat(curFactura.valueBuffer("tasaconv"));
			haberME = parseFloat(qrySubcuentas.value(1));
		}
		haber = util.roundFieldValue(haber, "co_partidas", "haber");
		haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
		totalHaber += parseFloat(haber);

		/// Necesario cuando se tiene la extensión de IVA incluido porque el sumatorio de redondeos agrupados por subcuenta puede no coincidir con el sumatorio total hecho en el campo Neto.
		if (iSubcuenta == ultimaSubcuenta) {
			var dif:Number = parseFloat(neto) - parseFloat(totalHaber);
			if (dif > -0.011 && dif != 0 && dif < 0.011) {
				if (monedaSistema) {
					haber = parseFloat(haber) + parseFloat(dif);
					haberME = 0;
				} else {
					haber = (parseFloat(haber) + parseFloat(dif)) * parseFloat(curFactura.valueBuffer("tasaconv"));
					haberME = parseFloat(haber) + parseFloat(dif);
				}
				haber = util.roundFieldValue(haber, "co_partidas", "haber");
				haberME = util.roundFieldValue(haberME, "co_partidas", "haberme");
			}
		}

		var curPartida:FLSqlCursor = new FLSqlCursor("co_partidas");
		with (curPartida) {
			setModeAccess(curPartida.Insert);
			refreshBuffer();
			setValueBuffer("idsubcuenta", ctaVentas.idsubcuenta);
			setValueBuffer("codsubcuenta", ctaVentas.codsubcuenta);
			setValueBuffer("idasiento", idAsiento);
			setValueBuffer("debe", 0);
			setValueBuffer("haber", haber);
			setValueBuffer("coddivisa", curFactura.valueBuffer("coddivisa"));
			setValueBuffer("tasaconv", curFactura.valueBuffer("tasaconv"));
			setValueBuffer("debeME", 0);
			setValueBuffer("haberME", haberME);
		}

		this.iface.datosPartidaFactura(curPartida, curFactura, "cliente")

		if (!curPartida.commitBuffer())
			return false;

		idUltimaPartida = curPartida.valueBuffer("idpartida");
		iSubcuenta++;
	}

	/** \C En los asientos de factura de cliente, y en el caso de que se use moneda extranjera, la última partida de compras tiene un saldo tal que haga que el asiento cuadre perfectamente. Esto evita errores de redondeo de conversión de moneda entre las partidas del asiento.
	\end */
	if (!monedaSistema) {
		haber = util.sqlSelect("co_partidas", "SUM(debe - haber)", "idasiento = " + idAsiento + " AND idpartida <> " + idUltimaPartida);
		if (!haber)
			return false;
		if (!util.sqlUpdate("co_partidas", "haber", haber, "idpartida = " + idUltimaPartida))
			return false;
	}

	return true;
}

/** \D Obtiene la cuenta de ventas de un artículo para el ejercicio actual
@param	referencia: Referencia del artículo
@return	Array con los siguientes valores:
	* Código de subcuenta
	* Identificador interno de la subcuenta
\end */
function ctaVentaArt_subcuentaVentas(referencia:String, codEjercicio:String):Array
{
	var util:FLUtil = new FLUtil;
	var subcuenta:Array = [];
	subcuenta.codsubcuenta = util.sqlSelect("articulos", "codsubcuentaven", "referencia = '" + referencia + "'");
	if (subcuenta.codsubcuenta && subcuenta.codsubcuenta != "") {
		if (!codEjercicio) {
			codEjercicio = flfactppal.iface.pub_ejercicioActual();
		}
		subcuenta.idsubcuenta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + subcuenta.codsubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
		if (!subcuenta.idsubcuenta) {
// 			MessageBox.warning(util.translate("scripts", "No se ha encontrado la subcuenta de ventas %1 correspondiente al artículo %2 en el ejercicio %3.\nSe usará la subcuenta de ventas asociada a la cuenta especial VENTAS.").arg(subcuenta.codsubcuenta).arg(referencia).arg(codEjercicio), MessageBox.Ok, MessageBox.NoButton);
			return false;
		}
	} else {
		return false;
	}
	return subcuenta;
}
//// CTA_VENTA_ART///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

/** \D El número de serie no puede ser nulo cuando el artículo lo requiere
*/
function funNumSerie_beforeCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean
{
//	if ( !this.iface.__beforeCommit_lineasfacturascli(curLF) )
//		return false;

	if (curLF.modeAccess() != curLF.Insert)
		return true;

	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {

		if (!curLF.valueBuffer("numserie")) {
			MessageBox.warning(util.translate("scripts", "El número de serie en las líneas de factura no puede ser nulo para el artículo ") + curLF.valueBuffer("referencia"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	return true;
}

/** \D El número de serie no puede ser nulo cuando el artículo lo requiere
*/
function funNumSerie_beforeCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean
{
//	if ( !this.iface.__beforeCommit_lineasfacturasprov(curLF) )
//		return false;

	if (curLF.modeAccess() != curLF.Insert)
		return true;

	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {

		if (!curLF.valueBuffer("numserie")) {
			MessageBox.warning(util.translate("scripts", "El número de serie en las líneas de factura no puede ser nulo para el artículo ") + curLF.valueBuffer("referencia"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}

	}

	return true;
}

/** \D Controla los números de serie en función de la eliminación o creación de líneas de remito
*/
function funNumSerie_afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean
{
	if (!this.iface.__afterCommit_lineasalbaranesprov(curLA))
		return false;

	if (!curLA.valueBuffer("numserie")) return true;

	switch(curLA.modeAccess()) {

		case curLA.Insert:
		case curLA.Edit:
			if (!flfactalma.iface.insertarNumSerie(curLA.valueBuffer("referencia"), curLA.valueBuffer("numserie"), curLA.valueBuffer("idalbaran"), -1))
				return false;
			break;

		case curLA.Del:
			if (!flfactalma.iface.borrarNumSerie(curLA.valueBuffer("referencia"), curLA.valueBuffer("numserie")))
				return false;
			break;
	}
	return true;
}

/** \D Controla los números de serie en función de la eliminación o creación
de líneas de factura en caso de que no se trate de una factura automática
*/
function funNumSerie_afterCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean
{
	if (!interna_afterCommit_lineasfacturasprov(curLF))
		return false;

	var util:FLUtil = new FLUtil;

	if (!curLF.valueBuffer("numserie")) return true;

	var automatica:Boolean = util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"));

 	// Factura normal
	if (!automatica) {

		switch(curLF.modeAccess()) {

			case curLF.Insert:
				if (!flfactalma.iface.insertarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie"), -1, curLF.valueBuffer("idfactura")))
					return false;
				break;

			case curLF.Del:
				if (!flfactalma.iface.borrarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie")))
					return false;
				break;
		}
	}

 	// Factura automática. El número de serie ya está registrado
	else {

		switch(curLF.modeAccess()) {

			case curLF.Insert:
			case curLF.Edit:
				if (!flfactalma.iface.modificarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie"), "idfacturacompra", curLF.valueBuffer("idfactura")))
					return false;
				break;

			case curLF.Del:
				if (!flfactalma.iface.modificarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie"), "idfacturacompra", 0))
					return false;
				break;
		}
	}
	return true;
}

/** \D Actualiza el id de remito de compra para un número de serie.
*/
function funNumSerie_afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean
{
	if (!this.iface.__afterCommit_lineasalbaranescli(curLA))
		return false;

	if (!curLA.valueBuffer("numserie")) return true;

	var curNS:FLSqlCursor = new FLSqlCursor("numerosserie");

	switch(curLA.modeAccess()) {

		case curLA.Edit:
			// Control cuando cambia un número por otro, se libera el primero
			if (curLA.valueBuffer("numserie") != curLA.valueBufferCopy("numserie")) {
				curNS.select("referencia = '" + curLA.valueBuffer("referencia") + "' AND numserie = '" + curLA.valueBufferCopy("numserie") + "'");
				if (curNS.first()) {
					curNS.setModeAccess(curNS.Edit);
					curNS.refreshBuffer();
					curNS.setValueBuffer("idalbaranventa", -1)
					curNS.setValueBuffer("vendido", "false")
					if (!curNS.commitBuffer()) return false;
				}
			}

		case curLA.Insert:
			curNS.select("referencia = '" + curLA.valueBuffer("referencia") + "' AND numserie = '" + curLA.valueBuffer("numserie") + "'");
			if (curNS.first()) {
				curNS.setModeAccess(curNS.Edit);
				curNS.refreshBuffer();
				curNS.setValueBuffer("idalbaranventa", curLA.valueBuffer("idalbaran"))
				curNS.setValueBuffer("vendido", "true")
				if (!curNS.commitBuffer()) return false;
			}


		break;

		case curLA.Del:
			curNS.select("referencia = '" + curLA.valueBuffer("referencia") + "' AND numserie = '" + curLA.valueBuffer("numserie") + "'");
			if (curNS.first()) {
				curNS.setModeAccess(curNS.Edit);
				curNS.refreshBuffer();
				curNS.setValueBuffer("idalbaranventa", -1)
				curNS.setValueBuffer("vendido", "false")
				if (!curNS.commitBuffer()) return false;
			}
			break;
	}
	return true;
}

/** \D Actualiza el id de la factura de compra para un número de serie.
*/
function funNumSerie_afterCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean
{
	if (!interna_afterCommit_lineasfacturascli(curLF))
		return false;

	if (!curLF.valueBuffer("numserie")) return true;

	var util:FLUtil = new FLUtil();
	var curNS:FLSqlCursor = new FLSqlCursor("numerosserie");

	switch(curLF.modeAccess()) {
		case curLF.Edit:
			// Control cuando cambia un número por otro, se libera el primero
			if (curLF.valueBuffer("numserie") != curLF.valueBufferCopy("numserie")) {
				curNS.select("referencia = '" + curLF.valueBuffer("referencia") + "' AND numserie = '" + curLF.valueBufferCopy("numserie") + "'");
				if (curNS.first()) {
					curNS.setModeAccess(curNS.Edit);
					curNS.refreshBuffer();

					if (util.sqlSelect("facturascli", "decredito", "idfactura = " + curLF.valueBuffer("idfactura"))) {
						curNS.setValueBuffer("idfacturadevol", -1)
						curNS.setValueBuffer("vendido", "true")
					}
					else {
						curNS.setValueBuffer("idfacturaventa", -1)
						curNS.setValueBuffer("vendido", "false")
					}

					if (!curNS.commitBuffer()) return false;
				}
			}

		case curLF.Insert:

			curNS.select("referencia = '" + curLF.valueBuffer("referencia") + "' AND numserie = '" + curLF.valueBuffer("numserie") + "'");
			if (!curNS.first())
				break;

			curNS.setModeAccess(curNS.Edit);
			curNS.refreshBuffer();

			if (util.sqlSelect("facturascli", "decredito", "idfactura = " + curLF.valueBuffer("idfactura"))) {
				curNS.setValueBuffer("idfacturadevol", curLF.valueBuffer("idfactura"))
				curNS.setValueBuffer("vendido", "false")
			}
			else {
				curNS.setValueBuffer("idfacturaventa", curLF.valueBuffer("idfactura"))
				curNS.setValueBuffer("vendido", "true")
			}

			if (!curNS.commitBuffer()) return false;

			break;

		case curLF.Del:
			curNS.select("referencia = '" + curLF.valueBuffer("referencia") + "' AND numserie = '" + curLF.valueBuffer("numserie") + "' AND idalbaranventa IS NULL");
			if (curNS.first()) {
				curNS.setModeAccess(curNS.Edit);
				curNS.refreshBuffer();
				var util:FLUtil = new FLUtil();
				if (util.sqlSelect("facturascli", "decredito", "idfactura = " + curLF.valueBuffer("idfactura"))) {
					curNS.setValueBuffer("idfacturadevol", -1)
					curNS.setValueBuffer("vendido", "true")
				}
				else {
					curNS.setValueBuffer("idfacturaventa", -1)
					curNS.setValueBuffer("vendido", "false")
				}

				if (!curNS.commitBuffer()) return false;
			}
			break;
	}
	return true;
}

/** Verifica si la referencia es de número de serie, en cuyo caso la
catidad servida sólo puede ser 1 en el remito
\end */
function funNumSerie_actualizarLineaPedidoCli(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	if (idLineaPedido == 0)
		return true;

	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + referencia + "'"))
		return this.iface.__actualizarLineaPedidoCli(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);


	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	curLineaPedido.setModeAccess(curLineaPedido.Edit);
	if (!curLineaPedido.first())
		return false;

	var query:FLSqlQuery = new FLSqlQuery();
	query.setTablesList("lineasalbaranescli");
	query.setSelect("SUM(cantidad)");
	query.setFrom("lineasalbaranescli");
	query.setWhere("idlineapedido = " + idLineaPedido + " AND referencia = '" + referencia + "'");

	if (!query.exec())
		return false;
	if (query.next())
		cantidadServida = parseFloat(query.value(0));

	curLineaPedido.setValueBuffer("totalenalbaran", cantidadServida);
	if (!curLineaPedido.commitBuffer())
		return false;

	return true;
}

/** Verifica si la referencia es de número de serie, en cuyo caso la
catidad servida sólo puede ser 1 en el remito
\end */
function funNumSerie_actualizarLineaPedidoProv(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	if (idLineaPedido == 0)
		return true;

	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + referencia + "'"))
		return this.iface.__actualizarLineaPedidoProv(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);


	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	curLineaPedido.setModeAccess(curLineaPedido.Edit);
	if (!curLineaPedido.first())
		return false;

	var query:FLSqlQuery = new FLSqlQuery();
	query.setTablesList("lineasalbaranesprov");
	query.setSelect("SUM(cantidad)");
	query.setFrom("lineasalbaranesprov");
	query.setWhere("idlineapedido = " + idLineaPedido + " AND referencia = '" + referencia + "'");

	debug(query.sql());

	if (!query.exec())
		return false;
	if (query.next())
		cantidadServida = parseFloat(query.value(0));

	curLineaPedido.setValueBuffer("totalenalbaran", cantidadServida);
	if (!curLineaPedido.commitBuffer())
		return false;

	return true;
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

