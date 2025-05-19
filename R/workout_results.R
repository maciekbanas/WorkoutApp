workout_results_tab <- shinyMobile::f7Tab(
    tabName = "WorkoutResults",
    icon = shinyMobile::f7Icon("chart_bar_fill"),
    shinyMobile::f7Card(
        shiny::uiOutput("workout_results"),
        shinyMobile::f7Button(
          inputId = "next_workout_btn",
          label = "Next Workout",
          color = "green",
          size = "large"
        ),
        shinyMobile::f7Button(
          inputId = "close_app_btn",
          label = "Close App",
          color = "red",
          size = "large"
        ),
        shinyMobile::f7Picker(
          inputId = "workout_results_type",
          label = "Display data for",
          choices = workout_types
        ),
        plotly::plotlyOutput("workout_data")
    )
)

workout_results_server <- function(input, output, session, workout_data) {
  
  workout_results_global <- httr::GET(
    url = supabase_project_url,
    httr::add_headers(
      Authorization = paste0("Bearer ", Sys.getenv("SUPABASE_API_KEY")),
      apikey = Sys.getenv("SUPABASE_ROLE_KEY")
    )
  ) |>
    httr::content() |>
    purrr::map(data.frame) |>
    purrr::list_rbind()
  
  output$workout_results <- shiny::renderUI({
    shiny::p(
      paste0("Today (", Sys.Date(), "): ", workout_data$type, ": ", 
             paste0(workout_data$reps, collapse = ", "))
    )
  })
  
  output$workout_data <- plotly::renderPlotly({
    df_long <- workout_results_global |>
      dplyr::filter(workout_type == input$workout_results_type) |>
      dplyr::mutate(series_id = dplyr::row_number()) |>
      tidyr::separate_rows(reps, sep = ",") |>
      dplyr::group_by(id) |>
      dplyr::mutate(
        timestamp = lubridate::as_datetime(timestamp),
        series = dplyr::row_number(),
        reps = as.numeric(reps)
      ) |>
      dplyr::ungroup()
    
    plotly::plot_ly(
      data = df_long,
      x = ~timestamp,
      y = ~reps,
      type = 'bar',
      color = ~factor(series),
      text = ~paste("Series", series, "<br>Reps:", reps),
      hoverinfo = 'text'
    ) |>
      plotly::layout(
        title = paste("Workout series for:", input$workout_results_type),
        xaxis = list(title = "Series"),
        yaxis = list(title = "Repetitions"),
        barmode = 'group',
        paper_bgcolor = 'rgba(0,0,0,0)',
        plot_bgcolor = 'rgba(0,0,0,0)'
      )
  })
  
  shiny::observeEvent(input$"next_workout_btn", {
    shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutConfigure")
    session$sendCustomMessage("updateSeriesNumber", 1L)
  })
  
  shiny::observeEvent(input$close_app_btn, {
    shiny::stopApp()
  })
}