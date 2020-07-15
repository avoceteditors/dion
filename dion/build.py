"""build.py - Functions to build compiled document """
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
import glob
import lxml.etree
import pathlib
import pkg_resources
import shutil
import subprocess
import sys

# Local Imports
import dion.log

# Configure Logger
logger = dion.log.get_logger('dion')


def run_html(source, output):
    """Builds HTML documents"""
    logger.debug("Building HTML documents")

    xsl = pkg_resources.resource_filename("dion", "data/html.xsl")

    command = ['saxsl',
               "-s:%s" % str(source),
               "-xsl:%s" % str(xsl),
               "-o:%s" % str(output.joinpath("dion.log")),
               "-xi"
               ]
    logger.debug("Running Saxon")
    subprocess.run(command)

def run_latex(source, tmp):
    """Builds LaTeX document"""
    logger.debug("Building LaTeX document")

    xsl = pkg_resources.resource_filename('dion', 'data/latex.xsl')

    command = ['saxsl',
               "-s:%s" % str(source),
               "-xsl:%s" % str(xsl),
               "-o:%s" % str(tmp.joinpath("dion.log")),
               "-xi"
               ]

    logger.debug("Running Saxon")
    subprocess.run(command)

def postprocess_latex(path, engine, pdf_dir, force):
    logger.debug("Postprocessing LaTeX: %s" % str(path))

    sty = path.parent.joinpath('dion.sty')
    if not sty.exists() or force:
        sty_path = pkg_resources.resource_filename('dion', 'data/dion.sty')
        shutil.copyfile(sty_path, sty)

    # Run LaTeX
    subprocess.run([engine, "--output-directory=%s" % str(path.parent), str(path)])

    # PDF File
    logger.debug("Copying PDF build to target directory")
    target_pdf = pdf_dir.joinpath("%s.pdf" % path.stem)
    base_pdf = path.parent.joinpath("%s.pdf" % path.stem)
    shutil.copyfile(base_pdf, target_pdf)

# Run Main Process
def run(args):
    """Runs build CLI process"""
    logger.info("Called build operation")

    source = pathlib.Path(args.source)
    output = pathlib.Path(args.output)

    if not source.exists():
        logger.warn("Source path does not exist")
        sys.exit(1)

    if args.type in ["book", "chapter"]:

        # Ensure Output Directories
        output_tex = output.joinpath("latex")
        output_pdf = output.joinpath("pdf")

        for i in [output_tex, output_pdf]:
            if not i.exists():
                i.mkdir(parents=True)

        run_latex(source, output_tex)

        if args.post_process:
        
            try:
                command = []
                doc = lxml.etree.parse(str(source)).getroot()

                latest = dion.xml.find_last_edit(doc, args.type, args.all)

                for i in latest:
                    idref = i.get(dion.xml.id_attr)
                    tex_path = output_tex.joinpath(f"{idref}.tex")
                    if tex_path.exists():
                        postprocess_latex(tex_path, args.engine, output_pdf, args.force)

            except Exception as err:
                logger.error("Error in postprocessing: %s" % err)


    elif args.type == "web":

        # Ensure Output Directory
        output_html = output.joinpath("html")
        if not output_html.exists():
            output_html.mkdir(parents=True)

        run_html(source, output_html)

        if args.post_process:
            images = output_html.joinpath("images")
            static = output_html.joinpath("static")
            images_src = pathlib.Path("./images")
            static_src = pathlib.Path("./static")

            for (src, target) in [(images_src, images), (static_src, static)]:

                if src.exists():

                    # Create Target Directory
                    if not target.exists():
                        target.mkdir(parents=True)

                    # Command
                    for i in src.rglob("*"):
                        subprocess.run(["cp", "-R", str(i), str(target)])
                else:
                    logger.warn("Path not found: %s" % str(src))


