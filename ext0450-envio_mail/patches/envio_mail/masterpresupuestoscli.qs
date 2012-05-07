
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO_MAIL ////////////////////////////////////////////////
class envioMail extends oficial {
    function envioMail( context ) { oficial ( context ); }
	function init() { 
		return this.ctx.envioMail_init(); 
	}
	function enviarDocumento(codPresupuesto:String, codCliente:String) {
		return this.ctx.envioMail_enviarDocumento(codPresupuesto, codCliente);
	}
	function imprimir(codPresupuesto:String) {
		return this.ctx.envioMail_imprimir(codPresupuesto);
	}
}

//// ENVIO_MAIL ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubEnvioMail */
/////////////////////////////////////////////////////////////////
//// PUB_ENVIO_MAIL /////////////////////////////////////////////
class pubEnvioMail extends head {
    function pubEnvioMail( context ) { head( context ); }
	function pub_enviarDocumento(codPresupuesto:String, codCliente:String) {
		return this.enviarDocumento(codPresupuesto, codCliente);
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

function envioMail_enviarDocumento(codPresupuesto:String, codCliente:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (!codPresupuesto) {
		codPresupuesto = cursor.valueBuffer("codigo");
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
	var asunto:String = util.translate("scripts", "Presupuesto %1").arg(codPresupuesto);

	var rutaDocumento:String = rutaIntermedia + "Pr_" + codPresupuesto + ".pdf";
	var codigo:String;
	if (codPresupuesto) {
		codigo = codPresupuesto;
	} else {
		if (!cursor.isValid()) {
			return;
		}
		codigo = cursor.valueBuffer("codigo");
	}
	var numCopias:Number = util.sqlSelect("presupuestoscli p INNER JOIN clientes c ON c.codcliente = p.codcliente", "c.copiasfactura", "p.codigo = '" + codigo + "'", "presupuestoscli,clientes");
	if (!numCopias) {
		numCopias = 1;
	}
		
	var curImprimir:FLSqlCursor = new FLSqlCursor("i_presupuestoscli");
	curImprimir.setModeAccess(curImprimir.Insert);
	curImprimir.refreshBuffer();
	curImprimir.setValueBuffer("descripcion", "temp");
	curImprimir.setValueBuffer("d_presupuestoscli_codigo", codigo);
	curImprimir.setValueBuffer("h_presupuestoscli_codigo", codigo);
	flfactinfo.iface.pub_lanzarInforme(curImprimir, "i_presupuestoscli", "", "", false, false, "", "i_presupuestoscli", 1, rutaDocumento, true);

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_imprimir(codPresupuesto:String)
{
	var util:FLUtil = new FLUtil;
	
	var datosEMail:Array = [];
	datosEMail["tipoInforme"] = "presupuestoscli";
	var codCliente:String;
	if (codPresupuesto && codPresupuesto != "") {
		datosEMail["codDestino"] = util.sqlSelect("presupuestoscli", "codcliente", "codigo = '" + codPresupuesto + "'");
		datosEMail["codDocumento"] = codPresupuesto;
	} else {
		var cursor:FLSqlCursor = this.cursor();
		datosEMail["codDestino"] = cursor.valueBuffer("codcliente");
		datosEMail["codDocumento"] = cursor.valueBuffer("codigo");
	}
	flfactinfo.iface.datosEMail = datosEMail;
	this.iface.__imprimir(codPresupuesto);
}

//// ENVIO_MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


