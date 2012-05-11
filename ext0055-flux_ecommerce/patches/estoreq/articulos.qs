
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends oficial {
    function fluxEcommerce( context ) { oficial ( context ); }
	function init() {
		this.ctx.fluxEcommerce_init();
	}
	function validateForm():Boolean {
		return this.ctx.fluxEcommerce_validateForm();
	}
	function bufferChanged(fN:String) {
		return this.ctx.fluxEcommerce_bufferChanged(fN);
	}
	function seleccionarImagen() {
		return this.ctx.fluxEcommerce_seleccionarImagen();
	}
	function editarAtributos() {
		return this.ctx.fluxEcommerce_editarAtributos();
	}
	function editarAtributos() {
		return this.ctx.fluxEcommerce_editarAtributos();
	}
	function actualizarPvpOferta() {
		return this.ctx.fluxEcommerce_actualizarPvpOferta();
	}
	function actualizarControlesOferta() {
		return this.ctx.fluxEcommerce_actualizarControlesOferta();
	}
	function traducirDescripcion() {
		return this.ctx.fluxEcommerce_traducirDescripcion();
	}
	function traducirDescPublica() {
		return this.ctx.fluxEcommerce_traducirDescPublica();
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
function fluxEcommerce_init()
{
	this.iface.__init();
	connect(this.child("pbnImagen"), "clicked()", this, "iface.seleccionarImagen");
	connect(this.child("pbnEditarAtributos"), "clicked()", this, "iface.editarAtributos");
	connect(this.child("pbnTradDescripcion"), "clicked()", this, "iface.traducirDescripcion");
	connect(this.child("pbnTradDescPublica"), "clicked()", this, "iface.traducirDescPublica");

	this.iface.actualizarControlesOferta();

	this.child("fdbDescPublica").setTextFormat(0);
}

function fluxEcommerce_validateForm():Boolean
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();

	if (cursor.valueBuffer("enoferta") && parseFloat(cursor.valueBuffer("pvpoferta")) > parseFloat(cursor.valueBuffer("pvp"))) {
		MessageBox.critical(util.translate("scripts","El precio de oferta no puede ser mayor que el precio normal"),
				MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
		return false;
	}

	if (cursor.valueBuffer("enoferta") && parseFloat(cursor.valueBuffer("pvpoferta")) == 0) {
		MessageBox.critical(util.translate("scripts","Debe indicar un precio de oferta"),
				MessageBox.Ok, MessageBox.NoButton,MessageBox.NoButton);
		return false;
	}

	return true;
}

function fluxEcommerce_bufferChanged(fN:String)
{
	var cursor:FLSqlCursor = this.cursor();

	switch (fN) {
		case "pvp":
		case "codtarifa":
			this.iface.actualizarPvpOferta();
		break;
		case "enoferta":
			this.iface.actualizarControlesOferta();
		break;
		default:
			return this.iface.__bufferChanged(fN);
	}
}

function fluxEcommerce_seleccionarImagen()
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("opcionestv", "arquitectura", "1=1") != "Unificada") {
		MessageBox.warning(util.translate("scripts", "Sólo es posible la copia de imágenes para arquitectura unificada"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	var rutaDestino:String = util.sqlSelect("opcionestv", "rutaweb", "1 = 1");

	if (!File.exists(rutaDestino)) {
		MessageBox.warning(util.translate("scripts", "No se ha establecido la ruta a la web en las opciones generales,\no la ruta no es válida"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	if (rutaDestino.right(1) != "\\" && rutaDestino.right(1) != "/")
		rutaDestino += "/";

	var cursor:FLSqlCursor = this.cursor();
	var archivo:String = FileDialog.getOpenFileName("*.jpg;*.png;*.gif", util.translate("scripts","Elegir Fichero"));

	if (!archivo)
		return;

	var file = new File( archivo );
	var extension:String = file.extension;
	if (extension.length > 3)
		extension = extension.right(3);

	// Abrir el fichero	de lectura
	try {
		file.open( File.ReadOnly );
	}
	catch (e) {
		MessageBox.warning(util.translate("scripts", "Se produjo el error siguiente al tratar de abrir el fichero de imagen:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	rutaDestino += "catalogo/img_normal/" + cursor.valueBuffer("referencia") + "." + extension;

	var outfile = new File(rutaDestino);

	// Abrir el fichero	de escritura y copiar el contenido original
	try {
		outfile.open(File.WriteOnly);
		while (!file.eof)
			outfile.writeByte( file.readByte() );
	}
	catch (e) {
		MessageBox.warning(util.translate("scripts", "Se produjo el error siguiente al tratar de copiar el fichero de imagen:\n") + e, MessageBox.Ok, MessageBox.NoButton);
		return false;
	}

	file.close();
	outfile.close();

	if (File.exists(rutaDestino)) {
		cursor.setValueBuffer("fechaimagen", 0);
		cursor.setValueBuffer("tipoimagen", extension);
		MessageBox.information(util.translate("scripts", "Se copió correctamente la imagen en la página web"), MessageBox.Ok, MessageBox.NoButton);
	}
	else {
		MessageBox.warning(util.translate("scripts", "No se pudo copiar la imagen en la página web"), MessageBox.Ok, MessageBox.NoButton);
		return false;
	}


	return true;
}


/** \D Abre un diálogo para la edición rápida de atributos
\end */
function fluxEcommerce_editarAtributos()
{
	var util:FLUtil = new FLUtil();
	var referencia:String = this.cursor().valueBuffer("referencia");
	var codFamilia:String = this.cursor().valueBuffer("codfamilia");
	var codAtr:Array = [];

	var q:FLSqlQuery = new FLSqlQuery();

	// Si no hay familia buscamos atributos que no pertenecen a un grupo
	if (!codFamilia) {
		q.setTablesList("atributos");
		q.setFrom("atributos");
		q.setSelect("codatributo,nombre");
		q.setWhere("codgrupo = ''");
	}
	else {
		q.setTablesList("atributos,gruposatributos,familias");
		q.setFrom("atributos INNER JOIN gruposatributos " +
					" ON atributos.codgrupo = gruposatributos.codgrupo" +
					" INNER JOIN familias " +
					" ON gruposatributos.codgrupo = familias.codgrupoatr");

		q.setSelect("atributos.codatributo,atributos.nombre");
		q.setWhere("familias.codfamilia = '" + codFamilia + "'");
	}

	if (!q.exec()) return false;

	var dialog = new Dialog(util.translate ( "scripts", "Atributos" ), 0);
	dialog.caption = "Edición de atributos";
	dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
	dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
	dialog.width = 500;

	var bgroup:GroupBox = new GroupBox;
	dialog.add( bgroup );
	var cB:Array = [];
	var nAtr:Number = 0;

	while (q.next())  {

		valor = util.sqlSelect("atributosart", "valor", "referencia = '" + referencia + "' AND codatributo = '" + q.value(0)+ "'");
		if (!valor)
			valor = "";

		cB[nAtr] = new LineEdit;
		cB[nAtr].label = q.value(1);
		cB[nAtr].text = valor;
		codAtr[nAtr] = q.value(0);
		bgroup.add( cB[nAtr] );
		nAtr ++;
	}
	if (nAtr > 0) {
		nAtr --;

		if(dialog.exec()) {

			var curTab:FLSqlCursor = this.child("tdbAtributosArt").cursor();

			for (var i:Number = 0; i <= nAtr; i++) {

				debug(cB[i].text);

				if (!cB[i].text)
					continue;

				curTab.select("referencia = '" + referencia + "' AND codatributo = '" + codAtr[i] + "'");

				if (curTab.first()) {
					curTab.setModeAccess(curTab.Edit);
					curTab.refreshBuffer();
				}
				else {
					curTab.setModeAccess(curTab.Insert);
					curTab.refreshBuffer();
					curTab.setValueBuffer("referencia", referencia);
					curTab.setValueBuffer("codatributo", codAtr[i]);
				}

				curTab.setValueBuffer("valor", cB[i].text);
				curTab.commitBuffer();
			}

			this.child("tdbAtributosArt").refresh();

		}
		else
			return;
	}
	// NO se encuentran atributos
	else {
		MessageBox.warning(util.translate("scripts", "No se encontraron atributos asociados a la familia de este artículo\nAsegúrese de que la familia tiene un grupo de atributos asociados"), MessageBox.Ok, MessageBox.NoButton);
		return;
	}
}


function fluxEcommerce_actualizarPvpOferta()
{
	var util:FLUtil = new FLUtil();

	var pvp:Number = parseFloat(this.cursor().valueBuffer("pvp"));
	var codTarifa:Number = this.cursor().valueBuffer("codtarifa");

	debug(pvp);

	var dTar:Array = flfactppal.iface.pub_ejecutarQry("tarifas", "inclineal,incporcentual", "codtarifa = '" + codTarifa + "'");

	if (dTar.result != 1)
		return;

	debug(dTar.inclineal);

	pvp = parseFloat((pvp * (100 + parseFloat(dTar.incporcentual)) / 100) + parseFloat(dTar.inclineal));
	this.cursor().setValueBuffer("pvpoferta", pvp);
}

function fluxEcommerce_actualizarControlesOferta()
{
	var util:FLUtil = new FLUtil();

	if (this.cursor().valueBuffer("enoferta")) {
		this.child("gbxOferta").setDisabled(false);
	}
	else {
		this.child("gbxOferta").setDisabled(true);
	}
}

function fluxEcommerce_traducirDescripcion()
{
	return flfactppal.iface.pub_traducir("articulos", "descripcion", this.cursor().valueBuffer("referencia"));
}

function fluxEcommerce_traducirDescPublica()
{
	return flfactppal.iface.pub_traducir("articulos", "descpublica", this.cursor().valueBuffer("referencia"));
}

//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

