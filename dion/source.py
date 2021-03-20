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

import dion.yml

class Source:

    def __init__(self, path, registry):
        self.path = path
        self.data_yml = {}
        self.data_tex = {}
        self.data_rst = {}
        self.data_other = {}
        self.registry = registry
        self.update()


    def update(self):
        for i in self.path.rglob("*"):
            if i.is_file():
                self.append(i)
        
    def files(self):
        data = {}
        data.update(self.data_yml)
        data.update(self.data_tex)
        data.update(self.data_rst)
        return data

    def __repr__(self):
        return f"[YaML: {len(self.data_yml)}, LaTeX: {len(self.data_tex)}, RST: {len(self.data_rst)}, Other: {len(self.data_other)}]"

    def append(self, path):
        if path.suffix == ".tex":
            self.data_tex[path] = None
        elif path.suffix == ".rst":
            self.data_rst[path] = None
        elif path.suffix == ".yml":
            self.data_yml[path] = dion.yml.read(path) 
        else:
            self.data_other[path] = None

    def update_registry(self):

        for data in self.data_yml.values():
            lang = data.get("language", None)
            if lang is not None:
                self.registry.update(lang, data)



