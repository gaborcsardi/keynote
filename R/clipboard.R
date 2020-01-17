
with_clipboard <- function(rich_text, expr) {
  # TODO: actually restore
  # current <- get_clipboard()
  set_clipboard(rich_text)
  expr
  # set_clipboard(current)
}

get_clipboard <- function() {
  # TODO
  NULL
}

#' @importFrom glue glue

set_clipboard <- function(rich_text, format = c("html")) {
  format <- match.arg(format)
  hex <- paste(charToRaw(enc2utf8(rich_text)), collapse = "")
  run_code(glue("set the clipboard to \u00abdata HTML{hex}\u00bb"))
}
