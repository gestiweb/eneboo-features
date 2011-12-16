
/** @class_declaration anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
class anticipos extends gastoDevol /** %from: oficial */ {
	function anticipos( context ) { gastoDevol( context ); }
	function init() {
		this.ctx.anticipos_init();
	}
	function bufferChanged(fN:String) {
		this.ctx.anticipos_bufferChanged(fN);
	}
}
//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_definition anticipos */
//////////////////////////////////////////////////////////////////
//// ANTICIPOS ///////////////////////////////////////////////////
function anticipos_init()
{
	var idAnticipo:Number = this.cursor().valueBuffer("idanticipo");
	if (idAnticipo != 0) {
		this.child("lblRemesado").text = "ANTICIPO";
		this.child("pushButtonNext").close();
		this.child("pushButtonPrevious").close();
		this.child("pushButtonFirst").close();
		this.child("pushButtonLast").close();
		this.child("pushButtonAcceptContinue").close();
		this.child("pushButtonAccept").close();

		this.child("fdbFechav").setDisabled(true);
		this.child("fdbImporte").setDisabled(true);
		this.child("fdbCodCuenta").editor().setDisabled(true);;
		this.child("coddir").editor().setDisabled(true);;
		this.child("fdbDescripcion").editor().setDisabled(true);
		this.child("fdbCtaEntidad").editor().setDisabled(true);
		this.child("fdbCtaAgencia").editor().setDisabled(true);
		this.child("fdbCuenta").editor().setDisabled(true);
		this.child("groupBoxPD").close();

		var tdbAnt:Object = this.child("tdbAnticipo");
		tdbAnt.setReadOnly(true);
		tdbAnt.cursor().setMainFilter("idanticipo = " + idAnticipo);
		tdbAnt.refresh();

	} else {
		this.child("groupBoxAnt").close();
		this.iface.__init();
	}
}

function anticipos_bufferChanged(fN:String)
{
	switch (fN) {
		case "importe": {
			this.child("fdbTexto").setValue(this.iface.calculateField("texto"));
			this.child("groupBoxPD").setDisabled(true);
			break;
		}
		default: {
			this.iface.__bufferChanged(fN);
		}
	}
}


//// ANTICIPOS ///////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

