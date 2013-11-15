
/** @class_declaration traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
class traducciones extends oficial {
    function traducciones( context ) { oficial ( context ); }
    function init() { this.ctx.traducciones_init(); }
    function traducirDescripcion() {
        return this.ctx.traducciones_traducirDescripcion();
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

    connect(this.child("pbnTradDescripcion"), "clicked()", this, "iface.traducirDescripcion");
}

function traducciones_traducirDescripcion()
{
    return flfactalma.iface.pub_traducir("familias", "descripcion", this.cursor().valueBuffer("codfamilia"));
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

