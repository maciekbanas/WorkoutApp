insert_series_widgets <- function(saved_reps_input, workout_dynamic = "dynamic") {
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
          value = saved_reps_input()
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

set_off_get_ready <- function(session = shiny::getDefaultReactiveDomain()) {
  shinyTimer::updateShinyTimer(
    inputId = "get_ready_timer",
    seconds = 5L
  )
  session$sendCustomMessage("showPrepareYourself", TRUE)
  session$sendCustomMessage("showTimer", "get-ready")
  shinyTimer::countDown(
    inputId = "get_ready_timer"
  )
}

set_off_stopwatch <- function(session = shiny::getDefaultReactiveDomain()) {
  shinyTimer::updateShinyTimer(
    inputId = "stopwatch_timer",
    seconds = 0L
  )
  session$sendCustomMessage("showTimer", "stopwatch")
  shinyTimer::countUp(
    inputId = "stopwatch_timer"
  )
  add_series_done_btn()
}

add_series_done_btn <- function() {
  shiny::insertUI(
    selector = "#series_done_container",
    ui = shinyMobile::f7Button(
      "series_done",
      "Done",
      color = "orange"
    )
  )
}

add_start_static_workout_btn <- function() {
  shiny::insertUI(
    selector = "#series_done_container",
    ui = shinyMobile::f7Button(
      "start_static",
      "Start",
      color = "green"
    )
  )
}