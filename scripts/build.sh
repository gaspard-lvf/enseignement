#!/usr/bin/env bash

set -e

FILE="$1"

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
        -interaction=nonstopmode \
        -auxdir=build \
        -jobname="$BASE-eleve" \
        "$BASE.tex"

    #mv "build/$BASE-eleve.pdf" ./

    echo "Compilation professeur"

    echo '\def\version{prof}' > version.tex

    latexmk -pdf \
        -interaction=nonstopmode \
        -auxdir=build \
        -jobname="$BASE" \
        "$BASE.tex"

    #cp "build/$BASE.pdf" ./
    rm version.tex

   
    
else
 echo "Compilation simple"

    latexmk -pdf \
        -interaction=nonstopmode \
        -auxdir=build \
        "$BASE.tex"

    #cp "build/$BASE.pdf" ./
   

fi