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
