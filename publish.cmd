git commit -am "Content Updates"
git push


::hugo

::xcopy /crydif "CNAME" "public"

:: cd public
:: git checkout gh-pages
::git pull
:: git add -A
:: git commit -m "Publish"
:: git push --force

:: cd ..
:: git add -A
:: git commit -m "Content Updates"
:: git push

::git subtree pull --prefix public origin gh-pages
::git subtree push --prefix public origin gh-pages --squash

:: Init subtree
:: git subtree add --prefix public origin gh-pages --squash
:: git subtree pull --prefix public origin gh-pages