library(shiny)
library(shinyMobile)

workout_app <- function() {
  ui <- shinyMobile::f7Page(
    title = "Workout App",
    shinyMobile::f7SingleLayout(
      navbar = shinyMobile::f7Navbar(
        title = "Workout App"
      ),
      workout_ui(
        id = "workout"
      )
    )
  )

server <- function(input, output, session) {
    workout_server(
      id = "workout"
    )
}

shiny::shinyApp(ui, server)
}
