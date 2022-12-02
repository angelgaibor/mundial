#
# Define server logic required to draw a histogram
#
source("R/1_global.R",local = T)

# verifica si estamos usando googlesheets
USING_GS4 <- "googlesheets4" %in% (.packages()) && gs4_has_token()

# autorizacion en google sheet
gs4_auth(cache = ".secrets", email = "endi.dm.inec@gmail.com")

server <- function(input, output, session){
  
  # reactive values
  v <- reactiveValues()
  v_o <- reactiveValues()
  
  # Inicialización de objetos
  v$guardado <- F
  v_o$guardado <- F
  
  dato <- data.frame(
    Siglas = character(0),
    Equipo = character(0),
    Grupo	= character(0),
    Prediccion = double(0),
    Liga = character(0),
    Jugador = character(0),
    Codigo = character(0))
  
  # server tab info
  source("ui_sr/sr_01_info.R", local = T)
  
  # server tab: juega conmigo - fase de grupos
  source("ui_sr/sr_02_juega_fase_grupos.R", local = T)
  
  # server tab: resultados eliminación directa
  source("ui_sr/sr_06_juega_octavos.R", local = T)
  
  # server tab: resultados fase de grupos
  source("ui_sr/sr_03_res_grupos.R", local = T)
  
  # server tab: resultados fase de grupos
  source("ui_sr/sr_04_res_elim_directa.R", local = T)
  
  # server tab: puntaje
  source("ui_sr/sr_05_puntaje.R", local = T)
  
}


