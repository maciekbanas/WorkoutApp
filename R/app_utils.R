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

workout_types <- c("pull", "push", "core", "legs", "mix")

workouts <- list(
  "push" = list(
    "static" = c("frog stand", "crow pose", "advanced crow pose", 
                 "wall handstand", "handstand (kick)", "handstand (press)",
                 "pseudo-planche-lean", "tucked planche", "straddle planche", "planche"),
    "dynamic" = c("push ups", "pike push ups", "advanced pike push ups",
                  "weighted push ups", "diamond push ups", "archer push ups",
                  "one hand push ups",
                  "ring push ups", "weighted push ups",
                  "dips", "ring dips")
    ),
  "pull" = list(
    "static" = c("tucked front lever", "front lever"),
    "dynamic" = c("chin ups", "weighted chin ups", "pull ups", "weighted pull ups",
                  "wide pull ups", "archer pull ups", 
                  "high pull ups", "muscle ups (kick)", "muscle up (strict)")
    ),
  "legs" = list("dynamic" = c("squats", "weighted squats", "pistol squats"),
                "static" = c("")),
  "core" = list(
    "static" = c("L-sit (hang)", "L-sit (paralletes)", "L-sit (floor)"),
    "dynamic" = c("leg raises")
  )
)