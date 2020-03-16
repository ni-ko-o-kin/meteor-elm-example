cd elm-client || exit

elm make --debug src/Main.elm --output=../packages/elm/elm-main.js

while inotifywait -e close_write -r src
do
    clear
    sleep 0.2
    echo "\n"
    elm make --debug src/Main.elm --output=../packages/elm/elm-main.js
    echo "\n"
done
