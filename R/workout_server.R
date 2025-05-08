workout_server <- function(input, output, session) {
  workout_data <- shiny::reactiveValues(
    type = "",
    series_no = 1,
    reps = c()
  )
  
  shiny::observeEvent(input$start_workout_btn, {
    workout_data$type <- input$workout_type
    workout_data$reps <- c()
    shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutSeries")
    session$sendCustomMessage("updateHeader", "Warm up!")
  }, ignoreInit = TRUE)
  
  shiny::observeEvent(input$next_series_btn, {
    workout_data$reps <- c(workout_data$reps, input$reps_input)
    shiny::updateNumericInput(session, "reps_input", value = 10L)
    shinyTimer::updateShinyTimer(
      inputId = "timer",
      seconds = input$timer_setter
    )
    workout_data$series_no <- workout_data$series_no + 1L
    session$sendCustomMessage("resetTimerDone", FALSE)
    session$sendCustomMessage("showTimer", TRUE)
    session$sendCustomMessage("updateSeriesNumber", workout_data$series_no)
    shinyTimer::countDown(
      inputId = "timer"
    )
  }, ignoreInit = TRUE)
  
  shiny::observeEvent(input$finish_workout_btn, {
    workout_data$reps <- c(workout_data$reps, input$reps_input)
    
    reps_str <- paste(workout_data$reps, collapse = ",")
    dbExecute(db_con, "
      INSERT INTO workouts (workout_type, reps, weight, band, session_date)
      VALUES (?, ?, ?, ?, ?)
    ",
      params = list(
        workout_data$type,
        reps_str,
        input$additional_weight,
        input$resistance_band,
        as.character(Sys.time())
      )
    )
    
    output$workout_results <- shiny::renderUI({
      shiny::p(
        paste0(workout_data$type, ": ", paste0(workout_data$reps, collapse = ", "))
      )
    })
    shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutResults")
  }, ignoreInit = TRUE)
  
  shiny::observeEvent(input$warmup_done, {
    shiny::removeUI(
      selector = "#warmup_done"
    )
    session$sendCustomMessage("updateHeader", workout_data$type)
    session$sendCustomMessage("updateSeriesNumber", 1L)
    session$sendCustomMessage("updateSeriesData", input$additional_weight)
    insert_series_widgets()
  })
  
  shiny::observeEvent(input$timer_done, {
    if (input$timer_done) {
      session$sendCustomMessage("hideTimer", TRUE)
      insert_series_widgets()
    } else {
      shiny::removeUI(
        selector = "#series_widgets"
      )
    }
  })
}

insert_series_widgets <- function() {
  shiny::insertUI(
    selector = "#series_widgets_container",
    ui = htmltools::div(
      id = "series_widgets",
      shinyMobile::f7Block(
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
  )
}
