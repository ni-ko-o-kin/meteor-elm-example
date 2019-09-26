git checkout production
git merge master --no-edit

meteor remove elm

sed -i '/elm-client\/elm-main\.js/d' .gitignore
cd elm-client
elm make --optimize src/Main.elm --output=elm-main.js
git add elm-main.js
git commit -m "[deploy] optimized elm" elm-main.js ../.gitignore ../.meteor/packages ../.meteor/versions
cd ..

git push heroku production:master
git checkout master
