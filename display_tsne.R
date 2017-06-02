library(tidyverse)
library(Rtsne)
library(plotly)
library(RColorBrewer)

data <- read_csv('./data/distances.csv') %>% arrange(main_file, comp_file)

imagenames <- unique(data$main_file)

mat <- data %>%  
  spread(comp_file,distance) %>% 
  select(-main_file) %>% 
  as.matrix()

perplexity = 4
max.iteration = 100
tsne.ouput <- Rtsne::Rtsne(X = mat, 
                           dims = 2,
                           perplexity = perplexity,
                           max_iter = max.iteration, 
                           is_distance = TRUE)
tsne.coord <- tsne.ouput$Y
colnames(tsne.coord) <- c("X1", "X2")

results <- as_data_frame(tsne.coord) %>% mutate(imagename = imagenames)

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

htmlwidgets::saveWidget(tsne.daily.plot, "imagecluster.html")
