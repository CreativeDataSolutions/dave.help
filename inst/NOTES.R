# notes
eval `ssh-agent`
ssh-add C:/Users/dgrapov/Dropbox/.ssh/git_key # github


cp inst/manual.html index.html
git add index.html
git commit -a -m 'update'
git push github gh-pages


#install all deps
deps<-c('dplyr',
    'shiny',
    'bsplus',
    'knitr',
    'shinythemes')

lapply(deps, function(x) {
  if(!require(x,character.only = TRUE)) install.packages(x)
})

system.file(package='shinythemes','shinythemes/css/darkly.min.css')
