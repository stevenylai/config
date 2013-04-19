docbook_html()
{
	xsltproc --xinclude --output "html/${1}.html" /usr/share/sgml/docbook/xsl-stylesheets/xhtml5/docbook.xsl "${1}.xml"
}