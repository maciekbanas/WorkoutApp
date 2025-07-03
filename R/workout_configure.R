workout_configure_tab <- 
  shinyMobile::f7Tab(
    tabName = "WorkoutConfigure",
    icon = shinyMobile::f7Icon("slider_horizontal_3"),
    active = TRUE,
    shinyMobile::f7Card(
      shiny::div(
        shinyMobile::f7Picker(
          inputId = "workout_category",
          label = "Type of workout",
          choices = workout_types
        )
      ),
      shiny::div(
        shinyMobile::f7Picker(
          inputId = "workout_dynamic",
          label = "Dynamic or static",
          value = "dynamic",
          choices = c("dynamic", "static")
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
      shinyMobile::f7BlockTitle(
        "Your bodyweight"
      ),
      shinyMobile::f7Stepper(
        inputId = "body_weight",
        label = NULL,
        min = 0,
        max = 200,
        step = 0.1,
        value = 73.5,
        size = "large",
        manual = TRUE
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
