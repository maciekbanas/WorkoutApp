workout_series_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutSeries",
    icon = shinyMobile::f7Icon("flame_fill"),
    shinyMobile::f7Card(
        shiny::h3("Series Input"),
        shinyMobile::f7BlockTitle("Time Left:"),
        shinyMobile::f7Block(
          shinyMobile::f7Badge(
            shinyTimer::shinyTimer(
              inputId = "timer",
              startSeconds = 0L
            )
          )
        ),
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
