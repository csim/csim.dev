::rmdir /S /Q public

hugo

xcopy /crydif "CNAME" "public"

git add -A
git commit -m "Updates"
git push origin master

::git subtree pull --prefix public origin gh-pages
git subtree push --prefix public origin gh-pages --squash



:: Init subtree
:: git subtree add --prefix public origin gh-pages --squash
:: git subtree pull --prefix public origin gh-pages