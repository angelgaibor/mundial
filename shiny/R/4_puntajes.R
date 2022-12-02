#
library(tidyverse)
#
# Cálculo de los puntajes
#
po1 <- posiciones %>% 
  filter(Pos %in% c(1,2)) %>% 
  select(Equipo, Pos)

pr1 <- predicciones %>% 
  filter(Siglas != "SN") %>%
  mutate(Jugador = gsub("\\. ", "", Jugador),
         Jugador = gsub("\\.", "", Jugador),
         Jugador = gsub("\\.", "", Jugador)) %>%
  group_by(Codigo) %>% 
  mutate(nn = max(row_number())) %>% 
  # si repitieron el equipo en la prediccion -> se elimina el duplicado
  group_by(Codigo, Grupo) %>% 
  mutate(control_equipo = n_distinct(Equipo),
         control_equipo_nn = row_number()) %>% 
  filter(!(control_equipo==1 & control_equipo_nn==2)) %>% 
  select(-control_equipo, control_equipo_nn)

pr2 <- pr1 %>% 
  group_by(Codigo, nn) %>%
  summarise() %>% 
  ungroup()

pr3 <- pr1 %>%
  cbind(orden = rep(1:(n_distinct(predicciones$Codigo)-1), times = pr2$nn)) %>% 
  select(Liga, Jugador, Codigo, Grupo, Equipo, Prediccion, orden) %>% 
  # emparejamos las posiciones oficiales
  left_join(po1, by = "Equipo") %>% 
  mutate(cp1 = ifelse(!is.na(Pos), 1, 0),
         Pos = ifelse(is.na(Pos), 0, Pos),
         cp2 = ifelse(Prediccion == Pos, 1, 0)) %>% 
  group_by(Liga, Jugador, Codigo) %>% 
  summarise(Puntaje = sum(cp1) + sum(cp2),
            orden = mean(orden)) %>% 
  # mismo jugador en misma liga y diferente puntaje -> nos quedamos con la última predicción
  group_by(Liga, Jugador) %>% 
  mutate(control_puntaje = mean(Puntaje),
         control_puntaje = ifelse(control_puntaje%%1 == 0, 0, 1)) %>%
  ungroup() %>% 
  filter(control_puntaje == 0 | orden >= mean(orden)) %>% 
  # mismo jugador en misma liga y mismo puntaje -> nos quedamos con la última predicción
  group_by(Liga, Jugador) %>% 
  mutate(nrow = mean(row_number())) %>% 
  group_by(Liga, Jugador, nrow) %>% 
  mutate(queda = ifelse(nrow == 1, 1,
                        ifelse(orden > mean(orden), 1, 0))) %>% 
  ungroup() %>% 
  filter(queda == 1) %>% 
  # seleccionamos lo que nos importa
  select(Liga, Jugador, Codigo, Puntaje)

pr4 <- pr1 %>% 
  filter(Codigo %in% pr3$Codigo) %>% 
  # seleccionamos lo que nos importa
  select(Liga, Jugador, Codigo, Grupo, Siglas, Equipo, Prediccion) %>% 
  # recodificar las siglas
  mutate(Siglas = case_when(Siglas == "URY"  ~ "URU",
                            Siglas == "PRT"  ~ "POR",
                            Siglas == "NLD"  ~ "NED",
                            Siglas == "HRV"  ~ "CRO",
                            Siglas == "DNK"  ~ "DEN",
                            Siglas == "GBR"  ~ "ENG",
                            Siglas == "CHE"  ~ "SUI",
                            Siglas == "DEU"  ~ "GER",
                            T ~ Siglas))

rm(po1, pr1, pr2)  

#
# puntaje octavos de final
puntos_octavos <- pre_octavos_ini %>% 
  mutate(id = paste0(primeros, segundos)) %>% 
  left_join(res_elim_directa %>% 
              filter(fase == "o") %>% 
              mutate(id = paste0(equipo1, equipo2),
                     g1f = as.numeric(g1), 
                     g2f = as.numeric(g2), 
                     p1f = as.numeric(p1), 
                     p2f = as.numeric(p2)) %>% 
              select(id, g1f, g2f, p1f, p2f),
            by = "id") %>% 
  filter(!is.na(g1f)) %>% 
  filter(!is.na(g1)) %>% 
  replace(is.na(.), 0) %>% 
  mutate(g1 = as.numeric(g1),
         g2 = as.numeric(g2),
         p1 = as.numeric(p1),
         p2 = as.numeric(p2),
         pres = case_when(sign(g1+p1 - (g2+p2)) == sign(g1f+p1f - (g2f+p2f)) ~ 1,
                          T ~ 0),
         pdif = case_when(g1 - g2 == g1f - g2f ~ 1,
                          T ~ 0),
         pexa = case_when(g1 == g1f & g2 == g2f ~ 2,
                          T ~ 0),
         poct = pres + pdif + pexa,
         codigo = tolower(codigo)) %>% 
  group_by(id, codigo) %>% 
  summarise(poct = last(poct)) %>% 
  ungroup() %>% 
  group_by(Codigo = codigo) %>% 
  summarise(poct = sum(poct))

pr3 <- pr3 %>% 
  mutate(Codigo = tolower(Codigo)) %>% 
  left_join(puntos_octavos, by = "Codigo") %>% 
  rename(pgru = Puntaje) %>% 
  mutate(poct = ifelse(is.na(poct), 0, poct),
         Puntaje = pgru + poct)


