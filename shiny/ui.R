#
# Carga de paquetes
#
library(haven)
library(openxlsx)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(sampling)
library(DT)
library(glue)
library(knitr)
library(rmarkdown)
#
options(shiny.maxRequestSize=30*1024^2,
        shiny.reactlog=TRUE) 
#
# Interfaz de usuario
#


ui <- dashboardPage(skin="black",
                    
                    dashboardHeader(title = "Polla mundialista Adeptos", titleWidth = 480
                    ),
                    
                    # panel lateral
                    dashboardSidebar(width = 240,
                                     sidebarMenu(menuItem("Informacion", tabName = "info", selected = T, 
                                                          icon = icon("sort-by-alphabet", lib="glyphicon")),
                                                 menuItem("Juega conmigo", tabName = "juega",
                                                          icon = icon("atlas"))
                                     )
                                     
                    ),
                    
                    # cuerpo
                    dashboardBody(
                      tabItems(
                        tabItem("info", 
                                fluidRow(column(width = 12, valueBoxOutput("tiempo", width = 12)),
                                         column(width = 6,
                                                box(title = "Mundial Qatar 2022", status = "danger", solidHeader = T, width = 12,
                                                    "Esto copiamos de wikipedia: La Copa Mundial de Fútbol de la FIFA Catar 2022 (en árabe, كأس العالم لكرة
                                                    القدم قطر 2022) será la XXII edición de la Copa Mundial de Fútbol masculino 
                                                    organizada por la FIFA. Se desarrollará desde el 20 de noviembre al 18 de diciembre en 
                                                    Catar, que consiguió los derechos de organización el 2 de diciembre de 2010.",
                                                    br(), br(),
                                                    "En Ecuador no va jugar el Kitu :("),
                                                box(title = "Reglas del juego", status = "danger", solidHeader = T, width = 12,
                                                    "- En la pestaña Juega conmigo, ingresa tu nombre y selecciona el primer y segundo equipo de cada grupo.",br(),
                                                    "- Debes guardar tus resultados dando click en el botón Su resultado una vez que hayas seleccionado a tus equipos", br(),
                                                    "- El archivo excel que se descarga se debe enviar a los correos javier.ns87@gmail.com o angleito2112@gmail.com.", br(),
                                                    "- De forma simbólica para participar se debe depositar $1, así se repartirá lo reunido entre las tres personas que obtengan mayor puntaje.", br(),
                                                    "- 50% para el primer lugar, 30% para el segundo lugar y 20% para el tercer lugar", br(),
                                                    "- El criterio de desempate en el caso de darse se definirá por quien tenga mayor número de aciertos en la posición de los equipos."),
                                                box(title = "Sistema de puntos", status = "danger", solidHeader = T, width = 12,
                                                    "- Por cada equipo clasificado a octavos de final recibes 1 punto.", br(),
                                                    "- Además si aciertas a la posición de clasificación de tu equipo recibes un punto extra.", br()
                                                )
                                         ),
                                         column(width = 6, img(src = "logo.jpg", style = "width:600px"))
                                )
                        ),
                        tabItem("juega", h1("Tu predicción"),
                                textInput("nombre", "Ingresa tu nombre/apodo", value = "..."),
#####
                                fluidRow(
                                  box(title = "Grupo A", status = "primary", solidHeader = T, width = 3,
                                             selectizeInput("a1", label = NULL, equipos$Equipo[equipos$Grupo=="A"], 
                                                            multiple = F, 
                                                            options = list(placeholder = "Primero...", 
                                                                           onInitialize = I('function() { this.setValue("");}'))),
                                             selectizeInput("a2", label = NULL, equipos$Equipo[equipos$Grupo=="A"], 
                                                            multiple = F, 
                                                            options = list(placeholder = "Segundo...", 
                                                                           onInitialize = I('function() { this.setValue("");}')))
                                      ),
                                  box(title = "Grupo B", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("b1", label = NULL, equipos$Equipo[equipos$Grupo=="B"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("b2", label = NULL, equipos$Equipo[equipos$Grupo=="B"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo C", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("c1", label = NULL, equipos$Equipo[equipos$Grupo=="C"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("c2", label = NULL, equipos$Equipo[equipos$Grupo=="C"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo D", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("d1", label = NULL, equipos$Equipo[equipos$Grupo=="D"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("d2", label = NULL, equipos$Equipo[equipos$Grupo=="D"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo E", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("e1", label = NULL, equipos$Equipo[equipos$Grupo=="E"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("e2", label = NULL, equipos$Equipo[equipos$Grupo=="E"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo F", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("f1", label = NULL, equipos$Equipo[equipos$Grupo=="F"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("f2", label = NULL, equipos$Equipo[equipos$Grupo=="F"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo G", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("g1", label = NULL, equipos$Equipo[equipos$Grupo=="G"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("g2", label = NULL, equipos$Equipo[equipos$Grupo=="G"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo H", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("h1", label = NULL, equipos$Equipo[equipos$Grupo=="H"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("h2", label = NULL, equipos$Equipo[equipos$Grupo=="H"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  infoBoxOutput("ib_res_con")
                                )
#####
                                ,
                                downloadButton("descarga", label = "Su resultado",
                                               class = "btn-block")
                        )
                      )
                    )
)

# incluir link a https://www.glyphicons.com/

