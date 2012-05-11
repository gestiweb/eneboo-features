
/** @class_declaration fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
class fluxEcommerce extends traducciones {
	var valoresTradActual:Array;
    function fluxEcommerce( context ) { traducciones ( context ); }

	function init() {
		return this.ctx.fluxEcommerce_init();
	}
	function introducirModulosWeb() {
		return this.ctx.fluxEcommerce_introducirModulosWeb();
	}
	function introducirPaises() {
		return this.ctx.fluxEcommerce_introducirPaises();
	}
	function introducirProvincias() {
		return this.ctx.fluxEcommerce_introducirProvincias();
	}
	function introducirIdiomas() {
		return this.ctx.fluxEcommerce_introducirIdiomas();
	}

	function lanzarOpciones() {
		return this.ctx.fluxEcommerce_lanzarOpciones();
	}

	function beforeCommit_accesoriosart(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_accesoriosart(cursor);
	}
	function beforeCommit_almacenes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_almacenes(cursor);
	}
	function beforeCommit_articulos(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_articulos(cursor);
	}
	function beforeCommit_atributosart(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_atributosart(cursor);
	}
	function beforeCommit_atributos(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_atributos(cursor);
	}
	function beforeCommit_fabricantes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_fabricantes(cursor);
	}
	function beforeCommit_familias(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_familias(cursor);
	}
	function beforeCommit_faqs(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_faqs(cursor);
	}
	function beforeCommit_formasenvio(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_formasenvio(cursor);
	}
	function beforeCommit_gruposatributos(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_gruposatributos(cursor);
	}
	function beforeCommit_infogeneral(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_infogeneral(cursor);
	}
	function beforeCommit_modulosweb(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_modulosweb(cursor);
	}
	function beforeCommit_noticias(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_noticias(cursor);
	}
	function beforeCommit_opcionestv(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_opcionestv(cursor);
	}
	function beforeCommit_plazosenvio(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_plazosenvio(cursor);
	}
	function beforeCommit_tarifas(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_tarifas(cursor);
	}
	function beforeCommit_articulostarifas(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_articulostarifas(cursor);
	}
	function beforeCommit_imagenes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_imagenes(cursor);
	}
	function beforeCommit_galeriasimagenes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_galeriasimagenes(cursor);
	}
	function beforeCommit_codigosdescuento(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_codigosdescuento(cursor);
	}
	function beforeCommit_traducciones(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_traducciones(cursor);
	}
	function beforeCommit_stocks(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_beforeCommit_stocks(cursor);
	}

	function setModificado(cursor:FLSqlCursor)  {
		return this.ctx.fluxEcommerce_setModificado(cursor);
	}


	function afterCommit_stocks(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_stocks(cursor);
	}
	function afterCommit_accesoriosart(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_accesoriosart(cursor);
	}
	function afterCommit_almacenes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_almacenes(cursor);
	}
	function afterCommit_articulos(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_articulos(cursor);
	}
	function afterCommit_atributosart(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_atributosart(cursor);
	}
	function afterCommit_atributos(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_atributos(cursor);
	}
	function afterCommit_fabricantes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_fabricantes(cursor);
	}
	function afterCommit_familias(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_familias(cursor);
	}
	function afterCommit_faqs(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_faqs(cursor);
	}
	function afterCommit_formasenvio(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_formasenvio(cursor);
	}
	function afterCommit_gruposatributos(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_gruposatributos(cursor);
	}
	function afterCommit_infogeneral(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_infogeneral(cursor);
	}
	function afterCommit_modulosweb(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_modulosweb(cursor);
	}
	function afterCommit_noticias(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_noticias(cursor);
	}
	function afterCommit_opcionestv(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_opcionestv(cursor);
	}
	function afterCommit_plazosenvio(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_plazosenvio(cursor);
	}
	function afterCommit_tarifas(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_tarifas(cursor);
	}
	function afterCommit_articulostarifas(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_articulostarifas(cursor);
	}
	function afterCommit_imagenes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_imagenes(cursor);
	}
	function afterCommit_galeriasimagenes(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_galeriasimagenes(cursor);
	}
	function afterCommit_codigosdescuento(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_codigosdescuento(cursor);
	}
	function afterCommit_traducciones(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_traducciones(cursor);
	}
	function afterCommit_stocks(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_afterCommit_stocks(cursor);
	}

	function registrarDel(cursor:FLSqlCursor):Boolean {
		return this.ctx.fluxEcommerce_registrarDel(cursor);
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubFluxEcommerce */
/////////////////////////////////////////////////////////////////
//// PUB FLUX ECOMMERCE //////////////////////////////////////////////////////
class pubFluxEcommerce extends ifaceCtx {
    function pubFluxEcommerce( context ) { ifaceCtx ( context ); }
	function pub_traducir(tabla:String, campo:String, idCampo:String) {
		return this.traducir(tabla, campo, idCampo);
	}
	function pub_valoresTrad(familia:String, campo:String, idCampo:String) {
		return this.valoresTrad(familia, campo, idCampo);
	}
}
//// PUB ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition fluxEcommerce */
/////////////////////////////////////////////////////////////////
//// FLUX ECOMMERCE //////////////////////////////////////////////////////

function fluxEcommerce_init()
{
	this.iface.__init();

	var cursor:FLSqlCursor = new FLSqlCursor("modulosweb");
	cursor.select();
	if (!cursor.first()) {
		var util:FLUtil = new FLUtil();
		MessageBox.information(util.translate("scripts",
			"Se insertarán algunos datos de la tienda virtual para empezar a trabajar"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

		util.createProgressDialog( util.translate( "scripts", "Introduciendo datos" ), 100);
		util.setProgress(10);
		this.iface.introducirModulosWeb();
		util.setProgress(20);
		this.iface.introducirIdiomas();
		util.setProgress(60);
		this.iface.introducirPaises();
		util.setProgress(80);
		this.iface.introducirProvincias();
		util.setProgress(100);

		util.destroyProgressDialog();

		MessageBox.information(util.translate("scripts",
			"Los datos fueron introducidos.\nEstablezca a continuación las Opciones de configuración"),
			MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

		this.iface.lanzarOpciones();
	}

}


function fluxEcommerce_introducirModulosWeb()
{
	// Campos: codigo, titulo, posicion, orden, mostrartitulo, casillaunica

	var util:FLUtil = new FLUtil();
	var datos =	[
			["modFamilias",util.translate("scripts", "Categorías"),0,1,true,false],
			["modBuscar",util.translate("scripts", "Buscar"),0,2,true,true],
			["modInfogeneral",util.translate("scripts", "Información general"),0,3,true,false],
			["modNoticias",util.translate("scripts", "Noticias"),0,4,true,false],
			["modIdiomas",util.translate("scripts", "Idiomas"),0,5,false,false],
			["modCesta",util.translate("scripts", "Mi cesta"),1,1,true,false],
			["modOfertas",util.translate("scripts", "Ofertas"),1,2,true,false],
			["modNovedad",util.translate("scripts", "Novedad"),1,3,true,false],
			["modGalerias",util.translate("scripts", "Galerías de imágenes"),1,4,true,false],
			["modFabricantes",util.translate("scripts", "Fabricantes"),1,5,true,true]];

	var cursor:FLSqlCursor = new FLSqlCursor("modulosweb");

	for (i = 0; i < datos.length; i++) {

			cursor.select("codigo = '" + datos[i][0] + "'");
			if (cursor.first())
				continue;

			cursor.setModeAccess(cursor.Insert);
			cursor.refreshBuffer();
			cursor.setValueBuffer("codigo", datos[i][0]);
			cursor.setValueBuffer("titulo", datos[i][1]);
			cursor.setValueBuffer("publico", true);
			cursor.setValueBuffer("posicion", datos[i][2]);
			cursor.setValueBuffer("orden", datos[i][3]);
			cursor.setValueBuffer("tipo", 1);
			cursor.setValueBuffer("mostrartitulo", datos[i][4]);
			cursor.setValueBuffer("casillaunica", datos[i][5]);
			cursor.setValueBuffer("modificado", true);
			cursor.commitBuffer();
	}

}

function fluxEcommerce_introducirPaises()
{
	// Campos: codigo, titulo, posicion, orden, mostrartitulo, casillaunica

	var util:FLUtil = new FLUtil();
	var datos =	[
		["AFGAN","Afganistan"],
		["ALBAN","Albania"],
		["ALEMA","Alemania"],
		["ANDOR","Andorra"],
		["ANGOL","Angola"],
		["ANGUI","Anguila"],
		["ANTAR","Antartida"],
		["ANTIG","Antigua y Barbuda"],
		["ANTIL","Antillas Neerlandesas"],
		["ARABI","Arabia Saudi"],
		["ARCTI","Arctic Ocean"],
		["ARGEL","Argelia"],
		["ARGEN","Argentina"],
		["ARMEN","Armenia"],
		["ARUBA","Aruba"],
		["ASHMO","Ashmore and Cartier Islands"],
		["ATLAN","Atlantic Ocean"],
		["AUSTR","Australia"],
		["AUSTR","Austria"],
		["AZERB","Azerbaiyan"],
		["BAHAM","Bahamas"],
		["BAHRA","Bahrain"],
		["BAKER","Baker Island"],
		["BANGL","Bangladesh"],
		["BARBA","Barbados"],
		["BASSA","Bassas da India"],
		["BELGI","Belgica"],
		["BELIC","Belice"],
		["BENIN","Benin"],
		["BERMU","Bermudas"],
		["BIELO","Bielorrusia"],
		["BIRMA","Birmania; Myanmar"],
		["BOLIV","Bolivia"],
		["BOSNI","Bosnia y Hercegovina"],
		["BOTSU","Botsuana"],
		["BRASI","Brasil"],
		["BRUNE","Brunei"],
		["BULGA","Bulgaria"],
		["BURKI","Burkina Faso"],
		["BURUN","Burundi"],
		["BUTAN","Butan"],
		["CABO ","Cabo Verde"],
		["CAMBO","Camboya"],
		["CAMER","Camerun"],
		["CANAD","Canada"],
		["CHAD","Chad"],
		["CHILE","Chile"],
		["CHINA","China"],
		["CHIPR","Chipre"],
		["CLIPP","Clipperton Island"],
		["COLOM","Colombia"],
		["COMOR","Comoras"],
		["CONGO","Congo"],
		["CORAL","Coral Sea Islands"],
		["CORNO","Corea del Norte"],
		["CORSU","Corea del Sur"],
		["COSMA","Costa de Marfil"],
		["COSRI","Costa Rica"],
		["CROAC","Croacia"],
		["CUBA","Cuba"],
		["DINAM","Dinamarca"],
		["DOMIN","Dominica"],
		["ECUAD","Ecuador"],
		["EGIPT","Egipto"],
		["SALVA","El Salvador"],
		["VATIC","El Vaticano"],
		["EMIRA","Emiratos arabes Unidos"],
		["ERITR","Eritrea"],
		["SLOVA","Eslovaquia"],
		["SLOVE","Eslovenia"],
		["ESTAD","Estados Unidos"],
		["ESTON","Estonia"],
		["ETIOP","Etiopia"],
		["EUROP","Europa Island"],
		["FILIP","Filipinas"],
		["FINLA","Finlandia"],
		["FIYI","Fiyi"],
		["FRANC","Francia"],
		["GABON","Gabon"],
		["GAMBI","Gambia"],
		["GAZA ","Gaza Strip"],
		["GEORG","Georgia"],
		["GHANA","Ghana"],
		["GIBRA","Gibraltar"],
		["GLORI","Glorioso Islands"],
		["GRANA","Granada"],
		["GRECI","Grecia"],
		["GROEN","Groenlandia"],
		["GUADA","Guadalupe"],
		["GUAM","Guam"],
		["GUATE","Guatemala"],
		["GUAYA","Guayana Francesa"],
		["GUERN","Guernsey"],
		["GUINE","Guinea"],
		["GUECU","Guinea Ecuatorial"],
		["GUBIS","Guinea-Bissau"],
		["GUYAN","Guyana"],
		["HAITI","Haiti"],
		["HONDU","Honduras"],
		["HONG","Hong Kong"],
		["HOWLA","Howland Island"],
		["HUNGR","Hungria"],
		["INDIA","India"],
		["INDON","Indonesia"],
		["IRAN","Iran"],
		["IRAQ","Iraq"],
		["IRLAN","Irlanda"],
		["IBOUV","Isla Bouvet"],
		["ICHRI","Isla Christmas"],
		["INORF","Isla Norfolk"],
		["ISLAN","Islandia"],
		["ICAIM","Islas Caiman"],
		["ICOCO","Islas Cocos"],
		["ICOOK","Islas Cook"],
		["IFERO","Islas Feroe"],
		["IGEOR","Islas Georgia Sur, Sandwich Sur"],
		["IHEAR","Islas Heard y McDonald"],
		["IMALV","Islas Malvinas"],
		["IMARI","Islas Marianas del Norte"],
		["IMARS","Islas Marshall"],
		["IPITC","Islas Pitcairn"],
		["ISALO","Islas Salomon"],
		["ITURC","Islas Turcas y Caicos"],
		["IVAME","Islas Virgenes Americanas"],
		["IVBRI","Islas Virgenes Britanicas"],
		["ISRAE","Israel"],
		["ITALI","Italia"],
		["JAMAI","Jamaica"],
		["JAN M","Jan Mayen"],
		["JAPON","Japon"],
		["JARVI","Jarvis Island"],
		["JERSE","Jersey"],
		["JOHNS","Johnston Atoll"],
		["JORDA","Jordania"],
		["JUAN","Juan de Nova Island"],
		["KAZAJ","Kazajistan"],
		["KENIA","Kenia"],
		["KINGM","Kingman Reef"],
		["KIRGU","Kirguizistan"],
		["KIRIB","Kiribati"],
		["KUWAI","Kuwait"],
		["LAOS","Laos"],
		["LESOT","Lesoto"],
		["LETON","Letonia"],
		["LIBAN","Libano"],
		["LIBER","Liberia"],
		["LIBIA","Libia"],
		["LIECH","Liechtenstein"],
		["LITUA","Lituania"],
		["LUXEM","Luxemburgo"],
		["MACAO","Macao"],
		["MACED","Macedonia"],
		["MADAG","Madagascar"],
		["MALAS","Malasia"],
		["MALAU","Malaui"],
		["MALDI","Maldivas"],
		["MALI","Mali"],
		["MALTA","Malta"],
		["IMAN","Man"," Isle of"],
		["MARRU","Marruecos"],
		["MARTI","Martinica"],
		["MAURI","Mauricio"],
		["MAURI","Mauritania"],
		["MAYOT","Mayotte"],
		["MEXIC","Mexico"],
		["MICRO","Micronesia"],
		["MIDWA","Midway Islands"],
		["MOLDA","Moldavia"],
		["MONAC","Monaco"],
		["MONGO","Mongolia"],
		["MONTS","Montserrat"],
		["MOZAM","Mozambique"],
		["NAMIB","Namibia"],
		["NAURU","Nauru"],
		["NAVAS","Navassa Island"],
		["NEPAL","Nepal"],
		["NICAR","Nicaragua"],
		["NIGER","Niger"],
		["NGERI","Nigeria"],
		["NIUE","Niue"],
		["NORUE","Noruega"],
		["NCALE","Nueva Caledonia"],
		["NZELA","Nueva Zelanda"],
		["OMAN","Oman"],
		["PACIF","Pacific Ocean"],
		["PAISE","Paises Bajos"],
		["PAKIS","Pakistan"],
		["PALAO","Palaos"],
		["PALMY","Palmyra Atoll"],
		["PANAM","Panama"],
		["PAPUA","Papua-Nueva Guinea"],
		["PARAC","Paracel Islands"],
		["PARAG","Paraguay"],
		["PERU","Peru"],
		["POLIN","Polinesia Francesa"],
		["POLON","Polonia"],
		["PORTU","Portugal"],
		["PUERT","Puerto Rico"],
		["QATAR","Qatar"],
		["REINO","Reino Unido"],
		["RCENT","Republica Centroafricana"],
		["RCHEC","Republica Checa"],
		["RCONG","Republica Democratica del Congo"],
		["RDOMI","Republica Dominicana"],
		["REUNI","Reunion"],
		["RUAND","Ruanda"],
		["RUMAN","Rumania"],
		["RUSIA","Rusia"],
		["SAHAR","Sahara Occidental"],
		["SAMOA","Samoa"],
		["SAMER","Samoa Americana"],
		["SANCR","San Cristobal y Nieves"],
		["SANMA","San Marino"],
		["SANPE","San Pedro y Miquelon"],
		["SANVI","San Vicente y las Granadinas"],
		["SHELE","Santa Helena"],
		["SLUCI","Santa Lucia"],
		["STOME","Santo Tome y Principe"],
		["SENEG","Senegal"],
		["SERBI","Serbia and Montenegro"],
		["SEYCH","Seychelles"],
		["SIERR","Sierra Leona"],
		["SINGA","Singapur"],
		["SIRIA","Siria"],
		["SOMAL","Somalia"],
		["SOUTH","Southern Ocean"],
		["SPRAT","Spratly Islands"],
		["SRILA","Sri Lanka"],
		["SUAZI","Suazilandia"],
		["SUDAF","Sudafrica"],
		["SUDAN","Sudan"],
		["SUECI","Suecia"],
		["SUIZA","Suiza"],
		["SURIN","Surinam"],
		["SVALB","Svalbard y Jan Mayen"],
		["TAILA","Tailandia"],
		["TAIWA","Taiwan"],
		["TANZA","Tanzania"],
		["TAYIK","Tayikistan"],
		["TERRB","Territorio Britanico Indico"],
		["TERRA","Territorios Australes Franceses"],
		["TIMOR","Timor Oriental"],
		["TOGO","Togo"],
		["TOKEL","Tokelau"],
		["TONGA","Tonga"],
		["TRINI","Trinidad y Tobago"],
		["TROME","Tromelin Island"],
		["TUNEZ","Tunez"],
		["TURKM","Turkmenistan"],
		["TURQU","Turquia"],
		["TUVAL","Tuvalu"],
		["UCRAN","Ucrania"],
		["UGAND","Uganda"],
		["URUGU","Uruguay"],
		["UZBEK","Uzbekistan"],
		["VANUA","Vanuatu"],
		["VENEZ","Venezuela"],
		["VIETN","Vietnam"],
		["WAKE","Wake Island"],
		["WALLI","Wallis y Futuna"],
		["YEMEN","Yemen"],
		["YIBUT","Yibuti"],
		["ZAMBI","Zambia"],
		["ZIMBA","Zimbabue"],
	];

	var cursor:FLSqlCursor = new FLSqlCursor("paises");
	for (i = 0; i < datos.length; i++) {
			cursor.select("codpais = '" + datos[i][0] + "'");
			if (cursor.first())	continue;
			cursor.setModeAccess(cursor.Insert);
			cursor.refreshBuffer();
			cursor.setValueBuffer("codpais", datos[i][0]);
			cursor.setValueBuffer("nombre", datos[i][1]);
			cursor.setValueBuffer("modificado", true);
			cursor.commitBuffer();
	}

}


function fluxEcommerce_introducirProvincias()
{
	// Campos: idprovincia, provincia, codpais

	var util:FLUtil = new FLUtil();
	var datos =	[
	 [0, "ESP", "..."],
	 [1, "ESP", "ALAVA"],
	 [2, "ESP", "ALBACETE"],
	 [3, "ESP", "ALICANTE"],
	 [4, "ESP", "ALMERIA"],
	 [33, "ESP", "ASTURIAS"],
	 [5, "ESP", "AVILA"],
	 [6, "ESP", "BADAJOZ"],
	 [8, "ESP", "BARCELONA"],
	 [9, "ESP", "BURGOS"],
	 [10, "ESP", "CACERES"],
	 [11, "ESP", "CADIZ"],
	 [39, "ESP", "CANTABRIA"],
	 [12, "ESP", "CASTELLON"],
	 [51, "ESP", "CEUTA"],
	 [13, "ESP", "CIUDAD REAL"],
	 [14, "ESP", "CORDOBA"],
	 [15, "ESP", "CORUÑA, A"],
	 [16, "ESP", "CUENCA"],
	 [17, "ESP", "GIRONA"],
	 [18, "ESP", "GRANADA"],
	 [19, "ESP", "GUADALAJARA"],
	 [20, "ESP", "GUIPUZCOA"],
	 [21, "ESP", "HUELVA"],
	 [22, "ESP", "HUESCA"],
	 [7, "ESP", "ILLES BALEARS"],
	 [23, "ESP", "JAEN"],
	 [24, "ESP", "LEON"],
	 [25, "ESP", "LLEIDA"],
	 [27, "ESP", "LUGO"],
	 [28, "ESP", "MADRID"],
	 [29, "ESP", "MALAGA"],
	 [52, "ESP", "MELILLA"],
	 [30, "ESP", "MURCIA"],
	 [31, "ESP", "NAVARRA"],
	 [32, "ESP", "OURENSE"],
	 [34, "ESP", "PALENCIA"],
	 [35, "ESP", "PALMAS, LAS"],
	 [36, "ESP", "PONTEVEDRA"],
	 [26, "ESP", "RIOJA, LA"],
	 [37, "ESP", "SALAMANCA"],
	 [38, "ESP", "SANTA CRUZ DE TENERIFE"],
	 [40, "ESP", "SEGOVIA"],
	 [41, "ESP", "SEVILLA"],
	 [42, "ESP", "SORIA"],
	 [43, "ESP", "TARRAGONA"],
	 [44, "ESP", "TERUEL"],
	 [45, "ESP", "TOLEDO"],
	 [46, "ESP", "VALENCIA"],
	 [47, "ESP", "VALLADOLID"],
	 [48, "ESP", "VIZCAYA"],
	 [49, "ESP", "ZAMORA"],
	 [50, "ESP", "ZARAGOZA"]
	];

	var cursor:FLSqlCursor = new FLSqlCursor("provincias");
	for (i = 0; i < datos.length; i++) {
			cursor.select("idprovincia = '" + datos[i][0] + "'");
			if (cursor.first())	continue;
			cursor.setModeAccess(cursor.Insert);
			cursor.refreshBuffer();
			cursor.setValueBuffer("idprovincia", datos[i][0]);
			cursor.setValueBuffer("codpais", datos[i][1]);
			cursor.setValueBuffer("provincia", datos[i][2]);
			cursor.commitBuffer();
	}

}


function fluxEcommerce_introducirIdiomas()
{
	// Campos: codigo, titulo, posicion, orden, mostrartitulo, casillaunica

	var util:FLUtil = new FLUtil();
	var datos =	[
			["esp","Español", 1],
			["eng","Inglés", 2]];

	var cursor:FLSqlCursor = new FLSqlCursor("idiomas");

	for (i = 0; i < datos.length; i++) {

			cursor.select("codidioma = '" + datos[i][0] + "'");
			if (cursor.first())
				continue;

			cursor.setModeAccess(cursor.Insert);
			cursor.refreshBuffer();
			cursor.setValueBuffer("codidioma", datos[i][0]);
			cursor.setValueBuffer("nombre", datos[i][1]);
			cursor.setValueBuffer("orden", datos[i][2]);
			cursor.setValueBuffer("publico", true);
			cursor.setValueBuffer("modificado", true);
			cursor.commitBuffer();
	}
}


function fluxEcommerce_beforeCommit_accesoriosart(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_almacenes(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_articulos(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_atributosart(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_atributos(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_fabricantes(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_familias(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_faqs(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_formasenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_gruposatributos(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_infogeneral(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_modulosweb(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_noticias(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_opcionestv(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_plazosenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_tarifas(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_articulostarifas(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_galeriasimagenes(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_imagenes(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_zonasformasenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_zonasformaspago(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_zonasventa(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_intervalospesos(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_costesenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_codigosdescuento(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_traducciones(cursor:FLSqlCursor):Boolean {
	return this.iface.setModificado(cursor);
}
function fluxEcommerce_beforeCommit_stocks(cursor:FLSqlCursor):Boolean {
	this.iface.__beforeCommit_stocks(cursor);
	return this.iface.setModificado(cursor);
}


/** \D Marca el registro como modificado. Se utiliza para actualizar los datos en
la base de datos remota
*/
function fluxEcommerce_setModificado(cursor:FLSqlCursor) {
	if (cursor.isModifiedBuffer() && !cursor.valueBufferCopy("modificado"))
		cursor.setValueBuffer("modificado", true);

	return true;
}




function fluxEcommerce_afterCommit_accesoriosart(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_almacenes(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_articulos(cursor:FLSqlCursor):Boolean {
	if (!this.iface.__afterCommit_articulos(cursor))
		return false;
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_atributosart(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_atributos(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_fabricantes(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_familias(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_faqs(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_formasenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_gruposatributos(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_infogeneral(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_modulosweb(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_noticias(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_opcionestv(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_plazosenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_tarifas(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_articulostarifas(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_galeriasimagenes(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_imagenes(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_zonasformasenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_zonasformaspago(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_zonasventa(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_intervalospesos(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_costesenvio(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_codigosdescuento(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_traducciones(cursor:FLSqlCursor):Boolean {
	return this.iface.registrarDel(cursor);
}
function fluxEcommerce_afterCommit_stocks(cursor:FLSqlCursor):Boolean {
	this.iface.__afterCommit_stocks(cursor);
	return this.iface.registrarDel(cursor);
}


/** \D Guarda el registro en la tabla de eliminados. Se utiliza para eliminar
registros en la base de datos remota
*/
function fluxEcommerce_registrarDel(cursor:FLSqlCursor)
{
	if (cursor.modeAccess() != cursor.Del)
		return true;

	var tabla:String = cursor.table();
	var valorClave = cursor.valueBuffer(cursor.primaryKey());

	var curTab:FLSqlCursor = new FLSqlCursor("registrosdel");
	curTab.select("tabla = '" + tabla + "' AND idcampo = '" + valorClave + "'");

	if (curTab.first())
		return true;

	curTab.setModeAccess(curTab.Insert);
	curTab.refreshBuffer();
	curTab.setValueBuffer("tabla", tabla);
	curTab.setValueBuffer("idcampo", valorClave);
	curTab.commitBuffer();

	return true;
}

function fluxEcommerce_lanzarOpciones()
{
	var f = new FLFormSearchDB("opcionestv");
	var cursor:FLSqlCursor = f.cursor();

	cursor.select();
	if (!cursor.first())
		cursor.setModeAccess(cursor.Insert);
	else
		cursor.setModeAccess(cursor.Edit);

	f.setMainWidget();
	cursor.refreshBuffer();
	var commitOk:Boolean = false;
	var acpt:Boolean;
	cursor.transaction(false);
	while (!commitOk) {
		acpt = false;
		f.exec("id");
		acpt = f.accepted();
		if (!acpt) {
			if (cursor.rollback())
					commitOk = true;
		} else {
			if (cursor.commitBuffer()) {
					cursor.commit();
					commitOk = true;
			}
		}
		f.close();
	}
}
//// FLUX ECOMMERCE //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

