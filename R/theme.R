#' Custom theme based on unity
#'
#' @param ... everything passed on to bslib::bs_theme()
#'
#' @returns theme list
#' @export
custom_theme <- function(...,
                         version = 5,
                         primary = "#1E4A8F",
                         secondary = "#FF6F61",
                         # success = "#1E4A8F",
                         # info = ,
                         # warning = ,
                         # danger = ,
                         # fg = "#000",
                         # bg="#fff",
                         bootswatch = "united",
                         base_font = bslib::font_google("Montserrat"),
                         # base_font = bslib::font_google("Alice"),
                         # heading_font = bslib::font_google("Jost", wght = "800"),
                         # heading_font = bslib::font_google("Noto Serif"),
                         # heading_font = bslib::font_google("Alice"),
                         heading_font = bslib::font_google("Public Sans",wght = "700"),
                         code_font = bslib::font_google("Open Sans")){
  bslib::bs_theme(
    ...,
    version = version,
    primary = primary,
    secondary = secondary,
    bootswatch = bootswatch,
    base_font = base_font,
    heading_font = heading_font,
    code_font = code_font
  )
}
