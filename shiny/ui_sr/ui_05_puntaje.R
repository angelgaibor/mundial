#
ui_puntaje <-
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
          
          
          
  )