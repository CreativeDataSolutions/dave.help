
#' @title get_help_html
#' @params fun string passed to help for an object from a loaded library
#' @import dplyr shiny utils tools
#' @details get R function help as HTML
#' @export
get_help_html<-function(fun, lib=NULL,filter=TRUE){
  
  #ugly but works
  # capture.output(tools:::Rd2HTML(utils:::.getHelpFile(help(fun))))
  
  #pretty but unnecessary
  capture.output( # cant pipe to this
    help((fun),(lib)) %>%
      utils:::.getHelpFile(.) %>%
      tools:::Rd2HTML(.)
  ) %>% {
    if( filter){
      breaks<-1:(grep('<h3>Usage</h3>',.)-1)
      breaks<-c(breaks, grep('<h3>Note</h3>',.):(grep('<h3>See Also</h3>',.)-1))
      .[breaks] %>%
        paste0(.,collapse='\n') %>%
        paste0(.,'</body></html>',collapse = '\n')
    } else {
      paste0(.,collapse='')
    }
  } %>%
    shiny::HTML()
  
}


#filter html to retain specific tags

test<-function(){
  
  fun<-'randomForest'
  lib<-'randomForest'
  
  get_help_html(fun,lib)
  
  html<-  capture.output( # cant pipe to this
    help((fun),(lib)) %>%
      utils:::.getHelpFile(.) %>%
      tools:::Rd2HTML(.)
  )
  
  #hack to extract sections since no valid html anchosr for sections
  #keep title, description, note
  breaks<-1:(grep('<h3>Usage</h3>',html)-1)
  breaks<-c(breaks, grep('<h3>Note</h3>',html):(grep('<h3>See Also</h3>',html)-1))
  html[breaks] %>%
    paste0(.,collapse='\n') %>%
    paste0(.,'</body></html>',collapse = '\n')
  
}
