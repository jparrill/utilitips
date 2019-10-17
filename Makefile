.PHONY: build release serve 

serve:
	mdbook serve

build:
	mdbook build

release: build
	VERSION="$(find -type f -exec md5sum {} \; | md5sum | cut -f1 -d\ )"
	git add -A
	git commit -a -m "New Book version published: ${VERSION}"
	git push origin master
	git push gitlab master
