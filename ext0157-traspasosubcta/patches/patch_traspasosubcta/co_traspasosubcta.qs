/***************************************************************************
                 co_traspasosubcta.qs  -  description
                             -------------------
    begin                : jue may 17 2007
    copyright            : (C) 2004 by InfoSiAL S.L.
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
class interna {
    var ctx:Object;
    function interna( context ) { this.ctx = context; }
    function init() { this.ctx.interna_init(); }
}
//// INTERNA /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////
class oficial extends interna {
	
	var posActualPuntoSubcuenta:Number;
	var ejercicioActual:String;
	var longSubcuenta:Number;
	var bloqueoSubcuenta:Boolean;
    function oficial( context ) { interna( context ); } 
	function bufferChanged(fN) { return this.ctx.oficial_bufferChanged(fN); }
	function traspaso() { return this.ctx.oficial_traspaso() }
}
//// OFICIAL /////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

/** @class_declaration head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////
class head extends oficial {
    function head( context ) { oficial ( context ); }
}
//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_declaration ifaceCtx */
/////////////////////////////////////////////////////////////////
//// INTERFACE  /////////////////////////////////////////////////
class ifaceCtx extends head {
    function ifaceCtx( context ) { head( context ); }
}

const iface = new ifaceCtx( this );
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
	var util:FLUtil = new FLUtil();
	
	this.iface.ejercicioActual = flfactppal.iface.pub_ejercicioActual();
	this.iface.longSubcuenta = util.sqlSelect("ejercicios", "longsubcuenta",  "codejercicio = '" + this.iface.ejercicioActual + "'");
	this.iface.posActualPuntoSubcuenta = -1;
	this.iface.bloqueoSubcuenta = false;
	
	connect(this.cursor(), "bufferChanged(QString)", this, "iface.bufferChanged");
	connect(this.child("pbnTraspaso"), "clicked()", this, "iface.traspaso");
}

//// INTERNA /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition oficial */
//////////////////////////////////////////////////////////////////
//// OFICIAL /////////////////////////////////////////////////////

function oficial_traspaso()
{
	var util:FLUtil = new FLUtil();
	
	var idSubctaOri:Number = this.child("fdbIdSubcuentaOri").value();
	var idSubctaDes:Number = this.child("fdbIdSubcuentaDes").value();	
	var codSubctaOri:Number = this.child("fdbCodSubcuentaOri").value();
	var codSubctaDes:Number = this.child("fdbCodSubcuentaDes").value();
	
	if (!util.sqlSelect("co_subcuentas", "idsubcuenta", "idsubcuenta = " + idSubctaOri) || !util.sqlSelect("co_subcuentas", "idsubcuenta", "idsubcuenta = " + idSubctaDes)) {
		MessageBox.warning( util.translate( "scripts", "Las subcuentas de origen y/o destino no son válidas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
		
	if (idSubctaOri != util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubctaOri + "' AND codejercicio = '" + this.iface.ejercicioActual + "'")
			|| idSubctaDes != util.sqlSelect("co_subcuentas", "idsubcuenta", "codsubcuenta = '" + codSubctaDes + "' AND codejercicio = '" + this.iface.ejercicioActual + "'")) {
		MessageBox.warning( util.translate( "scripts", "Las subcuentas de origen y/o destino no son válidas"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
		
	var res:Object = MessageBox.information(util.translate("scripts", "A continuación todos los apuntes contables de la subcuenta origen pasarán a la subcuenta destino\npara el ejercicio %0\n\n¿Continuar?").arg(this.iface.ejercicioActual), MessageBox.No, MessageBox.Yes, MessageBox.NoButton);
	if (res != MessageBox.Yes)
		return;
	
	res = util.sqlUpdate("co_partidas", "idsubcuenta,codsubcuenta", idSubctaDes + "," + codSubctaDes, "idsubcuenta = " + idSubctaOri);
	if (!res) {
		MessageBox.warning( util.translate( "scripts", "Hubo un problema en la actualización"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}

	res = util.sqlUpdate("co_partidas", "idcontrapartida,codcontrapartida", idSubctaDes + "," + codSubctaDes, "idcontrapartida = " + idSubctaOri);
	if (!res) {
		MessageBox.warning( util.translate( "scripts", "Hubo un problema en la actualización"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton );
		return;
	}
	
	flcontppal.iface.pub_calcularSaldo(idSubctaOri);
	flcontppal.iface.pub_calcularSaldo(idSubctaDes);
	
	this.iface.bufferChanged("codsubcuentaori");
	this.iface.bufferChanged("codsubcuentades");

	MessageBox.information ( util.translate( "scripts", "Proceso finalizado.\n\nPara guardar los cambios debe aceptar el formulario\nSi cancela el formulario se cancelará el traspaso"), MessageBox.Ok, MessageBox.NoButton, MessageBox.NoButton);
}

function oficial_bufferChanged(fN)
{
	var util:FLUtil = new FLUtil();
	var cursor:FLSqlCursor = this.cursor();
	var idScta:Number;
	
	switch(fN) {
		/*U Al introducir la subcuenta, si el usuario pulsa la tecla del punto '.', la subcuenta se informa automaticamente con el código de cuenta más tantos ceros como sea necesario para completar la longitud de subcuenta asociada al ejercicio actual.
		\end */
		case "codsubcuentaori":
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaOri", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				idScta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "' and codsubcuenta = '" + this.child("fdbCodSubcuentaOri").value() + "'");
				if (idScta)
					cursor.setValueBuffer("idsubcuentaori", idScta);
				this.iface.bloqueoSubcuenta = false;
			}
		break;
		case "codsubcuentades":
			if (!this.iface.bloqueoSubcuenta) {
				this.iface.bloqueoSubcuenta = true;
				this.iface.posActualPuntoSubcuenta = flcontppal.iface.pub_formatearCodSubcta(this, "fdbCodSubcuentaDes", this.iface.longSubcuenta, this.iface.posActualPuntoSubcuenta);
				idScta = util.sqlSelect("co_subcuentas", "idsubcuenta", "codejercicio = '" + this.iface.ejercicioActual + "' and codsubcuenta = '" + this.child("fdbCodSubcuentaDes").value() + "'");
				if (idScta)
					cursor.setValueBuffer("idsubcuentades", idScta);
				this.iface.bloqueoSubcuenta = false;
			}
		break;
	}
}

//// OFICIAL /////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////


/** @class_definition head */
/////////////////////////////////////////////////////////////////
//// DESARROLLO /////////////////////////////////////////////////

//// DESARROLLO /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
