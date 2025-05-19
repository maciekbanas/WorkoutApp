test_mode <- Sys.getenv("WORKOUT_APP_TEST_MODE", unset = "FALSE") |> as.logical()
test_mode_on <- function() {
  Sys.setenv(WORKOUT_APP_TEST_MODE = "TRUE")
  print("TEST mode ON.")
}
test_mode_off <- function() {
  Sys.setenv(WORKOUT_APP_TEST_MODE = "FALSE")
  print("PROD mode ON.")
}
if (test_mode) {
  print("TEST mode ON.")
}
supabase_project_url <- if (test_mode) {
  Sys.getenv("SUPABASE_PROJECT_URL_TEST")
} else {
  Sys.getenv("SUPABASE_PROJECT_URL")
}

deploy_workout_app <- function(){
  test_mode_off()
  rsconnect::deployApp()
}

workout_types <- c("push ups", 
                   "pike push ups", "advanced pike push ups",
                   "dips", "ring dips",
                   "chin ups", "weighted chin ups",
                   "pull ups", "weighted pull ups", "wide pull ups", "archer pull ups", 
                   "high pull ups", "muscle ups",
                   "squats", "pistol squats", 
                   "burpees",
                   "leg raises")