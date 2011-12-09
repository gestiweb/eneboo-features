
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends oficial /** %from: oficial */ {
    function fluxEcommerce( context ) { oficial ( context ); }
	function init() {
		this.ctx.fluxEcommerce_init();
	}
	function validateForm():Boolean {
		return this.ctx.fluxEcommerce_validateForm();
	}
	function traducirDescripcion() {
		return this.ctx.fluxEcommerce_traducir("descripcion");
	}
	function traducirDescLarga() {
		return this.ctx.fluxEcommerce_traducir("descripcionlarga");
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////

function fluxEcommerce_init()
{
	connect(this.child("pbnTradDescripcion"), "clicked()", this, "iface.traducirDescripcion");
	connect(this.child("pbnTradDescLarga"), "clicked()", this, "iface.traducirDescLarga");

	this.child("fdbDescLarga").setTextFormat(0);
}

function fluxEcommerce_validateForm()
{
	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("formaspago", "codpago", "activo = true AND codpago <> '" + this.cursor().valueBuffer("codpago") + "'") && !this.cursor().valueBuffer("activo")) {
		MessageBox.information(util.translate("scripts",
			"Debe existir al menos una forma de pago activa"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
		return false;
	}

	return this.iface.__validateForm();
}

function fluxEcommerce_traducir(campo)
{
	return flfactalma.iface.pub_traducir("formaspago", campo, this.cursor().valueBuffer("codpago"));
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

