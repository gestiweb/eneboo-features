
/** @class_declaration liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
class liqAgentes extends oficial /** %from: oficial */ {
	var porComision:Number;
	var baseLiq:Number;
	var ivaLiq:Number;
	var irpfLiq:Number;

    function liqAgentes( context ) { oficial ( context ); }
	function totalComisionFactura(nodo:FLDomNode, campo:String):Number {
		return this.ctx.liqAgentes_totalComisionFactura(nodo, campo);
	}
	function porComisionFactura(nodo:FLDomNode, campo:String):Number {
		return this.ctx.liqAgentes_porComisionFactura(nodo, campo);
	}
	function iniciarValoresLiq(nodo:FLDomNode, campo:String) {
		return this.ctx.liqAgentes_iniciarValoresLiq(nodo, campo);
	}
	function calcularValoresLiq(nodo:FLDomNode, campo:String) {
		return this.ctx.liqAgentes_calcularValoresLiq(nodo, campo);
	}
	function mostrarValoresLiq(nodo:FLDomNode, campo:String):Number {
		return this.ctx.liqAgentes_mostrarValoresLiq(nodo, campo);
	}
}
//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubLiqAgentes */
/////////////////////////////////////////////////////////////////
//// PUB_LIQ_AGENTES ////////////////////////////////////////////
class pubLiqAgentes extends ifaceCtx /** %from: ifaceCtx */ {
	function pubLiqAgentes( context ) { ifaceCtx( context ); }
	function pub_iniciarValoresLiq(nodo:FLDomNode, campo:String) {
		return this.iniciarValoresLiq(nodo, campo);
	}
	function pub_calcularValoresLiq(nodo:FLDomNode, campo:String) {
		return this.calcularValoresLiq(nodo, campo);
	}
	function pub_mostrarValoresLiq(nodo:FLDomNode, campo:String):Number {
		return this.mostrarValoresLiq(nodo, campo);
	}
}
//// PUB_LIQ_AGENTES ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition liqAgentes */
/////////////////////////////////////////////////////////////////
//// LIQAGENTES /////////////////////////////////////////////////
/** \D
Obtiene el porcentaje de comisión de la factura. Si no lo tiene el porcentaje será la media de los porcentajes de sus líneas.
@param	nodo: Nodo XML con los datos de la línea que se va a mostrar en el informe
@param	campo: Campo a mostrar
@return	Valor del campo
\end */
function liqAgentes_porComisionFactura(nodo:FLDomNode, campo:String):Number
{debug("liqAgentes_porComisionFactura");
		var util:FLUtil = new FLUtil();

	var res:Number = parseFloat(nodo.attributeValue("facturascli.porcomision"));
	if(res && res != 0) {
		this.iface.porComision = res;
		return res;
	}

	var idFactura:String = nodo.attributeValue("facturascli.idfactura");
	var numLineas:Number = parseFloat(util.sqlSelect("lineasfacturascli","COUNT(idlinea)","idfactura = " + idFactura));
debug("numLineas " + numLineas);
	if(!numLineas) {
		this.iface.porComision = 0;
		return 0;
	}

	var sumCom:Number = parseFloat(util.sqlSelect("lineasfacturascli","SUM(porcomision)","idfactura = " + idFactura));
debug("sumCom " + sumCom);
	res = sumCom/numLineas;
debug("res " + res);
	this.iface.porComision = res;

	return res;
}

/** \D
Obtiene la comisión total de una factura
@param	nodo: Nodo XML con los datos de la línea que se va a mostrar en el informe
@param	campo: Campo a mostrar
@return	Valor del campo
\end */
function liqAgentes_totalComisionFactura(nodo:FLDomNode, campo:String):Number
{
	var util:FLUtil = new FLUtil();

	if(!this.iface.porComision)
		return 0;

	var totalFactura:Number = nodo.attributeValue("facturascli.neto");
	var res:Number = totalFactura * this.iface.porComision / 100;
	return res;
}

function liqAgentes_iniciarValoresLiq(nodo:FLDomNode, campo:String)
{
	this.iface.baseLiq = 0;
	this.iface.ivaLiq = 0;
	this.iface.irpfLiq = 0;
}

function liqAgentes_calcularValoresLiq(nodo:FLDomNode, campo:String)
{
	var util:FLUtil = new FLUtil();
	this.iface.baseLiq = nodo.attributeValue("liquidaciones.total");

	var irpf:Number = util.sqlSelect("agentes", "irpf", "codagente = '" + nodo.attributeValue("liquidaciones.codagente") + "'");
	this.iface.irpfLiq = (nodo.attributeValue("liquidaciones.total") * irpf) / 100;

	var codImpuesto:Number = util.sqlSelect("articulos", "codimpuesto", "referencia = '" + flfactalma.iface.pub_valorDefectoAlmacen("refivaliquidacion") + "'");
	if (codImpuesto) {
		var iva:Number = util.sqlSelect("impuestos", "iva", "codimpuesto = '" + codImpuesto + "'");
		this.iface.ivaLiq = (nodo.attributeValue("liquidaciones.total") * iva) / 100;
	}
}

function liqAgentes_mostrarValoresLiq(nodo:FLDomNode, campo:String):Number
{
	var util:FLUtil = new FLUtil();
	var valor:Number;
	switch (campo) {
		case "baseimponible": {
			valor = this.iface.baseLiq;
			break;
		}
		case "irpf": {
			valor = this.iface.irpfLiq;
			break;
		}
		case "iva": {
			valor = this.iface.ivaLiq;
			break;
		}
		case "total": {
			valor = parseFloat(this.iface.baseLiq) + parseFloat(this.iface.ivaLiq) - parseFloat(this.iface.irpfLiq);
			break;
		}
	}
	return valor;
}

//// LIQAGENTES /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

