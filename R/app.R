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
      
      shiny::observeEvent(input$timer_done, {
        shiny::insertUI(
          selector = "#series_widgets",
          ui = shinyMobile::f7Block(
            shinyMobile::f7Slider(
              inputId = "reps_input",
              label = "How many reps did you do?",
              min = 0,
              max = 100,
              value = 10
            ),
            shiny::br(),
            shinyMobile::f7Button(
              inputId = "next_series_btn",
              label = "Next Series",
              color = "green",
              size = "large"
            ),
            shinyMobile::f7Button(
              inputId = "finish_workout_btn",
              label = "Save and finish Workout",
              color = "red",
              size = "large"
            )
          )
        )
      })
}

shiny::shinyApp(ui, server)
}
