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
            html = TRUE,
            text = tagList(
              shiny::selectInput(
                inputId = "workout_type",
                label = "Choose your workout",
                choices = app_config[["workout_types"]]
              )
            )
          )
        }
      )
    }
  )
}