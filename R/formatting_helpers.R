
#' @title signif_format_fun
#' @export
#' @details pretty format table values
signif_format_fun<-function(x,digits=2){
  as.numeric(x) %>%
    formatC(., digits=digits,format="e", flag="#")
}
