/***************************************************************************
                 empresa.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
    copyright            : (C) 2004 by InfoSiAL S.L.
    email                : mail@infosial.com
 ***************************************************************************/
/***************************************************************************
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 ***************************************************************************/

/** @file */

/** @class_declaration interna */
////////////////////////////////////////////////////////////////////////////
//// DECLARACION ///////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////
class interna {
	var ctx:Object;
	function interna( context ) { this.ctx = context; }
	function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna 
{
	var tedResultados:Object;
	function oficial( context ) { interna( context ); }
	function imprimirResultados() {
		return this.ctx.oficial_imprimirResultados();
	}
	function recargarResultados():Boolean {
		return this.ctx.oficial_recargarResultados();
	}
	function codeBarra(longitud:Number, color:String):String {
		return this.ctx.oficial_codeBarra(longitud, color);
	}
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
	function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
	function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
//// INTERFACE  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition interna */
////////////////////////////////////////////////////////////////////////////
//// DEFINICION ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////
//// INTERNA /////////////////////////////////////////////////////

function interna_init()
{
	this.iface.tedResultados = this.child( "tedResultados" );
	
	connect( this.child( "pbnRecargarResultados"), "clicked()", this, "iface.recargarResultados" );
	connect( this.child( "pbnImprimirResultados"), "clicked()", this, "iface.imprimirResultados" );

	var cursor:FLSqlCursor = this.cursor();
	if (cursor.modeAccess() == cursor.Edit)
		this.iface.recargarResultados();
}


//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_recargarResultados():Boolean
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	
	var qWhere:String = "1=1";
	var titCriterios:String = "";
	var codHTML:String = "";
	var totalVisitas:Number = 0;
	var parcialVisitas:Number = 0;
	
	var datosDeUsuarios:String = cursor.valueBuffer("datosdeusuarios");
	
	var hoy = new Date();
	titCriterios += "<h3>" + util.translate("scripts", "Informe de visitas eStoreQ") + " - " + util.dateAMDtoDMA(hoy) + "</h3>";
	
	titCriterios += "<b>" + util.translate("scripts", "Usuarios: ") + "</b>";
	switch (datosDeUsuarios) {
		case "Registrados":
			qWhere += " AND (v.codcliente IS NOT NULL AND v.codcliente <> '')";
			titCriterios += util.translate("scripts", "Sólo usuarios registrados");
		break;
		case "No registrados":
			qWhere += " AND (v.codcliente IS NULL OR v.codcliente = '')";
			titCriterios += util.translate("scripts", "Sólo usuarios no registrados");
		break;
		default:
			titCriterios += util.translate("scripts", "Todos");
	}

	titCriterios += "<br>";
	
	var codCliente:String = cursor.valueBuffer("codcliente");
	if (codCliente) {
		qWhere += " AND c.codcliente = '" + codCliente + "'";
		titCriterios += "<b>" + util.translate("scripts", "Cliente: ") + "</b>";
		titCriterios += codCliente + " - " + util.sqlSelect("clientes", "nombre", "codcliente = '" + codCliente + "'");
		titCriterios += "<br>";
	}

	var codGrupo:String = cursor.valueBuffer("codgrupo");
	if (codGrupo && !codCliente) {
		qWhere += " AND c.codgrupo = '" + codGrupo + "'";
		titCriterios += "<b>" + util.translate("scripts", "Grupo de clientes: ") + "</b>";
		titCriterios += codGrupo + " - " + util.sqlSelect("gruposclientes", "nombre", "codgrupo = '" + codGrupo + "'");
		titCriterios += "<br>";
	}

	var referencia:String = cursor.valueBuffer("referencia");
	if (referencia) {
		qWhere += " AND a.referencia = '" + referencia + "'";
		titCriterios += "<b>" + util.translate("scripts", "Referencia: ") + "</b>";
		titCriterios += referencia + " - " + util.sqlSelect("articulos", "descripcion", "referencia = '" + referencia + "'");
		titCriterios += "<br>";
	}

	var codFamilia:String = cursor.valueBuffer("codfamilia");
	if (codFamilia && !codCliente) {
		qWhere += " AND a.codfamilia = '" + codFamilia + "'";
		titCriterios += "<b>" + util.translate("scripts", "Familia: ") + "</b>";
		titCriterios += codFamilia + " - " + util.sqlSelect("familias", "descripcion", "codfamilia = '" + codFamilia + "'");
		titCriterios += "<br>";
	}

	titCriterios += "<b>" + util.translate("scripts", "Datos por: ") + "</b>";

	var datosPor:String = cursor.valueBuffer("datospor");
	if (datosPor == "Referencia") {
		qWhere += " AND v.tabla = 'articulos'";
		titCriterios += util.translate("scripts", "Referencias");
	}
	else {
		qWhere += " AND v.tabla = 'familias'";
		titCriterios += util.translate("scripts", "Familias");
	}

	titCriterios += "<br>";
	codHTML += titCriterios + "<hr>";

	var qTablesList:String = "visitasweb,articulos,clientes,gruposclientes,articulos,familias";
	var	qFrom:String = "visitasweb v left join clientes c on v.codcliente = c.codcliente left join gruposclientes g on c.codgrupo = g.codgrupo left join articulos a on v.campo = a.referencia left join familias f on a.codfamilia = f.codfamilia";
	
	var campoGrupo:String;
	var qOrderBy:String;
	switch (cursor.valueBuffer("agruparpor")) {
		case "Cliente":
// 			qTablesList = "visitasweb,articulos,clientes";
// 			qFrom = "visitasweb v left join clientes c on v.codcliente = c.codcliente";
			qSelect = "sum(v.visitas),v.campo,c.codcliente,c.nombre";
			qGroupBy = " GROUP BY v.campo,c.codcliente,c.nombre";
			qOrderBy = " ORDER BY c.codcliente, v.campo";
			campoGrupo = "c.codcliente";
		break;
		case "Grupo de Clientes":
// 			qTablesList = "visitasweb,articulos,clientes,gruposclientes";
// 			qFrom = "visitasweb v left join clientes c on v.codcliente = c.codcliente left join gruposclientes g on c.codgrupo = g.codgrupo";
			qSelect = "sum(v.visitas),v.campo,g.codgrupo,g.nombre";
			qGroupBy = " GROUP BY v.campo,g.codgrupo,g.nombre";
			qOrderBy = " ORDER BY g.codgrupo, v.campo";
			campoGrupo = "g.codgrupo";
		break;
		case "Familia":
// 			qTablesList = "visitasweb,articulos,familias";
// 			qFrom = "visitasweb v left join articulos a on v.campo = a.referencia left join familias f on a.codfamilia = f.codfamilia";
			qSelect = "sum(v.visitas),v.campo,f.codfamilia,f.descripcion";
			qGroupBy = " GROUP BY v.campo,f.codfamilia,f.descripcion";
			qOrderBy = " ORDER BY f.codfamilia, v.campo";
			campoGrupo = "f.codfamilia";
		break;
		default:
			debug("DEFAULT");
// 			qTablesList = "visitasweb,articulos,clientes,gruposclientes";
// 			qFrom = "visitasweb v left join clientes c on v.codcliente = c.codcliente left join gruposclientes g on c.codgrupo = g.codgrupo";
			qSelect = "sum(v.visitas),v.campo";
			qGroupBy = " GROUP BY v.campo";
			qOrderBy = " ORDER BY v.campo";
			campoGrupo = "";
	}
	
	this.iface.tedResultados.clear();
	
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList(qTablesList);
 	q.setFrom(qFrom);
 	q.setSelect(qSelect);
 	q.setWhere(qWhere + qGroupBy + qOrderBy);

	q.exec();
	
	var totalVisitas:Number = util.sqlSelect(qFrom, "sum(visitas)", qWhere, qTablesList);
	var lastGrupo:String = "000000";
	var paso:Number = 0;
	
	codHTML += "<table>";
	
	while(q.next()) {
		
		if (campoGrupo && lastGrupo != q.value(campoGrupo)) {
		
			if (paso++) {
				porVisitas = util.buildNumber(100 * parcialVisitas / totalVisitas, "f", 2)
				codHTML += "<tr>";
				codHTML += "<th colspan=2>" + util.translate("scripts", "Total") + "</th>";
				codHTML += "<th align=\"right\">" + parcialVisitas + "</th>";
				codHTML += "<th align=\"right\">" + porVisitas + "%</th>";
				codHTML += "</tr>";
				codHTML += "<tr><td colspan=3>&nbsp;</td><tr>";
				
				parcialVisitas = 0;
			}
		
			codHTML += "<tr>";
			if (q.value(campoGrupo)) {
				codHTML += "<th>" + q.value(campoGrupo) + "</th>";
				codHTML += "<th>" + q.value(3) + "</th>";
			}
			else
				codHTML += "<th colspan=2>" + util.translate("scripts", "Sin determinar") + "</th>";
			codHTML += "<th align=\"right\">" + util.translate("scripts", "Visitas") + "</th>";
			codHTML += "</tr>";
		
			lastGrupo = q.value(campoGrupo);
		}
		
		porVisitas = util.buildNumber(100 * q.value(0) / totalVisitas, "f", 2);
				
		if (datosPor == "Referencia")
			descripcion = util.sqlSelect("articulos","descripcion", "referencia = '" + q.value(1) + "'");
		else
			descripcion = util.sqlSelect("familias","descripcion", "codfamilia = '" + q.value(1) + "'");
		
				
		codHTML += "<tr>";
		codHTML += "<td>" + q.value(1) + "</td>";
		codHTML += "<td>" + descripcion + "</td>";
		codHTML += "<td align=\"right\">" + q.value(0) + "</td>";
		codHTML += "<td align=\"right\">" + porVisitas + "%</td>";
// 		codHTML += "<td>" + this.iface.codeBarra(porVisitas) + "</td>";
		codHTML += "</tr>";
		
		parcialVisitas += q.value(0);
	
	}

	porVisitas = util.buildNumber(100 * parcialVisitas / totalVisitas, "f", 2)
	codHTML += "<tr>";
	codHTML += "<th colspan=2>" + util.translate("scripts", "Total") + "</th>";
	codHTML += "<th align=\"right\">" + parcialVisitas + "</th>";
	codHTML += "<th align=\"right\">" + porVisitas + "%</th>";
	codHTML += "</tr>";
	
	codHTML += "<tr><td colspan=3>&nbsp;</td><tr>";
	codHTML += "<tr><td colspan=3>&nbsp;</td><tr>";
	
	codHTML += "<tr>";
	codHTML += "<th colspan=2>" + util.translate("scripts", "TOTAL") + "</th>";
	codHTML += "<th align=\"right\">" + totalVisitas + "</th>";
	codHTML += "</tr>";
	
	codHTML += "</table>";
	
	if (q.size() == 0)
		codHTML = util.translate("scripts", "Sin resultados");
	
	this.iface.tedResultados.append(codHTML);
}

function oficial_codeBarra(longitud:Number, color:String):String
{
	if (!color)
		color = "#00F";

	longitud = Math.round(parseFloat(longitud * 4));

	var codHTML:String = "";
	codHTML += "<table cellspacing=0 cellpadding=0 width=\"" + longitud + "\" bgcolor=\"" + color + "\" height=\"5\"><tr><td>&nbsp;</td></tr></table>";
	
	return codHTML;
}

function oficial_imprimirResultados() 
{
	var tedResultados = this.child( "tedResultados" );

	if ( tedResultados.text.isEmpty() )
		return;

	sys.printTextEdit( tedResultados );
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
