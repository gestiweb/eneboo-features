/***************************************************************************
                      n43_importados.qs  -  description
                             -------------------
    begin                : lun dic 5 2005
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
  function importar()
  {
    this.ctx.oficial_importar();
  }
  function desRegistro(codReg)
  {
    return this.ctx.oficial_desRegistro(codReg);
  }
  function procesarRegistro(reg)
  {
    this.ctx.oficial_procesarRegistro(reg);
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
  function pub_desRegistro(codReg)
  {
    return this.desRegistro(codReg);
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
  this.child("tdbRegistros").setReadOnly(true);
  if (this.cursor().modeAccess() != this.cursor().Insert) {
    this.child("pbImportar").enabled = false;
    return;
  }
  connect(this.child("pbImportar"), "clicked()", this, "iface.importar()");
}
//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
function oficial_importar()
{
  var util = new FLUtil();
  var nombreFichero = FileDialog.getOpenFileName("*.*");

  if (!nombreFichero || nombreFichero.isEmpty()) {
    MessageBox.warning(util.translate("scripts", "Hay que indicar el fichero."),
                       MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var contenido = File.read(nombreFichero);
  var sha = util.sha1(contenido);
  var yaImportado = util.sqlSelect("n43_importados", "descripcion", "sha = '" + sha + "'");

  if (yaImportado) {
    MessageBox.warning(util.translate("scripts", "Este fichero ya ha sido importado :\n\n" + yaImportado),
                       MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
    return;
  }

  var d = new Date;

  this.child("fdbDescripcion").setValue(nombreFichero + "_" + d.toString());
  this.child("fdbSha").setValue(sha);
  this.child("fdbRegistros").setValue("0");
  this.child("pbImportar").enabled = false;

  var file = new File(nombreFichero);
  var reg;
  var steps;

  util.createProgressDialog(util.translate("scripts", "Importando registros..."),
                            contenido.length);
  file.open(File.ReadOnly);
  while (!file.eof) {
    reg = file.readLine();
    this.iface.procesarRegistro(reg);
    steps += reg.length;
    util.setProgress(steps);
  }
  this.child("fdbRegistros").setValue(reg.mid(20, 6));

  file.close();
  util.destroyProgressDialog();
}

function oficial_desRegistro(codReg: String)
{
  var ret = [];

  switch (codReg) {
      // Primer componente informa del número de campos y longitud total del registro
      //
      //  [CONTENIDO  POSICION  LONGITUD]
      //
      /** \D Registro de cabecera de cuenta \end */
    case "11":
      ret = [
              ["campos",    12,   81],
              ["codreg",    1,    2 ],
              ["entidad",   3,    4 ],
              ["agencia",   7,    4 ],
              ["cuenta",    11,   10],
              ["fechaini",  21,   6 ],
              ["fechafin",  27,   6 ],
              ["debehaber", 33,   1 ],
              ["saldoini",  34,   14],
              ["divisa",    48,   3 ],
              ["modalidad", 51,   1 ],
              ["abreviado", 52,   26],
              ["libre",     78,   3 ]];
      break;

      /** \D Registro principal de movimientos \end */
    case "22":
      ret = [
              ["campos",      12,   81],
              ["codreg",      1,    2 ],
              ["libre",       3,    4 ],
              ["claveorig",   7,    4 ],
              ["fechaop",     11,   6 ],
              ["fechaval",    17,   6 ],
              ["cptocomun",   23,   2 ],
              ["cptopropio",  25,   3 ],
              ["debehaber",   28,   1 ],
              ["importe",     29,   14],
              ["numerodoc",   43,   10],
              ["referencia1", 53,   12],
              ["referencia2", 65,   16]];
      break;

      /** \D Registros complementarios de concepto. Primero a quinto opcionales \end */
    case "23":
      ret = [
              ["campos",    4,    81],
              ["codreg",    1,    2 ],
              ["datocpto",  3,    2 ],
              ["concepto1", 5,    38],
              ["concepto2", 43,   38]];
      break;

      /** \D Registro complementario de información de equivalencia de importe del apunte \end */
    case "24":
      ret = [
              ["campos",      5,    81],
              ["codreg",      1,    2 ],
              ["datoequi",    3,    2 ],
              ["divisaequi",  5,    3 ],
              ["importeequi", 8,    14],
              ["libre",       22,   59]];
      break;

      /** \D Registro final de la cuenta \end */
    case "33":
      ret = [
              ["campos",        12,   81],
              ["codreg",        1,    2 ],
              ["entidad",       3,    4 ],
              ["agencia",       7,    4 ],
              ["cuenta",        11,   10],
              ["ndebe",         21,   5 ],
              ["importedebe",   26,   14],
              ["nhaber",        40,   5 ],
              ["importehaber",  45,   14],
              ["codsaldofin",   59,   1 ],
              ["saldofin",      60,   14],
              ["divisa",        74,   3 ],
              ["libre",         77,   4 ]];
      break;

      /** \D Registro de fin de fichero \end */
    case "88":
      ret = [
              ["campos",      4,    81],
              ["codreg",      1,    2 ],
              ["nueves",      3,    18],
              ["nregistros",  21,   6 ],
              ["libre",       27,   54]];
      break;
  }

  return ret;
}

function oficial_procesarRegistro(reg: String)
{
  if (!reg || reg.isEmpty())
    return;

  var codReg = reg.left(2);
  var desReg = this.iface.desRegistro(codReg);

  if (desReg.length == 0)
    return;

  var contenido = "";
  for (var i = 2; i <= desReg[0][1]; i++) {
    contenido += reg.mid(desReg[i][1] - 1, desReg[i][2]);
    if (i != desReg[0][1])
      contenido += ";";
  }

  var curRegistros = this.child("tdbRegistros").cursor();
  curRegistros.setModeAccess(curRegistros.Insert);
  curRegistros.refreshBuffer();
  curRegistros.setValueBuffer("codregistro", codReg);
  curRegistros.setValueBuffer("contenido", contenido);
  curRegistros.commitBuffer();
}
//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
