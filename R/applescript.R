
#' @importFrom processx run

run_script <- function(script, args = character(), ...) {
  stopifnot(
    is_string(script),
    is_character(args)
  )

  if (!is_absolute_path(script)) {
    script <- system.file(
      "scripts",
      paste0(script, ".applescript"),
      package = .packageName
    )
    if (script == "") stop("Cannot find Apple script `", script, "`")
  }

  if (!file.exists(script)) stop("Apple script file does not exist")

  run("osascript", c("-ss", script, args), ...)
}

run_code <- function(code, args = character(), ...) {
  tmp <- tempfile(fileext = ".applescript")
  on.exit(unlink(tmp), add = TRUE)
  cat(code, file = tmp)
  run_script(tmp, args)
}
