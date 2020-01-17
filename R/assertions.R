
is_string <- function(x) {
  is_character(x) && length(x) == 1
}

is_character <- function(x) {
  is.character(x) && ! any(is.na(x))
}
