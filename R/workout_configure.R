workout_configure_tab <- 
  shinyMobile::f7Tab(
    tabName = "WorkoutConfigure",
    icon = shinyMobile::f7Icon("slider_horizontal_3"),
    shinyMobile::f7Card(
      shiny::div(
        shinyMobile::f7Picker(
          inputId = "workout_category",
          label = "Type of workout",
          choices = workout_types
        )
      ),
      shiny::div(
        id = "workout_type_container"
      ),
      shiny::div(
        id = "add_weight_container"
      ),
      shiny::div(
        id = "add_resistance_band_container"
      ),
      shinyMobile::f7BlockTitle(
        "Set time between series (seconds)"
      ),
      shinyMobile::f7Stepper(
        inputId = "timer_setter",
        label = NULL,
        min = 0,
        max = 1000,
        step = 15,
        value = 90,
        size = "large",
        manual = TRUE
      ),
      shiny::br(),
      shiny::div(
        id = "comment_before_container",
        shinyMobile::f7TextArea(
          inputId = "comment_before",
          label = "Do you want to add some comment before workout?"
        )
      ),
      shiny::br(),
      shinyMobile::f7Button(
        inputId = "start_workout_btn",
        label = "Start Workout",
        color = "green",
        size = "large"
      )
    )
  )

workout_configure_server <- function(input, output, session, workout_data) {
  shiny::observeEvent(c(input$workout_category), {
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
          choices = unname(unlist(workouts[[input$workout_category]]))
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
    category_workouts <- workouts[[input$workout_category]]
    workout_dynamics <- purrr::keep(category_workouts, ~ input$workout_type %in% .) |>
      names()
    workout_data$dynamic = workout_dynamics
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
            choices = resistance_band_choices
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
    if (workout_data$dynamic == "dynamic") {
      add_series_done_btn()
    } 
    if (workout_data$dynamic == "static") {
      add_start_static_workout_btn()
    }
  }, ignoreInit = TRUE)
}