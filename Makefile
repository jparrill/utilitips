VERSION ?= $(shell bash -c 'find -type f -exec md5sum {} \; | md5sum | cut -f1 -d\ ')

default: release

serve:
	zola serve

build:
	zola build

release:
	echo ${VERSION}
	git add -A
	git commit -a -m "New Book version published: ${VERSION}"
	git push origin master
	git push gitlab master

.PHONY: build release serve 
