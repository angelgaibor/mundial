#
# Define server logic required to draw a histogram
#
source("R/global.R",local = T)

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
    t <- difftime(as.POSIXlt.character("2022-11-20 11:00:00 -00"), Sys.time(), units = "days")
    t <- as.numeric(t)
    dias <- floor(t)
    horas <- floor((t - floor(t))*24)
    minutos <- floor(((t - floor(t))*24 - horas)*60)
    segundos <- floor(t*24*60*60 - (dias*24*60*60 + horas*60*60 + minutos*60))
    minutos <- str_pad(minutos, 2, "left", "0")
    segundos <- str_pad(segundos, 2, "left", "0")
    mensaje <- paste0(dias, " dias ", horas, ":", minutos, ":", segundos)
    valueBox(mensaje, "restantes para Qatar 2022", icon = icon("time", lib = "glyphicon"), color = "yellow")
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
  
  # output de prueba tabla
  output$lala <- renderTable(
    head(posiciones)
  )
}


