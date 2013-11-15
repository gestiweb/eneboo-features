
/** @class_declaration traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
class traducciones extends medidas {
    var valoresTradActual:Array;
    function traducciones( context ) { medidas ( context ); }
    function init() { this.ctx.traducciones_init(); }
    function introducirIdiomas() {
        return this.ctx.traducciones_introducirIdiomas();
    }
    function traducir(tabla:String, campo:String, idCampo:String) {
        return this.ctx.traducciones_traducir(tabla, campo, idCampo);
    }
    function valoresTrad(tabla:String, campo:String, idCampo:String) {
        return this.ctx.traducciones_valoresTrad(tabla, campo, idCampo);
    }
    function beforeCommit_idiomas(cursor:FLSqlCursor):Boolean {
        return this.ctx.traducciones_beforeCommit_idiomas(cursor);
    }
    function beforeCommit_traducciones(cursor:FLSqlCursor):Boolean {
        return this.ctx.traducciones_beforeCommit_traducciones(cursor);
    }
    function setModificado(cursor:FLSqlCursor)  {
        return this.ctx.traducciones_setModificado(cursor);
    }
    function afterCommit_idiomas(cursor:FLSqlCursor):Boolean {
        return this.ctx.traducciones_afterCommit_idiomas(cursor);
    }
    function afterCommit_traducciones(cursor:FLSqlCursor):Boolean {
        return this.ctx.traducciones_afterCommit_traducciones(cursor);
    }
    function registrarDel(cursor:FLSqlCursor) {
        return this.ctx.traducciones_registrarDel(cursor);
    }
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubTraducciones */
/////////////////////////////////////////////////////////////////
//// PUB TRADUCCIONES ///////////////////////////////////////////
class pubTraducciones extends pubMedidas {
    function pubTraducciones( context ) { pubMedidas ( context ); }
    function pub_traducir(tabla:String, campo:String, idCampo:String) {
            return this.traducir(tabla, campo, idCampo);
    }
    function pub_valoresTrad(familia:String, campo:String, idCampo:String) {
            return this.valoresTrad(familia, campo, idCampo);
    }
}
//// PUB TRADUCCIONES ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition traducciones */
/////////////////////////////////////////////////////////////////
//// TRADUCCIONES ///////////////////////////////////////////////
function traducciones_init()
{
    this.iface.__init();

    var util:FLUtil = new FLUtil();
    var idiomas = util.sqlSelect("idiomas", "COUNT(*)", "1=1");
    if (!idiomas) this.iface.introducirIdiomas();
}

function traducciones_introducirIdiomas()
{
    // Campos: codigo, titulo, posicion, orden, mostrartitulo, casillaunica

    var util:FLUtil = new FLUtil();
    var datos:Array = [["esp","Español", 1],["eng","Inglés", 2]];

    var cursor:FLSqlCursor = new FLSqlCursor("idiomas");

    for (i = 0; i < datos.length; i++) {
        cursor.select("codidioma = '" + datos[i][0] + "'");
        if (cursor.first()) continue;

        cursor.setModeAccess(cursor.Insert);
        cursor.refreshBuffer();
        cursor.setValueBuffer("codidioma", datos[i][0]);
        cursor.setValueBuffer("nombre", datos[i][1]);
        cursor.setValueBuffer("orden", datos[i][2]);
        cursor.setValueBuffer("publico", true);
        cursor.setValueBuffer("modificado", true);
        cursor.commitBuffer();
    }
}

function traducciones_traducir(tabla:String, campo:String, idCampo:String)
{
    var util:FLUtil = new FLUtil();
    var codIdioma:Array = [];
    var idiomaDefecto:String = flfactppal.iface.pub_valorDefectoEmpresa("codidioma");

    var q:FLSqlQuery = new FLSqlQuery();
    q.setTablesList("idiomas");
    q.setFrom("idiomas");
    q.setSelect("codidioma,nombre");
    q.setWhere("1=1 ORDER BY orden");

    if (!q.exec()) return false;

    if (q.size() < 2) {
        MessageBox.information(util.translate("scripts", "Para realizar traducciones debe al menos definir dos idiomas"),
                               MessageBox.Ok, MessageBox.NoButton);
        return;
    }

    var tipoCampo = util.fieldType(campo,tabla);

    var dialog = new Dialog(util.translate ( "scripts", "Traducciones" ), 0);
    dialog.caption = "Traducciones";
    dialog.OKButtonText = util.translate ( "scripts", "Aceptar" );
    dialog.cancelButtonText = util.translate ( "scripts", "Cancelar" );
    dialog.width = 600;

    var cB:Array = [];
    var nAtr:Number = 0;
    var bgroup:GroupBox;

    // Texto corto
    if (tipoCampo != 4) {
        bgroup = new GroupBox;
        bgroup.title = "";
        dialog.add( bgroup );
    }

    while (q.next())  {
        if (q.value(0) == idiomaDefecto)
            continue;

        valor = util.sqlSelect("traducciones", "traduccion", "campo = '" + campo + "' AND tabla = '" + tabla + "' AND idcampo = '" + idCampo + "' AND codidioma = '" + q.value(0) + "'");
        if (!valor) valor = "";

        codIdioma[nAtr] = q.value(0);

        // Texto largo
        if (tipoCampo == 4) {
            if ((nAtr % 2 == 0) && nAtr > 0)
                    dialog.newColumn();

            bgroup = new GroupBox;
            bgroup.title = q.value(1);
            dialog.add( bgroup );
            cB[nAtr] = new TextEdit;
        }
        // Texto Corto
        else {
            cB[nAtr] = new LineEdit;
            cB[nAtr].label = q.value(1);
        }

        cB[nAtr].text = valor;
        bgroup.add( cB[nAtr] );
        nAtr ++;
    }

    if (nAtr > 0) {
        nAtr --;

        if(dialog.exec()) {
            var curTab:FLSqlCursor = new FLSqlCursor("traducciones");

            for (var i:Number = 0; i <= nAtr; i++) {
                if (!cB[i].text) continue;

                curTab.select("campo = '" + campo + "' AND tabla = '" + tabla + "' AND idcampo = '" + idCampo + "' AND codidioma = '" + codIdioma[i] + "'");

                if (curTab.first()) {
                    curTab.setModeAccess(curTab.Edit);
                    curTab.refreshBuffer();
                }
                else {
                    curTab.setModeAccess(curTab.Insert);
                    curTab.refreshBuffer();
                    curTab.setValueBuffer("codidioma", codIdioma[i]);
                    curTab.setValueBuffer("tabla", tabla);
                    curTab.setValueBuffer("campo", campo);
                    curTab.setValueBuffer("idcampo", idCampo);
                }

                curTab.setValueBuffer("traduccion", cB[i].text);
                curTab.commitBuffer();
            }
        }
        else
            return;
    }
}

function traducciones_valoresTrad(tabla:String, campo:String, idCampo:String)
{
    if (tabla) {
        this.iface.valoresTradActual = new Array(2);
        this.iface.valoresTradActual["tabla"] = tabla;
        this.iface.valoresTradActual["campo"] = campo;
        this.iface.valoresTradActual["idCampo"] = idCampo;
    }
    else
        return this.iface.valoresTradActual;
}

function traducciones_beforeCommit_idiomas(cursor:FLSqlCursor):Boolean {
        this.iface.setModificado(cursor);
}
function traducciones_beforeCommit_traducciones(cursor:FLSqlCursor):Boolean {
        this.iface.setModificado(cursor);
}

/** \D Marca el registro como modificado. Se utiliza para actualizar los datos en
la base de datos remota
*/
function traducciones_setModificado(cursor:FLSqlCursor) {
    if (cursor.isModifiedBuffer() && !cursor.valueBufferCopy("modificado"))
        cursor.setValueBuffer("modificado", true);
}

function traducciones_afterCommit_idiomas(cursor:FLSqlCursor):Boolean {
    this.iface.registrarDel(cursor);
}

function traducciones_afterCommit_traducciones(cursor:FLSqlCursor):Boolean {
    this.iface.registrarDel(cursor);
}

/** \D Guarda el registro en la tabla de eliminados. Se utiliza para eliminar
registros en la base de datos remota
*/
function traducciones_registrarDel(cursor:FLSqlCursor)
{
    if (cursor.modeAccess() != cursor.Del)
        return true;

    var tabla:String = cursor.table();
    var valorClave = cursor.valueBuffer(cursor.primaryKey());

    var curTab:FLSqlCursor = new FLSqlCursor("registrosdel");
    curTab.select("tabla = '" + tabla + "' AND idcampo = '" + valorClave + "'");

    if (curTab.first())
        return true;

    curTab.setModeAccess(curTab.Insert);
    curTab.refreshBuffer();
    curTab.setValueBuffer("tabla", tabla);
    curTab.setValueBuffer("idcampo", valorClave);
    curTab.commitBuffer();
}
//// TRADUCCIONES ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

