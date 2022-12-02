#
ui_info <- 
  tabItem("info", 
          fluidRow(column(width = 12, valueBoxOutput("tiempo", width = 12)),
                   column(width = 6,
                          box(title = "Mundial Qatar 2022", status = "danger", solidHeader = T, width = 12,
                              "Esto copiamos de Wikipedia: La Copa Mundial de Fútbol de la FIFA Catar 2022
                              (en árabe, كأس العالم لكرة القدم قطر 2022) será la XXII edición de la Copa Mundial de
                              Fútbol masculino organizada por la FIFA. Se desarrollará desde el 20 de noviembre al
                              18 de diciembre en Catar, que consiguió los derechos de organización el 2 de diciembre
                              de 2010.",
                              br(), br(),
                              "PD. En Ecuador no va jugar el Kitu :(",
                              br()),
                          box(title = "Reglas del juego", status = "danger", solidHeader = T, width = 12,
                              strong("Fase de grupos:"), br(),
                              "- En la pestaña Juega conmigo, ingresa tu nombre y liga.", br(),
                              "- Luego, selecciona el primer y segundo equipo de cada grupo.",br(),
                              "- Para enviar tus pronósticos da click en el botón ", strong("Envía tu pronóstico"), ".",br(),
                              "- Se visualizará un código el cual debes guardar para validar tus resultados.",br(),
                              br(),
                              strong("Fases de eliminación directa:"), br(),
                              "- Introduce los marcadores de los partidos de octavos de final.", br(),
                              "- Si tu pronóstico es empate, aparecerán dos casillas más para los penales.", br(),
                              "- Podrás ver los cruces de la siguiente fase de acuerdo a tu predicción.", br(),
                              "- Antes de enviar tus resultados deberás introducir el código asociado a tu jugador y liga de la fase de grupos.", br(),
                              "- Para enviar tus pronósticos da click en el botón ", strong("Envía tu pronóstico"), ".",br(),
                          ),
                          box(title = "Sistema de puntos", status = "danger", solidHeader = T, width = 12,
                              strong("Fase de grupos:"), br(),
                              "- Por cada equipo clasificado a octavos de final recibes ", strong("1 punto"), ".", br(),
                              "- Además, si aciertas a la posición de clasificación de tu equipo recibes ", strong("1 punto extra"), ".", br(),
                              br(),
                              strong("Fases de eliminación directa:"),br(),
                              "- Si aciertas al ganador de la llave recibes ", strong("1 punto"), ".", br(),
                              "- Además, si aciertas a la diferencia de goles recibes ", strong("1 punto extra"), ".", br(),
                              "- Por ultimo, si aciertas el marcador exacto recibirás ", strong("2 puntos extra"), ".", br(),
                              "- En el caso de que tu pronóstico sea un empate, el marcado exacto será determinado por los goles y los penales 
                                                  decidirán el ganador de la llave.", br(),
                              "- Los puntos ganados en semifinales y finales ", strong("valdrán el doble"), ". Es una ganga...!!!", br(),
                              br(),
                              strong("Criterios de desempate:"), br(),
                              "- Mayor número de aciertos en la posición de los equipos en la fase de grupos,", br(), 
                              "- Mayor número de aciertos a resultados exactos en las fases de eliminación directa,", br(),
                              "- Número de clasificados acertados en cada fase.",
                              br(), br(),
                              strong("Nota:"), br(),
                              "Si perdiste tu código contacta a los administradores (javier.ns87@gmail.com y/o angleito2112@gmail.com).",
                          )
                   ),
                   column(width = 6, img(src = "logo.jpg", style = "width:336px"), align = "center")
          )
  )