
/** @class_declaration tpvTallColBar */
/////////////////////////////////////////////////////////////////
//// TPV PARA TALLAS Y COLORES //////////////////////////////////
class tpvTallColBar extends barCode {
    function tpvTallColBar( context ) { barCode ( context ); }
    function init() {
		return this.ctx.tpvTallColBar_init();
	}
	function refrescarStock() {
		return this.ctx.tpvTallColBar_refrescarStock();
	}
}
//// TPV PARA TALLAS Y COLORES //////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition  tpvTallColBar*/
/////////////////////////////////////////////////////////////////
//// TPV PARA TALLAS Y COLORES /////////////////////////////////
function tpvTallColBar_init()
{
	this.iface.__init();

	connect(this.child("tdbAtributosArticulos").cursor(), "bufferCommited()", this, "iface.refrescarStock()");
}

function tpvTallColBar_refrescarStock()
{
	var cursor:FLSqlCursor = this.cursor();
	if (!this.iface.refrescarTablaStock(this.iface.tblStock, this.iface.arrayStock, cursor))
		return false;

}


//// TPV PARA TALLAS Y COLORES /////////////////////////////////
//////////////////////////////////////////////////////////////

