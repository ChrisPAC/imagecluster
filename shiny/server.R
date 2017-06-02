# server.R definition
server <- function(input, output){

  # Observes the second feature input for a change
  observeEvent(input$featureInput2,{

    # Create a convenience data.frame which can be used for charting
    plot.df <- data.frame(BreastCancer[,input$featureInput1],
                          BreastCancer[,input$featureInput2],
                          Class = BreastCancer$Class)

    # Add column names
    colnames(plot.df) <- c("x", "y", "Class")

    # Do a plotly contour plot to visualize the two featres with
    # the number of malignant cases as size
    # Note the use of 'source' argument
    output$Plot1 <- renderPlotly({
      plot_ly(plot.df, x = ~x, y = ~y, mode = "markers", type = "scatter", color = ~Class, source = "subset",
              marker = list(size = 30)) %>%
        layout(title = paste(input$featureInput1, "vs ", input$featureInput2),
               xaxis = list(title = input$featureInput1),
               yaxis = list(title = input$featureInput2),
               dragmode =  "select",
               plot_bgcolor = "6A446F")
    })

    # Create a contour plot of the number of malignant cases
    output$Plot2 <- renderPlotly({

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
                marker = list(opacity = 1)
        ) %>%
        layout(title = "Images", xaxis = ax, yaxis = ax)

    })

    # Assign to parent environment
    plot.df <<- plot.df
  })

  # Coupled event 1
  output$Plot3 <- renderPlotly({

    # Get subset based on selection
    event.data <- event_data("plotly_selected", source = "subset")
    print(event.data)
    # If NULL dont do anything
    if(is.null(event.data) == T) return(NULL)

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
  output$Plot4 <- renderImage({

    # Get subset based on selection
    event.data <- event_data("plotly_click", source = "select")

    # If NULL dont do anything
    if(is.null(event.data) == T) return(NULL)
    print(results[event.data[[2]]+1,3])
    
    list(src = paste0('../',results[event.data[[2]]+1,3]),
         contentType = 'image/png')
  })

}
