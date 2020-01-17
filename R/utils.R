
`%||%` <- function(l, r) if (is.null(l)) r else l

str_trim <- function(x) {
  sub("\\s+$", "", sub("^\\s+", "", x))
}

#' @importFrom uuid UUIDgenerate

new_uuid <- function() {
  toupper(UUIDgenerate())
}

is_absolute_path <- function(path) {
  grepl("^~", path) | grepl("^(/+|[A-Za-z]:)", path)
}
