workout_series_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutSeries",
    icon = shinyMobile::f7Icon("flame_fill"),
    shinyMobile::f7Card(
        shiny::div(id = "series-header"),
        shiny::div(id = "series-data"),
        shiny::div(id = "series-no"),
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
        shiny::br(),
        htmltools::div(
          id = "series_done_container",
          shinyMobile::f7Button(
            "series_done",
            "Done"
          )
        ),
        shiny::uiOutput("series_widgets_container")
      )
)
