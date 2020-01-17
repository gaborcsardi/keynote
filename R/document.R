
#' Create a new Keynote document
#'
#' @param theme Theme to use. See [`keynote$list_themes()`][keynote_document]
#'   for the available themes.
#' @return `keynote` object.
#' 
#' @export

new_keynote <- function(theme = NULL) {
  keynote_document$new(filename = NULL, open = FALSE, theme = theme)
}

#' Open a Keynote document
#'
#' @param filename path to the document to open.
#' @return `keynote` object.
#'
#' @export

open_keynote <- function(filename = NULL) {
  keynote_document$new(filename, open = TRUE)
}

#' A Keynote document
#'
#' TODO
#' 
#' @importFrom R6 R6Class
#' @importFrom glue glue
#' @export

keynote_document <- R6Class(
  "keynote_document",
  public = list(
    initialize = function(filename = NULL, open = TRUE, theme = NULL) {
      if (open) {
        if (!is.null(filename)) {
          private$open(filename)
        } else {
          private$open_choose()
        }
      } else {
        private$create_new(theme)
      }
      invisible(self)
    },

    run_script = function(text, args = character(), output_format = c("json", "raw")) {
      output_format <- match.arg(output_format)
      text <- paste(text, collapse = "\n")
      code <- glue('
        on run argv
          tell document id "{private$document_id}" of application "Keynote"
            {text}
          end tell
        end run'
      )
      out <- run_code(code, args)
      if (output_format == "json") {
        parse_json(out$stdout, simplifyDataFrame = FALSE)
      } else if (output_format == "raw") {
        out$stdout
      }
    },

    save = function(filename = NULL) {
      # TODO: warn if we are just making a copy
      if (is.null(filename)) {
        run_script("save", private$document_id)
      } else {
        filename <- path.expand(filename)
        run_script("save-as", c(private$document_id, filename))
      }
      invisible(self)
    },

    properties = function() {
      stop("not implemented yet")
      TODO
    },

    filename = function() {
      out <- run_script("get-filename", private$document_id)
      if (out$stdout == "missing value\n") {
        NA_character_
      } else {
        fn <- str_trim(out$stdout)
        substr(fn, 2, nchar(fn) - 1)
      }
    },

    close = function() {
      stop("not implemented yet")
      TODO
    },

    num_slides = function() {
      stop("not implemented yet")
      TODO
    },

    is_open = function() {
      stop("not implemented yet")
      TODO
    },

    export = function() {
      stop("not implemented yet")
      TODO
    },

    list_master_slides = function() {
      out <- run_script("list-master-slides", private$document_id)
      parse_json(out$stdout)
    },

    make_slide = function() {
      out <- run_script("make-slide", private$document_id)
      slide_num <- parse_slide_num(out$stdout)
      private$find_slide(slide_num)
    },

    slide_summary = function() {
      out <- run_script("get-slides", c(private$document_id, config_marker()))
      sum <- parse_json(out$stdout)
      sum$id <- vapply(
        sum$presenter_notes,
        function(x) parse_config(x)$config$id %||% NA_character_,
        ""
      )
      sum
    },

    get_slide = function(id) {
      slide$new(id = id, self, private)
    }
  ),

  private = list(
    document_id = NULL,

    open = function(filename) {
      filename <- normalizePath(filename)
      out <- run_script("open", filename)
      private$document_id <- parse_document_id(out$stdout)
    },

    open_choose = function() {
      out <- run_script("open-choose")
      if (nchar(out$stdout) == 0) stop("Cancelled")
      private$document_id <- parse_document_id(out$stdout)
    },

    create_new = function(theme) {
      out <- run_script("create-new", theme %||% "-")
      private$document_id <- parse_document_id(out$stdout)
    },

    find_slide = function(num) {
      id <- new_uuid()
      slide$new(id = id, self, private, num = num, make_notes = TRUE)
    }
  )
)

parse_document_id <- function(txt) {
  sub("^document id \"([-A-Za-z0-9]*)\".*$", "\\1", txt)
}

parse_slide_num <- function(txt) {
  sub("^slide ([0-9]+) of document.*$", "\\1", txt)
}

parse_json <- function(txt, simplifyDataFrame = TRUE, ...) {
  unq1 <- scan(text = txt, what = "", quiet = TRUE, quote = "\"")
  unq2 <- gsub("\\\"", "\"", unq1, fixed = TRUE)
  unq3 <- gsub("\\\\n", "\\n", unq2, fixed = TRUE)
  ret <- fromJSON(unq3, simplifyDataFrame = simplifyDataFrame, ...)
  if (simplifyDataFrame) ret <- tibble::as_tibble(ret)
  ret
}
