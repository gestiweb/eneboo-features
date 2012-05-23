
/** @class_declaration funNumSerie */
//////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
class funNumSerie extends oficial {
	function funNumSerie( context ) { oficial( context ); } 
	function afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasalbaranesprov(curLA);
	}
	function afterCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasfacturasprov(curLF);
	}
	function afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasalbaranescli(curLA);
	}
	function afterCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_afterCommit_lineasfacturascli(curLF);
	}
	function beforeCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_beforeCommit_lineasfacturascli(curLF);
	}
	function beforeCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean {
		return this.ctx.funNumSerie_beforeCommit_lineasfacturasprov(curLF);
	}
	function actualizarLineaPedidoCli(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.funNumSerie_actualizarLineaPedidoCli(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
	function actualizarLineaPedidoProv(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean {
		return this.ctx.funNumSerie_actualizarLineaPedidoProv(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);
	}
}
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////



/** @class_definition funNumSerie */
/////////////////////////////////////////////////////////////////
//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////

/** \D El número de serie no puede ser nulo cuando el artículo lo requiere
*/
function funNumSerie_beforeCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean
{
//	if ( !this.iface.__beforeCommit_lineasfacturascli(curLF) )
//		return false;

	if (curLF.modeAccess() != curLF.Insert) 
		return true;	
	
	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
		
		if (!curLF.valueBuffer("numserie")) {
			MessageBox.warning(util.translate("scripts", "El número de serie en las líneas de factura no puede ser nulo para el artículo ") + curLF.valueBuffer("referencia"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
	}

	return true;
}

/** \D El número de serie no puede ser nulo cuando el artículo lo requiere
*/
function funNumSerie_beforeCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean
{
//	if ( !this.iface.__beforeCommit_lineasfacturasprov(curLF) )
//		return false;

	if (curLF.modeAccess() != curLF.Insert) 
		return true;	
	
	var util:FLUtil = new FLUtil;
	if (util.sqlSelect("articulos", "controlnumserie", "referencia = '" + curLF.valueBuffer("referencia") + "'")) {
		
		if (!curLF.valueBuffer("numserie")) {
			MessageBox.warning(util.translate("scripts", "El número de serie en las líneas de factura no puede ser nulo para el artículo ") + curLF.valueBuffer("referencia"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
			return false;
		}
		
	}
	
	return true;
}

/** \D Controla los números de serie en función de la eliminación o creación de líneas de remito
*/
function funNumSerie_afterCommit_lineasalbaranesprov(curLA:FLSqlCursor):Boolean
{
	if (!this.iface.__afterCommit_lineasalbaranesprov(curLA))
		return false;
		
	if (!curLA.valueBuffer("numserie")) return true;
	
	switch(curLA.modeAccess()) {
		
		case curLA.Insert:
		case curLA.Edit:
			if (!flfactalma.iface.insertarNumSerie(curLA.valueBuffer("referencia"), curLA.valueBuffer("numserie"), curLA.valueBuffer("idalbaran"), -1))
				return false;
			break;
		
		case curLA.Del: 
			if (!flfactalma.iface.borrarNumSerie(curLA.valueBuffer("referencia"), curLA.valueBuffer("numserie")))
				return false;
			break;
	}
	return true;
}

/** \D Controla los números de serie en función de la eliminación o creación
de líneas de factura en caso de que no se trate de una factura automática
*/
function funNumSerie_afterCommit_lineasfacturasprov(curLF:FLSqlCursor):Boolean
{
	if (!interna_afterCommit_lineasfacturasprov(curLF))
		return false;
	
	var util:FLUtil = new FLUtil;
	
	if (!curLF.valueBuffer("numserie")) return true;
	
	var automatica:Boolean = util.sqlSelect("facturasprov", "automatica", "idfactura = " + curLF.valueBuffer("idfactura"));
	
 	// Factura normal
	if (!automatica) {
	
		switch(curLF.modeAccess()) {
			
			case curLF.Insert:
				if (!flfactalma.iface.insertarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie"), -1, curLF.valueBuffer("idfactura")))
					return false;
				break;
			
			case curLF.Del:
				if (!flfactalma.iface.borrarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie")))
					return false;
				break;
		}
	}
	
 	// Factura automática. El número de serie ya está registrado
	else {
	
		switch(curLF.modeAccess()) {
			
			case curLF.Insert:
			case curLF.Edit:
				if (!flfactalma.iface.modificarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie"), "idfacturacompra", curLF.valueBuffer("idfactura")))
					return false;
				break;
		
			case curLF.Del:
				if (!flfactalma.iface.modificarNumSerie(curLF.valueBuffer("referencia"), curLF.valueBuffer("numserie"), "idfacturacompra", 0))
					return false;
				break;
		}
	}
	return true;
}

/** \D Actualiza el id de remito de compra para un número de serie.
*/
function funNumSerie_afterCommit_lineasalbaranescli(curLA:FLSqlCursor):Boolean
{
	if (!this.iface.__afterCommit_lineasalbaranescli(curLA))
		return false;
		
	if (!curLA.valueBuffer("numserie")) return true;
	
	var curNS:FLSqlCursor = new FLSqlCursor("numerosserie");
	
	switch(curLA.modeAccess()) {
		
		case curLA.Edit: 
			// Control cuando cambia un número por otro, se libera el primero
			if (curLA.valueBuffer("numserie") != curLA.valueBufferCopy("numserie")) {
				curNS.select("referencia = '" + curLA.valueBuffer("referencia") + "' AND numserie = '" + curLA.valueBufferCopy("numserie") + "'");
				if (curNS.first()) {
					curNS.setModeAccess(curNS.Edit);
					curNS.refreshBuffer();
					curNS.setValueBuffer("idalbaranventa", -1)
					curNS.setValueBuffer("vendido", "false")
					if (!curNS.commitBuffer()) return false;
				}
			}
		
		case curLA.Insert:
			curNS.select("referencia = '" + curLA.valueBuffer("referencia") + "' AND numserie = '" + curLA.valueBuffer("numserie") + "'");
			if (curNS.first()) {
				curNS.setModeAccess(curNS.Edit);
				curNS.refreshBuffer();
				curNS.setValueBuffer("idalbaranventa", curLA.valueBuffer("idalbaran"))
				curNS.setValueBuffer("vendido", "true")
				if (!curNS.commitBuffer()) return false;
			}
			
			
		break;
		
		case curLA.Del:
			curNS.select("referencia = '" + curLA.valueBuffer("referencia") + "' AND numserie = '" + curLA.valueBuffer("numserie") + "'");
			if (curNS.first()) {
				curNS.setModeAccess(curNS.Edit);
				curNS.refreshBuffer();
				curNS.setValueBuffer("idalbaranventa", -1)
				curNS.setValueBuffer("vendido", "false")
				if (!curNS.commitBuffer()) return false;
			}
			break;
	}
	return true;
}

/** \D Actualiza el id de la factura de compra para un número de serie.
*/
function funNumSerie_afterCommit_lineasfacturascli(curLF:FLSqlCursor):Boolean
{
	if (!interna_afterCommit_lineasfacturascli(curLF))
		return false;
		
	if (!curLF.valueBuffer("numserie")) return true;
	
	var util:FLUtil = new FLUtil();
	var curNS:FLSqlCursor = new FLSqlCursor("numerosserie");
	
	switch(curLF.modeAccess()) {
		case curLF.Edit:
			// Control cuando cambia un número por otro, se libera el primero
			if (curLF.valueBuffer("numserie") != curLF.valueBufferCopy("numserie")) {
				curNS.select("referencia = '" + curLF.valueBuffer("referencia") + "' AND numserie = '" + curLF.valueBufferCopy("numserie") + "'");
				if (curNS.first()) {
					curNS.setModeAccess(curNS.Edit);
					curNS.refreshBuffer();
					
					if (util.sqlSelect("facturascli", "decredito", "idfactura = " + curLF.valueBuffer("idfactura"))) {
						curNS.setValueBuffer("idfacturadevol", -1)
						curNS.setValueBuffer("vendido", "true")
					}
					else {
						curNS.setValueBuffer("idfacturaventa", -1)
						curNS.setValueBuffer("vendido", "false")
					}
					
					if (!curNS.commitBuffer()) return false;
				}
			}
			
		case curLF.Insert:
		
			curNS.select("referencia = '" + curLF.valueBuffer("referencia") + "' AND numserie = '" + curLF.valueBuffer("numserie") + "'");
			if (!curNS.first())
				break;
			
			curNS.setModeAccess(curNS.Edit);
			curNS.refreshBuffer();
			
			if (util.sqlSelect("facturascli", "decredito", "idfactura = " + curLF.valueBuffer("idfactura"))) {
				curNS.setValueBuffer("idfacturadevol", curLF.valueBuffer("idfactura"))
				curNS.setValueBuffer("vendido", "false")
			}
			else {
				curNS.setValueBuffer("idfacturaventa", curLF.valueBuffer("idfactura"))
				curNS.setValueBuffer("vendido", "true")
			}
			
			if (!curNS.commitBuffer()) return false;
			
			break;
		
		case curLF.Del:
			curNS.select("referencia = '" + curLF.valueBuffer("referencia") + "' AND numserie = '" + curLF.valueBuffer("numserie") + "' AND idalbaranventa IS NULL");
			if (curNS.first()) {
				curNS.setModeAccess(curNS.Edit);
				curNS.refreshBuffer();
				var util:FLUtil = new FLUtil();
				if (util.sqlSelect("facturascli", "decredito", "idfactura = " + curLF.valueBuffer("idfactura"))) {
					curNS.setValueBuffer("idfacturadevol", -1)
					curNS.setValueBuffer("vendido", "true")
				}
				else {
					curNS.setValueBuffer("idfacturaventa", -1)
					curNS.setValueBuffer("vendido", "false")
				}
				
				if (!curNS.commitBuffer()) return false;
			}
			break;
	}
	return true;
}

/** Verifica si la referencia es de número de serie, en cuyo caso la 
catidad servida sólo puede ser 1 en el remito
\end */
function funNumSerie_actualizarLineaPedidoCli(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	if (idLineaPedido == 0)
		return true;

	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + referencia + "'"))
		return this.iface.__actualizarLineaPedidoCli(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);

	
	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	curLineaPedido.setModeAccess(curLineaPedido.Edit);
	if (!curLineaPedido.first())
		return false;
			
	var query:FLSqlQuery = new FLSqlQuery();
	query.setTablesList("lineasalbaranescli");
	query.setSelect("SUM(cantidad)");
	query.setFrom("lineasalbaranescli");
	query.setWhere("idlineapedido = " + idLineaPedido + " AND referencia = '" + referencia + "'");
	
	if (!query.exec())
		return false;
	if (query.next())
		cantidadServida = parseFloat(query.value(0));
		
	curLineaPedido.setValueBuffer("totalenalbaran", cantidadServida);
	if (!curLineaPedido.commitBuffer())
		return false;
	
	return true;
}

/** Verifica si la referencia es de número de serie, en cuyo caso la 
catidad servida sólo puede ser 1 en el remito
\end */
function funNumSerie_actualizarLineaPedidoProv(idLineaPedido:Number, idPedido:Number, referencia:String, idAlbaran:Number, cantidadLineaAlbaran:Number):Boolean
{
	if (idLineaPedido == 0)
		return true;

	var util:FLUtil = new FLUtil();
	if (!util.sqlSelect("articulos", "controlnumserie", "referencia = '" + referencia + "'"))
		return this.iface.__actualizarLineaPedidoProv(idLineaPedido, idPedido, referencia, idAlbaran, cantidadLineaAlbaran);

	
	var curLineaPedido:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");
	curLineaPedido.select("idlinea = " + idLineaPedido);
	curLineaPedido.setModeAccess(curLineaPedido.Edit);
	if (!curLineaPedido.first())
		return false;
			
	var query:FLSqlQuery = new FLSqlQuery();
	query.setTablesList("lineasalbaranesprov");
	query.setSelect("SUM(cantidad)");
	query.setFrom("lineasalbaranesprov");
	query.setWhere("idlineapedido = " + idLineaPedido + " AND referencia = '" + referencia + "'");
	
	debug(query.sql());
	
	if (!query.exec())
		return false;
	if (query.next())
		cantidadServida = parseFloat(query.value(0));
		
	curLineaPedido.setValueBuffer("totalenalbaran", cantidadServida);
	if (!curLineaPedido.commitBuffer())
		return false;
	
	return true;
}

//// FUN_NUMEROS_SERIE /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

