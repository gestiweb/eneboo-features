
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends oficial /** %from: oficial */ {
    function articuloscomp( context ) { oficial ( context ); }
	function imprimir(codFactura:String) {
		return this.ctx.articuloscomp_imprimir(codFactura);
	}
}
//// ARTICULOSCOMOP  /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_imprimir(codFactura:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		var util:FLUtil = new FLUtil();

		var dialog:Dialog = new Dialog(util.translate ( "scripts", "Imprimir Factura" ), 0, "imprimir");

		dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
		dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

		var bgroup:GroupBox = new GroupBox;
		dialog.add( bgroup );

		var impFactura:CheckBox = new CheckBox;
		impFactura.text = util.translate ( "scripts", "Imprimir artículos con sus componentes" );
		impFactura.checked = false;
		bgroup.add( impFactura );

		if ( !dialog.exec() )
			return true;

		var nombreInforme:String;

		var codigo:String;
		var idFactura:Number;
		if (codFactura) {
			codigo = codFactura;
			idFactura = util.sqlSelect("facturascli", "idfactura", "codigo = '" + codFactura + "'");
		} else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
			idFactura = this.cursor().valueBuffer("idfactura");
		}


		if ( impFactura.checked == true ){
			nombreInforme = "i_facturasclicomp";
			flfactinfo.iface.pub_crearTabla("FC", idFactura);
		}
		else
			nombreInforme = "i_facturascli";

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturascli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
		curImprimir.setValueBuffer("h_facturascli_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

