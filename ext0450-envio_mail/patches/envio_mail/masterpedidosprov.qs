
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL ////////////////////////////////////////////////
class envioMail extends oficial {
    function envioMail( context ) { oficial ( context ); }
	function init() { 
		return this.ctx.envioMail_init(); 
	}
	function enviarDocumento(codPedido:String, codProveedor:String) {
		return this.ctx.envioMail_enviarDocumento(codPedido, codProveedor);
	}
	function imprimir(codPedido:String) {
		return this.ctx.envioMail_imprimir(codPedido);
	}
}
//// ENVIO_MAIL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



/** @class_declaration pubEnvioMail */
/////////////////////////////////////////////////////////////////
//// PUB_ENVIO_MAIL /////////////////////////////////////////////
class pubEnvioMail extends ifaceCtx {
    function pubEnvioMail( context ) { ifaceCtx( context ); }
	function pub_enviarDocumento(codPedido:String, codProveedor:String) {
		return this.enviarDocumento(codPedido, codProveedor);
	}
}

//// PUB_ENVIO_MAIL /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL /////////////////////////////////////////////////
function envioMail_init()
{
	this.iface.__init();
	//this.child("tbnEnviarMail").close();
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarDocumento()");
}

function envioMail_enviarDocumento(codPedido:String, codProveedor:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codPedido) {
		codPedido = cursor.valueBuffer("codigo");
	}

	if (!codProveedor) {
		codProveedor = cursor.valueBuffer("codproveedor");
	}

	var tabla:String = "proveedores";
	var emailProveedor:String = flfactppal.iface.pub_componerListaDestinatarios(codProveedor, tabla);
	if (!emailProveedor) {	
		return;
	}

	var rutaIntermedia:String = util.readSettingEntry("scripts/flfactinfo/dirCorreo");
	if (!rutaIntermedia.endsWith("/")) {
		rutaIntermedia += "/";
	}

	var cuerpo:String = "";
	var asunto:String = util.translate("scripts", "Pedido %1").arg(codPedido);
	var rutaDocumento:String = rutaIntermedia + "P_" + codPedido + ".pdf";

	var codigo:String;
	if (codPedido) {
		codigo = codPedido;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}
	
	var curImprimir:FLSqlCursor = new FLSqlCursor("i_pedidosprov");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_pedidosprov_codigo", codigo);
	curImprimir.setValueBuffer("h_pedidosprov_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_pedidosprov", "", "", false, false, "", "i_pedidosprov", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailProveedor;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codPedido:String)
{
	var util:FLUtil = new FLUtil;
	
	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "pedidosprov";
	var codCliente:String;
	if (codPedido && codPedido != "") {
		datosEMail["codDestino"] = util.sqlSelect("pedidosprov", "codproveedor", "codigo = '" + codPedido + "'");
		datosEMail["codDocumento"] = codPedido;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codproveedor");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codPedido);
}

//// ENVIO_MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

