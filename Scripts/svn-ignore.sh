#!/bin/bash

STDIGN="`dirname $0`/latex-ignore.txt"
LOCALIGN=latex-ignore.txt

[ -f "$STDIGN" ] && svn propset svn:ignore -F "$STDIGN" $@
[ -f "$LOCALIGN" ] && svn propset svn:ignore -F "$LOCALIGN" $@
