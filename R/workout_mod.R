workout_ui <- function(id) {
  ns <- shiny::NS(id)
  shinyMobile::f7Card(
    shinyWidgets::actionBttn(
      inputId = ns("add_workout_btn"),
      label = "Add your workout",
      color = "royal",
      size = "lg"
    ),
    shiny::uiOutput(ns("workout_output"))
  )
}

workout_server <- function(id) {
  ns <- shiny::NS(id)
  shiny::moduleServer(
    id = id,
    module = function(input, output, session) {
      series_number <- shiny::reactiveVal(0)
      workout_data <- shiny::reactiveValues(
        type = "",
        reps = c()
      )

      add_series <- function(reps_no) {
        workout_data[["reps"]] <- c(workout_data$reps, reps_no)
      }

      finish_and_save_workout <- function() {
        workout_data[["type"]] <- input$workout_type
        output$workout_output <- shiny::renderText({
          paste0(workout_data[["type"]],
                 ": ",
                 paste0(workout_data[["reps"]], collapse = ", "))
        })
      }

      show_series_window <- function() {
        shinyalert::shinyalert(
          title = paste("Series", series_number()),
          html = TRUE,
          text = shiny::numericInput(
            inputId = ns("reps_no"),
            label = "Number of reps",
            value = 0
          ),
          showCancelButton = TRUE,
          cancelButtonText = "Finish",
          confirmButtonText = "Next series",
          callbackR = function(x) {
            if (x) {
              add_series(input$reps_no)
              series_number(series_number() + 1)
              show_series_window()
            } else {
              add_series(input$reps_no)
              finish_and_save_workout()
            }
          }
        )
      }

      shiny::observeEvent(input$add_workout_btn, {
        shinyalert::shinyalert(
            html = TRUE,
            text = shiny::tagList(
              shinyWidgets::pickerInput(
                inputId = ns("workout_type"),
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
            ),
            callbackR = function(x) {
              if (x) {
                series_number(series_number() + 1)
                show_series_window()
              }
            }
          )
        }
      )
    }
  )
}