# server.R definition
server <- function(input, output){

  # Coupled event 1
  output$Plot1 <- renderPlotly({

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
