
/** @class_declaration artObsoletos */
/////////////////////////////////////////////////////////////////
//// ART OBSOLETOS //////////////////////////////////////////////////
class artObsoletos extends oficial /** %from: oficial */
{
	var filtroOriginal:String;
	var chkObsoletos:Object;
	function artObsoletos( context ) { oficial ( context ); }
	function init() {
		return this.ctx.artObsoletos_init();
	}
	function cambioChkObsoletos() {
		return this.ctx.artObsoletos_cambioChkObsoletos();
	}
}
//// ART OBSOLETOS //////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

/** @class_definition artObsoletos */
/////////////////////////////////////////////////////////////////
//// ART OBSOLETOS //////////////////////////////////////////////////

function artObsoletos_init()
{
	this.iface.__init();

	this.iface.chkObsoletos = this.child("chkObsoletos");
	this.iface.filtroOriginal = this.iface.tdbRecords.cursor().mainFilter();
	connect(this.iface.chkObsoletos, "clicked()", this, "iface.cambioChkObsoletos");
	this.iface.cambioChkObsoletos();
}

/** \D Filtra las tabla de artículos por obsoletos
\end */
function artObsoletos_cambioChkObsoletos()
{
	var util:FLUtil = new FLUtil();

	if (this.iface.chkObsoletos.checked) {
		if (this.iface.filtroOriginal && this.iface.filtroOriginal != "")
			this.iface.tdbRecords.cursor().setMainFilter(this.iface.filtroOriginal + " AND obsoleto = false");
		else
			this.iface.tdbRecords.cursor().setMainFilter("obsoleto = false");
	} else {
		this.iface.tdbRecords.cursor().setMainFilter(this.iface.filtroOriginal);
	}

	this.iface.tdbRecords.refresh();
}

//// ART OBSOLETOS /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////

