
/** @class_declaration fluxecPro */
/////////////////////////////////////////////////////////////////
//// FLUX EC PRO /////////////////////////////////////////////////
class fluxecPro extends oficial /** %from: oficial */
{
	function fluxecPro( context ) { oficial ( context ); }

    function init() { this.ctx.fluxecPro_init(); }

	function cambiarPassword() {
		this.ctx.fluxecPro_cambiarPassword();
	}
	function traducirTituloSEO() {
		return this.ctx.fluxecPro_traducirTituloSEO();
	}
	function traducirDescripcionSEO() {
		return this.ctx.fluxecPro_traducirDescripcionSEO();
	}
	function traducirKeywordsSEO() {
		return this.ctx.fluxecPro_traducirKeywordsSEO();
	}
}
//// FLUX EC PRO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxecPro */
//////////////////////////////////////////////////////////////////
//// FLUX EC PRO //////////////////////////////////////////////////

function fluxecPro_init()
{
	this.iface.__init();
	connect(this.child("pbnCambiarPassword"), "clicked()", this, "iface.cambiarPassword");
	connect(this.child("pbnTradTituloSEO"), "clicked()", this, "iface.traducirTituloSEO");
	connect(this.child("pbnTradDescripcionSEO"), "clicked()", this, "iface.traducirDescripcionSEO");
}

function fluxecPro_traducirTituloSEO()
{
	return flfactppal.iface.pub_traducir("opcionestv", "tituloseo", this.cursor().valueBuffer("id"));
}

function fluxecPro_traducirDescripcionSEO()
{
	return flfactppal.iface.pub_traducir("opcionestv", "descripcionseo", this.cursor().valueBuffer("id"));
}

function fluxecPro_traducirKeywordsSEO()
{
	return flfactppal.iface.pub_traducir("opcionestv", "keywordsseo", this.cursor().valueBuffer("id"));
}

function fluxecPro_cambiarPassword()
{
	var util:FLUtil = new FLUtil;

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
	this.cursor().setValueBuffer("managerpass", password.toLowerCase());
}

//// FLUX EC PRO //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

