# Objective-C Binance API

BinanceAPI is a comprehensive Objective-C library for iOS and macOS. It can be used to interact with the various endpoints of the [Binance API](https://www.binance.com/restapipub.html). Both synchronous and asynchronous requests are supported. A rudimentary WebSocket implementation for event streaming is also provided. BinanceAPI is available as a [pod](https://cocoapods.org/pods/BinanceAPI) for easy installation via CocoaPods.

## API Endpoints
The [Binance REST API](https://www.binance.com/restapipub.html) is made up of four distinct endpoint types

* [General](https://www.binance.com/restapipub.html#user-content-general-endpoints)
* [Market Data](https://www.binance.com/restapipub.html#user-content-market-data-endpoints)
* [Account](https://www.binance.com/restapipub.html#user-content-account-endpoints)
* [User Stream](https://www.binance.com/restapipub.html#user-content-user-data-stream-endpoints)

This structure is reflected throughout the BinanceAPI library.

## CocoaPods
BinanceAPI's pod dependencies are included for convenience however, it is recommended that you set up your own CocoaPods environment by running:

```bash
$ (sudo) gem install cocoapods
```
and:

```bash
$ pod install
```

to keep up to date with the latest supported pod versions.

## Examples

For convenience, the examples provided are contained within an Xcode macOS unit test target. Simply run the test(s) to interact with the [Binance API](https://www.binance.com/restapipub.html).

### Prerequisites

In order to be able to interact with certain [Binance API](https://www.binance.com/restapipub.html) endpoints, you will need to be in possession of both a valid API and secret key. These can be generated in the [API section](https://www.binance.com/userCenter/createApi.html) of your Binance account. Replace the `YOUR-API-KEY` and `YOUR-SECRET-KEY` placeholders where appropriate to successfully interact with the API. Ensure that the respective checkmarks for trading and/or withdrawal are enabled when interacting with certain [Account](https://www.binance.com/restapipub.html#user-content-account-endpoints) endpoints.

### Getting Started

The [Binance API](https://www.binance.com/restapipub.html) library contains three client classes: 

1. [`BNBSynchronousRESTClient`](https://github.com/cbdite/BinanceAPI/blob/master/Classes/Clients/BNBSynchronousRESTClient.h) (blocking/not recommended)
2. [`BNBAsynchronousRESTClient`](https://github.com/cbdite/BinanceAPI/blob/master/Classes/Clients/BNBAsynchronousRESTClient.h) (non-blocking)
3. [`BNBWebSocketClient`](https://github.com/cbdite/BinanceAPI/blob/master/Classes/Clients/BNBWebSocketClient.h) (event streaming)

Instantiate the desired client with your API and secret key. Depending on the specific endpoint requirements specified at [Binance API](https://www.binance.com/restapipub.html), it may be necessary to add further endpoint paths to the respective `BNBHTTPSessionManager` class's signing or API collections. Only when contained within one of these collections will endpoint security be handled automatically.

```
BNBAsynchronousRESTClient *client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
```

Alternatively, when dealing with an open endpoint you can simply instantiate the desired client as follows:

```
BNBAsynchronousRESTClient *client = [BNBAsynchronousRESTClient new];
```
 
With the client instantiated, you are ready to fire requests at the API.

### General Endpoints

#### Test connectivity
```
[client testConnectivity:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Check server time
```
[client checkServerTime:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```

### Market Data Endpoints

#### Order book
```
[client orderBookForSymbol:@"LTCBTC" 
			 limit:10 
			result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Compressed/Aggregate trades list
```
[client aggregateTradesListForSymbol:@"LTCBTC"
			   fromId:NSNotFound
			startTime:-1.0 
		 	  endTime:-1.0 
			    limit:10 
			   result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Kline/candlesticks
```
[client klineDataForSymbol:@"LTCBTC" 
		    interval:FifteenMinutes 
		   startTime:-1.0 
		     endTime:-1.0
		       limit:10
		      result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### 24hr ticker price change statistics
```
[client priceChangeStatisticsTickerForSymbol:@"LTCBTC"
			interval:TwentyFourHours
			  result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Symbols price ticker
```
[client priceTickersResult:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Symbols order book ticker
```
[client orderBookTickersResult:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```

### Account Data Endpoints

#### New order (SIGNED)
```
[client createOrderWithSymbol:@"LTCBTC"
                  side:Buy
                  type:Limit
           timeInForce:GTC
              quantity:1.0
       icebergQuantity:0.0
                 price:0.005
             stopPrice:0.0
      newClientOrderId:nil
             timestamp:[NSDate millisecondTimeIntervalSince1970]
            timeToLive:5000
                result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Query order (SIGNED)
```
[client queryOrderWithSymbol:@"LTCBTC"
                    orderId:0
      originalClientOrderId:nil
                  timestamp:[NSDate millisecondTimeIntervalSince1970]
                 timeToLive:5000
                     result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Cancel order (SIGNED)
```
[client deleteOrderWithSymbol:@"LTCBTC"
                    orderId:0
      originalClientOrderId:nil
           newClientOrderId:nil
                  timestamp:[NSDate millisecondTimeIntervalSince1970]
                 timeToLive:5000
                     result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Current open orders (SIGNED)
```
[client openOrdersWithSymbol:@"LTCBTC"
                       timestamp:[NSDate millisecondTimeIntervalSince1970]
                      timeToLive:5000
                          result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### All orders (SIGNED)
```
[client allOrdersWithSymbol:@"LTCBTC"
                        orderId:0
                          limit:10
                      timestamp:[NSDate millisecondTimeIntervalSince1970]
                     timeToLive:5000
                         result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Account information (SIGNED)
```
[client accountInformationWithTimestamp:[NSDate millisecondTimeIntervalSince1970]
                                 timeToLive:5000
                                     result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Account trade list (SIGNED)
```
[client tradesWithSymbol:@"LTCBTC"
                      fromId:NSNotFound
                       limit:10
                   timestamp:[NSDate millisecondTimeIntervalSince1970]
                  timeToLive:5000
                      result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```

### User Stream Endpoints

#### Start user data stream (API-KEY)
```
[client createUserStream:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Keepalive user data stream (API-KEY)
```
[client updateUserStreamForListenKey:@""
                              result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```
#### Close user data stream (API-KEY)
```
[client deleteUserStreamForListenKey:@""
                              result:^(id  _Nullable responseObject, NSError * _Nullable error){}];
```

### WebSocket API

#### Depth Websocket Endpoint
```
BNBWebSocketClient *client = [BNBWebSocketClient webSocketClientWithURLString:@"wss://stream.binance.com:9443/ws/ltcbtc@depth"];
```
#### Kline Websocket Endpoint
```
BNBWebSocketClient *client = [BNBWebSocketClient webSocketClientWithURLString:@"wss://stream.binance.com:9443/ws/ltcbtc@kline_15m"];
```
#### Trades Websocket Endpoint
```
BNBWebSocketClient *client = [BNBWebSocketClient webSocketClientWithURLString:@"wss://stream.binance.com:9443/ws/ltcbtc@aggTrades"];
```
#### User Data Websocket Endpoint
```
BNBWebSocketClient *client = [BNBWebSocketClient webSocketClientWithURLString:@"wss://stream.binance.com:9443/ws/listenKey"];
```

Please refer to the respective tests for a more in depth treatment of the [Binance API](https://www.binance.com/restapipub.html) endpoints.

### ToDo
* Withdraw/getDepositHistory/getTradeHistory endpoint implementations
* Refactoring
* Documenting/Commenting