
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
class envioMail extends oficial /** %from: oficial */ {
    function envioMail( context ) { oficial ( context ); }
	function init() {
		return this.ctx.envioMail_init();
	}
	function enviarDocumento(codFactura:String, codCliente:String) {
		return this.ctx.envioMail_enviarDocumento(codFactura, codCliente);
	}
	function imprimir(codFactura:String) {
		return this.ctx.envioMail_imprimir(codFactura);
	}
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioMail */
/////////////////////////////////////////////////////////////////
//// PUB ENVIO MAIL /////////////////////////////////////////////
class pubEnvioMail extends ifaceCtx /** %from: ifaceCtx */ {
    function pubEnvioMail( context ) { ifaceCtx ( context ); }
	function pub_enviarDocumento(codFactura:String, codCliente:String) {
		return this.enviarDocumento(codFactura, codCliente);
	}
}
//// PUB ENVIO MAIL /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
function envioMail_init()
{
	this.iface.__init();
	//this.child("tbnEnviarMail").close();
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarDocumento()");
}

function envioMail_enviarDocumento(codFactura:String, codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codFactura) {
		codFactura = cursor.valueBuffer("codigo");
	}

	if (!codCliente) {
		codCliente = cursor.valueBuffer("codcliente");
	}

	var tabla:String = "clientes";
	var emailCliente:String = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
	if (!emailCliente) {
		return;
	}

	var rutaIntermedia:String = util.readSettingEntry("scripts/flfactinfo/dirCorreo");
	if (!rutaIntermedia.endsWith("/")) {
		rutaIntermedia += "/";
	}

	var cuerpo:String = "";
	var asunto:String = util.translate("scripts", "Factura %1").arg(codFactura);
	var rutaDocumento:String = rutaIntermedia + "F_" + codFactura + ".pdf";

	var codigo:String;
	if (codFactura) {
		codigo = codFactura;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}

	var numCopias:Number = util.sqlSelect("facturascli f INNER JOIN clientes c ON c.codcliente = f.codcliente", "c.copiasfactura", "f.codigo = '" + codigo + "'", "facturascli,clientes");
	if (!numCopias) {
		numCopias = 1;
	}

	var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturascli");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
	curImprimir.setValueBuffer("h_facturascli_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_facturascli", "", "", false, false, "", "i_facturascli", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codFactura:String)
{
	var util:FLUtil = new FLUtil;

	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "facturascli";
	var codCliente:String;
	if (codFactura && codFactura != "") {
		datosEMail["codDestino"] = util.sqlSelect("facturascli", "codcliente", "codigo = '" + codFactura + "'");
		datosEMail["codDocumento"] = codFactura;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codFactura);
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

