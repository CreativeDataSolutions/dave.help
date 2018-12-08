
#used in dave module summary and report formatting

#' @title module title
#' @export
#' @importFrom shiny HTML
module_title<-function(text,separator="<hr>",tag=c('b','h2','center')){
  paste(separator,
        make_tag(text,tag),
        separator,collapse = '\n')
}

#' @title make_tag
#' @export
make_tag<-function(obj,tag=c('center','h3')){
 #S3nkR
  for(i in 1:length(tag)){
    start<-paste0('<',tag[i],'>')
    end<-paste0('</',tag[i],'>')
    if(i==1) {
      out<-paste0(start,obj,end)
    } else {
      out<-paste0(start,out,end)
    }
  }
  out

}

#' @title report_calculate_format
#' @param obj string
#' @details loop over tags and encapsulate the obj
#' @export
html_text_format<-function(obj,tags=c('h4')){

  out<-obj
  for (i in tags){
    out<-do.call(i,list(out))
  }

  as.character(out)

}


#' @export
html_paragraph_format<-function(obj,tags='h4',collapse='\n',...){

  obj %>%
    lapply(.,function(x){
      html_text_format(x,tags=tags)
    }) %>%
    unlist() %>%
    paste(.,collapse=collapse)
}


#create collapsible html output
#' @export
#' @import bsplus
collapsible_html<-function(content,title,icon="user-circle-o",id='foo'){
  bsplus::bs_accordion(id = id) %>%
    bs_append(title = tags$label(class='bsCollapsePanel',HTML(paste0('<i class="fa fa-',icon,'"></i>')), title),
              content = content)
}

#' @export
#' @import shiny includeHTML
report_collapse<-function(path,title='Report',icon="file",id=basename(tempfile())){

  htmltools::tagList(rmarkdown::html_dependency_font_awesome()) # needs to be external?
  content<-shiny::includeHTML(path)
  collapsible_html(content=content,title=title,icon=icon,id=id)
}

#' @title
#' @export
#' @details used for hacked formating text colors in DT and formattable
highlight_text <- function(z,highlight='#3399ff',text='best',default='#ffffff00'){

  show<-grepl(text,z)
  if(show) {
    color<-highlight
    out<-gsub(text,'',z)
  } else {
    color<-default
    out<-z
  }

  list(color=color,text=out)

}

#create hyperlink inside doc helper
#' @inner_link
#' @export
#' @details create links inside document
inner_link<-function(name='bar',text=NULL){
  anchor<-shiny::tags$a(id=name) %>% as.character() %>% HTML()
  ref<-shiny::tags$a(href=paste0('#',name),text) %>% as.character() %>% HTML()
  list(anchor=anchor,ref=ref)
}

#' #' @export
#' #' @details create modal from a help button
#' help_modal <- function(modal_title, link, help_file) {
#'   sprintf("<div class='modal fade' id='%s' tabindex='-1' role='dialog' aria-labelledby='%s_label' aria-hidden='true'>
#'             <div class='modal-dialog'>
#'               <div class='modal-content'>
#'                 <div class='modal-header'>
#'                   <button type='button' class='close' data-dismiss='modal' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
#'                   <h4 class='modal-title' id='%s_label'>%s</h4>
#'                   </div>
#'                 <div class='modal-body'>%s<br>
#'                   &copy; CDS- Creative Data Solutions (2018) <a rel='license' href='www.createdatasol.com' target='_blank'></a>
#'                 </div>
#'               </div>
#'             </div>
#'            </div>
#'            <i title='Help' class='fa fa-question-circle fa-2x alignright' data-toggle='modal' data-target='#%s'></i>
#'           <div style='clear: both;'></div>",
#'           link, link, link, modal_title, help_file, link) %>%
#'     enc2utf8 %>% HTML
#' }

#' #' @export
#' get_help<-function(section,help=system.file('manual.html',package = 'dave.help')){
#'   help<-readLines(help) %>%
#'     paste(.,collapse = '\n')
#' 
#'   #hack for shiny using navigate to href fun in file
#'   gsub('<body>',paste0('<body onload="scrollTo(\'',section,'\')">'),help)
#' 
#' }

#create alert box
make_alert<-function(message='Hello world',color='#377eb8',remove=TRUE){
  paste0('<div>
    <style>
    .alert {
        padding: 20px;
        background-color: ', color,';
        color: white;
    }

    .closebtn {
        margin-left: 15px;
        color: white;
        font-weight: bold;
        float: right;
        font-size: 22px;
        line-height: 20px;
        cursor: pointer;
        transition: 0.3s;
    }

    .closebtn:hover {
        color: black;
    }
    </style>

    <div class="alert">',
      {
        if(remove){
          '<span class="closebtn" onclick="this.parentElement.style.display=\'none\';">&times;</span>'
        } 
      },
    message,
    '</div>
  </div>') %>% HTML()

}

test<-function(){

  library(dplyr)
  library(dave.help)
  library(bsplus)
  library(shiny)
  path<-'C:\\Users\\dgrapov\\Dropbox\\Software\\dave\\dave\\radiant\\inst\\app\\user\\user2\\report\\partial\\kruskal_report.html'
  #content<-includeHTML(path)
  content<-readLines(path) %>%
    paste(.,collapse = '\n')

  html<-collapsible_html(content=content,title='Report',icon="user-circle-o",id='foo') %>%
    as.character()
  cat(html,file='inst/test/test.html')

  #open help and navigate to the specified anchor
  get_help<-function(section,help=system.file('manual.html',package = 'dave.help')){
    help<-readLines(help) %>%
      paste(.,collapse = '\n')

    #hack for shiny using navigate to href fun in file
    gsub('<body>',paste0('<body onload="scrollTo(\'',section,'\')">'),help)

  }

  help<-'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/manual.html'
  section<-'dave.network.keggmap.methods'
  x<-get_help(section,help)
  cat(x,file='test/scroll.html')

  #get help file
  x<-help_modal(modal_title='foo', link='bar', help_file=get_help(section,help))
  x
}
