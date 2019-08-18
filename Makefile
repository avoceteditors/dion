


install: compile
	python3 setup.py install --user

compile:
	python3 setup.py build_ext --inplace



