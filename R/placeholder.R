

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