
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends oficial /** %from: oficial */ {
    function articuloscomp( context ) { oficial ( context ); }
	function imprimir(codAlbaran:String) {
		return this.ctx.articuloscomp_imprimir(codAlbaran);
	}
}
//// ARTICULOSCOMOP  /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_imprimir(codAlbaran:String)
{
	if (sys.isLoadedModule("flfactinfo")) {

		var util:FLUtil = new FLUtil();
		var nombreInforme:String = "i_albaranesprov";

		if (!codAlbaran) {
			var dialog:Dialog = new Dialog(util.translate ( "scripts", "Imprimir Albaran" ), 0, "imprimir");

			dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
			dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

			var bgroup:GroupBox = new GroupBox;
			dialog.add( bgroup );

			var impAlbaran:CheckBox = new CheckBox;
			impAlbaran.text = util.translate ( "scripts", "Imprimir artículos con sus componentes" );
			impAlbaran.checked = false;
			bgroup.add( impAlbaran );

			if ( !dialog.exec() )
				return true;


			if ( impAlbaran.checked == true ){
				nombreInforme = "i_albaranesprovcomp";
				flfactinfo.iface.pub_crearTabla("AP",this.cursor().valueBuffer("idalbaran"));
			}
		}

		var codigo:String;
		if (codAlbaran) {
			codigo = codAlbaran;
		} else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
		}

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranesprov");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_albaranesprov_codigo", codigo);
		curImprimir.setValueBuffer("h_albaranesprov_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

