#
ui_juega_octavos <-
  tabItem("juega_octavos",
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
                          valueBox(value = "Octavos de final", color = "red", subtitle = NULL, width = 12),
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
                                textOutput("nga1")),
                            div(class = "container-items",
                                span(textInput("go11", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po11"))),
                            div(class = "container-items",
                                span(uiOutput("po12"))),
                            div(class = "container-items",
                                span(textInput("go12", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("ngb2")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("ngc1")),
                            div(class = "container-items",
                                span(textInput("go21", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po21"))),
                            div(class = "container-items",
                                span(uiOutput("po22"))),
                            div(class = "container-items",
                                span(textInput("go22", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("ngd2")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("nge1")),
                            div(class = "container-items",
                                span(textInput("go31", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po31"))),
                            div(class = "container-items",
                                span(uiOutput("po32"))),
                            div(class = "container-items",
                                span(textInput("go32", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("ngf2")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("ngg1")),
                            div(class = "container-items",
                                span(textInput("go41", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po41"))),
                            div(class = "container-items",
                                span(uiOutput("po42"))),
                            div(class = "container-items",
                                span(textInput("go42", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("ngh2")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("ngb1")),
                            div(class = "container-items",
                                span(textInput("go51", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po51"))),
                            div(class = "container-items",
                                span(uiOutput("po52"))),
                            div(class = "container-items",
                                span(textInput("go52", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("nga2")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("ngd1")),
                            div(class = "container-items",
                                span(textInput("go61", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po61"))),
                            div(class = "container-items",
                                span(uiOutput("po62"))),
                            div(class = "container-items",
                                span(textInput("go62", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("ngc2")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("ngf1")),
                            div(class = "container-items",
                                span(textInput("go71", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po71"))),
                            div(class = "container-items",
                                span(uiOutput("po72"))),
                            div(class = "container-items",
                                span(textInput("go72", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("nge2")))
                          ),
                          div(
                            class = "container",
                            div(class = "container-items",
                                textOutput("ngh1")),
                            div(class = "container-items",
                                span(textInput("go81", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(uiOutput("po81"))),
                            div(class = "container-items",
                                span(uiOutput("po82"))),
                            div(class = "container-items",
                                span(textInput("go82", label = NULL, value = "", width = "36px"))),
                            div(class = "container-items",
                                span(textOutput("ngg2")))
                          )
                   )
          ),
          fluidRow(width = 12,
                   column(width = 1),
                   column(width = 4, align = "center",
                          valueBox(value = "Tu predicción:", color = "yellow", subtitle = NULL, width = 12),
                          box(width = 12, tableOutput("tabla_cuartos")),
                          textInput("codigo_octavos", label = "Ingresa el código de participación", value = "",
                                    width = "168px", placeholder = "Ejemplo: 1K1u5M"),
                          infoBoxOutput("ib_cod_oct", width = 12),
                          actionButton("pro_oct", "Envía tu pronóstico")
                   ),
                   column(width = 1)
          )
  )