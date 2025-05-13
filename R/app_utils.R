test_mode <- Sys.getenv("WORKOUT_APP_TEST_MODE", unset = "FALSE") |> as.logical()
if (test_mode) {
  print("Testing mode ON.")
}
supabase_project_url <- if (test_mode) {
  Sys.getenv("SUPABASE_PROJECT_URL_TEST")
} else {
  Sys.getenv("SUPABASE_PROJECT_URL")
}