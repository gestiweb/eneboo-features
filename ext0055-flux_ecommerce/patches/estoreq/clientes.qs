
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends oficial /** %from: oficial */ {
    function fluxEcommerce( context ) { oficial ( context ); }
	function init() {
		this.ctx.fluxEcommerce_init();
	}
	function cambiarPassword() {
		this.ctx.fluxEcommerce_cambiarPassword();
	}
	function validateForm():Boolean {
		return this.ctx.fluxEcommerce_validateForm();
	}
	function obtenerCodigoCliente(cursor:FLSqlCursor):String {
		return this.ctx.fluxEcommerce_obtenerCodigoCliente(cursor);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
function fluxEcommerce_init()
{
	this.iface.__init();
	connect(this.child("pbnCambiarPassword"), "clicked()", this, "iface.cambiarPassword");
}

function fluxEcommerce_cambiarPassword()
{
	var util:FLUtil = new FLUtil;

/*	if (util.sqlSelect("opcionestv", "arquitectura", "1=1") == util.translate("scripts", "Distribuida")) {
		MessageBox.information(util.translate("scripts", "Sólo se puede cambiar el password de los clientes\npara la configuración de base de datos unificada"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return;
	}*/

	var res = MessageBox.information(util.translate("scripts", "Esta acción no podrá deshacerse. ¿Está seguro?"), MessageBox.Yes, MessageBox.No);
	if (res != MessageBox.Yes)
		return;

	var password:String = Input.getText( "Nuevo password:" );

	if (!password)
		return;

	if (password.length < 6) {
		MessageBox.critical(util.translate("scripts", "El password debe tener al menos 6 dígitos"), MessageBox.Ok);
		return;
	}

	password = util.sha1(password);
	this.cursor().setValueBuffer("password", password.toLowerCase());
}

function fluxEcommerce_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;

	/** \C Los clientes con código > 500.000 se reservan para la web
	\end */
	if (cursor.modeAccess() == cursor.Insert &&	cursor.valueBuffer("codcliente").toString() >= "500000") {
		MessageBox.warning(util.translate("scripts", "El código de cliente ha de ser menor de 500.000\nLos códigos a partir de 500.000 se reservan para los clientes dados de alta desde la web"), MessageBox.Ok, MessageBox.NoButton)
		return false;
	}

	/** \C Si es un cliente web se deben rellenar los campos de --email--, --password--, --contacto-- y --apellidos--
	\end */
	if (cursor.valueBuffer("clienteweb")) {
		if (!cursor.valueBuffer("email") || !cursor.valueBuffer("password") || !cursor.valueBuffer("contacto") || !cursor.valueBuffer("apellidos")) {
			MessageBox.warning(util.translate("scripts", "Para los clientes web es necesario rellenar los datos\nE-mail, Password, Nombre y Apellidos, "), MessageBox.Ok, MessageBox.NoButton)
			return false;
		}
	}

	return this.iface.__validateForm();
}

function fluxEcommerce_obtenerCodigoCliente(cursor:FLSqlCursor):String
{
	var util:FLUtil = new FLUtil();
	var numCliente:Number = parseFloat(util.sqlSelect("clientes", "max(codcliente)", "codcliente < '500000'"));
	if (!numCliente)
		numCliente = 0;
	numCliente++;
	return flfacturac.iface.pub_cerosIzquierda(numCliente.toString(), 6);
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

