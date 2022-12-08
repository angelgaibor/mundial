#
#Input de equipos clasificados a octavos #####
output$c11 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="c"][1]
})

output$c12 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="c"][1]
})

output$c21 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="c"][2]
})

output$c22 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="c"][2]
})

output$c31 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="c"][3]
})

output$c32 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="c"][3]
})

output$c41 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="c"][4]
})

output$c42 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="c"][4]
})

#
#Inpunt text de posibles penales #####
output$pc11 <- renderUI({
  if (input$gc11 != input$gc12| input$gc11 == "" | input$gc12 == "") return(NULL) else {
    textInput("qc11", NULL,  width = "36px")
  }
})

output$pc12 <- renderUI({
  if (input$gc11 != input$gc12 | input$gc11 == "" | input$gc12 == "") return(NULL) else {
    textInput("qc12", NULL, width = "36px")
  }
})
output$pc21 <- renderUI({
  if (input$gc21 != input$gc22| input$gc21 == "" | input$gc22 == "") return(NULL) else {
    textInput("qc21", NULL,  width = "36px")
  }
})

output$pc22 <- renderUI({
  if (input$gc21 != input$gc22 | input$gc21 == "" | input$gc22 == "") return(NULL) else {
    textInput("qc22", NULL, width = "36px")
  }
})
output$pc31 <- renderUI({
  if (input$gc31 != input$gc32| input$gc31 == "" | input$gc32 == "") return(NULL) else {
    textInput("qc31", NULL,  width = "36px")
  }
})

output$pc32 <- renderUI({
  if (input$gc31 != input$gc32 | input$gc31 == "" | input$gc32 == "") return(NULL) else {
    textInput("qc32", NULL, width = "36px")
  }
})
output$pc41 <- renderUI({
  if (input$gc41 != input$gc42| input$gc41 == "" | input$gc42 == "") return(NULL) else {
    textInput("qc41", NULL,  width = "36px")
  }
})

output$pc42 <- renderUI({
  if (input$gc41 != input$gc42 | input$gc41 == "" | input$gc42 == "") return(NULL) else {
    textInput("qc42", NULL, width = "36px")
  }
})

#
#Cuartos de final ####
pre_cuartos <- reactive({
  req(input$gc11, input$gc21, input$gc31, input$gc41,
      input$gc12, input$gc22, input$gc32, input$gc42)
  
  penales1 <- rep("0", 4)
  if(is.vector(input$qc11)){penales1[1] <- input$qc11}
  if(is.vector(input$qc21)){penales1[2] <- input$qc21}
  if(is.vector(input$qc31)){penales1[3] <- input$qc31}
  if(is.vector(input$qc41)){penales1[4] <- input$qc41}
  
  penales2 <- rep("0", 4)
  if(is.vector(input$qc12)){penales2[1] <- input$qc12}
  if(is.vector(input$qc22)){penales2[2] <- input$qc22}
  if(is.vector(input$qc32)){penales2[3] <- input$qc32}
  if(is.vector(input$qc42)){penales2[4] <- input$qc42}
  
  cuartos1 <- data.frame(
    equipo1 = res_elim_directa$equipo1[res_elim_directa$fase=="c"],
    equipo2 = res_elim_directa$equipo2[res_elim_directa$fase=="c"],
    g1 = c(input$gc11, input$gc21, input$gc31, input$gc41),
    g2 = c(input$gc12, input$gc22, input$gc32, input$gc42),
    p1 = penales1,
    p2 = penales2,
    semis = c(1, 1, 2, 2)
  )
})

output$tabla_semis <- renderTable({
  pre_cuartos() %>% 
    mutate(clasificado = case_when(g1 > g2 ~ equipo1,
                                   g1 < g2 ~ equipo2,
                                   p1 > p2 ~ equipo1,
                                   p1 < p2 ~ equipo2,
                                   T ~ "Error en su marcador")) %>% 
    group_by(semis) %>%
    summarise(equipo1 = first(clasificado),
              equipo2 = last(clasificado), 
              vs =" - ") %>% 
    select(`Equipo C1` = equipo1, 
           vs,
           `Equipo C2` = equipo2)
}) 
####

#
#Infobox: verificar si jugador y codigo existe
output$ib_cod_cua <- renderInfoBox({
  if(tolower(input$codigo_cuartos) %in% tolower(pr3$Codigo)){
    titulo = "Identificación"
    valor = paste0("Jugador: ", pr3$Jugador[tolower(pr3$Codigo) == tolower(input$codigo_cuartos)])
    subtitulo = paste0("Liga: ", pr3$Liga[tolower(pr3$Codigo) == tolower(input$codigo_cuartos)])
    colorib = "green"
    iconob = icon("ok", lib = "glyphicon")
  }else{
    titulo = "Código"
    valor = "incorrecto"
    subtitulo = "contáctate con el administrador"
    colorib = "red"
    iconob = icon("remove", lib = "glyphicon")
  }
  infoBox(titulo, valor, subtitulo, color = colorib, icon = iconob, width = 12)
}) 

#
# dar click al boton y enviar resultados
observeEvent(input$pro_cua, {
  v_c$guardado <- T
  pre_cuartos_f <- pre_cuartos() %>%
    mutate(codigo = input$codigo_cuartos) %>% 
    select(equipo1, equipo2,	g1,	g2,	p1,	p2,	codigo) %>% 
    ungroup() %>% 
    as.data.frame()
  v_c$pre_cuartos_fin <- agrega_prediccion_cuartos(pre_cuartos_f, T)
})


#Infobox: verificar envío de resultados
output$vb_conf_cua <- renderValueBox({
  mensaje <- "Envía"
  subt <- "tu pronóstico"
  colorib <- "red"
  if(v_c$guardado == T & input$codigo_cuartos != ""){
    mensaje <- "Resultado enviado"
    subt <- "ya dejen de darle click al botón :("
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
