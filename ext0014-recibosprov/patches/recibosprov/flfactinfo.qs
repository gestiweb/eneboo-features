
/** @class_declaration recibosProv */
/////////////////////////////////////////////////////////////////
//// RECIBOS PROV ///////////////////////////////////////////////
class recibosProv extends oficial {
    function recibosProv( context ) { oficial ( context ); }
	function aplicarCriterio(tabla:String, campo:String, valor:String, signo:String):String {
		return this.ctx.recibosProv_aplicarCriterio(tabla, campo, valor, signo);
	}
}
//// RECIBOS PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////




/** @class_definition recibosProv */
/////////////////////////////////////////////////////////////////
//// RECIBOS PROV ///////////////////////////////////////////////
function recibosProv_aplicarCriterio(tabla:String, campo:String, valor:String, signo:String):String
{
	var criterio:String = "";
	switch (tabla) {
		case "i_recibosprov": {
			switch (campo) {
				case "recibosprov.estado": {
					switch (valor) {
						case "Pendiente": {
							criterio = "recibosprov.estado IN ('Emitido', 'Devuelto')";
							break;
						}
					}
					break;
				}
			}
			break;
		}
	}

	if (criterio == "") {
		criterio = this.iface.__aplicarCriterio(tabla, campo, valor, signo);
	}
	return criterio;
}
//// RECIBOS PROV ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////



