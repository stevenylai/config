docbook_html()
{
	xsltproc --xinclude --output "html/${1}.html" /usr/share/sgml/docbook/xsl-stylesheets/xhtml/docbook.xsl "${1}.xml"
}
docbook_pdf()
{
	xsltproc --xinclude /usr/share/sgml/docbook/xsl-ns-stylesheets/fo/docbook.xsl "${1}.xml" > "${1}.fo"
	fop -fo "${1}.fo" -pdf "${1}.pdf"
	rm "${1}.fo"
}
