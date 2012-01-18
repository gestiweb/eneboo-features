
/** @class_declaration liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
class liqAgentes extends oficial /** %from: oficial */ {
	function liqAgentes( context ) { oficial ( context ); }
	function calcularLiquidacionAgente(where:String):Number {
		return this.ctx.liqAgentes_calcularLiquidacionAgente(where);
	}
	function obtenFiltroFacturas(codAgente:String, desde:String, hasta:String, codEjercicio:String):String {
		return this.ctx.liqAgentes_obtenFiltroFacturas(codAgente, desde, hasta, codEjercicio);
	}
	function asociarFacturasLiq(filtro:String, codLiquidacion:String):Boolean {
		return this.ctx.liqAgentes_asociarFacturasLiq(filtro, codLiquidacion);
	}
	function asociarFacturaLiq(idFactura:String, codLiquidacion:String):Boolean {
		return this.ctx.liqAgentes_asociarFacturaLiq(idFactura, codLiquidacion);
	}
}
//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubLiqAgentes */
/////////////////////////////////////////////////////////////////
//// PUB LIQ AGENTES ////////////////////////////////////////////
class pubLiqAgentes extends ifaceCtx /** %from: ifaceCtx */ {
	function pubLiqAgentes( context ) { ifaceCtx( context ); }
	function pub_calcularLiquidacionAgente(where:String):Number {
		return this.calcularLiquidacionAgente(where);
	}
	function pub_obtenFiltroFacturas(codAgente:String, desde:String, hasta:String, codEjercicio:String):String {
		return this.obtenFiltroFacturas(codAgente, desde, hasta, codEjercicio);
	}
	function pub_asociarFacturasLiq(filtro:String, codLiquidacion:String):Boolean {
		return this.asociarFacturasLiq(filtro, codLiquidacion);
	}
	function pub_asociarFacturaLiq(idFactura:String, codLiquidacion:String):Boolean {
		return this.asociarFacturaLiq(idFactura, codLiquidacion);
	}
}
//// PUB LIQ AGENTES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
function liqAgentes_calcularLiquidacionAgente(where:String):Number {
	var util:FLUtil = new FLUtil();

	var qryFacturas:FLSqlQuery = new FLSqlQuery();
	qryFacturas.setTablesList("facturascli,lineasfacturascli");
	qryFacturas.setSelect("coddivisa, tasaconv, facturascli.porcomision, lineasfacturascli.porcomision, neto, facturascli.idfactura, lineasfacturascli.pvptotal");
	qryFacturas.setFrom("facturascli INNER JOIN lineasfacturascli ON facturascli.idfactura = lineasfacturascli.idfactura");
	qryFacturas.setWhere(where);
	if (!qryFacturas.exec()) {
		return false;
	}
	var total:Number = 0;
	var comision:Number = 0;
	var tasaconv:Number = 0;
	var divisaEmpresa:String = util.sqlSelect("empresa","coddivisa","1=1");
	var idfactura:Number = 0;
	var comisionFactura:Boolean = false;
	while (qryFacturas.next()) {
		if (!idfactura || idfactura != qryFacturas.value("facturascli.idfactura")) {
			idfactura = qryFacturas.value("facturascli.idfactura");
			if (parseFloat(qryFacturas.value("facturascli.porcomision"))) {
				comisionFactura = true;
				comision = parseFloat(qryFacturas.value("facturascli.porcomision")) * parseFloat(qryFacturas.value("neto")) / 100;
				tasaconv = parseFloat(qryFacturas.value("tasaconv"));
				if (qryFacturas.value("coddivisa") == divisaEmpresa) {
					total += comision;
				} else {
					total += comision * tasaconv;
				}
			} else {
				comisionFactura = false;
			}
		}
		if (!comisionFactura) {
			comision = parseFloat(qryFacturas.value("lineasfacturascli.porcomision")) * parseFloat(qryFacturas.value("lineasfacturascli.pvptotal")) / 100;
			tasaconv = parseFloat(qryFacturas.value("tasaconv"));
			if (qryFacturas.value("coddivisa") == divisaEmpresa) {
				total += comision;
			} else {
				total += comision * tasaconv ;
			}
		}
	}
	return total;
}

/** \D Establece el filtro sobre la tabla de facturas que deben cumplir las facturas a incluir en una liquidación
@param	codAgente: Agente
@param	desde: Fecha desde
@param	hasta: Fecha hasta
@param	codEjercicio: Ejercicio (opcional)
@return	filtro
\end */
function liqAgentes_obtenFiltroFacturas(codAgente:String, desde:String, hasta:String, codEjercicio:String):String
{
	var filtro:String = "facturascli.idfactura IN (SELECT DISTINCT facturascli.idfactura FROM facturascli INNER JOIN lineasfacturascli ON facturascli.idfactura = lineasfacturascli.idfactura WHERE 1 = 1";
	if (codAgente && codAgente != "") {
		filtro += " AND facturascli.codagente = '" + codAgente + "'";
	}
	if (codEjercicio && codEjercicio != "") {
		filtro += " AND codejercicio = '" + codEjercicio + "'";
	}
	filtro += " AND (facturascli.codliquidacion = '' OR facturascli.codliquidacion IS NULL) AND (facturascli.porcomision > 0 OR lineasfacturascli.porcomision > 0) and facturascli.fecha >= '" + desde + "' and facturascli.fecha <= '" + hasta + "')";
	return filtro;

// 	return "idfactura IN (SELECT DISTINCT facturascli.idfactura FROM facturascli INNER JOIN lineasfacturascli ON facturascli.idfactura = lineasfacturascli.idfactura WHERE facturascli.codagente = '" + cursor.valueBuffer("codagente") + "' AND (facturascli.codliquidacion = '' OR facturascli.codliquidacion IS NULL) AND (facturascli.porcomision > 0 OR lineasfacturascli.porcomision > 0) and facturascli.fecha >= '" + this.child("dateDesde").date + "' and facturascli.fecha <= '" + this.child("dateHasta").date + "')";
}

/** \D Asocia las facturas que cumplen el filtro a la liquidación indicada
@param	filtro: Sentencia where a aplicar sobre la tabla de facturas de cliente
@param	codLiquidación: Código de la liquidación a la que asociar las facturas
\end */
function liqAgentes_asociarFacturasLiq(filtro:String, codLiquidacion:String):Boolean
{
	var util:FLUtil = new FLUtil;
	var qryFacturas:FLSqlQuery = new FLSqlQuery;
	qryFacturas.setTablesList("facturascli");
	qryFacturas.setSelect("idfactura");
	qryFacturas.setFrom("facturascli");
	qryFacturas.setWhere(filtro);

	if (!qryFacturas.exec()) {
		return false;
	}
	util.createProgressDialog( util.translate( "scripts", "Asociando facturas pendientes de liquidar..." ), qryFacturas.size());
	var i:Number = 0;

	while(qryFacturas.next()) {
// 		if (!this.iface.asociarFactura(qryFacturas.value(0), this.iface.codLiquidacion)) {
		if (!this.iface.asociarFacturaLiq(qryFacturas.value(0), codLiquidacion)) {
			util.destroyProgressDialog();
			return false;
		}

		util.setProgress( i );
		sys.processEvents();
		i++;
	}

	util.destroyProgressDialog();
	return true;
}

/** \D Asocia una factura a una liquidación de agentes comerciales
@param	idFactura: Identificador de la factura
@param	codLiquidacion: Identificador de la liquidación
@return	true si la asociación se raliza correctamente, false en caso contrario
\end */
function liqAgentes_asociarFacturaLiq(idFactura:String, codLiquidacion:String):Boolean
{
	var curFactura:FLSqlCursor = new FLSqlCursor("facturascli");
	var editable:Boolean = true;

	curFactura.select("idfactura = " + idFactura);
	if (!curFactura.first()) {
		return false;
	}
	curFactura.setModeAccess(curFactura.Browse);
	curFactura.refreshBuffer();

	curFactura.setActivatedCommitActions(false);
	if (!curFactura.valueBuffer("editable")) {
		editable = false;
		curFactura.setUnLock("editable", true);
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first())
			return false;
	}

	curFactura.setModeAccess(curFactura.Edit);
	curFactura.refreshBuffer();
	curFactura.setValueBuffer( "codliquidacion", codLiquidacion);
	if (!curFactura.commitBuffer()) {
		return false;
	}
	if (editable == false) {
		curFactura.select("idfactura = " + idFactura);
		if (!curFactura.first()) {
			return false;
		}
		curFactura.setUnLock("editable", false);
	}

	return true;
}


//// LIQUIDACIÓN A AGENTES //////////////////////////////////////
/////////////////////////////////////////////////////////////////

