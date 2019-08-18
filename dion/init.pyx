# Module Imports
import pathlib
import pkg_resources
from shutil import copyfile

# Configure Logger
from logging import getLogger
logger = getLogger()


def run_init(object args):
    """ Initializes a directory to serve a Dion project"""
    logger.info("Called initialization operation")

    cdef object make_source, make_target

    make_source = pathlib.Path(pkg_resources.resource_filename('dion', 'data/Makefile'))
    make_target = pathlib.Path("Makefile")

    if make_target.exists() and not args.force:
        make_target = pathlib.Path("Makefile.example")

    logger.debug(f"Writing '{make_target}'")
    copyfile(make_source, make_target)

    
