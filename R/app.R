library(shiny)
library(shinyMobile)

workout_app <- function(){
  ui <- shinyMobile::f7Page(
    title = "Calisthenics App",
    shinyMobile::f7SingleLayout(
      navbar = shinyMobile::f7Navbar(
        title = "Measure your progress"
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
