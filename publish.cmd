rmdir /S /Q public

hugo

xcopy /crydifs CNAME "public/CNAME"

git add -A
git commit -m "Updates"
git push origin master
git subtree push --prefix=public http://github.com/csim/csim.github.io.git gh-pages