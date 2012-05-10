
/** @class_declaration traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
class traducciones extends fluxEcommerce {
    function traducciones( context ) { fluxEcommerce ( context ); }
    function init() {
		return this.ctx.traducciones_init();
	}
    function traducirFamilia() {
		return this.ctx.traducciones_traducirFamilia();
	}
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
function traducciones_init()
{
	this.iface.__init();
	connect(this.child("pbnTradDescripcion"), "clicked()", this, "iface.traducirFamilia");
}

function traducciones_traducirFamilia()
{
	return flfactppal.iface.pub_traducir("familias", "descripcion", this.cursor().valueBuffer("codfamilia"));
}

//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

