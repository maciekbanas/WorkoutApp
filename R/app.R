library(shiny)
library(shinyMobile)

workout_app <- function() {
  ui <- shinyMobile::f7Page(
  title = "Workout App",
  shinyMobile::f7TabLayout(
    navbar = shinyMobile::f7Navbar(
      title = "Workout App"
    ),
    shinyMobile::f7Tabs(
      id = "tabs",
      workout_configure_tab,
      workout_series_tab,
      workout_results_tab
    )
  )
)


  server <- function(input, output, session) {
      workout_data <- shiny::reactiveValues(
        type = "",
        reps = c()
      )
      
      shiny::observeEvent(input$start_workout_btn, {
        workout_data$type <- input$workout_type
        workout_data$reps <- c()
        shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutSeries")
        shinyTimer::countDown(
          session = session,
          inputId = "timer"
        )
      }, ignoreInit = TRUE)
      
      shiny::observeEvent(input$next_series_btn, {
        workout_data$reps <- c(workout_data$reps, input$reps_input)
        shiny::updateNumericInput(session, "reps_input", value = 10)
        shinyTimer::updateShinyTimer(
          inputId = "timer",
          seconds = input$timer_setter,
          session = session
        )
        shinyTimer::countDown(
          session = session,
          inputId = "timer"
        )
      }, ignoreInit = TRUE)

      shiny::observeEvent(input$finish_workout_btn, {
        workout_data$reps <- c(workout_data$reps, input$reps_input)
        
        output$workout_results <- shiny::renderUI({
          shiny::p(
            paste0(workout_data$type, ": ", paste0(workout_data$reps, collapse = ", "))
          )
        })
        shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutResults")

      }, ignoreInit = TRUE)
    
}

shiny::shinyApp(ui, server)
}
