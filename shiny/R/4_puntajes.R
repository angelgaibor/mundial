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
  select(Liga, Jugador, Codigo, Grupo, Siglas, Equipo, Prediccion)

rm(po1, pr1, pr2)  

g1 <- pr3 %>% 
  #filter(Liga == "Adeptos al Bar Feria") %>% 
  ggplot(aes(x = Jugador, y = Puntaje)) +
  geom_col()
plot(g1)

g2 <- pr4 %>% 
  #filter(Grupo == "A") %>% 
  ggplot(aes(x = factor(Prediccion), y = Equipo)) +
  geom_count(aes(color = Grupo))
plot(g2)




