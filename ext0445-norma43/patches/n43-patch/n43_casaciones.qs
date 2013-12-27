/***************************************************************************
                              n43_casaciones.qs
                             -------------------
    begin                : jue mar 24 2011
    copyright            : (C) 2011 by InfoSiAL S.L.
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
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna
{
  const MAX_MATCH = 0;
  const MID_MATCH = 1;
  const MIN_MATCH = 2;

  var matches_;
  var action_;
  var countAccepted_;
  var customForm_;
  var lwCas_;
  var lwSel_;
  var bgLvl_;
  var limitsSimil_ = [];
  var pixMov_;
  var pixRec_;
  var lblMov_;
  var lblRec_;
  var activeMovKey_;
  var activeRecKey_;
  var pbSel_;
  var pbRem_;
  var pbSelAll_;
  var pbRemAll_;
  var pbAcceptSel_;
  var pbUndo_;
  var curPD_;

  function oficial(context)
  {
    interna(context);
  }
  function customMain(matches, action)
  {
    this.ctx.oficial_customMain(matches, action);
  }
  function customInit()
  {
    this.ctx.oficial_customInit();
  }
  function updateUiListViewCas()
  {
    this.ctx.oficial_updateUiListViewCas();
  }
  function updateUiListViewSel()
  {
    this.ctx.oficial_updateUiListViewSel();
  }
  function updateUiButtons()
  {
    this.ctx.oficial_updateUiButtons();
  }
  function insertItemMov(parent, idMov, simil)
  {
    return this.ctx.oficial_insertItemMov(parent, idMov, simil);
  }
  function insertItemRec(parent, idRec, simil)
  {
    return this.ctx.oficial_insertItemRec(parent, idRec, simil);
  }
  function browseItemRecord(item)
  {
    this.ctx.oficial_browseItemRecord(item);
  }
  function activateItem(item)
  {
    this.ctx.oficial_activateItem(item);
  }
  function selectActiveRec()
  {
    this.ctx.oficial_selectActiveRec();
  }
  function removeActiveRec()
  {
    this.ctx.oficial_removeActiveRec();
  }
  function selectAllRec()
  {
    this.ctx.oficial_selectAllRec();
  }
  function removeAllRec()
  {
    this.ctx.oficial_removeAllRec();
  }
  function acceptSelectedSel()
  {
    this.ctx.oficial_acceptSelectedSel();
  }
  function realizarCasacionT(match, accion)
  {
    return this.ctx.oficial_realizarCasacionT(match, accion);
  }
  function realizarCasacion(match, accion)
  {
    return this.ctx.oficial_realizarCasacion(match, accion);
  }
  function deshacerCasacionT(match, accion)
  {
    return this.ctx.oficial_deshacerCasacionT(match, accion);
  }
  function deshacerCasacion(match, accion)
  {
    return this.ctx.oficial_deshacerCasacion(match, accion);
  }
  function pagarReciboCli(match, accion)
  {
    return this.ctx.oficial_pagarReciboCli(match, accion);
  }
  function pagarReciboProv(match, accion)
  {
    return this.ctx.oficial_pagarReciboProv(match, accion);
  }
  function noPagarReciboCli(match, accion)
  {
    return this.ctx.oficial_noPagarReciboCli(match, accion);
  }
  function noPagarReciboProv(match, accion)
  {
    return this.ctx.oficial_noPagarReciboProv(match, accion);
  }
  function datosPagoDevolCli(curN43Mov, aDatosCuenta)
  {
    return this.ctx.oficial_datosPagoDevolCli(curN43Mov, aDatosCuenta);
  }
  function datosPagoDevolProv(curN43Mov, aDatosCuenta)
  {
    return this.ctx.oficial_datosPagoDevolProv(curN43Mov, aDatosCuenta);
  }
  function undoAccepted()
  {
    this.ctx.oficial_undoAccepted();
  }
  function matchFromItemKey(itemKey)
  {
    return this.ctx.oficial_matchFromItemKey(itemKey);
  }
  function drawMov(idMov)
  {
    this.ctx.oficial_drawMov(idMov);
  }
  function drawRec(idRec)
  {
    this.ctx.oficial_drawRec(idRec);
  }
  function clearActiveItems()
  {
    this.ctx.oficial_clearActiveItems();
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
  function pub_customMain(matches, action)
  {
    this.customMain(matches, action);
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

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_customMain(matches, action)
{
  var _i = this.iface;
  var f = _i.customForm_ = new FLFormSearchDB("n43_procesoscas");

  _i.limitsSimil_[_i.MAX_MATCH] = 80;
  _i.limitsSimil_[_i.MID_MATCH] = 65;
  _i.limitsSimil_[_i.MIN_MATCH] = 30;
  _i.matches_ = matches;
  _i.action_ = action;
  _i.countAccepted_ = 0;
  f.setMainWidget("n43_casaciones.ui");
  connect(f, "formReady()", _i, "customInit()");
  f.exec();
}

function oficial_customInit()
{
  var _i = this.iface;
  var _f = _i.customForm_;

  _f.child("pushButtonAccept").close();
  _i.lwCas_ = _f.child("lwCasaciones");
  _i.lwSel_ = _f.child("lwSeleccionadas");
  _i.bgLvl_ = _f.child("bgNivelCasacion");
  _i.pixMov_ = _f.child("pixMov");
  _i.pixRec_ = _f.child("pixRec");
  _i.lblMov_ = _f.child("lblMov");
  _i.lblRec_ = _f.child("lblRec");
  _i.pbSel_ = _f.child("pbSeleccionar");
  _i.pbRem_ = _f.child("pbQuitar");
  _i.pbSelAll_ = _f.child("pbTodos");
  _i.pbRemAll_ = _f.child("pbNinguno");
  _i.pbAcceptSel_ = _f.child("pbAceptar");
  _i.pbUndo_ = _f.child("pbDeshacer");

  _i.lwCas_.setColumnAlignment(1, 2);
  _i.lwSel_.setColumnAlignment(1, 2);
  _i.updateUiListViewCas();
  _i.updateUiListViewSel();

  connect(_i.lwCas_, "doubleClicked(FLListViewItemInterface*)",
          _i, "browseItemRecord()");
  connect(_i.lwCas_, "selectionChanged(FLListViewItemInterface*)",
          _i, "activateItem()");
  connect(_i.lwSel_, "doubleClicked(FLListViewItemInterface*)",
          _i, "browseItemRecord()");
  connect(_i.lwSel_, "selectionChanged(FLListViewItemInterface*)",
          _i, "activateItem()");

  connect(_i.pbSel_, "clicked()", _i, "selectActiveRec()");
  connect(_i.pbRem_, "clicked()", _i, "removeActiveRec()");
  connect(_i.pbSelAll_, "clicked()", _i, "selectAllRec()");
  connect(_i.pbRemAll_, "clicked()", _i, "removeAllRec()");
  connect(_i.pbAcceptSel_, "clicked()", _i, "acceptSelectedSel()");
  connect(_i.pbUndo_, "clicked()", _i, "undoAccepted()");

  connect(_i.bgLvl_, "clicked(int)", _i, "updateUiListViewCas()");
}

function oficial_updateUiListViewCas()
{
  var _i = this.iface;

  var root = _i.lwCas_.firstChild();
  var item;
  while ((item = root.firstChild()))
    item.del();

  var limitSim = _i.limitsSimil_[_i.bgLvl_.selectedId];
  var firstItem = undefined;

  for (var i = 0; i < _i.matches_.length; ++i) {
    var match = _i.matches_[i];
    if (match.idDoc != undefined || match.maxSimil < limitSim || match.matched)
      continue;

    var countMatchs = 0;
    var itemMov = _i.insertItemMov(_i.lwCas_, match[0], match.maxSimil);
    for (var j = 1; j < match.length; j += 2) {
      var simil = match[j + 1];
      if (simil < limitSim)
        continue;
      _i.insertItemRec(itemMov, match[j], simil);
      ++countMatchs;
    }
    if (countMatchs > 0) {
      itemMov.setText(0, itemMov.text(0) + " (" + countMatchs + ")");
      itemMov.setOpen(true);
      if (firstItem == undefined)
        firstItem = itemMov;
    } else
      itemMov.del();
  }

  root.setOpen(true);
  if (firstItem != undefined)
    _i.activateItem(firstItem);
}

function oficial_updateUiListViewSel()
{
  var _i = this.iface;

  var root = _i.lwSel_.firstChild();
  var item;
  while ((item = root.firstChild()))
    item.del();

  var firstItem = undefined;

  for (var i = 0; i < _i.matches_.length; ++i) {
    var match = _i.matches_[i];
    if (match.idDoc == undefined || match.matched)
      continue;

    var itemMov = _i.insertItemMov(_i.lwSel_, match[0], match.maxSimil);
    for (var j = 1; j < match.length; j += 2) {
      if (match.idDoc != match[j])
        continue;
      _i.insertItemRec(itemMov, match[j], match[j + 1]);
      itemMov.setOpen(true);
      if (firstItem == undefined)
        firstItem = itemMov;
      break;
    }
  }

  root.setOpen(true);
  if (firstItem != undefined)
    _i.activateItem(firstItem);
}

function oficial_updateUiButtons()
{
  var _i = this.iface;

  if (_i.activeMovKey_ != undefined) {
    var match = _i.matchFromItemKey(_i.activeMovKey_);
    var isSelectedMatch = (match != undefined && match.idDoc != undefined);

    _i.pbSel_.setEnabled(!isSelectedMatch);
    _i.pbRem_.setEnabled(isSelectedMatch);
  }

  var isEmptyMatchsList = (_i.lwCas_.firstChild().firstChild() == undefined);
  var isEmptySelectsList = (_i.lwSel_.firstChild().firstChild() == undefined);

  _i.pbSelAll_.setEnabled(!isEmptyMatchsList);
  _i.pbRemAll_.setEnabled(!isEmptySelectsList);
  _i.pbAcceptSel_.setEnabled(!isEmptySelectsList);
  _i.pbUndo_.setEnabled(_i.countAccepted_ > 0);
}

function oficial_insertItemMov(parent, idMov, simil)
{
  var _i = this.iface;

  var qry = new FLSqlQuery;
  qry.setSelect("importe,concepto11");
  qry.setFrom("n43_movimientos");
  qry.setWhere("idmovimiento=" + idMov);

  if (!qry.exec() || !qry.next())
    return;

  var item = new FLListViewItem(parent.firstChild());
  item.setKey("mov:" + idMov);
  item.setPixmap(0, sys.fromPixmap(_i.pixMov_.pixmap));
  item.setText(0, idMov);
  item.setText(1, qry.value(0));
  item.setText(2, qry.value(1).toString());
  item.setText(3, Math.round(simil));

  return item;
}

function oficial_insertItemRec(parent, idRec, simil)
{
  var _i = this.iface;

  var qry = new FLSqlQuery;
  var sel = (_i.action_ == "reciboscli")
            ? "nombrecliente"
            : "nombreproveedor";
  qry.setSelect("codigo,importe," + sel);
  qry.setFrom(_i.action_);
  qry.setWhere("idrecibo=" + idRec);

  if (!qry.exec() || !qry.next())
    return;

  var item = new FLListViewItem(parent);
  item.setKey("rec:" + idRec);
  item.setPixmap(0, sys.fromPixmap(_i.pixRec_.pixmap));
  item.setText(0, qry.value(0));
  item.setText(1, qry.value(1));
  item.setText(2, qry.value(2));
  item.setText(3, Math.round(simil));

  return item;
}

function oficial_browseItemRecord(item)
{
  var _i = this.iface;

  if (item.text(1) == "")
    return;

  var k = item.key().split(":");
  switch (k[0]) {
    case "mov": {
      var cur = new FLSqlCursor("n43_movimientos");
      cur.select("idmovimiento=" + k[1]);
      cur.next();
      cur.browseRecord();
    }
    break;
    case "rec": {
      var cur = new FLSqlCursor(_i.action_);
      cur.select("idrecibo=" + k[1]);
      cur.next();
      cur.browseRecord();
    }
    break;
  }
}

function oficial_activateItem(item)
{
  var _i = this.iface;

  if (item.text(1) == "")
    return;

  var k = item.key().split(":");
  switch (k[0]) {
    case "mov":
      item.setOpen(true);
      if (_i.activeMovKey_ == item.key())
        break;
      _i.activeMovKey_ = item.key();
      _i.activateItem(item.firstChild());
      _i.drawMov(k[1]);
      break;
    case "rec":
      if (_i.activeRecKey_ == item.key())
        break;
      _i.activeRecKey_ = item.key();
      _i.activateItem(item.parent());
      _i.drawRec(k[1]);
      break;
  }

  _i.updateUiButtons();
}

function oficial_selectActiveRec()
{
  var _i = this.iface;

  if (_i.activeRecKey_ == undefined)
    return;

  var k = _i.activeRecKey_.split(":");
  var match = _i.matchFromItemKey(_i.activeMovKey_);
  if (match != undefined && match.idDoc != k[1]) {
    match.idDoc = k[1];
    _i.clearActiveItems();
    _i.updateUiListViewSel();
    _i.updateUiListViewCas();
    _i.updateUiButtons();
  }
}

function oficial_removeActiveRec()
{
  var _i = this.iface;

  if (_i.activeRecKey_ == undefined)
    return;

  var k = _i.activeRecKey_.split(":");
  var match = _i.matchFromItemKey(_i.activeMovKey_);
  if (match != undefined && match.idDoc != undefined) {
    match.idDoc = undefined;
    _i.clearActiveItems();
    _i.updateUiListViewCas();
    _i.updateUiListViewSel();
    _i.updateUiButtons();
  }
}

function oficial_selectAllRec()
{
  var _i = this.iface;

  var limitSim = _i.limitsSimil_[_i.bgLvl_.selectedId];

  for (var i = 0; i < _i.matches_.length; ++i) {
    var match = _i.matches_[i];
    if (match.idDoc != undefined || match.maxSimil < limitSim)
      continue;

    for (var j = 1; j < match.length; j += 2) {
      if (match[j + 1] != match.maxSimil)
        continue;
      match.idDoc = match[j];
      break;
    }
  }

  _i.clearActiveItems();
  _i.updateUiListViewCas();
  _i.updateUiListViewSel();
  _i.updateUiButtons();
}

function oficial_removeAllRec()
{
  var _i = this.iface;

  for (var i = 0; i < _i.matches_.length; ++i)
    _i.matches_[i].idDoc = undefined;

  _i.clearActiveItems();
  _i.updateUiListViewSel();
  _i.updateUiListViewCas();
  _i.updateUiButtons();
}

function oficial_acceptSelectedSel()
{
  // debug("TODO: oficial_acceptSelectedSel()");

  var _i = this.iface;

  // En _i.matches_[0..n] tenemos un array con todas las casaciones
  // En _i.action_ tenemos la accion del documento; en esta implementación reciboscli o recibosprov
  // En _i.countAccepted_ tenemos la cuenta de casaciones aceptadas por el usuario
  //
  // Cada casación a su vez es un array, match[0..m] donde:
  //   match[0] => Identificador del movimiento (n43_movimientos.idmovimiento)
  //     match[1] => Identificador del documento ([reciboscli | recibosprov].idrecibo)
  //     match[2] => Nivel de similitud del documento con el movimiento
  //     ...
  //     ...
  //     match[m - 1] => Identificador del documento ([reciboscli | recibosprov].idrecibo)
  //     match[m]     => Nivel de similitud del documento con el movimiento
  //   El array de cada casación tiene estos atributos;
  //     match.length   => m + 1
  //     match.maxSimil => Similitud maxima encontrada
  //     match.idDoc    => Si el usuario ha seleccionado esta casación es el id del documento
  //                       Si no ha sido seleccionada es UNDEFINED
  //     match.matched  => TRUE si la casacion ha sido seleccionada y aceptada

  // POR HACER:
  // -Por cada casación seleccionada dar el recibo correspondiente como pagado/cobrado
  //  y anotar que el movimiento ya esta casado con un documento, estableciendo los valores
  //  correspondientes para:
  //    n43_movimientos.codcasacion    <= idrecibo
  //    n43_movimientos.accioncasacion <= _i.action_
  //
  // -Modificar el formulario de edición de n43_movimientos para mostrar si el movimiento ya
  //  está casado, con cual documento (mostrando información relacionada) y dando posibilidad
  //  al usuario de anular la casación. Anular la casación sería establecer [codcasación] a '0'
  //  y [accioncasacion] a NULL

  var util = new FLUtil;
  var countMatched = 0;

  util.createProgressDialog(util.translate("scripts", "Aceptando casaciones..."), _i.matches_.length);

  for (var i = 0; i < _i.matches_.length; ++i) {
    util.setProgress(i);

    var match = _i.matches_[i];
    if (match.idDoc == undefined || match.matched) // Casación no seleccionada o ya aceptada, continuamos
      continue;

    // En este punto tenemos una casación seleccionada

    if (!this.iface.realizarCasacionT(match, _i.action_)) {
      util.destroyProgressDialog();
      MessageBox.warning(
        util.translate("scripts",
                       "Error al realizar la casación para la acción %1 y el código %2").arg(_i.action_).arg(match.idDoc),
        MessageBox.Ok, MessageBox.NoButton
      );
      return false;
    }

    // Anotamos la casacion como aceptada
    match.matched = true;
    ++countMatched;

    // Anotar movimiento como casado
    //     debug(String("select ... from n43_movimientos where idmovimiento = %1").arg(match[0]));
    //     debug(String(" n43_movimientos.codcasacion <= %1").arg(match.idDoc));
    //     debug(String(" n43_movimientos.accioncasacion <= %1").arg(_i.action_));
    //
    //     // Dar recibo como pagado/cobrado
    //     debug(String("select ... from %1 where idrecibo = %2").arg(_i.action_).arg(match.idDoc));
    //     debug(String(" PAGAR/COBRAR RECIBO %1 %2")
    //           .arg(match.idDoc)
    //           .arg(util.sqlSelect(_i.action_, "codigo", "idrecibo=" + match.idDoc)));
  }

  if (countMatched > 0) {
    _i.countAccepted_ += countMatched;
    _i.clearActiveItems();
    _i.updateUiListViewCas();
    _i.updateUiListViewSel();
    _i.updateUiButtons();
  }
  util.destroyProgressDialog();
  MessageBox.information(util.translate("scripts", "Casaciones aceptadas correctamente"),
                         MessageBox.Ok, MessageBox.NoButton);
}

function oficial_realizarCasacionT(match, accion)
{
  var curT = new FLSqlCursor("empresa");
  curT.transaction(false)
  try {
    if (this.iface.realizarCasacion(match, accion)) {
      curT.commit();
    } else {
      curT.rollback();
      return false;
    }
  } catch (e) {
    debug(e);
    curT.rollback();
    return false;
  }
  return true;
}

function oficial_realizarCasacion(match, accion)
{
  var util = new FLUtil;
  switch (accion) {
    case "reciboscli": {
      if (!this.iface.pagarReciboCli(match, accion)) {
        return false;
      }
      break;
    }
    case "recibosprov": {
      if (!this.iface.pagarReciboProv(match, accion)) {
        return false;
      }
      break;
    }
    default: {
      MessageBox.warning(
        util.translate(
          "scripts",
          "No hay definida una función para realizar la casación de la acción %1").arg(accion),
        MessageBox.Ok, MessageBox.NoButton
      );
      return false;
    }
  }
  return true;
}

function oficial_pagarReciboCli(match, accion)
{
  var _i = this.iface;

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var hayContabilidad = flfactppal.iface.valorDefectoEmpresa("contintegrada");

  var curN43Mov = new FLSqlCursor("n43_movimientos");
  curN43Mov.select("idmovimiento = " + match[0]);
  if (!curN43Mov.first()) {
    return false;
  }
  var idPD;
  curN43Mov.setModeAccess(curN43Mov.Edit);
  curN43Mov.refreshBuffer();

  var codCuenta = curN43Mov.valueBuffer("codcuenta");
  var aDatosCuenta = flfactppal.iface.pub_ejecutarQry("cuentasbanco",
                                                      "descripcion,ctaentidad,ctaagencia,cuenta,codsubcuenta",
                                                      "codcuenta = '" + codCuenta + "'");
  if (aDatosCuenta.result != 1) {
    return false;
  }
  aDatosCuenta.dc = util.calcularDC(aDatosCuenta.ctaentidad +
                                    aDatosCuenta.ctaagencia) +
                    util.calcularDC(aDatosCuenta.cuenta);

  if (hayContabilidad) {
    aDatosCuenta.idsubcuenta = util.sqlSelect("co_subcuentas",
                                              "idsubcuenta",
                                              "codsubcuenta = '" + aDatosCuenta.codsubcuenta +
                                              "' AND codejercicio = '" + codEjercicio + "'");
    if (!aDatosCuenta.idsubcuenta) {
      MessageBox.warning(
        util.translate(
          "scripts",
          "La cuenta bancaria asociada a la forma de pago seleccionada no tiene una cuenta contable válida asociada"),
        MessageBox.Ok, MessageBox.NoButton
      );
      return false;
    }
  }

  _i.curPD_ = new FLSqlCursor("pagosdevolcli");
  _i.curPD_.setModeAccess(_i.curPD_.Insert);
  _i.curPD_.refreshBuffer();
  _i.curPD_.setValueBuffer("idrecibo", match.idDoc);
  _i.curPD_.setValueBuffer("tipo", "Pago");
  _i.curPD_.setValueBuffer("fecha", curN43Mov.valueBuffer("fechaval"));
  _i.curPD_.setValueBuffer("tasaconv", 1);

  _i.curPD_.setValueBuffer("codcuenta", codCuenta);
  _i.curPD_.setValueBuffer("descripcion", aDatosCuenta.descripcion);
  _i.curPD_.setValueBuffer("ctaentidad", aDatosCuenta.ctaentidad);
  _i.curPD_.setValueBuffer("ctaagencia", aDatosCuenta.ctaagencia);
  _i.curPD_.setValueBuffer("dc", aDatosCuenta.dc);
  _i.curPD_.setValueBuffer("cuenta", aDatosCuenta.cuenta);
  if (!this.iface.datosPagoDevolCli(curN43Mov, aDatosCuenta)) {
    return false;
  }
  if (hayContabilidad) {
    _i.curPD_.setValueBuffer("codsubcuenta", aDatosCuenta.codsubcuenta);
    _i.curPD_.setValueBuffer("idsubcuenta", aDatosCuenta.idsubcuenta);
  }
  idPD = _i.curPD_.valueBuffer("idpagodevol");
  if (!_i.curPD_.commitBuffer()) {
    return false;
  }
  flfactteso.iface.curReciboCli = new FLSqlCursor("reciboscli");
  var curRecibo = flfactteso.iface.curReciboCli;
  curRecibo.select("idrecibo = " + match.idDoc);
  if (!curRecibo.first()) {
    return false;
  }

  curRecibo.setModeAccess(curRecibo.Edit);
  curRecibo.refreshBuffer();
  curRecibo.setValueBuffer("estado",
                           formRecordreciboscli.iface.pub_obtenerEstado(match.idDoc));
  if (!flfactteso.iface.totalesReciboCli()) {
    return false;
  }
  if (!curRecibo.commitBuffer()) {
    return false;
  }
  curN43Mov.setValueBuffer("codcasacion", idPD);
  curN43Mov.setValueBuffer("accioncasacion", "pagosdevolcli");

  if (!curN43Mov.commitBuffer()) {
    return false;
  }
  return true;
}

function oficial_pagarReciboProv(match, accion)
{
  var _i = this.iface;

  var codEjercicio = flfactppal.iface.pub_ejercicioActual();
  var hayContabilidad = flfactppal.iface.valorDefectoEmpresa("contintegrada");

  var curN43Mov = new FLSqlCursor("n43_movimientos");
  curN43Mov.select("idmovimiento = " + match[0]);
  if (!curN43Mov.first()) {
    return false;
  }
  var idPD;
  curN43Mov.setModeAccess(curN43Mov.Edit);
  curN43Mov.refreshBuffer();

  var codCuenta = curN43Mov.valueBuffer("codcuenta");
  var aDatosCuenta = flfactppal.iface.pub_ejecutarQry(
                       "cuentasbanco",
                       "descripcion,ctaentidad,ctaagencia,cuenta,codsubcuenta",
                       "codcuenta = '" + codCuenta + "'"
                     );
  if (aDatosCuenta.result != 1) {
    return false;
  }
  aDatosCuenta.dc = util.calcularDC(aDatosCuenta.ctaentidad +
                                    aDatosCuenta.ctaagencia) +
                    util.calcularDC(aDatosCuenta.cuenta);

  if (hayContabilidad) {
    aDatosCuenta.idsubcuenta = util.sqlSelect("co_subcuentas",
                                              "idsubcuenta",
                                              "codsubcuenta = '" + aDatosCuenta.codsubcuenta +
                                              "' AND codejercicio = '" + codEjercicio + "'");
    if (!aDatosCuenta.idsubcuenta) {
      MessageBox.warning(
        util.translate(
          "scripts",
          "La cuenta bancaria asociada a la forma de pago seleccionada no tiene una cuenta contable válida asociada"),
        MessageBox.Ok, MessageBox.NoButton
      );
      return false;
    }
  }

  _i.curPD_ = new FLSqlCursor("pagosdevolprov");
  _i.curPD_.setModeAccess(_i.curPD_.Insert);
  _i.curPD_.refreshBuffer();
  _i.curPD_.setValueBuffer("idrecibo", match.idDoc);
  _i.curPD_.setValueBuffer("tipo", "Pago");
  _i.curPD_.setValueBuffer("fecha", curN43Mov.valueBuffer("fechaval"));
  _i.curPD_.setValueBuffer("tasaconv", 1);

  _i.curPD_.setValueBuffer("codcuenta", codCuenta);
  _i.curPD_.setValueBuffer("descripcion", aDatosCuenta.descripcion);
  _i.curPD_.setValueBuffer("ctaentidad", aDatosCuenta.ctaentidad);
  _i.curPD_.setValueBuffer("ctaagencia", aDatosCuenta.ctaagencia);
  _i.curPD_.setValueBuffer("dc", aDatosCuenta.dc);
  _i.curPD_.setValueBuffer("cuenta", aDatosCuenta.cuenta);
  if (!this.iface.datosPagoDevolProv(curN43Mov, aDatosCuenta)) {
    return false;
  }
  if (hayContabilidad) {
    _i.curPD_.setValueBuffer("codsubcuenta", aDatosCuenta.codsubcuenta);
    _i.curPD_.setValueBuffer("idsubcuenta", aDatosCuenta.idsubcuenta);
  }
  idPD = _i.curPD_.valueBuffer("idpagodevol");
  if (!_i.curPD_.commitBuffer()) {
    return false;
  }
  flfactteso.iface.curReciboProv = new FLSqlCursor("recibosprov");
  var curRecibo = flfactteso.iface.curReciboProv;
  curRecibo.select("idrecibo = " + match.idDoc);
  if (!curRecibo.first()) {
    return false;
  }

  curRecibo.setModeAccess(curRecibo.Edit);
  curRecibo.refreshBuffer();
  curRecibo.setValueBuffer("estado",
                           formRecordrecibosprov.iface.pub_commonCalculateField("estado", curRecibo));
  if (!flfactteso.iface.totalesReciboProv()) {
    return false;
  }
  if (!curRecibo.commitBuffer()) {
    return false;
  }
  curN43Mov.setValueBuffer("codcasacion", idPD);
  curN43Mov.setValueBuffer("accioncasacion", "pagosdevolprov");

  if (!curN43Mov.commitBuffer()) {
    return false;
  }
  return true;
}

function oficial_datosPagoDevolCli(curN43Mov, aDatosCuenta)
{
  return true;
}
function oficial_datosPagoDevolProv(curN43Mov, aDatosCuenta)
{
  return true;
}

function oficial_undoAccepted()
{
  // debug("TODO: oficial_undoAccepted()");

  var _i = this.iface;

  // POR HACER:
  // -Similar a oficial_acceptSelectedSel(). Hay que recorrer el array de casaciones y
  //  deshacer las que han sido aceptadas por el usuario, quitando el último cobro/pago
  //  del recibo casado con el moviento y marcando el movimiento como no casado
  // -(POSIBLE MEJORA): Dar al usuario la opción de seleccionar que casaciones aceptadas
  //  quiere deshacer, en vez de deshacer todas

  var util = new FLUtil;
  var countUndo = 0;

  util.createProgressDialog(util.translate("scripts",
                                           "Deshaciendo casaciones aceptadas..."),
                            _i.matches_.length);

  for (var i = 0; i < _i.matches_.length; ++i) {
    util.setProgress(i);

    var match = _i.matches_[i];
    if (!match.matched) // Casación no aceptada, continuamos
      continue;

    // En este punto tenemos una casación aceptada
    if (!this.iface.deshacerCasacionT(match, _i.action_)) {
      util.destroyProgressDialog();
      MessageBox.warning(
        util.translate("scripts",
                       "Error al deshacer la casación para la acción %1 y el código %2").arg(_i.action_).arg(match.idDoc),
        MessageBox.Ok, MessageBox.NoButton);
      return false;
    }

    // Anotamos la casacion como no aceptada
    match.matched = false;
    ++countUndo;

    // Anotar movimiento como no casado
    //    debug(String("select ... from n43_movimientos where idmovimiento = %1").arg(match[0]));
    //    debug(String(" n43_movimientos.codcasacion <= '%1'").arg(0));
    //    debug(String(" n43_movimientos.accioncasacion <= %1").arg("NULL"));
    //
    //    // Quitar último pago/cobro del recibo
    //    debug(String("select ... from %1 where idrecibo = %2").arg(_i.action_).arg(match.idDoc));
    //    debug(String(" QUITAR PAGO/COBRO RECIBO %1 %2")
    //          .arg(match.idDoc)
    //          .arg(util.sqlSelect(_i.action_, "codigo", "idrecibo=" + match.idDoc)));
  }

  if (countUndo > 0) {
    _i.countAccepted_ -= countUndo;
    _i.clearActiveItems();
    _i.updateUiListViewCas();
    _i.updateUiListViewSel();
    _i.updateUiButtons();
  }
  util.destroyProgressDialog();
  MessageBox.information(
    util.translate("scripts", "Casaciones deshechas correctamente"),
    MessageBox.Ok, MessageBox.NoButton
  );
}
function oficial_deshacerCasacionT(match, accion)
{
  var curT = new FLSqlCursor("empresa");
  curT.transaction(false)
  try {
    if (this.iface.deshacerCasacion(match, accion)) {
      curT.commit();
    } else {
      curT.rollback();
      return false;
    }
  } catch (e) {
    debug(e);
    curT.rollback();
    return false;
  }
  return true;
}

function oficial_deshacerCasacion(match, accion)
{
  var util = new FLUtil;
  switch (accion) {
    case "reciboscli": {
      if (!this.iface.noPagarReciboCli(match, accion)) {
        return false;
      }
      break;
    }
    case "recibosprov": {
      if (!this.iface.noPagarReciboProv(match, accion)) {
        return false;
      }
      break;
    }
    default: {
      MessageBox.warning(
        util.translate(
          "scripts",
          "No hay definida una función para deshacer la casación de la acción %1").arg(accion),
        MessageBox.Ok, MessageBox.NoButton
      );
      return false;
    }
  }
  return true;
}

function oficial_noPagarReciboCli(match, accion)
{
  var curN43Mov = new FLSqlCursor("n43_movimientos");
  curN43Mov.select("idmovimiento = " + match[0]);
  if (!curN43Mov.first()) {
    return false;
  }

  curN43Mov.setModeAccess(curN43Mov.Edit);
  curN43Mov.refreshBuffer();

  var idPD = util.sqlSelect("n43_movimientos", "codcasacion",
                            "idmovimiento = " + match[0]);
  if (!idPD) {
    return false;
  }

  var curPD = new FLSqlCursor("pagosdevolcli");
  curPD.select("idpagodevol = " + idPD);
  if (!curPD.first()) {
    return false;
  }
  curPD.setModeAccess(curPD.Del);
  curPD.refreshBuffer();
  if (!curPD.commitBuffer()) {
    return false;
  }
  flfactteso.iface.curReciboCli = new FLSqlCursor("reciboscli");
  var curRecibo = flfactteso.iface.curReciboCli;
  curRecibo.select("idrecibo = " + match.idDoc);
  if (!curRecibo.first()) {
    return false;
  }

  curRecibo.setModeAccess(curRecibo.Edit);
  curRecibo.refreshBuffer();
  curRecibo.setValueBuffer("estado",
                           formRecordreciboscli.iface.pub_obtenerEstado(match.idDoc));
  if (!flfactteso.iface.totalesReciboCli()) {
    return false;
  }
  if (!curRecibo.commitBuffer()) {
    return false;
  }
  return true;
}

function oficial_noPagarReciboProv(match, accion)
{
  var curN43Mov = new FLSqlCursor("n43_movimientos");
  curN43Mov.select("idmovimiento = " + match[0]);
  if (!curN43Mov.first()) {
    return false;
  }

  curN43Mov.setModeAccess(curN43Mov.Edit);
  curN43Mov.refreshBuffer();

  var idPD = util.sqlSelect("n43_movimientos", "codcasacion",
                            "idmovimiento = " + match[0]);
  if (!idPD) {
    return false;
  }

  var curPD = new FLSqlCursor("pagosdevolprov");
  curPD.select("idpagodevol = " + idPD);
  if (!curPD.first()) {
    return false;
  }
  curPD.setModeAccess(curPD.Del);
  curPD.refreshBuffer();
  if (!curPD.commitBuffer()) {
    return false;
  }
  flfactteso.iface.curReciboProv = new FLSqlCursor("recibosprov");
  var curRecibo = flfactteso.iface.curReciboProv;
  curRecibo.select("idrecibo = " + match.idDoc);
  if (!curRecibo.first()) {
    return false;
  }

  curRecibo.setModeAccess(curRecibo.Edit);
  curRecibo.refreshBuffer();
  curRecibo.setValueBuffer("estado",
                           formRecordrecibosprov.iface.pub_commonCalculateField("estado", curRecibo));
  if (!flfactteso.iface.totalesReciboProv()) {
    return false;
  }
  if (!curRecibo.commitBuffer()) {
    return false;
  }
  return true;
}

function oficial_matchFromItemKey(itemKey)
{
  var _i = this.iface;

  var k = itemKey.split(":");
  var idMov = k[1];
  var match = undefined;
  for (var i = 0; i < _i.matches_.length; ++i) {
    if (_i.matches_[i][0] != idMov)
      continue;
    match = _i.matches_[i];
    break;
  }
  return match;
}

function oficial_drawMov(idMov)
{
  var _i = this.iface;

  var cur = new FLSqlCursor("n43_movimientos");
  if (!cur.select("idmovimiento=" + idMov) || !cur.next())
    return;

  var qry = new FLSqlQuery;
  qry.setSelect("descripcion,ctaentidad,ctaagencia,cuenta");
  qry.setFrom("cuentasbanco");
  qry.setWhere("codcuenta='" + cur.valueBuffer("codcuenta") + "'");
  if (!qry.exec() || !qry.next())
    return;

  var util = new FLUtil;
  var pic = new Picture;
  var pix = new Pixmap;

  pix.resize(_i.lblMov_.size);
  pix.fill(new Color(255, 255, 255));

  pic.begin();

  var font = new Font("Monospace");
  font.pointSize = 8;
  pic.setFont(font);

  pic.drawText(5, 30,
               cur.valueBuffer("numerodoc") + " " +
               cur.valueBuffer("referencia1") + " " +
               cur.valueBuffer("referencia2"));
  pic.drawText(265, 30, cur.valueBuffer("sha"));

  pic.drawText(5, 45, "Fecha Operación: " +
               util.dateAMDtoDMA(cur.valueBuffer("fechaop")));
  pic.drawText(5, 55, "Fecha     Valor: " +
               util.dateAMDtoDMA(cur.valueBuffer("fechaval")));

  pic.drawText(265, 45, "Origen Oficina: " + cur.valueBuffer("claveorig"));
  pic.drawText(265, 55, "Origen  Divisa: " + cur.valueBuffer("divisaequi"));

  var cptoPropio = cur.valueBuffer("cptopropio");
  pic.drawText(5, 95, cptoPropio + " " +
               util.sqlSelect("n43_cptospropios", "concepto",
                              "codconcepto='" + cptoPropio + "'"));

  var cptoComun = cur.valueBuffer("cptocomun");
  pic.drawText(5, 106, " " + cptoComun + " " +
               util.sqlSelect("n43_cptoscomunes", "concepto",
                              "codconcepto='" + cptoComun + "'"));
  pic.drawText(5, 126, "_" +
               cur.valueBuffer("datocpto1") + " " +
               cur.valueBuffer("concepto11") + " " +
               cur.valueBuffer("concepto21"));
  pic.drawText(5, 137, "_" +
               cur.valueBuffer("datocpto2") + " " +
               cur.valueBuffer("concepto12") + " " +
               cur.valueBuffer("concepto22"));
  pic.drawText(5, 148, "_" +
               cur.valueBuffer("datocpto3") + " " +
               cur.valueBuffer("concepto13") + " " +
               cur.valueBuffer("concepto23"));
  pic.drawText(5, 159, "_" +
               cur.valueBuffer("datocpto4") + " " +
               cur.valueBuffer("concepto14") + " " +
               cur.valueBuffer("concepto24"));
  pic.drawText(5, 170, "_" +
               cur.valueBuffer("datocpto5") + " " +
               cur.valueBuffer("concepto15") + " " +
               cur.valueBuffer("concepto25"));

  font.bold = true;
  pic.setFont(font);
  pic.drawText(5, 10, qry.value(0));
  pic.drawText(265, 10, qry.value(1) + " " + qry.value(2) + " " + qry.value(3));
  pic.drawText(5, 67, "        Importe: " +
               cur.valueBuffer("importe") + " " +
               cur.valueBuffer("debehaber"));
  pic.drawText(265, 67, "Origen Importe: " + cur.valueBuffer("importeequi"));

  pic.setPen(new Color(0, 0, 0), 1, pic.DotLine);
  pic.drawLine(5, 77, pix.width - 5, 77);
  pic.drawLine(5, 80, pix.width - 5, 80);

  pix = pic.playOnPixmap(pix);
  _i.lblMov_.pixmap = pix;

  pic.end();
}

function oficial_drawRec(idRec)
{
  var _i = this.iface;

  var cur = new FLSqlCursor(_i.action_);
  if (!cur.select("idrecibo=" + idRec) || !cur.next())
    return;

  var qry = new FLSqlQuery("i_" + _i.action_);
  qry.setWhere(_i.action_ + ".codigo ='" + cur.valueBuffer("codigo") + "'");
  if (!qry.exec() || !qry.next())
    return;

  var pix = new Pixmap;
  var pic = new Picture;
  var devSize = _i.lblRec_.size;
  var devRect = new Rect(0, 0, devSize.width, devSize.height);

  pix.resize(devSize);
  pix.fill(new Color(255, 255, 255));

  var vi = new FLReportViewer;
  vi.setReportTemplate("i_" + _i.action_);
  vi.setReportData(qry);
  vi.renderReport();

  var pageSize = vi.pageDimensions();
  var pageRect = new Rect(0, 0, pageSize.width, pageSize.height);

  pic.begin();

  pic.drawPicture(vi.getFirstPage());
  pix = pic.playOnPixmap(pix);
  _i.lblRec_.pixmap = pix;

  pic.end();
}

function oficial_clearActiveItems()
{
  var _i = this.iface;

  var pix = new Pixmap;
  pix.resize(_i.lblMov_.size);
  pix.fill(new Color(255, 255, 255));
  _i.lblMov_.pixmap = pix;
  pix.resize(_i.lblRec_.size);
  pix.fill(new Color(255, 255, 255));
  _i.lblRec_.pixmap = pix;

  _i.activeMovKey_ = undefined;
  _i.activeRecKey_ = undefined;
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
