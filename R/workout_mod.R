workout_ui <- function(id) {
  shinyMobile::f7Card(
    shinyWidgets::actionBttn(
      inputId = shiny::NS(id, "add_workout_btn"),
      label = "Add your workout",
      color = "royal",
      size = "lg"
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
              shinyWidgets::pickerInput(
                inputId = "workout_type",
                label = "Choose your workout",
                choices = app_config[["workout_types"]]
              ),
              shiny::numericInput(
                inputId = "additional_weight",
                label = "Additional weight?",
                value = 0
              ),
              shinyWidgets::pickerInput(
                inputId = "resistance_band",
                label = "Using resistance band",
                choices = c("no", "light", "medium", "hard")
              )
            )
          )
        }
      )
    }
  )
}