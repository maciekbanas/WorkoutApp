workout_series_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutSeries",
    icon = shinyMobile::f7Icon("flame_fill"),
    shinyMobile::f7Card(
        shiny::div(id = "series-header", class = "series-headers"),
        shiny::div(id = "series-data", class = "series-headers"),
        shiny::div(id = "series-no", class = "series-headers"),
        shiny::br(),
        shinyMobile::f7Block(
          htmltools::div(
            id = "shiny-timer-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "timer",
              seconds = NULL,
              background = "circle",
              style = "font-size:46px; background-color:orange;"
            )
          ),
          htmltools::div(
            id = "stopwatch-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "stopwatch",
              seconds = 0,
              background = "circle",
              style = "font-size:46px; background-color:green;"
            )
          )
        ),
        shiny::br(),
        htmltools::div(
          id = "series_done_container"
        ),
        shiny::uiOutput("series_widgets_container")
      )
)
