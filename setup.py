from distutils.core import setup
import pathlib
import re

# Configure Package Names
packages = [
    "dion",
]
package_dirs = {}

for package in packages:
    package_dirs[package] = re.sub("\.", "/", package)

# Configure Scripts
scripts_dir = pathlib.Path("scripts")
scripts =[]

for i in scripts_dir.glob("*"):
    scripts.append(str(i))


# Initialize Library
setup(
    name="dion",
    version="2020.1",
    packages=packages,
    package_dir=package_dirs,
    scripts=scripts,
    package_data={'dion':['data/*.xsl', 'data/*/*.xsl', 'data/dion.sty', 'data/*/*.sty']} 
)
