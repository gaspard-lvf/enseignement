.PHONY: fiche all clean

ifdef WORKSPACE_FOLDER
ROOT := $(WORKSPACE_FOLDER)
else
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
endif

rapide:
	@test -n "$(FILE)" || (echo "Usage : make rapide FILE=fiche.tex" && exit 1)
	"$(ROOT)/scripts/build.sh" rapide "$(FILE)"

propre:
	@test -n "$(FILE)" || (echo "Usage : make propre FILE=fiche.tex" && exit 1)
	"$(ROOT)/scripts/build.sh" propre "$(FILE)"

all:
	@find . -name "*.tex" | while read f ; do \
		$(MAKE) propre FILE="$$f" ; \
	done

clean:
	latexmk -C
	rm -f version.tex