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
import re

# Local Imports
import dion.file

# Configure Logger
from logging import getLogger
logger = getLogger()

################################## REGEX ################################
newline = re.compile("\n")
comment_pattern = re.compile("%")
ws_pattern = re.compile("^\s*$")
doc_pattern = re.compile("^\\\\documentclass")

inc_pattern = re.compile("^\\\\INCLUDE{(.*?)}")

star = re.compile("\\*")

################################## LaTeX Class ################################
class LaTeX(dion.file.File):

    def read(self):
        self.is_doc = False
        self.mtimes = [self.mtime]

        # Read Text
        with open(self.path, "r") as f:
            self.content = f.read()

        # Find Documents
        for i in re.split(newline, self.content):
            if re.match(doc_pattern, i):
                self.is_doc = True
                break
            elif re.match(ws_pattern, i) or re.match(comment_pattern, i):
                continue
            else:
                break

    def lastmod(self):
        return max(self.mtimes)

    def compile(self, src):

        text = []
        parent = self.path.parent

        for line in re.split(newline, self.content):
            incs = re.findall(inc_pattern, line)
            if len(incs) > 0:
                inc = incs[0]
                if re.match(star, inc):
                    logger.warn("Support for wildcards is not yet available")
                else:
                    subpath = parent.joinpath(f"{inc}.tex").resolve()
                    if subpath in src.data_tex:
                        subtex = src.data_tex[subpath]
                        subtex.compile(src)
                        self.mtimes += subtex.mtimes

                        text.append(subtex.content)
            else:
                text.append(line)
        self.content = "\n".join(text)
                      
def read(path):
    latex = LaTeX(path)

    latex.read()

    if latex.valid:
        return latex


