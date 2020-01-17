
#' Create and Update Keynote Presentations from R
#'
#' Create and Update Keynote Presentations from R
#'
#' @docType package
#' @name keynote
NULL

#' Object to query Keynote
#'
#' TODO
#' @export

keynote <- NULL

keynote_class <- R6Class(
  "keynote",
  public = list(

    is_running = function() {
      out <- run_script("is-running")
      parse_json(out$stdout, simplifyDataFrame = FALSE)
    },

    info = function() {
      out <- run_script("info")
      parse_json(out$stdout, simplifyDataFrame = FALSE, simplifyVector = FALSE)
    },

    list_document_windows = function() {
      out <- run_script("list-document-windows")
      parse_json(out$stdout)
    },

    list_themes = function() {
      out <- run_script("list-themes")
      parse_json(out$stdout)
    },

    quit = function() {
      run_script("quit")
      invisible(self)
    },

    start_slideshow = function() private$cmd("start_slideshow"),
    stop_slideshow = function() private$cmd("stop_slideshow"),
    show_next = function() private$cmd("show_next"),
    show_previous = function() private$cmd("show_previous")
  ),

  private = list(
    cmd = function(code) {
      run_script("cmd", code)
      invisible(self)
    }
  )
)
