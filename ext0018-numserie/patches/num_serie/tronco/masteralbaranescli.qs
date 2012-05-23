
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
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

/** \D Copia los datos de una línea de albarán en una línea de factura
@param	curLineaAlbaran: Cursor que contiene los datos a incluir en la línea de factura
@return	True si la copia se realiza correctamente, false en caso contrario
\end */
function funNumSerie_datosLineaFactura(curLineaAlbaran:FLSqlCursor):Boolean
{
	if(!this.iface.__datosLineaFactura(curLineaAlbaran))
		return false;

	with (this.iface.curLineaFactura) {
		setValueBuffer("numserie", curLineaAlbaran.valueBuffer("numserie"));
	}
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
			idAlbaran = util.sqlSelect("albaranescli", "idalbaran", "codigo = '" + codAlbaran + "'");
		}
		else {
			if (!this.cursor().isValid())
				return;
			codigo = this.cursor().valueBuffer("codigo");
			idAlbaran = this.cursor().valueBuffer("idalbaran");
		}

		var idLinea:Number = util.sqlSelect("lineasalbaranescli", "idlinea", "idalbaran = " + idAlbaran + " AND idlineapedido <> 0");

		var dialog:Dialog = new Dialog(util.translate ( "scripts", "Imprimir Albarán" ), 0, "imprimir");

		dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
		dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );

		var text:Object = new Label;
		text.text = util.translate("scripts","Albarán: ") + codigo;
		dialog.add(text);

		var bgroup:GroupBox = new GroupBox;
		bgroup.title = util.translate("scripts", "Opciones");
		dialog.add( bgroup );

		if ( util.sqlSelect("servicioscli", "idservicio", "idalbaran = " + idAlbaran) ) {
			var impServicio:RadioButton = new RadioButton;
			impServicio.text = util.translate ( "scripts", "Imprimir Servicio" );
			impServicio.checked = false;
			bgroup.add( impServicio );
		}

		var impRemito:RadioButton = new RadioButton;
		impRemito.text = util.translate ( "scripts", "Imprimir Albarán" );
		impRemito.checked = true;
		bgroup.add( impRemito );

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
		var numCopias:Number = flfactppal.iface.pub_valorDefectoEmpresa("copiasalbaran");
		if (!numCopias)
			numCopias = 1;

		if ( impRemito.checked == true) {

			if ( impComponentes.checked == true ) {
				if ( impNumSerie.checked == true ) {
					nombreInforme = "i_albaranesclicomp_ns";
					flfactinfo.iface.pub_crearTabla("AC", idAlbaran);
				} else {
					if (idLinea)
						nombreInforme = "i_albaranesclicomp_auto";
					else
						nombreInforme = "i_albaranesclicomp";
					flfactinfo.iface.pub_crearTabla("AC", idAlbaran);
				}
			} else {
				if ( impNumSerie.checked == true ) {
					nombreInforme = "i_albaranescli_ns";
				} else {
					if (idLinea)
						nombreInforme = "i_albaranescli_auto";
					else
						nombreInforme = "i_albaranescli";
				}
			}
		}
		else {
			nombreInforme = "i_albaranescli_serv";
		}

		var curImprimir:FLSqlCursor = new FLSqlCursor("i_albaranescli");
		curImprimir.setModeAccess(curImprimir.Insert);
		curImprimir.refreshBuffer();
		curImprimir.setValueBuffer("descripcion", "temp");
		curImprimir.setValueBuffer("d_albaranescli_codigo", codigo);
		curImprimir.setValueBuffer("h_albaranescli_codigo", codigo);

		flfactinfo.iface.pub_lanzarInforme(curImprimir, nombreInforme, "", "", false, false, "", nombreInforme, numCopias);
	} else
		flfactppal.iface.pub_msgNoDisponible("Informes");
}






//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


