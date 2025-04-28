workout_series_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutSeries",
    icon = shinyMobile::f7Icon("flame_fill"),
    shinyMobile::f7Card(
        shiny::h3("Series Input"),
        shinyMobile::f7BlockTitle("Time Left:"),
        shinyMobile::f7Block(
          htmltools::div(
            style = "display:flex; justify-content:center;",
            shinyTimer::shinyTimer(
              inputId = "timer",
              seconds = 10L,
              background = "circle",
              style = "font-size:46px; background-color:purple;"
            )
          )
        ),
        shiny::uiOutput("series_widgets")
      )
)
