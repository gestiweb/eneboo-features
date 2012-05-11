
/** @class_declaration personaFisica */
/////////////////////////////////////////////////////////////////
//// PERSONA_FISICA /////////////////////////////////////////////
class personaFisica extends fluxEcommerce /** %from: oficial */ {
    function personaFisica( context ) { fluxEcommerce ( context ); }
	function init() {
		return this.ctx.personaFisica_init();
	}
	function bufferChanged(fN:String) {
		return this.ctx.personaFisica_bufferChanged(fN);
	}
	function habilitarNombre() {
		return this.ctx.personaFisica_habilitarNombre();
	}
	function copiarNombre() {
		return this.ctx.personaFisica_copiarNombre();
	}
	function insertarNombre() {
		return this.ctx.personaFisica_insertarNombre();
	}
	function eliminarNombre() {
		return this.ctx.personaFisica_eliminarNombre();
	}
	function informarNombreJuridico() {
		return this.ctx.personaFisica_informarNombreJuridico();
	}
}
//// PERSONA_FISICA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition personaFisica */
/////////////////////////////////////////////////////////////////
//// PERSONA_FISICA /////////////////////////////////////////////
function personaFisica_init()
{
	this.iface.__init();

	connect(this.child("tbnInsertarNombre"), "clicked()", this, "iface.insertarNombre()");
	connect(this.child("tbnEliminarNombre"), "clicked()", this, "iface.eliminarNombre()");
	this.iface.habilitarNombre();
}

function personaFisica_bufferChanged(fN)
{
	var cursor:FLSqlCursor = this.cursor();
	switch(fN) {
		case "personafisica": {
			this.iface.habilitarNombre();
			this.iface.copiarNombre();
			break;
		}
		case "nombrepila":
		case "apellidos": {
			this.iface.informarNombreJuridico();
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
			break;
		}
	}
}

function personaFisica_habilitarNombre()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("personafisica")) {
		this.child("gbxNombre").close();
		this.child("gbxNombreApellidos").show();
	} else {
		this.child("gbxNombre").show();
		this.child("gbxNombreApellidos").close();
	}
}

function personaFisica_copiarNombre()
{
	var cursor:FLSqlCursor = this.cursor();
	if (cursor.valueBuffer("personafisica") && cursor.valueBuffer("apellidos") == "") {
		this.child("fdbApellidos").setValue(cursor.valueBuffer("nombre"));
	}
}

function personaFisica_insertarNombre()
{
	var cursor:FLSqlCursor = this.cursor();
	var i:Number;
	var nombrePila:String = cursor.valueBuffer("nombrepila");
	var apellidos:String = cursor.valueBuffer("apellidos");
	if (!apellidos) {
		apellidos = "";
		return;
	}
	if (!nombrePila) {
		nombrePila = "";
	}
	var palabra:String;
	var iEspacio:Number = apellidos.find(" ");
	if (iEspacio != - 1) {
		palabra = apellidos.substring(0, iEspacio);
		apellidos = apellidos.right(apellidos.length - iEspacio -1);
	} else {
		palabra = cursor.valueBuffer("apellidos");
		apellidos = "";
	}

	if (nombrePila == "") {
		nombrePila = palabra;
	} else {
		nombrePila = nombrePila + " " + palabra;
	}

	this.child("fdbNombrePila").setValue(nombrePila);
	this.child("fdbApellidos").setValue(apellidos);
}

function personaFisica_eliminarNombre()
{
	var cursor:FLSqlCursor = this.cursor();
	var i:Number;
	var nombrePila:String = cursor.valueBuffer("nombrepila");
	var apellidos:String = cursor.valueBuffer("apellidos");
	if (!nombrePila) {
		nombrePila = "";
		return;
	}
	if (!apellidos) {
		apellidos = "";
	}
	var iEspacio:Number = nombrePila.findRev(" ");
	var palabra:String = nombrePila.substring(iEspacio + 1, nombrePila.length);
	if (apellidos == "") {
		apellidos = palabra;
	} else {
		apellidos = palabra + " " + apellidos;
	}
	if (iEspacio == -1) {
		nombrePila = "";
	} else {
		nombrePila = nombrePila.left(iEspacio);
	}
	this.child("fdbNombrePila").setValue(nombrePila);
	this.child("fdbApellidos").setValue(apellidos);
}

function personaFisica_informarNombreJuridico()
{
	var cursor:FLSqlCursor = this.cursor();
	var nombrePila:String = cursor.valueBuffer("nombrepila");
	if (!nombrePila) {
		nombrePila = "";
	}
	var apellidos:String = cursor.valueBuffer("apellidos");
	if (!apellidos) {
		apellidos = "";
	}
	if (cursor.valueBuffer("personafisica")) {
		var nombre:String = apellidos + " " + nombrePila;
		this.child("fdbNombre").setValue(nombre);
	}
}

//// PERSONA_FISICA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

