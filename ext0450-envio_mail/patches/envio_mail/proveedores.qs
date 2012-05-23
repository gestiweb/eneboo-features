
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
class envioMail extends oficial /** %from: oficial */ {
    function envioMail( context ) { oficial ( context ); }
    function init() {
		return this.ctx.envioMail_init();
	}
    function enviarEmail() {
		return this.ctx.envioMail_enviarEmail();
	}
    function enviarEmailPedido() {
		return this.ctx.envioMail_enviarEmailPedido();
	}
    function accesoWeb():Boolean {
		return this.ctx.envioMail_accesoWeb();
	}
    function enviarEmailContacto() {
		return this.ctx.envioMail_enviarEmailContacto();
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
	connect(this.child("tbnEnviarMail"), "clicked()", this, "iface.enviarEmail()");
	connect(this.child("tbnEnviarMailPed"), "clicked()", this, "iface.enviarEmailPedido()");
	connect(this.child("tbnWeb"), "clicked()", this, "iface.accesoWeb()");
	connect(this.child("tbnEnviarMailContacto"), "clicked()", this, "iface.enviarEmailContacto()");
	//this.child("tbnEnviarMailPed").close();
}

function envioMail_enviarEmail()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var codProveedor:String = cursor.valueBuffer("codproveedor");
	var tabla:String = "proveedores";
	var emailProveedor:String = flfactppal.iface.pub_componerListaDestinatarios(codProveedor, tabla);
	if (!emailProveedor) {
		return;
	}

	var cuerpo:String = "";
	var asunto:String = "";

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailProveedor;

	var arrayAttach:Array = [];

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

function envioMail_enviarEmailPedido()
{
	var codPedido:String = this.child("tdbPedidos").cursor().valueBuffer("codigo");
	if (!codPedido) {
		return;
	}

	var codProveedor:String = this.child("tdbPedidos").cursor().valueBuffer("codproveedor");
	if (!codProveedor) {
		return;
	}
	formpedidosprov.iface.pub_enviarDocumento(codPedido, codProveedor);
}

function envioMail_accesoWeb():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var nombreNavegador = util.readSettingEntry("scripts/flfactinfo/nombrenavegador");
	if (!nombreNavegador || nombreNavegador == "") {
		MessageBox.warning(util.translate("scripts", "No tiene establecido el nombre del navegador.\nDebe establecer este valor en la pestaña Correo del formulario de empresa"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var webProveedor:String = cursor.valueBuffer("web");
	if (!webProveedor) {
		MessageBox.warning(util.translate("scripts", "Debe informar la web del proveedor"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var comando:Array = [nombreNavegador, webProveedor];
	var res:Array = flfactppal.iface.pub_ejecutarComandoAsincrono(comando);

	return true;
}

function envioMail_enviarEmailContacto()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var emailContacto:String = this.child("tdbContactos").cursor().valueBuffer("email");
	if (!emailContacto || emailContacto == "") {
		MessageBox.warning(util.translate("scripts", "El contacto no tiene el campo email informado."), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}
	var cuerpo:String = "";
	var asunto:String = "";

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailContacto;

	var arrayAttach:Array = [];

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, arrayAttach);
}

//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

