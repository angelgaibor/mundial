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

source("ui_sr/ui_01_info.R", local = T)
source("ui_sr/ui_02_juega_fase_grupos.R", local = T)
source("ui_sr/ui_03_res_grupos.R", local = T)
source("ui_sr/ui_04_res_elim_directa.R", local = T)
source("ui_sr/ui_05_puntaje.R", local = T)
source("ui_sr/ui_06_juega_octavos.R", local = T)
source("ui_sr/ui_07_juega_cuartos.R", local = T)
source("ui_sr/ui_08_juega_semis.R", local = T)
 source("ui_sr/ui_09_juega_final.R", local = T)

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
                                                          menuSubItem("Octavos de final", tabName = "juega_octavos"),
                                                          menuSubItem("Cuartos de final", tabName = "juega_cuartos"),
                                                          menuSubItem("Semifinales", tabName = "juega_semis"),
                                                          menuSubItem("Finales", tabName = "juega_final")
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
                        ui_info,
                        ui_juega_fase_grupos,
                        ui_res_grupos,
                        ui_res_elim_directa,
                        ui_puntaje,
                        ui_juega_octavos,
                        ui_juega_cuartos,
                        ui_juega_semis,
                        ui_juega_final
                      )
                    )
)


