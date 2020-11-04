library(shiny)
library(dplyr)

schedule <- read.csv("https://raw.githubusercontent.com/jjenki22/ShinyWorkshop/main/Data/NDSchedule.csv")

ui <- fluidPage(
  br(),
  column(3,
         selectInput("teamSelected",
                     "Select an Opponent:",
                     choices = schedule$Opponent)),
  column(9,
         textOutput("text"))
)

server <- function(input, output) {
  
  output$text <- renderText({
    selectedGame <- schedule %>% 
      filter(Opponent == input$teamSelected)
    paste("Notre Dame will play ",
          selectedGame$Opponent,
          " on ",
          as.character(selectedGame$Date),
          " at ",
          as.character(selectedGame$GameTime),
          " in ",
          as.character(selectedGame$Location),
          ".",
          sep = "")
  })
}

shinyApp(ui, server)