
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends oficial {
    function fluxEcommerce( context ) { oficial ( context ); }
	function init() {
		this.ctx.fluxEcommerce_init();
	}
	function validateForm():Boolean {
		return this.ctx.fluxEcommerce_validateForm();
	}
	function traducirDescLarga() {
		return this.ctx.fluxEcommerce_traducir("descripcionlarga");
	}
	function bufferChanged(fN:String) {
		return this.ctx.fluxEcommerce_bufferChanged(fN);
	}
	function insertarZona() {
		return this.ctx.fluxEcommerce_insertarZona();
	}
	function quitarZona() {
		return this.ctx.fluxEcommerce_quitarZona();
	}
	function tabSelected(nomTab:String) {
		return this.ctx.fluxEcommerce_tabSelected(nomTab);
	}
	function controlPorZonas() {
		return this.ctx.fluxEcommerce_controlPorZonas();
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////

function fluxEcommerce_init()
{
	connect(this.child("pbnTradDescLarga"), "clicked()", this, "iface.traducirDescLarga");

	this.child("fdbDescLarga").setTextFormat(0);
	this.child("tdbZonasVenta").cursor().setMainFilter("codzona not in (select codzona from zonasformaspago where codpago = '" + this.cursor().valueBuffer("codpago") + "')");

 	connect(this.child("tbwFormasPago"), "currentChanged(QString)", this, "iface.tabSelected");
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	connect (this.child("tbIncluir"), "clicked()", this, "iface.insertarZona()");
	connect (this.child("tbExcluir"), "clicked()", this, "iface.quitarZona()");

	this.iface.controlPorZonas();
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
	return flfactppal.iface.pub_traducir("formaspago", campo, this.cursor().valueBuffer("codpago"));
}

function fluxEcommerce_bufferChanged(fN:String)
{
	switch (fN) {
		case "controlporzonas":
			this.iface.controlPorZonas();
		break;
	}
}

function fluxEcommerce_insertarZona()
{
	var util:FLUtil;

	var cursor:FLSqlCursor = this.cursor();
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		if (!this.child("tdbZonasVenta").cursor().commitBufferCursorRelation())
			return;
	}

	var curTab:FLSqlCursor = this.child("tdbZonasVenta").cursor();
	if (!curTab.isValid())
		return;

	var codZona:String = curTab.valueBuffer("codzona");
	curTab = new FLSqlCursor("zonasformaspago");
	curTab.setModeAccess(curTab.Insert);
	curTab.refreshBuffer();
	curTab.setValueBuffer("codzona", codZona);
	curTab.setValueBuffer("codpago", cursor.valueBuffer("codpago"));
	curTab.commitBuffer();

	this.child("tdbZonasVenta").refresh();
	this.child("tdbZonasPago").refresh();
}

function fluxEcommerce_quitarZona()
{
	var util:FLUtil;

	var curTab:FLSqlCursor = this.child("tdbZonasPago").cursor();
	if (!curTab.isValid())
		return;

	curTab.setModeAccess(curTab.Del);
	curTab.refreshBuffer();
	curTab.commitBuffer();

	this.child("tdbZonasVenta").refresh();
	this.child("tdbZonasPago").refresh();
}

function fluxEcommerce_tabSelected(nomTab:String)
{
	debug(nomTab);
	if (nomTab == "precios")
		this.iface.reloadZonas();
}


function fluxEcommerce_controlPorZonas()
{
	if (this.cursor().valueBuffer("controlporzonas"))  {
		this.child("tbwFormasPago").setTabEnabled("zonas", true);
	}
	else {
		this.child("tbwFormasPago").setTabEnabled("zonas", false);
	}
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

