# R
# Black-Scholes Shiny app — fixed plots for call and put

library(shiny)
library(plotly)
library(ggplot2)
library(ggthemes)

##### SERVER #####
server <- function(input, output) {
    
    # Generate Black-Scholes values
    BS = function(S, K, T, v, rf, dv) {
        d1 = (log(S/K) + (rf - dv + 0.5 * v^2) * T) / (v * sqrt(T))
        d2 = d1 - v * sqrt(T)
        bscall = S * exp(-dv * T) * pnorm(d1) - K * exp(-rf * T) * pnorm(d2)
        bsput  = -S * exp(-dv * T) * pnorm(-d1) + K * exp(-rf * T) * pnorm(-d2)
        c(bscall, bsput)
    }
    
    # Call option price
    output$BScall <- renderText({ 
        S = input$stockprice
        K = input$strike
        T = input$maturity
        v = input$volatility
        rf = input$riskfreerate
        dv = input$divrate
        round(BS(S, K, T, v, rf, dv)[1], 4)
    })
    
    # Put option price
    output$BSput <- renderText({ 
        S = input$stockprice
        K = input$strike
        T = input$maturity
        v = input$volatility
        rf = input$riskfreerate
        dv = input$divrate
        round(BS(S, K, T, v, rf, dv)[2], 4)
    })
    
    # Call plot (shows call and put curves across strikes)
    output$plotCall <- renderPlotly({
        S = input$stockprice
        K = input$strike
        T = input$maturity
        v = input$volatility
        rf = input$riskfreerate
        dv = input$divrate

        strikes = seq(K - 30, K + 30)
        vcall = sapply(strikes, function(k) BS(S, k, T, v, rf, dv)[1])
        vput  = sapply(strikes, function(k) BS(S, k, T, v, rf, dv)[2])

        df = data.frame(strikes = strikes, Call = vcall, Put = vput)
        p <- ggplot(df, aes(x = strikes)) + 
            geom_line(aes(y = Call, color = "Call")) + 
            geom_line(aes(y = Put, color = "Put")) + 
            labs(title = "Black-Scholes Option Pricing",
                 x = "Strike Price",
                 y = "Option Price") + 
            theme_minimal() +
            scale_color_manual("", values = c("Call" = "steelblue", "Put" = "firebrick"))
        plotly::ggplotly(p)
    })
    
    # Put plot (same curves — kept for tab separation)
    output$plotPut <- renderPlotly({
        S = input$stockprice
        K = input$strike
        T = input$maturity
        v = input$volatility
        rf = input$riskfreerate
        dv = input$divrate

        strikes = seq(K - 30, K + 30)
        vcall = sapply(strikes, function(k) BS(S, k, T, v, rf, dv)[1])
        vput  = sapply(strikes, function(k) BS(S, k, T, v, rf, dv)[2])

        df = data.frame(strikes = strikes, Call = vcall, Put = vput)
        p <- ggplot(df, aes(x = strikes)) + 
            geom_line(aes(y = Put, color = "Put")) + 
            geom_line(aes(y = Call, color = "Call")) + 
            labs(title = "Black-Scholes Option Pricing",
                 x = "Strike Price",
                 y = "Option Price") + 
            theme_minimal() +
            scale_color_manual("", values = c("Call" = "steelblue", "Put" = "firebrick"))
        plotly::ggplotly(p)
    })
}

##### UI #####
ui <- shinyUI(fluidPage(
    
    titlePanel("Black-Scholes-Merton (1973)"),
    
    sidebarLayout(
        sidebarPanel(
            numericInput('stockprice', 'Stock Price', 100),
            numericInput('strike', 'Strike Price', 100),
            sliderInput('maturity', 'Maturity (years)', min = 0.1, max = 10, value = 1, step = 0.01),
            sliderInput('volatility', 'Volatility (annualized)', min = 0.1, max = 2, value = 0.2, step = 0.01),
            sliderInput('riskfreerate', 'Risk-free Rate (annualized)', min = 0, max = 0.5, value = 0.01, step = 0.01),
            sliderInput('divrate', 'Dividend Yield (annualized)', min = 0, max = 0.5, value = 0, step = 0.01),
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
                tabPanel("Calls", plotlyOutput("plotCall", width = "100%")), 
                tabPanel("Puts",  plotlyOutput("plotPut",  width = "100%")) 
            )
        )
    )  
))

##### Run ##### 
shinyApp(ui = ui, server = server)