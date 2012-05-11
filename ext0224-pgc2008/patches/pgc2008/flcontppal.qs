
/** @class_declaration pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////
class pgc2008 extends oficial {

    function pgc2008( context ) { oficial ( context ); }
	function init(init) {
		this.ctx.pgc2008_init();
	}
	function generarPGC(codEjercicio) {
		return this.ctx.pgc2008_generarPGC(codEjercicio);
	}
	function generarCodigosBalance2008() {
		return this.ctx.pgc2008_generarCodigosBalance2008();
	}
	function actualizarCuentasEspeciales(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentasEspeciales(codEjercicio);
	}
	function actualizarCuentas2008(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentas2008(codEjercicio);
	}
	function actualizarCuentas2008ba(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentas2008ba(codEjercicio);
	}
	function generarCuadroCuentas(codEjercicio:String) {
		return this.ctx.pgc2008_generarCuadroCuentas(codEjercicio);
	}


	function generarGrupos(codEjercicio:String) {
		return this.ctx.pgc2008_generarGrupos(codEjercicio);
	}
	function generarSubgrupos(codEjercicio:String) {
		return this.ctx.pgc2008_generarSubgrupos(codEjercicio);
	}
	function generarCuentas(codEjercicio:String) {
		return this.ctx.pgc2008_generarCuentas(codEjercicio);
	}
	function generarSubcuentas(codEjercicio:String, longSubcuenta:Number) {
		return this.ctx.pgc2008_generarSubcuentas(codEjercicio, longSubcuenta);
	}


	function generarCorrespondenciasCC(codEjercicio:String) {
		return this.ctx.pgc2008_generarCorrespondenciasCC(codEjercicio);
	}
	function convertirCodSubcuenta(codEjercicio:String, codSubcuenta90:String):String {
		return this.ctx.pgc2008_convertirCodSubcuenta(codEjercicio, codSubcuenta90);
	}
	function convertirCodCuenta(codSubcuenta90:String):String {
		return this.ctx.pgc2008_convertirCodCuenta(codSubcuenta90);
	}


	function datosGrupos():Array {
		return this.ctx.pgc2008_datosGrupos();
	}
	function datosSubgrupos():Array {
		return this.ctx.pgc2008_datosSubgrupos();
	}
	function datosCuentas():Array {
		return this.ctx.pgc2008_datosCuentas();
	}
	function datosCorrespondencias():Array {
		return this.ctx.pgc2008_datosCorrespondencias();
	}
	function datosCuentasEspeciales():Array {
		return this.ctx.pgc2008_datosCuentasEspeciales();
	}
	function datosCuentasHuerfanas():Array {
		return this.ctx.pgc2008_datosCuentasHuerfanas();
	}
	function completarTiposEspeciales():Array {
		return this.ctx.pgc2008_completarTiposEspeciales();
	}

	function generarOrden3CB() {
		return this.ctx.pgc2008_generarOrden3CB();
	}

	function regenerarPGC(codEjercicio:String) {
		return this.ctx.pgc2008_regenerarPGC(codEjercicio);
	}
	function actualizarCuentasDigitos(codEjercicio:String) {
		return this.ctx.pgc2008_actualizarCuentasDigitos(codEjercicio);
	}
}
//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pgc2008 */
/////////////////////////////////////////////////////////////////
//// PGC 2008 //////////////////////////////////////////////////////

function pgc2008_init()
{
	this.iface.__init();

	var util:FLUtil = new FLUtil();
	if (util.sqlSelect("ejercicios", "codejercicio", "plancontable = '08'") && !util.sqlSelect("co_cuentascbba", "codcuenta", "1=1"))
		MessageBox.information(util.translate("scripts", "ATENCIÓN. Es necesario que regenere su plan contable para todos los ejercicios del nuevo PGC 2008.\nPara ello, abra el menú Ejercicio -> Ver todos, seleccione el(los) ejercicio(s) y pulse \"Regenerar\" "), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function pgc2008_generarPGC(codEjercicio:String)
{
	var util:FLUtil = new FLUtil();

	if (util.sqlSelect("ejercicios", "plancontable", "codejercicio = '" + codEjercicio + "'") != "08")
		return this.iface.__generarPGC(codEjercicio);

	var longSubcuenta:Number = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + codEjercicio + "'");

	var numCuentasEsp:Number = this.iface.valorPorClave("co_cuentasesp", "count(idcuentaesp)", "1 = 1");
	if (!numCuentasEsp)
		this.iface.valoresIniciales();

	this.iface.generarCuadroCuentas(codEjercicio)
	this.iface.generarCodigosBalance2008();
	this.iface.actualizarCuentas2008(codEjercicio);
	this.iface.actualizarCuentas2008ba(codEjercicio);
	this.iface.generarCorrespondenciasCC(codEjercicio);
	this.iface.actualizarCuentasEspeciales(codEjercicio);
	this.iface.generarSubcuentas(codEjercicio, longSubcuenta);

	MessageBox.information(util.translate("scripts", "Se generó el cuadro de cuentas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}


/** \D Se introducen los códigos de balance, independientes del ejercicio
\end */
function pgc2008_generarCodigosBalance2008()
{
	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("co_codbalances08", "codbalance", "1=1"))
		return;

	var curCbl:FLSqlCursor = new FLSqlCursor("co_codbalances08");
	curCbl.setActivatedCheckIntegrity(false);

	var datos = [
		["A-A--I-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "1", "1. Desarrollo."],
		["A-A--I-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "2", "2. Concesiones."],
		["A-A--I-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "3", "3. Patentes, licencias, marcas y similares."],
		["A-A--I-4", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "4", "4. Fondo de comercio."],
		["A-A--I-5", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "5", "5. Aplicaciones informáticas."],
		["A-A--I-6", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "I", "I. Inmovilizado intangible.", "6", "6. Otro inmovilizado intangible."],
		["A-A--II-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "II", "II. Inmovilizado material.", "1", "1. Terrenos y construcciones."],
		["A-A--II-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "II", "II. Inmovilizado material.", "2", "2. Instalaciones técnicas, y otro inmovilizado material."],
		["A-A--II-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "II", "II. Inmovilizado material.", "3", "3. Inmovilizado en curso y anticipos."],
		["A-A--III-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "III", "III. Inversiones inmobiliarias.", "1", "1. Terrenos."],
		["A-A--III-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "III", "III. Inversiones inmobiliarias.", "2", "2. Construcciones."],
		["A-A--IV-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "1", "1. Instrumentos de patrimonio."],
		["A-A--IV-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "2", "2. Créditos a empresas."],
		["A-A--IV-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "3", "3. Valores representativos de deuda."],
		["A-A--IV-4", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "4", "4. Derivados."],
		["A-A--IV-5", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a largo plazo", "5", "5. Otros activos financieros."],
		["A-A--V-1", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "1", "1. Instrumentos de patrimonio."],
		["A-A--V-2", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "2", "2. Créditos a terceros"],
		["A-A--V-3", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "3", "3. Valores representativos de deuda"],
		["A-A--V-4", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "4", "4. Derivados."],
		["A-A--V-5", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "V", "V. Inversiones financieras a largo plazo.", "5", "5. Otros activos financieros."],
		["A-A--VI-", "A", "A", "A) ACTIVO NO CORRIENTE", "", "", "VI", "VI. Activos por impuesto diferido.", "", ""],
		["A-B--I-", "A", "B", "B) ACTIVO CORRIENTE", "", "", "I", "I. Activos no corrientes mantenidos para la venta.", "", ""],
		["A-B--II-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "1", "1. Comerciales."],
		["A-B--II-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "2", "2. Materias primas y otros aprovisionamientos."],
		["A-B--II-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "3", "3. Productos en curso."],
		["A-B--II-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "4", "4. Productos terminados."],
		["A-B--II-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "5", "5. Subproductos, residuos y materiales recuperados."],
		["A-B--II-6", "A", "B", "B) ACTIVO CORRIENTE", "", "", "II", "II. Existencias.", "6", "6. Anticipos a proveedores"],
		["A-B--III-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "1", "1. Clientes por ventas y prestaciones de servicios."],
		["A-B--III-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "2", "2. Clientes, empresas del grupo y asociadas."],
		["A-B--III-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "3", "3. Deudores varios."],
		["A-B--III-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "4", "4. Personal."],
		["A-B--III-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "5", "5. Activos por impuesto corriente."],
		["A-B--III-6", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "6", "6. Otros créditos con las Administraciones Públicas."],
		["A-B--III-7", "A", "B", "B) ACTIVO CORRIENTE", "", "", "III", "III. Deudores comerciales y otras cuentas a cobrar.", "7", "7. Accionistas (socios) por desembolsos exigidos"],
		["A-B--IV-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "1", "1. Instrumentos de patrimonio."],
		["A-B--IV-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "2", "2. Créditos a empresas."],
		["A-B--IV-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "3", "3. Valores representativos de deuda."],
		["A-B--IV-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "4", "4. Derivados."],
		["A-B--IV-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "IV", "IV. Inversiones en empresas del grupo y asociadas a corto plazo", "5", "5. Otros activos financieros."],
		["A-B--V-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "1", "1. Instrumentos de patrimonio."],
		["A-B--V-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "2", "2. Créditos a empresas"],
		["A-B--V-3", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "3", "3. Valores representativos de deuda."],
		["A-B--V-4", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "4", "4. Derivados."],
		["A-B--V-5", "A", "B", "B) ACTIVO CORRIENTE", "", "", "V", "V. Inversiones financieras a corto plazo.", "5", "5. Otros activos financieros."],
		["A-B--VI-", "A", "B", "B) ACTIVO CORRIENTE", "", "", "VI", "VI. Periodificaciones a corto plazo.", "", ""],
		["A-B--VII-1", "A", "B", "B) ACTIVO CORRIENTE", "", "", "VII", "VII. Efectivo y otros activos líquidos equivalentes.", "1", "1. Tesorería."],
		["A-B--VII-2", "A", "B", "B) ACTIVO CORRIENTE", "", "", "VII", "VII. Efectivo y otros activos líquidos equivalentes.", "2", "2. Otros activos líquidos equivalentes."],
		["P---VII-2", "P", "", "", "", "", "VII", "VII. Efectivo y otros activos líquidos equivalentes.", "2", "2. Otros activos líquidos equivalentes."],
		["P-A-1-I-1", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "I", "I. Capital.", "1", "1. Capital escriturado."],
		["P-A-1-I-2", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "I", "I. Capital.", "2", "2. (Capital no exigido)."],
		["P-A-1-II-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "II", "II. Prima de emisión.", "", ""],
		["P-A-1-III-1", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "III", "III. Reservas.", "1", "1. Legal y estatutarias."],
		["P-A-1-III-2", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "III", "III. Reservas.", "2", "2. Otras reservas."],
		["P-A-1-IV-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "IV", "IV. (Acciones y participaciones en patrimonio propias).", "", ""],
		["P-A-1-V-1", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "V", "V. Resultados de ejercicios anteriores.", "1", "1. Remanente."],
		["P-A-1-V-2", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "V", "V. Resultados de ejercicios anteriores.", "2", "2. (Resultados negativos de ejercicios anteriores)."],
		["P-A-1-VI-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "VI", "VI. Otras aportaciones de socios.", "", ""],
		["P-A-1-VII-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "VII", "VII. Resultado del ejercicio.", "", ""],
		["P-A-1-VIII-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "VIII", "VIII. (Dividendo a cuenta).", "", ""],
		["P-A-1-IX-", "P", "A", "A) PATRIMONIO NETO", "1", "A-1) Fondos propios.", "IX", "IX. Otros instrumentos de patrimonio neto.", "", ""],
		["P-A-2-I-", "P", "A", "A) PATRIMONIO NETO", "2", "A-2) Ajustes por cambios de valor.", "I", "I. Activos financieros disponibles para la venta", "", ""],
		["P-A-2-II-", "P", "A", "A) PATRIMONIO NETO", "2", "A-2) Ajustes por cambios de valor.", "II", "II. Operaciones de cobertura.", "", ""],
		["P-A-2-III-", "P", "A", "A) PATRIMONIO NETO", "2", "A-2) Ajustes por cambios de valor.", "III", "III. Otros.", "", ""],
		["P-A-3--", "P", "A", "A) PATRIMONIO NETO", "3", "A-3) Subvenciones, donaciones y legados recibidos.", "", "", "", ""],
		["P-B--I-1", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "1", "1. Obligaciones por prestaciones a largo plazo al personal."],
		["P-B--I-2", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "2", "2. Actuaciones medioambientales."],
		["P-B--I-3", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "3", "3. Provisiones por reestructuración."],
		["P-B--I-4", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "I", "I. Provisiones a largo plazo.", "4", "4. Otras provisiones."],
		["P-B--II-1", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "1", "1. Obligaciones y otros valores negociables."],
		["P-B--II-2", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "2", "2. Deudas con entidades de crédito."],
		["P-B--II-3", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "3", "3. Acreedores por arrendamiento financiero."],
		["P-B--II-4", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "4", "4. Derivados."],
		["P-B--II-5", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "II", "II. Deudas a largo plazo.", "5", "5. Otros pasivos financieros."],
		["P-B--III-", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "III", "III. Deudas con empresas del grupo y asociadas a largo plazo.", "", ""],
		["P-B--IV-", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "IV", "IV. Pasivos por impuesto diferido.", "", ""],
		["P-B--V-", "P", "B", "B) PASIVO NO CORRIENTE", "", "", "V", "V. Periodificaciones a largo plazo.", "", ""],
		["P-C--I-", "P", "C", "C) PASIVO CORRIENTE", "", "", "I", "I. Pasivos vinculados con activos no corrientes mantenidos para la venta", "", ""],
		["P-C--II-", "P", "C", "C) PASIVO CORRIENTE", "", "", "II", "II. Provisiones a corto plazo.", "", ""],
		["P-C--III-1", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "1", "1. Obligaciones y otros valores negociables."],
		["P-C--III-2", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "2", "2. Deudas con entidades de crédito."],
		["P-C--III-3", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "3", "3. Acreedores por arrendamiento financiero."],
		["P-C--III-4", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "4", "4. Derivados."],
		["P-C--III-5", "P", "C", "C) PASIVO CORRIENTE", "", "", "III", "III. Deudas a corto plazo.", "5", "5. Otros pasivos financieros."],
		["P-C--IV-", "P", "C", "C) PASIVO CORRIENTE", "", "", "IV", "IV. Deudas con empresas del grupo y asociadas a corto plazo.", "", ""],
		["P-C--V-1", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "1", "1. Proveedores"],
		["P-C--V-2", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "2", "2. Proveedores, empresas del grupo y asociadas."],
		["P-C--V-3", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "3", "3. Acreedores varios."],
		["P-C--V-4", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "4", "4. Personal (remuneraciones pendientes de pago)."],
		["P-C--V-5", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "5", "5. Pasivos por impuesto corriente."],
		["P-C--V-6", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "6", "6. Otras deudas con las Administraciones Públicas."],
		["P-C--V-7", "P", "C", "C) PASIVO CORRIENTE", "", "", "V", "V. Acreedores comerciales y otras cuentas a pagar.", "7", "7. Anticipos de clientes."],
		["P-C--VI-", "P", "C", "C) PASIVO CORRIENTE", "", "", "VI", "VI. Periodificaciones a corto plazo.", "", ""],

		["PG-A-1-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "1", "1. Importe neto de la cifra de negocios. ", "a", " a) Ventas ", "", ""],
		["PG-A-1-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "1", "1. Importe neto de la cifra de negocios. ", "b", " b) Prestaciones de servicios ", "", ""],
		["PG-A-2--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "2", "2. Variación de existencias de productos terminados y en curso de fabricación ", "", "", "", ""],
		["PG-A-3--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "3", "3. Trabajos realizados por la empresa para su activo ", "", "", "", ""],
		["PG-A-4-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "a", " a) Consumo de mercaderías ", "", ""],
		["PG-A-4-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "b", " b) Consumo de materias primas y otras materias consumibles ", "", ""],
		["PG-A-4-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "c", " c) Trabajos realizados por otras empresas ", "", ""],
		["PG-A-4-d-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "4", "4. Aprovisionamientos ", "d", " d) Deterioro de mercaderias , materias primas y otros aprovisioamientos ", "", ""],
		["PG-A-5-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "5", "5. Otros ingresos de explotación ", "a", " a) Ingresos accesorios y otros de gestión corriente ", "", ""],
		["PG-A-5-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "5", "5. Otros ingresos de explotación ", "b", " b) Subvenciones de explotación incorporadas al resultado del ejercicio ", "", ""],
		["PG-A-6-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "6", "6. Gastos de personal ", "a", " a) Sueldos , salarios y asimilados ", "", ""],
		["PG-A-6-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "6", "6. Gastos de personal ", "b", " b) Cargas sociales ", "", ""],
		["PG-A-6-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "6", "6. Gastos de personal ", "c", " c) Provisiones ", "", ""],
		["PG-A-7-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "a", " a) Servicios exteriores ", "", ""],
		["PG-A-7-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "b", " b) Tributos ", "", ""],
		["PG-A-7-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "c", " c) Pérdidas , deterioro y variación de provisiones por operaciones comerciales ", "", ""],
		["PG-A-7-d-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "7", "7. Otros gastos de explotación ", "d", " d) Otros gastos de gestión corriente ", "", ""],
		["PG-A-8--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "8", "8. Amortización del inmovilizado ", "", "", "", ""],
		["PG-A-9--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "9", "9. Imputación de subvenciones de inmovilizado no financiero y otras ", "", "", "", ""],
		["PG-A-10--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "10", "10. Excesos de provisiones ", "", "", "", ""],
		["PG-A-11-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "11", "11. Deterioro y resultado por enajenaciones del inmovilizado ", "a", " a) Deterioros y pérdidas ", "", ""],
		["PG-A-11-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "11", "11. Deterioro y resultado por enajenaciones del inmovilizado ", "b", " b) Resultados por enajenaciones y otras ", "", ""],
		["PG-A-12-a-1", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "a", " a) De participaciones en instrumentos de patrimonio ", "1", " a1) En empresas del grupo y asociadas "],
		["PG-A-12-a-2", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "a", " a) De participaciones en instrumentos de patrimonio ", "2", " a2) En empresas terceros "],
		["PG-A-12-b-1", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "b", " b) De valores negociables y otros instrumentos financieros ", "1", " b1) De empresas del grupo y asociadas "],
		["PG-A-12-b-2", "PG", "A", "A) OPERACIONES CONTINUADAS ", "12", "12. Ingresos financieros ", "b", " b) De valores negociables y otros instrumentos financieros ", "2", " b2) De terceros "],
		["PG-A-13-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "13", "13. Gastos financieros ", "a", " a) Por deudas con empresas del grupo y asociadas ", "", ""],
		["PG-A-13-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "13", "13. Gastos financieros ", "b", " b) Por deudas con terceros ", "", ""],
		["PG-A-13-c-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "13", "13. Gastos financieros ", "c", " c) Por actualización de provisiones ", "", ""],
		["PG-A-14-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "14", "14. Variación de valor razonable en instrumentos financieros ", "a", " a) Cartera de negociación y otros ", "", ""],
		["PG-A-14-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "14", "14. Variación de valor razonable en instrumentos financieros ", "b", " b) Imputación al resultado del ejercicio por activos fros. disponibles para la venta ", "", ""],
		["PG-A-15--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "15", "15. Diferencias de cambio ", "", "", "", ""],
		["PG-A-16-a-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "16", "16. Deterioro y resultado por enajenaciones de instrumentos financieros ", "a", " a) Deterioros y pérdidas ", "", ""],
		["PG-A-16-b-", "PG", "A", "A) OPERACIONES CONTINUADAS ", "16", "16. Deterioro y resultado por enajenaciones de instrumentos financieros ", "b", " b) Resultados por enajenaciones y otras ", "", ""],
		["PG-A-17--", "PG", "A", "A) OPERACIONES CONTINUADAS ", "17", "17. Impuesto sobre beneficios ", "", "  ", "", ""],
		["PG-B-18--", "PG", "B", "B) OPERACIONES INTERRUMPIDAS ", "18", "18. Resultado del ejercicio procedente de operaciones interrumpidas neto de impuestos ", "", "  ", "", ""],

		["IG-A--I-1", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "I", "I. Por valoración instrumentos financieros. ", "1", "1. Activos financieros disponibles para la venta. "],
		["IG-A--I-2", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "I", "I. Por valoración instrumentos financieros. ", "2", "2. Otros ingresos/gastos. "],
		["IG-A--II-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "II", "II. Por coberturas de flujos de efectivo. ", "", ""],
		["IG-A--III-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "III", "III. Subvenciones, donaciones y legados recibidos. ", "", ""],
		["IG-A--IV-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "IV", "IV. Por ganancias y pérdidas actuariales y otros ajustes. ", "", ""],
		["IG-A--V-", "IG", "A", "Ingresos y gastos imputados directamente al patrimonio neto ", "", "", "V", "V. Efecto impositivo. ", "", ""],
		["IG-B--VI-1", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VI", "VI. Por valoración de instrumentos financieros. ", "1", "1.Activos financieros disponibles para la venta. "],
		["IG-B--VI-2", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VI", "VI. Por valoración de instrumentos financieros. ", "2", "2. Otros ingresos/gastos. "],
		["IG-B--VII-", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VII", "VII. Por coberturas de flujos de efectivo. ", "", ""],
		["IG-B--VIII-", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "VIII", "VIII. Subvenciones, donaciones y legados recibidos. ", "", ""],
		["IG-B--IX-", "IG", "B", "Transferencias a la cuenta de pérdidas y ganancias ", "", "", "IX", "IX. Efecto impositivo. ", "", ""],
	];

	var orden:Number;
	util.createProgressDialog(util.translate("scripts", "Creando códigos de balance 2008"), datos.length);

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);

		curCbl.setModeAccess(curCbl.Insert);
		curCbl.refreshBuffer();
		curCbl.setValueBuffer("codbalance", datos[i][0]);
		curCbl.setValueBuffer("naturaleza", datos[i][1]);
		if (datos[i][2])
			curCbl.setValueBuffer("nivel1", datos[i][2]);
		if (datos[i][3])
			curCbl.setValueBuffer("descripcion1", datos[i][3]);
		if (datos[i][4])
			curCbl.setValueBuffer("nivel2", datos[i][4]);
		if (datos[i][5])
			curCbl.setValueBuffer("descripcion2", datos[i][5]);
		if (datos[i][6])
			curCbl.setValueBuffer("nivel3", datos[i][6]);
		if (datos[i][7])
			curCbl.setValueBuffer("descripcion3", datos[i][7]);
		if (datos[i][8])
			curCbl.setValueBuffer("nivel4", datos[i][8]);
		if (datos[i][9])
			curCbl.setValueBuffer("descripcion4", datos[i][9]);

		curCbl.commitBuffer();
	}

	this.iface.generarOrden3CB();

	util.destroyProgressDialog();
}


/** \D Es necesario actualizar el orden del nivel 3 en los códigos
para poder ordenar por números romanos
\end */
function pgc2008_generarOrden3CB()
{
	var romanos:String = "ðIðIIðIIIðIVðVðVIðVIIðVIIIðIXð";
	var nivel3:String;

	var roman2arab = [];
	roman2arab["I"] = 1;
	roman2arab["II"] = 2;
	roman2arab["III"] = 3;
	roman2arab["IV"] = 4;
	roman2arab["V"] = 5;
	roman2arab["VI"] = 6;
	roman2arab["VII"] = 7;
	roman2arab["VIII"] = 8;
	roman2arab["IX"] = 9;

	var curCbl:FLSqlCursor = new FLSqlCursor("co_codbalances08");
	curCbl.select();

	while (curCbl.next()) {

		curCbl.setModeAccess(curCbl.Edit);
		curCbl.refreshBuffer();

		nivel3 = curCbl.valueBuffer("nivel3");
		if (romanos.search("ð" + nivel3 + "ð") == -1)
			curCbl.setValueBuffer("orden3", nivel3.toString());
		else
			curCbl.setValueBuffer("orden3", roman2arab[nivel3]);

		curCbl.commitBuffer();
	}
}

/** \D Se actualizan los códigos de balance en las cuentas
\end */
function pgc2008_actualizarCuentas2008(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_cuentascb");
	curCbl.setActivatedCheckIntegrity(false);

	var datos = [
		["201","A-A--I-1"],
		["2801","A-A--I-1"],
		["200","A-A--I-1"],
		["2901","A-A--I-1"],
		["2900","A-A--I-1"],
		["2802","A-A--I-2"],
		["2902","A-A--I-2"],
		["202","A-A--I-2"],
		["203","A-A--I-3"],
		["2803","A-A--I-3"],
		["2903","A-A--I-3"],
		["204","A-A--I-4"],
		["206","A-A--I-5"],
		["2806","A-A--I-5"],
		["2906","A-A--I-5"],
		["209","A-A--I-6"],
		["205","A-A--I-6"],
		["2905","A-A--I-6"],
		["2805","A-A--I-6"],
		["2910","A-A--II-1"],
		["2911","A-A--II-1"],
		["210","A-A--II-1"],
		["2811","A-A--II-1"],
		["211","A-A--II-1"],
		["216","A-A--II-2"],
		["2919","A-A--II-2"],
		["2918","A-A--II-2"],
		["2917","A-A--II-2"],
		["2916","A-A--II-2"],
		["2915","A-A--II-2"],
		["2914","A-A--II-2"],
		["2913","A-A--II-2"],
		["2912","A-A--II-2"],
		["2819","A-A--II-2"],
		["2818","A-A--II-2"],
		["2817","A-A--II-2"],
		["2816","A-A--II-2"],
		["2815","A-A--II-2"],
		["2814","A-A--II-2"],
		["2813","A-A--II-2"],
		["2812","A-A--II-2"],
		["212","A-A--II-2"],
		["213","A-A--II-2"],
		["214","A-A--II-2"],
		["215","A-A--II-2"],
		["217","A-A--II-2"],
		["218","A-A--II-2"],
		["219","A-A--II-2"],
		["23","A-A--II-3"],
		["220","A-A--III-1"],
		["2920","A-A--III-1"],
		["282","A-A--III-2"],
		["221","A-A--III-2"],
		["2921","A-A--III-2"],
		["2493","A-A--IV-1"],
		["2404","A-A--IV-1"],
		["2494","A-A--IV-1"],
		["2403","A-A--IV-1"],
		["293","A-A--IV-1"],
		["2953","A-A--IV-2"],
		["2424","A-A--IV-2"],
		["2423","A-A--IV-2"],
		["2954","A-A--IV-2"],
		["2414","A-A--IV-3"],
		["2943","A-A--IV-3"],
		["2944","A-A--IV-3"],
		["2413","A-A--IV-3"],
		["2405","A-A--V-1"],
		["2495","A-A--V-1"],
		["250","A-A--V-1"],
		["259","A-A--V-1"],
		["2955","A-A--V-2"],
		["298","A-A--V-2"],
		["252","A-A--V-2"],
		["253","A-A--V-2"],
		["254","A-A--V-2"],
		["2425","A-A--V-2"],
		["251","A-A--V-3"],
		["2415","A-A--V-3"],
		["2945","A-A--V-3"],
		["297","A-A--V-3"],
		["255","A-A--V-4"],
		["258","A-A--V-5"],
		["26","A-A--V-5"],
		["474","A-A--VI-"],
		["580","A-B--I-"],
		["582","A-B--I-"],
		["583","A-B--I-"],
		["584","A-B--I-"],
		["599","A-B--I-"],
		["581","A-B--I-"],
		["390","A-B--II-1"],
		["30","A-B--II-1"],
		["32","A-B--II-2"],
		["392","A-B--II-2"],
		["391","A-B--II-2"],
		["31","A-B--II-2"],
		["33","A-B--II-3"],
		["34","A-B--II-3"],
		["394","A-B--II-3"],
		["393","A-B--II-3"],
		["395","A-B--II-4"],
		["35","A-B--II-4"],
		["396","A-B--II-5"],
		["36","A-B--II-5"],
		["407","A-B--II-6"],
		["430","A-B--III-1"],
		["490","A-B--III-1"],
		["4935","A-B--III-1"],
		["437","A-B--III-1"],
		["436","A-B--III-1"],
		["435","A-B--III-1"],
		["432","A-B--III-1"],
		["431","A-B--III-1"],
		["4934","A-B--III-2"],
		["434","A-B--III-2"],
		["433","A-B--III-2"],
		["4933","A-B--III-2"],
		["5533","A-B--III-3"],
		["44","A-B--III-3"],
		["5531","A-B--III-3"],
		["460","A-B--III-4"],
		["544","A-B--III-4"],
		["4709","A-B--III-5"],
		["472","A-B--III-6"],
		["471","A-B--III-6"],
		["4708","A-B--III-6"],
		["4700","A-B--III-6"],
		["5585","A-B--III-7"],
		["5580","A-B--III-7"],
		["5393","A-B--IV-1"],
		["5303","A-B--IV-1"],
		["5304","A-B--IV-1"],
		["5394","A-B--IV-1"],
		["593","A-B--IV-1"],
		["5954","A-B--IV-2"],
		["5953","A-B--IV-2"],
		["5344","A-B--IV-2"],
		["5343","A-B--IV-2"],
		["5324","A-B--IV-2"],
		["5323","A-B--IV-2"],
		["5334","A-B--IV-3"],
		["5333","A-B--IV-3"],
		["5314","A-B--IV-3"],
		["5944","A-B--IV-3"],
		["5313","A-B--IV-3"],
		["5943","A-B--IV-3"],
		["5524","A-B--IV-5"],
		["5354","A-B--IV-5"],
		["5353","A-B--IV-5"],
		["5523","A-B--IV-5"],
		["540","A-B--V-1"],
		["5305","A-B--V-1"],
		["5395","A-B--V-1"],
		["549","A-B--V-1"],
		["598","A-B--V-2"],
		["5325","A-B--V-2"],
		["5345","A-B--V-2"],
		["542","A-B--V-2"],
		["543","A-B--V-2"],
		["547","A-B--V-2"],
		["5955","A-B--V-2"],
		["5335","A-B--V-3"],
		["5315","A-B--V-3"],
		["541","A-B--V-3"],
		["597","A-B--V-3"],
		["546","A-B--V-3"],
		["5945","A-B--V-3"],
		["5590","A-B--V-4"],
		["5593","A-B--V-4"],
		["565","A-B--V-5"],
		["566","A-B--V-5"],
		["5525","A-B--V-5"],
		["551","A-B--V-5"],
		["550","A-B--V-5"],
		["548","A-B--V-5"],
		["545","A-B--V-5"],
		["5355","A-B--V-5"],
		["480","A-B--VI-"],
		["567","A-B--VI-"],
		["573","A-B--VII-1"],
		["575","A-B--VII-1"],
		["574","A-B--VII-1"],
		["570","A-B--VII-1"],
		["571","A-B--VII-1"],
		["572","A-B--VII-1"],
		["576","A-B--VII-2"],
		["992","IG-A--I-1"],
		["89","IG-A--I-1"],
		["800","IG-A--I-1"],
		["900","IG-A--I-1"],
		["991","IG-A--I-1"],
		["811","IG-A--II-"],
		["810","IG-A--II-"],
		["910","IG-A--II-"],
		["94","IG-A--III-"],
		["85","IG-A--IV-"],
		["95","IG-A--IV-"],
		["834","IG-A--V-"],
		["835","IG-A--V-"],
		["838","IG-A--V-"],
		["8300","IG-A--V-"],
		["833","IG-A--V-"],
		["836","IG-B--IX-"],
		["8301","IG-B--IX-"],
		["837","IG-B--IX-"],
		["902","IG-B--VI-1"],
		["993","IG-B--VI-1"],
		["994","IG-B--VI-1"],
		["802","IG-B--VI-1"],
		["813","IG-B--VII-"],
		["912","IG-B--VII-"],
		["812","IG-B--VII-"],
		["84","IG-B--VIII-"],
		["101","P-A-1-I-1"],
		["102","P-A-1-I-1"],
		["100","P-A-1-I-1"],
		["1030","P-A-1-I-2"],
		["1040","P-A-1-I-2"],
		["110","P-A-1-II-"],
		["1141","P-A-1-III-1"],
		["112","P-A-1-III-1"],
		["119","P-A-1-III-2"],
		["1140","P-A-1-III-2"],
		["115","P-A-1-III-2"],
		["113","P-A-1-III-2"],
		["1142","P-A-1-III-2"],
		["1143","P-A-1-III-2"],
		["1144","P-A-1-III-2"],
		["108","P-A-1-IV-"],
		["109","P-A-1-IV-"],
		["111","P-A-1-IX-"],
		["120","P-A-1-V-1"],
		["121","P-A-1-V-2"],
		["118","P-A-1-VI-"],
		["129","P-A-1-VII-"],
		["557","P-A-1-VIII-"],
		["133","P-A-2-I-"],
		["136","P-A-2-I-"],
		["1340","P-A-2-II-"],
		["1341","P-A-2-II-"],
		["137","P-A-2-III-"],
		["135","P-A-2-III-"],
		["131","P-A-3--"],
		["130","P-A-3--"],
		["132","P-A-3--"],
		["140","P-B--I-1"],
		["145","P-B--I-2"],
		["146","P-B--I-3"],
		["142","P-B--I-4"],
		["141","P-B--I-4"],
		["147","P-B--I-4"],
		["143","P-B--I-4"],
		["177","P-B--II-1"],
		["178","P-B--II-1"],
		["179","P-B--II-1"],
		["1605","P-B--II-2"],
		["170","P-B--II-2"],
		["1625","P-B--II-3"],
		["174","P-B--II-3"],
		["176","P-B--II-4"],
		["171","P-B--II-5"],
		["173","P-B--II-5"],
		["172","P-B--II-5"],
		["175","P-B--II-5"],
		["189","P-B--II-5"],
		["185","P-B--II-5"],
		["150","P-B--II-5"],
		["180","P-B--II-5"],
		["1615","P-B--II-5"],
		["1635","P-B--II-5"],
		["1604","P-B--III-"],
		["1603","P-B--III-"],
		["1613","P-B--III-"],
		["1614","P-B--III-"],
		["1623","P-B--III-"],
		["1624","P-B--III-"],
		["1633","P-B--III-"],
		["1634","P-B--III-"],
		["479","P-B--IV-"],
		["181","P-B--V-"],
		["588","P-C--I-"],
		["589","P-C--I-"],
		["587","P-C--I-"],
		["586","P-C--I-"],
		["585","P-C--I-"],
		["499","P-C--II-"],
		["529","P-C--II-"],
		["506","P-C--III-1"],
		["500","P-C--III-1"],
		["501","P-C--III-1"],
		["505","P-C--III-1"],
		["527","P-C--III-2"],
		["5105","P-C--III-2"],
		["520","P-C--III-2"],
		["5125","P-C--III-3"],
		["524","P-C--III-3"],
		["5598","P-C--III-4"],
		["5595","P-C--III-4"],
		["1034","P-C--III-5"],
		["194","P-C--III-5"],
		["1044","P-C--III-5"],
		["525","P-C--III-5"],
		["192","P-C--III-5"],
		["569","P-C--III-5"],
		["5532","P-C--III-5"],
		["509","P-C--III-5"],
		["5135","P-C--III-5"],
		["5530","P-C--III-5"],
		["528","P-C--III-5"],
		["5145","P-C--III-5"],
		["526","P-C--III-5"],
		["561","P-C--III-5"],
		["560","P-C--III-5"],
		["521","P-C--III-5"],
		["522","P-C--III-5"],
		["190","P-C--III-5"],
		["523","P-C--III-5"],
		["5566","P-C--III-5"],
		["555","P-C--III-5"],
		["5565","P-C--III-5"],
		["5525","P-C--III-5"],
		["5115","P-C--III-5"],
		["551","P-C--III-5"],
		["5113","P-C--IV-"],
		["5114","P-C--IV-"],
		["5123","P-C--IV-"],
		["5124","P-C--IV-"],
		["5133","P-C--IV-"],
		["5104","P-C--IV-"],
		["5103","P-C--IV-"],
		["5134","P-C--IV-"],
		["5143","P-C--IV-"],
		["5144","P-C--IV-"],
		["5563","P-C--IV-"],
		["5564","P-C--IV-"],
		["400","P-C--V-1"],
		["405","P-C--V-1"],
		["406","P-C--V-1"],
		["401","P-C--V-1"],
		["403","P-C--V-2"],
		["404","P-C--V-2"],
		["41","P-C--V-3"],
		["465","P-C--V-4"],
		["466","P-C--V-4"],
		["4752","P-C--V-5"],
		["476","P-C--V-6"],
		["477","P-C--V-6"],
		["4758","P-C--V-6"],
		["4751","P-C--V-6"],
		["4750","P-C--V-6"],
		["438","P-C--V-7"],
		["485","P-C--VI-"],
		["568","P-C--VI-"],
		["7951","PG-A-10--"],
		["7952","PG-A-10--"],
		["7956","PG-A-10--"],
		["7955","PG-A-10--"],
		["691","PG-A-11-a-"],
		["792","PG-A-11-a-"],
		["791","PG-A-11-a-"],
		["790","PG-A-11-a-"],
		["690","PG-A-11-a-"],
		["692","PG-A-11-a-"],
		["770","PG-A-11-b-"],
		["670","PG-A-11-b-"],
		["671","PG-A-11-b-"],
		["672","PG-A-11-b-"],
		["771","PG-A-11-b-"],
		["772","PG-A-11-b-"],
		["7601","PG-A-12-a-1"],
		["7600","PG-A-12-a-1"],
		["7602","PG-A-12-a-2"],
		["7603","PG-A-12-a-2"],
		["7611","PG-A-12-b-1"],
		["7610","PG-A-12-b-1"],
		["76200", "PG-A-12-b-1"],
		["76211", "PG-A-12-b-1"],
		["76210", "PG-A-12-b-1"],
		["76201", "PG-A-12-b-1"],
		["76202", "PG-A-12-b-2"],
		["76213", "PG-A-12-b-2"],
		["76212", "PG-A-12-b-2"],
		["76203", "PG-A-12-b-2"],
		["7612","PG-A-12-b-2"],
		["7613","PG-A-12-b-2"],
		["767","PG-A-12-b-2"],
		["769","PG-A-12-b-2"],
		["6615","PG-A-13-a-"],
		["6616","PG-A-13-a-"],
		["6651","PG-A-13-a-"],
		["6650","PG-A-13-a-"],
		["6620","PG-A-13-a-"],
		["6621","PG-A-13-a-"],
		["6641","PG-A-13-a-"],
		["6640","PG-A-13-a-"],
		["6610","PG-A-13-a-"],
		["6611","PG-A-13-a-"],
		["6655","PG-A-13-a-"],
		["6654","PG-A-13-a-"],
		["6657","PG-A-13-b-"],
		["6612","PG-A-13-b-"],
		["6613","PG-A-13-b-"],
		["6617","PG-A-13-b-"],
		["6618","PG-A-13-b-"],
		["6622","PG-A-13-b-"],
		["6623","PG-A-13-b-"],
		["6624","PG-A-13-b-"],
		["6642","PG-A-13-b-"],
		["6643","PG-A-13-b-"],
		["6652","PG-A-13-b-"],
		["6653","PG-A-13-b-"],
		["6656","PG-A-13-b-"],
		["669","PG-A-13-b-"],
		["660","PG-A-13-c-"],
		["7633","PG-A-14-a-"],
		["6631","PG-A-14-a-"],
		["6633","PG-A-14-a-"],
		["6630","PG-A-14-a-"],
		["7630","PG-A-14-a-"],
		["7631","PG-A-14-a-"],
		["7632","PG-A-14-b-"],
		["6632","PG-A-14-b-"],
		["768","PG-A-15--"],
		["668","PG-A-15--"],
		["699","PG-A-16-a-"],
		["797","PG-A-16-a-"],
		["798","PG-A-16-a-"],
		["799","PG-A-16-a-"],
		["696","PG-A-16-a-"],
		["697","PG-A-16-a-"],
		["698","PG-A-16-a-"],
		["796","PG-A-16-a-"],
		["673","PG-A-16-b-"],
		["667","PG-A-16-b-"],
		["666","PG-A-16-b-"],
		["775","PG-A-16-b-"],
		["773","PG-A-16-b-"],
		["766","PG-A-16-b-"],
		["675","PG-A-16-b-"],
		["6301","PG-A-17--"],
		["638","PG-A-17--"],
		["6300","PG-A-17--"],
		["633","PG-A-17--"],
		["702","PG-A-1-a-"],
		["706","PG-A-1-a-"],
		["708","PG-A-1-a-"],
		["709","PG-A-1-a-"],
		["701","PG-A-1-a-"],
		["700","PG-A-1-a-"],
		["703","PG-A-1-a-"],
		["704","PG-A-1-a-"],
		["705","PG-A-1-b-"],
		["6930","PG-A-2--"],
		["7930","PG-A-2--"],
		["71","PG-A-2--"],
		["73","PG-A-3--"],
		["6060","PG-A-4-a-"],
		["600","PG-A-4-a-"],
		["6080","PG-A-4-a-"],
		["6090","PG-A-4-a-"],
		["610","PG-A-4-a-"],
		["6062","PG-A-4-b-"],
		["6091","PG-A-4-b-"],
		["602","PG-A-4-b-"],
		["6061","PG-A-4-b-"],
		["601","PG-A-4-b-"],
		["6092","PG-A-4-b-"],
		["612","PG-A-4-b-"],
		["611","PG-A-4-b-"],
		["6081","PG-A-4-b-"],
		["6082","PG-A-4-b-"],
		["607","PG-A-4-c-"],
		["7931","PG-A-4-d-"],
		["6932","PG-A-4-d-"],
		["6931","PG-A-4-d-"],
		["7932","PG-A-4-d-"],
		["7933","PG-A-4-d-"],
		["6933","PG-A-4-d-"],
		["75","PG-A-5-a-"],
		["740","PG-A-5-b-"],
		["747","PG-A-5-b-"],
		["6450","PG-A-6-a-"],
		["640","PG-A-6-a-"],
		["641","PG-A-6-a-"],
		["642","PG-A-6-b-"],
		["643","PG-A-6-b-"],
		["649","PG-A-6-b-"],
		["7950","PG-A-6-c-"],
		["644","PG-A-6-c-"],
		["6457","PG-A-6-c-"],
		["7957","PG-A-6-c-"],
		["62","PG-A-7-a-"],
		["634","PG-A-7-b-"],
		["636","PG-A-7-b-"],
		["631","PG-A-7-b-"],
		["639","PG-A-7-b-"],
		["694","PG-A-7-c-"],
		["695","PG-A-7-c-"],
		["794","PG-A-7-c-"],
		["7954","PG-A-7-c-"],
		["650","PG-A-7-c-"],
		["651","PG-A-7-d-"],
		["659","PG-A-7-d-"],
		["68","PG-A-8--"],
		["746","PG-A-9--"]
	];

	util.createProgressDialog(util.translate("scripts", "Actualizando códigos de balance"), datos.length);

	datos.sort();

	for (i = datos.length - 1; i >= 0; i--) {

		util.setProgress(datos.length - i);

		codCuenta = datos[i][0];

		curCbl.select("codcuenta = '" + codCuenta + "'");
		if (curCbl.first()) {
			continue;
		}
		else {
			curCbl.setModeAccess(curCbl.Insert);
			curCbl.refreshBuffer();
			curCbl.setValueBuffer("codcuenta", codCuenta);
			curCbl.setValueBuffer("codbalance", datos[i][1]);
			curCbl.commitBuffer();
		}


	}

	util.destroyProgressDialog();
}


/** \D Se actualizan los códigos de balance en las cuentas
\end */
function pgc2008_actualizarCuentas2008ba(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_cuentascbba");
	curCbl.setActivatedCheckIntegrity(false);

	var datos = [
		["290","A-A--I-1"],
		["280","A-A--I-1"],
		["20","A-A--I-1"],
		["281","A-A--II-1"],
		["291","A-A--II-1"],
		["23","A-A--II-1"],
		["21","A-A--II-1"],
		["282","A-A--III-1"],
		["292","A-A--III-1"],
		["22","A-A--III-1"],
		["293","A-A--IV-1"],
		["2494","A-A--IV-1"],
		["2424","A-A--IV-1"],
		["2493","A-A--IV-1"],
		["2423","A-A--IV-1"],
		["2404","A-A--IV-1"],
		["2414","A-A--IV-1"],
		["2413","A-A--IV-1"],
		["2403","A-A--IV-1"],
		["2944","A-A--IV-1"],
		["2954","A-A--IV-1"],
		["2953","A-A--IV-1"],
		["2943","A-A--IV-1"],
		["254","A-A--V-1"],
		["253","A-A--V-1"],
		["252","A-A--V-1"],
		["251","A-A--V-1"],
		["250","A-A--V-1"],
		["2495","A-A--V-1"],
		["2425","A-A--V-1"],
		["2415","A-A--V-1"],
		["2405","A-A--V-1"],
		["26","A-A--V-1"],
		["259","A-A--V-1"],
		["258","A-A--V-1"],
		["257","A-A--V-1"],
		["298","A-A--V-1"],
		["255","A-A--V-1"],
		["2955","A-A--V-1"],
		["297","A-A--V-1"],
		["2945","A-A--V-1"],
		["474","A-A--VI-"],
		["580","A-B--I-"],
		["581","A-B--I-"],
		["582","A-B--I-"],
		["583","A-B--I-"],
		["584","A-B--I-"],
		["599","A-B--I-"],
		["31","A-B--II-1"],
		["407","A-B--II-1"],
		["39","A-B--II-1"],
		["36","A-B--II-1"],
		["35","A-B--II-1"],
		["34","A-B--II-1"],
		["33","A-B--II-1"],
		["32","A-B--II-1"],
		["30","A-B--II-1"],
		["431","A-B--III-1"],
		["430","A-B--III-1"],
		["493","A-B--III-1"],
		["490","A-B--III-1"],
		["437","A-B--III-1"],
		["436","A-B--III-1"],
		["435","A-B--III-1"],
		["434","A-B--III-1"],
		["433","A-B--III-1"],
		["432","A-B--III-1"],
		["5580","A-B--III-2"],
		["5533","A-B--III-3"],
		["44","A-B--III-3"],
		["460","A-B--III-3"],
		["470","A-B--III-3"],
		["471","A-B--III-3"],
		["472","A-B--III-3"],
		["544","A-B--III-3"],
		["5531","A-B--III-3"],
		["5353","A-B--IV-1"],
		["5943","A-B--IV-1"],
		["5944","A-B--IV-1"],
		["5354","A-B--IV-1"],
		["5393","A-B--IV-1"],
		["5953","A-B--IV-1"],
		["5954","A-B--IV-1"],
		["5303","A-B--IV-1"],
		["5394","A-B--IV-1"],
		["5523","A-B--IV-1"],
		["5524","A-B--IV-1"],
		["5313","A-B--IV-1"],
		["5304","A-B--IV-1"],
		["593","A-B--IV-1"],
		["5344","A-B--IV-1"],
		["5343","A-B--IV-1"],
		["5334","A-B--IV-1"],
		["5333","A-B--IV-1"],
		["5324","A-B--IV-1"],
		["5323","A-B--IV-1"],
		["5314","A-B--IV-1"],
		["549","A-B--V-1"],
		["5305","A-B--V-1"],
		["5315","A-B--V-1"],
		["5325","A-B--V-1"],
		["5335","A-B--V-1"],
		["5345","A-B--V-1"],
		["5355","A-B--V-1"],
		["5395","A-B--V-1"],
		["540","A-B--V-1"],
		["541","A-B--V-1"],
		["542","A-B--V-1"],
		["543","A-B--V-1"],
		["545","A-B--V-1"],
		["546","A-B--V-1"],
		["547","A-B--V-1"],
		["548","A-B--V-1"],
		["551","A-B--V-1"],
		["5525","A-B--V-1"],
		["5590","A-B--V-1"],
		["5593","A-B--V-1"],
		["565","A-B--V-1"],
		["566","A-B--V-1"],
		["5945","A-B--V-1"],
		["5955","A-B--V-1"],
		["597","A-B--V-1"],
		["598","A-B--V-1"],
		["480","A-B--VI-"],
		["567","A-B--VI-"],
		["57","A-B--VII-1"],
		["800","IG-A--I-1"],
		["89","IG-A--I-1"],
		["900","IG-A--I-1"],
		["991","IG-A--I-1"],
		["992","IG-A--I-1"],
		["910","IG-A--II-"],
		["810","IG-A--II-"],
		["94","IG-A--III-"],
		["95","IG-A--IV-"],
		["85","IG-A--IV-"],
		["8301","IG-A--V-"],
		["833","IG-A--V-"],
		["835","IG-A--V-"],
		["838","IG-A--V-"],
		["834","IG-A--V-"],
		["8300","IG-A--V-"],
		["837","IG-B--IX-"],
		["8301","IG-B--IX-"],
		["836","IG-B--IX-"],
		["902","IG-B--VI-1"],
		["802","IG-B--VI-1"],
		["994","IG-B--VI-1"],
		["993","IG-B--VI-1"],
		["812","IG-B--VII-"],
		["912","IG-B--VII-"],
		["84","IG-B--VIII-"],
		["101","P-A-1-I-1"],
		["102","P-A-1-I-1"],
		["100","P-A-1-I-1"],
		["1030","P-A-1-I-2"],
		["1040","P-A-1-I-2"],
		["110","P-A-1-II-"],
		["113","P-A-1-III-1"],
		["114","P-A-1-III-1"],
		["115","P-A-1-III-1"],
		["119","P-A-1-III-1"],
		["112","P-A-1-III-1"],
		["108","P-A-1-IV-"],
		["109","P-A-1-IV-"],
		["111","P-A-1-IX-"],
		["121","P-A-1-V-1"],
		["120","P-A-1-V-1"],
		["118","P-A-1-VI-"],
		["129","P-A-1-VII-"],
		["557","P-A-1-VIII-"],
		["137","P-A-2-I-"],
		["1340","P-A-2-I-"],
		["133","P-A-2-I-"],
		["132","P-A-3--"],
		["130","P-A-3--"],
		["131","P-A-3--"],
		["14","P-B--I-1"],
		["170","P-B--II-1"],
		["1605","P-B--II-1"],
		["1625","P-B--II-2"],
		["174","P-B--II-2"],
		["1635","P-B--II-3"],
		["171","P-B--II-3"],
		["172","P-B--II-3"],
		["173","P-B--II-3"],
		["1615","P-B--II-3"],
		["189","P-B--II-3"],
		["185","P-B--II-3"],
		["180","P-B--II-3"],
		["179","P-B--II-3"],
		["178","P-B--II-3"],
		["177","P-B--II-3"],
		["176","P-B--II-3"],
		["175","P-B--II-3"],
		["1603","P-B--III-"],
		["1634","P-B--III-"],
		["1633","P-B--III-"],
		["1624","P-B--III-"],
		["1623","P-B--III-"],
		["1614","P-B--III-"],
		["1613","P-B--III-"],
		["1604","P-B--III-"],
		["479","P-B--IV-"],
		["181","P-B--V-"],
		["589","P-C--I-"],
		["588","P-C--I-"],
		["587","P-C--I-"],
		["586","P-C--I-"],
		["585","P-C--I-"],
		["529","P-C--II-"],
		["499","P-C--II-"],
		["5105","P-C--III-1"],
		["527","P-C--III-1"],
		["520","P-C--III-1"],
		["524","P-C--III-2"],
		["5125","P-C--III-2"],
		["5135","P-C--III-3"],
		["5115","P-C--III-3"],
		["509","P-C--III-3"],
		["506","P-C--III-3"],
		["505","P-C--III-3"],
		["501","P-C--III-3"],
		["500","P-C--III-3"],
		["194","P-C--III-3"],
		["192","P-C--III-3"],
		["190","P-C--III-3"],
		["5145","P-C--III-3"],
		["1034","P-C--III-3"],
		["5530","P-C--III-3"],
		["1044","P-C--III-3"],
		["560","P-C--III-3"],
		["561","P-C--III-3"],
		["569","P-C--III-3"],
		["522","P-C--III-3"],
		["523","P-C--III-3"],
		["525","P-C--III-3"],
		["526","P-C--III-3"],
		["528","P-C--III-3"],
		["551","P-C--III-3"],
		["5525","P-C--III-3"],
		["5532","P-C--III-3"],
		["555","P-C--III-3"],
		["5565","P-C--III-3"],
		["5566","P-C--III-3"],
		["5595","P-C--III-3"],
		["521","P-C--III-3"],
		["5598","P-C--III-3"],
		["5564","P-C--IV-"],
		["5103","P-C--IV-"],
		["5113","P-C--IV-"],
		["5114","P-C--IV-"],
		["5123","P-C--IV-"],
		["5124","P-C--IV-"],
		["5133","P-C--IV-"],
		["5134","P-C--IV-"],
		["5143","P-C--IV-"],
		["5144","P-C--IV-"],
		["5523","P-C--IV-"],
		["5524","P-C--IV-"],
		["5563","P-C--IV-"],
		["5104","P-C--IV-"],
		["405","P-C--V-1"],
		["406","P-C--V-1"],
		["404","P-C--V-1"],
		["403","P-C--V-1"],
		["401","P-C--V-1"],
		["400","P-C--V-1"],
		["475","P-C--V-2"],
		["476","P-C--V-2"],
		["477","P-C--V-2"],
		["41","P-C--V-2"],
		["438","P-C--V-2"],
		["465","P-C--V-2"],
		["466","P-C--V-2"],
		["568","P-C--VI-"],
		["485","P-C--VI-"],
		["7951","PG-A-10--"],
		["7956","PG-A-10--"],
		["7955","PG-A-10--"],
		["7952","PG-A-10--"],
		["670","PG-A-11-a-"],
		["792","PG-A-11-a-"],
		["791","PG-A-11-a-"],
		["790","PG-A-11-a-"],
		["772","PG-A-11-a-"],
		["771","PG-A-11-a-"],
		["770","PG-A-11-a-"],
		["692","PG-A-11-a-"],
		["691","PG-A-11-a-"],
		["690","PG-A-11-a-"],
		["672","PG-A-11-a-"],
		["671","PG-A-11-a-"],
		["769","PG-A-12-a-1"],
		["762","PG-A-12-a-1"],
		["761","PG-A-12-a-1"],
		["760","PG-A-12-a-1"],
		["767","PG-A-12-a-1"],
		["669","PG-A-13-a-"],
		["660","PG-A-13-a-"],
		["665","PG-A-13-a-"],
		["664","PG-A-13-a-"],
		["662","PG-A-13-a-"],
		["661","PG-A-13-a-"],
		["763","PG-A-14-a-"],
		["663","PG-A-14-a-"],
		["668","PG-A-15--"],
		["768","PG-A-15--"],
		["675","PG-A-16-a-"],
		["667","PG-A-16-a-"],
		["666","PG-A-16-a-"],
		["698","PG-A-16-a-"],
		["697","PG-A-16-a-"],
		["696","PG-A-16-a-"],
		["668","PG-A-16-a-"],
		["799","PG-A-16-a-"],
		["798","PG-A-16-a-"],
		["797","PG-A-16-a-"],
		["796","PG-A-16-a-"],
		["775","PG-A-16-a-"],
		["773","PG-A-16-a-"],
		["766","PG-A-16-a-"],
		["699","PG-A-16-a-"],
		["638","PG-A-17--"],
		["633","PG-A-17--"],
		["6301","PG-A-17--"],
		["6300","PG-A-17--"],
		["708","PG-A-1-a-"],
		["703","PG-A-1-a-"],
		["700","PG-A-1-a-"],
		["701","PG-A-1-a-"],
		["702","PG-A-1-a-"],
		["704","PG-A-1-a-"],
		["705","PG-A-1-a-"],
		["706","PG-A-1-a-"],
		["709","PG-A-1-a-"],
		["71","PG-A-2--"],
		["7930","PG-A-2--"],
		["6930","PG-A-2--"],
		["73","PG-A-3--"],
		["600","PG-A-4-a-"],
		["601","PG-A-4-a-"],
		["602","PG-A-4-a-"],
		["606","PG-A-4-a-"],
		["607","PG-A-4-a-"],
		["608","PG-A-4-a-"],
		["609","PG-A-4-a-"],
		["61","PG-A-4-a-"],
		["6931","PG-A-4-a-"],
		["6932","PG-A-4-a-"],
		["6933","PG-A-4-a-"],
		["7931","PG-A-4-a-"],
		["7933","PG-A-4-a-"],
		["7932","PG-A-4-a-"],
		["75","PG-A-5-a-"],
		["740","PG-A-5-a-"],
		["747","PG-A-5-a-"],
		["64","PG-A-6-a-"],
		["634","PG-A-7-a-"],
		["62","PG-A-7-a-"],
		["636","PG-A-7-a-"],
		["631","PG-A-7-a-"],
		["7954","PG-A-7-a-"],
		["794","PG-A-7-a-"],
		["695","PG-A-7-a-"],
		["694","PG-A-7-a-"],
		["65","PG-A-7-a-"],
		["639","PG-A-7-a-"],
		["68","PG-A-8--"],
		["746","PG-A-9--"]
	];

	util.createProgressDialog(util.translate("scripts", "Actualizando códigos de balance abreviado"), datos.length);

	datos.sort();

	for (i = datos.length - 1; i >= 0; i--) {

		util.setProgress(datos.length - i);

		codCuenta = datos[i][0];

		curCbl.select("codcuenta = '" + codCuenta + "'");
		if (curCbl.first()) {
			continue;
		}
		else {
			curCbl.setModeAccess(curCbl.Insert);
			curCbl.refreshBuffer();
			curCbl.setValueBuffer("codcuenta", codCuenta);
			curCbl.setValueBuffer("codbalance", datos[i][1]);
			curCbl.commitBuffer();
		}


	}

	util.destroyProgressDialog();


	// Descripciones de balance abreviado
	var datos = [
		["A-B--III-1", "1. Clientes por ventas y prestaciones de servicios"],
		["A-B--III-2", "2. Accionistas (socios) por desembolsos exigidos"],
		["A-B--III-3", "3. Otros deudores"],
		["P-A-1-I-1", "1. Capital escriturado"],
		["P-A-1-I-2", "2. (Capital no exigido)"],
		["P-B--II-1", "1. Deudas con entidades de crédito"],
		["P-B--II-2", "2. Acreedores por arrendamiento financiero"],
		["P-B--II-3", "3. Otras deudas a largo plazo"],
		["P-C--III-1", "1. Deudas con entidades de crédito"],
		["P-C--III-2", "2. Acreedores por arrendamiento financiero"],
		["P-C--III-3", "3. Otras deudas a corto plazo"],
		["P-C--V-1", "1. Proveedores"],
		["P-C--V-2", "2. Otros acreedores"],
	];

	util.createProgressDialog(util.translate("scripts", "Actualizando nombres de códigos de balance abreviado"), datos.length);

	curCbl = new FLSqlCursor("co_codbalances08");
	curCbl.setActivatedCheckIntegrity(false);

	for (i = 0; i < datos.length; i++) {

		util.setProgress(i);

		curCbl.select("codbalance = '" + datos[i][0] + "'");
		if (!curCbl.first())
			continue;
		else {
			curCbl.setModeAccess(curCbl.Edit);
			curCbl.refreshBuffer();
			curCbl.setValueBuffer("descripcion4ba", datos[i][1]);
			curCbl.commitBuffer();
		}

	}

	util.destroyProgressDialog();



	return;
	/************* ASIENTO DE PRUEBAS */

	util.sqlDelete("co_partidas", "idasiento = 19");
	var curP:FLSqlCursor = new FLSqlCursor("co_partidas");
	var curS:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	curS.select("codejercicio = '0002'");
	haber = 0;
	paso = 0;

	util.createProgressDialog(util.translate("scripts", "Creando asiento de pruebas"), curS.size());

	while(curS.next()) {

		util.setProgress(paso++);
		haber += parseFloat(curS.valueBuffer("codcuenta"));

		curP.setModeAccess(curP.Insert);
		curP.refreshBuffer();

		curP.setValueBuffer("idasiento", 19);
		curP.setValueBuffer("idsubcuenta", curS.valueBuffer("idsubcuenta"));
		curP.setValueBuffer("codsubcuenta", curS.valueBuffer("codsubcuenta"));
		curP.setValueBuffer("debe", curS.valueBuffer("codcuenta"));
		curP.setValueBuffer("haber", 0);
		curP.setValueBuffer("tasaconv", 1);
		curP.setValueBuffer("debeme", 0);
		curP.setValueBuffer("haberme", 0);
		curP.setValueBuffer("baseimponible", 0);
		curP.setValueBuffer("iva", 0);
		curP.setValueBuffer("recargo", 0);
		curP.commitBuffer();
	}

	curP.setModeAccess(curP.Insert);
	curP.refreshBuffer();

	curP.setValueBuffer("idasiento", 19);
	curP.setValueBuffer("idsubcuenta", curS.valueBuffer("idsubcuenta"));
	curP.setValueBuffer("codsubcuenta", curS.valueBuffer("codsubcuenta"));
	curP.setValueBuffer("debe", 0);
	curP.setValueBuffer("haber", haber);
	curP.setValueBuffer("tasaconv", 1);
	curP.setValueBuffer("debeme", 0);
	curP.setValueBuffer("haberme", 0);
	curP.setValueBuffer("baseimponible", 0);
	curP.setValueBuffer("iva", 0);
	curP.setValueBuffer("recargo", 0);
	curP.commitBuffer();

	util.destroyProgressDialog();
}


/** Se establecen los códigos de cuenta especial en las cuentas que lo requieren del nuevo ejercicio
*/
function pgc2008_actualizarCuentasEspeciales(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor = new FLSqlCursor("co_cuentas");

	this.iface.completarTiposEspeciales();
	var datos:Array = this.iface.datosCuentasEspeciales();

	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas especiales"), datos.length);

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		with(curCbl) {

			codCuenta08 = util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + datos[i][0] + "'");

			select("codcuenta = '" + codCuenta08 + "' and codejercicio = '" + codEjercicio + "'");
			if (!first())
				continue;

			setModeAccess(curCbl.Edit);
			refreshBuffer();
			setValueBuffer("idcuentaesp", datos[i][1]);
			commitBuffer();
		}
	}

	util.destroyProgressDialog();
}




/** \D Se crean los epígrafes y cuentas
\end */
function pgc2008_generarCuadroCuentas(codEjercicio:String)
{
	this.iface.generarGrupos(codEjercicio);
	this.iface.generarSubgrupos(codEjercicio);
	this.iface.generarCuentas(codEjercicio);
}

function pgc2008_generarGrupos(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;

	// GRUPOS
	var datos:Array = this.iface.datosGrupos();

	curCbl = new FLSqlCursor("co_gruposepigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Creando grupos 2008"), datos.length);

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codgrupo", datos[i][0]);
			setValueBuffer("descripcion", datos[i][1]);
			setValueBuffer("codejercicio", codEjercicio);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}

function pgc2008_generarSubgrupos(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;

	// SUBGRUPOS (antes Epígrafes)
	var datos:Array = this.iface.datosSubgrupos();
	curCbl = new FLSqlCursor("co_epigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Creando epigrafes 2008"), datos.length);

	for (i = 0; i < datos.length; i++) {

		idGrupo = util.sqlSelect("co_gruposepigrafes", "idgrupo", "codgrupo = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");

		util.setProgress(i);
		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codepigrafe", datos[i][0]);
			setValueBuffer("descripcion", datos[i][1]);
			setValueBuffer("idgrupo", idGrupo);
			setValueBuffer("codejercicio", codEjercicio);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}

function pgc2008_generarCuentas(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;

	// CUENTAS
	var datos:Array = this.iface.datosCuentas();
	curCbl = new FLSqlCursor("co_cuentas");
	curCbl.setActivatedCheckIntegrity(false);

	util.createProgressDialog(util.translate("scripts", "Creando cuentas 2008"), datos.length);

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);

		idEpigrafe = util.sqlSelect("co_epigrafes", "idepigrafe", "codepigrafe = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");

		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codcuenta", datos[i][0]);
			setValueBuffer("descripcion", datos[i][1]);
			setValueBuffer("idepigrafe", idEpigrafe);
			setValueBuffer("codepigrafe", datos[i][2]);
			setValueBuffer("codejercicio", codEjercicio);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}

/** Genera las subcuentas necesarias a partir de las cuentas ya existentes
*/
function pgc2008_generarSubcuentas(codEjercicio:String, longSubcuenta:Number)
{
	var util:FLUtil = new FLUtil();
	var curCuenta:FLSqlCursor = new FLSqlCursor("co_cuentas");
	var curSubcuenta:FLSqlCursor = new FLSqlCursor("co_subcuentas");
	curCuenta.setActivatedCheckIntegrity(false);
	curSubcuenta.setActivatedCheckIntegrity(false);

	var codSubcuenta:String;
	var numCeros:Number;
	var paso:Number = 0;

	var codDivisa =	util.sqlSelect("empresa", "coddivisa", "1 = 1");

	curCuenta.select("codejercicio = '" + codEjercicio + "'");
	util.createProgressDialog(util.translate("scripts", "Generando subcuentas adicionales"), curCuenta.size());


	while (curCuenta.next()) {

		util.setProgress(paso++);

		curCuenta.setModeAccess(curCuenta.Browse);
		curCuenta.refreshBuffer();
		codSubcuenta = curCuenta.valueBuffer("codcuenta");

		numCeros = longSubcuenta - codSubcuenta.toString().length;
		for (var i = 0; i < numCeros; i++)
			codSubcuenta += "0";

		// Existe ya la subcuenta?
		curSubcuenta.select("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
		if (curSubcuenta.first()) {

			// Corresponde a la cuenta o sólo coincide el código (ejemplo: cuentas 133 y 1330)
			if (!util.sqlSelect("co_subcuentas", "idcuenta", "idcuenta = " + curCuenta.valueBuffer("idcuenta") + " AND codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'")) {
				codSubcuenta = codSubcuenta.left(longSubcuenta - 1) + "1"; // Código -> 1330000001
				// Nueva comprobación
				curSubcuenta.select("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
				if (curSubcuenta.first())
					continue;
			}

			else
				continue;
		}

		with(curSubcuenta) {
			setModeAccess(curSubcuenta.Insert);
			refreshBuffer();
			setValueBuffer("codsubcuenta", codSubcuenta);
			setValueBuffer("descripcion", curCuenta.valueBuffer("descripcion"));
			setValueBuffer("codejercicio", codEjercicio);
			setValueBuffer("idcuenta", curCuenta.valueBuffer("idcuenta"));
			setValueBuffer("codcuenta", curCuenta.valueBuffer("codcuenta"));
			setValueBuffer("coddivisa", codDivisa);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}

/** Se rellena la tabla de correspondencias entre cuentas de los planes 90-08
Sólo si no existen
*/
function pgc2008_generarCorrespondenciasCC(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;

	if (util.sqlSelect("co_correspondenciascc", "codigo90", ""))
		return;

	var curCbl:FLSqlCursor;

	var datos:Array = this.iface.datosCorrespondencias();
	curCbl = new FLSqlCursor("co_correspondenciascc");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Creando correspondencias entre planes 1990-2008"), datos.length);

	var datosCuenta:Array;

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);

		datosCuenta = flfactppal.iface.pub_ejecutarQry("co_cuentas", "descripcion,idepigrafe", "codcuenta = '" + datos[i][1] + "' AND codejercicio = '" + codEjercicio + "'");

		with(curCbl) {
			setModeAccess(curCbl.Insert);
			refreshBuffer();
			setValueBuffer("codigo90", datos[i][0]);
			setValueBuffer("codigo08", datos[i][1]);
			commitBuffer();
		}
	}
	util.destroyProgressDialog();
}


function pgc2008_convertirCodSubcuenta(codEjercicio:String, codSubcuenta90:String):String
{
	var util:FLUtil = new FLUtil();

	var codCuenta90:String = util.sqlSelect("co_subcuentas", "codcuenta", "codsubcuenta = '" + codSubcuenta90 + "' and codejercicio = '" + codEjercicio + "'");
	var rightSubcuenta90:String = codSubcuenta90.right(codSubcuenta90.length - codCuenta90.length);
	var codCuenta08:String = util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + codCuenta90 + "'");
	if (!codCuenta08)
		return false;

	var rightSubcuenta08:String = rightSubcuenta90.right(codSubcuenta90.length - codCuenta08.length);

	// se completa con ceros
	while (rightSubcuenta08.length < codSubcuenta90.length - codCuenta08.length)
		rightSubcuenta08 = "0" + rightSubcuenta08;

	return codCuenta08 + rightSubcuenta08;
}

function pgc2008_convertirCodCuenta(codCuenta90:String):String
{
	var util:FLUtil = new FLUtil();
	return util.sqlSelect("co_correspondenciascc", "codigo08", "codigo90 = '" + codCuenta90 + "'");
}



function pgc2008_datosGrupos():Array
{
	var datos:Array = [
		["1","Financiación básica"],
		["2","Activo no corriente"],
		["3","Existencias"],
		["4","Acreedores y deudores por operaciones comerciales"],
		["5","Cuentas financieras"],
		["6","Compras y gastos"],
		["7","Ventas e ingresos"],
		["8","Gastos imputados al patrimonio neto"],
		["9","Ingresos imputados al patrimonio neto"]
	];

	return datos;
}

function pgc2008_datosSubgrupos():Array
{
	var datos:Array = [
		["10","Capital","1"],
		["11","Reservas y otros instrumentos de patrimonio","1"],
		["12","Resultados pendientes de aplicacion","1"],
		["13","Subvenciones, donaciones y ajustes por cambios de valor","1"],
		["14","Provisiones","1"],
		["15","Deudas a largo plazo con caracteristicas especiales","1"],
		["16","Deudas a largo plazo con partes vinculadas","1"],
		["17","Deudas a largo plazo por prestamos recibidos, emprestitos y otros conceptos","1"],
		["18","Pasivos por fianzas, garantias y otros conceptos a largo plazo","1"],
		["19","Situaciones transitorias de financiacion","1"],
		["20","Inmovilizaciones intangibles","2"],
		["21","Inmovilizaciones materiales","2"],
		["22","Inversiones inmobiliarias","2"],
		["23","Inmovilizaciones materiales en curso","2"],
		["24","Inversiones financieras a largo plazo en partes vinculadas","2"],
		["25","Otras inversiones financieras a largo plazo","2"],
		["26","Fianzas y depositos constituidos a largo plazo","2"],
		["28","Amortizacion acumulada del inmovilizado","2"],
		["29","Deterioro de valor de activos no corrientes","2"],
		["30","Comerciales","3"],
		["31","Materias primas","3"],
		["32","Otros aprovisionamientos","3"],
		["33","Productos en curso","3"],
		["34","Productos semiterminados","3"],
		["35","Productos terminados","3"],
		["36","Subproductos, residuos y materiales recuperados","3"],
		["39","Deterioro de valor de las existencias","3"],
		["40","Proveedores","4"],
		["41","Acreedores varios","4"],
		["43","Clientes","4"],
		["44","Deudores varios","4"],
		["46","Personal","4"],
		["47","Administraciones publicas","4"],
		["48","Ajustes por periodificacion","4"],
		["49","Deterioro de valor de creditos comerciales y provisiones a corto plazo","4"],
		["50","Emprestitos, deudas con caracteristicas especiales y otras emisiones analogas a corto plazo","5"],
		["51","Deudas a corto plazo con partes vinculadas","5"],
		["52","Deudas a corto plazo por prestamos recibidos y otros conceptos","5"],
		["53","Inversiones financieras a corto plazo en partes vinculadas","5"],
		["54","Otras inversiones financieras a corto plazo","5"],
		["55","Otras cuentas no bancarias","5"],
		["56","Fianzas y depósitos recibidos y constituidos a corto plazo y ajustes por periodificación","5"],
		["57","Tesorería","5"],
		["58","Activos no corrientes mantenidos para la venta y activos y pasivos asociados","5"],
		["59","Deterioro del valor de inversiones financieras a corto plazo y de activos no corrientes mantenidos para la venta","5"],
		["60","Compras","6"],
		["61","Variación de existencias","6"],
		["62","Servicios exteriores","6"],
		["63","Tributos","6"],
		["64","Gastos de personal","6"],
		["65","Otros gastos de gestión","6"],
		["66","Gastos financieros","6"],
		["67","Pérdidas procedentes de activos no corrientes y gastos excepcionales","6"],
		["68","Dotaciones para amortizaciones","6"],
		["69","Pérdidas por deterioro y otras dotaciones","6"],
		["70","Ventas de mercaderías, de producción propia, de servicios, etc","7"],
		["71","Variación de existencias","7"],
		["73","Trabajos realizados para la empresa","7"],
		["74","Subvenciones, donaciones y legados","7"],
		["75","Otros ingresos de gestión","7"],
		["76","Ingresos financieros","7"],
		["77","Beneficios procedentes de activos no corrientes e ingresos excepcionales","7"],
		["79","Excesos y aplicaciones de provisiones y de pérdidas por deterioro","7"],
		["80","Gastos financieros por valoración de activos y pasivos","8"],
		["81","Gastos en operaciones de cobertura","8"],
		["82","Gastos por diferencias de conversión","8"],
		["83","Impuesto sobre beneficios","8"],
		["84","Transferencias de subvenciones, donaciones y legados","8"],
		["85","Gastos por pérdidas actuariales y ajustes en los activos por retribuciones a largo plazo de prestación definida","8"],
		["86","Gastos por activos no corrientes en venta","8"],
		["89","Gastos de participaciones en empresas del grupo o asociadas con ajustes valorativos positivos previos","8"],
		["90","Ingresos financieros por valoración de activos y pasivos","9"],
		["91","Ingresos en operaciones de cobertura","9"],
		["92","Ingresos por diferencias de conversion","9"],
		["94","Ingresos por subvenciones, donaciones y legados","9"],
		["95","Ingresos por ganancias actuariales y ajustes en los activos por retribuciones a largo plazo de prestacion definida","9"],
		["96","Ingresos por activos no corrientes en venta","9"],
		["99","Ingresos de participaciones en empresas del grupo o asociadas con ajustes valorativos negativos previos","9"]
	];

	return datos;
}



function pgc2008_datosCuentas():Array
{
	var datos:Array = [
		["100","Capital social","10"],
		["101","Fondo social","10"],
		["102","Capital","10"],
		["1030","Socios por desembolsos no exigidos, capital social","10"],
		["1034","Socios por desembolsos no exigidos, capital pendiente de inscripción","10"],
		["1040","Socios por aportaciones no dinerarias pendientes, capital social","10"],
		["1044","Socios por aportaciones no dinerarias pendientes, capital pendiente de inscripción","10"],
		["108","Acciones o participaciones propias en situaciones especiales","10"],
		["109","Acciones o participaciones propias para reducción de capital","10"],
		["110","Prima de emisión o asunción","11"],
		["1110","Patrimonio neto por emisión de instrumentos financieros compuestos","11"],
		["1111","Resto de instrumentos de patrimonio neto","11"],
		["112","Reserva legal","11"],
		["113","Reservas voluntarias","11"],
		["1140","Reservas para acciones o participaciones de la sociedad dominante","11"],
		["1141","Reservas estatutarias","11"],
		["1142","Reserva por capital amortizado","11"],
		["1143","Reserva por fondo de comercio","11"],
		["1144","Reservas por acciones propias aceptadas en garantía","11"],
		["115","Reservas por pérdidas y ganancias actuariales y otros ajustes","11"],
		["118","Aportaciones de socios o propietarios","11"],
		["119","Diferencias por ajuste del capital a euros","11"],
		["120","Remanente","12"],
		["121","Resultados negativos de ejercicios anteriores","12"],
		["129","Resultado del ejercicio","12"],
		["130","Subvenciones oficiales de capital","13"],
		["131","Donaciones y legados de capital","13"],
		["132","Otras subvenciones, donaciones y legados","13"],
		["133","Ajustes por valoración en activos financieros disponibles para la venta","13"],
		["1340","Cobertura de flujos de efectivo","13"],
		["1341","Cobertura de una inversión neta en un negocio en el extranjero","13"],
		["135","Diferencias de conversión","13"],
		["136","Ajustes por valoración en activos no corrientes y grupos enajenables de elementos, mantenidos para la venta","13"],
		["1370","Ingresos fiscales por diferencias permanentes a distribuir en varios ejercicios","13"],
		["1371","Ingresos fiscales por deducciones y bonificaciones a distribuir en varios ejercicios","13"],
		["140","Provisión por retribuciones a largo plazo al personal","14"],
		["141","Provisión para impuestos","14"],
		["142","Provisión para otras responsabilidades","14"],
		["143","Provisión por desmantelamiento, retiro o rehabilitación del inmovilizado","14"],
		["145","Provisión para actuaciones medioambientales","14"],
		["146","Provisión para reestructuraciones","14"],
		["147","Provisión por transacciones con pagos basados en instrumentos de patrimonio","14"],
		["150","Acciones o participaciones a largo plazo consideradas como pasivos financieros","15"],
		["1533","Desembolsos no exigidos, empresas del grupo","15"],
		["1534","Desembolsos no exigidos, empresas asociadas","15"],
		["1535","Desembolsos no exigidos, otras partes vinculadas","15"],
		["1536","Otros desembolsos no exigidos","15"],
		["1543","Aportaciones no dinerarias pendientes, empresas del grupo","15"],
		["1544","Aportaciones no dinerarias pendientes, empresas asociadas","15"],
		["1545","Aportaciones no dinerarias pendientes, otras partes vinculadas","15"],
		["1546","Otras aportaciones no dinerarias pendientes","15"],
		["1603","Deudas a largo plazo con entidades de crédito, empresas del grupo","16"],
		["1604","Deudas a largo plazo con entidades de crédito, empresas asociadas","16"],
		["1605","Deudas a largo plazo con otras entidades de crédito vinculadas","16"],
		["1613","Proveedores de inmovilizado a largo plazo, empresas del grupo","16"],
		["1614","Proveedores de inmovilizado a largo plazo, empresas asociadas","16"],
		["1615","Proveedores de inmovilizado a largo plazo, otras partes vinculadas","16"],
		["1623","Acreedores por arrendamiento financiero a largo plazo, empresas de grupo","16"],
		["1624","Acreedores por arrendamiento financiero a largo plazo, empresas asociadas","16"],
		["1625","Acreedores por arrendamiento financiero a largo plazo, otras partes vinculadas.","16"],
		["1633","Otras deudas a largo plazo, empresas del grupo","16"],
		["1634","Otras deudas a largo plazo, empresas asociadas","16"],
		["1635","Otras deudas a largo plazo, con otras partes vinculadas","16"],
		["170","Deudas a largo plazo con entidades de crédito","17"],
		["171","Deudas a largo plazo","17"],
		["172","Deudas a largo plazo transformables en subvenciones, donaciones y legados","17"],
		["173","Proveedores de inmovilizado a largo plazo","17"],
		["174","Acreedores por arrendamiento financiero a largo plazo","17"],
		["175","Efectos a pagar a largo plazo","17"],
		["1765","Pasivos por derivados financieros a largo plazo, cartera de negociación","17"],
		["1768","Pasivos por derivados financieros a largo plazo, instrumentos de cobertura","17"],
		["177","Obligaciones y bonos","17"],
		["178","Obligaciones y bonos convertibles","17"],
		["179","Deudas representadas en otros valores negociables","17"],
		["180","Fianzas recibidas a largo plazo","18"],
		["181","Anticipos recibidos por ventas o prestaciones de servicios a largo plazo","18"],
		["185","Depósitos recibidos a largo plazo","18"],
		["189","Garantías financieras a largo plazo","18"],
		["190","Acciones o participaciones emitidas","19"],
		["192","Suscriptores de acciones","19"],
		["194","Capital emitido pendiente de inscripción","19"],
		["195","Acciones o participaciones emitidas consideradas como pasivos financieros","19"],
		["197","Suscriptores de acciones consideradas como pasivos financieros","19"],
		["199","Acciones o participaciones emitidas consideradas como pasivos financieros pendientes de inscripción.","19"],
		["200","Investigación","20"],
		["201","Desarrollo","20"],
		["202","Concesiones administrativas","20"],
		["203","Propiedad industrial","20"],
		["204","Fondo de comercio","20"],
		["205","Derechos de traspaso","20"],
		["206","Aplicaciones informáticas","20"],
		["209","Anticipos para inmovilizaciones intangibles","20"],
		["210","Terrenos y bienes naturales","21"],
		["211","Construcciones","21"],
		["212","Instalaciones técnicas","21"],
		["213","Maquinaria","21"],
		["214","Utillaje","21"],
		["215","Otras instalaciones","21"],
		["216","Mobiliario","21"],
		["217","Equipos para procesos de información","21"],
		["218","Elementos de transporte","21"],
		["219","Otro inmovilizado material","21"],
		["220","Inversiones en terrenos y bienes naturales","22"],
		["221","Inversiones en construcciones","22"],
		["230","Adaptación de terrenos y bienes naturales","23"],
		["231","Construcciones en curso","23"],
		["232","Instalaciones técnicas en montaje","23"],
		["233","Maquinaria en montaje","23"],
		["237","Equipos para procesos de información en montaje","23"],
		["239","Anticipos para inmovilizaciones materiales","23"],
		["2403","Participaciones a largo plazo en empresas del grupo","24"],
		["2404","Participaciones a largo plazo en empresas asociadas","24"],
		["2405","Participaciones a largo plazo en otras partes vinculadas","24"],
		["2413","Valores representativos de deuda a largo plazo de empresas del grupo","24"],
		["2414","Valores representativos de deuda a largo plazo de empresas asociadas","24"],
		["2415","Valores representativos de deuda a largo plazo de otras partes vinculadas","24"],
		["2423","Créditos a largo plazo a empresas del grupo","24"],
		["2424","Créditos a largo plazo a empresas asociadas","24"],
		["2425","Créditos a largo plazo a otras partes vinculadas","24"],
		["2493","Desembolsos pendientes sobre participaciones a largo plazo en empresas del grupo.","24"],
		["2494","Desembolsos pendientes sobre participaciones a largo plazo en empresas asociadas.","24"],
		["2495","Desembolsos pendientes sobre participaciones a largo plazo en otras partes vinculadas","24"],
		["250","Inversiones financieras a largo plazo en instrumentos de patrimonio","25"],
		["251","Valores representativos de deuda a largo plazo","25"],
		["252","Créditos a largo plazo","25"],
		["253","Créditos a largo plazo por enajenación de inmovilizado","25"],
		["254","Créditos a largo plazo al personal","25"],
		["2550","Activos por derivados financieros a largo plazo, cartera de negociación","25"],
		["2553","Activos por derivados financieros a largo plazo, instrumentos de cobertura","25"],
		["257","Derechos de reembolso derivados de contratos de seguro relativos a retribuciones a largo plazo al personal","25"],
		["258","Imposiciones a largo plazo","25"],
		["259","Desembolsos pendientes sobre participaciones en el patrimonio neto a largo plazo","25"],
		["260","Fianzas constituidas a largo plazo","26"],
		["265","Depósitos constituidos a largo plazo","26"],
		["2800","Amortización acumulada de investigación","28"],
		["2801","Amortización acumulada de desarrollo","28"],
		["2802","Amortización acumulada de concesiones administrativas","28"],
		["2803","Amortización acumulada de propiedad industrial","28"],
		["2805","Amortización acumulada de derechos de traspaso","28"],
		["2806","Amortización acumulada de aplicaciones informáticas","28"],
		["2811","Amortización acumulada de construcciones","28"],
		["2812","Amortización acumulada de instalaciones técnicas","28"],
		["2813","Amortización acumulada de maquinaria","28"],
		["2814","Amortización acumulada de utillaje","28"],
		["2815","Amortización acumulada de otras instalaciones","28"],
		["2816","Amortización acumulada de mobiliario","28"],
		["2817","Amortización acumulada de equipos para procesos de información","28"],
		["2818","Amortización acumulada de elementos de transporte","28"],
		["2819","Amortización acumulada de otro inmovilizado material","28"],
		["282","Amortización acumulada de las inversiones inmobiliarias","28"],
		["2900","Deterioro de valor de investigación","29"],
		["2901","Deterioro del valor de desarrollo","29"],
		["2902","Deterioro de valor de concesiones administrativas","29"],
		["2903","Deterioro de valor de propiedad industrial","29"],
		["2905","Deterioro de valor de derechos de traspaso","29"],
		["2906","Deterioro de valor de aplicaciones informáticas","29"],
		["2910","Deterioro de valor de terrenos y bienes naturales","29"],
		["2911","Deterioro de valor de construcciones","29"],
		["2912","Deterioro de valor de instalaciones técnicas","29"],
		["2913","Deterioro de valor de maquinaria","29"],
		["2914","Deterioro de valor de utillaje","29"],
		["2915","Deterioro de valor de otras instalaciones","29"],
		["2916","Deterioro de valor de mobiliario","29"],
		["2917","Deterioro de valor de equipos para procesos de información","29"],
		["2918","Deterioro de valor de elementos de transporte","29"],
		["2919","Deterioro de valor de otro inmovilizado material","29"],
		["2920","Deterioro de valor de los terrenos y bienes naturales","29"],
		["2921","Deterioro de valor de construcciones","29"],
		["2933","Deterioro de valor de participaciones a largo plazo en empresas del grupo","29"],
		["2934","Deterioro de valor de participaciones a largo plazo en empresas asociadas","29"],
		["2943","Deterioro de valor de valores representativos de deuda a largo plazo de empresas del grupo","29"],
		["2944","Deterioro de valor de valores representativos de deuda a largo plazo de empresas asociadas","29"],
		["2945","Deterioro de valor de valores representativos de deuda a largo plazo de otras partes vinculadas","29"],
		["2953","Deterioro de valor de créditos a largo plazo a empresas del grupo","29"],
		["2954","Deterioro de valor de créditos a largo plazo a empresas asociadas","29"],
		["2955","Deterioro de valor de créditos a largo plazo a otras partes vinculadas","29"],
		["297","Deterioro de valor de valores representativos de deuda a largo plazo","29"],
		["298","Deterioro de valor de créditos a largo plazo","29"],
		["300","Mercaderías a","30"],
		["301","Mercaderías b","30"],
		["310","Materias primas a","31"],
		["311","Materias primas b","31"],
		["320","Elementos y conjuntos incorporables","32"],
		["321","Combustibles","32"],
		["322","Repuestos","32"],
		["325","Materiales diversos","32"],
		["326","Embalajes","32"],
		["327","Envases","32"],
		["328","Material de oficina","32"],
		["330","Productos en curso a","33"],
		["331","Productos en curso b","33"],
		["340","Productos semiterminados a","34"],
		["341","Productos semiterminados b","34"],
		["350","Productos terminados a","35"],
		["351","Productos terminados b","35"],
		["360","Subproductos a","36"],
		["361","Subproductos b","36"],
		["365","Residuos a","36"],
		["366","Residuos b","36"],
		["368","Materiales recuperados a","36"],
		["369","Materiales recuperados b","36"],
		["390","Deterioro de valor de las mercaderías","39"],
		["391","Deterioro de valor de las materias primas","39"],
		["392","Deterioro de valor de otros aprovisionamientos","39"],
		["393","Deterioro de valor de los productos en curso","39"],
		["394","Deterioro de valor de los productos semiterminados","39"],
		["395","Deterioro de valor de los productos terminados","39"],
		["396","Deterioro de valor de los subproductos, residuos y materiales recuperados","39"],
		["400","Proveedores","40"],
		["4000","Proveedores (euros)","40"],
		["4004","Proveedores (moneda extranjera)","40"],
		["4009","Proveedores, facturas pendientes de recibir o de formalizar","40"],
		["401","Proveedores, efectos comerciales a pagar","40"],
		["4030","Proveedores, empresas del grupo (euros)","40"],
		["4031","Efectos comerciales a pagar, empresas del grupo","40"],
		["4034","Proveedores, empresas del grupo (moneda extranjera)","40"],
		["4036","Envases y embalajes a devolver a proveedores, empresas del grupo","40"],
		["4039","Proveedores, empresas del grupo, facturas pendientes de recibir o de formalizar","40"],
		["404","Proveedores, empresas asociadas","40"],
		["405","Proveedores, otras partes vinculadas","40"],
		["406","Envases y embalajes a devolver a proveedores","40"],
		["407","Anticipos a proveedores","40"],
		["410","Acreedores","41"],
		["4100","Acreedores por prestaciones de servicios (euros)","41"],
		["4104","Acreedores por prestaciones de servicios, (moneda extranjera)","41"],
		["4109","Acreedores por prestaciones de servicios, facturas pendientes de recibir o de formalizar","41"],
		["411","Acreedores, efectos comerciales a pagar","41"],
		["419","Acreedores por operaciones en común","41"],
		["430","Clientes","43"],
		["4300","Clientes (euros)","43"],
		["4304","Clientes (moneda extranjera)","43"],
		["4309","Clientes, facturas pendientes de formalizar","43"],
		["4310","Efectos comerciales en cartera","43"],
		["4311","Efectos comerciales descontados","43"],
		["4312","Efectos comerciales en gestión de cobro","43"],
		["4315","Efectos comerciales impagados","43"],
		["432","Clientes, operaciones de factoring","43"],
		["4330","Clientes empresas del grupo (euros)","43"],
		["4331","Efectos comerciales a cobrar, empresas del grupo","43"],
		["4332","Clientes empresas del grupo, operaciones de factoring","43"],
		["4334","Clientes empresas del grupo (moneda extranjera)","43"],
		["4336","Clientes empresas del grupo de dudoso cobro","43"],
		["4337","Envases y embalajes a devolver a clientes, empresas del grupo","43"],
		["4339","Clientes empresas del grupo, facturas pendientes de formalizar","43"],
		["434","Clientes, empresas asociadas","43"],
		["435","Clientes, otras partes vinculadas","43"],
		["436","Clientes de dudoso cobro","43"],
		["437","Envases y embalajes a devolver por clientes","43"],
		["438","Anticipos de clientes","43"],
		["4400","Deudores (euros)","44"],
		["4404","Deudores (moneda extranjera)","44"],
		["4409","Deudores, facturas pendientes de formalizar","44"],
		["4410","Deudores, efectos comerciales en cartera","44"],
		["4411","Deudores, efectos comerciales descontados","44"],
		["4412","Deudores, efectos comerciales en gestión de cobro","44"],
		["4415","Deudores, efectos comerciales impagados","44"],
		["446","Deudores de dudoso cobro","44"],
		["449","Deudores por operaciones en común","44"],
		["460","Anticipos de remuneraciones","46"],
		["465","Remuneraciones pendientes de pago","46"],
		["466","Remuneraciones mediante sistemas de aportación definida pendientes de pago","46"],
		["4700","Hacienda pública, deudora por iva","47"],
		["4708","Hacienda pública, deudora por subvenciones concedidas","47"],
		["4709","Hacienda pública, deudora por devolución de impuestos","47"],
		["471","Organismos de la seguridad social, deudores","47"],
		["472","Hacienda pública, iva soportado","47"],
		["473","Hacienda pública, retenciones y pagos a cuenta","47"],
		["4740","Activos por diferencias temporarias deducibles","47"],
		["4742","Derechos por deducciones y bonificaciones pendientes de aplicar","47"],
		["4745","Crédito por pérdidas a compensar del ejercicio","47"],
		["4750","Hacienda pública, acreedora por iva","47"],
		["4751","Hacienda pública, acreedora por retenciones practicadas","47"],
		["4752","Hacienda pública, acreedora por impuesto sobre sociedades","47"],
		["4758","Hacienda pública, acreedora por subvenciones a reintegrar","47"],
		["476","Organismos de la seguridad social, acreedores","47"],
		["477","Hacienda pública, iva repercutido","47"],
		["479","Pasivos por diferencias temporarias imponibles","47"],
		["480","Gastos anticipados","48"],
		["485","Ingresos anticipados","48"],
		["490","Deterioro de valor de créditos por operaciones comerciales","49"],
		["4933","Deterioro de valor de créditos por operaciones comerciales con empresas del grupo","49"],
		["4934","Deterioro de valor de créditos por operaciones comerciales con empresas asociadas","49"],
		["4935","Deterioro de valor de créditos por operaciones comerciales con otras partes vinculadas","49"],
		["4994","Provisión por contratos onerosos","49"],
		["4999","Provisión para otras operaciones comerciales","49"],
		["500","Obligaciones y bonos a corto plazo","50"],
		["501","Obligaciones y bonos convertibles a corto plazo","50"],
		["502","Acciones o participaciones a corto plazo consideradas como pasivos financieros","50"],
		["505","Deudas representadas en otros valores negociables a corto plazo","50"],
		["506","Intereses a corto plazo de empréstitos y otras emisiones análogas","50"],
		["507","Dividendos de acciones o participaciones consideradas como pasivos financieros","50"],
		["5090","Obligaciones y bonos amortizados","50"],
		["5091","Obligaciones y bonos convertibles amortizados","50"],
		["5095","Otros valores negociables amortizados","50"],
		["5103","Deudas a corto plazo con entidades de crédito, empresas del grupo","51"],
		["5104","Deudas a corto plazo con entidades de crédito, empresas asociadas","51"],
		["5105","Deudas a corto plazo con otras entidades de crédito vinculadas","51"],
		["5113","Proveedores de inmovilizado a corto plazo, empresas del grupo","51"],
		["5114","Proveedores de inmovilizado a corto plazo, empresas asociadas","51"],
		["5115","Proveedores de inmovilizado a corto plazo, otras partes vinculadas","51"],
		["5123","Acreedores por arrendamiento financiero a corto plazo, empresas del grupo","51"],
		["5124","Acreedores por arrendamiento financiero a corto plazo, empresas asociadas","51"],
		["5125","Acreedores por arrendamiento financiero a corto plazo, otras partes vinculadas","51"],
		["5133","Otras deudas a corto plazo con empresas del grupo","51"],
		["5134","Otras deudas a corto plazo con empresas asociadas","51"],
		["5135","Otras deudas a corto plazo con otras partes vinculadas","51"],
		["5143","Intereses a corto plazo de deudas, empresas del grupo","51"],
		["5144","Intereses a corto plazo de deudas, empresas asociadas","51"],
		["5145","Intereses a corto plazo de deudas, otras partes vinculadas","51"],
		["5200","Préstamos a corto plazo de entidades de crédito","52"],
		["5201","Deudas a corto plazo por crédito dispuesto","52"],
		["5208","Deudas por efectos descontados","52"],
		["5209","Deudas por operaciones de factoring","52"],
		["521","Deudas a corto plazo","52"],
		["522","Deudas a corto plazo transformables en subvenciones, donaciones y legados","52"],
		["523","Proveedores de inmovilizado a corto plazo","52"],
		["524","Acreedores por arrendamiento financiero a corto plazo","52"],
		["525","Efectos a pagar a corto plazo","52"],
		["526","Dividendo activo a pagar","52"],
		["527","Intereses a corto plazo de deudas con entidades de crédito","52"],
		["528","Intereses a corto plazo de deudas","52"],
		["5290","Provisión a corto plazo por retribuciones al personal","52"],
		["5291","Provisión a corto plazo para impuestos","52"],
		["5292","Provisión a corto plazo para otras responsabilidades","52"],
		["5293","Provisión a corto plazo por desmantelamiento, retiro o rehabilitación del inmovilizado","52"],
		["5295","Provisión a corto plazo para actuaciones medioambientales","52"],
		["5296","Provisión a corto plazo para reestructuraciones","52"],
		["5297","Provisión a corto plazo por transacciones con pagos basados en instrumentos de patrimonio","52"],
		["5303","Participaciones a corto plazo, en empresas del grupo","53"],
		["5304","Participaciones a corto plazo, en empresas asociadas","53"],
		["5305","Participaciones a corto plazo, en otras partes vinculadas","53"],
		["5313","Valores representativos de deuda a corto plazo de empresas del grupo","53"],
		["5314","Valores representativos de deuda a corto plazo de empresas asociadas","53"],
		["5315","Valores representativos de deuda a corto plazo de otras partes vinculadas","53"],
		["5323","Créditos a corto plazo a empresas del grupo","53"],
		["5324","Créditos a corto plazo a empresas asociadas","53"],
		["5325","Créditos a corto plazo a otras partes vinculadas","53"],
		["5333","Intereses a corto plazo de valores representativos de deuda de empresas del grupo","53"],
		["5334","Intereses a corto plazo de valores representativos de deuda de empresas asociadas","53"],
		["5335","Intereses a corto plazo de valores representativos de deuda de otras partes vinculadas","53"],
		["5343","Intereses a corto plazo de créditos a empresas del grupo","53"],
		["5344","Intereses a corto plazo de créditos a empresas asociadas","53"],
		["5345","Intereses a corto plazo de créditos a otras partes vinculadas","53"],
		["5353","Dividendo a cobrar de empresas de grupo","53"],
		["5354","Dividendo a cobrar de empresas asociadas","53"],
		["5355","Dividendo a cobrar de otras partes vinculadas","53"],
		["5393","Desembolsos pendientes sobre participaciones a corto plazo en empresas del grupo.","53"],
		["5394","Desembolsos pendientes sobre participaciones a corto plazo en empresas asociadas.","53"],
		["5395","Desembolsos pendientes sobre participaciones a corto plazo en otras partes vinculadas","53"],
		["540","Inversiones financieras a corto plazo en instrumentos de patrimonio","54"],
		["541","Valores representativos de deuda a corto plazo","54"],
		["542","Créditos a corto plazo","54"],
		["543","Créditos a corto plazo por enajenación de inmovilizado","54"],
		["544","Créditos a corto plazo al personal","54"],
		["545","Dividendo a cobrar","54"],
		["546","Intereses a corto plazo de valores representativos de deudas","54"],
		["547","Intereses a corto plazo de créditos","54"],
		["548","Imposiciones a corto plazo","54"],
		["549","Desembolsos pendientes sobre participaciones en el patrimonio neto a corto plazo","54"],
		["550","Titular de la explotación","55"],
		["551","Cuenta corriente con socios y administradores","55"],
		["5523","Cuenta corriente con empresas del grupo","55"],
		["5524","Cuenta corriente con empresas asociadas","55"],
		["5525","Cuenta corriente con otras partes vinculadas","55"],
		["5530","Socios de sociedad disuelta","55"],
		["5531","Socios, cuenta de fusión","55"],
		["5532","Socios de sociedad escindida","55"],
		["5533","Socios, cuenta de escisión","55"],
		["554","Cuenta corriente con uniones temporales de empresas y comunidades de bienes","55"],
		["555","Partidas pendientes de aplicación","55"],
		["5563","Desembolsos exigidos sobre participaciones, empresas del grupo","55"],
		["5564","Desembolsos exigidos sobre participaciones, empresas asociadas","55"],
		["5565","Desembolsos exigidos sobre participaciones, otras partes vinculadas","55"],
		["5566","Desembolsos exigidos sobre participaciones de otras empresas","55"],
		["557","Dividendo activo a cuenta","55"],
		["5580","Socios por desembolsos exigidos sobre acciones o participaciones ordinarias","55"],
		["5585","Socios por desembolsos exigidos sobre acciones o participaciones consideradas como pasivos financieros","55"],
		["5590","Activos por derivados financieros a corto plazo, cartera de negociación","55"],
		["5593","Activos por derivados financieros a corto plazo, instrumentos de cobertura","55"],
		["5595","Pasivos por derivados financieros a corto plazo, cartera de negociación","55"],
		["5598","Pasivos por derivados financieros a corto plazo, instrumentos de cobertura","55"],
		["560","Fianzas recibidas a corto plazo","56"],
		["561","Depósitos recibidos a corto plazo","56"],
		["565","Fianzas constituidas a corto plazo","56"],
		["566","Depósitos constituidos a corto plazo","56"],
		["567","Intereses pagados por anticipado","56"],
		["568","Intereses cobrados por anticipado","56"],
		["569","Garantías financieras a corto plazo","56"],
		["570","Caja, euros","57"],
		["571","Caja, moneda extranjera","57"],
		["572","Bancos e instituciones de crédito c/c vista, euros","57"],
		["573","Bancos e instituciones de crédito c/c vista, moneda extranjera","57"],
		["574","Bancos e instituciones de crédito, cuentas de ahorro, euros","57"],
		["575","Bancos e instituciones de crédito, cuentas de ahorro, moneda extranjera","57"],
		["576","Inversiones a corto plazo de gran liquidez","57"],
		["580","Inmovilizado","58"],
		["581","Inversiones con personas y entidades vinculadas","58"],
		["582","Inversiones financieras","58"],
		["583","Existencias, deudores comerciales y otras cuentas a cobrar","58"],
		["584","Otros activos","58"],
		["585","Provisiones","58"],
		["586","Deudas con características especiales","58"],
		["587","Deudas con personas y entidades vinculadas","58"],
		["588","Acreedores comerciales y otras cuentas a pagar","58"],
		["589","Otros pasivos","58"],
		["5933","Deterioro de valor de participaciones a corto plazo en empresas del grupo","59"],
		["5934","Deterioro de valor de participaciones a corto plazo en empresas asociadas","59"],
		["5943","Deterioro de valor de valores representativos de deuda a corto plazo de empresas del grupo","59"],
		["5944","Deterioro de valor de valores representativos de deuda a corto plazo de empresas asociadas","59"],
		["5945","Deterioro de valor de valores representativos de deuda a corto plazo de otras partes vinculadas","59"],
		["5953","Deterioro de valor de créditos a corto plazo a empresas del grupo","59"],
		["5954","Deterioro de valor de créditos a corto plazo a empresas asociadas","59"],
		["5955","Deterioro de valor de créditos a corto plazo a otras partes vinculadas","59"],
		["597","Deterioro de valor de valores representativos de deuda a corto plazo","59"],
		["598","Deterioro de valor de créditos a corto plazo","59"],
		["5990","Deterioro de valor de inmovilizado no corriente mantenido para la venta","59"],
		["5991","Deterioro de valor de inversiones con personas y entidades vinculadas no corrientes mantenidas para la venta","59"],
		["5992","Deterioro de valor de inversiones financieras no corrientes mantenidas para la venta","59"],
		["5993","Deterioro de valor de existencias, deudores comerciales y otras cuentas a cobrar integrados en un grupo enajenable mantenido para la venta","59"],
		["5994","Deterioro de valor de otros activos mantenidos para la venta","59"],
		["600","Compras de mercaderías","60"],
		["601","Compras de materias primas","60"],
		["602","Compras de otros aprovisionamientos","60"],
		["6060","Descuentos sobre compras por pronto pago de mercaderías","60"],
		["6061","Descuentos sobre compras por pronto pago de materias primas","60"],
		["6062","Descuentos sobre compras por pronto pago de otros aprovisionamientos","60"],
		["607","Trabajos realizados por otras empresas","60"],
		["6080","Devoluciones de compras de mercaderías","60"],
		["6081","Devoluciones de compras de materias primas","60"],
		["6082","Devoluciones de compras de otros aprovisionamientos","60"],
		["6090","Rappels por compras de mercaderías","60"],
		["6091","Rappels por compras de materias primas","60"],
		["6092","Rappels por compras de otros aprovisionamientos","60"],
		["610","Variación de existencias de mercaderías","61"],
		["611","Variación de existencias de materias primas","61"],
		["612","Variación de existencias de otros aprovisionamientos","61"],
		["620","Gastos en investigación y desarrollo del ejercicio","62"],
		["621","Arrendamientos y cánones","62"],
		["622","Reparaciones y conservación","62"],
		["623","Servicios de profesionales independientes","62"],
		["624","Transportes","62"],
		["625","Primas de seguros","62"],
		["626","Servicios bancarios y similares","62"],
		["627","Publicidad, propaganda y relaciones públicas","62"],
		["628","Suministros","62"],
		["629","Otros servicios","62"],
		["6300","Impuesto corriente","63"],
		["6301","Impuesto diferido","63"],
		["631","Otros tributos","63"],
		["633","Ajustes negativos en la imposición sobre beneficios","63"],
		["6341","Ajustes negativos en iva de activo corriente","63"],
		["6342","Ajustes negativos en iva de inversiones","63"],
		["636","Devolución de impuestos","63"],
		["638","Ajustes positivos en la imposición sobre beneficios","63"],
		["6391","Ajustes positivos en iva de activo corriente","63"],
		["6392","Ajustes positivos en iva de inversiones","63"],
		["640","Sueldos y salarios","64"],
		["641","Indemnizaciones","64"],
		["642","Seguridad social a cargo de la empresa","64"],
		["643","Retribuciones a largo plazo mediante sistemas de aportación definida","64"],
		["6440","Contribuciones anuales","64"],
		["6442","Otros costes","64"],
		["6450","Retribuciones al personal liquidados con instrumentos de patrimonio","64"],
		["6457","Retribuciones al personal liquidados en efectivo basado en instrumentos de patrimonio","64"],
		["649","Otros gastos sociales","64"],
		["650","Pérdidas de créditos comerciales incobrables","65"],
		["6510","Beneficio transferido (gestor)","65"],
		["6511","Pérdida soportada (partícipe o asociado no gestor)","65"],
		["659","Otras pérdidas en gestión corriente","65"],
		["660","Gastos financieros por actualización de provisiones","66"],
		["6610","Intereses de obligaciones y bonos a largo plazo, empresas del grupo","66"],
		["6611","Intereses de obligaciones y bonos a largo plazo, empresas asociadas","66"],
		["6612","Intereses de obligaciones y bonos a largo plazo, otras partes vinculadas","66"],
		["6613","Intereses de obligaciones y bonos a largo plazo, otras empresas","66"],
		["6615","Intereses de obligaciones y bonos a corto plazo, empresas del grupo","66"],
		["6616","Intereses de obligaciones y bonos a corto plazo, empresas asociadas","66"],
		["6617","Intereses de obligaciones y bonos a corto plazo, otras partes vinculadas","66"],
		["6618","Intereses de obligaciones y bonos a corto plazo, otras empresas","66"],
		["6620","Intereses de deudas, empresas del grupo","66"],
		["6621","Intereses de deudas, empresas asociadas","66"],
		["6622","Intereses de deudas, otras partes vinculadas","66"],
		["6623","Intereses de deudas con entidades de crédito","66"],
		["6624","Intereses de deudas, otras empresas","66"],
		["6630","Pérdidas de cartera de negociación","66"],
		["6631","Pérdidas de designados por la empresa","66"],
		["6632","Pérdidas de disponibles para la venta","66"],
		["6633","Pérdidas de instrumentos de cobertura","66"],
		["6640","Dividendos de pasivos, empresas del grupo","66"],
		["6641","Dividendos de pasivos, empresas asociadas","66"],
		["6642","Dividendos de pasivos, otras partes vinculadas","66"],
		["6643","Dividendos de pasivos, otras empresas","66"],
		["6650","Intereses por descuento de efectos en entidades de crédito del grupo","66"],
		["6651","Intereses por descuento de efectos en entidades de crédito asociadas","66"],
		["6652","Intereses por descuento de efectos en otras entidades de crédito vinculadas","66"],
		["6653","Intereses por descuento de efectos en otras entidades de crédito","66"],
		["6654","Intereses por operaciones de factoring con entidades de crédito del grupo","66"],
		["6655","Intereses por operaciones de factoring con entidades de crédito asociadas","66"],
		["6656","Intereses por operaciones de factoring con otras entidades de crédito vinculadas","66"],
		["6657","Intereses por operaciones de factoring con otras entidades de crédito","66"],
		["6660","Pérdidas en valores representativos de deuda a largo plazo, empresas del grupo","66"],
		["6661","Pérdidas en valores representativos de deuda a largo plazo, empresas asociadas","66"],
		["6662","Pérdidas en valores representativos de deuda a largo plazo, otras partes vinculadas","66"],
		["6663","Pérdidas en participaciones y valores representativos de deuda a largo plazo, otras empresas","66"],
		["6665","Pérdidas en participaciones y valores representativos de deuda a corto plazo, empresas del grupo","66"],
		["6666","Pérdidas en participaciones y valores representativos de deuda a corto plazo, empresas asociadas","66"],
		["6667","Pérdidas en valores representativos de deuda a corto plazo, otras partes vinculadas","66"],
		["6668","Pérdidas en valores representativos de deuda a corto plazo, otras empresas","66"],
		["6670","Pérdidas de créditos a largo plazo, empresas del grupo","66"],
		["6671","Pérdidas de créditos a largo plazo, empresas asociadas","66"],
		["6672","Pérdidas de créditos a largo plazo, otras partes vinculadas","66"],
		["6673","Pérdidas de créditos a largo plazo, otras empresas","66"],
		["6675","Pérdidas de créditos a corto plazo, empresas del grupo","66"],
		["6676","Pérdidas de créditos a corto plazo, empresas asociadas","66"],
		["6677","Pérdidas de créditos a corto plazo, otras partes vinculadas","66"],
		["6678","Pérdidas de créditos a corto plazo, otras empresas","66"],
		["668","Diferencias negativas de cambio","66"],
		["669","Otros gastos financieros","66"],
		["670","Pérdidas procedentes del inmovilizado intangible","67"],
		["671","Pérdidas procedentes del inmovilizado material","67"],
		["672","Pérdidas procedentes de las inversiones inmobiliarias","67"],
		["6733","Pérdidas procedentes de participaciones a largo plazo, empresas del grupo","67"],
		["6734","Pérdidas procedentes de participaciones a largo plazo, empresas asociadas","67"],
		["6735","Pérdidas procedentes de participaciones a largo plazo, otras partes vinculadas","67"],
		["675","Pérdidas por operaciones con obligaciones propias","67"],
		["678","Gastos excepcionales","67"],
		["680","Amortización del inmovilizado intangible","68"],
		["681","Amortización del inmovilizado material","68"],
		["682","Amortización de las inversiones inmobiliarias","68"],
		["690","Pérdidas por deterioro del inmovilizado intangible","69"],
		["691","Pérdidas por deterioro del inmovilizado material","69"],
		["692","Pérdidas por deterioro de las inversiones inmobiliarias","69"],
		["6930","Pérdidas por deterioro de productos terminados y en curso de fabricación","69"],
		["6931","Pérdidas por deterioro de mercaderías","69"],
		["6932","Pérdidas por deterioro de materias primas","69"],
		["6933","Pérdidas por deterioro de otros aprovisionamientos","69"],
		["694","Pérdidas por deterioro de créditos por operaciones comerciales","69"],
		["6954","Dotación a la provisión por contratos onerosos","69"],
		["6959","Dotación a la provisión para otras operaciones comerciales","69"],
		["6960","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas del grupo","69"],
		["6961","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas asociadas","69"],
		["6962","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, otras partes vinculadas","69"],
		["6963","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, otras empresas","69"],
		["6965","Pérdidas por deterioro en valores representativos de deuda a largo plazo, empresas del grupo","69"],
		["6966","Pérdidas por deterioro en valores representativos de deuda a largo plazo, empresas asociadas","69"],
		["6967","Pérdidas por deterioro en valores representativos de deuda a largo plazo, otras partes vinculadas","69"],
		["6968","Pérdidas por deterioro en valores representativos de deuda a largo plazo, de otras empresas","69"],
		["6970","Pérdidas por deterioro de créditos a largo plazo, empresas del grupo","69"],
		["6971","Pérdidas por deterioro de créditos a largo plazo, empresas asociadas","69"],
		["6972","Pérdidas por deterioro de créditos a largo plazo, otras partes vinculadas","69"],
		["6973","Pérdidas por deterioro de créditos a largo plazo, otras empresas","69"],
		["6980","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas del grupo","69"],
		["6981","Pérdidas por deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas asociadas","69"],
		["6985","Pérdidas por deterioro en valores representativos de deuda a corto plazo, empresas del grupo","69"],
		["6986","Pérdidas por deterioro en valores representativos de deuda a corto plazo, empresas asociadas","69"],
		["6987","Pérdidas por deterioro en valores representativos de deuda a corto plazo, otras partes vinculadas","69"],
		["6988","Pérdidas por deterioro en valores representativos de deuda a corto plazo, de otras empresas","69"],
		["6990","Pérdidas por deterioro de créditos a corto plazo, empresas del grupo","69"],
		["6991","Pérdidas por deterioro de créditos a corto plazo, empresas asociadas","69"],
		["6992","Pérdidas por deterioro de créditos a corto plazo, otras partes vinculadas","69"],
		["6993","Pérdidas por deterioro de créditos a corto plazo, otras empresas","69"],
		["700","Ventas de mercaderías","70"],
		["701","Ventas de productos terminados","70"],
		["702","Ventas de productos semiterminados","70"],
		["703","Ventas de subproductos y residuos","70"],
		["704","Ventas de envases y embalajes","70"],
		["705","Prestaciones de servicios","70"],
		["7060","Descuentos sobre ventas por pronto pago de mercaderías","70"],
		["7061","Descuentos sobre ventas por pronto pago de productos terminados","70"],
		["7062","Descuentos sobre ventas por pronto pago de productos semiterminados","70"],
		["7063","Descuentos sobre ventas por pronto pago de subproductos y residuos","70"],
		["7080","Devoluciones de ventas de mercaderías","70"],
		["7081","Devoluciones de ventas de productos terminados","70"],
		["7082","Devoluciones de ventas de productos semiterminados","70"],
		["7083","Devoluciones de ventas de subproductos y residuos","70"],
		["7084","Devoluciones de ventas de envases y embalajes","70"],
		["7090","Rappels sobre ventas de mercaderías","70"],
		["7091","Rappels sobre ventas de productos terminados","70"],
		["7092","Rappels sobre ventas de productos semiterminados","70"],
		["7093","Rappels sobre ventas de subproductos y residuos","70"],
		["7094","Rappels sobre ventas de envases y embalajes","70"],
		["710","Variación de existencias de productos en curso","71"],
		["711","Variación de existencias de productos semiterminados","71"],
		["712","Variación de existencias de productos terminados","71"],
		["713","Variación de existencias de subproductos,residuos y materiales recuperados","71"],
		["730","Trabajos realizados para el inmovilizado intangible","73"],
		["731","Trabajos realizados para el inmovilizado material","73"],
		["732","Trabajos realizados en inversiones inmobiliarias","73"],
		["733","Trabajos realizados para el inmovilizado material en curso","73"],
		["740","Subvenciones, donaciones y legados a la explotación","74"],
		["746","Subvenciones, donaciones y legados de capital transferidos al resultado del ejercicio","74"],
		["747","Otras subvenciones, donaciones y legados transferidos al resultado del ejercicio","74"],
		["7510","Pérdida transferida (gestor)","75"],
		["7511","Beneficio atribuido (partícipe o asociado no gestor)","75"],
		["752","Ingresos por arrendamientos","75"],
		["753","Ingresos de propiedad industrial cedida en explotación","75"],
		["754","Ingresos por comisiones","75"],
		["755","Ingresos por servicios al personal","75"],
		["759","Ingresos por servicios diversos","75"],
		["7600","Ingresos de participaciones en instrumentos de patrimonio, empresas del grupo","76"],
		["7601","Ingresos de participaciones en instrumentos de patrimonio, empresas asociadas","76"],
		["7602","Ingresos de participaciones en instrumentos de patrimonio, otras partes vinculadas","76"],
		["7603","Ingresos de participaciones en instrumentos de patrimonio, otras empresas","76"],
		["7610","Ingresos de valores representativos de deuda, empresas del grupo","76"],
		["7611","Ingresos de valores representativos de deuda, empresas asociadas","76"],
		["7612","Ingresos de valores representativos de deuda, otras partes vinculadas","76"],
		["7613","Ingresos de valores representativos de deuda, otras empresas","76"],
		["76200","Ingresos de créditos a largo plazo, empresas del grupo","76"],
		["76201","Ingresos de créditos a largo plazo, empresas asociadas","76"],
		["76202","Ingresos de créditos a largo plazo, otras partes vinculadas","76"],
		["76203","Ingresos de créditos a largo plazo, otras empresas","76"],
		["76210","Ingresos de créditos a corto plazo, empresas del grupo","76"],
		["76211","Ingresos de créditos a corto plazo, empresas asociadas","76"],
		["76212","Ingresos de créditos a corto plazo, otras partes vinculadas","76"],
		["76213","Ingresos de créditos a corto plazo, otras empresas","76"],
		["7630","Beneficios de cartera de negociación","76"],
		["7631","Beneficios de designados por la empresa","76"],
		["7632","Beneficios de disponibles para la venta","76"],
		["7633","Beneficios de instrumentos de cobertura","76"],
		["7660","Beneficios en valores representativos de deuda a largo plazo, empresas del grupo","76"],
		["7661","Beneficios en valores representativos de deuda a largo plazo, empresas asociadas","76"],
		["7662","Beneficios en valores representativos de deuda a largo plazo, otras partes vinculadas","76"],
		["7663","Beneficios en participaciones y valores representativos de deuda a largo plazo, otras empresas","76"],
		["7665","Beneficios en participaciones y valores representativos de deuda a corto plazo, empresas del grupo","76"],
		["7666","Beneficios en participaciones y valores representativos de deuda a corto plazo, empresas asociadas","76"],
		["7667","Beneficios en valores representativos de deuda a corto plazo, otras partes vinculadas","76"],
		["7668","Beneficios en valores representativos de deuda a corto plazo, otras empresas","76"],
		["767","Ingresos de activos afectos y de derechos de reembolso relativos a retribuciones a largo plazo","76"],
		["768","Diferencias positivas de cambio","76"],
		["769","Otros ingresos financieros","76"],
		["770","Beneficios procedentes del inmovilizado intangible","77"],
		["771","Beneficios procedentes del inmovilizado material","77"],
		["772","Beneficios procedentes de las inversiones inmobiliarias","77"],
		["7733","Beneficios procedentes de participaciones a largo plazo, empresas del grupo","77"],
		["7734","Beneficios procedentes de participaciones a largo plazo, empresas asociadas","77"],
		["7735","Beneficios procedentes de participaciones a largo plazo, otras partes vinculadas","77"],
		["774","Diferencia negativa en combinaciones de negocios","77"],
		["775","Beneficios por operaciones con obligaciones propias","77"],
		["778","Ingresos excepcionales","77"],
		["790","Reversión del deterioro del inmovilizado intangible","79"],
		["791","Reversión del deterioro del inmovilizado material","79"],
		["792","Reversión del deterioro de las inversiones inmobiliarias","79"],
		["7930","Reversión del deterioro de productos terminados y en curso de fabricación","79"],
		["7931","Reversión del deterioro de mercaderías","79"],
		["7932","Reversión del deterioro de materias primas","79"],
		["7933","Reversión del deterioro de otros aprovisionamientos","79"],
		["794","Reversión del deterioro de créditos por operaciones comerciales","79"],
		["7950","Exceso de provisión por retribuciones al personal","79"],
		["7951","Exceso de provisión para impuestos","79"],
		["7952","Exceso de provisión para otras responsabilidades","79"],
		["79544","Exceso de provisión por contratos onerosos","79"],
		["79549","Exceso de provisión para otras operaciones comerciales","79"],
		["7955","Exceso de provisión para actuaciones medioambientales","79"],
		["7956","Exceso de provisión para reestructuraciones","79"],
		["7957","Exceso de provisión por transacciones con pagos basados en instrumentos de patrimonio","79"],
		["7960","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas del grupo","79"],
		["7961","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a largo plazo, empresas asociadas","79"],
		["7965","Reversión del deterioro de valores representativos de deuda a largo plazo, empresas del grupo","79"],
		["7966","Reversión del deterioro de valores representativos de deuda a largo plazo, empresas asociadas","79"],
		["7967","Reversión del deterioro de valores representativos de deuda a largo plazo, otras partes vinculadas","79"],
		["7968","Reversión del deterioro de valores representativos de deuda a largo plazo, otras empresas","79"],
		["7970","Reversión del deterioro de créditos a largo plazo, empresas del grupo","79"],
		["7971","Reversión del deterioro de créditos a largo plazo, empresas asociadas","79"],
		["7972","Reversión del deterioro de créditos a largo plazo, otras partes vinculadas","79"],
		["7973","Reversión del deterioro de créditos a largo plazo, otras empresas","79"],
		["7980","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas del grupo","79"],
		["7981","Reversión del deterioro de participaciones en instrumentos de patrimonio neto a corto plazo, empresas asociadas","79"],
		["7985","Reversión del deterioro en valores representativos de deuda a corto plazo, empresas del grupo","79"],
		["7986","Reversión del deterioro en valores representativos de deuda a corto plazo, empresas asociadas","79"],
		["7987","Reversión del deterioro en valores representativos de deuda a corto plazo, otras partes vinculadas","79"],
		["7988","Reversión del deterioro en valores representativos de deuda a corto plazo, otras empresas","79"],
		["7990","Reversión del deterioro de créditos a corto plazo, empresas del grupo","79"],
		["7991","Reversión del deterioro de créditos a corto plazo, empresas asociadas","79"],
		["7992","Reversión del deterioro de créditos a corto plazo, otras partes vinculadas","79"],
		["7993","Reversión del deterioro de créditos a corto plazo, otras empresas","79"],
		["800","Pérdidas en activos financieros disponibles para la venta","80"],
		["802","Transferencia de beneficios en activos financieros disponibles para la venta","80"],
		["810","Pérdidas por coberturas de flujos de efectivo","81"],
		["811","Pérdidas por coberturas de inversiones netas en un negocio en el extranjero","81"],
		["812","Transferencia de beneficios por coberturas de flujos de efectivo","81"],
		["813","Transferencia de beneficios por coberturas de inversiones netas en un negocio en el extranjero","81"],
		["820","Diferencias de conversión negativas","82"],
		["821","Transferencia de diferencias de conversión positivas","82"],
		["8300","Impuesto corriente","83"],
		["8301","Impuesto diferido","83"],
		["833","Ajustes negativos en la imposición sobre beneficios","83"],
		["834","Ingresos fiscales por diferencias permanentes","83"],
		["835","Ingresos fiscales por deducciones y bonificaciones","83"],
		["836","Transferencia de diferencias permanentes","83"],
		["837","Transferencia de deducciones y bonificaciones","83"],
		["838","Ajustes positivos en la imposición sobre beneficios","83"],
		["840","Transferencia de subvenciones oficiales de capital","84"],
		["841","Transferencia de donaciones y legados de capital","84"],
		["842","Transferencia de otras subvenciones, donaciones y legados","84"],
		["850","Pérdidas actuariales","85"],
		["851","Ajustes negativos en activos por retribuciones a largo plazo de prestación definida","85"],
		["860","Pérdidas en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","86"],
		["862","Transferencia de beneficios en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","86"],
		["891","Deterioro de participaciones en el patrimonio, empresas del grupo","89"],
		["892","Deterioro de participaciones en el patrimonio, empresas asociadas","89"],
		["900","Beneficios en activos financieros disponibles para la venta","90"],
		["902","Transferencia de pérdidas de activos financieros disponibles para la venta","90"],
		["910","Beneficios por coberturas de flujos de efectivo","91"],
		["911","Beneficios por coberturas de una inversión neta en un negocio en el extranjero","91"],
		["912","Transferencia de pérdidas por coberturas de flujos de efectivo","91"],
		["913","Transferencia de pérdidas por coberturas de una inversión neta en un negocio en el extranjero","91"],
		["920","Diferencias de conversión positivas","92"],
		["921","Transferencia de diferencias de conversión negativas","92"],
		["940","Ingresos de subvenciones oficiales de capital","94"],
		["941","Ingresos de donaciones y legados de capital","94"],
		["942","Ingresos de otras subvenciones, donaciones y legados","94"],
		["950","Ganancias actuariales","95"],
		["951","Ajustes positivos en activos por retribuciones a largo plazo de prestación definida","95"],
		["960","Beneficios en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","96"],
		["962","Transferencia de pérdidas en activos no corrientes y grupos enajenables de elementos mantenidos para la venta","96"],
		["991","Recuperación de ajustes valorativos negativos previos, empresas del grupo","99"],
		["992","Recuperación de ajustes valorativos negativos previos, empresas asociadas","99"],
		["993","Transferencia por deterioro de ajustes valorativos negativos previos, empresas del grupo","99"],
		["994","Transferencia por deterioro de ajustes valorativos negativos previos, empresas asociadas","99"],	];
	return datos;
}


function pgc2008_datosCorrespondencias():Array
{
	var datos:String = [
		["100","100"],
		["1000","100"],
		["1001","100"],
		["1002","100"],
		["1003","100"],
		["101","101"],
		["102","102"],
		["","1030"],
		["","1034"],
		["","1040"],
		["","1044"],
		["110","110"],
		["","111"],
		["111",""],
		["","1110"],
		["","1111"],
		["112","112"],
		["113","114"],
		["114","1140"],
		["","1143"],
		["","115"],
		["115","1144"],
		["116","1141"],
		["117","113"],
		["118","1142"],
		["119","119"],
		["120","120"],
		["121","121"],
		["122","118"],
		["129","129"],
		["130","130"],
		["1300","130"],
		["1301","130"],
		["131","131"],
		["","132"],
		["","133"],
		["","134"],
		["","1340"],
		["","1341"],
		["135",""],
		["","136"],
		["136","135"],
		["","137"],
		["137","1370"],
		["138","1371"],
		["140","140"],
		["141","141"],
		["142","142"],
		["143","143"],
		["144","142"],
		["145","145"],
		["","146"],
		["","147"],
		["","150"],
		["150","177"],
		["1500","177"],
		["1501","177"],
		["1502","177"],
		["1503","177"],
		["1504","177"],
		["1505","177"],
		["151","178"],
		["","153"],
		["","1533"],
		["","1534"],
		["","1535"],
		["","1536"],
		["","154"],
		["","1543"],
		["","1544"],
		["","1545"],
		["","1546"],
		["155","179"],
		["","160"],
		["160","1633"],
		["1600","1633"],
		["","1605"],
		["1608","1633"],
		["1609","1633"],
		["","161"],
		["161","1634"],
		["","1615"],
		["","162"],
		["162","1603"],
		["","1623"],
		["","1624"],
		["","1625"],
		["","163"],
		["163","1604"],
		["","1635"],
		["164","1613"],
		["165","1614"],
		["170","170"],
		["1700","170"],
		["1709","170"],
		["171","171"],
		["172","172"],
		["173","173"],
		["","174"],
		["174","175"],
		["","176"],
		["","1765"],
		["","1768"],
		["180","180"],
		["","181"],
		["185","185"],
		["","189"],
		["","190"],
		["190","103"],
		["191","103"],
		["","192"],
		["192","103"],
		["193","104"],
		["","194"],
		["194","104"],
		["","195"],
		["195","104"],
		["196","103"],
		["","197"],
		["198","108"],
		["","199"],
		["199","109"],
		["200",""],
		["201",""],
		["202",""],
		["210","201"],
		["210","200"],
		["2100","201"],
		["2100","200"],
		["2101","201"],
		["2101","200"],
		["211","202"],
		["212","203"],
		["213","204"],
		["214","205"],
		["215","206"],
		["219","209"],
		["","220"],
		["220","210"],
		["","221"],
		["221","211"],
		["222","212"],
		["223","213"],
		["224","214"],
		["225","215"],
		["226","216"],
		["227","217"],
		["228","218"],
		["229","219"],
		["230","230"],
		["231","231"],
		["232","232"],
		["233","233"],
		["237","237"],
		["239","239"],
		["","240"],
		["240","2403"],
		["","2405"],
		["","241"],
		["241","2404"],
		["","2415"],
		["","242"],
		["242","2413"],
		["","2425"],
		["243","2414"],
		["244","2423"],
		["2448","2423"],
		["245","2424"],
		["246","2423"],
		["247","2424"],
		["248","2493"],
		["","249"],
		["249","2494"],
		["","2495"],
		["250","250"],
		["2500","250"],
		["2501","250"],
		["2502","250"],
		["251","251"],
		["2518","251"],
		["252","252"],
		["253","253"],
		["254","254"],
		["","255"],
		["","2550"],
		["","2553"],
		["256","252"],
		["","257"],
		["257","252"],
		["258","258"],
		["259","259"],
		["260","260"],
		["265","265"],
		["270",""],
		["271",""],
		["272",""],
		["281","280"],
		["2810","2801"],
		["2810","2800"],
		["2811","2802"],
		["2812","2803"],
		["2813","204"],
		["2814","2805"],
		["2815","2806"],
		["2817","281"],
		["2817","280"],
		["","282"],
		["282","281"],
		["2821","2811"],
		["2822","2812"],
		["2823","2813"],
		["2824","2814"],
		["2825","2815"],
		["2826","2816"],
		["2827","2817"],
		["2828","2818"],
		["2829","2819"],
		["","2900"],
		["","2901"],
		["","2902"],
		["","2903"],
		["","2905"],
		["","2906"],
		["291","290"],
		["","2910"],
		["","2911"],
		["","2912"],
		["","2913"],
		["","2914"],
		["","2915"],
		["","2916"],
		["","2917"],
		["","2918"],
		["","2919"],
		["","292"],
		["292","291"],
		["","2920"],
		["","2921"],
		["","293"],
		["293","2943"],
		["293","2933"],
		["2930","2933"],
		["2935","2943"],
		["","294"],
		["294","2944"],
		["294","2934"],
		["2941","2934"],
		["","2945"],
		["2946","2944"],
		["","295"],
		["295","2953"],
		["","2955"],
		["296","2954"],
		["297","297"],
		["298","298"],
		["300","300"],
		["301","301"],
		["310","310"],
		["311","311"],
		["320","320"],
		["321","321"],
		["322","322"],
		["325","325"],
		["326","326"],
		["327","327"],
		["328","328"],
		["330","330"],
		["331","331"],
		["340","340"],
		["341","341"],
		["350","350"],
		["351","351"],
		["360","360"],
		["361","361"],
		["365","365"],
		["366","366"],
		["368","368"],
		["369","369"],
		["390","390"],
		["391","391"],
		["392","392"],
		["393","393"],
		["394","394"],
		["395","395"],
		["396","396"],
		["400","400"],
		["4000","4000"],
		["4004","4004"],
		["4009","4009"],
		["401","401"],
		["402","403"],
		["4020","4030"],
		["4021","4031"],
		["4024","4034"],
		["4026","4036"],
		["4029","4039"],
		["403","404"],
		["","405"],
		["406","406"],
		["407","407"],
		["410","410"],
		["4100","4100"],
		["4104","4104"],
		["4109","4109"],
		["411","411"],
		["419","419"],
		["430","430"],
		["4300","4300"],
		["4301","4304"],
		["4309","4309"],
		["431","431"],
		["4310","4310"],
		["4311","4311"],
		["4312","4312"],
		["4315","4315"],
		["","432"],
		["432","433"],
		["4320","4330"],
		["4321","4331"],
		["4324","4334"],
		["4326","4337"],
		["4329","4339"],
		["433","434"],
		["","4332"],
		["","4336"],
		["","435"],
		["435","436"],
		["436","437"],
		["437","438"],
		["440","440"],
		["4400","4400"],
		["4404","4404"],
		["4409","4409"],
		["441","441"],
		["4410","4410"],
		["4411","4411"],
		["4412","4412"],
		["4415","4415"],
		["445","446"],
		["449","449"],
		["460","460"],
		["465","465"],
		["","466"],
		["470","470"],
		["4700","4700"],
		["4707","470"],
		["4708","4708"],
		["4709","4709"],
		["471","471"],
		["472","472"],
		["4727","472"],
		["473","473"],
		["4732","473"],
		["474","474"],
		["4740","4740"],
		["4741","4740"],
		["4742","4742"],
		["4744","4742"],
		["4745","4745"],
		["4746","4745"],
		["4748","4740"],
		["4749","4745"],
		["475","475"],
		["4750","4750"],
		["4751","4751"],
		["4752","4752"],
		["4757","475"],
		["4758","4758"],
		["476","476"],
		["477","477"],
		["4777","477"],
		["479","479"],
		["4791","479"],
		["4798","479"],
		["480","480"],
		["485","485"],
		["490","490"],
		["","493"],
		["493","4933"],
		["","4935"],
		["494","4934"],
		["","499"],
		["499","4999"],
		["","4994"],
		["500","500"],
		["501","501"],
		["","502"],
		["505","505"],
		["506","506"],
		["","507"],
		["509","509"],
		["5090","5090"],
		["5091","5091"],
		["5095","5095"],
		["","510"],
		["510","5133"],
		["5100","5133"],
		["","5105"],
		["5108","5133"],
		["5109","5133"],
		["","511"],
		["511","5134"],
		["","5115"],
		["","512"],
		["512","5103"],
		["5120","5103"],
		["","5123"],
		["","5124"],
		["","5125"],
		["5128","5103"],
		["5129","5103"],
		["","513"],
		["513","5104"],
		["","5135"],
		["","514"],
		["514","5113"],
		["","5145"],
		["515","5114"],
		["516","5143"],
		["517","5144"],
		["520","520"],
		["5200","5200"],
		["5201","5201"],
		["5208","5208"],
		["","5209"],
		["521","521"],
		["","522"],
		["523","523"],
		["","524"],
		["524","525"],
		["525","526"],
		["526","527"],
		["527","528"],
		["","529"],
		["","5290"],
		["","5291"],
		["","5292"],
		["","5293"],
		["","5295"],
		["","5296"],
		["","5297"],
		["","530"],
		["530","5303"],
		["","5305"],
		["","531"],
		["531","5304"],
		["","5315"],
		["","532"],
		["532","5313"],
		["","5325"],
		["","533"],
		["533","5314"],
		["","5335"],
		["","534"],
		["534","5323"],
		["","5344"],
		["","5345"],
		["5348","5323"],
		["","535"],
		["535","5324"],
		["","5353"],
		["","5354"],
		["","5355"],
		["536","5333"],
		["5360","5333"],
		["5361","5343"],
		["537","5334"],
		["538","5393"],
		["","539"],
		["539","5394"],
		["","5395"],
		["540","540"],
		["5400","540"],
		["5401","540"],
		["5409","540"],
		["541","541"],
		["5418","541"],
		["542","542"],
		["543","543"],
		["544","544"],
		["545","545"],
		["546","546"],
		["547","547"],
		["548","548"],
		["549","549"],
		["550","550"],
		["551","5523"],
		["","552"],
		["552","5524"],
		["","5525"],
		["","553"],
		["553","551"],
		["","5530"],
		["","5531"],
		["","5532"],
		["","5533"],
		["","554"],
		["555","555"],
		["556","556"],
		["5560","5563"],
		["5561","5564"],
		["5562","5566"],
		["","5565"],
		["557","557"],
		["558","558"],
		["","5580"],
		["","5585"],
		["","559"],
		["","5590"],
		["","5593"],
		["","5595"],
		["","5598"],
		["560","560"],
		["561","561"],
		["565","565"],
		["566","566"],
		["","569"],
		["570","570"],
		["571","571"],
		["572","572"],
		["573","573"],
		["574","574"],
		["575","575"],
		["","576"],
		["","580"],
		["580","567"],
		["","581"],
		["","582"],
		["","583"],
		["","584"],
		["","585"],
		["585","568"],
		["","586"],
		["","587"],
		["","588"],
		["","589"],
		["","593"],
		["593","5943"],
		["593","5933"],
		["","594"],
		["594","5944"],
		["594","5934"],
		["","5945"],
		["","595"],
		["595","5953"],
		["","5955"],
		["596","5954"],
		["597","597"],
		["598","598"],
		["","599"],
		["","5990"],
		["","5991"],
		["","5992"],
		["","5993"],
		["","5994"],
		["600","600"],
		["601","601"],
		["602","602"],
		["","6060"],
		["","6061"],
		["","6062"],
		["607","607"],
		["608","608"],
		["6080","6080"],
		["6081","6081"],
		["6082","6082"],
		["609","609"],
		["6090","6090"],
		["6091","6091"],
		["6092","6092"],
		["610","610"],
		["611","611"],
		["612","612"],
		["620","620"],
		["621","621"],
		["6210","621"],
		["6211","621"],
		["622","622"],
		["6220","622"],
		["6223","622"],
		["623","623"],
		["6230","623"],
		["6233","623"],
		["624","624"],
		["625","625"],
		["626","626"],
		["627","627"],
		["628","628"],
		["629","629"],
		["630","630"],
		["","6300"],
		["6300","630"],
		["","6301"],
		["6301","630"],
		["631","631"],
		["632","631"],
		["6320","631"],
		["6321","631"],
		["6323","633"],
		["6328","638"],
		["633","633"],
		["634","634"],
		["6341","6341"],
		["6342","6342"],
		["6343","6341"],
		["6344","6342"],
		["635","630"],
		["636","636"],
		["637","631"],
		["6371","631"],
		["6372","631"],
		["6373","631"],
		["6374","631"],
		["638","638"],
		["639","639"],
		["6391","6391"],
		["6392","6392"],
		["6393","6391"],
		["6394","6392"],
		["640","640"],
		["641","641"],
		["642","642"],
		["643","644"],
		["643","643"],
		["","6440"],
		["","6442"],
		["","645"],
		["","6450"],
		["","6457"],
		["649","649"],
		["650","650"],
		["651","651"],
		["6510","6510"],
		["6511","6511"],
		["659","659"],
		["","660"],
		["661","661"],
		["6610","6610"],
		["6611","6611"],
		["","6612"],
		["6613","6613"],
		["6615","6615"],
		["6616","6616"],
		["","6617"],
		["6618","6618"],
		["662","662"],
		["6620","6620"],
		["6621","6621"],
		["","6622"],
		["6622","6623"],
		["6623","6624"],
		["","663"],
		["663","662"],
		["","6630"],
		["6630","6620"],
		["","6631"],
		["6631","6621"],
		["","6632"],
		["6632","6623"],
		["","6633"],
		["6633","6624"],
		["","664"],
		["664","665"],
		["","6640"],
		["6640","6650"],
		["","6641"],
		["6641","6651"],
		["","6642"],
		["","6643"],
		["6643","6653"],
		["665","706"],
		["6650","706"],
		["6651","706"],
		["","6652"],
		["6653","706"],
		["","6654"],
		["","6655"],
		["","6656"],
		["","6657"],
		["666","666"],
		["6660","6660"],
		["6661","6661"],
		["","6662"],
		["6663","6663"],
		["6665","6665"],
		["6666","6666"],
		["","6667"],
		["6668","6668"],
		["667","667"],
		["6670","6670"],
		["6671","6671"],
		["","6672"],
		["6673","6673"],
		["6675","6675"],
		["6676","6676"],
		["","6677"],
		["6678","6678"],
		["668","668"],
		["6680","668"],
		["6681","668"],
		["669","669"],
		["6690","669"],
		["6691","669"],
		["670","670"],
		["671","671"],
		["","672"],
		["672","6733"],
		["","673"],
		["673","6734"],
		["","6735"],
		["674","675"],
		["676","671"],
		["678","678"],
		["6780","678"],
		["6781","678"],
		["679","678"],
		["680",""],
		["681","680"],
		["","682"],
		["682","681"],
		["690","669"],
		["691","690"],
		["","692"],
		["692","691"],
		["693","693"],
		["","6930"],
		["","6931"],
		["","6932"],
		["","6933"],
		["694","694"],
		["695","695"],
		["6950","6959"],
		["6951","6954"],
		["696","696"],
		["6960","6960"],
		["6961","6961"],
		["","6962"],
		["6963","6968"],
		["6963","6963"],
		["6965","6965"],
		["6966","6966"],
		["","6967"],
		["697","697"],
		["6970","6970"],
		["6971","6971"],
		["","6972"],
		["6973","6973"],
		["698","698"],
		["6980","6985"],
		["6980","6980"],
		["6981","6986"],
		["6981","6981"],
		["6983","6988"],
		["","6987"],
		["699","699"],
		["6990","6990"],
		["6991","6991"],
		["","6992"],
		["6993","6993"],
		["700","700"],
		["701","701"],
		["702","702"],
		["703","703"],
		["704","704"],
		["705","705"],
		["","7060"],
		["","7061"],
		["","7062"],
		["","7063"],
		["708","708"],
		["7080","7080"],
		["7081","7081"],
		["7082","7082"],
		["7083","7083"],
		["7084","7084"],
		["709","709"],
		["7090","7090"],
		["7091","7091"],
		["7092","7092"],
		["7093","7093"],
		["7094","7094"],
		["710","710"],
		["711","711"],
		["712","712"],
		["713","713"],
		["730",""],
		["731","730"],
		["","732"],
		["732","731"],
		["733","733"],
		["737",""],
		["740","740"],
		["741","747"],
		["751","751"],
		["7510","7510"],
		["7511","7511"],
		["752","752"],
		["753","753"],
		["754","754"],
		["755","755"],
		["759","759"],
		["760","760"],
		["7600","7600"],
		["7601","7601"],
		["","7602"],
		["7603","7603"],
		["761","761"],
		["7610","7610"],
		["7611","7611"],
		["","7612"],
		["7613","7613"],
		["7618","761"],
		["","762"],
		["762","7620"],
		["7620","76200"],
		["","76202"],
		["7621","76201"],
		["","76212"],
		["7623","76203"],
		["","763"],
		["763","7621"],
		["","7630"],
		["7630","76210"],
		["","7631"],
		["7631","76211"],
		["","7632"],
		["","7633"],
		["7633","76213"],
		["765","606"],
		["7650","606"],
		["7651","606"],
		["7653","606"],
		["766","766"],
		["7660","7660"],
		["7661","7661"],
		["","7662"],
		["7663","7663"],
		["7665","7665"],
		["7666","7666"],
		["","7667"],
		["7668","7668"],
		["","767"],
		["768","768"],
		["7680","768"],
		["7681","768"],
		["769","769"],
		["7690","769"],
		["7691","769"],
		["770","770"],
		["771","771"],
		["","772"],
		["772","7733"],
		["","773"],
		["773","7734"],
		["","7735"],
		["","774"],
		["774","775"],
		["775","746"],
		["776","747"],
		["778","778"],
		["779","778"],
		["790","795"],
		["791","790"],
		["","792"],
		["792","791"],
		["793","793"],
		["","7930"],
		["","7931"],
		["","7932"],
		["","7933"],
		["794","794"],
		["795","794"],
		["","7950"],
		["","7951"],
		["","7952"],
		["","7954"],
		["","79544"],
		["","79549"],
		["","7955"],
		["","7956"],
		["","7957"],
		["796","796"],
		["7960","7960"],
		["7961","7961"],
		["7963","7968"],
		["7965","7965"],
		["7966","7966"],
		["","7967"],
		["797","797"],
		["7970","7970"],
		["7971","7971"],
		["","7972"],
		["7973","7973"],
		["798","798"],
		["7980","7985"],
		["7980","7980"],
		["7981","7986"],
		["7981","7981"],
		["7983","7988"],
		["","7987"],
		["799","799"],
		["7990","7990"],
		["7991","7991"],
		["","7992"],
		["7993","7993"],
		["","800"],
		["","802"],
		["","810"],
		["","811"],
		["","812"],
		["","813"],
		["","820"],
		["","821"],
		["","830"],
		["","8300"],
		["","8301"],
		["","833"],
		["","834"],
		["","835"],
		["","836"],
		["","837"],
		["","838"],
		["","840"],
		["","841"],
		["","842"],
		["","850"],
		["","851"],
		["","860"],
		["","862"],
		["","891"],
		["","892"],
		["","900"],
		["","902"],
		["","910"],
		["","911"],
		["","912"],
		["","913"],
		["","920"],
		["","921"],
		["","940"],
		["","941"],
		["","942"],
		["","950"],
		["","951"],
		["","960"],
		["","962"],
		["","991"],
		["","992"],
		["","993"],
		["","994"]
	];

	return datos;
}


function pgc2008_datosCuentasEspeciales()
{
	var datos:Array = [
		["570","CAJA"],
		["668","CAMNEG"],
		["768","CAMPOS"],
		["437","CLIENT"],
		["435","CLIENT"],
		["436","CLIENT"],
		["440","CLIENT"],
		["449","CLIENT"],
		["445","CLIENT"],
		["432","CLIENT"],
		["4320","CLIENT"],
		["4321","CLIENT"],
		["4324","CLIENT"],
		["4326","CLIENT"],
		["4329","CLIENT"],
		["4415","CLIENT"],
		["4412","CLIENT"],
		["4411","CLIENT"],
		["4410","CLIENT"],
		["441","CLIENT"],
		["4409","CLIENT"],
		["4404","CLIENT"],
		["4400","CLIENT"],
		["430","CLIENT"],
		["4300","CLIENT"],
		["4304","CLIENT"],
		["4309","CLIENT"],
		["431","CLIENT"],
		["4310","CLIENT"],
		["4311","CLIENT"],
		["4312","CLIENT"],
		["4315","CLIENT"],
		["433","CLIENT"],
		["600","COMPRA"],
		["608","DEVCOM"],
		["708","DEVVEN"],
		["136","DIVPOS"],
		["6680","EURNEG"],
		["7680","EURPOS"],
		["4751","IRPFPR"],
		["475","IVAACR"],
		["4750","IVAACR"],
		["4700","IVADEU"],
		["470","IVADEU"],
		["477","IVAREP"],
		["4770","IVAREP"],
		["4720","IVASOP"],
		["472","IVASOP"],
		["120","PREVIO"],
		["121","PREVIO"],
		["411","PROVEE"],
		["419","PROVEE"],
		["401","PROVEE"],
		["4029","PROVEE"],
		["4026","PROVEE"],
		["400","PROVEE"],
		["4000","PROVEE"],
		["4004","PROVEE"],
		["4009","PROVEE"],
		["407","PROVEE"],
		["403","PROVEE"],
		["406","PROVEE"],
		["410","PROVEE"],
		["4100","PROVEE"],
		["4104","PROVEE"],
		["4109","PROVEE"],
		["4024","PROVEE"],
		["4021","PROVEE"],
		["4020","PROVEE"],
		["402","PROVEE"],
		["129","PYG"],
		["705","VENTAS"],
		["704","VENTAS"],
		["703","VENTAS"],
		["700","VENTAS"],
		["701","VENTAS"],
		["702","VENTAS"]
	];

	return datos;
}


function pgc2008_datosCuentasHuerfanas()
{
	var datos:Array = [
		["111","Reservas de revalorización"],
		["135","Ingresos por intereses diferidos"],
		["200","Gastos de constitución"],
		["201","Gastos de primer establecimiento"],
		["202","Gastos de ampliación de capital"],
		["217","Derechos sobre bienes en régimen de arrendamiento financiero."],
		["270","Gastos de formalización de deudas"],
		["271","Gastos por intereses diferidos de valores negociables"],
		["272","Gastos por intereses diferidos"],
		["2813","Amortización acumulada de fondo de comercio"],
		["680","Amortización de gastos de establecimiento"],
		["730","Incorporación al activo de gastos de establecimiento"],
		["737","Incorporación al activo de gastos de formalización de deudas"]];

	return datos;
}


/** \D Se dan de alta las cuentas especiales, si existen se ignoran
\end */
function pgc2008_completarTiposEspeciales()
{
	var datos =
		[["IVAREP","Cuentas de IVA repercutido"],
		["IVASOP","Cuentas de IVA soportado"],
		["IVARUE","Cuentas de IVA repercutido UE"],
		["IVASUE","Cuentas de IVA soportado UE"],
		["IVAACR","Cuentas acreedoras de IVA en la regularización"],
		["IVADEU","Cuentas deudoras de IVA en la regularización"],
		["PYG","Pérdidas y ganancias"],
		["PREVIO","Cuentas relativas al ejercicio previo"],
		["CAMPOS","Cuentas de diferencias positivas de cambio"],
		["CAMNEG","Cuentas de diferencias negativas de cambio"],
		["DIVPOS","Cuentas por diferencias positivas en divisa extranjera"],
		["EURPOS","Cuentas por diferencias positivas de conversión a la moneda local"],
		["EURNEG","Cuentas por diferencias negativas de conversión a la moneda local"],
		["CLIENT","Cuentas de clientes"],
		["PROVEE","Cuentas de proveedores"],
		["COMPRA","Cuentas de compras"],
		["VENTAS","Cuentas de ventas"],
		["CAJA","Cuentas de caja"],
		["IRPFPR","Cuentas de retenciones para proveedores IRPFPR"],
		["IRPF","Cuentas de retenciones IRPF"],
		["GTORF","Gastos por recargo financiero"],
		["INGRF","Ingresos por recargo financiero"],
		["DEVCOM","Devoluciones de compras"],
		["DEVVEN","Devoluciones de ventas"]];

	var cursor:FLSqlCursor = new FLSqlCursor("co_cuentasesp");
	for (i = 0; i < datos.length; i++) {

		cursor.select("idcuentaesp = '" + datos[i][0] + "'");
		if (cursor.first())
			continue;

		cursor.setModeAccess(cursor.Insert);
		cursor.refreshBuffer();
		cursor.setValueBuffer("idcuentaesp", datos[i][0]);
		cursor.setValueBuffer("descripcion", datos[i][1]);
		cursor.commitBuffer();
	}
}

function pgc2008_regenerarPGC(codEjercicio:String)
{
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;
	var longSubcuenta:Number = util.sqlSelect("ejercicios", "longsubcuenta", "codejercicio = '" + codEjercicio + "'");


	// CORRESPONDENCIAS
	util.createProgressDialog(util.translate("scripts", "Preparando..."), 2);
	util.setProgress(1);
	util.sqlDelete("co_correspondenciascc", "");
	util.destroyProgressDialog();

	this.iface.generarCorrespondenciasCC(codEjercicio);


	// DESCRIPCIONES DE GRUPOS
	var datos:Array = this.iface.datosGrupos();
	curCbl = new FLSqlCursor("co_gruposepigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Actualizando grupos"), datos.length);

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);
		curCbl.select("codgrupo = '" + datos[i][0] + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
			with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}
	}
	util.destroyProgressDialog();



	// SUBGRUPOS
	var datos:Array = this.iface.datosSubgrupos();
	curCbl = new FLSqlCursor("co_epigrafes");
	curCbl.setActivatedCheckIntegrity(false);
	util.createProgressDialog(util.translate("scripts", "Actualizando subgrupos"), datos.length);

	for (i = 0; i < datos.length; i++) {

		idGrupo = util.sqlSelect("co_gruposepigrafes", "idgrupo", "codgrupo = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");

		util.setProgress(i);
		curCbl.select("codepigrafe = '" + datos[i][0] + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
			with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}
		else
			with(curCbl) {
				setModeAccess(curCbl.Insert);
				refreshBuffer();
				setValueBuffer("codepigrafe", datos[i][0]);
				setValueBuffer("descripcion", datos[i][1]);
				setValueBuffer("idgrupo", idGrupo);
				setValueBuffer("codejercicio", codEjercicio);
				commitBuffer();
			}
	}
	util.destroyProgressDialog();


	// CUENTAS
	var datos:Array = this.iface.datosCuentas();
	curCbl = new FLSqlCursor("co_cuentas");
	curCbl.setActivatedCheckIntegrity(false);

	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas"), datos.length);

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);

		idEpigrafe = util.sqlSelect("co_epigrafes", "idepigrafe", "codepigrafe = '" + datos[i][2] + "' and codejercicio = '" + codEjercicio + "'");

		curCbl.select("codcuenta = '" + datos[i][0] + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
				with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}

		else
			with(curCbl) {
				setModeAccess(curCbl.Insert);
				refreshBuffer();
				setValueBuffer("codcuenta", datos[i][0]);
				setValueBuffer("descripcion", datos[i][1]);
				setValueBuffer("idepigrafe", idEpigrafe);
				setValueBuffer("codepigrafe", datos[i][2]);
				setValueBuffer("codejercicio", codEjercicio);
				commitBuffer();
			}

	}
	util.destroyProgressDialog();


	// SUBCUENTAS (sólo las que vienen directas de cuenta: XXX000000)
	var datos:Array = this.iface.datosCuentas();
	curCbl = new FLSqlCursor("co_subcuentas");
	curCbl.setActivatedCheckIntegrity(false);

	util.createProgressDialog(util.translate("scripts", "Actualizando subcuentas"), datos.length);

	for (i = 0; i < datos.length; i++) {
		util.setProgress(i);

		codSubcuenta = datos[i][0];
		numCeros = longSubcuenta - codSubcuenta.toString().length;
		for (var i = 0; i < numCeros; i++)
			codSubcuenta += "0";

		curCbl.select("codsubcuenta = '" + codSubcuenta + "' AND codejercicio = '" + codEjercicio + "'");
		if (curCbl.first()) {
				with(curCbl) {
				setModeAccess(curCbl.Edit);
				refreshBuffer();
				setValueBuffer("descripcion", datos[i][1]);
				commitBuffer();
			}
		}

	}
	util.destroyProgressDialog();

	// SUBCUENTAS QUE FALTAN TRAS CREAR LAS CUENTAS
	this.iface.generarSubcuentas(codEjercicio, longSubcuenta);

	// CÓDIGOS DE BALANCE abreviado
	util.sqlDelete("co_cuentascbba", "");
	util.sqlDelete("co_cuentascb", "");
	util.sqlDelete("co_codbalances08", "");

	// CÓDIGOS DE BALANCE
	this.iface.generarCodigosBalance2008();
	this.iface.actualizarCuentas2008(codEjercicio);
	this.iface.actualizarCuentas2008ba(codEjercicio);

	this.iface.actualizarCuentasDigitos(codEjercicio);

	MessageBox.information(util.translate("scripts",  "Proceso finalizado"), MessageBox.Ok, MessageBox.NoButton);
}


/**
Las cuentas de 4 dígitos prevalecen sobre las de 3 dígitos. Ej: 830 desaparece y queda 8300
*/
function pgc2008_actualizarCuentasDigitos(codEjercicio:String)
{
	var curCbl:FLSqlCursor;
	var util:FLUtil = new FLUtil;
	var curCbl:FLSqlCursor;
	var codCuenta:String, codCuenta3:String, lastCodCuenta3:String = "";
	var paso:Number = 0;

	curCbl = new FLSqlCursor("co_cuentas");

	curCbl.select("codejercicio = '" + codEjercicio + "' ORDER BY codcuenta");
	util.createProgressDialog(util.translate("scripts", "Actualizando cuentas por dígitos"), curCbl.size());

	while (curCbl.next()) {

		util.setProgress(paso++);

		idCuenta = curCbl.valueBuffer("idcuenta");
		codCuenta = curCbl.valueBuffer("codcuenta");

		if (codCuenta.length != 4)
			continue;

		codCuenta3 = codCuenta.left(3);

		if (codCuenta3 == lastCodCuenta3)
			continue;

		lastCodCuenta3 = codCuenta3;

		idCuenta3 = util.sqlSelect("co_cuentas", "idcuenta", "codcuenta = '" + codCuenta3 + "' AND codejercicio = '" + codEjercicio + "'");
		if (!idCuenta3)
			continue;

		// Migrar las subcuentas dependientes
 		util.sqlUpdate("co_subcuentas", "idcuenta,codcuenta", idCuenta + "," + codCuenta, "idcuenta = " + idCuenta3);
 		util.sqlUpdate("series", "idcuenta", idCuenta, "idcuenta = " + idCuenta3)
	}

	util.destroyProgressDialog();
}




//// PGC 2008 //////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

