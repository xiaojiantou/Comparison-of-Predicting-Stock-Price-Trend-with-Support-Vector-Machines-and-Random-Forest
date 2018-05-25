library(shiny)
library(shinydashboard)
library(ggplot2)
library(DT)
library(plotly)


symbs = c("MSFT","CERN","AAPL","AMAT","TXN","CA","KLAC","LRCX","MU",
  "INTC","ADI","WDC","ADBE","SYMC","CSCO","XLNX","QCOM",
  "INTU","NTAP","CTXS","CHKP","ADSK","CTSH","NVDA","AKAM",
  "GRMN","STX","BIDU")

features = c('Open','High','Low','Close','Volume','Adjusted')


originalData <- fluidPage(
  titlePanel(' Data Display'),
  fluidRow(
    column(4,
           selectizeInput('sym',label = h4('Select symbol'),choices = symbs,selected = 'AAPL',
                          options = list(create = TRUE))
    ),
    column(4,
           dateRangeInput('dates',label = h4('Date range'),
                          start = '2007-01-01',
                          end = '2015-01-01')
    ),
    column(4,
           selectizeInput('feature',label = h4('Select features'),choices = features,multiple = T,
                          selected = features))
  ),
  fluidRow(
    DT::dataTableOutput('table')
    ),
  fluidRow(
    plotlyOutput('stockPlot')
  )
)




ui <- dashboardPage(
  dashboardHeader(title = 'StoForc'),
  dashboardSidebar(
    tags$head(
      tags$link(rel = 'stylesheet',type = 'text/css', href = 'custom.css')
    ),
    sidebarMenu(
      menuItem('Introduction',tabName = 'intro', icon = icon('comment')),
      menuItem('Data', icon = icon('folder-open'),startExpanded=TRUE,
               div(class='disAdj'),
               menuSubItem(span(class='submenu','Original Data'),tabName = 'odata'),
               div(class='border',style='border-bottom: 1px solid #222d32;'),
               div(class='disAdj'),
               menuSubItem(span(class='submenu','Processed Data'),tabName = 'pdata')),
      menuItem('SVM Model',tabName = 'svm', icon = icon('pause')),
      menuItem('Our Model',tabName = 'model', icon = icon('barcode'))
    ),
    div(class='disAdj-border'),
    div(class='border',style='border-bottom: 1px solid #2c3b41;'),
    div(class='user-panel',
        div(class='pull-left image',
            img()),
        div(class='pull-left info',
            p(a('Zixiao Zhang')),
            p('zz2500'))
        ),
    div(class='user-panel',
        div(class='pull-left image',
            img()),
        div(class='pull-left info',
            p(a('Xuelun Li')),
            p('xl2678'))
    )
        
    
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = 'intro',
              h2('Introduction')
              ),
      tabItem(tabName = 'odata',
              originalData
              ),
      tabItem(tabName = 'pdata',
              h2('processed data')
              # some layout
              
              # fluidRow(
              #   box(plotOutput("plot1", height = 250)),
              #   
              #   box(
              #     title = "Controls",
              #     sliderInput("slider", "Number of observations:", 1, 100, 50)
              #   )
              # )
              
              ),
      tabItem(tabName = 'svm',
              h2('svm visualization')
              # some layout
              ),
      tabItem(tabName = 'model',
              h2('visualization')
              # some layout
              )
    )
  )
)