
/** @class_declaration cambioIva */
/////////////////////////////////////////////////////////////////
//// CAMBIO_IVA /////////////////////////////////////////////////
class cambioIva extends oficial /** %from: oficial */ {
	var curLineaDoc_:FLSqlCursor;
	function cambioIva( context ) { oficial ( context ); }
	function campoImpuesto(campo:String, codImpuesto:String, fecha:String):Number {
		return this.ctx.cambioIva_campoImpuesto(campo, codImpuesto, fecha);
	}
	function datosImpuesto(codImpuesto:String, fecha:String):Array {
		return this.ctx.cambioIva_datosImpuesto(codImpuesto, fecha);
	}
	function validarIvas(curDoc:FLSqlCursor):Boolean {
		return this.ctx.cambioIva_validarIvas(curDoc);
	}
	function actualizarIvaLineasFecha(tabla:String, nombrePK:String, valorClave:String, fecha:String):Boolean {
		return this.ctx.cambioIva_actualizarIvaLineasFecha(tabla, nombrePK, valorClave, fecha);
	}
	function datosLineaDocIva():Boolean {
		return this.ctx.cambioIva_datosLineaDocIva();
	}
}
//// CAMBIO_IVA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubCambioIva */
/////////////////////////////////////////////////////////////////
//// PUB CAMBIO IVA /////////////////////////////////////////////
class pubCambioIva extends ifaceCtx /** %from: ifaceCtx */ {
	function pubCambioIva( context ) { ifaceCtx( context ); }
	function pub_validarIvas(curDoc:FLSqlCursor):Boolean {
		return this.validarIvas(curDoc);
	}
}
//// PUB CAMBIO IVA /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition cambioIva */
/////////////////////////////////////////////////////////////////
//// CAMBIO_IVA /////////////////////////////////////////////////
function cambioIva_campoImpuesto(campo:String, codImpuesto:String, fecha:String):Number
{
	var util:FLUtil = new FLUtil;
	var valor:Number;
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("periodos");
	qry.setSelect("fechadesde, fechahasta, iva, recargo");
	qry.setFrom("periodos");
	qry.setWhere("codimpuesto = '" + codImpuesto + "' AND fechadesde <= '" + fecha + "'");
	try { qry.setForwardOnly( true ); } catch (e) {}

	if (!qry.exec()) {
		throw("Error al ejecutar consulta en cambioIva_campoImpuesto");
	}
	var iva:Number;
	var recargo:Number;
	var existe_rango_valido:Boolean = false;

	while (qry.next()) {
		if (qry.value("fechahasta") && (util.daysTo(fecha,qry.value("fechahasta")) < 0)) {
			continue;
		}
		iva = qry.value("iva");
		recargo = qry.value("recargo");
		existe_rango_valido = true;
	}
	if (!existe_rango_valido) {
	    return this.iface.__campoImpuesto(campo, codImpuesto, fecha);
	}
	switch(campo) {
	    case "iva": return iva; break;
	    case "recargo": return regargo; break;
	    default: throw("campo <" + campo + "> no reconocido en cambioIva_campoImpuesto"); break;
	}
}

function cambioIva_datosImpuesto(codImpuesto:String, fecha:String):Array
{
	var util:FLUtil = new FLUtil;
	var datosImpuesto:Array;
	var qry:FLSqlQuery = new FLSqlQuery();
	qry.setTablesList("periodos");
	qry.setSelect("fechadesde, fechahasta, iva, recargo");
	qry.setFrom("periodos");
	qry.setWhere("codimpuesto = '" + codImpuesto + "' AND fechadesde <= '" + fecha + "'");
	try { qry.setForwardOnly( true ); } catch (e) {}

	if (!qry.exec()) {
		return false;
	}
	var iva:Number;
	var recargo:Number;
	while (qry.next()) {
		if (qry.value("fechahasta") && (util.daysTo(fecha,qry.value("fechahasta")) < 0)) {
			continue;
		}
		iva = qry.value("iva");
		recargo = qry.value("recargo");
	}

	datosImpuesto.iva = iva;
	datosImpuesto.recargo = recargo;
	return datosImpuesto;
}

/** \D Comprueba que los porcentaje de IVA son los vigentes para el documento indicado
@param curDoc: Cursor posicionado en el documento
\end */
function cambioIva_validarIvas(curDoc:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var tabla:String = curDoc.table();
	var nombrePK:String = curDoc.primaryKey();
	var valorClave:String = curDoc.valueBuffer(nombrePK);
	var tablaLineas:String;
	switch (tabla) {
		case "presupuestoscli": { tablaLineas = "lineaspresupuestoscli"; break; }
		case "pedidoscli": { tablaLineas = "lineaspedidoscli"; break; }
		case "albaranescli": { tablaLineas = "lineasalbaranescli"; break; }
		case "facturascli": { tablaLineas = "lineasfacturascli"; break; }
		case "pedidosprov": { tablaLineas = "lineaspedidosprov"; break; }
		case "albaranesprov": { tablaLineas = "lineasalbaranesprov"; break; }
		case "facturasprov": { tablaLineas = "lineasfacturasprov"; break; }
		default: { return -1; }
	}
	var qryLineas:FLSqlQuery = new FLSqlQuery();
	qryLineas.setTablesList(tablaLineas);
	qryLineas.setSelect("codimpuesto, iva, recargo");
	qryLineas.setFrom(tablaLineas);
	qryLineas.setWhere(nombrePK + " = " + valorClave + " GROUP BY codimpuesto, iva, recargo");
	qryLineas.setForwardOnly(true);
	if (!qryLineas.exec()) {
		return false;
	}
	var fecha:String = curDoc.valueBuffer("fecha");
	var codImpuesto:String, iva:Number, recargo:Number, valorActualIva:Number, valorActualRecargo:Number;
	while (qryLineas.next()) {
		codImpuesto = qryLineas.value("codimpuesto");
		if (!codImpuesto || codImpuesto == "") {
			continue;
		}
		iva = qryLineas.value("iva");
		if (!isNaN(iva) && iva != 0) {
			valorActualIva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha);
			if (valorActualIva != iva) {
				var res:Number = MessageBox.warning(util.translate("scripts", "Alguna de las líneas contiene un valor de IVA no adecuado a la fecha del documento.\n¿Desea recalcular automáticamente estos valores?"), MessageBox.Yes, MessageBox.No, MessageBox.Ignore);
				switch (res) {
					case MessageBox.Yes: {
						if (!this.iface.actualizarIvaLineasFecha(tablaLineas, nombrePK, valorClave, fecha)) {
							return -1;
						}
						return 1;
					}
					case MessageBox.No: {
						return -1;
					}
					case MessageBox.Ignore: {
						return 0;
					}
				}
			}
		}
		recargo = qryLineas.value("recargo");
		if (!isNaN(recargo) && recargo != 0) {
			valorActualRecargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha);
			if (valorActualRecargo != recargo) {
				var res:Number = MessageBox.warning(util.translate("scripts", "Alguna de las líneas contiene un valor de Recargo de Equivalencia no adecuado a la fecha del documento.\n¿Desea recalcular automáticamente estos valores?"), MessageBox.Yes, MessageBox.No, MessageBox.Ignore);
				switch (res) {
					case MessageBox.Yes: {
						if (!this.iface.actualizarIvaLineasFecha(tablaLineas, nombrePK, valorClave, fecha)) {
							return -1;
						}
						return 1;
					}
					case MessageBox.No: {
						return -1;
					}
					case MessageBox.Ignore: {
						return 0;
					}
				}
			}
		}
	}

	return 0;
}

function cambioIva_actualizarIvaLineasFecha(tabla:String, nombrePK:String, valorClave:String, fecha:String):Boolean
{
	if (this.iface.curLineaDoc_) {
		delete this.iface.curLineaDoc_;
	}
	this.iface.curLineaDoc_ = new FLSqlCursor(tabla);
	this.iface.curLineaDoc_.setActivatedCommitActions(false);
	this.iface.curLineaDoc_.setActivatedCheckIntegrity(false);
	this.iface.curLineaDoc_.select(nombrePK + " = " + valorClave);

	var codImpuesto:String, iva:Number, recargo:Number, valorActualIva:Number, valorActualRecargo:Number;
	var cambiado:Boolean;
	while (this.iface.curLineaDoc_.next()) {
		cambiado = false;
		this.iface.curLineaDoc_.setModeAccess(this.iface.curLineaDoc_.Edit);
		this.iface.curLineaDoc_.refreshBuffer();
		codImpuesto = this.iface.curLineaDoc_.valueBuffer("codimpuesto");
		if (!codImpuesto || codImpuesto == "") {
			continue;
		}
		iva = this.iface.curLineaDoc_.valueBuffer("iva");
		if (!isNaN(iva) && iva != 0) {
			valorActualIva = flfacturac.iface.pub_campoImpuesto("iva", codImpuesto, fecha);
			if (valorActualIva != iva) {
				this.iface.curLineaDoc_.setValueBuffer("iva", valorActualIva);
				cambiado = true;
			}
		}
		recargo = this.iface.curLineaDoc_.valueBuffer("recargo");
		if (!isNaN(recargo) && recargo != 0) {
			valorActualRecargo = flfacturac.iface.pub_campoImpuesto("recargo", codImpuesto, fecha);
			if (valorActualRecargo != recargo) {
				this.iface.curLineaDoc_.setValueBuffer("recargo", valorActualRecargo);
				cambiado = true;
			}
		}
		if (cambiado) {
			if (!this.iface.datosLineaDocIva()) {
				return false;
			}
			if (!this.iface.curLineaDoc_.commitBuffer()) {
				return false;
			}
		}
	}
	return true;
}

function cambioIva_datosLineaDocIva():Boolean
{
	return true;
}
//// CAMBIO_IVA /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

