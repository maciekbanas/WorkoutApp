workout_results_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutResults",
    icon = shinyMobile::f7Icon("chart_bar_fill"),
    shinyMobile::f7Card(
        shiny::uiOutput("workout_results")
    )
)