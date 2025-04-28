workout_configure_tab <- 
  shinyMobile::f7Tab(
    tabName = "WorkoutConfigure",
    icon = shinyMobile::f7Icon("slider_horizontal_3"),
    active = TRUE,
    shinyMobile::f7Card(
      shinyMobile::f7Picker(
        inputId = "workout_type",
        label = "Choose your workout",
        choices = c("Push ups", "Pike push ups", "Advanced pike push ups",
                    "Dips",
                    "Pull ups", "High pull ups", "Muscle ups",
                    "Squats", "Burpees")
      ),
      shinyMobile::f7Slider(
        inputId = "additional_weight",
        label = "Additional weight?",
        min = 0,
        max = 100,
        value = 0
      ),
      shinyMobile::f7Picker(
        inputId = "resistance_band",
        label = "Using resistance band",
        choices = c("no", "light", "medium", "hard")
      ),
      shiny::br(),
      shinyMobile::f7Slider(
        inputId = "timer_setter",
        label = "Set timer between series (seconds)",
        min = 0,
        max = 360,
        value = 60L
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