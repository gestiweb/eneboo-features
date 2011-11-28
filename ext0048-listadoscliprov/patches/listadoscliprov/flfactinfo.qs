
/** @class_declaration infoCliProv */
/////////////////////////////////////////////////////////////////
//// INFOCLIPROV //////////////////////////////////////////////////
class infoCliProv extends oficial {
	var idInformeActual:Number;
	function infoCliProv( context ) { oficial ( context ); }
	function cabeceraClientes(nodo:FLDomNode, campo:String):String {
		return this.ctx.infoCliProv_cabeceraClientes(nodo, campo);
	}
	function cabeceraProveedores(nodo:FLDomNode, campo:String):String {
		return this.ctx.infoCliProv_cabeceraProveedores(nodo, campo);
	}
	function establecerId(id:Number) {
		return this.ctx.infoCliProv_establecerId(id);
	}
}
//// INFOCLIPROV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubInfoCliProv */
/////////////////////////////////////////////////////////////////
//// PUBINFOCLIPROV //////////////////////////////////////////////////
class pubInfoCliProv extends infoCliProv {
	function pubInfoCliProv( context ) { infoCliProv ( context ); }
	function pub_cabeceraClientes(nodo:FLDomNode, campo:String):String {
		return this.cabeceraClientes(nodo, campo);
	}
	function pub_cabeceraProveedores(nodo:FLDomNode, campo:String):String {
		return this.cabeceraProveedores(nodo, campo);
	}
	function pub_establecerId(id:Number) {
		return this.establecerId(id);
	}
}

//// PUBINFOCLIPROV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition infoCliProv */
/////////////////////////////////////////////////////////////////
//// INFOCLIPROV //////////////////////////////////////////////////

function infoCliProv_cabeceraClientes(nodo:FLDomNode, campo:String):String
{
	var texCampo:String = new String(campo);

	var util:FLUtil = new FLUtil();

	var texto:String;
	var sep:String = "       ";

	var cri:Array = flfactppal.iface.pub_ejecutarQry("i_clientes", "descripcion,d_clientes_codcliente,h_clientes_codcliente,i_clientes_codagente,i_clientes_codgrupo,i_clientes_codserie,i_clientes_regimeniva,i_dirclientes_codpais","id = '" + this.iface.idInformeActual + "'");

	texto = " " + cri.descripcion + sep + sep;

	if (cri.d_clientes_codcliente || cri.h_clientes_codcliente)
		texto += util.translate("scripts","Clientes");
	
	if (cri.d_clientes_codcliente)		
		texto += " " + util.translate("scripts","desde") + " " + cri.d_clientes_codcliente;
	
	if (cri.h_clientes_codcliente)
		texto += " " + util.translate("scripts","hasta") + " " + cri.h_clientes_codcliente;

	if (cri.i_clientes_codagente)
		texto += sep + util.translate("scripts","Agente") + " " + cri.i_clientes_codagente;

	if (cri.i_clientes_codgrupo)
		texto += sep + util.translate("scripts","Grupo") + " " + cri.i_clientes_codgrupo;

	if (cri.i_clientes_codserie)	
		texto += sep + util.translate("scripts","Serie de facturación") + " " + cri.i_clientes_codserie;

	if (cri.i_clientes_regimeniva && cri.i_clientes_regimeniva != util.translate("scripts","Todos"))
		texto += sep + util.translate("scripts","Régimen I.V.A.") + " " + cri.i_clientes_regimeniva;

	if (cri.i_dirclientes_codpais)
		texto += sep + util.translate("scripts","País") + " " + cri.i_dirclientes_codpais;

	return texto;
}

function infoCliProv_cabeceraProveedores(nodo:FLDomNode, campo:String):String
{
	var texCampo:String = new String(campo);

	var util:FLUtil = new FLUtil();

	var texto:String;
	var sep:String = "       ";

	var cri:Array = flfactppal.iface.pub_ejecutarQry("i_proveedores", "descripcion,d_proveedores_codproveedor,h_proveedores_codproveedor,i_proveedores_codserie,i_proveedores_regimeniva,i_dirproveedores_codpais","id = '" + this.iface.idInformeActual + "'");

	texto = " " + cri.descripcion + sep + sep;

	if (cri.d_proveedores_codproveedor || cri.h_proveedores_codproveedor)
		texto += util.translate("scripts","Proveedores");
	
	if (cri.d_proveedores_codproveedor)		
		texto += " " + util.translate("scripts","desde") + " " + cri.d_proveedores_codproveedor;
	
	if (cri.h_proveedores_codproveedor)
		texto += " " + util.translate("scripts","hasta") + " " + cri.h_proveedores_codproveedor;

	if (cri.i_proveedores_codserie)	
		texto += sep + util.translate("scripts","Serie de facturación") + " " + cri.i_proveedores_codserie;

	if (cri.i_proveedores_regimeniva && cri.i_proveedores_regimeniva != util.translate("scripts","Todos"))
		texto += sep + util.translate("scripts","Régimen I.V.A.") + " " + cri.i_proveedores_regimeniva;

	if (cri.i_dirproveedores_codpais)
		texto += sep + util.translate("scripts","País") + " " + cri.i_dirproveedores_codpais;

	return texto;
}

/** \D Establece el id del informe que está siendo impreso
*/
function infoCliProv_establecerId(id:Number) 
{
	this.iface.idInformeActual = id;
}

//// INFOCLIPROV //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
