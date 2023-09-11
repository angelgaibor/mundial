#
library(rvest)
library(tidyverse)
#
# Web scraping
#
fifa = read_html("https://es.wikipedia.org/wiki/Copa_Mundial_de_F%C3%BAtbol_de_2022") %>%
  html_elements('table') %>%
  html_table()

dim_t <- sapply(fifa, dim)

lolo <- fifa[dim_t[2,]==9]

posiciones <- do.call(rbind, lolo) %>% 
  mutate(Siglas = substr(`Selección`, 1, 3)) %>% 
  select(-`Selección`) %>% 
  full_join(equipos %>% select(Siglas, Grupo, Equipo), by = "Siglas") %>% 
  arrange(Grupo, desc(Pts), desc(Dif), desc(PG)) %>% 
  group_by(Grupo) %>% 
  mutate(Pos = row_number()) %>% 
  select(Grupo, Pos, Equipo, Pts, PJ, PG, PE, PP, GF, GC, Dif) %>% 
  ungroup()

#
# preparacion para output de tablas de cada grupo
posiciones1  <- posiciones %>% 
  left_join(equipos, by = c("Equipo", "Grupo")) %>%
  ungroup() %>% 
  mutate(`G-E-P` = paste0(PG,"-",PE,"-", PP),
         `GF(Dif)` = paste0(GF, "(", Dif, ")")) %>% 
  select(-Equipo) %>% 
  rename(Equipo = Siglas) %>% 
  select(Grupo, Pos, Equipo, Pts, PJ,`G-E-P`,  `GF(Dif)`)

rm(fifa, dim_t, lolo)


