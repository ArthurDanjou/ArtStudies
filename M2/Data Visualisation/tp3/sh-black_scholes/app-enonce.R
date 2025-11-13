# Original source : https://srdas.github.io/MLBook/Shiny.html#the-application-program

library(shiny)
library(plotly)
library(ggplot2)
library(ggthemes)



##### CONSIGNES #####
#  1. Completer le code du serveur (???) permet de compléter l'objet `output` (argument plotCall
# et plotPut). Il s'agit de deux figures qui permet de presenter la valeur 
# d'un call et d'un put en fonction du Strike K.

# 2. Compléter le code de l'ui (???) afin de creer des box affichant la valeur de l'action
# 'Stock Price' et du strike 'Strike Price'. Prendre par dééfaut la valeur 100.

# 3 . Sur la base du slider pour la Maturité, ajouter un slider pour la volatilité,
#  le taux sans risque et le taux de dividende.

# 4. Lancer l'application.

##### SERVER #####

# Define server logic for random distribution application
server <- function(input, output) {
    
    #Generate Black-Scholes values
    BS = function(S,K,T,v,rf,dv) {
        d1 = (log(S/K) + (rf-dv+0.5*v^2)*T)/(v*sqrt(T))
        d2 = d1 - v*sqrt(T)
        bscall = S*exp(-dv*T)*pnorm(d1) - K*exp(-rf*T)*pnorm(d2)
        bsput = -S*exp(-dv*T)*pnorm(-d1) + K*exp(-rf*T)*pnorm(-d2)
        res = c(bscall,bsput)
    }
    
    #Call option price
    output$BScall <- renderText({ 
        #Get inputs
        S = input$stockprice
        K = input$strike
        T = input$maturity
        v = input$volatility
        rf = input$riskfreerate
        dv = input$divrate
        res = round(BS(S,K,T,v,rf,dv)[1],4)
    })
    
    #Put option price
    output$BSput <- renderText({ 
        #Get inputs
        S = input$stockprice
        K = input$strike
        T = input$maturity
        v = input$volatility
        rf = input$riskfreerate
        dv = input$divrate
        res = round(BS(S,K,T,v,rf,dv)[2],4)
    })
    
    #Call plot
    output$plotCall <- renderPlotly({
        S = input$stockprice
        K = input$strike
        T = input$maturity
        v = input$volatility
        rf = input$riskfreerate
        dv = input$divrate
        vcall = NULL; vput = NULL
        strikes = seq(K-30,K+30)
        for (k in strikes) {
            vcall = ???
            vput = ???
        }
        df = data.frame(strikes,vcall,vput)
        p <- ggplot(???) + ???
        plotly::ggplotly(p)
    })
    
    #Put plot
    output$plotPut <- ???
    
}

##### UI #####

ui <- shinyUI(fluidPage(
    
    titlePanel("Black-Scholes-Merton (1973)"),
    
    sidebarLayout(
        sidebarPanel(
            numericInput(???,'Stock Price', ???),
            numericInput(???,'Strike Price', ???),
            sliderInput('maturity','Maturity (years)',min=0.1,max=10,value=1,step=0.01),
            sliderInput(???),
            sliderInput(???),
            sliderInput(???),
            hr(),
            p('Please refer to following for more details:',
              a("Black-Scholes (1973)", 
                href = "https://en.wikipedia.org/wiki/Black%E2%80%93Scholes_model")),
            hr()
        ),
        
        mainPanel(
            h2('European call price'),
            textOutput("BScall"),
            hr(),
            h2('European put price'),
            textOutput("BSput"),
            hr(),
            tabsetPanel(
                tabPanel("Calls", plotlyOutput("plotCall",width="100%")), 
                tabPanel("Puts", plotlyOutput("plotPut",width="100%")) 
            )
        )
    )  
))

##### Run #####
???