
all: escript docs

escript:
	mix escript.build

docs: docs-build docs-sync 

docs-build:
	mix docs

docs-sync:
	rsync -aqdu doc/* /var/www/html/dion/



