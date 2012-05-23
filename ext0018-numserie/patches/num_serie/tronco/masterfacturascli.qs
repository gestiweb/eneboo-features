
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
		var util:FLUtil = new FLUtil();
		var codigo:String;
		var idFactura:Number;
		if (codFactura) {
			codigo = codFactura;
			idFactura = util.sqlSelect("facturascli", "idfactura", "codigo = '" + codFactura + "'");
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

		if ( util.sqlSelect("servicioscli INNER JOIN albaranescli ON servicioscli.idalbaran = albaranescli.idalbaran", "servicioscli.idservicio", "albaranescli.idfactura = " + idFactura, "servicioscli,albaranescli") ) {
			var impServicio:RadioButton = new RadioButton;
			impServicio.text = util.translate ( "scripts", "Imprimir Servicio" );
			impServicio.checked = false;
			bgroup.add( impServicio );
		}

		var impFactura:RadioButton = new RadioButton;
		impFactura.text = util.translate ( "scripts", "Imprimir Factura" );
		impFactura.checked = true;
		bgroup.add( impFactura );

		var impComponentes:CheckBox = new CheckBox;
//		impComponentes.text = util.translate ( "scripts", "Imprimir artículos con sus componentes" );
//		impComponentes.checked = flfactppal.iface.pub_valorDefectoEmpresa("imprimircomponentes");
//		bgroup.add( impComponentes );

		var impNumSerie:CheckBox = new CheckBox;
		impNumSerie.text = util.translate ( "scripts", "Imprimir números de serie" );
		impNumSerie.checked = flfactppal.iface.pub_valorDefectoEmpresa("imprimirnumserie");
		bgroup.add( impNumSerie );

		if ( !dialog.exec() )
			return true;

		var nombreInforme:String;
		var numCopias:Number = flfactppal.iface.pub_valorDefectoEmpresa("copiasfactura");
		if (!numCopias)
			numCopias = 1;

		if ( impFactura.checked == true) {

			if ( impComponentes.checked == true ) {
				if ( impNumSerie.checked == true ) {
					nombreInforme = "i_facturasclicomp_ns";
					flfactinfo.iface.pub_crearTabla("FC", idFactura);
				} else {
					nombreInforme = "i_facturasclicomp";
					flfactinfo.iface.pub_crearTabla("FC", idFactura);
				}
			} else {
				if ( impNumSerie.checked == true ) {
					nombreInforme = "i_facturascli_ns";
				} else {
					nombreInforme = "i_facturascli";
				}
			}
		}
		else {
			nombreInforme = "i_facturascli_serv";
		}

		var nombreReport:String = nombreInforme;
		if ( util.sqlSelect("facturascli", "tipoventa", "codigo = '" + codigo + "'") == "Factura A" )
			nombreReport += "_a";

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_facturascli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_facturascli_codigo", codigo);
		curImprimir.setValueBuffer("h_facturascli_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme, "", "", false, false, "", nombreReport, numCopias);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}

//// FUNNUMSERIE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


