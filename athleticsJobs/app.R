# If you remove the pound sign below, you can run the line. Once it is done
# throw that pound back in there. If RStudio prompts you through the little
# yellow bar, just use that.

# install.packages(c("DT", "purrr", "rvest", "shiny", "shinyalert"))

library(DT)
library(purrr)
library(rvest)
library(shiny)
library(shinyalert)

# Run the line of code below to make sure that you can actually 
# access this file on your machine -- something like the following
# might be needed: "C:/Users/jbiddick/Documents/athleticsJobs.csv"

athleticsJobs <- read.csv("athleticsJobs.cvs") 

ui <- fluidPage(

    # Application title
    titlePanel("Jobs From Teamwork Online"),
        # Show a plot of the generated distribution
        mainPanel(
            useShinyalert(),
            actionButton("update", "Update Data"),
            DT::dataTableOutput("mytable")
        )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    RV <- reactiveValues(data = athleticsJobs)
    
    observeEvent(input$update, {
       shinyalert::shinyalert(title = "This might take a bit.", 
                              text = "Hold tight and the data will update.",
                              type = "info")
    })
    
    observeEvent(input$update, {
        baseLinks <- paste("https://www.teamworkonline.com/jobs-in-sports?page=", 1, 
                           sep = "")
        
        allJobLinks <- lapply(baseLinks, function(x) {
            read_html(x) %>% 
                html_nodes("a.result-item__link.link--underlined") %>% 
                html_attr("href") %>% 
                paste("https://www.teamworkonline.com", ., sep = "")
        })
        
        allJobLinks <- unlist(allJobLinks)
        
        allOut <- map_dfr(allJobLinks, ~{
            out <- tryCatch({
                allHTML <- read_html(.)
                
                title <- allHTML %>% 
                    html_nodes("h1.opportunity-preview__title") %>% 
                    html_text()
                
                jobType <- allHTML %>% 
                    html_nodes(".opportunity-preview__job-content") %>% 
                    html_text()
                
                description <- allHTML %>% 
                    html_nodes(".opportunity-preview__body") %>% 
                    html_text()
                
                out <- data.frame(title = ifelse(length(title) > 0, title, NA), 
                                  jobType = ifelse(length(jobType) > 0, jobType[length(jobType)], NA),
                                  description = ifelse(length(description) > 0, description, NA), 
                                  stringsAsFactors = FALSE) %>% 
                    tidyr::separate(col = title, into = c("title", "location"),
                                    sep = "\\sin\\s") %>% 
                    dplyr::mutate(location = gsub("\\s·\\s", ", ", location))
            }, 
            error = function(e){
                data.frame(title = NA, 
                           jobType = NA,
                           description = NA,
                           location = NA,
                           stringsAsFactors = FALSE)
            })
            return(out)
        })
        
        RV$data <- rbind(allOut, RV$data)
    }) 
    
    output$mytable = DT::renderDataTable({
        RV$data
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
