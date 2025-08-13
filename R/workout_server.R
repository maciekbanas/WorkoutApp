workout_server <- function(input, output, session) {
  
  workout_data <- shiny::reactiveValues(
    type = "",
    dynamic = "dynamic",
    series_no = 1L,
    reps = c()
  )
  
  workout_home_server(input, output, session)
  workout_configure_server(input, output, session, workout_data)
  workout_series_server(input, output, session, workout_data)
  workout_results_server(input, output, session, workout_data)
  
}
