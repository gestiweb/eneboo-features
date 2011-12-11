
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
		var util:FLUtil = new FLUtil;
		var codigo:String;
		var idAlbaran:Number;
		if (codAlbaran) {
			codigo = codAlbaran;
			idAlbaran = util.sqlSelect("albaranescli", "idalbaran", "codigo = '" + codAlbaran + "'");
		}
		else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
			idAlbaran = this.cursor().valueBuffer("idalbaran");
		}

		var nombreInforme:String = "i_albaranescli";

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
			nombreInforme = "i_albaranesclicomp";
			flfactinfo.iface.pub_crearTabla("AC", idAlbaran);
		}
		else {
			nombreInforme = "i_albaranescli";
		}

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranescli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
		curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

