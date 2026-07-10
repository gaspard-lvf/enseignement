.PHONY: fiche all clean

ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

fiche:
	@test -n "$(FILE)" || (echo "Usage : make fiche FILE=fiche.tex" && exit 1)
	"$(ROOT)/scripts/build.sh" "$(FILE)"

all:
	@find . -name "*.tex" | while read f ; do \
		$(MAKE) fiche FILE="$$f" ; \
	done

clean:
	latexmk -C
	rm -f version.tex