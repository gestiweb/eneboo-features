/***************************************************************************
                   n43_mastermovimientos.qs  -  description
                             -------------------
    begin                : mie dic 7 2004
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
  var ctx: Object;

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

  function msgError(codError: Number)
  {
    return this.ctx.oficial_msgError(codError);
  }

  function actualizarDivisas()
  {
    this.ctx.oficial_actualizarDivisas();
  }

  function actualizarCptosComunes()
  {
    this.ctx.oficial_actualizarCptosComunes();
  }

  function imprimir()
  {
    this.ctx.oficial_imprimir();
  }

  function capturar()
  {
    this.ctx.oficial_capturar();
  }

  function procesarRegistro11(contenido: String)
  {
    return this.ctx.oficial_procesarRegistro11(contenido);
  }

  function procesarRegistro22(contenido: String)
  {
    return this.ctx.oficial_procesarRegistro22(contenido);
  }

  function procesarRegistro23(contenido: String)
  {
    return this.ctx.oficial_procesarRegistro23(contenido);
  }

  function procesarRegistro24(contenido: String)
  {
    return this.ctx.oficial_procesarRegistro24(contenido);
  }

  function procesarRegistro33(contenido: String)
  {
    return this.ctx.oficial_procesarRegistro33(contenido);
  }

  function procesarRegistro88(contenido: String)
  {
    return this.ctx.oficial_procesarRegistro88(contenido);
  }

  function guardarMovimiento(regMov: Array)
  {
    return this.ctx.oficial_guardarMovimiento(regMov);
  }

  function desDebeOHaber(clave: String)
  {
    return this.ctx.oficial_desDebeOHaber(clave);
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
function interna_init()
{
  this.child("tableDBRecords").setEditOnly(true);
  connect(this.child("toolButtonPrint"), "clicked()", this, "iface.imprimir()");
  connect(this.child("pbCapturar"), "clicked()", this, "iface.capturar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_msgError(codError: Number)
{
  var util = new FLUtil();

  switch (codError) {
    case 1:
      return util.translate("scripts",
                            "Hubo un error al seleccionar los registros del fichero importado.");

    case 2:
      return util.translate("scripts",
                            "Debe seleccionar un fichero importado.");

    case 3:
      return util.translate("scripts",
                            "El fichero contiene movimientos de una cuenta que no\nestá dada de alta como cuenta bancaria de la empresa.");

    case 4:
      return util.translate("scripts",
                            "No se pudo insertar automáticamente una cuenta bancaria.");

    case 5:
      return util.translate("scripts",
                            "El código de registro no coincide con el esperado.");

    case 6:
      return util.translate("scripts",
                            "Hubo un error al intentar insertar un movimiento en la base de datos.");
  }

  return util.translate("scripts", "Error desconocido");
}

function oficial_actualizarDivisas()
{
  var divisas = [];

  //          [CODIGO DESCRIPCION       TASA    CODIGOISO]
  divisas = [
              ["EUR", "EUROS",        					"1",    	"978"],
              ["USD", "DÓLARES USA",      			"0.845",  "849"],
              ["GBP", "LIBRAS ESTERLINAS",  		"1.48",   "826"],
              ["CHF", "FRANCOS SUIZOS",   			"0.648",  "756"],
              ["SEK", "CORONAS SUECAS",   			"0.106",  "752"],
              ["NOK", "CORONAS NORUEGAS",   		"0.126",  "578"],
              ["NZD", "DÓLARES NEOZELANDESES",	"0.608",  "554"],
              ["JPY", "YENES JAPONESES",    		"0.007",  "392"],
              ["DKK", "CORONAS DANESAS",    		"0.134",  "208"],
              ["CAD", "DÓLARES CANADIENSES",  	"0.735",  "124"],
              ["AUD", "DÓLARES AUSTRALIANOS", 	"0.639",  "036"]];

  var cur = new FLSqlCursor("divisas");

  for (var i = 0; i < divisas.length; i++) {
    cur.select("coddivisa = '" + divisas[i][0] + "'");
    if (cur.first())
      cur.setModeAccess(cur.Edit);
    else
      cur.setModeAccess(cur.Insert);
    cur.refreshBuffer();
    cur.setValueBuffer("coddivisa", divisas[i][0]);
    cur.setValueBuffer("descripcion", divisas[i][1]);
    cur.setValueBuffer("tasaconv", divisas[i][2]);
    cur.setValueBuffer("codiso", divisas[i][3]);
    cur.commitBuffer();
  }
}

function oficial_actualizarCptosComunes()
{
  var comunes = [];

  //  				[CODIGO   DESCRIPCION
  comunes = [
              ["01",    "TALONES - REINTEGROS"],
              ["02",    "ABONARES - ENTREGAS - INGRESOS"],
              ["03",    "DOMICILIADOS - RECIBOS - LETRAS - PAGOS POR SU CTA."],
              ["04",    "GIROS - TRANSFERENCIAS - TRASPASOS - CHEQUES"],
              ["05",    "AMORTIZACIONES PRESTAMOS, CREDITOS, ETC."],
              ["06",    "REMESAS EFECTOS"],
              ["07",    "SUSCRIPCIONES - DIV. PASIVOS - CANJES."],
              ["08",    "DIV. CUPONES - PRIMA JUNTA - AMORTIZACIONES"],
              ["09",    "OPERACIONES DE BOLSA Y/O COMPRA /VENTA VALORES"],
              ["10",    "CHEQUES GASOLINA"],
              ["11",    "CAJERO AUTOMATICO"],
              ["12",    "TARJETAS DE CREDITO - TARJETAS DEBITO"],
              ["13",    "OPERACIONES EXTRANJERO"],
              ["14",    "DEVOLUCIONES E IMPAGADOS"],
              ["15",    "NOMINAS - SEGUROS SOCIALES"],
              ["16",    "TIMBRES - CORRETAJE - POLIZA"],
              ["17",    "INTERESES - COMISIONES - CUSTODIA - GASTOS E IMPUESTOS"],
              ["98",    "ANULACIONES - CORRECCIONES ASIENTO"],
              ["99",    "VARIOS"]];

  var cur = new FLSqlCursor("n43_cptoscomunes");

  for (var i = 0; i < comunes.length; i++) {
    cur.select("codconcepto = '" + comunes[i][0] + "'");
    if (cur.first())
      cur.setModeAccess(cur.Edit);
    else
      cur.setModeAccess(cur.Insert);
    cur.refreshBuffer();
    cur.setValueBuffer("codconcepto", comunes[i][0]);
    cur.setValueBuffer("concepto", comunes[i][1]);
    cur.commitBuffer();
  }
}

function oficial_imprimir()
{
  debug("No implementado");
}

function oficial_capturar()
{
  var formImportados = new FLFormSearchDB("n43_importados");

  formImportados.setMainWidget();

  var idImportado = formImportados.exec("idimportado");
  var codError = 0;
  var util = new FLUtil();
  var lastCodReg = "";
  var lastContenido = "";
  var lastIdRegistro: Number;

  if (idImportado) {
    this.iface.actualizarDivisas();
    this.iface.actualizarCptosComunes();

    var query = new FLSqlQuery();

    query.setTablesList("n43_regsimportados");
    query.setSelect("codregistro,contenido,idregistro");
    query.setFrom("n43_regsimportados");
    query.setWhere("idimportado = " + idImportado + " order by idregistro asc");

    if (query.exec()) {
      var nRegistros = util.sqlSelect("n43_importados", "registros", "idimportado = " + idImportado);
      var steps = 2;
      var contComplementarios = 0;
      var contEquis = 0;
      var lastRegIniCuenta = [];
      var lastRegMov = [];

      while (query.next()) {

        if (!lastCodReg.isEmpty() && lastRegIniCuenta.ignorarMovs) {
          util.setProgress(++steps);
          continue;
        }

        switch (query.value(0)) {
            /** \D Registro de cabecera de cuenta \end */
          case "11":
            if (!lastCodReg.isEmpty() && lastCodReg != "33") {
              codError = 5;
              break;
            }
            util.destroyProgressDialog();
            lastRegIniCuenta = this.iface.procesarRegistro11(query.value(1));
            codError = lastRegIniCuenta.codError;
            util.createProgressDialog(util.translate("scripts", "Capturando movimientos..."), nRegistros);
            util.setProgress(steps);
            break;

            /** \D Registro principal de movimientos \end */
          case "22":
            if (lastCodReg.isEmpty()) {
              codError = 5;
              break;
            }
            if (lastCodReg != "11" && lastCodReg != "22" && lastCodReg != "23" && lastCodReg != "24") {
              codError = 5;
              break;
            }
            if (lastCodReg == "22" || lastCodReg == "23" || lastCodReg == "24") {
              lastRegMov.cptos = contComplementarios;
              lastRegMov.equis = contEquis;
              codError = this.iface.guardarMovimiento(lastRegMov);
              contComplementarios = 0;
              contEquis = 0;
              if (codError != 0)
                break;
            }
            lastRegMov = this.iface.procesarRegistro22(query.value(1) + ";" + lastRegIniCuenta.codCuenta);
            codError = lastRegMov.codError;
            util.setProgress(++steps);
            break;

            /** \D Registros complementarios de concepto. Primero a quinto opcionales \end */
          case "23":
            if (lastCodReg.isEmpty() || contComplementarios == 5) {
              codError = 5;
              break;
            }
            if (lastCodReg != "22" && lastCodReg != "23") {
              codError = 5;
              break;
            }

            var regComp = this.iface.procesarRegistro23(query.value(1));

            codError = regComp.codError;
            util.setProgress(++steps);
            contComplementarios++;

            var num = contComplementarios.toString();

            lastRegMov["datocpto" + num] = regComp.datocpto;
            lastRegMov["concepto1" + num] = regComp.concepto1;
            lastRegMov["concepto2" + num] = regComp.concepto2;
            break;

            /** \D Registro complementario de información de equivalencia de importe del apunte \end */
          case "24":
            if (lastCodReg.isEmpty() || contEquis == 1) {
              codError = 5;
              break;
            }
            if (lastCodReg != "22" && lastCodReg != "23") {
              codError = 5;
              break;
            }

            var regEqui = this.iface.procesarRegistro24(query.value(1));

            codError = regEqui.codError;
            util.setProgress(++steps);
            contEquis++;

            lastRegMov.datoequi = regEqui.datoequi;
            lastRegMov.divisaequi = regEqui.divisaequi;
            lastRegMov.importeequi = regEqui.importeequi;
            break;

            /** \D Registro final de la cuenta \end */
          case "33":
            if (lastCodReg.isEmpty()) {
              codError = 5;
              break;
            }
            if (lastCodReg != "22" && lastCodReg != "23" && lastCodReg != "24") {
              codError = 5;
              break;
            }

            var reg = this.iface.procesarRegistro33(query.value(1));

            codError = reg.codError;
            util.setProgress(++steps);
            break;

            /** \D Registro de fin de fichero \end */
          case "88":
            if (lastCodReg.isEmpty()) {
              codError = 5;
              break;
            }
            if (lastCodReg != "33") {
              codError = 5;
              break;
            }

            var reg = this.iface.procesarRegistro88(query.value(1));

            codError = reg.codError;
            break;
        }

        lastCodReg = query.value(0);
        lastContenido = query.value(1);
        lastIdRegistro = query.value(2);

        if (codError != 0)
          break;
      }
    } else
      codError = 1;
  } else
    codError = 2;

  util.destroyProgressDialog();

  if (codError != 0) {
    MessageBox.critical(
      util.translate("scripts", "La captura de movimientos no se completó.\n\n") +
      "Err" + codError + " : " + this.iface.msgError(codError) +
      "\n\nCod.Registro: " + lastCodReg +
      "\nContenido : " + lastContenido +
      "\nId. Registro : " + lastIdRegistro
      , MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
  }
}

function oficial_procesarRegistro11(contenido: String)
{
  var ret = [];
  var campos = contenido.split(";");
  var curCuentasBco = new FLSqlCursor("cuentasbanco");
  var util = new FLUtil();

  ret.codError = 0;

  curCuentasBco.select("ctaentidad = '" + campos[0] + "' and ctaagencia = '" + campos[1] + "' and cuenta = '" + campos[2] + "'");

  if (curCuentasBco.first()) {
    ret.codCuenta = curCuentasBco.valueBuffer("codcuenta");
  } else {
    var ans = MessageBox.warning(util.translate("scripts", "La cuenta Nº %1 no existe como cuenta bancaria de la empresa.\nEl fichero contiene movimientos de esta cuenta y deberá\ndarla de alta para poder realizar la captura de movimientos.\n\n¿Desea dar de alta en este momento esta cuenta bancaria?").arg(campos[2]), MessageBox.Yes, MessageBox.No);

    if (ans == MessageBox.Yes) {
      var codCuenta = util.nextCounter("codcuenta", curCuentasBco);

      curCuentasBco.setModeAccess(curCuentasBco.Insert);
      curCuentasBco.refreshBuffer();
      curCuentasBco.setValueBuffer("codcuenta",  codCuenta);
      curCuentasBco.setValueBuffer("ctaentidad", campos[0]);
      curCuentasBco.setValueBuffer("ctaagencia", campos[1]);
      curCuentasBco.setValueBuffer("cuenta", campos[2]);

      if (curCuentasBco.commitBuffer()) {
        curCuentasBco.select("codcuenta = '" + codCuenta + "'");
        if (!curCuentasBco.first()) {
          ret.codError = 4;
          return ret;
        } else {
          ret.codCuenta = codCuenta;
          curCuentasBco.editRecord();
          while (curCuentasBco.inTransaction())
            sys.processEvents();
        }
      } else {
        ret.codError = 4;
        return ret;
      }
    } else {
      ret.codError = 3;
      return ret;
    }
  }

  var curDivisas = new FLSqlCursor("divisas");

  curDivisas.select("codiso = '" + campos[7] + "'");
  if (!curDivisas.first()) {
    curDivisas.setModeAccess(curDivisas.Insert);
    curDivisas.refreshBuffer();
    curDivisas.setValueBuffer("coddivisa", campos[7]);
    curDivisas.setValueBuffer("descripcion", util.translate("scripts", "DESCONOCIDA - CREADA AUTOMÁTICAMENTE EN LA CAPTURA DE MOVIMIENTOS"));
    curDivisas.setValueBuffer("tasaconv", 1);
    curDivisas.setValueBuffer("codiso", campos[7]);
    curDivisas.commitBuffer();
  }

  var resumen: String;

  resumen = util.translate("scripts", "Inicio de captura de movimientos :\n\n");

  resumen += util.translate("scripts", "Cuenta :  %1  %2  %3   %4\n").arg(campos[0]).arg(campos[1]).arg(campos[2]).arg(campos[9]);

  resumen += util.translate("scripts", "F.Inicial : %1 / F.Final : %2   Saldo Inicial : %3%4\n").arg(util.dateAMDtoDMA("20" + campos[3])).arg(util.dateAMDtoDMA("20" + campos[4])).arg(util.buildNumber(parseFloat(campos[6]) / 100, "f", 2)).arg(this.iface.desDebeOHaber(campos[5]));

  resumen += util.translate("scripts", "Divisa : %1  %2\n\n").arg(campos[7]).arg(util.sqlSelect("divisas", "descripcion", "codiso = '" + campos[7] + "'"));

  resumen += util.translate("scripts", "¿Desea realizar la captura de movimientos de esta cuenta?\n");

  var ans = MessageBox.information(resumen, MessageBox.Yes, MessageBox.No);

  if (ans == MessageBox.Yes)
    ret.ignorarMovs = false;
  else
    ret.ignorarMovs = true;

  return ret;
}

function oficial_procesarRegistro22(contenido: String)
{
  var ret = [];
  var campos = contenido.split(";");
  var util = new FLUtil();

  var curComunes = new FLSqlCursor("n43_cptoscomunes");

  curComunes.select("codconcepto = '" + campos[4] + "'");
  if (!curComunes.first()) {
    curComunes.setModeAccess(curComunes.Insert);
    curComunes.refreshBuffer();
    curComunes.setValueBuffer("codconcepto", campos[4]);
    curComunes.setValueBuffer("concepto", util.translate("scripts", "DESCONOCIDO - CREADO AUTOMÁTICAMENTE EN LA CAPTURA DE MOVIMIENTOS"));
    curComunes.commitBuffer();
  }

  var entidad = util.sqlSelect("cuentasbanco", "ctaentidad", "codcuenta = '" + campos[11] + "'");

  if (entidad) {
    var curBancos = new FLSqlCursor("bancos");

    curBancos.select("entidad = '" + entidad + "'");
    if (!curBancos.first()) {
      curBancos.setModeAccess(curBancos.Insert);
      curBancos.refreshBuffer();
      curBancos.setValueBuffer("entidad", entidad);
      curBancos.setValueBuffer("nombre", util.translate("scripts", "DESCONOCIDA - CREADA AUTOMÁTICAMENTE EN LA CAPTURA DE MOVIMIENTOS"));
      curBancos.commitBuffer();
    }
  } else {
    ret.codError = 3;
    return ret;
  }

  var curPropios = new FLSqlCursor("n43_cptospropios");

  curPropios.select("codconcepto = '" + campos[5] + "'");
  if (!curPropios.first()) {
    curPropios.setModeAccess(curPropios.Insert);
    curPropios.refreshBuffer();
    curPropios.setValueBuffer("codconcepto", campos[5]);
    curPropios.setValueBuffer("concepto", util.translate("scripts", "DESCONOCIDO - CREADO AUTOMÁTICAMENTE EN LA CAPTURA DE MOVIMIENTOS"));
    curPropios.setValueBuffer("entidad", entidad);
    curPropios.commitBuffer();
  }

  ret.claveorig = campos[1];
  ret.fechaop = util.dateDMAtoAMD(util.dateAMDtoDMA("20" + campos[2]));
  ret.fechaval = util.dateDMAtoAMD(util.dateAMDtoDMA("20" + campos[3]));
  ret.cptocomun = campos[4];
  ret.cptopropio = campos[5];
  ret.debehaber = this.iface.desDebeOHaber(campos[6]);
  ret.importe = util.buildNumber(parseFloat(campos[7]) / 100, "f", 2);
  ret.numerodoc = campos[8];
  ret.referencia1 = campos[9];
  ret.referencia2 = campos[10];
  ret.codcuenta = campos[11];

  ret.codError = 0;

  return ret;
}

function oficial_procesarRegistro23(contenido: String)
{
  var ret = [];
  var campos = contenido.split(";");

  ret.datocpto = campos[0];
  ret.concepto1 = campos[1];
  ret.concepto2 = campos[2];

  ret.codError = 0;

  return ret;
}

function oficial_procesarRegistro24(contenido: String)
{
  var ret = [];
  var campos = contenido.split(";");

  var curDivisas = new FLSqlCursor("divisas");

  curDivisas.select("codiso = '" + campos[1] + "'");
  if (!curDivisas.first()) {
    curDivisas.setModeAccess(curDivisas.Insert);
    curDivisas.refreshBuffer();
    curDivisas.setValueBuffer("coddivisa", campos[1]);
    curDivisas.setValueBuffer("descripcion", util.translate("scripts", "DESCONOCIDA - CREADA AUTOMÁTICAMENTE EN LA CAPTURA DE MOVIMIENTOS"));
    curDivisas.setValueBuffer("tasaconv", 1);
    curDivisas.setValueBuffer("codiso", campos[1]);
    curDivisas.commitBuffer();
  }

  ret.datoequi = campos[0];
  ret.divisaequi = campos[1];
  ret.importeequi = util.buildNumber(parseFloat(campos[2]) / 100, "f", 2);

  ret.codError = 0;

  return ret;
}

function oficial_procesarRegistro33(contenido: String)
{
  var ret = [];
  var campos = contenido.split(";");
  var util = new FLUtil();
  var resumen: String;

  resumen = util.translate("scripts", "Final de captura de movimientos :\n\n");

  resumen += util.translate("scripts", "Cuenta :  %1  %2  %3\n").arg(campos[0]).arg(campos[1]).arg(campos[2]);

  resumen += util.translate("scripts", "Apuntes Debe : %1\tImporte Debe : %2\n").arg(campos[3]).arg(util.buildNumber(parseFloat(campos[4]) / 100, "f", 2));

  resumen += util.translate("scripts", "Apuntes Haber : %1\tImporte Haber : %2\n").arg(campos[5]).arg(util.buildNumber(parseFloat(campos[6]) / 100, "f", 2));

  resumen += util.translate("scripts", "Saldo Final : %1%2\n").arg(util.buildNumber(parseFloat(campos[8]) / 100, "f", 2)).arg(this.iface.desDebeOHaber(campos[7]));

  resumen += util.translate("scripts", "Divisa : %1  %2\n\n").arg(campos[9]).arg(util.sqlSelect("divisas", "descripcion", "codiso = '" + campos[9] + "'"));

  MessageBox.information(resumen, MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);

  ret.codError = 0;

  return ret;
}

function oficial_procesarRegistro88(contenido: String)
{
  var ret = [];

  ret.codError = 0;

  return ret;
}

function oficial_guardarMovimiento(regMov: Array)
{
  var util = new FLUtil();
  var i: Number;
  var num: Number;
  var sh: String;
  var registro: String;
  var campos =
    ["claveorig", "fechaop", "fechaval",
     "cptocomun", "cptopropio", "debehaber",
     "importe", "numerodoc", "referencia1",
     "referencia2", "codcuenta"];

  for (i = 0; i < regMov.cptos; i++) {
    num = i + 1;
    campos.push("datocpto" + num.toString());
    campos.push("concepto1" + num.toString());
    campos.push("concepto2" + num.toString());
  }

  if (regMov.equis == 1) {
    campos.push("datoequi");
    campos.push("divisaequi");
    campos.push("importeequi");
  }

  for (i = 0; i < campos.length; i++)
    registro += regMov[ campos[i] ];

  sha = util.sha1(registro);
  var yaCapturado = util.sqlSelect("n43_movimientos", "idmovimiento", "sha = '" + sha + "'");

  if (!yaCapturado) {
    var curMov = new FLSqlCursor("n43_movimientos");

    curMov.setModeAccess(curMov.Insert);
    curMov.refreshBuffer();

    for (i = 0; i < campos.length; i++)
      curMov.setValueBuffer(campos[i], regMov[ campos[i] ]);
    curMov.setValueBuffer("sha", sha);

    if (!curMov.commitBuffer())
      return 6;
  }

  return 0;
}

function oficial_desDebeOHaber(clave: String)
{
  if (clave == "1")
    return "D";

  if (clave == "2")
    return "H";
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
