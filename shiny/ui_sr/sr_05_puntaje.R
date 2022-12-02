
# gráfico de total de votos por posición recibidos
pr6 <- reactive({
  
  pr5 <- pr4 %>% 
    group_by(Grupo, Equipo, Prediccion) %>% 
    summarise(np1 = n(),
              np2 = n()) %>% 
    ungroup() %>% 
    mutate(np1 = ifelse(Prediccion==1, np1, 0),
           np2 = ifelse(Prediccion==2, np2, 0),
           pt = np1*2 + np2*1) %>% 
    group_by(Equipo) %>% 
    summarise(pt = sum(pt)) %>% 
    ungroup() %>% 
    right_join(select(posiciones, Grupo, Equipo), by = "Equipo") %>% 
    left_join(select(equipos, Equipo, Siglas), by = "Equipo") %>% 
    mutate(pt = ifelse(is.na(pt), 0, pt)) %>% 
    select(Grupo, Siglas, pt) %>% 
    arrange(desc(Grupo), pt) %>% 
    mutate(orden = factor(paste0(Grupo, "-", pt, "-", Siglas), paste0(Grupo, "-", pt, "-", Siglas), labels = Siglas)) %>% 
    select(Siglas, orden) %>% 
    right_join(pr4, by = "Siglas") %>% 
    mutate(pre = ifelse(Prediccion ==1, "1ro", "2do"))
  
  if(input$liga1 == "Todos contra todos" | is.null(input$liga1)){
    if(input$jugador1 == "Todos" | is.null(input$jugador1)){
      pr5
    }else{
      pr5 %>% filter(Jugador == input$jugador1)
    }
  }else {
    if(input$jugador1 == "Todos" | is.null(input$jugador1)){
      pr5 %>% 
        filter(Liga == input$liga1)
    }else{
      pr5 %>% 
        filter(Liga == input$liga1) %>% 
        filter(Jugador == input$jugador1)
    }
  }
})

output$bolitas <- renderPlot({
  validate(
    need(input$liga1, "Por favor, selecciona una Liga.")
  )
  
  ggplot(data = pr6(), aes(x = pre, y = orden)) +
    geom_count(aes(color = Grupo)) +
    facet_wrap(~ Grupo, ncol = 2, nrow = 4, scales= "free") +
    theme(axis.title = element_blank(),
          legend.position="none")
})
# Gráfico de barritas
bdd_gra_jug_pun <- reactive({
  if(input$liga1 == "Todos contra todos"  | is.null(input$liga1)){
    pr3 %>% 
      mutate(Jugador = paste0(toupper(substr(Liga, 1, 3)), "\n", Jugador)) %>% 
      arrange(Puntaje, Jugador) %>% 
      mutate(puntos1 = str_pad(Puntaje, 2, "left", "0"),
             Jugador = factor(paste0(puntos1, Jugador), levels = paste0(puntos1, Jugador), labels = Jugador))
  }else{
    pr3 %>% 
      filter(Liga == input$liga1) %>% 
      arrange(Puntaje, Jugador, Liga) %>% 
      mutate(puntos1 = str_pad(Puntaje, 2, "left", "0"),
             Jugador = factor(x = paste0(puntos1, Jugador, Liga), levels = paste0(puntos1, Jugador, Liga), labels = Jugador))
  }
})

#
# grafico de puntos por jugador/liga
output$gra_jug_pun <- renderPlot({
  validate(
    need(input$liga1, "Por favor, selecciona una Liga.")
  )
  
  if(dim(bdd_gra_jug_pun())[1]>10){
    li <- bdd_gra_jug_pun()[(dim(bdd_gra_jug_pun())[1] - 9) :dim(bdd_gra_jug_pun())[1], ]
  }else{
    li <- bdd_gra_jug_pun()
  }
  
  li %>% 
    ggplot(aes(y = Jugador, x = Puntaje, fill = Jugador)) +
    geom_col() + 
    theme(panel.background = element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major.y = element_blank(),
          strip.background = element_rect(fill="white"),
          axis.text = element_text(size=7),
          axis.title = element_blank(),
          axis.title.x = element_blank(),
          legend.box = "vertical",
          legend.box.spacing = unit(0.5, "cm"),
          legend.direction = "vertical", 
          legend.position = "none",
          legend.text = element_text(size=7),
          legend.title = element_text(size=8),
          legend.title.align = 0.5,
          panel.border = element_rect(colour = "black", fill = NA))
})