workout_home_tab <- shinyMobile::f7Tab(
  tabName = "WorkoutHome",
  icon = shinyMobile::f7Icon("house"),
  active = TRUE,
  shinyMobile::f7Card(
    shinyMobile::f7BlockTitle(
      "Your bodyweight today"
    ),
    shinyMobile::f7Stepper(
      inputId = "body_weight",
      label = NULL,
      min = 0,
      max = 200,
      step = 0.1,
      value = 73.5,
      size = "large",
      manual = TRUE
    ),
    shiny::br(),
    shiny::div(
      id = "comment_before_container",
      shinyMobile::f7TextArea(
        inputId = "comment_before",
        label = "",
        placeholder = "Add comment on any preconditions today."
      )
    ),
    shiny::br(),
    shinyMobile::f7Button(
      inputId = "configure_workout_btn",
      label = "Configure workout"
    )
  )
)

workout_home_server <- function(input, output, session) {
  shiny::observeEvent(input$configure_workout_btn, {
    shinyMobile::updateF7Tabs(session, id = "tabs", selected = "WorkoutConfigure")
  })
}