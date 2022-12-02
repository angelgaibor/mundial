#
ui_res_grupos <-
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
  )