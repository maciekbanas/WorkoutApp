library(shiny)
library(shinyMobile)

ui <- shinyMobile::f7Page(
  title = "Calisthenics App",
  shinyMobile::f7SingleLayout(
    navbar = shinyMobile::f7Navbar(
      title = "Measure your progress"
    ),
    shinyMobile::f7Card(
      shiny::actionButton(
        "add_workout_btn",
        "Add your workout"
      )
    )
  )
)

server <- function(input, output, session) {
  
}

shiny::shinyApp(ui, server)