
/** @class_declaration funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUNNUMSERIE ////////////////////////////////////////////////
class funNumSerie extends oficial {
	var tbnImprimir:Object;

    function funNumSerie( context ) { oficial ( context ); }
	function init() { this.ctx.funNumSerie_init(); }
	function imprimir(codFactura:String) {
		return this.ctx.funNumSerie_imprimir(codFactura);
	}
	function imprimirQuick(codFactura:String, impresora:String) {
		return this.ctx.funNumSerie_imprimirQuick(codFactura, impresora);
	}
}
//// FUNNUMSERIE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUNNUMSERIE ////////////////////////////////////////////////

function funNumSerie_init()
{
	this.iface.__init();

	this.iface.tbnImprimir = this.child("toolButtonPrint");

	connect(this.iface.tbnImprimir, "clicked()", this, "iface.imprimir");
}

function funNumSerie_imprimir(codFactura:String)
{
	if (sys.isLoadedModule("flfactinfo")) {
		var util:FLUtil = new FLUtil;
		var codigo:String;
		var idFactura:Number;
		if (codFactura) {
			codigo = codFactura;
			idFactura = util.sqlSelect("facturasprov", "idfactura", "codigo = '" + codFactura + "'");
		}
		else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
			idFactura = this.cursor().valueBuffer("idfactura");
		}

		var dialog:Dialog = new Dialog(util.translate ( "scripts", "Imprimir Factura" ), 0, "imprimir");

		dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
		dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

		var text:Object = new Label;
		text.text = util.translate("scripts","Factura: ") + codigo;
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
			nombreInforme = "i_facturasprov";
		}
		else if ( impComponentes.checked == true ) {
			nombreInforme = "i_facturasprovcomp";
			flfactinfo.iface.pub_crearTabla("FP", idFactura);
		}
		else if ( impNumSerie.checked == true ) {
			nombreInforme = "i_facturasprov_ns";
		}

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturasprov");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_facturasprov_codigo", codigo);
		curImprimir.setValueBuffer("h_facturasprov_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme, "", "", false, false, "", nombreInforme);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUNNUMSERIE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

