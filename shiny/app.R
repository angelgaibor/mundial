#
rm(list=ls())
#

#
# Run the application

#
app <- shinyAppDir("./shiny/", options = list())

#runApp(app)
runGadget(app, viewer = dialogViewer("Hola bebé", width = 3000, height = 3000))
runGadget(app, viewer = paneViewer(minHeight = 600))
runGadget(app, viewer = browserViewer(browser = getOption("browser")))

