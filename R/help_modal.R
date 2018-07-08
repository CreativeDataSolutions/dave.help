
#create anchors
#' @export
create_links<-function(link_name,section_name=c('methods','results','plots','save','report')){
  paste0(link_name,section_name) %>%
    sapply(.,function(x){inner_link(x)$anchor}) %>%
    setNames(.,section_name) %>%
    as.list()
}


#' @export
#' @param module get link to show based on app navbar and tab logic
help_section<-function(module){
  
  
  x<-module %>% .[!names(.) %in% 'main']
  
  sub_module<-case_when(
    x == 'Calculate' ~ "methods",
    x == 'Plot' ~ "plots",
    x == 'Explore' ~ "plots",
    x == 'Report' ~ "report"
  )
  
  section<-paste(names(x),sub_module,sep=".")
  
  #show modal and navigate
  #to appropriete section
  #not generating local html because
  #has to be a fragment not to break shiny ...
  help_iframe(section)
  
}

#create iframe
#' @export
help_iframe<-function(section,url='https://creativedatasolutions.github.io/dave.help/',style="width: 100% !important; height: 575px !important;"){
  
  .url<-paste0(url,'#',section)
  paste0('<iframe src=',.url,' frameBorder="0" scrolling="yes" style="', style,'"></iframe>') %>% HTML()
}

#create iframe
#' @export
modalModuleUI <- function(id) {
  ns <- NS(id)
  actionLink(ns('help_model_btn'),'',icon=icon('question-circle', "fa-2x"),style="color:#3399ff; width=20px;")
}


#create iframe
#' @export
#' @param content needs to be a reactive else modal won't update
modalModule <- function(input, output, session,content=function(){HTML('foo')}) {

  output$content_ui<-renderUI({
    content()
  })
  
  
  
  myModal <- function() {
    ns <- session$ns
    
    #TODO add class to specifi modal
    
    
   modalDialog(
        fluidRow(
          column(12,
                 uiOutput(ns('content_ui'))
          )
        ),
        footer = tagList(
          modalButton("Close",icon = icon('close'))
        ),
        size = "l",
        easyClose = TRUE,
        style='width: 100%;'
   )
  }


  # open modal on button click
  observeEvent(input$help_model_btn,{
               showModal(myModal())
  })

}

test<-function(){
  # Main app UI
  ui <- fluidPage(
    column(12,modalModuleUI(id="balls")),
    column(12,modalModuleUI(id="foo"))
  )
  
  
  
  # Main app server
  server <- function(input, output, session) {
    callModule(modalModule,id='balls',content=help_iframe(section='preprocess'))
    callModule(modalModule,session=session,id='foo')
  
  }
  
  shinyApp(ui, server)
}