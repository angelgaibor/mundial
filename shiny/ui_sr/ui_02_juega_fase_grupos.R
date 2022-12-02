#
ui_juega_fase_grupos <- 
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
  )