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

  
#
##### Angelito


#
##### Javi
gs4_deauth()
res_octavos <- "https://docs.google.com/spreadsheets/d/1U_H63SWVT6K1whlKql07nXXrXu0e5mi7R5SR4UP8-NA/"
res_octavos <- read_sheet(res_octavos)

gs4_deauth()
res_cuartos <- "https://docs.google.com/spreadsheets/d/1NmwY96SztmRMw_3pHnBhgya3gXg64yS7ux8zYYfF44U/"
res_cuartos <- read_sheet(res_cuartos)