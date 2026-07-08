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

MODE=$(awk '
/\\newcommand{\\buildmode}/ {
    match($0, /\{(simple|double)\}/)
    print substr($0, RSTART+1, RLENGTH-2)
}' "$BASE.tex")


if [ "$MODE" = "simple" ]; then
    echo "Compilation simple"

    latexmk -pdf \
        -interaction=nonstopmode \
        "$BASE.tex"

else

    echo "Compilation élève"

    rm -f version.tex   
    echo '\def\version{eleve}' > version.tex

    latexmk -pdf \
        -interaction=nonstopmode \
        -outdir=build \
        -jobname="$BASE-eleve" \
        "$BASE.tex"

    mv "build/$BASE-eleve.pdf" ./

    echo "Compilation professeur"

    echo '\def\version{prof}' > version.tex

    latexmk -pdf \
        -interaction=nonstopmode \
        -outdir=build \
        -jobname="$BASE-prof" \
        "$BASE.tex"

    mv "build/$BASE-prof.pdf" ./
    rm version.tex

fi