#!/usr/bin/env bash

set -e

MODE_COMPILATION="$1"
FILE="$2"

if [ -z "$FILE" ]; then
    echo "Usage : build.sh fichier.tex"
    exit 1
fi
# File : chemin complet du fichier .tex depuis la racine du projet.
DIR=$(dirname "$FILE")          # Chemin du répertoire contenant le fichier .tex.
BASE=$(basename "$FILE" .tex)   # Nom du fichier .tex sans l'extension.

cd "$DIR"
pwd
ls

if [ ! -f "$BASE.tex" ]; then
    echo "Erreur : impossible de trouver '$BASE.tex'"
    exit 1
fi

case $MODE_COMPILATION in
    rapide)
        echo "Compilation rapide"
        #rm -rf build
        #mkdir build
        echo '\def\version{prof}' > version.tex
        pdflatex -synctex=1 \
            -output-directory=./build/ \
            "$BASE.tex"

        rm version.tex
        
        exit 0
        ;;
    propre)
            # On récupère le mode de compilation (simple ou double) depuis le fichier .tex.
        MODE=$(awk '
        /\\newcommand{\\buildmode}/ {
            match($0, /\{(simple|double)\}/)
            print substr($0, RSTART+1, RLENGTH-2)
        }' "$BASE.tex")

        if [ "$MODE" = "double" ]; then
        echo "Compilation élève"

            rm -f version.tex   
            echo '\def\version{eleve}' > version.tex

            latexmk -pdf \
                -synctex=1 \
                -interaction=nonstopmode \
                -outdir=build \
                -jobname="$BASE-eleve" \
                "$BASE.tex"

            echo "Compilation professeur"

            echo '\def\version{prof}' > version.tex

            latexmk -pdf \
                -synctex=1 \
                -interaction=nonstopmode \
                -outdir=build \
                -jobname="$BASE" \
                "$BASE.tex"

            rm version.tex

            cp "build/$BASE.pdf" "$BASE.pdf"
            
        else
        echo "Compilation simple"

            latexmk -pdf \
                -synctex=1 \
                -interaction=nonstopmode \
                -outdir=build \
                "$BASE.tex"

        cp "build/$BASE.pdf" "$BASE.pdf"
        fi
        ;;
    esac

