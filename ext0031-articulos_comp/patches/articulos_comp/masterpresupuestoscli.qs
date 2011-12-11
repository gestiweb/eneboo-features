
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends oficial /** %from: oficial */ {
    function articuloscomp( context ) { oficial ( context ); }
	function imprimir(codPresupuesto:String) {
		return this.ctx.articuloscomp_imprimir(codPresupuesto);
	}
}
//// ARTICULOSCOMOP  /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_imprimir(codPresupuesto:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		var util:FLUtil = new FLUtil;
		var codigo:String;
		var idPresupuesto:Number;
		if (codPresupuesto) {
			codigo = codPresupuesto;
			idPresupuesto = util.sqlSelect("presupuestoscli", "idpresupuesto", "codigo = '" + codPresupuesto + "'");
		}
		else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
			idPresupuesto = this.cursor().valueBuffer("idpresupuesto");
		}

		var dialog:Dialog = new Dialog(util.translate ( "scripts", "Imprimir Presupuesto" ), 0, "imprimir");

		dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
		dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

		var bgroup:GroupBox = new GroupBox;
		dialog.add( bgroup );

		var impPresupuesto:CheckBox = new CheckBox;
		impPresupuesto.text = util.translate ( "scripts", "Imprimir artículos con sus componentes" );
		impPresupuesto.checked = false;
		bgroup.add( impPresupuesto );

		if ( !dialog.exec() )
			return true;

		var nombreInforme:String;

		if ( impPresupuesto.checked == true ){
			nombreInforme = "i_presupuestosclicomp";
			flfactinfo.iface.pub_crearTabla("PR", idPresupuesto);
		}
		else
			nombreInforme = "i_presupuestoscli";

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_presupuestoscli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_presupuestoscli_codigo", codigo);
		curImprimir.setValueBuffer("h_presupuestoscli_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

