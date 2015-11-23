mkdir public
git subtree add --prefix=public http://github.com/csim/clintsimon.com.git gh-pages --squash
git subtree pull --prefix=public http://github.com/csim/clintsimon.com.git gh-pages