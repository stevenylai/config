pscrop()
{
	if [ ${#} -lt 1 ]; then
		echo "Usage: pscrop <filename>"
		return
	fi
	filename=`echo "${1}"|sed 's/\.[^.]\+$//g'`
	psnup -1 -b-10 "${1}" "${filename}_tmp.ps"
	ps2pdf -dEPSCrop "${filename}_tmp.ps" "${filename}.pdf"
	mv "${filename}_tmp.ps" "${1}"
}
pdfcrop()
{
	if [ ${#} -lt 1 ]; then
		echo "Usage: pdfcrop <filename>"
		return
	fi
	filename=`echo "${1}"|sed 's/\.[^.]\+$//g'`
	pdf2ps "${1}" "${filename}_tmp.ps"
	psnup -1 -b-10 "${filename}_tmp.ps" "${filename}.ps"
	ps2pdf -dEPSCrop "${filename}.ps" "${filename}.pdf"
	rm "${filename}_tmp.ps"
}
