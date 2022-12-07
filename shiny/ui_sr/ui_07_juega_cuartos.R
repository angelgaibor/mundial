#
ui_juega_cuartos <-
  tabItem("juega_cuartos",
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
                          valueBox(value = "Cuartos de final", color = "red", subtitle = NULL, width = 12),
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
                                textOutput("c11")),
                            div(class = "container-items",
                                span(textInput("gc11", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("pc11"))),
                            div(class = "container-items",
                                span(uiOutput("pc12"))),
                            div(class = "container-items",
                                span(textInput("gc12", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("c12")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("c21")),
                            div(class = "container-items",
                                span(textInput("gc21", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("pc21"))),
                            div(class = "container-items",
                                span(uiOutput("pc22"))),
                            div(class = "container-items",
                                span(textInput("gc22", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("c22")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("c31")),
                            div(class = "container-items",
                                span(textInput("gc31", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("pc31"))),
                            div(class = "container-items",
                                span(uiOutput("pc32"))),
                            div(class = "container-items",
                                span(textInput("gc32", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("c32")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("c41")),
                            div(class = "container-items",
                                span(textInput("gc41", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("pc41"))),
                            div(class = "container-items",
                                span(uiOutput("pc42"))),
                            div(class = "container-items",
                                span(textInput("gc42", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("c42")))
                          )
                   )
          ),
          fluidRow(width = 12,
                   column(width = 1),
                   column(width = 4, align = "center",
                          valueBox(value = "Tu predicción:", color = "yellow", subtitle = NULL, width = 12),
                          box(width = 12, tableOutput("tabla_semis")),
                          textInput("codigo_cuartos", label = "Ingresa el código de participación", value = "",
                                    width = "168px", placeholder = "Ejemplo: 1K1u5M"),
                          infoBoxOutput("ib_cod_cua", width = 12),
                          actionButton("pro_cua", "Envía tu pronóstico"),
                          br(),
                          valueBoxOutput("vb_conf_cua", width = 12)
                   ),
                   column(width = 1)
          )
  )