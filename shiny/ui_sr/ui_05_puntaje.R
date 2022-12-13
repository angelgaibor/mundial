#
ui_puntaje <-
  tabItem("puntaje",
          selectizeInput("liga1", label = NULL, choices = "",
                         multiple = F,
                         options = list(placeholder = "...", 
                                        onInitialize = I('function() { this.setValue("");}'))),
          box(title = "Puntaje por jugador", status = "danger", solidHeader = T, plotOutput("gra_jug_pun")),
          box(title = NULL, status = "danger", solidHeader = F, "Puntaje (oscuro a claro): Fase de grupos - Octavos de final -
                     Cuartos de final - Semifinal - Final"),
          selectizeInput("jugador1", label = NULL, choices = "",
                         multiple = F,
                         options = list(placeholder = "...", 
                                        onInitialize = I('function() { this.setValue("");}'))),
          box(title = "Equipos más votados", status = "warning", solidHeader = T, plotOutput("bolitas")),
          box(title = NULL, status = "warning", solidHeader = F, "Equipos más votados: mientras más grande la bolita más gente
                     votó por ese equipo en esa posición.")
          
  )