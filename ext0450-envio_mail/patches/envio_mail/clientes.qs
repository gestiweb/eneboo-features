
/** @class_declaration envioMail */
/////////////////////////////////////////////////////////////////
//// ENVIO MAIL /////////////////////////////////////////////////
class envioMail extends oficial {
    function envioMail( context ) { oficial ( context ); }
    function init() { 
		return this.ctx.envioMail_init(); 
	}
    function enviarEmail() { 
		return this.ctx.envioMail_enviarEmail(); 
	}
    function enviarEmailPresupuesto() { 
		return this.ctx.envioMail_enviarEmailPresupuesto(); 
	}
    function enviarEmailPedido() { 
		return this.ctx.envioMail_enviarEmailPedido(); 
	}
    function enviarEmailAlbaran() { 
		return this.ctx.envioMail_enviarEmailAlbaran(); 
	}
    function enviarEmailFactura() { 
		return this.ctx.envioMail_enviarEmailFactura(); 
	}
    function enviarEmailRecibo() { 
		return this.ctx.envioMail_enviarEmailRecibo(); 
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
	connect(this.child("tbnEnviarMailPr"), "clicked()", this, "iface.enviarEmailPresupuesto()");
	connect(this.child("tbnEnviarMailPed"), "clicked()", this, "iface.enviarEmailPedido()");
	connect(this.child("tbnEnviarMailAlb"), "clicked()", this, "iface.enviarEmailAlbaran()");
	connect(this.child("tbnEnviarMailFac"), "clicked()", this, "iface.enviarEmailFactura()");
	connect(this.child("tbnEnviarMailRec"), "clicked()", this, "iface.enviarEmailRecibo()");
	connect(this.child("tbnWeb"), "clicked()", this, "iface.accesoWeb()");
	connect(this.child("tbnEnviarMailContacto"), "clicked()", this, "iface.enviarEmailContacto()");
/*	this.child("tbnEnviarMailPr").close();
	this.child("tbnEnviarMailPed").close();
	this.child("tbnEnviarMailAlb").close();
	this.child("tbnEnviarMailFac").close();
	this.child("tbnEnviarMailRec").close();*/
}

function envioMail_enviarEmail()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	var codCliente:String = cursor.valueBuffer("codcliente");
	var tabla:String = "clientes";
	var emailCliente:String = flfactppal.iface.pub_componerListaDestinatarios(codCliente, tabla);

	if (!emailCliente) {
		return;
	}
	var cuerpo:String = "";
	var asunto:String = "";

	var arrayDest:Array = [];
	arrayDest[0] = [];
	arrayDest[0]["tipo"] = "to";
	arrayDest[0]["direccion"] = emailCliente;

	var arrayAttach:Array = [];

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, false);
}

function envioMail_enviarEmailPresupuesto()
{
	var codPresupuesto:String = this.child("tdbPresupuestos").cursor().valueBuffer("codigo");
	if (!codPresupuesto) {
		return;
	}

	var codCliente:String = this.child("tdbPresupuestos").cursor().valueBuffer("codcliente");
	if (!codCliente) {
		return;
	}
	
	formpresupuestoscli.iface.pub_enviarDocumento(codPresupuesto, codCliente);
}

function envioMail_enviarEmailPedido()
{
	var codPedido:String = this.child("tdbPedidos").cursor().valueBuffer("codigo");
	if (!codPedido) {
		return;
	}

	var codCliente:String = this.child("tdbPedidos").cursor().valueBuffer("codcliente");
	if (!codCliente) {
		return;
	}
	formpedidoscli.iface.pub_enviarDocumento(codPedido, codCliente);
}

function envioMail_enviarEmailAlbaran()
{
	var codAlbaran:String = this.child("tdbAlbaranes").cursor().valueBuffer("codigo");
	if (!codAlbaran) {
		return;
	}

	var codCliente:String = this.child("tdbAlbaranes").cursor().valueBuffer("codcliente");
	if (!codCliente) {
		return;
	}
	formalbaranescli.iface.pub_enviarDocumento(codAlbaran, codCliente);
}

function envioMail_enviarEmailFactura()
{
	var codFactura:String = this.child("tdbFacturas").cursor().valueBuffer("codigo");
	if (!codFactura) {
		return;
	}

	var codCliente:String = this.child("tdbFacturas").cursor().valueBuffer("codcliente");
	if (!codCliente) {
		return;
	}
	formfacturascli.iface.pub_enviarDocumento(codFactura, codCliente);
}

function envioMail_enviarEmailRecibo()
{
	var codRecibo:String = this.child("tdbRecibos").cursor().valueBuffer("codigo");
	if (!codRecibo) {
		return;
	}

	var codCliente:String = this.child("tdbRecibos").cursor().valueBuffer("codcliente");
	if (!codCliente) {
		return;
	}
	formreciboscli.iface.pub_enviarDocumento(codRecibo, codCliente);
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

	var webCliente:String = cursor.valueBuffer("web");
	if (!webCliente) {
		MessageBox.warning(util.translate("scripts", "Debe informar la web del cliente"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var comando:Array = [nombreNavegador, webCliente];
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

	flfactppal.iface.pub_enviarCorreo(cuerpo, asunto, arrayDest, false);
}

//// ENVIO MAIL /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

