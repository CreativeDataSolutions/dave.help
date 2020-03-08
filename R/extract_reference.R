
#extract reference from function

#' @title get_help_html
#' @params fun string passed to help for an object from a loaded library
#' @import dplyr shiny utils tools
#' @details get R function help as HTML
#' @export
get_help_reference<-function(fun, lib=NULL,filter=TRUE){
  
  #ugly but works
  # capture.output(tools:::Rd2HTML(utils:::.getHelpFile(help(fun))))
  
  #pretty but unnecessary
  x<-capture.output( 
    help((fun),(lib)) %>%
      utils:::.getHelpFile(.) %>%
      tools:::Rd2HTML(.))
  
      breaks<-(grep('<h3>References</h3>',x)+2)
      breaks<-c(breaks:(grep('<h3>See Also</h3>',x)-1))
     
      out<-x[breaks]
      #convert to bibtext reference
      
      
      
      paste0('@Article{,
        title = {',title,'},
        author = {',author,'},
        journal = {R News},
        year = {',year,'},
        volume = {2},
        number = {3},
        pages = {18-22},
        url = {https://CRAN.R-project.org/doc/Rnews/},
      }')
}


test<-function(){
  
  fun<-'kruskal.test'
  lib<-'stats'
  
  
  
}