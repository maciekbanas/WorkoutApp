workout_series_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutSeries",
    icon = shinyMobile::f7Icon("flame_fill"),
    shinyMobile::f7Card(
        shiny::div(id = "series-header", class = "series-headers"),
        shiny::div(id = "series-data", class = "series-headers"),
        shiny::div(id = "series-no", class = "series-headers"),
        shiny::div(style = "height: 50px;"),
        shiny::br(),
        htmltools::div(
          style = "height: 150px;",
          htmltools::div(
            id = "break-timer-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "break_timer",
              seconds = 0,
              frame = "circle",
              fill = "orange",
              style = "font-size:46px;"
            )
          ),
          htmltools::div(
            id = "stopwatch-timer-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "stopwatch_timer",
              seconds = 0,
              frame = "circle",
              fill = "#272931",
              color = "yellow",
              style = "font-size:46px;"
            )
          ),
          htmltools::div(
            id = "get-ready-timer-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "get_ready_timer",
              seconds = 5,
              frame = "circle",
              fill = "#272931",
              color = "red",
              style = "font-size:46px;"
            )
          )
        ),
        shiny::div(style = "height: 50px;"),
        shiny::br(),
        htmltools::div(
          id = "series_done_container"
        ),
        shiny::uiOutput("series_widgets_container")
      )
)

workout_series_server <- function(input, output, session, workout_data) {
  
  saved_reps_input <- shiny::reactiveVal(10L)
  get_ready_set_off <- shiny::reactiveVal(FALSE)
  
  shiny::observeEvent(input$next_series_btn, {
    workout_data$reps <- c(workout_data$reps, input$reps_input)
    saved_reps_input(input$reps_input)
    shiny::updateNumericInput(session, "reps_input", value = input$reps_input)
    workout_data$series_no <- workout_data$series_no + 1L
    session$sendCustomMessage("updateSeriesNumber", workout_data$series_no)
    shinyTimer::updateShinyTimer(
      inputId = "break_timer",
      seconds = input$timer_setter
    )
    shiny::removeUI(
      selector = "#series_widgets"
    )
    session$sendCustomMessage("resetTimerDone", "break_timer")
    if (workout_data$dynamic == "static") {
      session$sendCustomMessage("resetTimerDone", "get_ready_timer")
    }
    session$sendCustomMessage("showTimer", "break")
    shinyTimer::countDown(
      inputId = "break_timer"
    )
  }, ignoreInit = TRUE)
  
  shiny::observeEvent(input$finish_workout_btn, {
    shinyMobile::f7Dialog(
      id = "comment_after",
      title = "Do you want to add some comment?",
      type = "prompt",
      text = ""
    )
    shiny::removeUI(
      selector = "#series_widgets"
    )
    if (workout_data$dynamic == "static") {
      session$sendCustomMessage("hideTimer", TRUE)
    }
    shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutResults")
  }, ignoreInit = TRUE)
  
  shiny::observeEvent(input$comment_after, {
    workout_data$reps <- c(workout_data$reps, input$reps_input)
    
    reps_str <- paste(workout_data$reps, collapse = ",")
    add_weight <- 0
    if (!is.null(input$additional_weight)) {
      add_weight <- input$additional_weight
    }
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
          weight = add_weight,
          band = input$resistance_band,
          time_between = input$timer_setter,
          session_date = Sys.time(),
          body_weight = input$body_weight,
          comment_before = input$comment_before,
          comment_after = input$comment_after
        ),
        auto_unbox = TRUE
      )
    )
    if (test_mode) {
      shinyMobile::f7Notif(paste0("Workout saved to TEST database."))
    } else {
      shinyMobile::f7Notif(paste0("Workout saved to database."))
    }
  })
  
  shiny::observeEvent(input$get_ready_timer_done, {
    if (input$get_ready_timer_done) {
      get_ready_set_off(FALSE)
      session$sendCustomMessage("hideTimer", "get-ready")
      set_off_stopwatch()
    }
  })
  
  shiny::observeEvent(input$break_timer_done, {
    if (input$break_timer_done) {
      if (workout_data$dynamic == "dynamic") {
        session$sendCustomMessage("hideTimer", "break")
        add_series_done_btn()
      }
      if (workout_data$dynamic == "static") {
        session$sendCustomMessage("hideTimer", "break")
        add_start_static_workout_btn()
      }
    }
  })
  
  shiny::observeEvent(input$series_done, {
    shiny::removeUI(
      selector = "#series_done"
    )
    if (workout_data$dynamic == "dynamic") {
      insert_series_widgets(saved_reps_input)
    } 
    if (workout_data$dynamic == "static") {
      shinyTimer::pauseTimer(
        inputId = "stopwatch_timer"
      )
      session$sendCustomMessage("hideTimer", "stopwatch")
      insert_series_widgets(saved_reps_input, "static")
    }
  })
  
  shiny::observeEvent(input$stopwatch_timer_content, {
    shinyMobile::updateF7Stepper(
      inputId = "reps_input",
      value = as.numeric(input$stopwatch_timer_content)
    )
  }, priority = 1)
  
  shiny::observeEvent(input$start_static, {
    shiny::removeUI(
      selector = "#start_static"
    )
    set_off_get_ready()
    get_ready_set_off(TRUE)
  })
}