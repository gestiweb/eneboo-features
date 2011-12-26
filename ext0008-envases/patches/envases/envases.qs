/***************************************************************************
                 envases.qs  -  description
                             -------------------
    begin                : lun abr 26 2004
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

function init()
{
	var cursor = form.cursor();
	connect(cursor, "bufferChanged(QString)", this, "bufferChanged");
}

function bufferChanged(fN)
{
	switch (fN) {
		case "medida":
		case "densidad":
			form.child("fdbCantidad").setValue(calculateField("cantidad"));
			bloqueoSubcuenta = false;
		break;
	}
}

function calculateField(fN)
{
	var valor;
	
	switch (fN) {
		case "cantidad":
			valor = parseFloat(form.child("fdbDensidad").value()) * parseFloat(form.child("fdbMedida").value());
		break;
	}
	return valor;
}
