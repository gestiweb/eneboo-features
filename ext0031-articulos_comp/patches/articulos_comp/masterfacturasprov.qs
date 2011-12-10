
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
		var nombreInforme:String = "i_facturasprov";

		if (!codFactura) {
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

			if ( impFactura.checked == true ){
				nombreInforme = "i_facturasprovcomp";
				flfactinfo.iface.pub_crearTabla("FP",this.cursor().valueBuffer("idfactura"));
			}
		}

		var codigo:String;
		if (codFactura) {
			codigo = codFactura;
		} else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
		}

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturasprov");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_facturasprov_codigo", codigo);
		curImprimir.setValueBuffer("h_facturasprov_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

