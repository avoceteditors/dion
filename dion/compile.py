"""compile.py - Compiles source XML document """
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
import lxml.etree
import pathlib
import sys

# Local Imports
import dion.log
import dion.xml

# Configure Logger
logger = dion.log.get_logger("dion")


# Run Main CLI process
def run(args):
    """Main CLI process called from command-line to
    compile XML document with relevant includes into
    a cache.xml file"""
    logger.info("Called compile command")

    # Read Source
    source = pathlib.Path(args.source)

    if not source.exists():
        logger.warn("Source path does not exist: %s" % str(source))
        sys.exit(1)

    try:
        # Read in XML data
        doc = lxml.etree.parse(str(source))
        doc.xinclude()

        # Stat Element
        element = doc.getroot()
        dion.xml.stat_element(element, source)

        for dinc in dion.xml.xpath(element, "//dion:include"):
            dion.xml.process_dinc(dinc, source)

        # Preprocess
        dion.xml.wc(element)

    except Exception as err:
        logger.warn("Issue compiling XML data: %s" % err)
        sys.exit(1)



    # Output
    data = lxml.etree.tostring(element, pretty_print=True)

    output = pathlib.Path(args.output)
    if not output.parent.exists():
        output.parent.mkdir(parents=True)
    with open(output, 'wb') as f:
        f.write(data)

