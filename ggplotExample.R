library(shiny)
library(ggplot2)
library(dplyr)

server <- function(input, output){
  
  diamondsFiltered <- reactive({
    diamonds %>% 
      filter(carat >= input$Carets[1] & carat <= input$Carets[2])
  })
  
  output$diamondsBar <- renderPlot({
    ggplot(data=diamondsFiltered(), aes(x=cut)) +
      geom_bar(fill="steelblue") +
      theme_classic() + labs( x = "Cut", 
                              y = "Count")
  })
  
}

ui <- fluidPage(
  br(),
  sliderInput("Carets",
              "Number of Carets in the Diamonds:",
              min = 0.3,
              max = max(diamonds$carat),
              value = c(1, 3),
              step = .1),
  plotOutput("diamondsBar")
)

shinyApp(ui, server)