#
ui_res_elim_directa <-
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
  )