#!/usr/bin/env bash

START_PWD=$(pwd)
ELM_DIR="elm-client"

cd "$ELM_DIR" || exit

FILE_NAMES=(
    Main
)

FILES=()
for file in "${FILE_NAMES[@]}"; do
    FILES+=("src/${file}.elm")
done

function elmMake {
    elm make --debug "${FILES[@]}" --output="$START_PWD/packages/elm/elm-main.js"
}

clear
elmMake

while inotifywait -e close_write "${FILES[@]}" elm.json
do
    clear
    sleep 0.2
    elmMake
done
