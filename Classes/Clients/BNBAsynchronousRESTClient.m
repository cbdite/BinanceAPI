// BNBAsynchronousRESTClient.m
// Copyright (c) 2017 Chris Dite
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BNBAsynchronousRESTClient.h"

#import "BNBHTTPSessionManager.h"
#import "BNBUtilities.h"

@interface BNBAsynchronousRESTClient ()

@property (readwrite, copy, nonatomic) NSString *APIKey;

@property (readwrite, copy, nonatomic) NSString *secretKey;

@end

@implementation BNBAsynchronousRESTClient

#pragma mark - Initialization

- (instancetype)initWithAPIKey:(NSString *)APIKey
                     secretKey:(NSString *)secretKey
{
    if (self = [super init])
    {
        self.APIKey = APIKey;
        self.secretKey = secretKey;
    }
    
    return self;
}

#pragma mark - General Endpoint Methods

// GET /api/v1/ping
- (void)testConnectivity:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/ping"
             parameters:nil
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

// GET /api/v1/time
- (void)checkServerTime:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/time"
             parameters:nil
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

#pragma mark - Market Data Endpoint Methods

// GET /api/v1/depth
- (void)orderBookForSymbol:(NSString *)symbol
                    result:(nullable ResultBlock)result
{
    [self orderBookForSymbol:symbol
                       limit:NSNotFound
                      result:result];
}

// GET /api/v1/depth
- (void)orderBookForSymbol:(NSString *)symbol
                     limit:(NSUInteger)limit
                    result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    if (limit != NSNotFound)
    {
        NSUInteger canonicalLimit = MIN(limit, 100);
        
        parameters[@"limit"] = @(canonicalLimit);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/depth"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

// GET /api/v1/aggTrades
- (void)aggregateTradesListForSymbol:(NSString *)symbol
                              result:(nullable ResultBlock)result
{
    [self aggregateTradesListForSymbol:symbol
                                fromId:NSNotFound
                             startTime:-1.0
                               endTime:-1.0
                                 limit:NSNotFound
                                result:result];
}

// GET /api/v1/aggTrades
- (void)aggregateTradesListForSymbol:(NSString *)symbol
                              fromId:(NSUInteger)fromId
                           startTime:(NSTimeInterval)startTime
                             endTime:(NSTimeInterval)endTime
                               limit:(NSUInteger)limit
                              result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    if (fromId != NSNotFound)
    {
        parameters[@"fromId"] = @(fromId);
    }
    
    if (startTime >= 0.0)
    {
        parameters[@"startTime"] = @([NSNumber numberWithDouble:startTime].longLongValue);
    }
    
    if (endTime >= 0.0)
    {
        parameters[@"endTime"] = @([NSNumber numberWithDouble:endTime].longLongValue);
    }
    
    if (startTime >= 0.0 && endTime >= 0.0)
    {
        NSTimeInterval timeInterval = endTime - startTime;
        
        CGFloat hours = timeInterval/3600.0;
        
        if (hours >= 24.0)
        {
            @throw
            [NSException exceptionWithName:@"Invalid time interval"
                                    reason:@"The time interval defined by startTime/endTime must be less than 24 hours"
                                  userInfo:nil];
        }
    }
    else
    {
        if (limit != NSNotFound)
        {
            NSUInteger canonicalLimit = MIN(limit, 500);
            
            parameters[@"limit"] = @(canonicalLimit);
        }
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/aggTrades"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

// GET /api/v1/klines
- (void)klineDataForSymbol:(NSString *)symbol
                  interval:(BNBInterval)interval
                    result:(nullable ResultBlock)result
{
    [self klineDataForSymbol:symbol
                    interval:interval
                   startTime:-1.0
                     endTime:-1.0
                       limit:NSNotFound
                      result:result];
}

// GET /api/v1/klines
- (void)klineDataForSymbol:(NSString *)symbol
                  interval:(BNBInterval)interval
                 startTime:(NSTimeInterval)startTime
                   endTime:(NSTimeInterval)endTime
                     limit:(NSUInteger)limit
                    result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSString *intervalString = Interval_toString[interval];
    
    NSParameterAssert(intervalString);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    parameters[@"interval"] = intervalString;
    
    if (startTime >= 0.0)
    {
        parameters[@"startTime"] = @([NSNumber numberWithDouble:startTime].longLongValue);
    }
    
    if (endTime >= 0.0)
    {
        parameters[@"endTime"] = @([NSNumber numberWithDouble:endTime].longLongValue);
    }
    
    if (limit != NSNotFound)
    {
        NSUInteger canonicalLimit = MIN(limit, 500);
        
        parameters[@"limit"] = @(canonicalLimit);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/klines"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

/*
 * Interval currently defaults to 24hr
 */

// GET /api/v1/ticker/24hr
- (void)priceChangeStatisticsTickerForSymbol:(NSString *)symbol
                                    interval:(BNBInterval)interval
                                      result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSDictionary *parameters = @{@"symbol": symbol};
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/ticker/24hr"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

// GET /api/v1/ticker/allPrices
- (void)priceTickersResult:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/ticker/allPrices"
             parameters:nil
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

// GET /api/v1/ticker/allBookTickers
- (void)orderBookTickersResult:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    [sessionManager GET:@"/api/v1/ticker/allBookTickers"
             parameters:nil
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
}

#pragma mark - Account Endpoint Methods

// POST /api/v3/order/test
- (void)testCreateOrderWithSymbol:(NSString *)symbol
                             side:(BNBOrderSide)side
                             type:(BNBOrderType)type
                      timeInForce:(BNBTimeInForce)timeInForce
                         quantity:(CGFloat)quantity
                  icebergQuantity:(CGFloat)icebergQuantity
                            price:(CGFloat)price
                        stopPrice:(CGFloat)stopPrice
                 newClientOrderId:(nullable NSString *)newClientOrderId
                        timestamp:(NSTimeInterval)timestamp
                       timeToLive:(NSTimeInterval)timeToLive
                           result:(nullable ResultBlock)result
{
    [self createOrderWithSymbol:symbol
                           side:side
                           type:type
                    timeInForce:timeInForce
                       quantity:quantity
                icebergQuantity:icebergQuantity
                          price:price
                      stopPrice:stopPrice
               newClientOrderId:newClientOrderId
                      timestamp:timestamp
                     timeToLive:timeToLive
                         result:result
                      URLString:@"/api/v3/order/test"];
}

// POST /api/v3/order
- (void)createOrderWithSymbol:(NSString *)symbol
                         side:(BNBOrderSide)side
                         type:(BNBOrderType)type
                  timeInForce:(BNBTimeInForce)timeInForce
                     quantity:(CGFloat)quantity
              icebergQuantity:(CGFloat)icebergQuantity
                        price:(CGFloat)price
                    stopPrice:(CGFloat)stopPrice
             newClientOrderId:(nullable NSString *)newClientOrderId
                    timestamp:(NSTimeInterval)timestamp
                   timeToLive:(NSTimeInterval)timeToLive
                       result:(nullable ResultBlock)result
{
    [self createOrderWithSymbol:symbol
                           side:side
                           type:type
                    timeInForce:timeInForce
                       quantity:quantity
                icebergQuantity:icebergQuantity
                          price:price
                      stopPrice:stopPrice
               newClientOrderId:newClientOrderId
                      timestamp:timestamp
                     timeToLive:timeToLive
                         result:result
                      URLString:@"api/v3/order"];
}

// POST /api/v3/order
- (void)createOrderWithSymbol:(NSString *)symbol
                         side:(BNBOrderSide)side
                         type:(BNBOrderType)type
                  timeInForce:(BNBTimeInForce)timeInForce
                     quantity:(CGFloat)quantity
              icebergQuantity:(CGFloat)icebergQuantity
                        price:(CGFloat)price
                    stopPrice:(CGFloat)stopPrice
             newClientOrderId:(nullable NSString *)newClientOrderId
                    timestamp:(NSTimeInterval)timestamp
                   timeToLive:(NSTimeInterval)timeToLive
                       result:(nullable ResultBlock)result
                    URLString:(NSString *)URLString
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    NSString *sideString = OrderSide_toString[side];
    
    NSParameterAssert(sideString);
    
    parameters[@"side"] = sideString;
    
    NSString *typeString = OrderType_toString[type];
    
    NSParameterAssert(typeString);
    
    parameters[@"type"] = typeString;
    
    NSString *timeInForceString = TimeInForce_toString[timeInForce];
    
    NSParameterAssert(timeInForceString);
    
    parameters[@"timeInForce"] = timeInForceString;
    
    parameters[@"quantity"] = @(quantity);
    
    if (icebergQuantity > 0.0)
    {
        parameters[@"icebergQuantity"] = @(icebergQuantity);
    }
    
    parameters[@"price"] = @(price);
    
    if (stopPrice > 0.0)
    {
        parameters[@"stopPrice"] = @(stopPrice);
    }
    
    if (newClientOrderId)
    {
        parameters[@"newClientOrderId"] = newClientOrderId;
    }
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager POST:URLString
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// GET /api/v3/order
- (void)queryOrderWithSymbol:(NSString *)symbol
                     orderId:(NSUInteger)orderId
       originalClientOrderId:(nullable NSString *)originalClientOrderId
                   timestamp:(NSTimeInterval)timestamp
                  timeToLive:(NSTimeInterval)timeToLive
                      result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    if (orderId != NSNotFound)
    {
        parameters[@"orderId"] = @(orderId);
    }
    else
    {
        NSParameterAssert(originalClientOrderId);
        
        parameters[@"origClientOrderId"] = originalClientOrderId;
    }
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager GET:@"/api/v3/order"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// DELETE /api/v3/order
- (void)deleteOrderWithSymbol:(NSString *)symbol
                      orderId:(NSUInteger)orderId
        originalClientOrderId:(nullable NSString *)originalClientOrderId
             newClientOrderId:(nullable NSString *)newClientOrderId
                    timestamp:(NSTimeInterval)timestamp
                   timeToLive:(NSTimeInterval)timeToLive
                       result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    if (orderId != NSNotFound)
    {
        parameters[@"orderId"] = @(orderId);
    }
    else
    {
        NSParameterAssert(originalClientOrderId);
        
        parameters[@"origClientOrderId"] = originalClientOrderId;
    }
    
    if (newClientOrderId)
    {
        parameters[@"newClientOrderId"] = newClientOrderId;
    }
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager DELETE:@"/api/v3/order"
                parameters:parameters
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// GET /api/v3/openOrders
- (void)openOrdersWithSymbol:(NSString *)symbol
                   timestamp:(NSTimeInterval)timestamp
                  timeToLive:(NSTimeInterval)timeToLive
                      result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager GET:@"/api/v3/openOrders"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// GET /api/v3/allOrders
- (void)allOrdersWithSymbol:(NSString *)symbol
                    orderId:(NSUInteger)orderId
                      limit:(NSUInteger)limit
                  timestamp:(NSTimeInterval)timestamp
                 timeToLive:(NSTimeInterval)timeToLive
                     result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    if (orderId != NSNotFound)
    {
        parameters[@"orderId"] = @(orderId);
    }
    
    if (limit != NSNotFound)
    {
        NSUInteger canonicalLimit = MIN(limit, 500);
        
        parameters[@"limit"] = @(canonicalLimit);
    }
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager GET:@"/api/v3/allOrders"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// GET /api/v3/account
- (void)accountInformationWithTimestamp:(NSTimeInterval)timestamp
                             timeToLive:(NSTimeInterval)timeToLive
                                 result:(nullable ResultBlock)result
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager GET:@"/api/v3/account"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// GET /api/v3/myTrades
- (void)tradesWithSymbol:(NSString *)symbol
                  fromId:(NSUInteger)fromId
                   limit:(NSUInteger)limit
               timestamp:(NSTimeInterval)timestamp
              timeToLive:(NSTimeInterval)timeToLive
                  result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"symbol"] = symbol;
    
    if (fromId != NSNotFound)
    {
        parameters[@"fromId"] = @(fromId);
    }
    
    if (limit != NSNotFound)
    {
        NSUInteger canonicalLimit = MIN(limit, 500);
        
        parameters[@"limit"] = @(canonicalLimit);
    }
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager GET:@"/api/v3/myTrades"
             parameters:parameters
               progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// POST /wapi/v1/withdraw.html
- (void)withdrawAsset:(NSString *)asset
              address:(NSString *)address
               amount:(CGFloat)amount
                 name:(NSString *)name
            timestamp:(NSTimeInterval)timestamp
           timeToLive:(NSTimeInterval)timeToLive
               result:(nullable ResultBlock)result
{
    NSParameterAssert(asset);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"asset"] = asset;
    
    NSParameterAssert(address);
    
    parameters[@"address"] = address;
    
    NSAssert(amount >= 0.0, @"Amount must be greater than or equal to zero");
    
    parameters[@"amount"] = @(amount);
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager POST:@"/wapi/v1/withdraw.html"
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// POST /wapi/v1/getDepositHistory.html
- (void)depositHistoryForAsset:(nullable NSString *)asset
                 depositStatus:(BNBDepositStatus)depositStatus
                     startTime:(NSTimeInterval)startTime
                       endTime:(NSTimeInterval)endTime
                     timestamp:(NSTimeInterval)timestamp
                    timeToLive:(NSTimeInterval)timeToLive
                        result:(nullable ResultBlock)result
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    if (asset)
    {
        parameters[@"asset"] = asset;
    }
    
    if (depositStatus != NSNotFound)
    {
        parameters[@"status"] = @(depositStatus);
    }
    
    if (startTime >= 0.0)
    {
        parameters[@"startTime"] = @([NSNumber numberWithDouble:startTime].longLongValue);
    }
    
    if (endTime >= 0.0)
    {
        parameters[@"endTime"] = @([NSNumber numberWithDouble:endTime].longLongValue);
    }
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
        
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager POST:@"/wapi/v1/getDepositHistory.html"
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

// POST /wapi/v1/getWithdrawHistory.html
- (void)withdrawHistoryForAsset:(nullable NSString *)asset
                 withdrawStatus:(BNBWithdrawStatus)withdrawStatus
                      startTime:(NSTimeInterval)startTime
                        endTime:(NSTimeInterval)endTime
                      timestamp:(NSTimeInterval)timestamp
                     timeToLive:(NSTimeInterval)timeToLive
                         result:(nullable ResultBlock)result
{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    if (asset)
    {
        parameters[@"asset"] = asset;
    }
    
    if (withdrawStatus != NSNotFound)
    {
        parameters[@"status"] = @(withdrawStatus);
    }
    
    if (startTime >= 0.0)
    {
        parameters[@"startTime"] = @([NSNumber numberWithDouble:startTime].longLongValue);
    }
    
    if (endTime >= 0.0)
    {
        parameters[@"endTime"] = @([NSNumber numberWithDouble:endTime].longLongValue);
    }
    
    parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.secretKey = self.secretKey;
    
    [sessionManager POST:@"/wapi/v1/getWithdrawHistory.html"
              parameters:parameters
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

#pragma mark - User Stream Endpoint Methods

// POST /api/v1/userDataStream
- (void)createUserStream:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    
    [sessionManager POST:@"/api/v1/userDataStream"
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
}

// PUT /api/v1/userDataStream
- (void)updateUserStreamForListenKey:(NSString *)listenKey result:(nullable ResultBlock)result
{
    NSParameterAssert(listenKey);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"listenKey"] = listenKey;
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    
    [sessionManager PUT:@"/api/v1/userDataStream"
             parameters:parameters
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
}

// DELETE /api/v1/userDataStream
- (void)deleteUserStreamForListenKey:(NSString *)listenKey result:(nullable ResultBlock)result
{
    NSParameterAssert(listenKey);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"listenKey"] = listenKey;
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    
    [sessionManager DELETE:@"/api/v1/userDataStream"
                parameters:parameters
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (result)
         {
             result(responseObject, nil);
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (result)
         {
             result(nil, error);
         }
     }];
    
    sessionManager.APIKey = nil;
}

@end
