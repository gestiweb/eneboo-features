
/** @class_declaration modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
class modelo303 extends modelo390 /** %from: modelo390 */ {
	function modelo303( context ) { modelo390 ( context ); }
	function init() {
		this.ctx.modelo303_init();
	}
	function informarTiposDec303() {
		this.ctx.modelo303_informarTiposDec303();
	}
	function informarCasillas303() {
			this.ctx.modelo303_informarCasillas303();
	}
}
//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition modelo303 */
/////////////////////////////////////////////////////////////////
//// MODELO 303 /////////////////////////////////////////////////
function modelo303_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil;

	if (!util.sqlSelect("co_tipodec303", "idtipodec", "1 = 1")) {
		this.iface.informarTiposDec303();
	}
	this.iface.informarCasillas303();
}

function modelo303_informarTiposDec303()
{
	var curTipoDec:FLSqlCursor = new FLSqlCursor("co_tipodec303");
	var valores:Array = [["C", "Solicitud de compensación"],
		["D", "Devolución"],
		["G", "Cuenta corriente tributaria - ingreso"],
		["I", "Ingreso"],
		["N", "Sin actividad / resultado 0"],
		["V", "Cuenta corriente tributaria - devolución"],
		["U", "Domiciliación de ingreso en CCC"]];

	for (var i:Number = 0; i < valores.length; i++) {
		with (curTipoDec) {
			setModeAccess(Insert);
			refreshBuffer();
			setValueBuffer("idtipodec", valores[i][0]);
			setValueBuffer("descripcion", valores[i][1]);
			commitBuffer();
		}
	}
}

function modelo303_informarCasillas303()
{
	var util:FLUtil = new FLUtil;

	var contenido:String = "<Todos>" +
	"<co_casillas303 casilla='[01]-[09]' descripcion='" + util.translate("scripts", "I.V.A. Devengado - Régimen General") + "' />" +
	"<co_casillas303 casilla='[10]-[18]' descripcion='" + util.translate("scripts", "I.V.A. Devengado Recargo de equivalencia Régimen General") + "' />" +
	"<co_casillas303 casilla='[19]-[20]' descripcion='" + util.translate("scripts", "I.V.A. Devengado Adquisiciones intracomunitarias") + "' />" +
	"<co_casillas303 casilla='[22]-[23]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en operaciones interiores con bienes corrientes") + "' />" +
	"<co_casillas303 casilla='[24]-[25]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en operaciones interiores con bienes de inversión") + "' />" +
	"<co_casillas303 casilla='[26]-[27]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en importaciones de bienes corrientes") + "' />" +
	"<co_casillas303 casilla='[28]-[29]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en importaciones de bienes de inversión") + "' />" +
	"<co_casillas303 casilla='[30]-[31]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en adquisiciones intracomunitarias de bienes corrientes") + "' />" +
	"<co_casillas303 casilla='[32]-[33]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por cuotas soportadas en adquisiciones intracomunitarias de bienes de inversión") + "' />" +
	"<co_casillas303 casilla='[34]' descripcion='" + util.translate("scripts", "I.V.A. Deducible por compensaciones de regimen especial A.G.y P.") + "' />" +
	"<co_casillas303 casilla='[42]' descripcion='" + util.translate("scripts", "Entregas intracomunitarias") + "' />" +
	"<co_casillas303 casilla='[43]' descripcion='" + util.translate("scripts", "Exportaciones y operaciones asimilables") + "' />" +
	"<co_casillas303 casilla='[44]' descripcion='" + util.translate("scripts", "Operaciones no sujetas o con inversión del sujeto pasivo que originan derecho a deducción") + "' />" +
	"</Todos>";

	xmlDoc = new FLDomDocument();
	if (!xmlDoc.setContent(contenido)) {
debug("!xmlDoc.setContent(contenido)");
		return false;
	}
	var xmlOD:FLDomNodeList = xmlDoc.elementsByTagName("co_casillas303");
	var eOD:FLDomElement;
	var curCasillas:FLSqlCursor = new FLSqlCursor("co_casillas303");
	for (var i:Number = 0; i < xmlOD.length(); i++) {
		eOD = xmlOD.item(i).toElement();
		curCasillas.setModeAccess(curCasillas.Insert);
		curCasillas.refreshBuffer();
		if (util.sqlSelect("co_casillas303", "casilla303", "casilla303 = '" + eOD.attribute("casilla") + "'")) {
			continue;
		}
		curCasillas.setValueBuffer("casilla303", eOD.attribute("casilla"));
		curCasillas.setValueBuffer("descripcion", eOD.attribute("descripcion"));
		if (!curCasillas.commitBuffer()) {
			return false;
		}
	}
	return true;
}

//// MODELO 303 /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

