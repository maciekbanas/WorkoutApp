# UI Function
workout_ui <- function(id) {
  ns <- shiny::NS(id)
  
  # Main UI
  shinyMobile::f7Card(
    shinyMobile::f7Picker(
      inputId = ns("workout_type"),
      label = "Choose your workout",
      choices = c("Pushups", "Squats", "Burpees")  # Example choices
    ),
    shinyMobile::f7Slider(
      inputId = ns("additional_weight"),
      label = "Additional weight?",
      min = 0,
      max = 100,
      value = 0
    ),
    shinyMobile::f7Picker(
      inputId = ns("resistance_band"),
      label = "Using resistance band",
      choices = c("no", "light", "medium", "hard")
    ),
    shiny::br(),
    shinyMobile::f7Button(
      inputId = ns("start_workout_btn"),
      label = "Start Workout",
      color = "green",
      size = "large"
    ),
    shiny::br(),
    shiny::uiOutput(ns("series_ui")),
    shiny::br(),
    # Output for displaying workout summary
    shiny::uiOutput(ns("workout_output"))
  )
}

# Server Function
workout_server <- function(id) {
  ns <- shiny::NS(id)
  shiny::moduleServer(
    id = id,
    module = function(input, output, session) {

      # Reactive values to manage workout data and state
      workout_data <- shiny::reactiveValues(
        type = "",
        reps = c()
      )
      
      # Visibility states for conditional panels
      show_settings <- shiny::reactiveVal(FALSE)
      show_series <- shiny::reactiveVal(FALSE)

      # Update output bindings to manage panel visibility
      output$show_settings <- shiny::renderText({
        if (show_settings()) "show_settings" else "hide"
      })
      
      output$show_series <- shiny::renderText({
        if (show_series()) "show_series" else "hide"
      })

      # Add workout button click event
      shiny::observeEvent(input$add_workout_btn, {
        show_settings(TRUE)
        show_series(FALSE)
        updateNumericInput(session, ns("reps_input"), value = 10)
      }, ignoreInit = TRUE)
      
      # Start workout button click event
      shiny::observeEvent(input$start_workout_btn, {
        output$series_ui <- shiny::renderUI({
          shiny::tagList(
            shiny::h3("Series Input"),
            shinyMobile::f7Slider(
              inputId = ns("reps_input"),
              label = "Number of reps",
              min = 0,
              max = 100,
              value = 10
            ),
            shiny::br(),
            shinyMobile::f7Button(
              inputId = ns("next_series_btn"),
              label = "Next Series",
              color = "green",
              size = "large"
            ),
            shinyMobile::f7Button(
              inputId = ns("finish_workout_btn"),
              label = "Finish Workout",
              color = "red",
              size = "large"
            )
          )
        })
        workout_data$type <- input$workout_type
        workout_data$reps <- c()  # Reset reps
        show_settings(FALSE)
        show_series(TRUE)
      }, ignoreInit = TRUE)
      
      # Next series button click event
      shiny::observeEvent(input$next_series_btn, {
        workout_data$reps <- c(workout_data$reps, input$reps_input)
        updateNumericInput(session, ns("reps_input"), value = 10)  # Reset for next input
      }, ignoreInit = TRUE)
      
      # Finish workout button click event
      shiny::observeEvent(input$finish_workout_btn, {
        workout_data$reps <- c(workout_data$reps, input$reps_input)  # Add last series
        show_series(FALSE)
        
        # Display workout summary
        output$workout_output <- shiny::renderUI({
          shiny::p(
            paste0(workout_data$type, ": ", paste0(workout_data$reps, collapse = ", "))
          )
        })
      }, ignoreInit = TRUE)
    }
  )
}
