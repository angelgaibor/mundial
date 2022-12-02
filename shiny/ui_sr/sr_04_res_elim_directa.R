#
# Resultados octavos #####
output$res_octavos <- renderTable(
  res_elim_directa %>% 
    filter(fase == "o") %>% 
    replace(is.na(.), 0) %>% 
    mutate(Fecha = as.character(Fecha),
           Fecha = gsub("2022-", "", Fecha),
           Fecha = gsub("-", "\\/", Fecha),
           Hora = gsub(" hrs", "", Hora),
           `GL (P)` = ifelse(p1 != 0, paste0(g1, " (", p1, ")"), g1),
           `GV (P)` = ifelse(p2 != 0, paste0(g2, " (", p2, ")"), g2),
           `vs.` = " - ",
           Resultado = paste0(`GL (P)`, `vs.`, `GV (P)`)) %>% 
    select(Fecha, Hora, Local = equipo1, Resultado, Visita = equipo2),
  align = "c"
)
#
# Resultados cuartos #####
output$res_cuartos <- renderTable(
  res_elim_directa %>% 
    filter(fase == "c") %>% 
    replace(is.na(.), 0) %>% 
    mutate(Fecha = as.character(Fecha),
           Fecha = gsub("2022-", "", Fecha),
           Fecha = gsub("-", "\\/", Fecha),
           Hora = gsub(" hrs", "", Hora),
           `GL (P)` = ifelse(p1 != 0, paste0(g1, " (", p1, ")"), g1),
           `GV (P)` = ifelse(p2 != 0, paste0(g2, " (", p2, ")"), g2),
           `vs.` = " - ",
           Resultado = paste0(`GL (P)`, `vs.`, `GV (P)`)) %>% 
    select(Fecha, Hora, Local = equipo1, Resultado, Visita = equipo2),
  align = "c"
)
#
# Resultados semis #####
output$res_semis <- renderTable(
  res_elim_directa %>% 
    filter(fase == "s") %>% 
    replace(is.na(.), 0) %>% 
    mutate(Fecha = as.character(Fecha),
           Fecha = gsub("2022-", "", Fecha),
           Fecha = gsub("-", "\\/", Fecha),
           Hora = gsub(" hrs", "", Hora),
           `GL (P)` = ifelse(p1 != 0, paste0(g1, " (", p1, ")"), g1),
           `GV (P)` = ifelse(p2 != 0, paste0(g2, " (", p2, ")"), g2),
           `vs.` = " - ",
           Resultado = paste0(`GL (P)`, `vs.`, `GV (P)`)) %>% 
    select(Fecha, Hora, Local = equipo1, Resultado, Visita = equipo2),
  align = "c"
)
#
# Resultados final #####
output$res_tercero <- renderTable(
  res_elim_directa %>% 
    filter(fase == "t") %>% 
    replace(is.na(.), 0) %>% 
    mutate(Fecha = as.character(Fecha),
           Fecha = gsub("2022-", "", Fecha),
           Fecha = gsub("-", "\\/", Fecha),
           Hora = gsub(" hrs", "", Hora),
           `GL (P)` = ifelse(p1 != 0, paste0(g1, " (", p1, ")"), g1),
           `GV (P)` = ifelse(p2 != 0, paste0(g2, " (", p2, ")"), g2),
           `vs.` = " - ",
           Resultado = paste0(`GL (P)`, `vs.`, `GV (P)`)) %>% 
    select(Fecha, Hora, Local = equipo1, Resultado, Visita = equipo2),
  align = "c"
)

output$res_campeon <- renderTable(
  res_elim_directa %>% 
    filter(fase == "f") %>% 
    replace(is.na(.), 0) %>% 
    mutate(Fecha = as.character(Fecha),
           Fecha = gsub("2022-", "", Fecha),
           Fecha = gsub("-", "\\/", Fecha),
           Hora = gsub(" hrs", "", Hora),
           `GL (P)` = ifelse(p1 != 0, paste0(g1, " (", p1, ")"), g1),
           `GV (P)` = ifelse(p2 != 0, paste0(g2, " (", p2, ")"), g2),
           `vs.` = " - ",
           Resultado = paste0(`GL (P)`, `vs.`, `GV (P)`)) %>% 
    select(Fecha, Hora, Local = equipo1, Resultado, Visita = equipo2),
  align = "c"
)