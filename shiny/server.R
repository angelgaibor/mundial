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
     mutate(resul_gru = ifelse(Siglas == input$a1, "Primero del grupo A", ""))
   )
   
   
   output$descarga <- downloadHandler(
     filename = function() {
       paste0("polla_mundialista_", input$nombre, ".xlsx")
     },
     content = function(file) {
       openxlsx::write.xlsx(lol(), file)
     }
   )
}


