rmdir /S /Q public

git checkout master
git add -A
git commit "Reset publishing suubtree"
git push

git subtree add --prefix public origin gh-pages --squash

.\publish.cmd

::hugo

::xcopy /crydif "CNAME" "public"

::git add -A
::git commit -qam "Updates"
::git push origin master

::git subtree pull --prefix public origin gh-pages
::git subtree push --prefix public origin gh-pages



:: Init subtree
:: git subtree add --prefix public origin gh-pages --squash
:: git subtree pull --prefix public origin gh-pages