library(DBI)
library(RSQLite)

db_con <- dbConnect(RSQLite::SQLite(), "workouts.sqlite")

dbExecute(db_con, "
  CREATE TABLE IF NOT EXISTS workouts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp TEXT DEFAULT CURRENT_TIMESTAMP,
    workout_type TEXT,
    reps TEXT,
    weight INTEGER,
    band TEXT,
    session_date TEXT
  )
")

onStop(function() {
  dbDisconnect(db_con)
})