library(shiny)
library(mlbench)
library(plotly)
library(shinythemes)
library(dplyr)

results <- read_csv("../data/tsne_results.csv")

# ui.R definition
ui <- fluidPage(
  # Set theme
  theme = shinytheme("spacelab"),

  # Some help text
  h2("Coupled events in plotly charts using Shiny"),
  h4("This Shiny app showcases coupled events using Plotly's ", tags$code("event_data()"), " function."),
  tags$ol(
    tags$li("The first chart showcases", tags$code("plotly_selected")),
    tags$li("The third chart showcases", tags$code("plotly_click"))
  ),

  # Vertical space
  tags$hr(),

  # First row
  fixedRow(
    column(6, plotlyOutput("Plot1", height = "600px")),
    column(6, imageOutput("Plot2", height = "600px")))

  )
