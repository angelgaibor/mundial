
# mensajes de error (debug)
# debug_msg <- function(...) {
#   is_local <- Sys.getenv('SHINY_PORT') == ""
#   in_shiny <- !is.null(shiny::getDefaultReactiveDomain())
#   txt <- toString(list(...))
#   if (is_local) message(txt)
#   if (in_shiny) shinyjs::runjs(sprintf("console.debug(\"%s\")", txt))
# }

# agregar prediccion
agrega_prediccion <- function(data, gs4 = TRUE) {
  
  if (gs4) {
    sheet_append(resultados, data, "predicciones")
    sum_data <- read_sheet(resultados, "predicciones")
  } else {
    old_data <- read.xlsx("data/resultados.xlsx", "predicciones")
    sum_data <- bind_rows(old_data, data)
    write.xlsx(sum_data, "data/resultados.xlsx", "predicciones")
  }
  
  sum_data
}