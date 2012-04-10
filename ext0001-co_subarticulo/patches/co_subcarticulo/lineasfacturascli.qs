
/** @class_declaration ctaVentasArt */
//////////////////////////////////////////////////////////////////
//// CTA_VENTAS_ART //////////////////////////////////////////////
class ctaVentasArt extends oficial /** %from: oficial */ {

	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
	var ejercicioActual:String;
	var posActualPuntoSubcuenta:Number;

	function ctaVentasArt( context ) { oficial( context ); }
	function init() {
		this.ctx.ctaVentasArt_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.ctaVentasArt_bufferChanged(fN);
	}
	function calculateField(fN:String) {
		return this.ctx.ctaVentasArt_calculateField(fN);
	}
}
//// CTA_VENTAS_ART //////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition ctaVentasArt */
/////////////////////////////////////////////////////////////////
//// CTA_VENTAS_ART //////////////////////////////////////////////

function ctaVentasArt_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil;

	if (sys.isLoadedModule("flcontppal")) {
		this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
		this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta",
				"codejercicio = '" + this.iface.ejercicioActual + "'");
		this.iface.bloqueoSubcuenta = false;
		this.iface.posActualPuntoSubcuenta = -1;
		this.child("fdbIdSubcuenta").setFilter("codejercicio = '" + this.iface.ejercicioActual + "'");
	} else
		this.child("gbxContabilidad").enabled = false;
}


function ctaVentasArt_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	switch(fN) {
		case "codsubcuenta":
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuenta", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				this.iface.bloqueoSubcuenta = false;
			}
			break;
		case "referencia":
			this.iface.bloqueoSubcuenta = true;
			this.child("fdbCodSubcuenta").setValue(this.iface.calculateField("codsubcuenta"));
			this.iface.bloqueoSubcuenta = false;
			this.child("fdbIdSubcuenta").setValue(this.iface.calculateField("idsubcuenta"));
			var serie:String = cursor.cursorRelation().valueBuffer("codserie");
			var sinIva:Boolean = util.sqlSelect("series","siniva","codserie = '" + serie + "'");
			if(sinIva == false)
				this.child("fdbCodImpuesto").setValue(this.iface.calculateField("codimpuesto", cursor));
		default:
			this.iface.__bufferChanged(fN);
	}
}

function ctaVentasArt_calculateField(fN:String):String
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var valor:String;
	switch(fN) {
		case "codsubcuenta": {
			var referencia:String = cursor.valueBuffer("referencia");
			if(!referencia || referencia == "")
				valor = "";
			else
				valor = util.sqlSelect("articulos", "codsubcuentaven", "referencia = '" + referencia + "'");
			break
		}
		case "idsubcuenta": {
			var idFactura:Number = cursor.valueBuffer("idfactura");
			if(!idFactura) {
				valor = "";
				break;
			}
			var codEjercicio:String = util.sqlSelect("facturascli","codejercicio","idfactura = " + idFactura);
			if(!codEjercicio || codEjercicio == "") {
				valor = "";
				break;
			}
			var codSubcuenta:String = cursor.valueBuffer("codsubcuenta");
			if(!codSubcuenta || codSubcuenta == "") {
				valor = "";
				break;
			}
			var idsubcuenta:Number = util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");

			if (!idsubcuenta)
				valor = "";
// 				MessageBox.warning(util.translate("scripts", "No existe la subcuenta ")  + cursor.valueBuffer("codsubcuenta") + util.translate("scripts", " correspondiente al ejercicio ") + codEjercicio + util.translate("scripts", ".\nPara poder crear la factura debe crear antes esta subcuenta"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			else
				valor = idsubcuenta;
			break;
		}
		default:
			valor = this.iface.__calculateField(fN);
	}

	return valor;
}

//// CTA_VENTAS_ART //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

