
/** @class_declaration norma43 */
//////////////////////////////////////////////////////////////////
//// NORMA43   ///////////////////////////////////////////////////
class norma43 extends oficial /** %from: oficial */ {
	function norma43( context ) { oficial( context ); }

	function init() {
		this.ctx.norma43_init();
	}

	function bufferChanged( fN:String ) {
		this.ctx.norma43_bufferChanged( fN );
	}

	function actualizarResumen() {
		this.ctx.norma43_actualizarResumen();
	}
}
//// NORMA43   ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition norma43 */
//////////////////////////////////////////////////////////////////
//// NORMA43   ///////////////////////////////////////////////////
function norma43_init()
{
	this.iface.__init();

	this.child( "tdbMovimientos" ).setEditOnly( true );
	connect( this.child( "tdbMovimientos" ).cursor(), "cursorUpdated()", this, "iface.actualizarResumen()");
}

function norma43_bufferChanged( fN:String )
{
	this.iface.__bufferChanged( fN );

	if ( fN == "codsubcuenta" || fN == "saldoini" )
		this.iface.actualizarResumen();
}

function norma43_actualizarResumen()
{
	var util:FLUtil = new FLUtil();
	var q:FLSqlQuery = new FLSqlQuery();
	var codCuenta:String = this.child( "fdbCodCuenta" ).value();

	var saldoIni:Number = this.child( "fdbSaldoIni" ).value();
	var debeBanco:Number = 0;
	var haberBanco:Number = 0;
	var saldoBanco:Number = 0
	var debeConta:Number = 0;
	var haberConta:Number = 0;
	var saldoConta:Number = 0;

	q.setTablesList( "n43_movimientos" );
	q.setSelect( "SUM(importe)");
	q.setFrom( "n43_movimientos" );
	q.setWhere("codcuenta = '" + codCuenta + "' and debehaber ='D'");
	if ( q.exec() ) {
		if (q.first() ) {
			debeBanco = q.value(0);
			this.child( "lblDebeBanco" ).text = util.roundFieldValue( debeBanco, "n43_movimientos", "importe" );
		}
	}

	q.setSelect( "SUM(importe)");
	q.setFrom( "n43_movimientos" );
	q.setWhere("codcuenta = '" + codCuenta + "' and debehaber ='H'");
	if ( q.exec() ) {
		if (q.first() ) {
			haberBanco = q.value(0) + parseFloat( saldoIni );
			this.child( "lblHaberBanco" ).text = util.roundFieldValue( haberBanco, "n43_movimientos", "importe" );
		}
	}

	saldoBanco = haberBanco - debeBanco;
	this.child( "lblSaldoBanco" ).text = util.roundFieldValue( saldoBanco, "n43_movimientos", "importe" );

	var codSubcuenta:Number = this.child( "fdbCodSubcuenta" ).value();

	if ( codSubcuenta && this.iface.contabilidadCargada ) {
		q.setTablesList( "co_subcuentas" );
		q.setSelect( "debe,haber,saldo" );
		q.setFrom( "co_subcuentas" );
		q.setWhere( "codsubcuenta = '" + codSubcuenta + "' and codejercicio = '" + this.iface.ejercicioActual + "'");
		if ( q.exec() ) {
			if ( q.first() ) {
				debeConta = q.value(0);
				haberConta = q.value(1);
				saldoConta = q.value(2);
				this.child( "lblDebeConta" ).text = util.roundFieldValue( debeConta, "co_subcuentas", "saldo" );
				this.child( "lblHaberConta" ).text = util.roundFieldValue( haberConta, "co_subcuentas", "saldo" );
				this.child( "lblSaldoConta" ).text = util.roundFieldValue( saldoConta, "co_subcuentas", "saldo" );
			}
		}
	}

	this.child( "lblDebeDes" ).text = util.roundFieldValue( haberBanco - debeConta, "n43_movimientos", "importe" );
	this.child( "lblHaberDes" ).text = util.roundFieldValue( debeBanco - haberConta, "n43_movimientos", "importe" );
	this.child( "lblSaldoDes" ).text = util.roundFieldValue( saldoBanco - saldoConta, "n43_movimientos", "importe" );
}
//// NORMA43   ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

