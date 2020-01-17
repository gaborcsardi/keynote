
#' @importFrom jsonlite unbox

slide <- R6Class(
  "slide",
  public = list(
    initialize = function(id, document, document_private,
                          num = NA, make_notes = FALSE) {
      private$id <- id
      private$document <- document
      private$document_private <- document_private
      private$doc_id <- document_private$document_id
      if (make_notes) private$make_notes(num)
      invisible(self)
    },

    get_number = function() private$find_myself(),

    get_contents = function() {
      num <- private$find_myself()
      if (is.null(num)) stop("Slide does not exist")
      out <- run_script("get-slide-contents", c(private$doc_id, num))
      parse_json(out$stdout)
    },

    set_title_text = function(text) {
      private$set_item_text("default title item", text)
    },

    set_body_text = function(text) {
      private$set_item_text("default body item", text)
    },

    set_title = function(rich_text) {
      private$set_item("default title item", rich_text)
    },

    set_body = function(rich_text) {
      private$set_item("default body item", rich_text)
    }
  ),

  private = list(
    id = NULL,
    document = NULL,
    document_private = NULL,
    doc_id = NULL,

    find_myself = function() {
      out <- run_script("find-slide-by-id", c(private$doc_id, private$id))
      num <- as.integer(out$stdout)
      if (num == 0) NULL else num
    },

    make_notes = function(num) {
      if (is.na(num)) stop("Internal error, cannot create slide")
      out <- run_script(
        "get-presenter-notes", c(private$doc_id, num))
      pn <- parse_string(out$stdout)
      pn2 <- add_config(pn, list(id = unbox(private$id)))
      run_script("set-presenter-notes", c(private$doc_id, num, pn2))
    },

    set_item_text = function(which, text) {
      num <- private$find_myself()
      if (is.null(num)) stop("Slide does not exist")
      text <- paste(text, collapse = "\n")
      out <- run_script("set-text-item", c(private$doc_id, num, which, text))
      invisible(self)
    },

    set_item = function(which, rich_text) {
      num <- private$find_myself()
      if (is.null(num)) stop("Slide does not exist")
      rich_text <- parse_rich_text(rich_text)
      with_clipboard(rich_text, {
        run_script("paste-into", c(private$doc_id, num, which))
      })
    }
  )
)

parse_string <- function(txt) {
  paste0("", scan(text = txt, quiet = TRUE, what = ""))
}
