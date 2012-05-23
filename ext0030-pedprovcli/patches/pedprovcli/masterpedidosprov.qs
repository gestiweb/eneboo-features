
/** @class_declaration pedProvCli */
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
class pedProvCli extends oficial /** %from: oficial */ {
	var pedidosSel_:Array;
	var lineasPedCli:Array;
	var mensajeFinal:String;
	var curPedidoProvCli_:FLSqlCursor;
    function pedProvCli( context ) { oficial ( context ); }
	function init() {
		return this.ctx.pedProvCli_init();
	}
	function tbnPedidosCli_clicked() {
		return this.ctx.pedProvCli_tbnPedidosCli_clicked();
	}
	function filtroPedidosCli():String {
		return this.ctx.pedProvCli_filtroPedidosCli();
	}
	function buscarProveedorArray(codProveedor:String):Number {
		return this.ctx.pedProvCli_buscarProveedorArray(codProveedor);
	}
	function crearArray(listaPedidos:String):Boolean {
		return this.ctx.pedProvCli_crearArray(listaPedidos);
	}
	function crearPedidos():Boolean {
		return this.ctx.pedProvCli_crearPedidos();
	}
	function buscarPedidosAbiertos(arrayPedCli:Array):Array {
		return this.ctx.pedProvCli_buscarPedidosAbiertos(arrayPedCli);
	}
	function crearPedidoProvCli(indice:Number,idPedido:Number):String {
		return this.ctx.pedProvCli_crearPedidoProvCli(indice,idPedido);
	}
	function copiarLineasPedidoProvCli(idPedidoCli:String,idPedidoProv:String,indice:Number):Boolean {
		return this.ctx.pedProvCli_copiarLineasPedidoProvCli(idPedidoCli,idPedidoProv,indice);
	}
	function datosLineaPedidoProvCli(curLineasCli:FLSqlCursor,curLineasProv:FLSqlCursor,idPedido:Number):String {
		return this.ctx.pedProvCli_datosLineaPedidoProvCli(curLineasCli, curLineasProv, idPedido);
	}
	function calcularTotalesPedidoProvCli():Boolean {
		return this.ctx.pedProvCli_calcularTotalesPedidoProvCli();
	}
	function asociarPedidoProvCli(idPedidoCli:Number,idPedidoProv:Number):Boolean {
		return this.ctx.pedProvCli_asociarPedidoProvCli(idPedidoCli,idPedidoProv);
	}
	function copiaLineasPedidoProvCli(idPedidoCli:String, idPedidoProv:String):Boolean {
		return this.ctx.pedProvCli_copiaLineasPedidoProvCli(idPedidoCli, idPedidoProv);
	}
	function datosPedidoProvCli(indice:Number):Boolean {
		return this.ctx.pedProvCli_datosPedidoProvCli(indice);
	}
	function imprimir(codPedido:String) {
		return this.ctx.pedProvCli_imprimir(codPedido);
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration pubPedProvCli */
/////////////////////////////////////////////////////////////////
//// PUB_PEDPROVCLI  ////////////////////////////////////////////
class pubPedProvCli extends ifaceCtx /** %from: ifaceCtx */ {
    function pubPedProvCli( context ) { ifaceCtx( context ); }
	function pub_commonCalculateField(fN:String, cursor:FLSqlCursor):FLSqlCursor {
		return this.commonCalculateField(fN, cursor);
	}
	function pub_generarAlbaran(where:String, cursor:FLSqlCursor, datosAgrupacion:Array):Number {
		return this.generarAlbaran(where, cursor, datosAgrupacion);
	}
	function pub_imprimir(codPedido:String) {
		return this.imprimir(codPedido);
	}
	function pub_copiarLineasPedidoProvCli(idPedidoCli:String,idPedidoProv:String,indice:Number):Boolean {
		return this.copiarLineasPedidoProvCli(idPedidoCli,idPedidoProv,indice);
	}
	function pub_asociarPedidoProvCli(idPedidoCli:Number,idPedidoProv:Number):Boolean {
		return this.asociarPedidoProvCli(idPedidoCli,idPedidoProv);
	}
}
//// PUB_PEDPROVCLI  ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition pedProvCli*/
/////////////////////////////////////////////////////////////////
//// PED_PROV_CLI ///////////////////////////////////////////////
function pedProvCli_init()
{
	var util:FLUtil;

	this.iface.__init();

	connect(this.child("tbnPedidosCli"), "clicked()", this, "iface.tbnPedidosCli_clicked");

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("pedidosprov");
	q.setSelect("idpedido");
	q.setFrom("pedidosprov");
	q.setWhere("editable = false AND abierto = true");

	if (!q.exec())
		return false;

	var curPed:FLSqlCursor = new FLSqlCursor("pedidosprov");
	curPed.setActivatedCommitActions(false);
	while (q.next()) {
		curPed.select("idpedido = " + q.value("idpedido"));
		curPed.first();
		curPed.setUnLock("editable", true);

		curPed.select("idpedido = " + q.value("idpedido"));
		curPed.first();
		curPed.setModeAccess(curPed.Edit);
		curPed.refreshBuffer();
		curPed.setValueBuffer("abierto",false);
		curPed.commitBuffer();

		curPed.select("idpedido = " + q.value("idpedido"));
		curPed.first();
		curPed.setUnLock("editable", false);
	}
}

function pedProvCli_tbnPedidosCli_clicked()
{
	var cursor:FLSqlCursor = this.cursor();
	var util:FLUtil = new FLUtil();
	this.iface.mensajeFinal = "";
	var f:Object = new FLFormSearchDB("buscapedclisel");
	var curPedidosCli:FLSqlCursor = f.cursor();

	curPedidosCli.setMainFilter(this.iface.filtroPedidosCli());
	f.setMainWidget();
	if (!f.exec("idpedido")) {
		return;
	}
	if (this.iface.pedidosSel_.length == 0) {
		return;
	}
	var listaPedidos:String = this.iface.pedidosSel_.toString();
	if (!this.iface.crearArray(listaPedidos)) {
		return false;
	}

	var curT:FLSqlCursor = new FLSqlCursor("empresa");
	curT.transaction(false);
	try {
		if (this.iface.crearPedidos()) {
			curT.commit();
		}
		else {
			curT.rollback();
			return;
		}
	}
	catch (e) {
		curT.rollback();
		MessageBox.critical(util.translate("scripts", "Hubo un error en la generación de pedidos:") + "\n" + e, MessageBox.Ok, MessageBox.NoButton);
		return;
	}

	this.iface.tdbRecords.refresh();
	this.iface.procesarEstado();

	MessageBox.information(util.translate("scripts", "Pedidos implicados: \n%1").arg(this.iface.mensajeFinal), MessageBox.Ok, MessageBox.NoButton);
}

function pedProvCli_crearPedidos():Boolean
{
	var util:FLUtil;

	var pedidosAbiertos:Array;
	for(var indice=0;indice<this.iface.lineasPedCli.length;indice++) {

		delete pedidosAbiertos;
		pedidosAbiertos = this.iface.buscarPedidosAbiertos(this.iface.lineasPedCli[indice]);
		if(pedidosAbiertos.length > 0) {

			var dialog = new Dialog;
			dialog.caption = "Pedidos abiertos";
			dialog.okButtonText = "Aceptar"
			dialog.cancelButtonText = "Cancelar";

			var gbx = new GroupBox;
			var codProveedor:String = this.iface.lineasPedCli[indice][0];
			var nombreProv:String = util.sqlSelect("proveedores", "nombre", "codproveedor = '" + codProveedor + "'");
			gbx.title = util.translate("scripts", "Existen pedidos abiertos para el proveedor %1 - %2. Selecciona el pedido al cual asociar las líneas:").arg(codProveedor).arg(nombreProv);
			dialog.add(gbx)
			var pedidos:Array = new Array();
			pedidos[0] = new RadioButton;
			pedidos[0].text = "Pedido nuevo";
			pedidos[0].checked = false;
			gbx.add(pedidos[0]);

			for(var i=0;i<pedidosAbiertos.length;i++) {
				pedidos[i+1] = new RadioButton;
				pedidos[i+1].text = util.translate("scripts", "Pedido %1 del %2    Importe: %3").arg(pedidosAbiertos[i][1]).arg(util.dateAMDtoDMA(pedidosAbiertos[i][2])).arg(util.roundFieldValue(parseFloat(pedidosAbiertos[i][3]), "pedidosprov","total"));
				if(i == pedidosAbiertos.length -1) {
					pedidos[i+1].checked = true;
				} else {
					pedidos[i+1].checked = false;
				}
				gbx.add(pedidos[i+1]);
			}

			if (!dialog.exec()) {
				return false;
			}
			var nuevoPed:String;
			if (pedidos[0].checked) {
				nuevoPed = this.iface.crearPedidoProvCli(indice);
				if (!nuevoPed) {
					return false;
				} else {
					this.iface.mensajeFinal += nuevoPed + " (NUEVO)" + "\n";
				}
			} else {
				for (var i=1;i<=pedidosAbiertos.length;i++) {
					if (pedidos[i].checked) {
						nuevoPed = this.iface.crearPedidoProvCli(indice,pedidosAbiertos[i-1][0]);
						if (!nuevoPed) {
							return false;
						} else {
							this.iface.mensajeFinal += nuevoPed + " (MODIFICADO)" + "\n";
						}
						i = pedidosAbiertos.length;
					}
				}
			}
		} else {
			nuevoPed = this.iface.crearPedidoProvCli(indice);
			if (!nuevoPed) {
				return false;
			} else {
				this.iface.mensajeFinal += nuevoPed + " (NUEVO)" + "\n";
			}
		}
	}
	return true;
}

function pedProvCli_crearPedidoProvCli(indice:Number,idPedido:Number):String
{
	var util:FLUtil;

	if (!this.iface.curPedidoProvCli_) {
		this.iface.curPedidoProvCli_ = new FLSqlCursor("pedidosprov");
	}

	if (!idPedido) {
		this.iface.curPedidoProvCli_.setModeAccess(this.iface.curPedidoProvCli_.Insert);
		this.iface.curPedidoProvCli_.refreshBuffer();
		if (!this.iface.datosPedidoProvCli(indice)) {
			return false;
		}
		if (!this.iface.curPedidoProvCli_.commitBuffer()) {
			return false;
		}
		idPedido = this.iface.curPedidoProvCli_.valueBuffer("idpedido");
	}
	if (!this.iface.copiarLineasPedidoProvCli(false, idPedido, indice)) {
		return false;
	}
	this.iface.curPedidoProvCli_.select("idpedido = " + idPedido);
	if (!this.iface.curPedidoProvCli_.first()) {
		return false;
	}
	this.iface.curPedidoProvCli_.setModeAccess(this.iface.curPedidoProvCli_.Edit);
	this.iface.curPedidoProvCli_.refreshBuffer();

	if (!this.iface.calcularTotalesPedidoProvCli()) {
		return false;
	}
	if (!this.iface.curPedidoProvCli_.commitBuffer()) {
		return false;
	}

	return this.iface.curPedidoProvCli_.valueBuffer("codigo");
}

function pedProvCli_datosPedidoProvCli(indice:Number):Boolean
{
	var util:FLUtil;

	var codProveedor:String = this.iface.lineasPedCli[indice][0];
	if (!codProveedor || codProveedor == "") {
		return false;
	}

	var hoy:Date = new Date();
	with(this.iface.curPedidoProvCli_) {
		setValueBuffer("fecha",hoy);
		setValueBuffer("codproveedor", codProveedor);
		setValueBuffer("nombre", util.sqlSelect("proveedores","nombre","codproveedor = '" + codProveedor + "'"));
		setValueBuffer("cifnif", util.sqlSelect("proveedores","cifnif","codproveedor = '" + codProveedor + "'"));
		setValueBuffer("codejercicio", flfactppal.iface.pub_ejercicioActual());
		setValueBuffer("codserie", flfactppal.iface.pub_valorDefectoEmpresa("codserie"));
		setValueBuffer("irpf", formpedidosprov.iface.pub_commonCalculateField("irpf", this));
		setValueBuffer("codalmacen", flfactppal.iface.pub_valorDefectoEmpresa("codalmacen"));
		setValueBuffer("coddivisa", flfactppal.iface.pub_valorDefectoEmpresa("coddivisa"));
		setValueBuffer("tasaconv", util.sqlSelect("divisas", "tasaconv", "coddivisa = '" + valueBuffer("coddivisa") + "'"));
		setValueBuffer("codpago", flfactppal.iface.pub_valorDefectoEmpresa("codpago"));
	}

	return true;
}

function pedProvCli_calcularTotalesPedidoProvCli():Boolean
{
	with (this.iface.curPedidoProvCli_) {
		setValueBuffer("neto", formpedidosprov.iface.pub_commonCalculateField("neto", this));
		setValueBuffer("totaliva", formpedidosprov.iface.pub_commonCalculateField("totaliva", this));
		setValueBuffer("totalirpf", formpedidosprov.iface.pub_commonCalculateField("totalirpf", this));
		setValueBuffer("totalrecargo", formpedidosprov.iface.pub_commonCalculateField("totalrecargo", this));
		setValueBuffer("total", formpedidosprov.iface.pub_commonCalculateField("total", this));
		setValueBuffer("totaleuros", formpedidosprov.iface.pub_commonCalculateField("totaleuros", this));
	}

	return true;
}

/** \D Copia las líneas de un pedido de cliente en líneas de un pedido a proveedor
@param	idPedidoCli: Identificador del pedido de cliente
@param	idPedidoProv: Identificador del pedido de proveedor
@return	true si la copia se realiza de forma correcta, false si hay error
\end */
function pedProvCli_copiarLineasPedidoProvCli(idPedidoCli:String, idPedidoProv:String,indice:Number):Boolean
{
	var util:FLUtil = new FLUtil;
	var curLineasCli:FLSqlCursor = new FLSqlCursor("lineaspedidoscli");
	var curLineasProv:FLSqlCursor = new FLSqlCursor("lineaspedidosprov");

	if(idPedidoCli)
		curLineasCli.select("idpedido = " + idPedidoCli);
	else {
		if(indice >= 0)
			curLineasCli.select("idlinea IN (" + this.iface.lineasPedCli[indice][1].toString() + ")");
		else
			return false;
	}

	var cantidad:Number, cantidadProv:Number;
	var estadoCopia:String;
	while (curLineasCli.next()) {
		curLineasCli.setModeAccess(curLineasCli.Edit);
		curLineasCli.refreshBuffer();

		cantidad = parseFloat(curLineasCli.valueBuffer("cantidad")) - parseFloat(curLineasCli.valueBuffer("totalenalbaran"));
		cantidadProv = util.sqlSelect("lineaspedidosprov", "SUM(CASE WHEN cerrada THEN totalenalbaran ELSE cantidad END)", "idlineacli = " + curLineasCli.valueBuffer("idlinea"));
		cantidad -= (isNaN(cantidadProv) ? 0 : parseFloat(cantidadProv));
		if (cantidad <= 0) {
			continue;
		}

		curLineasProv.setModeAccess(curLineasProv.Insert);
		curLineasProv.refreshBuffer();
		curLineasProv.setValueBuffer("cantidad", cantidad);

		estadoCopia = this.iface.datosLineaPedidoProvCli(curLineasCli,curLineasProv,idPedidoProv);
		switch (estadoCopia) {
			case "OK": {
				break;
			}
			case "SALTAR": {
				continue;
				break;
			}
			default: {
				return false;
			}
		}

		if (!curLineasProv.commitBuffer()) {
			return false;
		}
		curLineasCli.setValueBuffer("idlineaprov", curLineasProv.valueBuffer("idlinea"));
		if (!curLineasCli.commitBuffer()) {
			return false;
		}
	}

	return true;
}

function pedProvCli_asociarPedidoProvCli(idPedidoCli:Number,idPedidoProv:Number):Boolean
{
	if(!idPedidoCli || !idPedidoProv)
		return false;

	var util:FLUtil = new FLUtil();
	var curPedidoCli:FLSqlCursor = new FLSqlCursor("pedidoscli");
	curPedidoCli.select("idpedido = " + idPedidoCli);
	if (!curPedidoCli.first())
		return false;

	curPedidoCli.setModeAccess(curPedidoCli.Edit);
	curPedidoCli.refreshBuffer();
	curPedidoCli.setValueBuffer("idpedidoprov", idPedidoProv);
	curPedidoCli.setValueBuffer("codpedidoprov", util.sqlSelect("pedidosprov","codigo","idpedido = " + idPedidoProv));
	if (!curPedidoCli.commitBuffer())
		return false;

	return true;
}

/** \D Copia los datos de la línea de pedido de cliente en la línea de pedido de proveedor
@param	curLineasCli: Cursor de la línea de pedido de cliente
@param	curLineasProv: Cursor de la línea de pedido de proveedor
@param	idPedido: Identificador del pedido de proveedor
@return	Valores:
 * OK: Correcto
 * SALTAR: No copiar la línea, continuar con la siguiente
 * false: Error
\end */
function pedProvCli_datosLineaPedidoProvCli(curLineasCli:FLSqlCursor,curLineasProv:FLSqlCursor,idPedido:Number):String
{
	var util:FLUtil;
	var valor:Number;

	with (curLineasProv) {
		setValueBuffer("idpedido", idPedido);
		setValueBuffer("referencia", curLineasCli.valueBuffer("referencia"));
		setValueBuffer("descripcion", curLineasCli.valueBuffer("descripcion"));
// 		setValueBuffer("cantidad", cantidad);

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpunitario", curLineasProv);
		if (!valor || isNaN(valor)) {
			valor = 0;
		}
		setValueBuffer("pvpunitario", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvpsindto", curLineasProv);
		setValueBuffer("pvpsindto", parseFloat(valor));

		setValueBuffer("codimpuesto", formRecordlineaspedidosprov.iface.pub_commonCalculateField("codimpuesto", curLineasProv));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("iva", curLineasProv);
		setValueBuffer("iva", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("recargo", curLineasProv);
		setValueBuffer("recargo", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("dtopor", curLineasProv);
		if (!valor || isNaN(valor)) {
			valor = 0;
		}
		setValueBuffer("dtopor", parseFloat(valor));

		valor = formRecordlineaspedidosprov.iface.pub_commonCalculateField("pvptotal", curLineasProv);
		setValueBuffer("pvptotal", parseFloat(valor));

		setValueBuffer("idlineacli", curLineasCli.valueBuffer("idlinea"));
	}

	return "OK";
}

function pedProvCli_buscarPedidosAbiertos(arrayPedCli:Array):Array
{
	var array:Array = new Array();
	var tam:Number = 0;
	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("pedidosprov");
	q.setSelect("idpedido,codigo,fecha,total");
	q.setFrom("pedidosprov");
	q.setWhere("abierto AND codproveedor = '" + arrayPedCli[0] + "' ORDER BY fecha");

	if (!q.exec()) {
		return false;
	}
	while (q.next()) {
		array[tam] = new Array();
		array[tam][0] = q.value("idpedido");
		array[tam][1] = q.value("codigo");
		array[tam][2] = q.value("fecha");
		array[tam][3] = q.value("total");
		tam ++;
	}
	return array;
}

function pedProvCli_crearArray(listaPedidos:String):Boolean
{
	var util:FLUtil;

	var q:FLSqlQuery = new FLSqlQuery();
	q.setTablesList("lineaspedidoscli");
	q.setSelect("referencia,cantidad,totalenalbaran,idlinea");
	q.setFrom("lineaspedidoscli");
	q.setWhere("idpedido IN(" + listaPedidos + ") AND (cerrada IS NULL OR cerrada = false)");

	if (!q.exec()) {
		return false;
	}
	delete this.iface.lineasPedCli;
	this.iface.lineasPedCli = new Array();
	var codProveedor:String = "";
	var referencia:String = "";
	var cantidad:Number;
	var posicion:Number = -1;
	while (q.next()) {
		referencia = q.value("referencia");
		if (!referencia || referencia == "") {
			continue;
		}
		cantidad = parseFloat(q.value("cantidad")) - parseFloat(q.value("totalenalbaran"));
		if (cantidad <= 0) {
			continue;
		}
		codProveedor = util.sqlSelect("articulosprov","codproveedor","referencia = '" + referencia + "' AND pordefecto = true");
		if (!codProveedor || codProveedor == "") {
			var res:Number = MessageBox.warning(util.translate("scripts", "No se ha encontrado un proveedor para el artículo %1.\n¿Desea continuar generando el resto de pedidos?").arg(referencia), MessageBox.Yes, MessageBox.No);
			if (res != MessageBox.Yes) {
				return false;
			}
			continue;
		}

		posicion = this.iface.buscarProveedorArray(codProveedor);
		if (posicion == -1) {
			posicion = this.iface.lineasPedCli.length;
			this.iface.lineasPedCli[posicion] = new Array();
			this.iface.lineasPedCli[posicion][0] = codProveedor;
			this.iface.lineasPedCli[posicion][1] = new Array();
		}
		var linea:Number = this.iface.lineasPedCli[posicion][1].length
		this.iface.lineasPedCli[posicion][1][linea] = q.value("idlinea");
	}

// 	debug("===============================================");
// 	for(var i=0;i<this.iface.lineasPedCli.length;i++) {
// 		debug("------ Proveedor // " + this.iface.lineasPedCli[i][0] + " //");
// 		for(var j=0;j<this.iface.lineasPedCli[i][1].length;j++) {
// 			debug("------ Linea " + this.iface.lineasPedCli[i][1][j]);
// 		}
// 		debug("");
// 	}
// 	debug("===============================================");

	return true;
}

function pedProvCli_buscarProveedorArray(codProveedor:String):Number
{
	for (var i:Number = 0; i < this.iface.lineasPedCli.length; i++) {
		if (this.iface.lineasPedCli[i][0] == codProveedor) {
			return i;
		}
	}
	return -1;
}

/** \D Obtiene el filtro a aplicar sobre el formulario de búsqueda de pedidos de cliente
@return	filtro a aplicar
\end */
function pedProvCli_filtroPedidosCli():String
{
	return "pedido IN ('No', 'Parcial') AND servido IN ('No', 'Parcial')";
}

function pedProvCli_imprimir(codPedido:String)
{
	var util:FLUtil;

	this.iface.__imprimir(codPedido);

	var codigo:String;
	if (codPedido) {
		codigo = codPedido;
	} else {
		if (!this.cursor().isValid())
			return;
		codigo = this.cursor().valueBuffer("codigo");
	}

	if(util.sqlSelect("pedidosprov","abierto","codigo = '" + codigo + "'")) {
		var res:Number = MessageBox.information(util.translate("scripts", "¿Desea marcar el pedido como no abierto"), MessageBox.Yes, MessageBox.No);
		if(res == MessageBox.Yes)
			util.sqlUpdate("pedidosprov","abierto",false,"codigo = '" + codigo + "'");
	}
}
//// PED_PROV_CLI ///////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

