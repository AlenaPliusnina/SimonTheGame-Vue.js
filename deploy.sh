
#!/usr/bin/env sh

set -e

npm run build

cd dist

git init
git add -A
git commit -m 'deploy'

git push -f git@github.com:alenapliusnina/SimonTheGame-Vue.js.git master:gh-pages

cd -
