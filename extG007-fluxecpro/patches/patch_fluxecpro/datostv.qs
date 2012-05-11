
/** @class_declaration fluxecPro */
/////////////////////////////////////////////////////////////////
//// FLUX EC PRO /////////////////////////////////////////////////
class fluxecPro extends oficial /** %from: oficial */ {
    function fluxecPro( context ) { oficial ( context ); }
    function init() { this.ctx.fluxecPro_init(); }
	function exportarTabla(tabla:String, nomTabla:String, tablaGeneral:Boolean):Number {
		return this.ctx.fluxecPro_exportarTabla(tabla, nomTabla, tablaGeneral);
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

	this.iface.tablas = new Array(
		"idiomas",
		"infogeneral",
		"modulosweb",
		"noticias",
		"traducciones",
		"fabricantes",
		"faqs",

		"paises",
		"provincias",

		"galeriasimagenes",
		"imagenes",
		"tarifas",
		"gruposclientes",
		"almacenes",
		"gruposatributos",
		"familias",
		"plazosenvio",
		"articulos",
		"atributos",
		"atributosart",
		"accesoriosart",
		"formasenvio",
		"pasarelaspago",
		"parametrospasarela",
		"formaspago",
		"opcionestv",
		"articulostarifas",

		"intervalospesos",
		"zonasventa",
		"zonasformasenvio",
		"zonasformaspago",
		"costesenvio",
		"codigosdescuento",
		"stocks",

		"clientes",
		"empresa"
	);
}

/** \D Exporta todo a una tabla en remoto que luego se importa con php. Exporta a un solo campo directamente el string de la query
Evita problemas de consistencia en grandes bases de datos
*/
function fluxecPro_exportarTabla(tabla:String, nomTabla:String, tablaGeneral:Boolean)
{
	if (!this.cursor().valueBuffer("exportardirecto"))
		return this.iface.__exportarTabla(tabla, nomTabla, tablaGeneral);

	var util:FLUtil = new FLUtil();

	var ahora = new Date();

	var curLoc:FLSqlCursor = new FLSqlCursor(tabla);
	var curMod:FLSqlCursor = new FLSqlCursor("modificadossql", this.iface.conexion);

	var campoClave:String = curLoc.primaryKey();
	var listaCampos:Array = this.iface.obtenerListaCampos(tabla);

	var valor:String;
	var valorClave;
	var paso:Number = 0;
	var exportados:Number = 0;
	var eliminados:Number = 0;
	var linea:String;
	var lineas:String;

	var regExp:RegExp = new RegExp("'");
	regExp.global = true;

	var pasoBloque:Number = 0;
	var pasosBloque:Number = 30;

	if (this.cursor().valueBuffer("subirtodo"))
	 	curLoc.select();
	else
	 	curLoc.select("modificado = true");

	if (curLoc.size() == 0)
		return 0;

	util.createProgressDialog( util.translate( "scripts", "Exportando " ) + nomTabla, curLoc.size());
	util.setProgress(1);

 	while (curLoc.next()) {

		util.setProgress(paso++);

 		valorClave = curLoc.valueBuffer(campoClave);
		linea = "";

		// Bucle de campos
		for(var i = 0; i < listaCampos.length; i++) {

			campo = listaCampos[i];
			valor = curLoc.valueBuffer(campo);
			valor = valor.toString();

			// excepciones
			if (tabla == "formaspago" && campo == "codcuenta")
				continue;

			switch (curLoc.fieldType(campo)) {
				case 26: // fecha
					if (!valor)
						valor = '1000-01-01';
				break;
			}

			if (valor.find(regExp) > -1)
				valor = valor.replace(regExp, "\\'");

			linea += linea ? "," : "";
			linea += campo + "='" + valor + "'";
		}

		curMod.select("tabla = '" + tabla + "' AND valorclave = '" + valorClave + "'");
		if (curMod.first())
			curMod.setModeAccess(curMod.Edit);
		else
			curMod.setModeAccess(curMod.Insert);

		curMod.refreshBuffer();
		curMod.setValueBuffer("tabla", tabla);
		curMod.setValueBuffer("campoclave", campoClave);
		curMod.setValueBuffer("valorclave", valorClave);
		curMod.setValueBuffer("valores", linea);
		if (!curMod.commitBuffer())
			debug(util.translate("scripts",	"Error al actualizar la tabla local %0 el código/id " ).arg(tabla) + valorClave);

		else
			exportados++;
	}

	util.setLabelText(util.translate("scripts", "Procesando..."));

	util.sqlUpdate(tabla, "modificado", false, "modificado=true");

	util.destroyProgressDialog();

	return exportados;
}


//// FLUX EC PRO //////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////

//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

