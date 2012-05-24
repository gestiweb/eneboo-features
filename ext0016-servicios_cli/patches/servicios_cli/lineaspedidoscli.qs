
/** @class_declaration serviciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
class serviciosCli extends oficial /** %from: oficial */ {
    function serviciosCli( context ) { oficial ( context ); }
	function datosTablaPadre(cursor:FLSqlCursor):Array {
		return this.ctx.serviciosCli_datosTablaPadre(cursor);
	}
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition serviciosCli */
/////////////////////////////////////////////////////////////////
//// SERVICIOS CLI //////////////////////////////////////////////
function serviciosCli_datosTablaPadre(cursor:FLSqlCursor):Array
{
	var datos:Array;
	switch (cursor.table()) {
		case "lineasservicioscli": {
			datos.where = "idservicio = "+ cursor.valueBuffer("idservicio");
			datos.tabla = "servicioscli";
			break;
		}
		default: {
			return this.iface.__datosTablaPadre(cursor);
		}
	}
	var curRel:FLSqlCursor = cursor.cursorRelation();
	if (curRel && curRel.table() == datos.tabla) {
		datos["tasaconv"] = curRel.valueBuffer("tasaconv");
		datos["codcliente"] = curRel.valueBuffer("codcliente");
		datos["fecha"] = curRel.valueBuffer("fecha");
		datos["codserie"] = curRel.valueBuffer("codserie");
		datos["porcomision"] = curRel.valueBuffer("porcomision");
		datos["codagente"] = curRel.valueBuffer("codagente");
	} else {
		var qryDatos:FLSqlQuery = new FLSqlQuery;
		qryDatos.setTablesList(datos.tabla);
		qryDatos.setSelect("codcliente, fecha, codserie, porcomision, codagente, tasaconv");
		qryDatos.setFrom(datos.tabla);
		qryDatos.setWhere(datos.where);
		qryDatos.setForwardOnly(true);
		if (!qryDatos.exec()) {
			return false;
		}
		if (!qryDatos.first()) {
			return false;
		}
		datos["tasaconv"] = qryDatos.value("tasaconv");
		datos["codcliente"] = qryDatos.value("codcliente");
		datos["fecha"] = qryDatos.value("fecha");
		datos["codserie"] = qryDatos.value("codserie");
		datos["porcomision"] = qryDatos.value("porcomision");
		datos["codagente"] = qryDatos.value("codagente");
	}
	return datos;
}
//// SERVICIOS CLI //////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

