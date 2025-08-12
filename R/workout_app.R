workout_app <- function() {
  workout_ui <- shinyMobile::f7Page(
    htmltools::htmlDependency(name = "WorkoutApp-assets", version = "0.1",
                              package = "WorkoutApp",
                              src = "www",
                              script = "script.js",
                              stylesheet = "style.css"
    ),
    title = "Workout App",
    shinyMobile::f7TabLayout(
      navbar = shinyMobile::f7Navbar(
        title = paste0("Workout App (", app_version, ") ", print_test_mode())
      ),
      shinyMobile::f7Tabs(
        id = "tabs",
        workout_home_tab,
        workout_configure_tab,
        workout_series_tab,
        workout_results_tab
      )
    )
  )
  shiny::shinyApp(workout_ui, workout_server)
}
