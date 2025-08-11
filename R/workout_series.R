workout_series_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutSeries",
    icon = shinyMobile::f7Icon("flame_fill"),
    shinyMobile::f7Card(
        shiny::div(id = "series-header", class = "series-headers"),
        shiny::div(id = "series-data", class = "series-headers"),
        shiny::div(id = "series-no", class = "series-headers"),
        shiny::div(style = "height: 100px;"),
        shiny::br(),
        htmltools::div(
          style = "height: 150px;",
          htmltools::div(
            id = "break-timer-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "break_timer",
              seconds = 0,
              frame = "circle",
              fill = "orange",
              style = "font-size:46px;"
            )
          ),
          htmltools::div(
            id = "stopwatch-timer-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "stopwatch_timer",
              seconds = 0,
              frame = "circle",
              fill = "#272931",
              color = "yellow",
              style = "font-size:46px;"
            )
          ),
          htmltools::div(
            id = "get-ready-timer-container",
            class = c("shinytimer-container", "hidden"),
            shinyTimer::shinyTimer(
              inputId = "get_ready_timer",
              seconds = 5,
              frame = "circle",
              fill = "#272931",
              color = "red",
              style = "font-size:46px;"
            )
          )
        ),
        shiny::div(style = "height: 50px;"),
        shiny::br(),
        htmltools::div(
          id = "series_done_container"
        ),
        shiny::uiOutput("series_widgets_container")
      )
)
