#
#Input de equipos clasificados a octavos #####
output$nga1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "A" & posiciones1$Pos == 1]
})

output$nga2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "A" & posiciones1$Pos == 2]
})

output$ngb1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "B" & posiciones1$Pos == 1]
})

output$ngb2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "B" & posiciones1$Pos == 2]
})

output$ngc1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "C" & posiciones1$Pos == 1]
})

output$ngc2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "C" & posiciones1$Pos == 2]
})

output$ngd1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "D" & posiciones1$Pos == 1]
})

output$ngd2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "D" & posiciones1$Pos == 2]
})

output$nge1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "E" & posiciones1$Pos == 1]
})

output$nge2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "E" & posiciones1$Pos == 2]
})

output$ngf1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "F" & posiciones1$Pos == 1]
})

output$ngf2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "F" & posiciones1$Pos == 2]
})

output$ngg1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "G" & posiciones1$Pos == 1]
})

output$ngg2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "G" & posiciones1$Pos == 2]
})

output$ngh1 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "H" & posiciones1$Pos == 1]
})

output$ngh2 <- renderText({
  posiciones1$Equipo[posiciones1$Grupo == "H" & posiciones1$Pos == 2]
})

#
#Inpunt text de posibles penales #####
output$po11 <- renderUI({
  if (input$go11 != input$go12| input$go11 == "" | input$go12 == "") return(NULL) else {
    textInput("qo11", NULL,  width = "36px")
  }
})

output$po12 <- renderUI({
  if (input$go11 != input$go12 | input$go11 == "" | input$go12 == "") return(NULL) else {
    textInput("qo12", NULL, width = "36px")
  }
})
output$po21 <- renderUI({
  if (input$go21 != input$go22| input$go21 == "" | input$go22 == "") return(NULL) else {
    textInput("qo21", NULL,  width = "36px")
  }
})

output$po22 <- renderUI({
  if (input$go21 != input$go22 | input$go21 == "" | input$go22 == "") return(NULL) else {
    textInput("qo22", NULL, width = "36px")
  }
})
output$po31 <- renderUI({
  if (input$go31 != input$go32| input$go31 == "" | input$go32 == "") return(NULL) else {
    textInput("qo31", NULL,  width = "36px")
  }
})

output$po32 <- renderUI({
  if (input$go31 != input$go32 | input$go31 == "" | input$go32 == "") return(NULL) else {
    textInput("qo32", NULL, width = "36px")
  }
})
output$po41 <- renderUI({
  if (input$go41 != input$go42| input$go41 == "" | input$go42 == "") return(NULL) else {
    textInput("qo41", NULL,  width = "36px")
  }
})

output$po42 <- renderUI({
  if (input$go41 != input$go42 | input$go41 == "" | input$go42 == "") return(NULL) else {
    textInput("qo42", NULL, width = "36px")
  }
})

output$po51 <- renderUI({
  if (input$go51 != input$go52| input$go51 == "" | input$go52 == "") return(NULL) else {
    textInput("qo51", NULL,  width = "36px")
  }
})

output$po52 <- renderUI({
  if (input$go51 != input$go52 | input$go51 == "" | input$go52 == "") return(NULL) else {
    textInput("qo52", NULL, width = "36px")
  }
})

output$po61 <- renderUI({
  if (input$go61 != input$go62| input$go61 == "" | input$go62 == "") return(NULL) else {
    textInput("qo61", NULL,  width = "36px")
  }
})

output$po62 <- renderUI({
  if (input$go61 != input$go62 | input$go61 == "" | input$go62 == "") return(NULL) else {
    textInput("qo62", NULL, width = "36px")
  }
})

output$po71 <- renderUI({
  if (input$go71 != input$go72| input$go71 == "" | input$go72 == "") return(NULL) else {
    textInput("qo71", NULL,  width = "36px")
  }
})

output$po72 <- renderUI({
  if (input$go71 != input$go72 | input$go71 == "" | input$go72 == "") return(NULL) else {
    textInput("qo72", NULL, width = "36px")
  }
})

output$po81 <- renderUI({
  if (input$go81 != input$go82| input$go81 == "" | input$go82 == "") return(NULL) else {
    textInput("qo81", NULL,  width = "36px")
  }
})

output$po82 <- renderUI({
  if (input$go81 != input$go82 | input$go81 == "" | input$go82 == "") return(NULL) else {
    textInput("qo82", NULL, width = "36px")
  }
})
#
#Cuartos de final ####
pre_octavos <- reactive({
  req(input$go11, input$go21, input$go31, input$go41,
      input$go51, input$go61, input$go71, input$go81,
      input$go12, input$go22, input$go32, input$go42,
      input$go52, input$go62, input$go72, input$go82)
  
  penales1 <- rep(0, 8)
  if(is.vector(input$qo11)){penales1[1] <- input$qo11}
  if(is.vector(input$qo21)){penales1[2] <- input$qo21}
  if(is.vector(input$qo31)){penales1[3] <- input$qo31}
  if(is.vector(input$qo41)){penales1[4] <- input$qo41}
  if(is.vector(input$qo51)){penales1[5] <- input$qo51}
  if(is.vector(input$qo61)){penales1[6] <- input$qo61}
  if(is.vector(input$qo71)){penales1[7] <- input$qo71}
  if(is.vector(input$qo81)){penales1[8] <- input$qo81}
  
  penales2 <- rep(0, 8)
  if(is.vector(input$qo12)){penales2[1] <- input$qo12}
  if(is.vector(input$qo22)){penales2[2] <- input$qo22}
  if(is.vector(input$qo32)){penales2[3] <- input$qo32}
  if(is.vector(input$qo42)){penales2[4] <- input$qo42}
  if(is.vector(input$qo52)){penales2[5] <- input$qo52}
  if(is.vector(input$qo62)){penales2[6] <- input$qo62}
  if(is.vector(input$qo72)){penales2[7] <- input$qo72}
  if(is.vector(input$qo82)){penales2[8] <- input$qo82}
  
  octavos1 <- data.frame(
    primeros = c(posiciones1$Equipo[posiciones1$Grupo == "A" & posiciones1$Pos == 1],
                 posiciones1$Equipo[posiciones1$Grupo == "C" & posiciones1$Pos == 1],
                 posiciones1$Equipo[posiciones1$Grupo == "E" & posiciones1$Pos == 1],
                 posiciones1$Equipo[posiciones1$Grupo == "G" & posiciones1$Pos == 1],
                 posiciones1$Equipo[posiciones1$Grupo == "B" & posiciones1$Pos == 1],
                 posiciones1$Equipo[posiciones1$Grupo == "D" & posiciones1$Pos == 1],
                 posiciones1$Equipo[posiciones1$Grupo == "F" & posiciones1$Pos == 1],
                 posiciones1$Equipo[posiciones1$Grupo == "H" & posiciones1$Pos == 1]
    ),
    segundos = c(posiciones1$Equipo[posiciones1$Grupo == "B" & posiciones1$Pos == 2],
                 posiciones1$Equipo[posiciones1$Grupo == "D" & posiciones1$Pos == 2],
                 posiciones1$Equipo[posiciones1$Grupo == "F" & posiciones1$Pos == 2],
                 posiciones1$Equipo[posiciones1$Grupo == "H" & posiciones1$Pos == 2],
                 posiciones1$Equipo[posiciones1$Grupo == "A" & posiciones1$Pos == 2],
                 posiciones1$Equipo[posiciones1$Grupo == "C" & posiciones1$Pos == 2],
                 posiciones1$Equipo[posiciones1$Grupo == "E" & posiciones1$Pos == 2],
                 posiciones1$Equipo[posiciones1$Grupo == "G" & posiciones1$Pos == 2]
    ),
    g1 = c(input$go11, input$go21, input$go31, input$go41,
           input$go51, input$go61, input$go71, input$go81),
    g2 = c(input$go12, input$go22, input$go32, input$go42,
           input$go52, input$go62, input$go72, input$go82),
    p1 = penales1,
    p2 = penales2,
    cuartos = c(1, 1, 2, 2, 3, 3, 4, 4)
  )
})

output$tabla_cuartos <- renderTable({
  pre_octavos() %>% 
    mutate(clasificado = case_when(g1 > g2 ~ primeros,
                                   g1 < g2 ~ segundos,
                                   p1 > p2 ~ primeros,
                                   p1 < p2 ~ segundos,
                                   T ~ "Error en su marcador")) %>% 
    group_by(cuartos) %>%
    summarise(equipo1 = first(clasificado),
              equipo2 = last(clasificado), 
              vs =" - ") %>% 
    select(`Equipo C1` = equipo1, 
           vs,
           `Equipos C2` = equipo2)
}) 
####

#Puntos octavos ####
puntos <- posiciones1 %>% 
  filter(Pos %in% c(1, 2)) %>% 
  cbind(cuartos = c(1, 5, 5, 1, 2, 6, 6, 2, 3, 7, 7, 3, 4, 8, 8, 4)) %>% 
  group_by(cuartos) %>% 
  summarise(equipo1 = first(Equipo),
            equipo2 = last(Equipo))

#
#Infobox: verificar si jugador y codigo existe
output$ib_cod_oct <- renderInfoBox({
  if(tolower(input$codigo_octavos) %in% tolower(pr3$Codigo)){
    titulo = "Identificación"
    valor = paste0("Jugador: ", pr3$Jugador[tolower(pr3$Codigo) == tolower(input$codigo_octavos)])
    subtitulo = paste0("Liga: ", pr3$Liga[tolower(pr3$Codigo) == tolower(input$codigo_octavos)])
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
observeEvent(input$pro_oct, {
  v_o$guardado <- T
  pre_octavos_f <- pre_octavos() %>%
    mutate(codigo = input$codigo_octavos) %>% 
    select(primeros, segundos,	g1,	g2,	p1,	p2,	codigo) %>% 
    ungroup() %>% 
    as.data.frame()
  v_o$pre_octavos_fin <- agrega_prediccion_octavos(pre_octavos_f, T)
})
