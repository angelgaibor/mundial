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

ui <- dashboardPage(skin="black",
                    
                    dashboardHeader(title = "Polla mundialista CGB - Fase de Grupos", titleWidth = 480
                    ),
                    
                    # panel lateral
                    dashboardSidebar(width = 240,
                                     sidebarMenu(menuItem("Juega conmigo", startExpanded = T,
                                                          icon = icon("screenshot", lib = "glyphicon"),
                                                          menuSubItem("¿Cómo jugar?", tabName = "info", selected = T),
                                                          menuSubItem("Fase de grupos", tabName = "juega_grupos"),
                                                          menuSubItem("Octavos de final", tabName = "juega_octavos")
                                                          # menuSubItem("Octavos de final", tabName = "juega_cuartos"),
                                                          # menuSubItem("Octavos de final", tabName = "juega_semis")
                                     ),
                                     menuItem("Resultados Qatar 2022",
                                              icon = icon("tasks", lib = "glyphicon"),
                                              menuSubItem("Fase de grupos", tabName = "res_grupos"),
                                              menuSubItem("Fase final", tabName = "res_elim_directa")),
                                     menuItem("Puntaje", tabName = "puntaje",
                                              icon = icon("signal", lib = "glyphicon"))
                                     )
                    ),
                    
                    # cuerpo
                    dashboardBody(
                      tabItems(
                        tabItem("info", 
                                fluidRow(column(width = 12, valueBoxOutput("tiempo", width = 12)),
                                         column(width = 6,
                                                box(title = "Mundial Qatar 2022", status = "danger", solidHeader = T, width = 12,
                                                    "Esto copiamos de Wikipedia: La Copa Mundial de Fútbol de la FIFA Catar 2022
                                           (en árabe, كأس العالم لكرة القدم قطر 2022) será la XXII edición de la Copa Mundial de
                                           Fútbol masculino organizada por la FIFA. Se desarrollará desde el 20 de noviembre al
                                           18 de diciembre en Catar, que consiguió los derechos de organización el 2 de diciembre
                                          de 2010.",
                                                    br(), br(),
                                                    "PD. En Ecuador no va jugar el Kitu :(",
                                                    br()),
                                                box(title = "Reglas del juego", status = "danger", solidHeader = T, width = 12,
                                                    strong("Fase de grupos:"), br(),
                                                    "- En la pestaña Juega conmigo, ingresa tu nombre y liga.", br(),
                                                    "- Luego, selecciona el primer y segundo equipo de cada grupo.",br(),
                                                    "- Para enviar tus pronósticos da click en el botón ", strong("Envía tu pronóstico"), ".",br(),
                                                    "- Se visualizará un código el cual debes guardar para validar tus resultados.",br(),
                                                    br(),
                                                    strong("Fases de eliminación directa:"), br(),
                                                    "- Introduce los marcadores de los partidos de octavos de final.", br(),
                                                    "- Si tu pronóstico es empate, aparecerán dos casillas más para los penales.", br(),
                                                    "- Podrás ver los cruces de la siguiente fase de acuerdo a tu predicción.", br(),
                                                    "- Antes de enviar tus resultados deberás introducir el código asociado a tu jugador y liga de la fase de grupos.", br(),
                                                    "- Para enviar tus pronósticos da click en el botón ", strong("Envía tu pronóstico"), ".",br(),
                                                ),
                                                box(title = "Sistema de puntos", status = "danger", solidHeader = T, width = 12,
                                                    strong("Fase de grupos:"), br(),
                                                    "- Por cada equipo clasificado a octavos de final recibes ", strong("1 punto"), ".", br(),
                                                    "- Además, si aciertas a la posición de clasificación de tu equipo recibes ", strong("1 punto extra"), ".", br(),
                                                    br(),
                                                    strong("Fases de eliminación directa:"),br(),
                                                    "- Si aciertas al ganador de la llave recibes ", strong("1 punto"), ".", br(),
                                                    "- Además, si aciertas a la diferencia de goles recibes ", strong("1 punto extra"), ".", br(),
                                                    "- Por ultimo, si aciertas el marcador exacto recibirás ", strong("2 puntos extra"), ".", br(),
                                                    "- En el caso de que tu pronóstico sea un empate, el marcado exacto será determinado por los goles y los penales 
                                                  decidirán el ganador de la llave.", br(),
                                                    "- Los puntos ganados en semifinales y finales ", strong("valdrán el doble"), ". Es una ganga...!!!", br(),
                                                    br(),
                                                    strong("Criterios de desempate:"), br(),
                                                    "- Mayor número de aciertos en la posición de los equipos en la fase de grupos,", br(), 
                                                    "- Mayor número de aciertos a resultados exactos en las fases de eliminación directa,", br(),
                                                    "- Número de clasificados acertados en cada fase.",
                                                    br(), br(),
                                                    strong("Nota:"), br(),
                                                    "Si perdiste tu código contacta a los administradores (javier.ns87@gmail.com y/o angleito2112@gmail.com).",
                                                )
                                         ),
                                         column(width = 6, img(src = "logo.jpg", style = "width:336px"), align = "center")
                                )
                        ),
                        tabItem("juega_grupos", h1("Ingresa tu predicción"),
                                fluidRow(
                                  column(width = 12,
                                         textInput("nombre", "Ingresa tu nombre/apodo", value = "..."),
                                         selectizeInput("liga", label = NULL, choices = "",
                                                        multiple = F,
                                                        options = list(placeholder = "...", 
                                                                       onInitialize = I('function() { this.setValue("");}')))
                                  )
                                ),
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
                                  box(title = "Grupo B", status = "success", solidHeader = T, width = 3,
                                      selectizeInput("b1", label = NULL, equipos$Equipo[equipos$Grupo=="B"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("b2", label = NULL, equipos$Equipo[equipos$Grupo=="B"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo C", status = "warning", solidHeader = T, width = 3,
                                      selectizeInput("c1", label = NULL, equipos$Equipo[equipos$Grupo=="C"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("c2", label = NULL, equipos$Equipo[equipos$Grupo=="C"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo D", status = "danger", solidHeader = T, width = 3,
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
                                  box(title = "Grupo F", status = "success", solidHeader = T, width = 3,
                                      selectizeInput("f1", label = NULL, equipos$Equipo[equipos$Grupo=="F"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("f2", label = NULL, equipos$Equipo[equipos$Grupo=="F"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo G", status = "warning", solidHeader = T, width = 3,
                                      selectizeInput("g1", label = NULL, equipos$Equipo[equipos$Grupo=="G"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("g2", label = NULL, equipos$Equipo[equipos$Grupo=="G"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo H", status = "danger", solidHeader = T, width = 3,
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
                        tabItem("res_grupos",
                                fluidRow(width = 12,
                                         box(title = "Grupo A", status = "primary", solidHeader = T, width = 3,
                                             tableOutput("g1"),  align = "center"),
                                         box(title = "Grupo B", status = "success", solidHeader = T, width = 3,
                                             tableOutput("g2"),  align = "center"),
                                         box(title = "Grupo C", status = "warning", solidHeader = T, width = 3,
                                             tableOutput("g3"),  align = "center"),
                                         box(title = "Grupo D", status = "danger", solidHeader = T, width = 3,
                                             tableOutput("g4"),  align = "center"),
                                         box(title = "Grupo E", status = "primary", solidHeader = T, width = 3,
                                             tableOutput("g5"),  align = "center"),
                                         box(title = "Grupo F", status = "success", solidHeader = T, width = 3,
                                             tableOutput("g6"),  align = "center"),
                                         box(title = "Grupo G", status = "warning", solidHeader = T, width = 3,
                                             tableOutput("g7"),  align = "center"),
                                         box(title = "Grupo H", status = "danger", solidHeader = T, width = 3,
                                             tableOutput("g8"),  align = "center")
                                )    
                        ),
                        tabItem("res_elim_directa",
                                fluidRow(width = 12,
                                         column(width = 3, align = "center",
                                                valueBox(value = "Octavos de final", color = "blue", subtitle = NULL, width = 12),
                                                box(title = NULL, status = "primary", solidHeader = T, width = 12,
                                                    tableOutput("res_octavos"),  align = "center")
                                                
                                         ),
                                         column(width = 3, align = "center",
                                                valueBox(value = "Cuartos de final", color = "green", subtitle = NULL, width = 12),
                                                box(title = NULL, status = "success", solidHeader = T, width = 12,
                                                    tableOutput("res_cuartos"),  align = "center")
                                         ),
                                         column(width = 3, align = "center",
                                                valueBox(value = "Semifinales", color = "yellow", subtitle = NULL, width = 12),
                                                box(title = NULL, status = "warning", solidHeader = T, width = 12,
                                                    tableOutput("res_semis"),  align = "center")
                                         ),
                                         column(width = 3, align = "center",
                                                valueBox(value = "Final", color = "red", subtitle = NULL, width = 12),
                                                box(title = NULL, status = "danger", solidHeader = T, width = 12,
                                                    tableOutput("res_tercero"),  align = "center"),
                                                box(title = NULL, status = "danger", solidHeader = T, width = 12,
                                                    tableOutput("res_campeon"),  align = "center")
                                         )
                                )
                        ),
                        tabItem("puntaje", # h1("Puntaje"),
                                
                                selectizeInput("liga1", label = NULL, choices = "",
                                               multiple = F,
                                               options = list(placeholder = "...", 
                                                              onInitialize = I('function() { this.setValue("");}'))),
                                box(title = "Puntaje por jugador", status = "danger", solidHeader = T, plotOutput("gra_jug_pun")),
                                selectizeInput("jugador1", label = NULL, choices = "",
                                               multiple = F,
                                               options = list(placeholder = "...", 
                                                              onInitialize = I('function() { this.setValue("");}'))),
                                box(title = "Equipos más votados", status = "warning", solidHeader = T, plotOutput("bolitas")),
                                box(title = NULL, status = "warning", solidHeader = F, "Equipos más votados: mientras más grande la bolita más gente
                          votó por ese equipo en esa posición.")
                                
                                
                                
                        ),
                        tabItem("juega_octavos",
                                tags$style(
                                  ".container {
                          display: flex;
                          justify-content: space-around;
                          border-color: #666666;
                          background-color: #fff;
                          border-style: solid;
                          border-width: thin;
                          border-radius: 3px;
                          text-align: center;
                          margin: 14px;
                          min-height: 48px;
                          width: 336px;
                          }
                          .container-items {
                          width: 40px;
                          height: 34px;
                          margin: 7px;
                          text-align: center;
                          font-size: 18px;
                          vertical-align: baseline;
                          }
                          "
                                ),
                                fluidRow(width = 12,
                                         column(width = 6, align = "center",
                                                valueBox(value = "Octavos de final", color = "red", subtitle = NULL, width = 12),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      strong("Loc")),
                                                  div(class = "container-items",
                                                      strong("Gol")),
                                                  div(class = "container-items",
                                                      strong("Pen")),
                                                  div(class = "container-items",
                                                      strong("Pen")),
                                                  div(class = "container-items",
                                                      strong("Gol")),
                                                  div(class = "container-items",
                                                      strong("Vis"))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("nga1")),
                                                  div(class = "container-items",
                                                      span(textInput("go11", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po11"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po12"))),
                                                  div(class = "container-items",
                                                      span(textInput("go12", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("ngb2")))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("ngc1")),
                                                  div(class = "container-items",
                                                      span(textInput("go21", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po21"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po22"))),
                                                  div(class = "container-items",
                                                      span(textInput("go22", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("ngd2")))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("nge1")),
                                                  div(class = "container-items",
                                                      span(textInput("go31", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po31"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po32"))),
                                                  div(class = "container-items",
                                                      span(textInput("go32", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("ngf2")))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("ngg1")),
                                                  div(class = "container-items",
                                                      span(textInput("go41", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po41"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po42"))),
                                                  div(class = "container-items",
                                                      span(textInput("go42", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("ngh2")))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("ngb1")),
                                                  div(class = "container-items",
                                                      span(textInput("go51", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po51"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po52"))),
                                                  div(class = "container-items",
                                                      span(textInput("go52", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("nga2")))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("ngd1")),
                                                  div(class = "container-items",
                                                      span(textInput("go61", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po61"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po62"))),
                                                  div(class = "container-items",
                                                      span(textInput("go62", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("ngc2")))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("ngf1")),
                                                  div(class = "container-items",
                                                      span(textInput("go71", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po71"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po72"))),
                                                  div(class = "container-items",
                                                      span(textInput("go72", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("nge2")))
                                                ),
                                                div(
                                                  class = "container",
                                                  div(class = "container-items",
                                                      textOutput("ngh1")),
                                                  div(class = "container-items",
                                                      span(textInput("go81", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po81"))),
                                                  div(class = "container-items",
                                                      span(uiOutput("po82"))),
                                                  div(class = "container-items",
                                                      span(textInput("go82", label = NULL, value = "", width = "36px"))),
                                                  div(class = "container-items",
                                                      span(textOutput("ngg2")))
                                                )
                                         )
                                ),
                                fluidRow(width = 12,
                                         column(width = 1),
                                         column(width = 4, align = "center",
                                                valueBox(value = "Tu predicción:", color = "yellow", subtitle = NULL, width = 12),
                                                box(width = 12, tableOutput("tabla_cuartos")),
                                                textInput("codigo_octavos", label = "Ingresa el código de participación", value = "",
                                                          width = "168px", placeholder = "Ejemplo: 1K1u5M"),
                                                infoBoxOutput("ib_cod_oct", width = 12)
                                                #,
                                                #actionButton("pro_oct", "Envía tu pronóstico")
                                         ),
                                         column(width = 1)
                                )
                        )
                      )
                    )
)

                    
# incluir link a https://www.glyphicons.com/

