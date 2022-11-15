#
# Define server logic required to draw a histogram
#
source("R/global.R",local = T)
server <- function(input, output, session){
    
   output$ib_equ_com <- renderInfoBox({
        infoBox(
            HTML("Equipos en competencia"), 
            h6(32 - sum(equipos$Eliminado)), 
            icon = icon("cloud-upload", lib = "glyphicon"),
            color = "aqua", 
            fill = T
        )
    })
    
   lol <- reactive(
     
      equipos %>%
         mutate(resul_gru = case_when(Equipo %in% c(input$a1, input$b1, input$c1, input$d1,
                                                input$e1, input$f1, input$g1, input$h1) ~ "Primero",
                                      Equipo %in% c(input$a2, input$b2, input$c2, input$d2,
                                                input$e2, input$f2, input$g2, input$h2) ~ "Segundo",
                                  T ~ "")) %>% 
         filter(resul_gru != "") %>% 
         select(Siglas, Equipo, Grupo, Resultado = resul_gru)
   )  
   
   output$ib_res_con <- renderInfoBox({
      if(dim(lol())[1] == 16){
         colorib = "green"
         mensaje = "Puede descargar sus resultados"
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
   
   output$descarga <- downloadHandler(
     filename = function() {
       paste0("polla_mundialista_", input$nombre, ".xlsx")
     },
     content = function(file) {
       openxlsx::write.xlsx(lol(), file)
     }
   )
   
   output$tiempo <- renderValueBox({
      invalidateLater(1000, session)
      t <- difftime(as.POSIXlt.character("2022-11-20 11:00:00 -05"), Sys.time(), units = "days")
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
}


