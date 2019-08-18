# Module Imports
import lxml.etree
import pathlib
import sys

# Logging Configuration
from logging import getLogger
cdef object logger = getLogger()

#################### XML Namespaces##############################
xmlns = {
    "xml": "http://www.w3.org/XML/1998/namespace",
    "book": "http://docbook.org/ns/docbook",
    "xi": "http://www.w3.org/2001/XInclude",
    "xsl": "http://www.w3.org/1999/XSL/Transform",
    "xlink": "http://www.w3.org/1999/xlink",
    "dion": "http://avoceteditors.com/xml/dion"
}
xmlrns = {v: k for k, v in xmlns.items()}

######################## Build LaTeX Preamble #################


def latex_packages(str build_type):
    cdef list packages, gen_format, preamble

    packages = [
        ('graphicx', None),
        ('fancyhdr', None),
        ('inputenc', ['utf8']),
        ('hyperref', ['hidelinks']),
        ('setspace', None),
        ('babel', ['english']),
        ('csquotes', ['autostyle', 'english=american']),
        ('titlesec', ['noindentafter', 'explicit']),
        ('lettrine', None),
        ('framed', None),
        ('pifont',None),
        ('appendix', ['toc, page']),
        ('geometry', ['margin=1in']),
        ('pgfornament', ['object=vectorian']),
        ('fontspec', None),
        ('tipa', None),
        ('footmisc', None),
        ('textgreek', ['euler']),
        ('multicol', None)]


    gen_format = []
    for i in ['part', 'chapter', 'section', 'subsection', 'subsubsection', 'paragraph', 'subparagra']:
        text = '\\titleformat{\\%s}{}{}{}{}' % i
        gen_format.append(text)
        text = '\\titlespacing{\\%s}{}{}{}{}' % i
        gen_format.append(text)

    gen_format.append('\\frenchspacing')

    if build_type in ['novel', 'book']:
        preamble = ['\\documentclass[twoside, 10pt, b5paper]{book}']
        spacing = '1'
    else:
        preamble = ['\\documentclass[oneside, 12pt, letterhead]{book}']
        spacing = '1.5'


    for (name, opts) in packages:
        if opts is None:
            preamble.append("\\usepackage{%s}" % name)
        else:
            preamble.append("\\usepackage[%s]{%s}" % (', '.join(opts), name))

    for i in gen_format:
        preamble.append(i)

    preamble.append('\\linespread{%s}' % spacing)

    sectionline = ["% Sectionline Command",
            "\\newcommand{\\sectionline}{%",
            "\\nointerlineskip\\noindent\\vspace{.8\\baselineskip}\\hspace{\\fill}",
            "{\\resizebox{0.5\\linewidth}{2ex}",
            "{{{\\begin{tikzpicture}",
            "\\node  (C) at (0,0) {};",
            "\\node (D) at (5,0) {};",
            "\\path (C) to [ornament=88] (D);",
            "\\end{tikzpicture}}}}}%",
            "\\hspace{\\fill}"
            "\\par\\nointerlineskip \\vspace{0.1in}}"]
    preamble.append('\n'.join(sectionline))

    return '\n'.join(preamble)


#################### XPath operation #########################
def xpath(str target, object source):
    return source.xpath(target, namespaces=xmlns)


###################### Open Files ###########################
def open_xml(object path):
    """Functions takes a path and opens it as an LXML Element"""
    with open(path, 'rb') as f:
        return lxml.etree.fromstring(f.read())

###################### Process dion:includes ##################
def dinc(object element, object path):
    """Processes a series of dion:include entries for the doctree,
    replacing their contents with elements from specifies files"""

    # Initialize Variables
    cdef str pattern
    cdef int st
    cdef object doctree_new

    pattern = element.attrib['src']

    for i in path.parent.glob(pattern):
        try:
            logger.debug(f"Adding dion:include for: {i}")
            doctree_new = open_xml(i)

            for r in xpath("//dion:include", doctree_new):
                dinc(r, i.parent)

            st = i.stat().st_mtime

            doctree_new.set('{%s}include' % xmlns['dion'], 'yes')
            doctree_new.set('{%s}path' % xmlns['dion'], str(i))
            doctree_new.set('{%s}mtime' % xmlns['dion'], f'{st}')

            element.addnext(doctree_new)
            #element.clear()
        except Exception as e:
            logger.warning(f"Error processing dion:include to {i}: {e}")


################## Process Lettrine Text #########################
def lettrine(object lett):
    cdef object p = lett.getparent().getparent()

    if p.tag == "{%s}chapter" % xmlns['book'] or p.tag == "{%s}article" % xmlns['book']:
        lett.attrib['rubric'] = lett.text[0]
        if len(lett.text) > 1:
            lett.text = lett.text[1:]
        else:
            lett.text = ''

########################## Process dion:entry #########################
def process_dictionary_entries(object entry):
    cdef int count
    cdef list ddefs
    cdef object ddef
     
    count = 0
    ddefs = xpath("dion:definition", entry)

    if len(ddefs) > 1:
        for ddef in ddefs:
            count += 1
            ddef.set('counter', f'{str(count)}')
    elif ddefs != []:
        ddefs[0].set('counter', '')


######################### Validate Uniquenss ###########################
def validate_idref_uniqueness(object doctree):
    """Checks each xml:id for uniqueness """
    cdef list data = []
    cdef dict idrefs = {}

    for target in xpath("//@xml:id", doctree):
        try:
            idrefs[target] += 1
        except:
            idrefs[target] = 1

    cdef int check = False
    for i in idrefs:
        if idrefs[i] > 1:
            logger.warn("Duplicate xml:id entries for '{i}': {idrefs[i]}")
            check = True

    if check:
        sys.exit(1)

################### Fetch and Process Source Data ##############
def fetch_source(object config):
    """ Functions fetches, opens and processes XML documents 
    to build the base doctree, performing additional preprocessing
    tasks to prepare the doctree for use."""
    logger.info("Compiling source data")

    # Init Variables
    cdef object path, doctree, i

    try:
        path = pathlib.Path(config['config']['path'])

        # Open and Process base file
        logger.debug("Initializing Doctree")
        doctree = open_xml(path)

        # Process dion:includes
        for i in xpath("//dion:include", doctree):
            try:
                dinc(i, path)
            except Exception as e:
                logger.warning(f"Error occurred while processing dion:includes in source file: {e}")

        # Preprocess Lettrines
        logger.debug("Preprocessing lettrines")
        for i in xpath("//dion:lett", doctree):
            try:
                lettrine(i)
            except Exception as e:
                logger.warning(f"Error processing lettrine text: {e}")

        # Preprocess Lexica
        logger.debug("Preprocessing dictionary entries")
        for i in xpath("//dion:entry", doctree):
            process_dictionary_entries(i)

        return doctree
            
    except Exception as e:
        logger.warning(f"Error compiling XML: {e}")

################################ BUILD SOURCE #####################################
def process_doctree(object config, object src, str idref, str build_type, str build_target):
    cdef object , name, surname, pub, pubname, pubcities
    cdef str author_name, author_surname, publisher_name, publisher_cities
    cdef list doctree, result_set = []

    if idref != '':
        doctree = xpath("//%s[@xml:id='%s']" % (build_target, idref), src)
    else:
        doctree = xpath("//%s" % build_target, src)

    if len(doctree) < 1:
        sys.exit("Unable to locate document")
        sys.exit(1)
    else:
        author_name = config['config']['author']['name']
        author_surname = config['config']['author']['surname']
        publisher_name = config['config']['publisher']['name']
        publisher_cities = ' + '.join(config['config']['publisher']['cities'])
        for i in doctree:
            info = i.find("book:info", namespaces=xmlns)

            # Add Author Information
            author = lxml.etree.Element('{%s}author' % xmlns['dion'])
            name = lxml.etree.Element('{%s}name' % xmlns['dion'])
            name.text = author_name
            surname = lxml.etree.Element('{%s}surname' % xmlns['dion'])
            surname.text = author_surname
            author.append(name)
            author.append(surname)
            info.append(author)

            # Add Publisher Information
            pub = lxml.etree.Element('{%s}publisher' % xmlns['dion'])
            pubname = lxml.etree.Element('{%s}name' % xmlns['dion'])
            pubname.text = publisher_name
            pub.append(pubname)
            pubcities = lxml.etree.Element('{%s}cities' % xmlns['dion'])
            pubcities.text = publisher_cities
            pub.append(pubcities)
            info.append(pub)

            if build_type != 'web':
                latex = lxml.etree.Element("{%s}latex-preamble" % xmlns['dion'])
                latex.text = latex_packages(build_type)
                info.append(latex)
            result_set.append(i)
             
    return result_set





