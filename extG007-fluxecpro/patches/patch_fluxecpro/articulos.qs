
/** @class_declaration traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
class traducciones extends fluxEcommerce /** %from: fluxEcommerce */ {
    function traducciones( context ) { fluxEcommerce ( context ); }
    function init() {
		return this.ctx.traducciones_init();
	}
	function traducirDescripcion() {
		return this.ctx.traducciones_traducirDescripcion();
	}
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration fluxecPro */
/////////////////////////////////////////////////////////////////
//// FLUX EC PRO /////////////////////////////////////////////////
class fluxecPro extends traducciones /** %from: traducciones */ {
    function fluxecPro( context ) { traducciones ( context ); }
	function init() {
		this.ctx.fluxecPro_init();
	}
	function traducirDescripcionSEO() {
		return this.ctx.fluxecPro_traducirDescripcionSEO();
	}
}
//// FLUX EC PRO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES //////////////////////////////////////////////
function traducciones_init()
{
	this.iface.__init();
	connect(this.child("pbnTradDescripcion"), "clicked()", this, "iface.traducirDescripcion");
}

function traducciones_traducirDescripcion()
{
	return flfactppal.iface.pub_traducir("articulos", "descripcion", this.cursor().valueBuffer("referencia"));
}

//// TRADUCCIONES //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxecPro */
//////////////////////////////////////////////////////////////////
//// FLUX EC PRO //////////////////////////////////////////////////
function fluxecPro_init()
{
	this.iface.__init();
	connect(this.child("pbnTradDescripcionSEO"), "clicked()", this, "iface.traducirDescripcionSEO");
}

function fluxecPro_traducirDescripcionSEO()
{
	return flfactppal.iface.pub_traducir("articulos", "descripcionseo", this.cursor().valueBuffer("referencia"));
}
//// FLUX EC PRO //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

