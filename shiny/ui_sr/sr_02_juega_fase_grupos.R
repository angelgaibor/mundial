#
# lista de ligas
observeEvent(req(lista_ligas), {
  updateSelectizeInput(session, inputId = "liga", label = 'Selecciona tu Liga:', selected = NULL,
                       choices  = unique(lista_ligas$Liga))
  
  updateSelectizeInput(session, inputId = "liga1", label = 'Selecciona tu Liga:', selected = "Todos contra todos",
                       choices  = c("Todos contra todos", unique(lista_ligas$Liga)))
})

observeEvent(req(pr3, input$liga1), {
  if(input$liga1 == "Todos contra todos"){
    pr31 <- pr3 %>% 
      mutate(Jugador = paste0(toupper(substr(Liga, 1, 3)), " ", Jugador))
  }else{
    pr31 <- pr3 %>% 
      filter(Liga == input$liga1)
  }
  
  updateSelectizeInput(session, inputId = "jugador1", label = 'Selecciona al jugador:', selected = "Todos",
                       choices  = c("Todos", unique(pr31$Jugador)))
})
#
# prediccion del jugador
data <- reactive(
  
  equipos %>%
    mutate(resul_gru = case_when(Equipo %in% c(input$a1, input$b1, input$c1, input$d1,
                                               input$e1, input$f1, input$g1, input$h1) ~ "1",
                                 Equipo %in% c(input$a2, input$b2, input$c2, input$d2,
                                               input$e2, input$f2, input$g2, input$h2) ~ "2",
                                 T ~ "")) %>% 
    filter(resul_gru != "") %>%
    mutate(resul_gru = as.numeric(resul_gru),
           Jugador = input$nombre,
           Liga = input$liga) %>% 
    select(Siglas, Equipo, Grupo, Prediccion = resul_gru, Liga, Jugador)
)  
#
# infobox - prediccion es correcta o no
output$ib_res_con <- renderInfoBox({
  if(dim(data())[1] == 16 & input$nombre != "..." & input$liga != "..."){
    colorib = "green"
    mensaje = "Puede enviar sus resultados"
    iconob = icon("ok", lib = "glyphicon")
  }else if(input$nombre == "..."){
    colorib = "red"
    mensaje = "Ingresa tu nombre"
    iconob = icon("remove", lib = "glyphicon")
  }else if(input$liga == "..."){
    colorib = "red"
    mensaje = "Selecciona una Liga"
    iconob = icon("remove", lib = "glyphicon")
  }else{
    colorib = "red"
    mensaje = "Seleccione un equipo diferente en cada grupo"
    iconob = icon("remove", lib = "glyphicon")
  }
  infoBox(
    HTML("Estado de tu predicción"), 
    h6(mensaje), 
    icon = iconob,
    color = colorib, 
    fill = T
  )
})
#
# envía la predicción
observeEvent(input$pronostico, {
  # debug_msg("pronostico")
  # save the data and update summary data
  v$guardado <- T
  v$codigo <- stri_rand_strings(1,6)
  dato <- data() %>% 
    mutate(Codigo = v$codigo)
  v$predicciones <- agrega_prediccion(dato, T) #USING_GS4
  
})
#
# infobox de envío de resultados
output$ib_env_res <- renderValueBox({
  mensaje <- "Envía"
  subt <- "tu pronóstico"
  colorib <- "red"
  if(v$guardado == T){
    mensaje <- v$codigo
    subt <- "su código de participación. Guárdalo!!!"
    colorib <- "green"
  }
  valueBox(
    mensaje,
    subt,
    icon = icon("cloud-upload", lib = "glyphicon"),
    color = colorib, 
    width = 12
  )
})