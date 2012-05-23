
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL ////////////////////////////////////////////////
class envioMail extends oficial /** %from: oficial */ {
    function envioMail( context ) { oficial ( context ); }
	function init() {
		return this.ctx.envioMail_init();
	}
	function enviarDocumento(codAlbaran:String, codCliente:String) {
		return this.ctx.envioMail_enviarDocumento(codAlbaran, codCliente);
	}
	function imprimir(codAlbaran:String) {
		return this.ctx.envioMail_imprimir(codAlbaran);
	}
}

//// ENVIO_MAIL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioMail */
/////////////////////////////////////////////////////////////////
//// PUB_ENVIO_MAIL /////////////////////////////////////////////
class pubEnvioMail extends ifaceCtx /** %from: ifaceCtx */ {
    function pubEnvioMail( context ) { ifaceCtx( context ); }
	function pub_enviarDocumento(codAlbaran:String, codCliente:String) {
		return this.enviarDocumento(codAlbaran, codCliente);
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

function envioMail_enviarDocumento(codAlbaran:String, codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codAlbaran) {
		codAlbaran = cursor.valueBuffer("codigo");
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
	var asunto:String = util.translate("scripts", "Albaran %1").arg(codAlbaran);
	var rutaDocumento:String = rutaIntermedia + "A_" + codAlbaran + ".pdf";

	var util:FLUtil = new FLUtil;
	var codigo:String;
	if (codAlbaran) {
		codigo = codAlbaran;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}

	var numCopias:Number = util.sqlSelect("albaranescli a INNER JOIN clientes c ON c.codcliente = a.codcliente", "c.copiasfactura", "a.codigo = '" + codigo + "'", "albaranescli,clientes");
	if (!numCopias) {
		numCopias = 1;
	}

	var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranescli");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
	curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_albaranescli", "", "", false, false, "", "i_albaranescli", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codAlbaran:String)
{
	var util:FLUtil = new FLUtil;

	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "albaranescli";
	var codCliente:String;
	if (codAlbaran && codAlbaran != "") {
		datosEMail["codDestino"] = util.sqlSelect("albaranescli", "codcliente", "codigo = '" + codAlbaran + "'");
		datosEMail["codDocumento"] = codAlbaran;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codAlbaran);
}

//// ENVIO_MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

