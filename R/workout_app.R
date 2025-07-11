workout_app <- function() {
  workout_ui <- shinyMobile::f7Page(
    htmltools::htmlDependency(name = "WorkoutApp-assets", version = "0.1",
                              package = "WorkoutApp",
                              src = "www",
                              script = "script.js",
                              stylesheet = "style.css"
    ),
    add_pwa_deps(),
    add_pwacompat_deps(),
    title = "Workout App",
    allowPWA = TRUE,
    shinyMobile::f7TabLayout(
      navbar = shinyMobile::f7Navbar(
        title = "Workout App"
      ),
      shinyMobile::f7Tabs(
        id = "tabs",
        workout_configure_tab,
        workout_series_tab,
        workout_results_tab
      )
    )
  )
  shiny::shinyApp(workout_ui, workout_server)
}
