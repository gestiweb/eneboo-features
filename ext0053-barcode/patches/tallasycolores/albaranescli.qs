
/** @class_declaration barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
class barCode extends oficial {
	var curLinTC:FLSqlCursor;
    function barCode( context ) { oficial ( context ); }
	function init() {
		this.ctx.barCode_init();
	}
	function lineasTallaColor_clicked() {
		return this.ctx.barCode_lineasTallaColor_clicked();
	}
	function lineasTallaColor(tabla:String, campoPadre:String, valorCP:String, referencia:String, habilitar:Boolean):Boolean {
		return this.ctx.barCode_lineasTallaColor(tabla, campoPadre, valorCP, referencia, habilitar);
	}
	function datosLineasTC(curLineasTC:FLSqlCursor, datosTC:Array):Boolean {
		return this.ctx.barCode_datosLineasTC(curLineasTC, datosTC);
	}
	function generarLineasTC(curLineasTC:FLSqlCursor):Boolean {
		return this.ctx.barCode_generarLineasTC(curLineasTC);
	}
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubBarCode */
/////////////////////////////////////////////////////////////////
//// PUB_BARCODE ////////////////////////////////////////////////
class pubBarCode extends ifaceCtx {
    function pubBarCode ( context ) { ifaceCtx( context ); }
	function pub_lineasTallaColor(tabla:String, campoPadre:String, valorCP:String, referencia:String, habilitar:Boolean):Boolean {
		return this.lineasTallaColor(tabla, campoPadre, valorCP, referencia, habilitar);
	}
}
//// PUB_BARCODE ////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition barCode */
/////////////////////////////////////////////////////////////////
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
function barCode_init()
{
	var util:FLUtil;

	this.iface.__init();

	connect(this.child("tbnTallasCol"), "clicked()", this, "iface.lineasTallaColor_clicked");
}

function barCode_lineasTallaColor_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var referencia:String;

	var curLineas:FLSqlCursor = this.child("tdbLineasAlbaranesCli").cursor();
	referencia = curLineas.valueBuffer("referencia");
	var habilitar:Boolean = true;
	switch (cursor.modeAccess()) {
		case cursor.Insert: {
			curLineas.setModeAccess(curLineas.Insert);
			if (!curLineas.refreshBuffer())
				return false;
			if (!curLineas.commitBufferCursorRelation())
				return false;
			break;
		}
		case cursor.Browse: {
			habilitar = false;
			break;
		}
	}

	if (!this.iface.lineasTallaColor("lineasalbaranescli", "idalbaran", cursor.valueBuffer("idalbaran"), referencia, habilitar))
		return;

	this.iface.calcularTotales();
	this.child("tdbLineasAlbaranesCli").refresh();
}


/** \D Lanza el formulario para insertar tallas y colores en pedidos, albaranes y facturas de cliente
@param	tabla: Tabla de líneas donde se insertarán los datos
@param	campoPadre: Campo que relaciona la tabla de líneas con su tabla padre
@param	valorCP: Valor del campo padre
@param	referencia: Referencia seleccionada en las líneas en el momento de abrir el formulario
@param	habilitar: Indica si el formulario debe abrirse en modo Edit (true) o en modo Browse (false)
\end */
function barCode_lineasTallaColor(tabla:String, campoPadre:String, valorCP:String, referencia:String, habilitar:Boolean):Boolean
{
	var util:FLUtil = new FLUtil();
	util.sqlDelete("lineastallacolcli", "usuario = '" + sys.nameUser() + "'");

	var f:Object = new FLFormSearchDB("lineastallacolcli");
	var curLineasTC:FLSqlCursor = f.cursor();
	curLineasTC.setModeAccess(curLineasTC.Insert);
	curLineasTC.refreshBuffer();
	curLineasTC.setValueBuffer("usuario", sys.nameUser());
	curLineasTC.setValueBuffer("tabla", tabla);
	curLineasTC.setValueBuffer("campopadre", campoPadre);
	curLineasTC.setValueBuffer("valorcampopadre", valorCP);
	curLineasTC.setValueBuffer("referencia", referencia);
	if (!curLineasTC.commitBuffer())
		return false;;

	curLineasTC.select("usuario = '" + sys.nameUser() + "'");
	if (!curLineasTC.first())
		return false;

	if (habilitar)
		curLineasTC.setModeAccess(curLineasTC.Edit);
	else
		curLineasTC.setModeAccess(curLineasTC.Browse);

	f.setMainWidget();
	curLineasTC.refreshBuffer();
	var acpt:String = f.exec("usuario");
	if (!acpt)
		return false;

	var idBuffer:String = curLineasTC.valueBuffer("id");
	curLineasTC.commitBuffer();
	curLineasTC.select("id = " + idBuffer);
	if (!curLineasTC.first())
		return false;

	curLineasTC.setModeAccess(curLineasTC.Browse);
	curLineasTC.refreshBuffer();

	/*curLineasTC.transaction(false);
	try {
		if (*/this.iface.generarLineasTC(curLineasTC)/*) {
			curLineasTC.commit();
		} else {
			curLineasTC.rollback();
		}
	}
	catch (e) {
		curLineasTC.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de las líneas:\n%1").arg(e), MessageBox.Ok, MessageBox.NoButton);
	}*/
	return true;
}

/** \D Actualiza las líneas de facturación de cliente para un determinado artículo en base a los datos introducidos por el usuario en el formulario de introducción de datos de tallas y colores
@param	curLineasTC: Cursor con los datos que el usuario ha introducido
\end */
function barCode_generarLineasTC(curLineasTC:FLSqlCursor):Boolean
{
	var util:FLUtil = new FLUtil;
	var referencia:String = curLineasTC.valueBuffer("referencia");
	this.iface.curLinTC = new FLSqlCursor(curLineasTC.valueBuffer("tabla"));
	this.iface.curLinTC.select(curLineasTC.valueBuffer("campopadre") + " = " + curLineasTC.valueBuffer("valorcampopadre") + " AND referencia = '" + referencia + "'");
	while (this.iface.curLinTC.next()) {
		if (curLineasTC.valueBuffer("tabla") == "lineasalbaranescli") {
			var idLineaPedido:Number = this.iface.curLinTC.valueBuffer("idlineapedido");
			if (idLineaPedido != "0") {
				var idPedido:Number = this.iface.curLinTC.valueBuffer("idpedido");
				var cantidad:Number = this.iface.curLinTC.valueBuffer("cantidad");
				flfacturac.iface.restarCantidadCli(idLineaPedido, this.iface.curLinTC.valueBuffer("idlinea"));
				flfacturac.iface.actualizarEstadoPedidoCli(idPedido);
			}
		}
		this.iface.curLinTC.setModeAccess(this.iface.curLinTC.Del);
		this.iface.curLinTC.refreshBuffer();
		if (!this.iface.curLinTC.commitBuffer())
			return false;;
	}

	var datos:String = curLineasTC.valueBuffer("datos");
	if (!datos || datos == "")
		return false;

	var arrayBarCodes:Array = datos.split(";");
	var temp:Array;
	var barCodeBD:String;
	for (var i:Number = 0; i < arrayBarCodes.length; i++) {
		temp = arrayBarCodes[i].split(",");
		barCodeBD = util.sqlSelect("atributosarticulos", "barcode", "referencia = '" + referencia + "' AND talla = '" + temp[1] + "' AND color = '" + temp[2] + "'");
		if (barCodeBD) {
			temp[0] = barCodeBD;
		} else {
			var datosBarCode:Array = [];
			datosBarCode["barcode"] = temp[0];
			datosBarCode["codtalla"] = temp[1];
			datosBarCode["codcolor"] = temp[2];
			if (!flfactalma.iface.pub_crearBarcode(referencia, datosBarCode)) {
				return false;
			 }
		}
		this.iface.curLinTC.setModeAccess(this.iface.curLinTC.Insert);
		this.iface.curLinTC.refreshBuffer();
		this.iface.curLinTC.setValueBuffer(curLineasTC.valueBuffer("campopadre"), curLineasTC.valueBuffer("valorcampopadre"));

		if (!this.iface.datosLineasTC(curLineasTC, temp))
			return false;

		if (!this.iface.curLinTC.commitBuffer()) {
			return false;
		}
	}
	return true;
}

function barCode_datosLineasTC(curLineasTC:FLSqlCursor, datosTC:Array):Boolean
{
	this.iface.curLinTC.setValueBuffer("referencia", curLineasTC.valueBuffer("referencia"));
	this.iface.curLinTC.setValueBuffer("descripcion", curLineasTC.valueBuffer("descripcion"));
	this.iface.curLinTC.setValueBuffer("talla", datosTC[1]);
	this.iface.curLinTC.setValueBuffer("color", datosTC[2]);
	this.iface.curLinTC.setValueBuffer("barcode", datosTC[0]);
	this.iface.curLinTC.setValueBuffer("pvpunitario", datosTC[4]);
	this.iface.curLinTC.setValueBuffer("cantidad", datosTC[3]);
	this.iface.curLinTC.setValueBuffer("codimpuesto", curLineasTC.valueBuffer("codimpuesto"));
	this.iface.curLinTC.setValueBuffer("iva", curLineasTC.valueBuffer("iva"));
	this.iface.curLinTC.setValueBuffer("recargo", curLineasTC.valueBuffer("recargo"));
	this.iface.curLinTC.setValueBuffer("dtopor", curLineasTC.valueBuffer("dtopor"));
	this.iface.curLinTC.setValueBuffer("pvpsindto", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvpsindto", this.iface.curLinTC));
	this.iface.curLinTC.setValueBuffer("pvptotal", formRecordlineaspedidoscli.iface.pub_commonCalculateField("pvptotal", this.iface.curLinTC));
	if (curLineasTC.valueBuffer("tabla") == "lineasalbaranescli") {
		this.iface.curLinTC.setValueBuffer("idlineapedido", datosTC[5]);
		this.iface.curLinTC.setValueBuffer("idpedido", datosTC[6]);
	}
	return true;
}
//// TALLAS Y COLORES POR BARCODE ///////////////////////////////
/////////////////////////////////////////////////////////////////

