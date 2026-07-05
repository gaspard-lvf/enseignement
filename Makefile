.PHONY: fiche all clean

fiche:
	@echo $(VAR)
	@test -n "$(FILE)" || (echo "Usage : make fiche FILE=fiche.tex" && exit 1)
	$(WORKSPACE_FOLDER)/scripts/build.sh "$(FILE)"

all:
	@for f in *.tex ; do \
		$(MAKE) fiche FILE="$$f"; \
	done

clean:
	latexmk -C
	rm -f version.tex