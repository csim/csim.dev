::rmdir /S /Q public

hugo

xcopy /crydif "CNAME" "public"

cd public

git commit -am "Publish"
git push

cd ..
git commit -am "Content Updates"


::git subtree pull --prefix public origin gh-pages
::git subtree push --prefix public origin gh-pages --squash

:: Init subtree
:: git subtree add --prefix public origin gh-pages --squash
:: git subtree pull --prefix public origin gh-pages