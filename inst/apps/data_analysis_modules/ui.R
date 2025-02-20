# ns <- NS(id)

ui_elements <- list(
  ##############################################################################
  #########
  #########  Home panel
  #########
  ##############################################################################
  "home" = bslib::nav_panel(
    title = "freesearcheR",
    shiny::markdown(readLines("www/intro.md")),
    icon = shiny::icon("home")
  ),
  ##############################################################################
  #########
  #########  Import panel
  #########
  ##############################################################################
  "import" = bslib::nav_panel(
    title = "Import",
    shiny::h4("Choose your data source"),
    shiny::br(),
    shinyWidgets::radioGroupButtons(
      inputId = "source",
      selected = "env",
      # label = "Choice: ",
      choices = c(
        "File upload" = "file",
        "REDCap server" = "redcap",
        "Local data" = "env"
      ),
      # checkIcon = list(
      #   yes = icon("square-check"),
      #   no = icon("square")
      # ),
      width = "100%"
    ),
    shiny::helpText("Upload a file from your device, get data directly from REDCap or select a sample data set for testing from the app."),
    shiny::conditionalPanel(
      condition = "input.source=='file'",
      datamods::import_file_ui("file_import",
        title = "Choose a datafile to upload",
        file_extensions = c(".csv", ".txt", ".xls", ".xlsx", ".rds", ".fst", ".sas7bdat", ".sav", ".ods", ".dta")
      )
    ),
    shiny::conditionalPanel(
      condition = "input.source=='redcap'",
      m_redcap_readUI("redcap_import")
    ),
    shiny::conditionalPanel(
      condition = "input.source=='env'",
      import_globalenv_ui(id = "env", title = NULL)
    ),
    shiny::conditionalPanel(
      condition = "input.source=='redcap'",
      DT::DTOutput(outputId = "redcap_prev")
    ),
    shiny::br(),
    shiny::br(),
    shiny::h5("Exclude in-complete variables"),
    shiny::p("Before going further, you can exclude variables with a low degree of completeness."),
    shiny::br(),
    shiny::sliderInput(
      inputId = "complete_cutoff",
      label = "Choose completeness threshold (%)",
      min = 0,
      max = 100,
      step = 10,
      value = 70,
      ticks = FALSE
    ),
    shiny::helpText("Only include variables with completeness above a specified percentage."),
    shiny::br(),
    shiny::br(),
    shiny::actionButton(
      inputId = "act_start",
      label = "Start",
      width = "100%",
      icon = shiny::icon("play")
    ),
    shiny::helpText('After importing, hit "Start" or navigate to the desired tab.'),
    shiny::br(),
    shiny::br()
  ),
  ##############################################################################
  #########
  #########  Data overview panel
  #########
  ##############################################################################
  "overview" =
  # bslib::nav_panel_hidden(
    bslib::nav_panel(
      # value = "overview",
      title = "Data",
      bslib::navset_bar(
        fillable = TRUE,
        bslib::nav_panel(
          title = "Summary & filter",
          tags$h3("Data summary and filtering"),
          fluidRow(
            shiny::column(
              width = 9,
              shiny::tags$p(
                "Below is a short summary table of the provided data.
              On the right hand side you have the option to create filters.
              At the bottom you'll find a raw overview of the original vs the modified data."
              )
            )
          ),
          fluidRow(
            # column(
            #   width = 3,
            #   shiny::uiOutput("filter_vars"),
            #   shiny::conditionalPanel(
            #     condition = "(typeof input.filter_vars !== 'undefined' && input.filter_vars.length > 0)",
            #     datamods::filter_data_ui("filtering", max_height = "500px")
            #   )
            # ),
            # column(
            #   width = 9,
            #   DT::DTOutput(outputId = "filtered_table"),
            #   tags$b("Code dplyr:"),
            #   verbatimTextOutput(outputId = "filtered_code")
            # ),
            shiny::column(
              width = 9,
              data_summary_ui(id = "data_summary")
            ),
            shiny::column(
              width = 3,
              IDEAFilter::IDEAFilter_ui("data_filter"),
              shiny::tags$br(),
              shiny::tags$b("Filter code:"),
              shiny::verbatimTextOutput(outputId = "filtered_code"),
              shiny::tags$br()
            )
          ),
          fluidRow(
            column(
              width = 6,
              tags$b("Original data:"),
              # verbatimTextOutput("original"),
              verbatimTextOutput("original_str")
            ),
            column(
              width = 6,
              tags$b("Modified data:"),
              # verbatimTextOutput("modified"),
              verbatimTextOutput("modified_str")
            )
          )
        ),
        # bslib::nav_panel(
        #   title = "Overview",
        #   DT::DTOutput(outputId = "table")
        # ),
        bslib::nav_panel(
          title = "Modify",
          tags$h3("Subset, rename and convert variables"),
          fluidRow(
            shiny::column(
              width = 9,
              shiny::tags$p("Below, you can subset the data (select variables to include on clicking 'Apply changes'), rename variables, set new labels (for nicer tables in the report) and change variable classes (numeric, factor/categorical etc.).
                            Italic text can be edited/changed.
                            On the right, you can create and modify factor/categorical variables as well as resetting the data to the originally imported data.")
            )
          ),
          fluidRow(
            shiny::column(
              width = 9,
              update_variables_ui("vars_update"),
              shiny::tags$br()
            ),
            shiny::column(
              width = 3,
              tags$h4("Create new variables"),
              shiny::tags$br(),
              shiny::actionButton(
                inputId = "modal_cut",
                label = "Create factor variable",
                width = "100%"
              ),
              shiny::tags$br(),
              shiny::helpText("Create factor/categorical variable from an other value."),
              shiny::tags$br(),
              shiny::tags$br(),
              shiny::actionButton(
                inputId = "modal_update",
                label = "Reorder factor levels",
                width = "100%"
              ),
              shiny::tags$br(),
              shiny::helpText("Reorder the levels of factor/categorical variables."),
              shiny::tags$br(),
              shiny::tags$br(),
              shiny::actionButton(
                inputId = "modal_column",
                label = "New variable",
                width = "100%"
              ),
              shiny::tags$br(),
              shiny::helpText("Create a new variable/column based on an R-expression."),
              shiny::tags$br(),
              shiny::tags$br(),
              tags$h4("Restore"),
              shiny::actionButton(
                inputId = "data_reset",
                label = "Restore original data",
                width = "100%"
              ),
              shiny::tags$br(),
              shiny::helpText("Reset to original imported dataset. Careful! There is no un-doing."),
              shiny::tags$br() # ,
              # shiny::tags$br(),
              # shiny::tags$br(),
              # IDEAFilter::IDEAFilter_ui("data_filter") # ,
              # shiny::actionButton("save_filter", "Apply the filter")
            )
            # datamods::update_variables_ui("vars_update")
          )
        ),
        bslib::nav_panel(
          title = "Browser",
          tags$h3("Browse the provided data"),
          shiny::tags$p(
            "Below is a data table with all the modified data provided to browse and understand data."
          ),
          shinyWidgets::html_dependency_winbox(),
          # fluidRow(
          # column(
          #   width = 3,
          #   shiny::uiOutput("filter_vars"),
          #   shiny::conditionalPanel(
          #     condition = "(typeof input.filter_vars !== 'undefined' && input.filter_vars.length > 0)",
          #     datamods::filter_data_ui("filtering", max_height = "500px")
          #   )
          # ),
          # column(
          #   width = 9,
          #   DT::DTOutput(outputId = "filtered_table"),
          #   tags$b("Code dplyr:"),
          #   verbatimTextOutput(outputId = "filtered_code")
          # ),
          # shiny::column(
          #   width = 8,
          fluidRow(
            toastui::datagridOutput(outputId = "table_mod")
          ),
          shiny::tags$br(),
          shiny::tags$br(),
          shiny::tags$br(),
          shiny::tags$br(),
          shiny::tags$br()
          # ,
          # shiny::tags$b("Reproducible code:"),
          # shiny::verbatimTextOutput(outputId = "filtered_code")
          #   ),
          #   shiny::column(
          #     width = 4,
          #     shiny::actionButton("modal_cut", "Create factor from a variable"),
          #     shiny::tags$br(),
          #     shiny::tags$br(),
          #     shiny::actionButton("modal_update", "Reorder factor levels")#,
          #     # shiny::tags$br(),
          #     # shiny::tags$br(),
          #     # IDEAFilter::IDEAFilter_ui("data_filter") # ,
          #     # shiny::actionButton("save_filter", "Apply the filter")
          #   )
          # )
        )


        # column(
        #   8,
        #   shiny::verbatimTextOutput("filtered_code"),
        #   DT::DTOutput("filtered_table")
        # ),
        # column(4, IDEAFilter::IDEAFilter_ui("data_filter"))
      )
    ),
  ##############################################################################
  #########
  #########  Descriptive analyses panel
  #########
  ##############################################################################
  "describe" =
    bslib::nav_panel(
      title = "Evaluate",
      id = "navdescribe",
      bslib::navset_bar(
        title = "",
        # bslib::layout_sidebar(
        #   fillable = TRUE,
        sidebar = bslib::sidebar(
          bslib::accordion(
            open = "acc_chars",
            multiple = FALSE,
            bslib::accordion_panel(
              value = "acc_chars",
              title = "Characteristics",
              icon = bsicons::bs_icon("table"),
              shiny::uiOutput("strat_var"),
              shiny::helpText("Only factor/categorical variables are available for stratification. Go back to the 'Data' tab to reclass a variable if it's not on the list."),
              shiny::conditionalPanel(
                condition = "input.strat_var!='none'",
                shiny::radioButtons(
                  inputId = "add_p",
                  label = "Compare strata?",
                  selected = "no",
                  inline = TRUE,
                  choices = list(
                    "No" = "no",
                    "Yes" = "yes"
                  )
                ),
                shiny::helpText("Option to perform statistical comparisons between strata in baseline table.")
              )
            ),
            bslib::accordion_panel(
              vlaue = "acc_cor",
              title = "Correlations",
              icon = bsicons::bs_icon("table"),
              shiny::uiOutput("outcome_var_cor"),
              shiny::helpText("This variable will be excluded from the correlation plot."),
              shiny::br(),
              shiny::sliderInput(
                inputId = "cor_cutoff",
                label = "Correlation cut-off",
                min = 0,
                max = 1,
                step = .02,
                value = .8,
                ticks = FALSE
              )
            )
          )
        ),
        bslib::nav_panel(
          title = "Baseline characteristics",
          gt::gt_output(outputId = "table1")
        ),
        bslib::nav_panel(
          title = "Variable correlations",
          data_correlations_ui(id = "correlations", height = 600)
        )
      )
    ),
  ##############################################################################
  #########
  #########  Regression analyses panel
  #########
  ##############################################################################
  "analyze" =
    bslib::nav_panel(
      title = "Regression",
      id = "navanalyses",
      bslib::navset_bar(
        title = "",
        # bslib::layout_sidebar(
        #   fillable = TRUE,
        sidebar = bslib::sidebar(
          bslib::accordion(
            open = "acc_reg",
            multiple = FALSE,
            bslib::accordion_panel(
              value = "acc_reg",
              title = "Regression",
              icon = bsicons::bs_icon("calculator"),
              shiny::uiOutput("outcome_var"),
              # shiny::selectInput(
              #   inputId = "design",
              #   label = "Study design",
              #   selected = "no",
              #   inline = TRUE,
              #   choices = list(
              #     "Cross-sectional" = "cross-sectional"
              #   )
              # ),
              shiny::uiOutput("regression_type"),
              shiny::radioButtons(
                inputId = "add_regression_p",
                label = "Add p-value",
                inline = TRUE,
                selected = "yes",
                choices = list(
                  "Yes" = "yes",
                  "No" = "no"
                )
              ),
              bslib::input_task_button(
                id = "load",
                label = "Analyse",
                # icon = shiny::icon("pencil", lib = "glyphicon"),
                icon = bsicons::bs_icon("pencil"),
                label_busy = "Working...",
                icon_busy = fontawesome::fa_i("arrows-rotate",
                  class = "fa-spin",
                  "aria-hidden" = "true"
                ),
                type = "secondary",
                auto_reset = TRUE
              ),
              shiny::helpText("Press 'Analyse' again after changing parameters."),
              shiny::tags$br(),
              shiny::uiOutput("plot_model")
            ),
            bslib::accordion_panel(
              value = "acc_advanced",
              title = "Advanced",
              icon = bsicons::bs_icon("gear"),
              shiny::radioButtons(
                inputId = "all",
                label = "Specify covariables",
                inline = TRUE, selected = 2,
                choiceNames = c(
                  "Yes",
                  "No"
                ),
                choiceValues = c(1, 2)
              ),
              shiny::conditionalPanel(
                condition = "input.all==1",
                shiny::uiOutput("include_vars")
              )
            )
          ),
          # shiny::helpText(em("Please specify relevant settings for your data, and press 'Analyse'")),
          # shiny::radioButtons(
          #   inputId = "specify_factors",
          #   label = "Specify categorical variables?",
          #   selected = "no",
          #   inline = TRUE,
          #   choices = list(
          #     "Yes" = "yes",
          #     "No" = "no"
          #   )
          # ),
          # shiny::conditionalPanel(
          #   condition = "input.specify_factors=='yes'",
          #   shiny::uiOutput("factor_vars")
          # ),
          # shiny::conditionalPanel(
          #   condition = "output.ready=='yes'",
          # shiny::tags$hr(),
        ),
        bslib::nav_panel(
          title = "Regression table",
          gt::gt_output(outputId = "table2")
        ),
        bslib::nav_panel(
          title = "Coefficient plot",
          shiny::plotOutput(outputId = "regression_plot")
        ),
        bslib::nav_panel(
          title = "Model checks",
          shiny::plotOutput(outputId = "check")
          # shiny::uiOutput(outputId = "check_1")
        )
      )
    ),
  ##############################################################################
  #########
  #########  Download panel
  #########
  ##############################################################################
  "download" =
    bslib::nav_panel(
      title = "Download",
      id = "navdownload",
      shiny::fluidRow(
        shiny::column(
          width = 6,
          shiny::h4("Report"),
          shiny::helpText("Choose your favourite output file format for further work, and download, when the analyses are done."),
          shiny::selectInput(
            inputId = "output_type",
            label = "Output format",
            selected = NULL,
            choices = list(
              "MS Word" = "docx",
              "LibreOffice" = "odt"
              # ,
              # "PDF" = "pdf",
              # "All the above" = "all"
            )
          ),
          shiny::br(),
          # Button
          shiny::downloadButton(
            outputId = "report",
            label = "Download report",
            icon = shiny::icon("download")
          )
          # shiny::helpText("If choosing to output to MS Word, please note, that when opening the document, two errors will pop-up. Choose to repair and choose not to update references. The issue is being worked on. You can always choose LibreOffice instead."),
        ),
        shiny::column(
          width = 6,
          shiny::h4("Data"),
          shiny::helpText("Choose your favourite output data format to download the modified data."),
          shiny::selectInput(
            inputId = "data_type",
            label = "Data format",
            selected = NULL,
            choices = list(
              "R" = "rds",
              "stata" = "dta",
              "CSV" = "csv"
            )
          ),
          shiny::br(),
          # Button
          shiny::downloadButton(
            outputId = "data_modified",
            label = "Download data",
            icon = shiny::icon("download")
          )
        )
      ),
      shiny::br()
    ),
  ##############################################################################
  #########
  #########  Documentation panel
  #########
  ##############################################################################
  "docs" = bslib::nav_item(
    # shiny::img(shiny::icon("book")),
    shiny::tags$a(
      href = "https://agdamsbo.github.io/freesearcheR/",
      "Docs (external)",
      target = "_blank",
      rel = "noopener noreferrer"
    )
  )
  #   bslib::nav_panel(
  #   title = "Documentation",
  #   # shiny::tags$iframe("www/docs.html", height=600, width=535),
  #   shiny::htmlOutput("docs_file"),
  #   shiny::br()
  # )
)
# Initial attempt at creating light and dark versions
light <- custom_theme()
dark <- custom_theme(
  bg = "#000",
  fg = "#fff"
)

# Fonts to consider:
# https://webdesignerdepot.com/17-open-source-fonts-youll-actually-love/

ui <- bslib::page_fixed(
  shiny::tags$head(includeHTML(("www/umami-app.html"))),
  shiny::tags$style(
    type = "text/css",
    # add the name of the tab you want to use as title in data-value
    shiny::HTML(
      ".container-fluid > .nav > li >
                        a[data-value='freesearcheR'] {font-size: 28px}"
    )
  ),
  title = "freesearcheR",
  theme = light,
  shiny::useBusyIndicators(),
  bslib::page_navbar(
    id = "main_panel",
    ui_elements$home,
    ui_elements$import,
    ui_elements$overview,
    ui_elements$describe,
    ui_elements$analyze,
    ui_elements$download,
    bslib::nav_spacer(),
    ui_elements$docs,
    fillable = FALSE,
    footer = shiny::tags$footer(
      style = "background-color: #14131326; padding: 4px; text-align: center; bottom: 0; width: 100%;",
      shiny::p(
        style = "margin: 1",
        "Data is only stored for analyses and deleted immediately afterwards."
      ),
      shiny::p(
        style = "margin: 1; color: #888;",
        "AG Damsbo | v", app_version(), " | AGPLv3 license | ", shiny::tags$a("Source on Github", href = "https://github.com/agdamsbo/freesearcheR/", target = "_blank", rel = "noopener noreferrer")
      ),
    )
  )
)
