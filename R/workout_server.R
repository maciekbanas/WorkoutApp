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
    session$sendCustomMessage("updateSeriesNumber", 1L)
    session$sendCustomMessage("updateHeader", workout_data$type)
    session$sendCustomMessage("updateSeriesData", input$additional_weight)
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
    res <- httr::POST(
      url = supabase_project_url,
      httr::add_headers(
        Authorization = paste0("Bearer ", Sys.getenv("SUPABASE_API_KEY")),
        apikey = Sys.getenv("SUPABASE_ROLE_KEY"),
        `Content-Type` = "application/json"
      ),
      body = jsonlite::toJSON(
        list(
          workout_type = workout_data$type,
          reps = reps_str,
          weight = input$additional_weight,
          band = input$resistance_band,
          session_date = Sys.time()
        ),
        auto_unbox = TRUE
      )
    )
    if (test_mode) {
      shinyMobile::f7Notif(paste0("Workout saved to TEST database."))
    } else {
      shinyMobile::f7Notif(paste0("Workout saved to database."))
    }
    shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutResults")
  }, ignoreInit = TRUE)
  
  workout_results_server(input, output, session, workout_data)
  
  shiny::observeEvent(input$series_done, {
    shiny::removeUI(
      selector = "#series_done"
    )
    insert_series_widgets()
  })
  
  shiny::observeEvent(input$timer_done, {
    if (input$timer_done) {
      session$sendCustomMessage("hideTimer", TRUE)
      shiny::insertUI(
        selector = "#series_done_container",
        ui = shinyMobile::f7Button(
          "series_done",
          "Done"
        )
      )
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
        shinyMobile::f7BlockTitle(
          "How many reps did you do?"
        ),
        shinyMobile::f7Stepper(
          inputId = "reps_input",
          label = NULL,
          min = 0,
          max = 100,
          size = "large",
          manual = TRUE,
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
