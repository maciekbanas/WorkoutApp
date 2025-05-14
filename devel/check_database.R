res <- httr::GET(
  url = "https://ypnwafkusuvrnrgaikhc.supabase.co/rest/v1/workouts",
  httr::add_headers(
    Authorization = paste0("Bearer ", Sys.getenv("SUPABASE_API_KEY")),
    apikey = Sys.getenv("SUPABASE_ROLE_KEY")
  )
)

httr::content(res)
