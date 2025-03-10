#' Launch the freesearcheR tool locally
#'
#' @description
#' All data.frames in the global environment will be accessible through the app.
#'
#'
#' @param ... arguments passed on to `shiny::runApp()`
#'
#' @return shiny app
#' @export
#'
#' @examples
#' \dontrun{
#' data(mtcars)
#' shiny_freesearcheR(launch.browser = TRUE)
#' }
shiny_freesearcheR <- function(...) {
  appDir <- system.file("apps", "freesearcheR", package = "freesearcheR")
  if (appDir == "") {
    stop("Could not find the app directory. Try re-installing `freesearcheR`.", call. = FALSE)
  }

  a <- shiny::runApp(appDir = paste0(appDir,"/app.R"), ...)
  return(invisible(a))
}


#' Easily launch the freesearcheR app
#'
#' @param ... passed on to `shiny::runApp()`
#'
#' @returns shiny app
#' @export
#'
launch_freesearcheR <- function(...){
  shiny_freesearcheR(...)
}
