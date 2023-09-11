#
ui_juega_semis <-
  tabItem("juega_semis",
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
                          valueBox(value = "Semifinales", color = "red", subtitle = NULL, width = 12),
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
                                textOutput("s11")),
                            div(class = "container-items",
                                span(textInput("gs11", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("ps11"))),
                            div(class = "container-items",
                                span(uiOutput("ps12"))),
                            div(class = "container-items",
                                span(textInput("gs12", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("s12")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("s21")),
                            div(class = "container-items",
                                span(textInput("gs21", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("ps21"))),
                            div(class = "container-items",
                                span(uiOutput("ps22"))),
                            div(class = "container-items",
                                span(textInput("gs22", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("s22")))
                          )
                   )
          ),
          fluidRow(width = 12,
                   column(width = 1),
                   column(width = 4, align = "center",
                          valueBox(value = "Tu predicción:", color = "yellow", subtitle = NULL, width = 12),
                          box(width = 12, tableOutput("tabla_final")),
                          textInput("codigo_semis", label = "Ingresa el código de participación", value = "",
                                    width = "168px", placeholder = "Ejemplo: 1K1u5M"),
                          infoBoxOutput("ib_cod_sem", width = 12),
                          # actionButton("pro_sem", "Envía tu pronóstico"),
                          br(), br(),
                          valueBoxOutput("vb_conf_sem", width = 12)
                   ),
                   column(width = 1)
          )
  )