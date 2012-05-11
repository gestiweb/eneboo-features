
/** @class_declaration fluxecPro */
/////////////////////////////////////////////////////////////////
//// FLUX EC PRO /////////////////////////////////////////////////
class fluxecPro extends oficial /** %from: oficial */ {

	var tblZonas:QTable;
	var pesos:Array;
	var zonas:Array;
	var datosModificados:Boolean;

    function fluxecPro( context ) { oficial ( context ); }

    function init() { this.ctx.fluxecPro_init(); }

	function bufferChanged(fN:String, miForm:Object) {
		return this.ctx.fluxecPro_bufferChanged(fN, miForm);
	}
	function reloadZonas() {
		return this.ctx.fluxecPro_reloadZonas();
	}
	function cargarPreciosZonas() {
		return this.ctx.fluxecPro_cargarPreciosZonas();
	}
	function guardarPrecio(fil:Number, col:Number) {
		return this.ctx.fluxecPro_guardarPrecio(fil, col);
	}
	function insertarZona() {
		return this.ctx.fluxecPro_insertarZona();
	}
	function quitarZona() {
		return this.ctx.fluxecPro_quitarZona();
	}
	function tabSelected(nomTab:String) {
		return this.ctx.fluxecPro_tabSelected(nomTab);
	}
	function controlPorZonas() {
		return this.ctx.fluxecPro_controlPorZonas();
	}

}
//// FLUX EC PRO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxecPro */
//////////////////////////////////////////////////////////////////
//// FLUX EC PRO //////////////////////////////////////////////////

function fluxecPro_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = this.cursor();

	this.iface.tblZonas = this.child("tblZonas");
 	connect(this.iface.tblZonas, "valueChanged(int,int)", this, "iface.guardarPrecio");

	connect (this.child("tbIncluir"), "clicked()", this, "iface.insertarZona()");
	connect (this.child("tbExcluir"), "clicked()", this, "iface.quitarZona()");

	this.child("tdbZonasVenta").cursor().setMainFilter("codzona not in (select codzona from zonasformasenvio where codenvio = '" + cursor.valueBuffer("codenvio") + "')");
 	connect(this.child("tbwFormasEnvio"), "currentChanged(QString)", this, "iface.tabSelected");

	this.iface.controlPorZonas();
}


function fluxecPro_bufferChanged(fN:String)
{
	switch (fN) {
		case "controlporzonas":
			this.iface.controlPorZonas();
		break;
		default:
			return this.iface.__bufferChanged(fN);
	}
}

function fluxecPro_reloadZonas()
{
	var codEnvio:String = this.cursor().valueBuffer("codenvio");
	if (!codEnvio)
		return;

	var util:FLUtil = new FLUtil();

	var paso:Number = 0;
	var titRows:String = "";
	var titCols:String = "";

	this.iface.pesos = [];
	this.iface.zonas = [];
	this.iface.tblZonas.clear();

	// Filas
	var curTab:FLSqlCursor = new FLSqlCursor("intervalospesos");
	curTab.select();
	this.iface.tblZonas.insertRows(0, curTab.size());
	while (curTab.next()) {
		if (titRows)
			titRows += ",";
		titRows += curTab.valueBuffer("desde") + " - " + curTab.valueBuffer("hasta");
		this.iface.pesos[paso++] = curTab.valueBuffer("codigo");
	}

	this.iface.tblZonas.setRowLabels(",", titRows);

	// Columnas
	paso = 0;
	curTab = new FLSqlCursor("zonasformasenvio");
	curTab.select("codenvio = '" + codEnvio + "'");
	this.iface.tblZonas.setNumCols(curTab.size());
	while (curTab.next()) {
		if (titCols)
			titCols += ",";
		this.iface.tblZonas.setColumnWidth(paso, 80)
		titCols += curTab.valueBuffer("codzona");
		this.iface.zonas[paso++] = curTab.valueBuffer("codzona");
	}

	this.iface.tblZonas.setColumnLabels(",", titCols);
	this.iface.cargarPreciosZonas();
}




function fluxecPro_cargarPreciosZonas()
{
	var i:Number, j:Number;
	var codEnvio:String = this.cursor().valueBuffer("codenvio");
	var curTab:FLSqlCursor = new FLSqlCursor("costesenvio");

	for (i = 0; i < this.iface.pesos.length; i++) {
		for (j = 0; j < this.iface.zonas.length; j++) {
			curTab.select("codenvio = '" + codEnvio + "' AND codpeso = '" + this.iface.pesos[i] + "' AND codzona = '" + this.iface.zonas[j] + "'");
			if (curTab.first()) {
				this.iface.tblZonas.setText(i, j, curTab.valueBuffer("pvp"));
			}
		}
	}
}

function fluxecPro_guardarPrecio(fil:Number, col:Number)
{
	var regExp:RegExp = new RegExp( "," );
	var pvp:Number = parseFloat(this.iface.tblZonas.text(fil, col).toString().replace(regExp,"."));

	var codEnvio:String = this.cursor().valueBuffer("codenvio");

	var curTab:FLSqlCursor = new FLSqlCursor("costesenvio");
	curTab.select("codenvio = '" + codEnvio + "' AND codpeso = '" + this.iface.pesos[fil] + "' AND codzona = '" + this.iface.zonas[col] + "'");
	if (curTab.first()) {
		curTab.setModeAccess(curTab.Edit);
		curTab.refreshBuffer();
	}
	else {
		curTab.setModeAccess(curTab.Insert);
		curTab.refreshBuffer();
		curTab.setValueBuffer("codenvio", codEnvio);
		curTab.setValueBuffer("codpeso", this.iface.pesos[fil]);
		curTab.setValueBuffer("codzona", this.iface.zonas[col]);
	}

	curTab.setValueBuffer("pvp", pvp);
	curTab.commitBuffer();
}


function fluxecPro_insertarZona()
{
	var util:FLUtil;

	var cursor:FLSqlCursor = this.cursor();
	if (this.cursor().modeAccess() == this.cursor().Insert) {
		if (!this.child("tdbZonasVenta").cursor().commitBufferCursorRelation())
			return;
	}

	var curTab:FLSqlCursor = this.child("tdbZonasVenta").cursor();
	if (!curTab.isValid())
		return;

	var codZona:String = curTab.valueBuffer("codzona");
	curTab = new FLSqlCursor("zonasformasenvio");
	curTab.setModeAccess(curTab.Insert);
	curTab.refreshBuffer();
	curTab.setValueBuffer("codzona", codZona);
	curTab.setValueBuffer("codenvio", cursor.valueBuffer("codenvio"));
	curTab.setValueBuffer("pvp", cursor.valueBuffer("pvp"));
	curTab.setValueBuffer("codimpuesto", cursor.valueBuffer("codimpuesto"));
	curTab.setValueBuffer("ivaincluido", cursor.valueBuffer("ivaincluido"));
	curTab.commitBuffer();

	this.child("tdbZonasVenta").refresh();
	this.child("tdbZonasEnvio").refresh();
}

function fluxecPro_quitarZona()
{
	var util:FLUtil;

	var curTab:FLSqlCursor = this.child("tdbZonasEnvio").cursor();
	if (!curTab.isValid())
		return;

	curTab.setModeAccess(curTab.Del);
	curTab.refreshBuffer();
	curTab.commitBuffer();

	this.child("tdbZonasVenta").refresh();
	this.child("tdbZonasEnvio").refresh();
}

function fluxecPro_tabSelected(nomTab:String)
{
	debug(nomTab);
	if (nomTab == "precios")
		this.iface.reloadZonas();
}


function fluxecPro_controlPorZonas()
{
	if (this.cursor().valueBuffer("controlporzonas"))  {
		this.child("tbwFormasEnvio").setTabEnabled("zonas", true);
		this.child("tbwFormasEnvio").setTabEnabled("precios", true);
	}
	else {
		this.child("tbwFormasEnvio").setTabEnabled("zonas", false);
		this.child("tbwFormasEnvio").setTabEnabled("precios", false);
	}
}


//// FLUX EC PRO //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

