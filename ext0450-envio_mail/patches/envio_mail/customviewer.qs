
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
class envioMail extends oficial /** %from: oficial */ {
	var tbnEnviarMail;
	function envioMail( context ) { oficial( context ); }
	function init() {
		return this.ctx.envioMail_init();
	}
	function enviarEMail() {
		return this.ctx.envioMail_enviarEMail();
	}
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
function envioMail_init()
{
	this.iface.__init();
	this.iface.tbnEnviarMail = this.child( "tbnEnviarMail" );
	connect( this.iface.tbnEnviarMail, "clicked()", this, "iface.enviarEMail()" );
}

function envioMail_enviarEMail()
{
	var util:FLUtil = new FLUtil;
	var tabla:String;

	var rutaIntermedia:String = util.readSettingEntry("scripts/flfactinfo/dirCorreo");
	if (!rutaIntermedia.endsWith("/")) {
		rutaIntermedia += "/";
	}
	var cuerpo:String = "";
	var asunto:String;
	var rutaDocumento:String = "";
	var emailDestino:String = "";

	var datosEMail:Array = flfactinfo.iface.datosEMail;
	if (datosEMail) {
		var tipoInforme:String = datosEMail.tipoInforme;
		switch (tipoInforme) {
			case "facturascli": {
				tabla = "clientes";
				var codCliente:String = datosEMail.codDestino;
				var codFactura = datosEMail.codDocumento;
				emailDestino = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
				asunto = util.translate("scripts", "Factura %1").arg(codFactura);
				rutaDocumento = rutaIntermedia + "F_" + codFactura + ".pdf";
				break;
			}
			case "presupuestoscli": {
				tabla = "clientes";
				var codCliente:String = datosEMail.codDestino;
				var codPresupuesto = datosEMail.codDocumento;
				emailDestino = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
				asunto = util.translate("scripts", "Presupuesto %1").arg(codPresupuesto);
				rutaDocumento = rutaIntermedia + "Pr_" + codPresupuesto + ".pdf";
				break;
			}
			case "pedidoscli": {
				tabla = "clientes";
				var codCliente:String = datosEMail.codDestino;
				var codPedido = datosEMail.codDocumento;
				emailDestino = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
				asunto = util.translate("scripts", "Pedido %1").arg(codPedido);
				rutaDocumento = rutaIntermedia + "P_" + codPedido + ".pdf";
				break;
			}
			case "albaranescli": {
				tabla = "clientes";
				var codCliente:String = datosEMail.codDestino;
				var codAlbaran = datosEMail.codDocumento;
				emailDestino = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
				asunto = util.translate("scripts", "Albaran %1").arg(codAlbaran);
				rutaDocumento = rutaIntermedia + "A_" + codAlbaran + ".pdf";
				break;
			}
			case "pedidosprov": {
				tabla = "proveedores";
				var codProveedor:String = datosEMail.codDestino;
				var codPedido = datosEMail.codDocumento;
				emailDestino = flfactppal.iface.pub_componerListaDestinatarios(codProveedor, tabla);
				asunto = util.translate("scripts", "Pedido %1").arg(codPedido);
				rutaDocumento = rutaIntermedia + "P_" + codPedido + ".pdf";
				break;
			}
			case "reciboscli": {
				tabla = "clientes";
				var codCliente:String = datosEMail.codDestino;
				var codRecibo = datosEMail.codDocumento;
				emailDestino = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);
				asunto = util.translate("scripts", "Recibo %1").arg(codRecibo);
				rutaDocumento = rutaIntermedia + "R_" + codRecibo + ".pdf";
				break;
			}
		}
	}
	delete flfactinfo.iface.datosEMail; /// Para que no se quede para el próximo informe
	flfactinfo.iface.datosEMail = false;
	if (!rutaDocumento || rutaDocumento == "") {
		var nombre:String = Input.getText(util.translate("scripts", "Nombre del fichero a enviar"));
		if (!nombre || nombre == "") {
			return false;
		}
		if (!nombre.toLowerCase().endsWith(".pdf")) {
			nombre += ".pdf";
		}
		rutaDocumento = rutaIntermedia + nombre;
	}
	this.iface.visor.printReportToPDF(rutaDocumento);
	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailDestino;

	var arrayAttach:Array = [];
	arrayAttach[0] = rutaDocumento;

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}
//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

