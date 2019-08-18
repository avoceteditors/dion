# Module Imports
import lxml.etree
import sys

# Local Imports
from .config import * 
from .read import * 

# Logger Configuration
from logging import getLogger
cdef object logger = getLogger()

############################# FETCH BUILD KEYS ##################################
def fetch_build_keys(str target, int build_all, object config):
    cdef list keys
    try:
        logger.info("Fetching Targets")
        keys = config["config"]["targets"]
        if not build_all:
            if target is not None:
                if target in keys:
                    keys = [target]
                else:
                    keys = [keys[0]]
            else:
                keys = [keys[0]]
        return keys
    except Exception as e:
        logger.warn(f"Error retrieving build targets: {e}")
 


################################ RUN BUILD #####################################
def run_build(object args):
    logger.info("Called build operation")

    # Init Variables
    cdef object config, src
    cdef str key

    config = process_config(fetch_config(args.config))

    # Compile Source Data
    try:
        src = fetch_source(config)
    except Exception as e:
        logger.warn(f"Unable to load source data: {e}")
        sys.exit(1)

    # Validate Uniqueness
    validate_idref_uniqueness(src)

    # Find Keys to Build Targets 
    cdef list keys = fetch_build_keys(args.target, args.all, config)

    # Iterate over keys
    for key in keys:

        # Fetch Configuration
        try:
            # Collect build configuration
            idref = config[key]["id"]
            build_type = config[key]['build']['type']
            build_target = config[key]['build']['target']
 
            # Perform additional doctree processing
            build_src = process_doctree(config, src, idref, build_type, build_target)

            # Transform
            # Write to file           
        except Exception as e:
            logger.warn(f"Unable to load configuration for key '{key}': {e}")


