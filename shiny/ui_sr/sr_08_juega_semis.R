#
#Input de equipos clasificados a octavos #####
output$s11 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="s"][1]
})

output$s12 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="s"][1]
})

output$s21 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="s"][2]
})

output$s22 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="s"][2]
})

#
#Inpunt text de posibles penales #####
output$ps11 <- renderUI({
  if (input$gs11 != input$gs12| input$gs11 == "" | input$gs12 == "") return(NULL) else {
    textInput("qs11", NULL,  width = "36px")
  }
})

output$ps12 <- renderUI({
  if (input$gs11 != input$gs12 | input$gs11 == "" | input$gs12 == "") return(NULL) else {
    textInput("qs12", NULL, width = "36px")
  }
})
output$ps21 <- renderUI({
  if (input$gs21 != input$gs22| input$gs21 == "" | input$gs22 == "") return(NULL) else {
    textInput("qs21", NULL,  width = "36px")
  }
})

output$ps22 <- renderUI({
  if (input$gs21 != input$gs22 | input$gs21 == "" | input$gs22 == "") return(NULL) else {
    textInput("qs22", NULL, width = "36px")
  }
})

#
# Semifinales ####
pre_semis <- reactive({
  req(input$gs11, input$gs21, input$gs12, input$gs22)
  
  penales1 <- rep("0", 2)
  if(is.vector(input$qs11)){penales1[1] <- input$qs11}
  if(is.vector(input$qs21)){penales1[2] <- input$qs21}
  
  penales2 <- rep("0", 2)
  if(is.vector(input$qs12)){penales2[1] <- input$qs12}
  if(is.vector(input$qs22)){penales2[2] <- input$qs22}
  
  semis1 <- data.frame(
    equipo1 = res_elim_directa$equipo1[res_elim_directa$fase=="s"],
    equipo2 = res_elim_directa$equipo2[res_elim_directa$fase=="s"],
    g1 = c(input$gs11, input$gs21),
    g2 = c(input$gs12, input$gs22),
    p1 = penales1,
    p2 = penales2,
    final = c(1, 2)
  )
})

output$tabla_final <- renderTable({
  pre_semis() %>% 
    mutate(clasificado = case_when(g1 > g2 ~ equipo1,
                                   g1 < g2 ~ equipo2,
                                   p1 > p2 ~ equipo1,
                                   p1 < p2 ~ equipo2,
                                   T ~ "Error en su marcador")) %>% 
    group_by(final) %>%
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
output$ib_cod_sem <- renderInfoBox({
  if(tolower(input$codigo_semis) %in% tolower(pr3$Codigo)){
    titulo = "Identificación"
    valor = paste0("Jugador: ", pr3$Jugador[tolower(pr3$Codigo) == tolower(input$codigo_semis)])
    subtitulo = paste0("Liga: ", pr3$Liga[tolower(pr3$Codigo) == tolower(input$codigo_semis)])
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
observeEvent(input$pro_sem, {
  v_s$guardado <- T
  pre_semis_f <- pre_semis() %>%
    mutate(codigo = input$codigo_semis) %>% 
    select(equipo1, equipo2,	g1,	g2,	p1,	p2,	codigo) %>% 
    ungroup() %>% 
    as.data.frame()
  v_s$pre_semis_fin <- agrega_prediccion_semis(pre_semis_f, T)
})

#Infobox: verificar envío de resultados
output$vb_conf_sem <- renderValueBox({
  mensaje <- "Envía"
  subt <- "tu pronóstico"
  colorib <- "red"
  if(v_s$guardado == T & input$codigo_semis != ""){
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
