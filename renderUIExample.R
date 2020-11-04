library(shiny)

schedule <- read.csv("https://raw.githubusercontent.com/jjenki22/ShinyWorkshop/main/Data/NDSchedule.csv")

server <- function(input, output) {
  output$TeamSelectedUIOutput <- renderUI({
    selectInput("teamSelected",
                "Select an Opponent:",
                choices = schedule$Opponent)
  })
  
  output$text <- renderText({
    req(input$teamSelected)
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

ui <- fluidPage(
  br(),
  column(5,
         uiOutput("TeamSelectedUIOutput")),
  column(7,
         textOutput("text"))
)

shinyApp(ui, server)