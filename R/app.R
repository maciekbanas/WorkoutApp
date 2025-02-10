library(shiny)
library(shinyMobile)

workout_app <- function() {
  ui <- shinyMobile::f7Page(
    title = "Workout App",
    shinyMobile::f7SingleLayout(
      navbar = shinyMobile::f7Navbar(
        title = "Workout App"
      ),
      workout_ui(
        id = "workout"
      )
    ),
    htmltools::tags$script(HTML("
      let timerInterval;
      Shiny.addCustomMessageHandler('startCountdown', function(startTime) {
        clearInterval(timerInterval);  // Clear any existing timer
        let timeLeft = startTime;
        const countdownElement = document.getElementById('workout-countdown');
        debugger;
        countdownElement.textContent = timeLeft;
        timerInterval = setInterval(function() {
          timeLeft--;
          countdownElement.textContent = timeLeft;

          if (timeLeft <= 0) {
            clearInterval(timerInterval);
            // Optionally notify the server when timer ends
            Shiny.setInputValue('timer_done', true);
          }
        }, 1000);
      });
    "))
  )

server <- function(input, output, session) {
    workout_server(
      id = "workout"
    )
}

shiny::shinyApp(ui, server)
}
