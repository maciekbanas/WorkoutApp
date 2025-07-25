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
  $("#series-no").text("series " + x);
})

Shiny.addCustomMessageHandler("updateWeightData", function(x) {
  $("#series-data").text("additional weight: " + x + " kg");
})

Shiny.addCustomMessageHandler("updateBandInfo", function(x) {
  $("#series-data").text("resistance band: " + x);
})

Shiny.addCustomMessageHandler("showPrepareYourself", function(x) {
  $("#series-data").text("Prepare yourself!");
})