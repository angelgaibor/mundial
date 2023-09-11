#
ui_juega_final <-
  tabItem("juega_final",
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
                          valueBox(value = "Tercer Lugar", color = "red", subtitle = NULL, width = 12),
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
                                textOutput("t1")),
                            div(class = "container-items",
                                span(textInput("gt1", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("pt1"))),
                            div(class = "container-items",
                                span(uiOutput("pt2"))),
                            div(class = "container-items",
                                span(textInput("gt2", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("t2")))
                          )
                   ),
                   column(width = 6, align = "center",
                          valueBox(value = "Final", color = "red", subtitle = NULL, width = 12),
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
                                textOutput("f1")),
                            div(class = "container-items",
                                span(textInput("gf1", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("pf1"))),
                            div(class = "container-items",
                                span(uiOutput("pf2"))),
                            div(class = "container-items",
                                span(textInput("gf2", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("f2")))
                          )
                   )
          ),
          fluidRow(width = 12,
                   column(width = 1),
                   column(width = 4, align = "center",
                          valueBox(value = "Tu predicción:", color = "yellow", subtitle = NULL, width = 12),
                          box(width = 12, tableOutput("tabla_campeones")),
                          textInput("codigo_final", label = "Ingresa el código de participación", value = "",
                                    width = "168px", placeholder = "Ejemplo: 1K1u5M"),
                          infoBoxOutput("ib_cod_fin", width = 12),
                          # actionButton("pro_fin", "Envía tu pronóstico"),
                          br(), br(),
                          valueBoxOutput("vb_conf_fin", width = 12)
                   ),
                   column(width = 1)
          )
  )