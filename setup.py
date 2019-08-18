from setuptools import setup, find_packages
from Cython.Build import cythonize

setup(
    name="dion",
    version="2019.2",
    packages = ['dion'], 
    scripts = ['bin/dion'],
    package_data={'dion': ['data/Makefile']},
    ext_modules = cythonize("dion/*.pyx", language_level=3))
