#!/usr/bin/env bash

export DEPLOY_HOSTNAME=eu-west-1.galaxy-deploy.meteor.com 
DEPLOY_TO=mywebsite.com

START_PWD=$(pwd)
ELM_DIR="elm-client"
OUTPUT="elm-main.js"

# cleanup
function cleanup {
    echo "cleanup"
    cd "$START_PWD" || exit
    rm -vf private/settings.json
    rm -vf "$ELM_DIR/$OUTPUT"
    meteor add elm
}
trap cleanup EXIT

git checkout production

ELM_FILE_NAMES=(
    Main
)

ELM_FILES=()
for file in "${ELM_FILE_NAMES[@]}"; do
    ELM_FILES+=("src/${file}.elm")
done

# optimze elm output
cd "$ELM_DIR" || exit
elm make --optimize "${ELM_FILES[@]}" --output="$OUTPUT"
cd "$START_PWD" || exit

# deploy
meteor remove elm
gpg --output private/settings.json --decrypt private/settings.json.gpg
meteor deploy "$DEPLOY_TO" --settings private/settings.json
git checkout master
