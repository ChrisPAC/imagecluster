library(shiny)
library(mlbench)
library(plotly)
library(shinythemes)
library(tidyverse)

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

# server.R definition
server <- function(input, output){
  
  # Coupled event 1
  output$Plot1 <- renderPlotly({
    ax <- list(
      title = "",
      zeroline = FALSE,
      showline = FALSE,
      showticklabels = FALSE,
      showgrid = FALSE
    )
    tsne.daily.plot <- 
      plot_ly(results,
              x = ~X1, y = ~X2, 
              type = "scatter",
              mode = "markers",
              hoverinfo = "text",
              text = ~imagename,
              #color = ~log(Weight),
              #colors = brewer.pal(9,"Paired"),
              #size = ~Size,
              #sizes = c(8,30),
              marker = list(opacity = 1),
              source = "select"
      ) %>%
      layout(title = "Images", xaxis = ax, yaxis = ax)
    
  })
  
  # Coupled event 2
  output$Plot2 <- renderImage({
    
    # Get subset based on selection
    event.data <- event_data("plotly_click", source = "select")
    
    # If NULL dont do anything
    if(is.null(event.data) == T) 
      list(src = paste0('../',results[1,3]),
           contentType = 'image/png')
    else
      list(src = paste0('../',results[event.data[[2]]+1,3]),
           contentType = 'image/png')
  }, delete = FALSE)
  
}

shinyApp(ui, server)