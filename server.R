library(shiny)
library(shinydashboard)
library(DT)
library(quantmod)

features = c("Open","High","Low","Close","Volume","Adjusted")


server <- function(input,output){
  
  stockData <- reactive({
    data.ac = getSymbols(input$sym,from = input$dates[1],to = input$dates[2],env = NULL)
    colnames(data.ac) = features
    return(data.frame(Date=index(data.ac),coredata(data.ac)))
  })
  
  plotElements <- reactive({
    bbands = BBands(stockData()[,c("High","Low","Close")])
    dataWB = subset(cbind(stockData(),data.frame(bbands[,1:3])),
                    Date >= input$dates[1] & Date <= input$dates[2])
    for(i in 1:length(dataWB[,1])){
      if(dataWB$Close[i] >= dataWB$Open[i]){
        dataWB$direction[i] = "Increasing"
      }else{
        dataWB$direction[i] = "Decreasing"
      }
    }
    
    inc = list(line=list(color="#17BECF"))
    dec = list(line=list(color="#7F7F7F"))
    p = dataWB %>%
      plot_ly(x=~Date, type="candlestick",
              open = ~Open, close = ~ Close,
              high = ~High, low = ~Low, name = input$sym,
              increasing = inc, decreasing = dec) %>%
      add_lines(x = ~Date, y = ~up , name = "B Bands",
                line = list(color = '#ccc', width = 0.5),
                legendgroup = "Bollinger Bands",
                hoverinfo = "none", inherit = F) %>%
      add_lines(x = ~Date, y = ~dn, name = "B Bands",
                line = list(color = '#ccc', width = 0.5),
                legendgroup = "Bollinger Bands", inherit = F,
                showlegend = FALSE, hoverinfo = "none") %>%
      add_lines(x = ~Date, y = ~mavg, name = "Mv Avg",
                line = list(color = '#E377C2', width = 0.5),
                hoverinfo = "none", inherit = F) %>%
      layout(title = paste("Historical Price Data Of ",input$sym),
             yaxis = list(title = "Price"),
             legend = list(orientation='h',
                           xanchor = 'center',
                           yanchor = 'top',
                           bgcolor = 'transparent',
                           x = 0.5, y = 1))

    return(p)
  })
  
  
  output$table <- DT::renderDataTable(DT::datatable({
    stockData()[,c("Date",input$feature)]
  }))
  
  output$stockPlot <- renderPlotly({
    plotElements()
  })
  output$debug_out <- renderPrint({

  })
}