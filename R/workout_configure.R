workout_configure_tab <- 
  shinyMobile::f7Tab(
    tabName = "WorkoutConfigure",
    icon = shinyMobile::f7Icon("slider_horizontal_3"),
    active = TRUE,
    shinyMobile::f7Card(
      shinyMobile::f7Picker(
        inputId = "workout_category",
        label = "Type of workout",
        choices = workout_types
      ),
      shinyMobile::f7Radio(
        inputId = "workout_dynamic",
        label = "",
        selected = "dynamic",
        choices = c("dynamic", "static")
      ),
      shiny::div(
        id = "workout_type_container"
      ),
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
      ),
      shinyMobile::f7Picker(
        inputId = "resistance_band",
        label = "Using resistance band",
        choices = c("no", "light", "medium", "hard")
      ),
      shiny::br(),
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
      shinyMobile::f7Button(
        inputId = "start_workout_btn",
        label = "Start Workout",
        color = "green",
        size = "large"
      )
    )
  )
