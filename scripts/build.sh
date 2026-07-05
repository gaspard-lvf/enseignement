#!/usr/bin/env bash

set -e

FILE="$1"

if [ -z "$FILE" ]; then
    echo "Usage : build.sh fichier.tex"
    exit 1
fi

DIR=$(dirname "$FILE")
BASE=$(basename "$FILE" .tex)

cd "$DIR"

MODE=$(grep -oP '\\newcommand\{\\buildmode\}\{\K[^}]+' "$BASE.tex")

if [ "$MODE" = "simple" ]; then
    echo "Compilation simple"

    latexmk -pdf \
        -interaction=nonstopmode \
        "$BASE.tex"

else

    echo "Compilation élève"

    echo '\def\version{eleve}' > version.tex

    latexmk -pdf \
        -interaction=nonstopmode \
        -jobname="$BASE-eleve" \
        "$BASE.tex"

    echo "Compilation professeur"

    echo '\def\version{prof}' > version.tex

    latexmk -pdf \
        -interaction=nonstopmode \
        -jobname="$BASE-prof" \
        "$BASE.tex"

    rm version.tex

fi