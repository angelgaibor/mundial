library(googlesheets4)
gs4_deauth()
qatar22 <- "https://docs.google.com/spreadsheets/d/13qZaElTnoTFK1f40lKW9geqS6dsbqkJOzMAbIoLs8IU/"
equipos <- read_sheet(qatar22)

gs4_deauth()
resultados <- "https://docs.google.com/spreadsheets/d/10bKKPH_tYS6OBK4ucWGHznx5RlkXCc7jVA0FBo4-vCc/"

gs4_deauth()
li_ligas <- "https://docs.google.com/spreadsheets/d/1G9vbPS4sYwRbAcs-325NpIFgr9VTnffCwZYlEyucWig/"
lista_ligas <- read_sheet(li_ligas)

partidos <- read.xlsx("shiny/data/partidos.xlsx")

partidos_jugados <- partidos %>% 
  filter(!is.na(GA))

equipoa <- partidos_jugados %>% 
  rename(Equipo = EquipoA) %>% 
  mutate(J = 1,
         G = ifelse(GA > GB, 1, 0),
         P = ifelse(GA < GB, 1, 0),
         E = ifelse(GA == GB, 1, 0),
         GF = GA,
         GC = GB) %>% 
  select(Equipo, J, G, P, E, GF, GC)

equipob <- partidos_jugados %>% 
  rename(Equipo = EquipoB) %>% 
  mutate(J = 1,
         G = ifelse(GB > GA, 1, 0),
         P = ifelse(GB < GA, 1, 0),
         E = ifelse(GB == GA, 1, 0),
         GF = GB,
         GC = GA) %>% 
  select(Equipo, J, G, P, E, GF, GC)

equipoab <- rbind(equipoa, equipob) %>% 
  group_by(Equipo) %>% 
  summarise_all(sum)

posiciones <- partidos %>% 
  group_by(Grupo, Equipo = EquipoA) %>% 
  summarise() %>% 
  left_join(equipoab, by = "Equipo") %>% 
  replace(is.na(.), 0) %>% 
  mutate(DG = GF - GC,
         Pts = G*3 + E) %>% 
  arrange(Grupo, desc(Pts), desc(DG), desc(G)) %>% 
  cbind(Pos = rep(c(1,2,3,4), 8)) %>% 
  select(Grupo, Pos, Equipo, Pts, J, G, P, E, GF, GC, DG)
  
