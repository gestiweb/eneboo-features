/***************************************************************************
                      n43_procesoscas.qs  -  description
                             -------------------
    begin                : lun dic 7 2005
    copyright            : (C) 2005 by InfoSiAL S.L.
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
class interna
{
  var ctx;

  function interna(context)
  {
    this.ctx = context;
  }
  function init()
  {
    this.ctx.interna_init();
  }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  function oficial(context)
  {
    interna(context);
  }
  function obtenerPKRegistro(accion, filtro)
  {
    return this.ctx.oficial_obtenerPKRegistro(accion, filtro);
  }
  function accionDocumento()
  {
    return this.ctx.oficial_accionDocumento();
  }
  function selMovimientoPrueba()
  {
    this.ctx.oficial_selMovimientoPrueba();
  }
  function selDocumentoPrueba()
  {
    this.ctx.oficial_selDocumentoPrueba();
  }
  function appendLog(txt)
  {
    this.ctx.oficial_appendLog(txt);
  }
  function printLog()
  {
    this.ctx.oficial_printLog();
  }
  function similitud(regMov, regDoc, funcion)
  {
    return this.ctx.oficial_similitud(regMov, regDoc, funcion);
  }
  function comprobar()
  {
    this.ctx.oficial_comprobar();
  }
  function recordToArray(cur)
  {
    return this.ctx.oficial_recordToArray(cur);
  }
  function minimo(a, b, c)
  {
    return this.ctx.oficial_minimo(a, b, c);
  }
  function distanciaDL(s, t)
  {
    return this.ctx.oficial_distanciaDL(s, t);
  }
  function editarReglaCas()
  {
    this.ctx.oficial_editarReglaCas();
  }
  function normalizarCadena(cad)
  {
    return this.ctx.oficial_normalizarCadena(cad);
  }
  function insertarEjemplo()
  {
    this.ctx.oficial_insertarEjemplo();
  }
  function simularProceso()
  {
    this.ctx.oficial_simularProceso();
  }
  function obtenerCasaciones(accionDoc, filtroDoc, filtroMov, funcionSim)
  {
    return this.ctx.oficial_obtenerCasaciones(accionDoc, filtroDoc,
                                              filtroMov, funcionSim);
  }
  function mostrarCandidatosLog(candidatos, tablaDoc, umbral, tedLog)
  {
    this.ctx.oficial_mostrarCandidatosLog(candidatos, tablaDoc,
                                          umbral, tedLog);
  }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial
{
  function head(context)
  {
    oficial(context);
  }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head
{
  function ifaceCtx(context)
  {
    head(context);
  }
  function pub_appendLog(txt)
  {
    this.appendLog(txt);
  }
  function pub_distanciaDL(s, t)
  {
    return this.distanciaDL(s, t);
  }
  function pub_normalizarCadena(cad)
  {
    return this.normalizarCadena(cad);
  }
  function pub_obtenerCasaciones(accionDoc, filtroDoc, filtroMov, funcionSim)
  {
    return this.obtenerCasaciones(accionDoc, filtroDoc, filtroMov, funcionSim);
  }
}

const iface = new ifaceCtx(this);
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
  connect(this.child("pbMovimiento"), "clicked()", this, "iface.selMovimientoPrueba()");
  connect(this.child("pbDocumento"), "clicked()", this, "iface.selDocumentoPrueba()");
  connect(this.child("pbComprobar"), "clicked()", this, "iface.comprobar()");
  connect(this.child("pbPrint"), "clicked()", this, "iface.printLog()");
  connect(this.child("pbnEditarReglasCas"), "clicked()", this, "iface.editarReglaCas()");
  connect(this.child("pbEjemplo"), "clicked()", this, "iface.insertarEjemplo()");
  connect(this.child("pbSimular"), "clicked()", this, "iface.simularProceso()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_obtenerPKRegistro(accion, filtro)
{
  var ret;

  if (!accion || accion.isEmpty())
    return ret;

  var f = new FLFormSearchDB(accion);

  f.setMainWidget();

  if (filtro && !filtro.isEmpty())
    f.cursor().setMainFilter(filtro);

  ret = f.exec(f.cursor().primaryKey());

  return ret;
}

function oficial_accionDocumento()
{
  var d = this.child("fdbDocumento").value();
  var accion = "";

  switch (d) {
    case 0:
      accion = "pedidoscli";
      break;

    case 1:
      accion = "reciboscli";
      break;
  }

  return accion;
}

function oficial_selMovimientoPrueba()
{
  var pk = this.iface.obtenerPKRegistro("n43_movimientos",
                                        this.child("fdbFiltroMov").value());
  if (pk)
    this.child("lblMovimiento").text = pk;
}

function oficial_selDocumentoPrueba()
{
  var accion = this.iface.accionDocumento();
  var pk = this.iface.obtenerPKRegistro(accion,
                                        this.child("fdbFiltroDoc").value());
  if (pk)
    this.child("lblDocumento").text = pk;
}

function oficial_appendLog(txt: String)
{
  var log = this.child("tedLog");
  if (log)
    log.append(txt);
}

function oficial_printLog()
{
  var log = this.child("tedLog");
  if (log.text.isEmpty())
    return;
  sys.printTextEdit(log);
}

function oficial_similitud(regMov, regDoc, funcion)
{
  if (globalCalcularSimilitud == undefined)
    globalCalcularSimilitud = new Function("movimientos,documentos", funcion);
  return globalCalcularSimilitud(regMov, regDoc);
}

function oficial_comprobar()
{
  var util = new FLUtil();
  var curMov = new FLSqlCursor("n43_movimientos");
  var curDoc = new FLSqlCursor(this.iface.accionDocumento());

  var idMov = this.child("lblMovimiento").text;
  if (idMov.isEmpty()) {
    this.iface.appendLog("<font color=\"#ff0000\"><b>" +
                         util.translate("scripts", "DEBE SELECCIONAR UN MOVIMIENTO") +
                         "</b></font>");
    return;
  }

  var idDoc = this.child("lblDocumento").text;
  if (idDoc.isEmpty()) {
    this.iface.appendLog("<font color=\"#ff0000\"><b>" +
                         util.translate("scripts", "DEBE SELECCIONAR UN DOCUMENTO") +
                         "</b></font>");
    return;
  }

  curMov.select(curMov.primaryKey() + " = '" + idMov + "'");
  if (!curMov.first()) {
    this.iface.appendLog("<font color=\"#ff0000\"><b>" +
                         util.translate("scripts", "MOVIMIENTO NO VÁLIDO") +
                         "</b></font>");
    this.child("lblMovimiento").text = "";
    return;
  }

  curDoc.select(curDoc.primaryKey() + " = '" + idDoc + "'");
  if (!curDoc.first()) {
    this.iface.appendLog("<font color=\"#ff0000\"><b>" +
                         util.translate("scripts", "DOCUMENTO NO VÁLIDO") +
                         "</b></font>");
    this.child("lblDocumento").text = "";
    return;
  }

  var i = 0;
  var log = "";
  var regMov = this.iface.recordToArray(curMov);
  var camposMov = util.nombreCampos(curMov.table());

  log = "<table border=\"1\">";
  log += "<tr><th>Contenido del Movimiento</th></tr>";
  log += "<tr><th>Campo</th><th>Valor</th></tr>";

  for (i = 1; i < camposMov.length; ++i)
    log += "<tr><td>" + camposMov[i] + "</td><td>" +
           regMov[ camposMov[i] ] + "</td></tr>";
  log += "</table>";

  this.iface.appendLog(log);

  var regDoc = this.iface.recordToArray(curDoc);
  var camposDoc = util.nombreCampos(curDoc.table());

  log = "<table border=\"1\">";
  log += "<tr><th>Contenido del Documento</th></tr>";
  log += "<tr><th>Campo</th><th>Valor</th></tr>";

  for (i = 1; i < camposDoc.length; ++i)
    log += "<tr><td>" + camposDoc[i] + "</td><td>" +
           regDoc[ camposDoc[i] ] + "</td></tr>";
  log += "</table>";

  this.iface.appendLog(log);
  this.iface.appendLog("<hr>");
  this.iface.appendLog("Calculando similitud...<br>");
  this.iface.appendLog("<hr>");

  var funcionSimil = this.child("fdbReglaCas").editor().text;
  var similitud: Number;

  if (funcionSimil.isEmpty())
    this.iface.appendLog("<font color=\"#ff0000\"><b>" +
                         util.translate("scripts", "FUNCIÓN DE SIMILITUD NO DEFINIDA") +
                         "</b></font><br>");
  else
    similitud = this.iface.similitud(regMov, regDoc, funcionSimil);

  log = "<table border=\"1\">";
  log += "<tr><th>Nivel de similitud</th><th>" + similitud + "</th></tr>";
  log += "</table>";

  this.iface.appendLog(log);
}

function oficial_recordToArray(cur)
{
  var ret = [];

  if (!cur.isValid())
    return ret;

  var util = new FLUtil();
  var campos = util.nombreCampos(cur.table());

  if (campos) {
    for (var i = 1; i < campos.length; ++i) {
      ret[ campos[i] ] = cur.valueBuffer(campos[i]);
    }
  }

  return ret;
}

function oficial_minimo(a, b, c)
{
  var mi = a;
  if (b < mi)
    mi = b;
  if (c < mi)
    mi = c;
  return mi;
}

function oficial_distanciaDL(s, t)
{
  var n;
  var m;
  var i;
  var j;
  var s_i;
  var t_j;
  var cost;

  n = s.length;
  m = t.length;
  if (n == 0)
    return m;
  if (m == 0)
    return n;

  var d = new Array(n + 1);

  for (i = 0; i <= n; ++i) {
    d[i] = new Array(m + 1);
    d[i][0] = i;
  }

  for (j = 0; j <= m; ++j)
    d[0][j] = j;

  for (i = 1; i <= n; ++i) {
    s_i = s.charAt(i - 1);

    for (j = 1; j <= m; ++j) {
      t_j = t.charAt(j - 1);

      if (s_i == t_j)
        cost = 0;
      else
        cost = 1;

      d[i][j] = this.iface.minimo(d[i - 1][j] + 1, d[i][j - 1] + 1,
                                  d[i - 1][j - 1] + cost);
    }
  }

  return d[n][m];
}

function oficial_editarReglaCas()
{
  var code = this.child("fdbReglaCas").editor().text;
  var editor = new FLScriptEditor(code);

  this.setDisabled(true);
  editor.setCode(code);
  editor.exec();
  this.cursor().setValueBuffer("reglacas" , editor.code());

  this.setDisabled(false);
}

function oficial_normalizarCadena(cad)
{
  //  var ret = cad.replace(/[\.\s\t\,\-\:]/g, "");
  //  ret = ret.replace(/[ÁáÀà]/g, "A");
  //  ret = ret.replace(/[ÉéÈè]/g, "E");
  //  ret = ret.replace(/[ÍíÌì]/g, "O");
  //  ret = ret.replace(/[ÓóÒò]/g, "I");
  //  ret = ret.replace(/[ÚúÙù]/g, "U");
  //  return ret;

  var ret = cad.replace(/[\.\s\t\,\-\:]/g, "");
  ret = ret.replace(/[ÁáÀà]/g, "A");
  ret = ret.replace(/[ÉéÈè]/g, "E");
  ret = ret.replace(/[ÍíÌì]/g, "O");
  ret = ret.replace(/[ÓóÒò]/g, "I");
  ret = ret.replace(/[ÚúÙù]/g, "U");
  return ret;
}

function oficial_insertarEjemplo()
{
  var util = new FLUtil();

  var ans = MessageBox.warning(util.translate("scripts",
                                              "Se insertará código de ejemplo en el editor.\n\n¿Desea continuar?"),
                               MessageBox.Yes, MessageBox.No);

  if (ans != MessageBox.Yes)
    return;

  // ###
  var codigoEjemplo = this.cursor().valueBuffer("reglacas").toString();
  this.cursor().setValueBuffer("reglacas" , codigoEjemplo);
}

function oficial_simularProceso()
{
  var util = new FLUtil();
  var tablaDoc = this.iface.accionDocumento();
  var casaciones = this.iface.obtenerCasaciones();
  var umbral = this.cursor().valueBuffer("umbral");
  var masUmbral;
  var i;
  var j;

  util.createProgressDialog(util.translate("scripts",
                                           "Simulando proceso de casación de movimientos..."),
                            casaciones.length);
  util.setProgress(1);

  for (i = 0; i < casaciones.length; ++i) {
    var casacion = casaciones[i];

    masUmbral = 0;
    for (j = 2; j < casacion.length; j += 2) {
      if (casacion[j] >= umbral)
        ++masUmbral;
    }

    if (masUmbral == 0) {
      this.iface.mostrarCandidatosLog(casacion, tablaDoc, 0, this.child("tedImprobables"));
      continue;
    }

    if (masUmbral == 1) {
      this.iface.mostrarCandidatosLog(casacion, tablaDoc, umbral, this.child("tedPosibles"));
      continue;
    }

    if (masUmbral > 1) {
      this.iface.mostrarCandidatosLog(casacion, tablaDoc, umbral, this.child("tedDudosas"));
      continue;
    }

    util.setProgress(i + 1);
  }

  util.destroyProgressDialog();
}

function oficial_obtenerCasaciones(accionDoc, filtroDoc, filtroMov, funcionSim)
{
  globalCalcularSimilitud = undefined;

  var funcionSimil = (funcionSim == undefined)
                     ? this.child("fdbReglaCas").editor().text
                     : funcionSim;
  var curDoc = new FLSqlCursor(accionDoc == undefined
                               ? this.iface.accionDocumento()
                               : accionDoc);
  var curMov = new FLSqlCursor("n43_movimientos");

  curDoc.select(filtroDoc == undefined
                ? this.child("fdbFiltroDoc").value()
                : filtroDoc);
  curMov.select(filtroMov == undefined
                ? this.child("fdbFiltroMov").value()
                : filtroMov);

  var util = new FLUtil();
  var curDocSize = curDoc.size();
  var curMovSize = curMov.size();
  var similitud = 0;
  var maxSimil = 0;
  var i = 0;
  var j = 0;
  var k = 0;
  var steps = 1;
  var ret = new Array(curMovSize);
  var regsDoc = new Array(curDocSize);
  var pkDoc = curDoc.primaryKey();
  var regMov;
  var regDoc;
  var txtEstado = "";

  util.createProgressDialog(util.translate("scripts", "Obteniendo documentos candidatos..."),
                            curMovSize * curDocSize);
  while (curDoc.next()) {
    regDoc = this.iface.recordToArray(curDoc);
    regsDoc[k] = new Array(regDoc.length);
    regsDoc[k] = regDoc;
    util.setProgress(++k * curMovSize);
  }
  util.setProgress(steps);
  while (curMov.next()) {
    maxSimil = 0;
    regMov = this.iface.recordToArray(curMov);
    ret[i] = new Array(7);
    ret[i][0] = regMov.idmovimiento;
    for (j = 1; j < 7; ++j)
      ret[i][j] = 0;

    txtEstado = util.translate("scripts", "Buscando casasión para movimiento: \n\n");
    txtEstado += regMov.idmovimiento + "\n\n";
    txtEstado += this.iface.normalizarCadena(regMov.concepto11.upper()) + "\n\n";
    txtEstado += regMov.importe + "\n\n";
    util.setLabelText(txtEstado);

    for (k = 0; k < curDocSize; ++k) {
      similitud = this.iface.similitud(regMov, regsDoc[k], funcionSimil);
      if (similitud > maxSimil) {
        maxSimil = similitud;
        util.setLabelText(txtEstado +
                          util.translate("scripts", "Similitud máxima encontrada : ") +
                          maxSimil + "\n\n");
      }
      for (j = 2; j < 7; j += 2) {
        if (ret[i][j] < similitud) {
          ret[i][j - 1] = regsDoc[k][ pkDoc ];
          ret[i][j] = similitud;
          break;
        }
      }
      util.setProgress(++steps);
    }
    ret[i].maxSimil = maxSimil;
    ret[i].idDoc = undefined;
    ret[i].matched = false;
    ++i;
  }
  util.destroyProgressDialog();

  return ret;
}

function oficial_mostrarCandidatosLog(candidatos, tablaDoc, umbral, tedLog)
{
  var util = new FLUtil();
  var curMov = new FLSqlCursor("n43_movimientos");
  var curDoc = new FLSqlCursor(tablaDoc);

  var idMov = candidatos[0];

  if (!idMov)
    return;

  curMov.select(curMov.primaryKey() + " = '" + idMov + "'");
  if (!curMov.first())
    return;

  var i;
  var log = "";
  var regMov = this.iface.recordToArray(curMov);
  var camposMov = util.nombreCampos(curMov.table());

  log = "<table border=\"1\">";
  log += "<tr><th>Movimiento</th></tr>";

  log += "<tr>";
  for (i = 1; i < camposMov.length; ++i)
    log += "<th>" + camposMov[i] + "</th>";
  log += "</tr>";

  log += "<tr>";
  for (i = 1; i < camposMov.length; ++i)
    log += "<td>" + regMov[ camposMov[i] ] + "</td>";
  log += "</tr>";

  log += "</table>";

  log += "<table border=\"1\">";
  log += "<tr><th>--</th><th>Casaciones Candidatas para " + tablaDoc + "</tr>";

  var j;
  for (j = 1; j < candidatos.length; j += 2) {
    if (candidatos[j + 1] < umbral)
      continue;

    var idDoc = candidatos[j];

    if (!idDoc)
      continue;

    curDoc.select(curDoc.primaryKey() + " = '" + idDoc + "'");
    if (!curDoc.first())
      continue;

    var regDoc = this.iface.recordToArray(curDoc);
    var camposDoc = util.nombreCampos(curDoc.table());

    log += "<tr><th>--</th>";
    for (i = 1; i < camposDoc.length; ++i)
      log += "<th>" + camposDoc[i] + "</th>";
    log += "</tr>";

    log += "<tr><th>--</th>";
    for (i = 1; i < camposDoc.length; ++i)
      log += "<td>" + regDoc[ camposDoc[i] ] + "</td>";
    log += "</tr>";
  }

  log += "</table>";

  tedLog.append(log);
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
