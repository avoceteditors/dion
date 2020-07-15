"""xml.py - Common functions and variables for XML data"""
##############################################################################
# Copyright (c) 2020, Kenneth P. J. Dyer <kenneth@avoceteditors.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
# * Neither the name of the copyright holder nor the name of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
##############################################################################

# Module Imports
import datetime
import re
import lxml.etree

# Local Imports
import dion.log

# Configure Logger
logger = dion.log.get_logger("dion")

# XML Namespaces
ns = {
    "book": "http://docbook.org/ns/docbook",
    "xi": "http://www.w3.org/2001/XInclude",
    "xsl": "http://www.w3.org/1999/XSL/Transform",
    "xlink": "http://www.w3.org/1999/xlink",
    "dion": "http://avoceteditors.com/xml/dion",
    "py": "http://genshi.edgewall.org",
    "xml": "http://www.w3.org/XML/1998/namespace"
}

path_attr = "{%s}path" % ns['dion']
mtime_attr = "{%s}mtime" % ns['dion']
hmtime_attr = "{%s}hmtime" % ns['dion']
atime_attr = "{%s}atime" % ns['dion']
hatime_attr = "{%s}hatime" % ns['dion']
ctime_attr = "{%s}ctime" % ns['dion']
hctime_attr = "{%s}hctime" % ns['dion']

dstat_lines = "{%s}lines" % ns['dion']
dstat_words = "{%s}words" % ns['dion']
dstat_chars = "{%s}chars" % ns['dion']
dstat_plines = "{%s}plines" % ns['dion']
dstat_pwords = "{%s}pwords" % ns['dion']
dstat_pchars = "{%s}pchars" % ns['dion']

date_format = "%A, %B %d, %Y"

pretty_format = "{:,.0f}"

book_tag = "{%s}book" % ns['book']
chapter_tag = "{%s}chapter" % ns['book']
article_tag = "{%s}article" % ns['book']

id_attr = "{%s}id" % ns['xml']

# Process XPath
def xpath(element, path):
    """Runs XPath with default namespaces"""
    return element.xpath(path, namespaces=ns)


# Stat XML file
def stat_element(element, path):
    """Loads stat data into XML element"""

    # Set Path
    element.set(path_attr, str(path))

    # Set Stat
    stat = path.stat()

    # Mtime
    mtime = stat.st_mtime
    element.set(mtime_attr, str(mtime))
    hmtime = datetime.datetime.fromtimestamp(mtime).strftime(date_format)
    element.set(hmtime_attr, str(hmtime))

    # Atime
    atime = stat.st_atime
    element.set(atime_attr, str(atime))
    hatime = datetime.datetime.fromtimestamp(atime).strftime(date_format)
    element.set(hatime_attr, str(hatime))

    # Ctime
    ctime = stat.st_ctime
    element.set(atime_attr, str(ctime))
    hctime = datetime.datetime.fromtimestamp(ctime).strftime(date_format)
    element.set(hctime_attr, str(hctime))


# Process dion:include
def process_dinc(element, path):
    """Processes a dion:include element"""
    pattern = element.get("src")
    for i in path.parent.glob(pattern):
        try:

            # Read File
            doc = lxml.etree.parse(str(i))
            doc.xinclude()

            # Fetch Element
            root = doc.getroot()
            stat_element(root, i)

            # Recurse
            for dinc in xpath(root, "//dion:include"):
                process_dinc(dinc, i)

            element.addprevious(root)

        except Exception as err:
            print(path)
            logger.warn(err)

    element.getparent().remove(element)


# Sets WC Statistical Data on Element
def set_wc(element):
    """Collects wordcount data and sets it on the element"""

    # Initialize Variables
    clines = cwords = cchars = 0

    for para in xpath(element, ".//book:para"):
        clines += 1
        for text in xpath(para, ".//text()"):
            words = re.split("\s+", text)

            for word in words:
                if word != '':
                    cwords += 1
                    cchars += len(word)

    element.set(dstat_lines, str(clines))
    element.set(dstat_words, str(cwords))
    element.set(dstat_chars, str(cchars))

    element.set(dstat_plines, pretty_format.format(clines))
    element.set(dstat_pwords, pretty_format.format(cwords))
    element.set(dstat_pchars, pretty_format.format(cchars))


def wc(element):
    """Collects wordcount data"""

    for section in xpath(element, "//book:book|//book:chapter|//book:article"):
        set_wc(section)


# Lettrine Preprocessor
def lett(element):
    """Preprocess element for lettrine occurrences"""

    for chapter in xpath(element, "//book:chapter"):
        first = True

        for lett in xpath(chapter, ".//dion:lett"):
            if first:
                first = False
                # Check not empty
                if lett.text != '':
                    lett.set("rubric", lett.text[0])

                    if len(lett.text) > 2:
                        lett.text = lett.text[1:]
                    else:
                        lett.text = ''


# Find Last Edit
def find_last_edit(element, target, return_all):
    """Finds the most recent edit and returns in list"""
    if target == "chapter":
        pattern = "//book:chapter|//book:article"
        backpattern = "ancestor::book:chapter|ancestor::book:article"
    else:
        pattern = "//book:book"
        backpattern = "ancestor::book:book"

    data = xpath(element, pattern)
    if return_all:
        return data
    else:
        sorted_data = []
        for datum in data:
            for i in xpath(datum, ".//*[@dion:mtime]"):
                mtime = i.get(mtime_attr)
                sorted_data.append((float(mtime), i))

        latest = (0.0, None)
        for (mtime, entry) in sorted_data:
            if mtime > latest[0]:
                latest = (mtime, entry)

        (mtime, entry) = latest
        if entry is None:
            return data
        else:
            return xpath(entry, "./%s" % backpattern)

            
