rmdir /S /Q public

git submodule add http://github.com/csim/clintsimon.com.git public

cd public

git checkout gh-pages
git add -A
git commit -m "Setup publishing"
git push

cd ..

.\publish.cmd

::hugo

::xcopy /crydif "CNAME" "public"

::git subtree add --prefix public origin gh-pages --squash
::git add -A
::git commit -qam "Updates"
::git push origin master

::git subtree pull --prefix public origin gh-pages
::git subtree push --prefix public origin gh-pages



:: Init subtree
:: git subtree add --prefix public origin gh-pages --squash
:: git subtree pull --prefix public origin gh-pages