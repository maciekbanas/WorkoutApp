Shiny.addCustomMessageHandler("resetTimerDone", function(x) {
  Shiny.setInputValue("timer_done", false);
})

Shiny.addCustomMessageHandler("showTimer", function(x) {
  $("#shiny-timer-container").removeClass("hidden");
})

Shiny.addCustomMessageHandler("hideTimer", function(x) {
  $("#shiny-timer-container").addClass("hidden");
})