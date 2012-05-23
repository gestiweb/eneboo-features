
/** @class_declaration funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
class funNumSerie extends oficial {
    var tbnImprimir:Object;
    
	function funNumSerie( context ) { oficial ( context ); }
	function datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_datosLineaFactura(curLineaAlbaran);
	}
	
	function init() { this.ctx.funNumSerie_init(); }
	function imprimir(codAlbaran:String) {
		return this.ctx.funNumSerie_imprimir(codAlbaran);
	}
}
//// FUN_NUMEROS_SERIE //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE //////////////////////////////////////////

/** \D Copia los datos de una línea de remito en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si el cálculo se realiza correctamente, false en caso contrario
\end */
function funNumSerie_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{

	with (this.iface.curLineaFactura) {
 		setValueBuffer("numserie", curLineaAlbaran.valueBuffer("numserie"));
	}
	
	if(!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	return true;
}



function funNumSerie_init()
{
	this.iface.__init();

	this.iface.tbnImprimir = this.child("toolButtonPrint");

	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
}

function funNumSerie_imprimir(codAlbaran:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		var util:FLUtil = new FLUtil;
		var codigo:String;
		var idAlbaran:Number;
		if (codAlbaran) {
			codigo = codAlbaran;
			idAlbaran = util.sqlSelect("albaranesprov", "idalbaran", "codigo = '" + codAlbaran + "'");
		}
		else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
			idAlbaran = this.cursor().valueBuffer("idalbaran");
		}

		var dialog:Dialog = new Dialog(util.translate ( "scripts", "Imprimir Albarán" ), 0, "imprimir");

		dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
		dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

		var text:Object = new Label;
		text.text = util.translate("scripts","Albarán: ") + codigo;
		dialog.add(text);

		var bgroup:GroupBox = new GroupBox;
		bgroup.title = util.translate("scripts", "Opciones");
		dialog.add( bgroup );

		var impNormal:RadioButton = new RadioButton;
		impNormal.text = util.translate ( "scripts", "Imprimir normalmente" );
		impNormal.checked = true;
		bgroup.add( impNormal );

		var impComponentes:RadioButton = new RadioButton;
//		impComponentes.text = util.translate ( "scripts", "Imprimir artículos con sus componentes" );
//		impComponentes.checked = false;
//		bgroup.add( impComponentes );

		var impNumSerie:RadioButton = new RadioButton;
		impNumSerie.text = util.translate ( "scripts", "Imprimir números de serie" );
		impNumSerie.checked = false;
		bgroup.add( impNumSerie );

		if ( !dialog.exec() )
			return true;

		var nombreInforme:String;

		if ( impNormal.checked == true ) {
			nombreInforme = "i_albaranesprov";
		}
		else if ( impComponentes.checked == true ) {
			nombreInforme = "i_albaranesprovcomp";
			flfactinfo.iface.pub_crearTabla("AP", idAlbaran);
		}
		else if ( impNumSerie.checked == true ) {
			nombreInforme = "i_albaranesprov_ns";
		}

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranesprov");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_albaranesprov_codigo", codigo);
		curImprimir.setValueBuffer("h_albaranesprov_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme, "", "", false, false, "", nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
