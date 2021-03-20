all: install ctags

install:
	python3 setup.py install --user
ctags:
	ctags -R dion
