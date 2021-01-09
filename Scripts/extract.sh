INFILE=template.tex

CUSTOM_STR_BEGIN="%%  BEGINING OF TEMPLATE COSTUMIZATION"
ATTRIBUTES_STR_BEGIN="%%  DOCUMENT ATTRIBUTES"

CUSTOM_STR_LINE=$(fgrep -n "$CUSTOM_STR_BEGIN" $INFILE  | cut -d ':' -f 1)
ATTRIBUTES_STR_LINE=$(fgrep -n "$ATTRIBUTES_STR_BEGIN" $INFILE  | cut -d ':' -f 1)

if [[ -z "$CUSTOM_STR_LINE" || -z "ATTRIBUTES_STR_LINE" ]]; then
	echo Could not extract the CUSTOMIZATION CODE!  Aborting...
	exit 1
fi

echo $CUSTOM_STR_LINE $ATTRIBUTES_STR_LINE

NLINES=$(( $ATTRIBUTES_STR_LINE - $CUSTOM_STR_LINE + 1 ))
cat $INFILE | head -$ATTRIBUTES_STR_LINE | tail -$NLINES  > custom_lines.txt

# TITLE=$(cat $INFILE | perl -p -e 's/^\\nttitle{(.*)}/-\1-/')
cat $INFILE | grep -n "^\\\\nttitle"