
config_marker <- function() "-- keynote R package, do not change --"

#' @importFrom jsonlite fromJSON toJSON
#' @importFrom utils modifyList

parse_config <- function(notes) {
  parts <- strsplit(notes, config_marker(), fixed = TRUE)[[1]]
  if (length(parts) == 0) parts <- c("", "[]")
  if (length(parts) == 1) parts <- c(parts, "[]")
  list(notes = parts[1], config = fromJSON(parts[2]))
}

add_config <- function(notes, config) {
  old_config <- parse_config(notes)
  new_config <- modifyList(old_config$config, config)
  paste0(
    old_config$notes,
    config_marker(),
    "\n",
    toJSON(new_config)
  )
}
