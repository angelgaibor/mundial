#
# Define server logic required to draw a histogram
#
source("R/1_global.R",local = T)

# verifica si estamos usando googlesheets
USING_GS4 <- "googlesheets4" %in% (.packages()) && gs4_has_token()

# autorizacion en google sheet
gs4_auth(cache = ".secrets", email = "endi.dm.inec@gmail.com")

server <- function(input, output, session){
  
  # reactive values
  v <- reactiveValues()
  
  # Inicialización de objetos
  v$guardado <- F
  
  dato <- data.frame(
    Siglas = character(0),
    Equipo = character(0),
    Grupo	= character(0),
    Prediccion = double(0),
    Liga = character(0),
    Jugador = character(0),
    Codigo = character(0))
  
  # contador de tiempo para el mundial
  output$tiempo <- renderValueBox({
    invalidateLater(1000, session)
    
    t1 <- difftime(as.POSIXlt.character("2022-11-20 11:00:00 -05"), Sys.time(), units = "days") + 5/24
    t2 <- difftime(as.POSIXlt.character("2022-12-18 10:00:00 -05"), Sys.time(), units = "days") + 5/24
    if(as.numeric(t1)<0){
      t <- t2
      debajo <- "restantes para la final de Qatar 2022"
    }else{
      t <- t1
      debajo <- "restantes para Qatar 2022"
    }
    t <- as.numeric(t)
    dias <- floor(t)
    horas <- floor((t - floor(t))*24)
    minutos <- floor(((t - floor(t))*24 - horas)*60)
    segundos <- floor(t*24*60*60 - (dias*24*60*60 + horas*60*60 + minutos*60))
    minutos <- str_pad(minutos, 2, "left", "0")
    segundos <- str_pad(segundos, 2, "left", "0")
    mensaje <- paste0(dias, " días ", horas, ":", minutos, ":", segundos)
    valueBox(mensaje, debajo, icon = icon("time", lib = "glyphicon"), color = "yellow")
  })
  
  # infobox - equipos en competencia
  output$ib_equ_com <- renderInfoBox({
    infoBox(
      HTML("Equipos en competencia"), 
      h6(32 - sum(equipos$Eliminado)), 
      icon = icon("cloud-upload", lib = "glyphicon"),
      color = "aqua", 
      fill = T
    )
  })
  
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
  
  # infobox - prediccion es correcta o no
  output$ib_res_con <- renderInfoBox({
    if(dim(data())[1] == 16 & input$nombre != "..." & input$liga != "..."){
      colorib = "green"
      mensaje = "Puede enviar sus resultados"
    }else if(input$nombre == "..."){
      colorib = "red"
      mensaje = "Ingresa tu nombre"
    }else if(input$liga == "..."){
      colorib = "red"
      mensaje = "Selecciona una Liga"
    }else{
      colorib = "red"
      mensaje = "Seleccione un equipo diferente en cada grupo"
    }
    infoBox(
      HTML("Estado de tu predicción"), 
      h6(mensaje), 
      icon = icon("cloud-upload", lib = "glyphicon"),
      color = colorib, 
      fill = T
    )
  })
  # 
  # # descarga la predicción
  # output$descarga <- downloadHandler(
  #   filename = function() {
  #     paste0("polla_mundialista_", input$nombre, ".xlsx")
  #   },
  #   content = function(file) {
  #     openxlsx::write.xlsx(data(), file)
  #   }
  # )
  
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
  # output de tablas de cada grupo
  
  posiciones1  <- posiciones %>% 
    left_join(equipos, by = c("Equipo", "Grupo")) %>%
    ungroup() %>% 
    mutate(`G-E-P` = paste0(PG,"-",PE,"-", PP),
           `GF(Dif)` = paste0(GF, "(", Dif, ")")) %>% 
    select(-Equipo) %>% 
    rename(Equipo = Siglas) %>% 
    select(Grupo, Pos, Equipo, Pts, PJ,`G-E-P`,  `GF(Dif)`)
    
  # con todas las categorias   
  # 
  
  
  # Tablas de posición por grupo #####
   
  output$g1 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "A") %>% 
      select(-Grupo)
  })
  
  output$g2 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "B") %>% 
      select(-Grupo)
  })
  
  output$g3 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "C") %>% 
      select(-Grupo)
  })
  
  output$g4 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "D") %>% 
      select(-Grupo)
  })
  
  output$g5 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "E") %>% 
      select(-Grupo)
  })
  
  output$g6 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "F") %>% 
      select(-Grupo)
  })
  
  output$g7 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "G") %>% 
      select(-Grupo)
  })
  
  output$g8 <- renderTable({
    posiciones1 %>% 
      filter(Grupo == "H") %>% 
      select(-Grupo)
  }) 
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
  
  #Cuartos de final ####
  octavos <- reactive({
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
      cuartos = c(1, 1, 2, 2, 3, 3, 4, 4),
      orden = 
    ) 
  })
  
  output$tabla_cuartos <- renderTable({
    cuartos() %>% 
      mutate(clasificado = case_when(g1 > g2 ~ primeros,
                                     g1 < g2 ~ segundos,
                                     p1 > p2 ~ primeros,
                                     p1 < p2 ~ segundos,
                                     T ~ "Error en su marcador")) %>% 
      select(semis, cuartos, clasificado) %>% 
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
  
  
  }


