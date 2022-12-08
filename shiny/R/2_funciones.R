#
# agregar prediccion
agrega_prediccion <- function(data, gs4 = TRUE) {
  
  if (gs4) {
    sheet_append(resultados, data, "predicciones")
    sum_data <- read_sheet(resultados, "predicciones")
  } else {
    old_data <- read.xlsx("data/resultados.xlsx", "predicciones")
    sum_data <- bind_rows(old_data, data)
    write.xlsx(sum_data, "data/resultados.xlsx", "predicciones")
  }
  
  sum_data
}

# agregar prediccion octavos
agrega_prediccion_octavos <- function(data_oct, gs4 = TRUE) {
  
  if (gs4) {
    sheet_append(pre_oct, data_oct, "pre_oct")
    cum_data <- read_sheet(pre_oct, "pre_oct")
  } else {
    old_data <- read.xlsx("data/predicciones_octavos.xlsx", "Hoja1")
    cum_data <- bind_rows(old_data, data_oct)
    write.xlsx(cum_data, "data/predicciones_octavos.xlsx", "Hoja1")
  }
  
  cum_data
}

# agregar prediccion cuartos
agrega_prediccion_cuartos <- function(data_cua, gs4 = TRUE) {
  
  if (gs4) {
    sheet_append(pre_cua, data_cua, "pre_cua")
    cum_data <- read_sheet(pre_cua, "pre_cua")
  } else {
    old_data <- read.xlsx("data/predicciones_cuartos.xlsx", "Hoja1")
    cum_data <- bind_rows(old_data, data_oct)
    write.xlsx(cum_data, "data/predicciones_cuartos.xlsx", "Hoja1")
  }
  
  cum_data
}

# agregar prediccion semis
agrega_prediccion_semis <- function(data_sem, gs4 = TRUE) {
  
  if (gs4) {
    sheet_append(pre_sem, data_sem, "pre_cua")
    cum_data <- read_sheet(pre_sem, "pre_cua")
  } else {
    old_data <- read.xlsx("data/predicciones_semis.xlsx", "Hoja1")
    cum_data <- bind_rows(old_data, data_oct)
    write.xlsx(cum_data, "data/predicciones_semis.xlsx", "Hoja1")
  }
  
  cum_data
}
