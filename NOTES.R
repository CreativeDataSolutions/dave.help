#NOTES

# update manual on github
git checkout -b gh-pages

#remove all and create index.html
git checkout gh-pages
cp inst/manual.html index.html
find . -type f -not -name 'index.html' -not -name '.git' -delete # this deletes the git repo


#.gitignore

#build help pages for each package here
#make UI for unified help pages
#use bookdown for pages?

#help pages
-[ ] dave.main
-[ ] dave.preproc
-[ ] dave.stats
-[ ] dave.cluster
-[ ] dave.multivariate
-[ ] dave.pathway
-[ ] dave.rf
-[ ] dave.network