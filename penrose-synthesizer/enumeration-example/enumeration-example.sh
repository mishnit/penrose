#!/bin/bash 
NAME='enum-'$1
EXAMPLE='../../examples'
AUTOMATOR='../../automator'
ARTIFACT='../../penrose-artifacts'

# Clean up output dir
rm -rf synthesized-progs

# Synthesize n Substance programs
penrose-synthesizer $EXAMPLE/set-theory-domain/setTheory.dsl --substance=threesets.sub --spec=enum-spec.dsl --num-programs=$1 --synth-setting=enum-settings.json

# Generate registries for Substance, Style, and Domain programs
python3 ../generateRegistry.py synthesized-progs $1 ./venn-synth.sty venn $EXAMPLE/set-theory-domain/setTheory.dsl set-theory

# Move the registries + synthesized programs to the automator dir for rendering
rsync -a -v --delete-after synthesized-progs/ $AUTOMATOR/synthesized-progs

# Move to automator
cd $AUTOMATOR

# CLean up output dir
rm -rf $ARTIFACT/artifacts/$NAME
rm -rf $ARTIFACT/browser/*
mkdir -p $ARTIFACT/artifacts/$NAME

# Render all diagrams
npm start -- batch substance.json style.json domain.json $ARTIFACT/artifacts/$NAME --folders --src-prefix="synthesized-progs"

# Go to artifact site generator
cd $ARTIFACT

# Generate a static artifact page
npm start -- ./artifacts/$NAME ./browser

# Open the page
open browser/index.html

