#!/usr/bin/env python3
import sys
import re

if len(sys.argv) != 3:
    print('Usage: patchfile <infile> <outfile>')
    sys.exit(1)

infile=sys.argv[1]
outfile=sys.argv[2]

for i in sys.argv:
	print('Arg:' + i)

print ('INFILE=' + infile)
print ('OYFILE=' + outfile)

# read INPUT file into inputfile
try:
    with open(infile, 'r') as inf:
        inputfile=inf.read()
except OSError as exc:    # Python 2. For Python 3 use OSError
    tb = sys.exc_info()[-1]
    lineno = tb.tb_lineno
    filename = tb.tb_frame.f_code.co_filename
    print('{} at {} line {}.'.format(exc.strerror, filename, lineno))
    sys.exit(exc.errno)

# read OUTPUT file into outputfile
try:
    with open(outfile, 'r') as outf:
        outputfile=outf.read()
except OSError as exc:    # Python 2. For Python 3 use OSError
    tb = sys.exc_info()[-1]
    lineno = tb.tb_lineno
    filename = tb.tb_frame.f_code.co_filename
    print('{} at {} line {}.'.format(exc.strerror, filename, lineno))
    sys.exit(exc.errno)

# process class options
for i in [ "docdegree", "school", "lang", "printcommittee" ]:
	regexin=f"^\s*({i})=([^ ,]*).*$"
	m = re.search(regexin, inputfile, re.MULTILINE)
	if m != None:
		key=m.group(1)
		val=m.group(2)
		print (f"Found IN [{key}={val}]")
		regexout="%*\s*(\\\\ntsetup){("+key+")=(.*)}"
		m=re.search(regexout, outputfile, re.MULTILINE)
		if m != None:
			# key=m.group(2)
			# val=m.group(3)
			print (f"Found OUT [{key}={val}]")
			outputfile = re.sub(regexout,r"\1{\2="+val+"}", outputfile, re.MULTILINE)
		else:
			print (f"Search for [{regexout}] failed!")
	else:
		print (f"Search for [{regexin}] failed!")

# process title
regexin="^\s*(\\\\title)\s?(\[(.*)\])?\s*{(.*)}"
m = re.search(regexin, inputfile, re.MULTILINE)
if m != None:
	t1=m.group(3)
	t2=m.group(4)
	if t1 != None:
		t1=t2
	regexout="^%*\s*(\\\\nttitle){(.*)}"
	m=re.search(regexout, outputfile, re.MULTILINE)
	if m != None:
		print (f"Replacing OUT nttitle")
		outputfile = re.sub(regexout,r"\1{"+t1+"}", outputfile, re.MULTILINE)
	else:
		print (f"Search for [{regexout}] failed!")
else:
	print (f"Search for [regexin] failed!")

print (outputfile)
