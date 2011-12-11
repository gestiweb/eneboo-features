
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends oficial /** %from: oficial */ {
    function articuloscomp( context ) { oficial ( context ); }
	function imprimir(codPedido:String) {
		return this.ctx.articuloscomp_imprimir(codPedido);
	}
}
//// ARTICULOSCOMOP  /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_imprimir(codPedido:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		var util:FLUtil = new FLUtil;
		var codigo:String;
		var idPedido:Number;
		if (codPedido) {
			codigo = codPedido;
			idPedido = util.sqlSelect("pedidoscli", "idpedido", "codigo = '" + codPedido + "'");
		}
		else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
			idPedido = this.cursor().valueBuffer("idpedido");
		}

		var dialog:Dialog = new Dialog(util.translate ( "scripts", "Imprimir Pedido" ), 0, "imprimir");

		dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
		dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

		var bgroup:GroupBox = new GroupBox;
		dialog.add( bgroup );

		var impPedido:CheckBox = new CheckBox;
		impPedido.text = util.translate ( "scripts", "Imprimir artículos con sus componentes" );
		impPedido.checked = false;
		bgroup.add( impPedido );

		if ( !dialog.exec() )
			return true;

		var nombreInforme:String;

		if ( impPedido.checked == true ){
			nombreInforme = "i_pedidosclicomp";
			flfactinfo.iface.pub_crearTabla("PC", idPedido);
		}
		else
			nombreInforme = "i_pedidoscli";

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_pedidoscli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_pedidoscli_codigo", codigo);
		curImprimir.setValueBuffer("h_pedidoscli_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

