// BNBSynchronousRESTClient.m
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

#import "BNBSynchronousRESTClient.h"

#import "BNBHTTPSessionManager.h"
#import <AFHTTPSessionManager+Synchronous.h>

@interface BNBSynchronousRESTClient ()

@property (readwrite, copy, nonatomic) NSString *APIKey;

@property (readwrite, copy, nonatomic) NSString *secretKey;

@end

@implementation BNBSynchronousRESTClient

#pragma mark - Initialization

- (instancetype)initWithAPIKey:(NSString *)APIKey secretKey:(NSString *)secretKey
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
- (void)testConnectivity:(nullable void (^)(id _Nullable responseObject, NSError * _Nullable error))result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/ping"
                                 parameters:nil
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
}

// GET /api/v1/time
- (void)checkServerTime:(nullable void (^)(id _Nullable responseObject, NSError * _Nullable error))result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/time"
                                 parameters:nil
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
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
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/depth"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
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
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/aggTrades"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
}

// GET /api/v1/klines
- (void)klineDataForSymbol:(NSString *)symbol
                     interval:(Interval)interval
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
                     interval:(Interval)interval
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
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/klines"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
}

/*
 * Interval currently defaults to 24hr
 */

// GET /api/v1/ticker/24hr
- (void)priceChangeStatisticsTickerForSymbol:(NSString *)symbol
                                    interval:(Interval)interval
                                      result:(nullable ResultBlock)result
{
    NSParameterAssert(symbol);
    
    NSDictionary *parameters = @{@"symbol": symbol};
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/ticker/24hr"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
}

// GET /api/v1/ticker/allPrices
- (void)priceTickersResult:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/ticker/allPrices"
                                 parameters:nil
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
}

// GET /api/v1/ticker/allBookTickers
- (void)orderBookTickersResult:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v1/ticker/allBookTickers"
                                 parameters:nil
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.completionQueue = nil;
}

#pragma mark - Account Endpoint Methods

// POST /api/v3/order/test
- (void)testCreateOrderWithSymbol:(NSString *)symbol
                             side:(OrderSide)side
                             type:(OrderType)type
                      timeInForce:(TimeInForce)timeInForce
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
                         side:(OrderSide)side
                         type:(OrderType)type
                  timeInForce:(TimeInForce)timeInForce
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
                         side:(OrderSide)side
                         type:(OrderType)type
                  timeInForce:(TimeInForce)timeInForce
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
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncPOST:URLString
                                  parameters:parameters
                                        task:nil
                                       error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
    sessionManager.completionQueue = nil;
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
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v3/order"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
    sessionManager.completionQueue = nil;
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
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncDELETE:@"/api/v3/order"
                                    parameters:parameters
                                          task:nil
                                         error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
    sessionManager.completionQueue = nil;
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
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v3/openOrders"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
    sessionManager.completionQueue = nil;
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
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v3/allOrders"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
    sessionManager.completionQueue = nil;
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
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v3/account"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
    sessionManager.completionQueue = nil;
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
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);
    
    NSError *error;
    
    id resultData = [sessionManager syncGET:@"/api/v3/myTrades"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
    sessionManager.completionQueue = nil;
}

#pragma mark - User Stream Endpoint Methods

// POST /api/v1/userDataStream
- (void)createUserStream:(nullable ResultBlock)result
{
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);

    NSError *error;
    
    id resultData = [sessionManager syncPOST:@"/api/v1/userDataStream"
                                  parameters:nil
                                        task:nil
                                       error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.completionQueue = nil;
}

// PUT /api/v1/userDataStream
- (void)updateUserStreamForListenKey:(NSString *)listenKey result:(nullable ResultBlock)result
{
    NSParameterAssert(listenKey);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"listenKey"] = listenKey;
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);

    NSError *error;
    
    id resultData = [sessionManager syncPUT:@"/api/v1/userDataStream"
                                 parameters:parameters
                                       task:nil
                                      error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.completionQueue = nil;
}

// DELETE /api/v1/userDataStream
- (void)deleteUserStreamForListenKey:(NSString *)listenKey result:(nullable ResultBlock)result
{
    NSParameterAssert(listenKey);
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    
    parameters[@"listenKey"] = listenKey;
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    sessionManager.APIKey = self.APIKey;
    sessionManager.completionQueue = dispatch_queue_create("AFNetworking+Synchronous", NULL);

    NSError *error;
    
    id resultData = [sessionManager syncDELETE:@"/api/v1/userDataStream"
                                    parameters:parameters
                                          task:nil
                                         error:&error];
    
    if (result)
    {
        if (resultData)
        {
            result(resultData, nil);
        }
        else
        {
            result(nil, error);
        }
    }
    
    sessionManager.APIKey = nil;
    sessionManager.completionQueue = nil;
}

@end
