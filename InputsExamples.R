library(shiny)

server <- function(input, output) {
  
}

ui <- fluidPage(
  br(),
  fluidRow(
    column(4, 
           tags$h4("Check Box"),
           br(),
           checkboxGroupInput("checkboxGroupID",
                              "I'm a checkboxGroupInput",
                              c("MSA", 
                                "MSM",
                                "MSBA",
                                "MBA"),
                              inline = TRUE),
           br(),
           checkboxInput("checkboxInputID",
                         "I'm a checkboxInput")),
    column(4,
           tags$h4("Radio Buttons, selectInput, and SliderInput"),
           br(),
           radioButtons("radioButtonID",
                        "I'm a radioButton",
                        c("MSA",
                          "MSM",
                          "MSBA",
                          "MBA"),
                        select = "MBA",
                        inline = FALSE),
           br(),
           selectInput("selectInputID",
                       "I'm a selectInput",
                       c("MSA",
                         "MSM",
                         "MSBA",
                         "MBA"),
                       multiple = FALSE),
           br(),
           sliderInput("sliderInputID",
                       "I'm a sliderInput",
                       min = 0,
                       max = 100,
                       value = 50,
                       step = 5)),
    column(4,
           tags$h4("Numeric Input, Text Input, DateRange Input, and DateInput"),
           br(),
           numericInput("numericInputID",
                        "I'm a numericInput",
                        value = 10),
           br(),
           textInput("textInputID",
                     "I'm a textInput",
                     "enter text"),
           br(),
           dateRangeInput("dateRangeInputID",
                          "I'm a date range"),
           br(),
           dateInput("dateInputID",
                     "I'm a date input")
  )
))

shinyApp(ui, server)