Shiny.addCustomMessageHandler("resetTimerDone", function(x) {
  Shiny.setInputValue("timer_done", false);
})

Shiny.addCustomMessageHandler("showTimer", function(x) {
  $("#shiny-timer-container").removeClass("hidden");
})

Shiny.addCustomMessageHandler("hideTimer", function(x) {
  $("#shiny-timer-container").addClass("hidden");
})

Shiny.addCustomMessageHandler("updateHeader", function(x) {
  $("#series-header").text(x);
})

Shiny.addCustomMessageHandler("updateSeriesNumber", function(x) {
  $("#series-no").text("Series " + x);
})

Shiny.addCustomMessageHandler("updateSeriesData", function(x) {
  $("#series-data").text("Additional weight: " + x + " kg");
})