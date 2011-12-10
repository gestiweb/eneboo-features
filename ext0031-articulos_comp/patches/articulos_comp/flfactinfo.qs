
/** @class_declaration articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class articuloscomp extends oficial /** %from: oficial */ {
    function articuloscomp( context ) { oficial ( context ); }
	function crearTabla(tipoDoc:String,idDoc:Number):Boolean {
		return this.ctx.articuloscomp_crearTabla(tipoDoc,idDoc);
	}
	function crearLinea(referencia:String,cantidad:Number,idLinea:Number):Boolean {
		return this.ctx.articuloscomp_crearLinea(referencia,cantidad,idLinea);
	}
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubarticuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
class pubarticuloscomp extends ifaceCtx /** %from: ifaceCtx */ {
    function pubarticuloscomp( context ) { ifaceCtx ( context ); }
	function pub_crearTabla(tipoDoc:String,idDoc:Number):Boolean {
		return this.crearTabla(tipoDoc,idDoc);
	}
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition articuloscomp */
/////////////////////////////////////////////////////////////////
//// ARTICULOSCOMP //////////////////////////////////////////////
function articuloscomp_crearTabla(tipoDoc:String,idDoc:Number):Boolean
{
	var util:FLUtil = new FLUtil();
	var qLineas:FLSqlQuery = new FLSqlQuery();
	var tabla:String;
	var id:String;
	var referencia:String;

	util.sqlDelete("i_articuloscomp_buffer","1=1");

	switch(tipoDoc){
		case "FC":{
			tabla = "lineasfacturascli";
			id = "idfactura";
			break;
		}
		case "FP":{
			tabla = "lineasfacturasprov";
			id = "idfactura";
			break;
		}
		case "AC":{
			tabla = "lineasalbaranescli";
			id = "idalbaran";
			break;
		}
		case "AP":{
			tabla = "lineasalbaranesprov";
			id = "idalbaran";
			break;
		}
		case "PC":{
			tabla = "lineaspedidoscli";
			id = "idpedido";
			break;
		}
		case "PP":{
			tabla = "lineaspedidosprov";
			id = "idpedido";
			break;
		}
		case "PR":{
			tabla = "lineaspresupuestoscli";
			id = "idpresupuesto";
			break;
		}
		default: return false;
	}

	qLineas.setTablesList(tabla);
	qLineas.setSelect("referencia,idlinea,cantidad");
	qLineas.setFrom(tabla);
	qLineas.setWhere(id + " = '" + idDoc + "'");

	if(!qLineas.exec())
		return false;

	while (qLineas.next()) {
		referencia = qLineas.value(0);
		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("articuloscomp");
		q.setSelect("refcomponente,cantidad");
		q.setFrom("articuloscomp");
		q.setWhere("refcompuesto = '" + referencia + "'");

		if(!q.exec())
		return false;

		while (q.next()){
			var cantidad:Number = parseFloat(qLineas.value(2)) * parseFloat(q.value(1));
			if(!this.iface.crearLinea(q.value(0),cantidad,qLineas.value(1)))
				return false;
		}
	}

	return true;
}

function articuloscomp_crearLinea(refcomponente:String,cantidad:Number,idLinea:Number):Boolean
{
		var util:FLUtil = new FLUtil();
		var cantidad2:Number;

		var q:FLSqlQuery = new FLSqlQuery();
		q.setTablesList("articuloscomp");
		q.setSelect("refcomponente,cantidad,codunidad");
		q.setFrom("articuloscomp");
		q.setWhere("refcompuesto = '" + refcomponente + "'");

		if(!q.exec())
			return false;

		if(!q.first()){
			var curLinea:FLSqlCursor = new FLSqlCursor("i_articuloscomp_buffer");
			with(curLinea) {
				setModeAccess(Insert);
				refreshBuffer();
				setValueBuffer("idlinea", idLinea);
				setValueBuffer("referencia", refcomponente);
				setValueBuffer("descripcion", util.sqlSelect("articulos","descripcion","referencia = '" + refcomponente + "'"));
				setValueBuffer("cantidad", cantidad);
				setValueBuffer("codunidad", util.sqlSelect("articulos","codunidad","referencia = '" + refcomponente + "'"));
			}
			if (!curLinea.commitBuffer())
				return false;
		} else
			do {
				cantidad2 = cantidad * parseFloat(q.value(1));
				if(!this.iface.crearLinea(q.value(0), cantidad2, idLinea))
					return false;
			} while (q.next());

		return true;
}
//// ARTICULOSCOMP //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

