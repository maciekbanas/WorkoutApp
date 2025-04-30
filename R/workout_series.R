workout_series_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutSeries",
    icon = shinyMobile::f7Icon("flame_fill"),
    shinyMobile::f7Card(
        shiny::h3("Warm up"),
        shinyMobile::f7Block(
          htmltools::div(
            id = "shiny-timer-container",
            class = "hidden",
            shinyTimer::shinyTimer(
              inputId = "timer",
              seconds = NULL,
              background = "circle",
              style = "font-size:46px; background-color:purple;"
            )
          )
        ),
        br(),
        shinyMobile::f7Button(
          "warmup_done",
          "Done"
        ),
        shiny::uiOutput("series_widgets_container")
      )
)
