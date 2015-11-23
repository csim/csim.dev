::rmdir /S /Q public

hugo

xcopy /crydif "CNAME" "public"

git add -A
git commit -m "Updates"
git push origin master
git subtree push --prefix=public http://github.com/csim/clintsimon.com.git gh-pages

:: Init subtree
:: git subtree add --prefix=public http://github.com/csim/clintsimon.com.git gh-pages --squash
:: git subtree pull --prefix=public http://github.com/csim/clintsimon.com.git gh-pages