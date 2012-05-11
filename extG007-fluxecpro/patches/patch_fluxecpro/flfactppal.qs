
/** @class_declaration traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
class traducciones extends fluxEcommerce /** %from: oficial */ {
	var valoresTradActual:Array;
	function traducciones( context ) { fluxEcommerce ( context ); }
	function traducir(tabla:String, campo:String, idCampo:String) {
		return this.ctx.traducciones_traducir(tabla, campo, idCampo);
	}
	function valoresTrad(tabla:String, campo:String, idCampo:String) {
		return this.ctx.traducciones_valoresTrad(tabla, campo, idCampo);
	}
	function traducirValor(campo:String, tabla:String, codIdioma:String):String {
		return this.ctx.traducciones_traducirValor(campo, tabla, codIdioma);
	}
	function traducirValorIdTabla(idTabla:String, tabla:String, codIdioma:String):String {
		return this.ctx.traducciones_traducirValorIdTabla(idTabla, tabla, codIdioma);
	}
	function ordenIdiomas():String {
		return this.ctx.traducciones_ordenIdiomas();
	}
	function idiomaDefecto():String {
		return this.ctx.traducciones_idiomaDefecto();
	}
	function beforeCommit_idiomas(cursor:FLSqlCursor):Boolean {
		return this.ctx.traducciones_beforeCommit_idiomas(cursor);
	}
	function afterCommit_idiomas(cursor:FLSqlCursor):Boolean {
		return this.ctx.traducciones_afterCommit_idiomas(cursor);
	}
	function beforeCommit_traducciones(cursor:FLSqlCursor):Boolean {
		return this.ctx.traducciones_beforeCommit_traducciones(cursor);
	}
	function afterCommit_traducciones(cursor:FLSqlCursor):Boolean {
		return this.ctx.traducciones_afterCommit_traducciones(cursor);
	}
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubTraducciones */
/////////////////////////////////////////////////////////////////
//// PUB_TRADUCCIONES //////////////////////////////////////////
class pubTraducciones extends head /** %from: head */ {
	function pubTraducciones( context ) { head( context ); }
	function pub_traducir(tabla:String, campo:String, idCampo:String) {
		return this.traducir(tabla, campo, idCampo);
	}
	function pub_valoresTrad(tabla:String, campo:String, idCampo:String) {
		return this.valoresTrad(tabla, campo, idCampo);
	}
	function pub_traducirValor(campo:String, tabla:String, codIdioma:String):String {
		return this.traducirValor(campo, tabla, codIdioma);
	}
	function pub_traducirValorIdTabla(idTabla:String, tabla:String, codIdioma:String):String {
		return this.traducirValorIdTabla(idTabla, tabla, codIdioma);
	}
}

//// PUB_TRADUCCIONES //////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
function traducciones_traducir(tabla:String, campo:String, idCampo:String)
{
	var util:FLUtil = new FLUtil();
	var codIdioma:Array = [];
 	var idiomaDefecto:String = this.iface.idiomaDefecto();

	var ordenIdiomas:String = this.iface.ordenIdiomas();

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("idiomas");
	q.setFrom("idiomas");
	q.setSelect("codidioma,nombre");
	q.setWhere("1=1" + ordenIdiomas);

	if (!q.exec()) {
		return false;
	}

	if (q.size() < 2) {
		MessageBox.information(util.translate("scripts","Para realizar traducciones debe al menos definir dos idiomas"),MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	var tipoCampo = util.fieldType(campo,tabla);

	var dialog = new Dialog(util.translate ( "scripts", "Traducciones" ), 0);
	dialog.caption = "Traducciones";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	dialog.width = 600;

	var cB:Array = [];
	var nAtr:Number = 0;
	var bgroup:GroupBox;

	// Texto corto
	if (tipoCampo != 4) {
		bgroup = new GroupBox;
		bgroup.title = "";
		dialog.add( bgroup );
	}

	while (q.next())  {

		if (q.value(0) == idiomaDefecto)
			continue;

		valor = util.sqlSelect("traducciones", "traduccion", "campo = '" + campo + "' AND tabla = '" + tabla + "' AND idcampo = '" + idCampo + "' AND codidioma = '" + q.value(0) + "'");
		if (!valor)
			valor = "";

		codIdioma[nAtr] = q.value(0);

		// Texto largo
		if (tipoCampo == 4) {
			if ((nAtr % 2 == 0) && nAtr > 0)
				dialog.newColumn();

			bgroup = new GroupBox;
			bgroup.title = q.value(1);
			dialog.add( bgroup );
			cB[nAtr] = new TextEdit;
			cB[nAtr].textFormat = 0;
		}
		// Texto Corto
		else {
			cB[nAtr] = new LineEdit;
			cB[nAtr].label = q.value(1);
		}

		cB[nAtr].text = valor;
		bgroup.add( cB[nAtr] );
		nAtr ++;

	}
	if (nAtr > 0) {
		nAtr --;

		if(dialog.exec()) {

			var curTab:FLSqlCursor = new FLSqlCursor("traducciones");

			for (var i:Number = 0; i <= nAtr; i++) {

				if (!cB[i].text)
					continue;

				curTab.select("campo = '" + campo + "' AND tabla = '" + tabla + "' AND idcampo = '" + idCampo + "' AND codidioma = '" + codIdioma[i] + "'");

				if (curTab.first()) {
					curTab.setModeAccess(curTab.Edit);
					curTab.refreshBuffer();
				}
				else {
					curTab.setModeAccess(curTab.Insert);
					curTab.refreshBuffer();
					curTab.setValueBuffer("codidioma", codIdioma[i]);
					curTab.setValueBuffer("tabla", tabla);
					curTab.setValueBuffer("campo", campo);
					curTab.setValueBuffer("idcampo", idCampo);
				}

				curTab.setValueBuffer("traduccion", cB[i].text);
				curTab.commitBuffer();
			}

		}
		else
			return;
	}
}

function traducciones_idiomaDefecto():String
{
	var util:FLUtil = new FLUtil();
	var idiomaDefecto:String = util.sqlSelect("paises", "codidioma", "codpais = '" + flfactppal.iface.pub_valorDefectoEmpresa("codpais") + "'");
	return idiomaDefecto;
}

function traducciones_ordenIdiomas():String
{
	return " ";
}

function traducciones_valoresTrad(tabla:String, campo:String, idCampo:String)
{
	if (tabla) {
		this.iface.valoresTradActual = new Array(2);
		this.iface.valoresTradActual["tabla"] = tabla;
		this.iface.valoresTradActual["campo"] = campo;
		this.iface.valoresTradActual["idCampo"] = idCampo;
	}

	else
		return this.iface.valoresTradActual;
}

function traducciones_traducirValor(campo:String, tabla:String, codIdioma:String):String
{
	var util:FLUtil = new FLUtil();
	var traduccion:String;
	traduccion = util.sqlSelect("traducciones", "traduccion", "idcampo = '" + campo + "' AND codidioma = '" + codIdioma + "' AND tabla = '" + tabla + "'");
	if (!traduccion) {
		traduccion = "";
	}

	return traduccion;
}

function traducciones_traducirValorIdTabla(idTabla:String, tabla:String, codIdioma:String):String
{
	var util:FLUtil = new FLUtil();
	var traduccion:String;
	traduccion = util.sqlSelect("traducciones", "traduccion", "idcampo = '" + idTabla + "' AND codidioma = '" + codIdioma + "' AND tabla = '" + tabla + "'");
	if (!traduccion) {
		traduccion = "";
	}

	return traduccion;
}

function traducciones_beforeCommit_idiomas(cursor:FLSqlCursor):Boolean
{
	return true;
}

function traducciones_afterCommit_idiomas(cursor:FLSqlCursor):Boolean
{
	return true;
}

function traducciones_beforeCommit_traducciones(cursor:FLSqlCursor):Boolean
{
	return true;
}

function traducciones_afterCommit_traducciones(cursor:FLSqlCursor):Boolean
{
	return true;
}


//// TRADUCCIONES //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

