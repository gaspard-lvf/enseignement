.PHONY: fiche all clean

fiche:
	@test -n "$(FILE)" || (echo "Usage : make fiche FILE=fiche.tex" && exit 1)
	./scripts/build.sh "$(FILE)"

all:
	@for f in *.tex ; do \
		$(MAKE) fiche FILE="$$f"; \
	done

clean:
	latexmk -C
	rm -f version.tex