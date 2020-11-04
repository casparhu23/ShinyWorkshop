library(shiny)
library(leaflet)
library(dplyr)
library(DT)
library(stringr)

bballArenas <- read.csv("https://raw.githubusercontent.com/jjenki22/ShinyWorkshop/main/Data/CollegeBBallArenas.csv")

server <- function(input, output) {
  
  selectedConf <- reactive({
    req(input$conferenceInput)
    bballArenas %>% 
      filter(CONF == input$conferenceInput)
  })
  
  output$teamsDT <- DT::renderDataTable(DT::datatable({
    selectedConf()
    }))
  
  arena_data <- reactive({
    team_arena_data <- selectedConf() %>% 
      mutate(popup = str_c(str_c("School: ", Team, sep = ""),
                           str_c("Arena: ", Arena, sep = ""),
                           str_c("City: ", City, sep = ""),
                           str_c("State: ", State, sep = ""),
                           str_c("Capacity: ", Capacity, sep = ""),
                           str_c("Conference: ", CONF, sep = ""),
                           sep = "<br/>"))
    team_arena_data
  })
  
  observeEvent(input$showMap, {
    output$Conf_Map <-renderLeaflet({
        ncaa_map <- leaflet(arena_data()) %>% 
          addProviderTiles("CartoDB.Positron")  %>% 
          setView(-98.35, 39.7,
                  zoom = 4) %>% 
          addMarkers(~Longitude, ~Latitude,
                     popup = ~popup)
        ncaa_map  
    }) 
  })
}

ui <- fluidPage(
  br(),
  fluidRow(
    column(9, 
           tags$b(tags$h1("Locations of College Basketball Arenas"))),
    column(3, 
           tags$img(src = "ncaa-logo-Floor.jpg",
                    height = 55))),
  sidebarLayout(
    sidebarPanel(
      selectInput("conferenceInput",
                  "Select a Conference(s)",
                  choices = bballArenas$CONF,
                  selectize = TRUE,
                  multiple = TRUE),
      actionButton("showMap",
                   "Show/Update Map",
                   class = "btn-primary"),
      radioButtons("displayTable",
                   "Do you want to display a table?",
                   c("Yes" = TRUE,
                     "No" = FALSE),
                   inline = TRUE,
                   selected = FALSE)),
    mainPanel(
      leafletOutput("Conf_Map"),
      br(),
      conditionalPanel(condition = "input.displayTable == 'TRUE'",
                       DT::dataTableOutput("teamsDT"))
    )))

shinyApp(ui, server)