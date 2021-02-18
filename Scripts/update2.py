# ============================================================
#  IMPORTS
# ============================================================
# from __future__ import print_function
from optparse import OptionParser
import os
import shutil
import sys
import zipfile
import glob
import urllib2
import re

# ============================================================
#  CONFIG VARIABLES
# ============================================================
novathesis_git_default = "novathesis.git"
novathesis_git_url = "git clone https://github.com/joaomlourenco/novathesis.git"

novathesis_zip_default = "novathesis.zip"
novathesis_zip_url = "https://github.com/joaomlourenco/novathesis/archive/master.zip"
# novathesis_zip_url = "https://github.com/joaomlourenco/novathesis/zipball/master"
g_valid_protocols = ('g', 'r', 'z', 'f')

g_required_commands = {
    'r': [],
    'z': [],
    'g': ['git'],
    'f': [],
}

# ============================================================
#  INTERNAL VARIABLES
# ============================================================
g_urls_keys = ['src', 'nt', 'out']
g_urls = {
    'src': "",
    'nt': "",
    'out': "",
}

g_folders = {}

template_info = {
    'src': {
        'options': [],
        'packages': [],
        'cover': [],
        'files': [],
    },
    'nt': {
        'options': [],
        'packages': [],
        'cover': [],
        'files': [],
    },
}

global options
global optionargs

v_print = None


# ============================================================
#  PROCESS OPTIONS
# ============================================================
def process_options(argv):
    parser = OptionParser()
    parser.add_option("-d", "--debug", default=0, action="count", dest="verbose", help="increase verbosity level")
    # parser.add_option("-n", "--dry-run", action="store_true", default=False, help="take no effect")
    parser.add_option("-r", "--retry", action="store_true", default=False, help="Retry using folders")
    parser.add_option("-p", "--patch", default="opcf", metavar="LIST",
                      help="LIST of what to patch?                             (o)ptions, (p)ackages, (c)over, (f)iles")
    parser.add_option("-4", "--src", choices=g_valid_protocols, default="f", help="source for Source")
    parser.add_option("-5", "--nt", choices=g_valid_protocols, default="f", help="source for NOVAthesis")
    parser.add_option("-o", "--out", choices=('f',), default="f", help="destination")
    global options
    global optionargs
    (options, optionargs) = parser.parse_args(argv)
    nargs = len(optionargs)
    if nargs != 3:
        parser.error("Expected 3 arguments: <src_URL|src_DIR> <nt_URL|nt_DIR> <out_DIR>\nGot " + str(optionargs))
    else:
        for i in range(0, nargs):
            g_urls[g_urls_keys[i]] = optionargs[i]
    if options.verbose:
        def _v_print(*args):
            # Print each argument separately so caller doesn't need to
            # stuff everything to be printed into a single string
            if args[0] >= options.verbose:
                for i in args[1:]:
                    print i,
            print
    else:
        def _v_print(*args):
            pass
    global v_print
    v_print = _v_print
    v_print(1, options)
    v_print(1, g_urls)


# ============================================================
#  AUX FUNCTIONS
# ============================================================
def which(pgm):
    path = os.getenv('PATH')
    for p in path.split(os.path.pathsep):
        p = os.path.join(p, pgm)
        if os.path.exists(p) and os.access(p, os.X_OK):
            return p


def check_external_commands(protocol):
    for cmd in g_required_commands[protocol]:
        p = which(cmd)
        if p is None:
            print("Command '{}' not fond!  Aborting...".format(cmd))
            sys.exit(1)


def get_remote_zip(url, file_name=None):
    # type: (str, str) -> str
    if file_name is None:
        file_name = url.split('/')[-1]
    if os.path.exists(file_name):
        print ("Error: file '{0}' already exists! Aborting...".format(file_name))
        sys.exit(1)
    u = urllib2.urlopen(url)
    meta = u.info()
    content_length = meta.getheaders("Content-Length")
    if content_length is []:
        file_size = -1
    else:
        file_size = int(content_length[0])
    if options.verbose > 0:
        print ("Downloading: '{0}' Bytes: {1}".format(url, file_size))
    # Download
    file_size_dl = 0
    block_sz = 8192
    f = open(file_name, 'wb')
    while True:
        buffer = u.read(block_sz)
        if not buffer:
            break
        file_size_dl += len(buffer)
        file_one_hundred = file_size / 100.0
        f.write(buffer)
        if options.verbose > 0 and file_size != -1:
            print_progress_bar(file_size, file_size_dl)
    print('')
    f.close()
    return file_name


def print_progress_bar(file_size, file_size_dl):
    status = "\r{0:10d}  [{1:3.2%}]".format(file_size_dl, float(file_size_dl) / file_size)
    print status,
    sys.stdout.flush()


# ============================================================
#  LOAD / SAVE TEMPLATE
# ============================================================
template_filename = "template.tex"
template_old_filename = "template-OLD.tex"


def load_template(target):
    with open(target) as f:
        template = "".join(line for line in f)
    return template


def save_template(template):
    os.rename(template_filename, template_old_filename)
    # v_print(1, "Saving updated version to '{0}'".format(t_path)
    with open(template_filename, "w") as text_file:
        text_file.write(template)


# ============================================================
#  DOWNLOAD AND MAKE FOLDER
# ============================================================
def make_folder_git(opt, url):
    # type: (str, str) -> None
    default_dest = './v4'
    if url == novathesis_git_default:
        url = novathesis_git_url
    if os.path.exists(default_dest):
        print("Destination folder {0} already exist".format(default_dest))
        sys.exit(1)
    dir_name = url.split('/')[-1]
    if os.path.exists(dir_name):
        print("Git destination folder {0} already exist".format(dir_name))
        sys.exit(1)
    err = os.system("git clone {0}".format(url))
    if err != 0:
        print ("Error: Git cloning of '{0}' failed! Aborting...".format(url))
        sys.exit(1)
    os.rename(dir_name, default_dest)
    make_folder_folder(opt, default_dest)


def make_folder_remote(opt, url):
    # type: (str, str) -> None
    if url == novathesis_zip_default:
        url = novathesis_zip_url
    filename = get_remote_zip(url)
    make_folder_zip(opt, './' + filename)


def make_folder_zip(opt, url):
    # type: (str, str) -> None
    tempdir = './new_temp_folder_for_zip_file'
    default_dest = './v5'
    if os.path.isfile(url):
        with zipfile.ZipFile(url, 'r') as zip_ref:
            zip_ref.extractall(tempdir)
        dirlist = [dir for dir in glob.glob(os.path.join(tempdir, '*'))]
        if len(dirlist) == 1:
            os.rename(dirlist[0], default_dest)
            os.rmdir(tempdir)
            make_folder_folder(opt, default_dest)
        else:
            print("Found multiple folders in zip file: {1}: {2}".format(url, dirlist))
            sys.exit(1)
    else:
        print("Missing or invalid '{0}' zip file: {1}".format(opt, url))
        sys.exit(1)


def make_folder_folder(opt, url, reuse=True):
    # type: (str, str) -> None
    if os.path.exists(url) == reuse:
        g_folders[opt] = url
    else:
        print("Invalid '{0}' folder: {1}".format(opt, url))
        sys.exit(1)


def make_folder(opt, protocol, url):
    # type: (str, str, str) -> None
    if protocol == 'g':
        make_folder_git(opt, url)
    elif protocol == 'r':
        make_folder_remote(opt, url)
    elif protocol == 'z':
        make_folder_zip(opt, url)
    elif protocol == 'f':
        make_folder_folder(opt, url)


# ============================================================
#  EXTRACT INFO
# ============================================================
def extract_info(version):
    v_print(1, "EXTRACT_INFO({})".format(version))
    os.chdir(g_folders[version])
    template = load_template('template.tex')
    v_print(1, "{0} OPTIONS".format(version))
    extract_info_options(template, version)
    v_print(1, "{0} PACKAGES".format(version))
    extract_info_packages(template, version)
    v_print(1, "{0} COVER".format(version))
    extract_info_cover(template, version)
    v_print(1, "{0} FILES".format(version))
    extract_info_files(template, version)
    v_print(1, print_template_info(version))
    os.chdir('..')


def print_template_info(version):
    print('------------------------------------------------------')
    print("FINAL for '{0}'".format(version))
    print('------------------------------------------------------')
    for i in ('options', 'packages', 'cover', 'files'):
        print(i.upper())
        for j in sorted(template_info[version][i]):
            print("\t{0}".format(j))
    return ''


def extract_info_files(template, version):
    for opt in ['dedicatory', 'acknowledgements', 'abstract', 'glossary', 'acronyms',
                'symbols', 'aftercover', 'chapter', 'appendix', 'annex', 'bib']:
        for m in re.finditer(r'\n\s*\\(add)?' + opt + r'file((\s*(\{.*\})|(\[.*\]))*)', template):
            opt_val = m.group(2)
            # v_print(1, "\t{0}={1}".format(opt, opt_val))
            if opt_val not in template_info[version]['files']:
                template_info[version]['files'].append("{0}={1}".format(opt, opt_val))
    if len(template_info[version]['files']) == 0:
        for opt in ['dedicatory', 'acknowledgements', 'abstract', 'glossaries', 'aftercover',
                    'chapter', 'appendix', 'annex', 'addbib', 'bib']:
            for m in re.finditer(r'\n\s*\\ntaddfile\{' + opt + r'\}((\s*(\{.*\})|(\[.*\]))*)', template):
                opt_val = m.group(1)
                # v_print(1, "\t{0}={1}".format(opt,opt_val))
                if opt_val not in template_info[version]['files']:
                    template_info[version]['files'].append("{0}={1}".format(opt, opt_val))


def extract_info_cover(template, version):
    for opt in ['majorfield', 'degreename', 'specialization', 'sponsors', 'title', 'authorname',
                'authordegree', 'datemonth', 'dateyear', 'adviser', 'coadviser', 'committee']:
        regex = r'\n\s*\\(nt)?' + opt + r'((\s*(\{.*\})|([\[\(].*[\]\)]=?))*)'
        for m in re.finditer(regex, template):
            opt_val = m.group(2)
            if opt == 'title':
                regex = r'(\[(.*)\])?\s*\{(.*)\}'
                m = re.match(regex, opt_val)
                opt_val = m.group(2)
                if opt_val is None:
                    opt_val = m.group(3)
                opt_val = '{' + opt_val + '}'
            elif opt == 'adviser' or opt == 'coadviser':
                opt_val = re.sub(r'\}\{', ', ', opt_val)
                opt_val = re.sub(r'\\&', r'\\\\', opt_val)
            # v_print(1, "\t{0}={1}".format(opt,opt_val))
            if opt_val not in template_info[version]['cover']:
                template_info[version]['cover'].append("{0}={1}".format(opt, opt_val))


def extract_info_packages(template, version):
    for opt in ('usepackage',):
        for m in re.finditer(r'\n\s*\\usepackage\{(.*)\}', template):
            opt_val = m.group(1)
            # v_print(1, "\t{0}".format(opt_val))
            if opt_val not in template_info[version]['packages']:
                template_info[version]['packages'].append(opt_val)


def extract_info_options(template, version):
    for opt in ['docdegree', 'school', 'lang', 'coverlang', 'copyrightlang', 'copyrightlang',
                'fontstyle', 'chapstyle', 'aftercover', 'linkscolor', 'printcommittee', 'media']:
        m = re.search(r'\n\s*(\\ntsetup\{)?(' + opt + r'\s*=\s*[\w/]+)', template)
        if m != None:
            opt_val = m.group(2)
            # v_print(1, "\t{0}".format(opt_val))
            if opt_val not in template_info[version]['options']:
                template_info[version]['options'].append(opt_val)


def make_dest(src, nt, out):
    v_print(1, "MAKE_DEST({0}, {1}, {2})".format(src, nt, out))
    v_print(1, "\tCopy {0} -> {1}".format(nt, out))
    shutil.copytree(nt, out)
    for i in ['Chapters', 'Examples', '_config.yml', 'bibliography.bib', 'template.pdf']:
        make_dest_delete(i, out)
    srcfiles = glob.glob('{0}/*.bib'.format(src)) + ['{0}/Chapters'.format(src)]
    for i in srcfiles:
        make_dest_copy(i, out, src)


def make_dest_copy(i, out, src):
    i = i.split('/')[2]
    v_print(1, "\tCopy {0}/{1} -> {2}/{3}".format(src, i, out, i))
    if os.path.isdir('{0}/{1}'.format(src, i)):
        shutil.copytree("{0}/{1}".format(src, i), "{0}/{1}".format(out, i))
    else:
        shutil.copy("{0}/{1}".format(src, i), "{0}/{1}".format(out, i))


def make_dest_delete(i, out):
    v_print(1, "\tRemoving {0}/{1}".format(out, i))
    if os.path.isdir("{0}/{1}".format(out, i)):
        shutil.rmtree("{0}/{1}".format(out, i))
    else:
        os.remove("{0}/{1}".format(out, i))


# ============================================================
#  PATCHING
# ============================================================
def patch_options(template, src):
    v_print(1, "\tPatching OPTIONS")
    for i in template_info[src]['options']:
        template = patch_options_option(i, template)
    print("WARNING!! Bibliography style not patched!  Please open 'template2.tex' and select one yourself!")
    return template


def patch_options_option(i, template):
    v_print(1, "\t\tpatch_options_option({0})".format(i))
    opt, val = i.split('=')
    template = re.sub(r'\n\s*(%?)\s*(\\nt(bib)?setup\s*\{.*)\b(' + opt + r'\s*=.*)(\})',
                      '\n\\2' + opt + '=' + val + '\\5',
                      template)
    return template


def patch_packages(template, src):
    v_print(1, "\tPatching PACKAGES")
    pcks = "\n".join('\\\\usepackage{%s}' % i for i in template_info[src]['packages'])
    template = re.sub(r'((\n\s*)?(\n\s*%?\s*\\usepackage.*))+', '\n' + pcks, template)
    return template


cover_done = {
}


def patch_cover(template, src):
    v_print(1, "\tPATCH_COVER")
    for i in template_info[src]['cover']:
        opt, val = i.split('=', 1)
        if opt in ['majorfield', 'degreename', 'specialization', 'sponsors']:
            template = patch_cover_majorfield(opt, template, val)
        elif opt in ['title', 'authorname', 'authordegree', 'datemonth', 'dateyear']:
            template = patch_cover_authorname(opt, template, val)
        elif opt in ['adviser', 'coadviser', 'committee']:
            template = patch_cover_adviser(opt, template, val)
        else:
            print("\t\tInvalid option: '{0}'".format(opt))
            sys.exit(2)
    return template


def patch_cover_adviser(opt, template, val):
    if cover_done.get(opt, True):
        template = re.sub(
            r'(\n\s*%\s*syntax:\s*\\ntaddperson\{' + opt + r'\}.*)(\n\s*%?\s*\\ntaddperson\{' + opt + r'\}.*)*',
            r'\1', template)
        cover_done[opt] = False
    template = re.sub(
        r'(\n\s*%\s*syntax: \\ntaddperson\{' + opt + r'\}.*)((\n\\ntaddperson\{' + opt + r'\}.*)*)',
        '\\1\\2\n\\\\ntaddperson{' + opt + '}' + val, template)
    return template


def patch_cover_authorname(opt, template, val):
    template = re.sub(r'(\n\s*\\nt' + opt + r'.*)',
                      '\n\\\\nt' + opt + val, template)
    return template


def patch_cover_majorfield(opt, template, val):
    if cover_done.get(opt, True):
        template = re.sub(r'(\n\s*%\s*syntax:\s*\\nt' + opt + r'.*)(\n\s*%?\s*\\nt' + opt + r'.*)*', r'\1',
                          template)
        cover_done[opt] = False
    val2 = re.sub(r'\[(.*)\]\s*=?\s*(\{.*\})', '(\\1)\\2', val)
    template = re.sub(r'(\n\s*%\s*syntax: \\nt' + opt + r'.*)((\n\\nt' + opt + r'.*)*)',
                      '\\1\\2\n\\\\nt' + opt + val2, template)
    return template


def patch_files(template, src):
    v_print(1, "\tPATCH_FILES")
    v_print(1, "\t\tDeleting example files...")
    for opt in ['bib', 'dedicatory', 'acknowledgements', 'quote', 'glossaries', 'chapter', 'appendix', 'annex',
                'aftercover']:
        template = patch_files_delete(opt, template)
    for i in template_info[src]['files']:
        template = patch_files_add(i, template)
    return template


def patch_files_add(i, template):
    v_print(1, "PATCH_FILES_add({0})".format(i))
    opt, val = i.split('=')
    if opt in ['glossary', 'acronyms', 'symbols']:
        template = re.sub(r'(\n\s*%\s*syntax: \\ntaddfile{glossaries}.*)((\n\\ntaddfile{glossaries}.*)*)',
                          '\\1\\2\n\\\\ntaddfile{glossaries}[' + opt + ']' + val, template)
    else:
        template = re.sub(r'(\n\s*%\s*syntax: \\ntaddfile\{' + opt + r'\}.*)((\n\\ntaddfile\{' + opt + r'\}.*)*)',
                          '\\1\\2\n\\\\ntaddfile{' + opt + '}' + val, template)
    return template


def patch_files_delete(opt, template):
    template = re.sub(
        r'(\n\s*%\s*syntax:\s*\\ntaddfile\{' + opt + r'\}.*)(\n\s*%?\s*\\ntaddfile\{' + opt + r'\}.*)*', r'\1',
        template)
    return template


patch_function = {
    'o': patch_options,
    'p': patch_packages,
    'c': patch_cover,
    'f': patch_files,
}


def patch_template(src, nt, out):
    v_print(1, "PATCH_TEMPLATE({0}, {1}, {2})".format(src, nt, out))
    os.chdir(g_folders[out])
    template = load_template('template.tex')
    for i in ('o', 'p', 'c', 'f'):
        if i in options.patch:
            template = patch_function[i](template, src)
    save_template(template)


# ============================================================
#  MAIN
# ============================================================
def main(argv):
    process_options(argv)
    for i in ['src', 'nt']:
        check_external_commands(getattr(options, i))
    for i in ['src', 'nt']:
        make_folder(i, getattr(options, i), g_urls[i])
    make_folder_folder('out', g_urls['out'], False)
    extract_info('src')
    extract_info('nt')
    make_dest(g_folders['src'], g_folders['nt'], g_folders['out'])
    patch_template('src', 'nt', 'out')


if __name__ == "__main__":
    main(sys.argv[1:])
