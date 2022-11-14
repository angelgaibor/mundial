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


ui <- dashboardPage(skin="purple",
                    
                    dashboardHeader(title = "Consistencia base de campo ENDI - GDM", titleWidth = 480
                    ),
                    
                    # panel lateral
                    dashboardSidebar(width = 360,
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
                                fluidRow(infoBox(title = "Fecha de corte", value = 1,icon = icon("calendar")),
                                         infoBoxOutput("ib_equ_com"))),
                        tabItem("juega", h1("Sexo y fecha"),
                                textInput("nombre", "Ingresa tu nombre", value = "..."),
                                fluidRow(
                                  box(title = "Grupo A", status = "primary", solidHeader = T, width = 3,
                                             selectizeInput("a1", label = NULL, equipos$Siglas[equipos$Grupo=="A"], 
                                                            multiple = F, 
                                                            options = list(placeholder = "Primero...", 
                                                                           onInitialize = I('function() { this.setValue("");}'))),
                                             selectizeInput("a2", label = NULL, equipos$Siglas[equipos$Grupo=="A"], 
                                                            multiple = F, 
                                                            options = list(placeholder = "Segundo...", 
                                                                           onInitialize = I('function() { this.setValue("");}')))
                                      ),
                                  box(title = "Grupo B", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("b1", label = NULL, equipos$Siglas[equipos$Grupo=="B"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("b2", label = NULL, equipos$Siglas[equipos$Grupo=="B"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo C", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("c1", label = NULL, equipos$Siglas[equipos$Grupo=="C"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("c2", label = NULL, equipos$Siglas[equipos$Grupo=="C"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo D", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("d1", label = NULL, equipos$Siglas[equipos$Grupo=="D"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("d2", label = NULL, equipos$Siglas[equipos$Grupo=="D"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo E", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("e1", label = NULL, equipos$Siglas[equipos$Grupo=="E"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("e2", label = NULL, equipos$Siglas[equipos$Grupo=="E"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo F", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("f1", label = NULL, equipos$Siglas[equipos$Grupo=="F"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("f2", label = NULL, equipos$Siglas[equipos$Grupo=="F"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo G", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("g1", label = NULL, equipos$Siglas[equipos$Grupo=="G"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("g2", label = NULL, equipos$Siglas[equipos$Grupo=="G"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  ),
                                  box(title = "Grupo H", status = "primary", solidHeader = T, width = 3,
                                      selectizeInput("h1", label = NULL, equipos$Siglas[equipos$Grupo=="H"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Primero...", 
                                                                    onInitialize = I('function() { this.setValue("");}'))),
                                      selectizeInput("h2", label = NULL, equipos$Siglas[equipos$Grupo=="H"], 
                                                     multiple = F, 
                                                     options = list(placeholder = "Segundo...", 
                                                                    onInitialize = I('function() { this.setValue("");}')))
                                  )
                                )
                                ,
                                downloadButton("descarga", label = "Su resultado",
                                               class = "btn-block")
                        )
                      )
                    )
)

# incluir link a https://www.glyphicons.com/

