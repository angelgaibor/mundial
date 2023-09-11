#
#Input de equipos clasificados a octavos #####
output$f1 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="f"]
})

output$f2 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="f"]
})

output$t1 <- renderText({
  res_elim_directa$equipo1[res_elim_directa$fase=="t"]
})

output$t2 <- renderText({
  res_elim_directa$equipo2[res_elim_directa$fase=="t"]
})

#
#Inpunt text de posibles penales #####
output$pf1 <- renderUI({
  if (input$gf1 != input$gf2| input$gf1 == "" | input$gf2 == "") return(NULL) else {
    textInput("qf1", NULL,  width = "36px")
  }
})

output$pf2 <- renderUI({
  if (input$gf1 != input$gf2 | input$gf1 == "" | input$gf2 == "") return(NULL) else {
    textInput("qf2", NULL, width = "36px")
  }
})
output$pt1 <- renderUI({
  if (input$gt1 != input$gt2| input$gt1 == "" | input$gt2 == "") return(NULL) else {
    textInput("qt1", NULL,  width = "36px")
  }
})

output$pt2 <- renderUI({
  if (input$gt1 != input$gt2 | input$gt1 == "" | input$gt2 == "") return(NULL) else {
    textInput("qt2", NULL, width = "36px")
  }
})

#
# Tercer puesto y final ####
pre_tercero <- reactive({
  req(input$gt1, input$gt2)
  
  penales1 <- "0"
  if(is.vector(input$qt1)){penales1 <- input$qt1}
  
  penales2 <- "0"
  if(is.vector(input$qt2)){penales2 <- input$qt2}
  
  semis1 <- data.frame(
    equipo1 = res_elim_directa$equipo1[res_elim_directa$fase=="t"],
    equipo2 = res_elim_directa$equipo2[res_elim_directa$fase=="t"],
    g1 = input$gt1,
    g2 = input$gt2,
    p1 = penales1,
    p2 = penales2
  )
})

pre_final <- reactive({
  req(input$gf1, input$gf2)
  
  penales1 <- "0"
  if(is.vector(input$qf1)){penales1 <- input$qf1}
  
  penales2 <- "0"
  if(is.vector(input$qf2)){penales2 <- input$qf2}
  
  semis1 <- data.frame(
    equipo1 = res_elim_directa$equipo1[res_elim_directa$fase=="f"],
    equipo2 = res_elim_directa$equipo2[res_elim_directa$fase=="f"],
    g1 = input$gf1,
    g2 = input$gf2,
    p1 = penales1,
    p2 = penales2
  )
})

output$tabla_campeones <- renderTable({
  lugar3_4 <- pre_tercero() %>% 
    mutate(ganador = case_when(g1 > g2 ~ equipo1,
                               g1 < g2 ~ equipo2,
                               p1 > p2 ~ equipo1,
                               p1 < p2 ~ equipo2,
                               T ~ "Error en su marcador"),
           perdedor = case_when(g1 > g2 ~ equipo2,
                                g1 < g2 ~ equipo1,
                                p1 > p2 ~ equipo2,
                                p1 < p2 ~ equipo1,
                                T ~ "Error en su marcador"))
  
  lugar1_2 <- pre_final() %>% 
    mutate(ganador = case_when(g1 > g2 ~ equipo1,
                               g1 < g2 ~ equipo2,
                               p1 > p2 ~ equipo1,
                               p1 < p2 ~ equipo2,
                               T ~ "Error en su marcador"),
           perdedor = case_when(g1 > g2 ~ equipo2,
                                g1 < g2 ~ equipo1,
                                p1 > p2 ~ equipo2,
                                p1 < p2 ~ equipo1,
                                T ~ "Error en su marcador"))
  
  campeones <- data.frame(
    Lugar = c("Campeón", "Subcampeón", "Tercero", "Cuarto"),
    Equipo = c(lugar1_2$ganador, lugar1_2$perdedor,
               lugar3_4$ganador, lugar3_4$perdedor)
    ) 
}) 
####

#
#Infobox: verificar si jugador y codigo existe
output$ib_cod_fin <- renderInfoBox({
  if(tolower(input$codigo_final) %in% tolower(pr3$Codigo)){
    titulo = "Identificación"
    valor = paste0("Jugador: ", pr3$Jugador[tolower(pr3$Codigo) == tolower(input$codigo_final)])
    subtitulo = paste0("Liga: ", pr3$Liga[tolower(pr3$Codigo) == tolower(input$codigo_final)])
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
observeEvent(input$pro_fin, {
  v_f$guardado <- T
  pre_final_f <- pre_final() %>%
    bind_rows(pre_tercero()) %>% 
    mutate(codigo = input$codigo_final) %>% 
    select(equipo1, equipo2,	g1,	g2,	p1,	p2,	codigo) %>% 
    ungroup() %>% 
    as.data.frame()
  v_s$pre_final_fin <- agrega_prediccion_final(pre_final_f, T)
})

#Infobox: verificar envío de resultados
output$vb_conf_fin <- renderValueBox({
  mensaje <- "Envía"
  subt <- "tu pronóstico"
  colorib <- "red"
  if(v_f$guardado == T & input$codigo_final != ""){
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
