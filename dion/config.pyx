
# Module Imports
import pathlib
import json
import sys

# Logging Configuration
from logging import getLogger
logger = getLogger()


############################ Processes Configuration File #############################
def process_config(object config):
    defaults = {
        "author": {
            "name": "Unknown",
            "surname": "Unknown"
        },
        "publisher": {
        "name": "Nameless Printer",
        "cities": ["Boston", "New Orleans"]}
    }

    for i in ["author", "publisher"]:
        try:
            check = config['config'][i]
        except:
            config['config'][i] = defaults[i]

    return config



############################ Retrieves Configuration File #############################
def fetch_config(str str_path):
    cdef object path = pathlib.Path(str_path)
    logger.info("Loading configuration file")
    if path.exists():
        try:
            with open(path, 'rb') as f:
                return json.load(f)
                logger.debug("Configuration file found")
        except Exception as e:
            logger.warn(f"Unable to load configuration file: {e}")
            sys.exit(1)
    else:
        logger.warn("Configuration file does not exists")
        sys.exit(1)



