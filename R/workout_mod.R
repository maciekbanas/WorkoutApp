workout_ui <- function(id) {
  shinyMobile::f7Card(
    shiny::actionButton(
      shiny::NS(id, "add_workout_btn"),
      "Add your workout"
    )
  )
}

workout_server <- function(id) {
  moduleServer(
    id = id,
    module = function(input, output, session) {
      shiny::observeEvent(input$add_workout_btn, {
          shinyalert::shinyalert(
            title = "What is your workout?",
            text = "Choose type of your workout",
            type = "input"
          )
        }
      )
    }
  )
}