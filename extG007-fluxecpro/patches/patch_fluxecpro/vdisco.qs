
/** @class_declaration nattec */
/////////////////////////////////////////////////////////////////
//// NATTEC ////////////////////////////////////////////////////
class nattec extends oficial {
    function nattec( context ) { oficial ( context ); }
    function acceptedForm() {
        return this.ctx.nattec_acceptedForm();
    }
    function generarFichero19(curRemesa:FLSqlCursor):Boolean{
        return this.ctx.nattec_generarFichero19(curRemesa);
    }
    function consultaRecibos(curRemesa:FLSqlCursor,agruparCliente:Boolean):Boolean{
        return this.nattec_consultaRecibos(curRemesa,agruparCliente);
    }
    function conceptoIO(qryRecibos:FLSqlQuery):String {
        return this.ctx.nattec_conceptoIO(qryRecibos);
    }
}
//// NATTEC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition nattec */
/////////////////////////////////////////////////////////////////
//// NATTEC ////////////////////////////////////////////////////
/** \C Al aceptar el formulario, generar el fichero de texto con los datos de la remesa en el fichero especificado
*/
function nattec_acceptedForm()
{
    if (!this.iface.generarFichero19(this.cursor())){
        return false;
    }

    return true;
}

function nattec_generarFichero19(curRemesa:FLSqlCursor):Boolean{

    var file:Object = new File(this.child("leFichero").text);
    file.open(File.WriteOnly);

    file.write(this.iface.cabeceraPresentador() + "\r\n");
    file.write(this.iface.cabeceraOrdenante() + "\r\n");

    var qryRecibos:FLSqlQuery = this.iface.consultaRecibos(curRemesa,this.child("chkAgruparCliente").checked);
    qryRecibos.setForwardOnly(true);
    if (!qryRecibos.exec()) {
        return false;
    }

    while (qryRecibos.next()){
        file.write(this.iface.individualObligatorio(qryRecibos) + "\r\n");
    }

    file.write(this.iface.totalOrdenante(qryRecibos.size()) + "\r\n");
    debug("6 nattec_generarFichero19");
    file.write(this.iface.totalGeneral(qryRecibos.size()) + "\r\n");

    file.close();

    // Genera copia del fichero en codificacion ISO
    // ### Por hacer: Incluir mas codificaciones
    file.open( File.ReadOnly );
    var content = file.read();
    file.close();

    var fileIso = new File( this.child("leFichero").text + ".iso8859" );

    fileIso.open(File.WriteOnly);
    fileIso.write( sys.fromUnicode( content, "ISO-8859-15" ) );
    fileIso.close();

    var util:FLUtil = new FLUtil();
    MessageBox.information(util.translate("scripts", "Generado fichero de recibos en: \n\n%1\n\n").arg(this.child("leFichero").text),MessageBox.Ok, MessageBox.NoButton);

}

function nattec_consultaRecibos(curRemesa:FLSqlCursor,agruparCliente:Boolean):Boolean{

    var qryRecibos:FLSqlQuery = new FLSqlQuery();
    if (agruparCliente) {
        qryRecibos.setTablesList("reciboscli");
        qryRecibos.setSelect("SUM(importe), codcliente, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta");
        qryRecibos.setFrom("reciboscli");
        qryRecibos.setWhere("idrecibo IN (SELECT pd.idrecibo FROM pagosdevolcli pd WHERE pd.idremesa = " + curRemesa.valueBuffer("idremesa") + ") GROUP BY codcliente, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta");
    } else {
        qryRecibos.setTablesList("reciboscli");
        qryRecibos.setSelect("importe, codigo, codcliente, nombrecliente, codcuenta, ctaentidad, ctaagencia, dc, cuenta, idrecibo");
        qryRecibos.setFrom("reciboscli");
        qryRecibos.setWhere("idrecibo IN (SELECT pd.idrecibo FROM pagosdevolcli pd WHERE pd.idremesa = " + curRemesa.valueBuffer("idremesa") + ")");
    }

    return qryRecibos;
}


function nattec_conceptoIO(qryRecibos:FLSqlQuery):String
{
    var util:FLUtil = new FLUtil;

    var concepto:String = "";
    var conceptoAux = this.cursor().valueBuffer("conceptofichero");
    if (conceptoAux && conceptoAux!="") {
        concepto += conceptoAux;
    }

    var conceptoRecibo:String = "";

    if (this.child("chkAgruparCliente").checked) {
        conceptoRecibo = this.iface.__conceptoIO(qryRecibos);
    } else {
        var codigoFra = util.sqlSelect("facturascli inner join reciboscli on facturascli.idfactura = reciboscli.idfactura","facturascli.codigo","reciboscli.idrecibo="+qryRecibos.value("idrecibo"),"facturascli,reciboscli");
        if (codigoFra) {
            conceptoRecibo = "Fra."+codigoFra;
        }
    }

    if (conceptoRecibo && conceptoRecibo!="") {
        if (concepto && concepto!="") {
            concepto += " ";
        }
        if (conceptoRecibo && conceptoRecibo!="") {
            concepto += conceptoRecibo;
        }
    }

    return concepto;
}
//// NATTEC ////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

