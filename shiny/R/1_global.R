library(googlesheets4)
gs4_deauth()
qatar22 <- "https://docs.google.com/spreadsheets/d/13qZaElTnoTFK1f40lKW9geqS6dsbqkJOzMAbIoLs8IU/"
equipos <- read_sheet(qatar22)

gs4_deauth()
resultados <- "https://docs.google.com/spreadsheets/d/10bKKPH_tYS6OBK4ucWGHznx5RlkXCc7jVA0FBo4-vCc/"
predicciones <- read_sheet(resultados)

gs4_deauth()
li_ligas <- "https://docs.google.com/spreadsheets/d/1G9vbPS4sYwRbAcs-325NpIFgr9VTnffCwZYlEyucWig/"
lista_ligas <- read_sheet(li_ligas)

  