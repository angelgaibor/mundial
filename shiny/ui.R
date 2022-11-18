#
# Interfaz de usuario

# carga de paquetes
library(openxlsx)
library(rvest)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(glue)
library(stringi)

# autorizacion en google sheet
gs4_auth(cache = ".secrets", email = "endi.dm.inec@gmail.com")

tags$audio(src = "Magneto_Malherido.mp3", type = "audio/mp3", autoplay = NA, controls = NA)

ui <- dashboardPage(skin="black",
                    
                    dashboardHeader(title = "Polla mundialista CGB - Fase de Grupos", titleWidth = 480
                    ),
                    
                    # panel lateral
                    dashboardSidebar(width = 240,
                                     sidebarMenu(menuItem("Informacion", tabName = "info", selected = T, 
                                                          icon = icon("sort-by-alphabet", lib="glyphicon")),
                                                 menuItem("Juega conmigo", tabName = "juega",
                                                          icon = icon("atlas", lib = "glyphicon")),
                                                 menuItem("Tablas de posiciones", tabName = "grupos",
                                                          icon = icon("atlas")),
                                                 menuItem("Puntaje", tabName = "puntaje",
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
                                                    "Esto copiamos de wikipedia: La Copa Mundial de Fútbol de la FIFA Catar 2022
                                                     (en árabe, كأس العالم لكرة القدم قطر 2022) será la XXII edición de la Copa Mundial de
                                                     Fútbol masculino organizada por la FIFA. Se desarrollará desde el 20 de noviembre al
                                                     18 de diciembre en Catar, que consiguió los derechos de organización el 2 de diciembre
                                                    de 2010.",
                                                    br(), br(),
                                                    strong("Nota: Esta polla mundialista es sólo para la Fase de Grupos del Mundiasl Qatar 2022.
                                                    A partir de octavos de final se creará otra con un sistema de puntaje distinto."),
                                                    br(), br(),
                                                    "PD. En Ecuador no va jugar el Kitu :(",
                                                    br()),
                                                box(title = "Reglas del juego", status = "danger", solidHeader = T, width = 12,
                                                    "- En la pestaña Juega conmigo, ingresa tu nombre y liga", br(), br(),
                                                    "- Luego, selecciona el primer y segundo equipo de cada grupo.",
                                                    br(), br(),
                                                    "- Para enviar tus resultados da click en el botón ", strong("Envía tu pronóstico"), ".",
                                                    br(), br(),
                                                    "- Se visualizará un código el cual debes guardar para validar tus resultados.",
                                                    br()),
                                                box(title = "Sistema de puntos", status = "danger", solidHeader = T, width = 12,
                                                    "- Por cada equipo clasificado a octavos de final recibes ", strong("1 punto"), ".", br(), br(),
                                                    "- Además, si aciertas a la posición de clasificación de tu equipo recibes ", strong("1 punto extra"), ".",
                                                    br(), br(),
                                                    "- El criterio de desempate en el caso de darse se definirá por quien tenga mayor número de aciertos 
                                                    en la posición de los equipos.",
                                                    br(), br(),
                                                    strong("Notas:"),
                                                    "- La semana del 21/11/22 se incluirá una pestaña para revisar las clasificaciones.",
                                                    br(), br(),
                                                    "- Cada jugador puede tener un pronóstico diferente por liga.",
                                                    br(), br(),
                                                    "- Para crear una liga nueva contactar a los administradores (javier.ns87@gmail.com y/o angleito2112@gmail.com).",
                                                    br()
                                                    
                                                )
                                         ),
                                         column(width = 6, img(src = "logo.jpg", style = "width:360px"))
                                )
                        ),
                        tabItem("juega", h1("Ingresa tu predicción"),
                                fluidRow(
                                  column(width = 12,
                                         textInput("nombre", "Ingresa tu nombre/apodo", value = "..."),
                                         selectizeInput("liga", label = NULL, choices = "",
                                                        multiple = F,
                                                        options = list(placeholder = "...", 
                                                                       onInitialize = I('function() { this.setValue("");}'))),
                                  )),
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
                                  )
                                )
                                #####
                                ,
                                fluidRow(align = "center",
                                         column(width = 4, ""),
                                         column(width = 4, infoBoxOutput("ib_res_con", width = 12),
                                                actionButton("pronostico", "Envía tu pronóstico"),
                                                br(), br(),
                                                valueBoxOutput("ib_env_res", width = 12)
                                         ),
                                         column(width = 4, "")
                                )
                        ),
                        tabItem("grupos", h1("Posiciones"),
                                fluidRow(
                                  box(title = "Grupo A", status = "primary", solidHeader = T, width = 6,
                                      tableOutput("g1"),  align = "center"),
                                  box(title = "Grupo B", status = "success", solidHeader = T, width = 6,
                                      tableOutput("g2"),  align = "center"),
                                  box(title = "Grupo C", status = "warning", solidHeader = T, width = 6,
                                      tableOutput("g3"),  align = "center"),
                                  box(title = "Grupo D", status = "danger", solidHeader = T, width = 6,
                                      tableOutput("g4"),  align = "center"),
                                  box(title = "Grupo E", status = "primary", solidHeader = T, width = 6,
                                      tableOutput("g5"),  align = "center"),
                                  box(title = "Grupo F", status = "success", solidHeader = T, width = 6,
                                      tableOutput("g6"),  align = "center"),
                                  box(title = "Grupo G", status = "warning", solidHeader = T, width = 6,
                                      tableOutput("g7"),  align = "center"),
                                  box(title = "Grupo H", status = "danger", solidHeader = T, width = 6,
                                      tableOutput("g8"),  align = "center")
                                )    
                        ),
                        tabItem("puntaje", h1("Puntaje"),
                                
                                selectizeInput("liga1", label = NULL, choices = "",
                                               multiple = F,
                                               options = list(placeholder = "...", 
                                                              onInitialize = I('function() { this.setValue("");}'))),
                                box(title = "Puntaje por jugador", status = "danger", solidHeader = T, plotOutput("gra_jug_pun")),
                                box(title = "Equipos más votados", status = "warning", solidHeader = T, plotOutput("bolitas"))

                                

                        )
                        # # downloadButton("descarga", label = "Su resultado",
                        # #                class = "btn-block"),
                        
                      )
                    )
)

# incluir link a https://www.glyphicons.com/

