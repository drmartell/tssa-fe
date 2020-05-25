
#  tssa-fe

### TradeStation Semiautomatic Trader Front End

[TradeStation](https://www.tradestation.com/) has a Web API that they've been promoting lately although at time of writing they require a $100,000 funded account to grant access.

I'm interested in using this API to assist me in placing trades. I generally monitor the market using [TradingView](https://www.tradingview.com/) (which is quite excellent). Although TradingView allows order placement through TradeStation and several other brokers, there are limitations in their order entry interface that I would like to overcome.

My first thought was to use a browser on the front end, but I want a very minimalist interface and I'll need several instances running. Hence, instead the thought here is to create a lightweight front end in [AutoHotkey](https://www.autohotkey.com/) and connect that to a back end written in Node that will handle the trade construction logic and make the calls to the TradeStation API.

Shout out to [AutoGUI](https://www.autohotkey.com/boards/viewtopic.php?t=10157), a great GUI building tool and IDE for AutoHotkey.