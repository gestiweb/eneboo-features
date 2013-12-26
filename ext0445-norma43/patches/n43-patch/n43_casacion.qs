/***************************************************************************
                               n43_casacion.qs
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
  const CUSTOMER = 0;
  const SUPPLIER = 1;

  var customForm_;
  var tdbMov_;
  var tdbRec_;
  var tdbRecState_;
  var bgCliPro_;
  var deFromMov_;
  var deToMov_;
  var deFromRec_;
  var deToRec_;

  function oficial(context)
  {
    interna(context);
  }
  function main()
  {
    this.ctx.oficial_main();
  }
  function customInit()
  {
    this.ctx.oficial_customInit();
  }
  function updateUiTableMov()
  {
    this.ctx.oficial_updateUiTableMov();
  }
  function updateUiTableRec()
  {
    this.ctx.oficial_updateUiTableRec();
  }
  function compactRec(matches, idMov, idRec, simil)
  {
    this.ctx.oficial_compactRec(matches, idMov, idRec, simil);
  }
  function startProcess()
  {
    this.ctx.oficial_startProcess();
  }
  function similFunctionCode()
  {
    return this.ctx.oficial_similFunctionCode();
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
function oficial_main()
{
  var _i = this.iface;
  var f = _i.customForm_ = new FLFormSearchDB("n43_procesoscas");

  f.setMainWidget("n43_casacion.ui");
  connect(f, "formReady()", _i, "customInit()");
  f.exec();
}

function oficial_customInit()
{
  var _i = this.iface;
  var _f = _i.customForm_;

  _i.tdbMov_ = _f.child("tdbMovimientos");
  _i.tdbRec_ = _f.child("tdbRecibos");
  _i.bgCliPro_ = _f.child("bgCliPro");
  _i.deFromMov_ = _f.child("deDesdeMov");
  _i.deToMov_ = _f.child("deHastaMov");
  _i.deFromRec_ = _f.child("deDesdeRec");
  _i.deToRec_ = _f.child("deHastaRec");

  _f.child("pushButtonAccept").close();

  var date = new Date;
  _i.deToMov_.date = date;
  _i.deToRec_.date = date;
  date.setDate(1);
  date.setMonth(1);
  _i.deFromMov_.date = date;
  _i.deFromRec_.date = date;

  _i.updateUiTableMov();
  _i.updateUiTableRec();

  connect(_i.bgCliPro_, "clicked(int)", _i, "updateUiTableRec()");
  connect(_i.deFromMov_, "valueChanged(const QDate&)", _i, "updateUiTableMov()");
  connect(_i.deToMov_, "valueChanged(const QDate&)", _i, "updateUiTableMov()");
  connect(_i.deFromRec_, "valueChanged(const QDate&)", _i, "updateUiTableRec()");
  connect(_i.deToRec_, "valueChanged(const QDate&)", _i, "updateUiTableRec()");
  connect(_f.child("pbStart"), "clicked()", _i, "startProcess()");
}

function oficial_updateUiTableMov()
{
  var _i = this.iface;

  if (_i.tdbMov_.tableName != "n43_movimientos") {
    _i.tdbMov_.tableName = "n43_movimientos";
    _i.tdbMov_.refresh(true, false);
  }

  _i.tdbMov_.setFilter("fechaop>='" + _i.deFromMov_.date.toString() + "' and " +
                       "fechaop<='" + _i.deToMov_.date.toString() + "' and " +
                       "codcasacion='0'");
  _i.tdbMov_.refresh(false, true);
}

function oficial_updateUiTableRec()
{
  var _i = this.iface;

  switch (_i.bgCliPro_.selectedId) {
    case _i.CUSTOMER: // Clientes
      if (_i.tdbRec_.tableName != "reciboscli") {
        _i.tdbRec_.tableName = "reciboscli";
        _i.tdbRecState_ = _i.CUSTOMER;
        _i.tdbRec_.refresh(true, false);
      }
      break;
    case _i.SUPPLIER: // Proveedores
      if (_i.tdbRec_.tableName != "recibosprov") {
        _i.tdbRec_.tableName = "recibosprov";
        _i.tdbRecState_ = _i.SUPPLIER;
        _i.tdbRec_.refresh(true, false);
      }
      break;
  }

  _i.tdbRec_.setFilter("fecha>='" + _i.deFromRec_.date.toString() + "' and " +
                       "fecha<='" + _i.deToRec_.date.toString() + "' and " +
                       "estado<>'Pagado'");
  _i.tdbRec_.refresh(false, true);
}

function oficial_compactRec(matches, idMov, idRec, simil)
{
  for (var i = 0; i < matches.length; ++i) {
    var match = matches[i];
    if (match[0] == idMov)
      continue;
    for (var j = 1; j < match.length; j += 2) {
      if (match[j] != idRec)
        continue;
      if (match[j + 1] > simil)
        continue;
      matches[i][j + 1] = 0;
    }
  }
}

function oficial_startProcess()
{
  var _i = this.iface;

  var action = (_i.tdbRecState_ == _i.CUSTOMER
                ? "reciboscli"
                : "recibosprov");

  var matches = formRecordn43_procesoscas.iface.pub_obtenerCasaciones(
                  action,
                  _i.tdbRec_.cursor().obj().curFilter(),
                  _i.tdbMov_.cursor().obj().curFilter(),
                  _i.similFunctionCode()
                );

  var util = new FLUtil;
  util.createProgressDialog(util.translate("scripts", "Compactando casaciones..."),
                            matches.length);
  for (var i = 0; i < matches.length; ++i) {
    var match = matches[i];
    var idMov = match[0];
    for (var j = 1; j < match.length; j += 2) {
      var simil = match[j + 1];
      if (simil < 0)
        continue;
      _i.compactRec(matches, idMov, match[j], simil);
    }
    util.setProgress(i);
  }
  util.destroyProgressDialog();

  formn43_casaciones.iface.pub_customMain(matches, action);
}

function oficial_similFunctionCode()
{
  var _i = this.iface;

  var code = "var regMov; var regDoc;\
  var cMov;\
  var cDoc;\
	var dist;\
	var util;\
	var ponds;\
	var longs;\
	var simil;\
  \
  regMov = arguments[0];\
  regDoc = arguments[1];\
  util = new FLUtil();\
  ponds = new Array( 4 );\
	longs = new Array( 4 );\
	simil = new Array( 4 );\
  \
  // Similitud entre el concepto del movimiento y el nombre\
	cMov = regMov.concepto11.upper() + regMov.concepto21.upper();\
	cMov = iface.pub_normalizarCadena( cMov );\
	cDoc = regDoc.%1.upper();\
	cDoc = iface.pub_normalizarCadena( cDoc );\
	dist = iface.pub_distanciaDL( cMov, cDoc );\
	if ( dist > cMov.length )\
		dist = cMov.length;\
	longs[0] = cMov.length;\
	simil[0] = longs[0] - dist;\
	ponds[0] = 20;\
	\
	var len;\
	\
	// Similitud entre captura de 1/3 de texto del concepto del movimiento y la coincidencia de esa captura\
	// en el nombre\
	len = cMov.length / 3;\
	cMov = cMov.mid( len, len );\
	cDoc = cDoc.mid( cDoc.search( cMov.left( len / 3 + 1 ) ),  len );\
	dist = iface.pub_distanciaDL( cMov, cDoc );\
	if ( dist > cMov.length )\
		dist = cMov.length;\
	longs[1] = cMov.length;\
	simil[1] = longs[1] - dist;\
	ponds[1] = 15;\
	\
	// Similitud entre el importe del movimiento e importe del recibo\
	cMov = parseFloat( regMov.importe );\
	cDoc = parseFloat( regDoc.importe );\
	dist = Math.pow( Math.abs( cMov - cDoc ), 2 );\
	if ( dist > cMov )\
		dist = cMov;\
	longs[2] = cMov;\
	simil[2] = longs[2] - dist;\
	ponds[2] = 40;\
	\
	// Similitud entre la fecha de operación del movimiento y la fecha del recibo\
	cMov = regMov.fechaop;\
	cDoc = regDoc.fecha;\
	dist = Math.abs( util.daysTo( cMov, cDoc ) );\
	if ( dist > 365 )\
		dist = 365;\
	longs[3] = 365;\
	simil[3] = longs[3] - dist;\
	ponds[3] = 25;\
	\
	var ret;\
	var i;\
	\
	ret = 0;\
	for( i = 0; i < longs.length ; i++ )\
		ret += ( simil[i] / longs[i] * ponds[i] );\
	\
	return ret;";

  return code.arg(_i.tdbRecState_ == _i.CUSTOMER
                  ? "nombrecliente"
                  : "nombreproveedor");
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
