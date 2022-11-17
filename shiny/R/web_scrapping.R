#
library(rvest)

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
  select(Grupo, Pos, Equipo, Pts, PJ, PG, PE, PP, GF, GC, Dif)

rm(fifa, dimt_t, lolo)


