#!/bin/bash

STDIGN="`dirname $0`/latex-ignore.txt"
LOCALIGN=latex-ignore.txt

[ -f "$STDIGN" ] && rm -f `cat "$STDIGN" | xargs`
[ -f "$LOCALIGN" ] && rm -f `cat "$LOCALIGN" | xargs`
