

decorate<-function(txt,obj='span',color='#3399ff'){
  
  paste0('<',obj,' class="txbox_green" style="background-color: ',color,' !important;">',txt,'</',obj,'>')
  
}

#' @export
dcr_g<-function(txt){
  decorate(txt,color='#3dbc8b')
}

#' @export
dcr<-function(txt){
  decorate(txt)
}

#' @export
dcr_b<-function(txt){
  decorate(txt,color='#2a4e8a;')
}
