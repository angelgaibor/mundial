#
# Tablas de posición por grupo #####

output$g1 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "A") %>% 
    select(-Grupo),
  align = "c"
)

output$g2 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "B") %>% 
    select(-Grupo),
  align = "c"
)

output$g3 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "C") %>% 
    select(-Grupo),
  align = "c"
)

output$g4 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "D") %>% 
    select(-Grupo),
  align = "c"
)

output$g5 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "E") %>% 
    select(-Grupo),
  align = "c"
)

output$g6 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "F") %>% 
    select(-Grupo),
  align = "c"
)

output$g7 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "G") %>% 
    select(-Grupo),
  align = "c"
)

output$g8 <- renderTable(
  posiciones1 %>% 
    filter(Grupo == "H") %>% 
    select(-Grupo),
  align = "c"
) 