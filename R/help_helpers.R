
#' @title two_col_layout
#' @export
two_col_layout<-function(fig,text,fig_right=TRUE,
                         heading=4,
                         wrap=60,
                         text_cap=list(paste0('<h',heading, ' style="align: right;">'),paste0('</h',heading,'>')),
                         fig_cap=list('<img class="zoom_plot" src="','">'),spacer='  ',self=TRUE){

  if(is.null(fig)){
    #assume both aren't NULL
    text<-paste0('<p style="word-wrap: break-word;">',text,"</p>")
    text<-paste0(text_cap[[1]],text,text_cap[[2]])
    return(text)
  } else {
    if(self){
      fig<-markdown:::.b64EncodeFile(fig)
    }
    fig<-paste0(fig_cap[[1]],fig,fig_cap[[2]])
  }


  if(!is.null(text)){
    text<-paste0('<p style="word-wrap: break-word;">',text,"</p>")
    text<-paste0(text_cap[[1]],text,text_cap[[2]])

    #figure placement
    left<-ifelse(fig_right,text,fig)
    right<-ifelse(fig_right,fig,text)

    #text align

    paste0('<table width="100%">
    <col width="50%">
    <col width="50%">
    <tr>
    <td>',
    left,
    '</td>
    <td>',
    right,
    '</td>
    </tr></table>')
  } else {
    #center fig
    make_tag(fig,'center')
  }

}

#allow default to full page if text=NULL
#add logic to handle only images or text



#' @title two_col_layout.list
#' @export
two_col_layout.list<-function(obj){

  lapply(obj, function(x){
    do.call('two_col_layout',x)
  }) %>%
    unlist() %>%
    paste0(.,collapse='<br>')

}

#'
#' #need to not allow section to float?
#' #' @title two_col_layout_float
#' #' @export
#' two_col_layout_float<-function(fig,text,fig_right=TRUE,
#'                                heading=4,
#'                                text_cap=list(paste0('<h',heading, ' style="align: right;">'),paste0('</h',heading,'>')),
#'                                fig_cap=list('<img src="','">'),spacer='  ',self=TRUE){
#'
#'   #add tags +
#'   if(self){
#'     fig<-markdown:::.b64EncodeFile(fig)
#'   }
#'   fig<-paste0(fig_cap[[1]],fig,fig_cap[[2]])
#'
#'   text<-paste0('<p style="word-wrap: break-word;">',text,"</p>")
#'   text<-paste0(text_cap[[1]],text,text_cap[[2]])
#'
#'   #figure placement
#'   left<-ifelse(fig_right,text,fig)
#'   right<-ifelse(fig_right,fig,text)
#'
#'   #text align
#'
#'   paste0('<div class="right_panel">',
#'         right,
#'         '</div>
#'          <div class="left_panel">',
#'         left,
#'          '</div>')
#'
#' }

#' @title wrap_text
#' @export
wrap_txt<-function(txt,length=40){
  strwrap(txt,length) %>% paste0(.,collapse = '<br>')
}

#' @title parse_modules
#' @export
parse_modules<-function(mods){
  mods<-unlist(strsplit(mods,', '))
  list(modules=mods,length=length(mods))
}

#' @title grammatical_paste
#' @export
#' @details same as glue::collapse
grammatical_paste<-function(obj,collapse=", "){
  len<-length(obj)
  if(len==1) obj else paste0(paste(obj[-len],collapse=collapse)," and ",obj[len],collapse="")
}

#' title place_fig
#' @param fig
#' @param self encode image self-contained
#' @import markdown
#' @export 
place_fig<-function(fig,self=TRUE){
  if(self) {
    paste0('<center><img src="',markdown:::.b64EncodeFile(fig),'"></center>')
  } else {
    paste0('<center><img src="',fig,'"></center>')
  }

}


#' #' @export
#' format_help_section<-function(section,tags='h4',collapse='\n',...){
#'
#'   section %>%
#'     lapply(.,function(x){
#'       paste0(x$section,'\n<br>\n',
#'              two_col_layout.list(x$content),
#'              collapse = '\n<br>\n')
#'     }) %>%
#'     unlist() %>%
#'     paste(.,collapse=collapse)
#' }

#no loop version
#' @export
make_help_section<-function(help_section,...){

      paste0(help_section$section,'\n<br>\n',
             do.call('two_col_layout.list',list(help_section$content)),
             collapse = '\n<br>\n')
}

#' @export
make_section<-function(section,...){

  #adding loop to control section formats
  lapply(section,function(x){
    if(is.null(x$asis) || !x$asis){ # assume help is default
      make_help_section(x,...)
    } else {
      #could add helpers here... for now allowing pass through
      x$content
    }
  }) %>%
    unlist() %>%
    paste(.,collapse='\n')



}

#' @title section_title
#' @export
#' @importFrom shiny tags
section_title<-function(title,tags='h3'){
  shiny::tags$code(title) %>%
    shiny::tags[[tags]](.) %>%
    as.character()
}

#' @export
submodule_title<-function(title,tags='h3'){
  title %>%
    shiny::tags[[tags]](.) %>%
    as.character() %>%
    paste0(.,'\n<hr>')
}

# render the help skeleton results
render_skeleton<-function(title=NULL,
                          nav=NULL,
                          mod_desc=NULL,
                          section=list(list(section='`Methods`',content='methods'),
                                       list(section='`Results`',content='results'),
                                       list(section='`Explore and Plot`',content='plots')),
                          collapse='\n<br>\n',section_tags='h3',self=TRUE){

  # unlike create_skeleton execute the code and get all results in one HTML DOC
  #can't (?) create inline and execute in one render
  .title<-if(!is.null(title)) module_title(title) else NULL
  .nav<-if(!is.null(nav)) {
    if(self){
      paste0('<img src="',markdown:::.b64EncodeFile(nav),'">')
    } else {
      paste0('<img src="',nav,'">')
    }

  } else {
    NULL
  }
  #allow pass through?.. eg for reports
  .section<-if(!is.null(section)) {
    make_section(section,tags=section_tags,collapse=collapse)
      # format_help_section(section,tags=section_tags,collapse=collapse)
    } else {
      NULL
    }

  paste(.title,
        .nav,
        mod_desc,
        .section,
        collapse = collapse)


}



test<-function(){

  fig<-'figs/dave.main/2.png'
  text<-'foo'

  two_col_layout(fig,text,TRUE,3) %>% cat()

  fig<-'figs/dave.main/2.png'
  text<-NULL

  two_col_layout(fig,text,TRUE,3) %>% cat()

  #mods
  mods<-'Data, Preprocess, Statistics, Clustering, Projection, Pathway, Machine-learning, Network, Report'
  parse_modules(mods)


  #create a method to actually render the
  #skeleton output includeing code execution
  args<-list(title='Title',
    nav='C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/figs/dave.stat/nav.png',
    mod_desc='foo',
    section=list(list(section='`Methods`',
                      content=list(list(text='Select from a variety of plot types.',
                                        fig= 'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/figs/dave.multivariate/menue_plot.png',
                                        fig_right=FALSE,4))),
                 list(section='`Results`',
                      content=list(list(text='Select from a variety of plot types.',
                                        fig= 'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/figs/dave.multivariate/menue_plot.png',
                                        fig_right=FALSE,4))),
                 list(section='`Explore and Plot`',
                      content=list(list(text='Select from a variety of plot types.',
                                        fig= 'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/figs/dave.multivariate/menue_plot.png',
                                        fig_right=FALSE,4)))),
    collapse='\n<br>\n',section_tags='h3')

  #environment vars
  env<-list(
    mod_description<-'foo',
    methods=list(list(text='Select from a variety of plot types.',
                     fig= 'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/figs/dave.multivariate/menue_plot.png',
                     fig_right=FALSE,4)),
    results=list(list(text='Select from a variety of plot types.',
                     fig= 'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/figs/dave.multivariate/menue_plot.png',
                     fig_right=FALSE,4)),
    plot=list(list(text='Select from a variety of plot types.',
                  fig= 'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/figs/dave.multivariate/menue_plot.png',
                  fig_right=FALSE,4))
  )

  text<-do.call('create_skeleton',args)


  #copy env and save to temp file... ugly hack
  env<-environment()
  env_file<-tempfile()
  save(env,file=env_file)

  render_section<-function(main){
    rmarkdown::render('C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/inst/template/help_section_template.Rmd',
                      params = list(main),
                      output_format = html_fragment(),
                      output_file = 'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/test.html')
  }

  #pass environment
  #PROBLEM: can't create inline content and then evaluate? in the same render
  env<-environment()
  env_file<-tempfile()
  save(env,file=env_file)

  #workdir for relative scoping
  wd<-'C:/Users/dgrapov/Dropbox/Software/dave/dave/dave.help/'

  render_section(main=list(env=env_file,text=text))

  #to mimmic global like scoping
  bar<-'foo'
  params<-list2env(list(bar=bar)) # copies and unlinks from current env
  #params$bar<-bar
  do.call('print',list(params$bar),envir = params)




  #chunks
  #----------------
  # ```{r two-column, results='asis', echo=FALSE, out.extra=''}
  # source('../R/help_helpers.R')
  # fig<-'figs/dave.main/2.png'
  # text<-'foo hfhdrtfgh rthfhrty rtyrtyrtt rtyrtyrty r'
  #
  # cat(two_col_layout(fig,text,fig_right=FALSE))
  #
  #
  # ```

}
