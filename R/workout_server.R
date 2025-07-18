workout_server <- function(input, output, session) {
  workout_data <- shiny::reactiveValues(
    type = "",
    series_no = 1L,
    reps = c()
  )
  
  shiny::observeEvent(c(input$workout_category, input$workout_dynamic), {
    shiny::removeUI(
      selector = "#workout_type_div"
    )
    shiny::insertUI(
      selector = "#workout_type_container",
      ui = shiny::div(
        id = "workout_type_div",
        shinyMobile::f7Picker(
          label = "Choose your workout",
          inputId = "workout_type",
          choices = workouts[[input$workout_category]][[input$workout_dynamic]]
        )
      )
    )
  })
  
  shiny::observeEvent(input$workout_type, {
    shiny::removeUI(
      selector = "#additional_weight_div"
    )
    shiny::removeUI(
      selector = "#resistance_band_div"
    )
    if (grepl("weighted", input$workout_type)) {
      shiny::insertUI(
        selector = "#add_weight_container",
        ui = shiny::div(
          id = "additional_weight_div",
          shinyMobile::f7BlockTitle(
            "Additional weight?"
          ),
          shinyMobile::f7Stepper(
            inputId = "additional_weight",
            label = NULL,
            min = 0,
            max = 100,
            value = 0,
            size = "large",
            manual = TRUE
          )
        )
      )
    } else {
      shiny::insertUI(
        selector = "#add_resistance_band_container",
        ui =  shiny::div(
          id = "resistance_band_div",
          shinyMobile::f7Picker(
            inputId = "resistance_band",
            label = "Using resistance band",
            choices = c("no", "light", "medium", "hard")
          )
        ),
      )
    }
  })
  
  shiny::observeEvent(input$start_workout_btn, {
    workout_data$type <- input$workout_type
    workout_data$reps <- c()
    workout_data$series_no <- 1L
    shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutSeries")
    session$sendCustomMessage("updateHeader", workout_data$type)
    if (!is.null(input$additional_weight) && input$additional_weight > 0) {
      session$sendCustomMessage("updateWeightData", input$additional_weight)
    }
    if (input$resistance_band != "no") {
      session$sendCustomMessage("updateBandInfo", input$resistance_band)
    }
    session$sendCustomMessage("updateSeriesNumber", workout_data$series_no)
    if (input$workout_dynamic == "dynamic") {
      shiny::insertUI(
        selector = "#series_done_container",
        ui = shinyMobile::f7Button(
          "series_done",
          "Done",
          color = "orange"
        )
      )
    } else {
      shiny::insertUI(
        selector = "#series_done_container",
        ui = shinyMobile::f7Button(
          "start_static",
          "Start",
          color = "green"
        )
      )
    }
  }, ignoreInit = TRUE)
  
  shiny::observeEvent(input$next_series_btn, {
    workout_data$reps <- c(workout_data$reps, input$reps_input)
    shiny::updateNumericInput(session, "reps_input", value = input$reps_input)
    workout_data$series_no <- workout_data$series_no + 1L
    session$sendCustomMessage("updateSeriesNumber", workout_data$series_no)
    shinyTimer::updateShinyTimer(
      inputId = "timer",
      seconds = input$timer_setter
    )
    session$sendCustomMessage("resetTimerDone", FALSE)
    session$sendCustomMessage("showTimer", TRUE)
    shinyTimer::countDown(
      inputId = "timer"
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
    if (input$workout_dynamic == "static") {
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
  
  workout_results_server(input, output, session, workout_data)
  
  shiny::observeEvent(input$timer_done, {
    if (input$timer_done) {
      if (input$workout_dynamic == "dynamic") {
        session$sendCustomMessage("hideTimer", TRUE)
        shiny::insertUI(
          selector = "#series_done_container",
          ui = shinyMobile::f7Button(
            "series_done",
            "Done",
            color = "orange"
          )
        )
      } else {
        shinyTimer::updateShinyTimer(
          inputId = "timer",
          seconds = 0L
        )
        shinyTimer::countUp(
          inputId = "timer"
        )
        shiny::insertUI(
          selector = "#series_done_container",
          ui = shinyMobile::f7Button(
            "series_done",
            "Done",
            color = "orange"
          )
        )
      }
    } else {
      shiny::removeUI(
        selector = "#series_widgets"
      )
    }
  })
  
  shiny::observeEvent(input$series_done, {
    shiny::removeUI(
      selector = "#series_done"
    )
    if (input$workout_dynamic == "dynamic") {
      insert_series_widgets()
    } else {
      shinyTimer::pauseTimer(
        inputId = "timer"
      )
      insert_series_widgets("static")
      session$sendCustomMessage("hideTimer", TRUE)
    }
  })
  
  shiny::observeEvent(input$shinytimer_content, {
    shinyMobile::updateF7Stepper(
      inputId = "reps_input",
      value = as.numeric(input$shinytimer_content)
    )
  }, priority = 1)
  
  shiny::observeEvent(input$start_static, {
    shiny::removeUI(
      selector = "#start_static"
    )
    session$sendCustomMessage("showTimer", TRUE)
    session$sendCustomMessage("showPrepareYourself", TRUE)
    shinyTimer::updateShinyTimer(
      inputId = "timer",
      seconds = 5L
    )
    shinyTimer::countDown(
      inputId = "timer"
    )
  })
}

insert_series_widgets <- function(workout_dynamic = "dynamic") {
  series_data_title <- if (workout_dynamic == "dynamic") {
    "How many reps did you do?"
  } else {
    "How long did you hold?"
  }
  shiny::insertUI(
    selector = "#series_widgets_container",
    ui = htmltools::div(
      id = "series_widgets",
      shinyMobile::f7Block(
        shinyMobile::f7BlockTitle(
          series_data_title
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
