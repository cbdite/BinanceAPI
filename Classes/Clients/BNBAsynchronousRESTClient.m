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

#import "BNBTestConnectivityRequest.h"
#import "BNBCheckServerTimeRequest.h"

#import "BNBOrderBookRequest.h"
#import "BNBAggregateTradesListRequest.h"
#import "BNBKlineDataRequest.h"
#import "BNBPriceChangeStatisticsTickerRequest.h"
#import "BNBPriceTickersRequest.h"
#import "BNBOrderBookTickersRequest.h"

#import "BNBCreateUserStreamRequest.h"
#import "BNBUpdateUserStreamRequest.h"
#import "BNBDeleteUserStreamRequest.h"

#import "BNBTestCreateOrderRequest.h"
#import "BNBCreateOrderRequest.h"
#import "BNBQueryOrderRequest.h"
#import "BNBDeleteOrderRequest.h"
#import "BNBOpenOrdersRequest.h"
#import "BNBAllOrdersRequest.h"
#import "BNBAccountRequest.h"
#import "BNBTradesRequest.h"
#import "BNBWithdrawRequest.h"
#import "BNBDepositHistoryRequest.h"
#import "BNBWithdrawHistoryRequest.h"

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
    id<BNBEndpointRequestProtocol> request = [BNBTestConnectivityRequest new];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
}

// GET /api/v1/time
- (void)checkServerTime:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [BNBCheckServerTimeRequest new];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
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
    id<BNBEndpointRequestProtocol> request = [[BNBOrderBookRequest alloc] initWithSymbol:symbol
                                                                                   limit:limit];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
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
    id<BNBEndpointRequestProtocol> request = [[BNBAggregateTradesListRequest alloc] initWithSymbol:symbol
                                                                                            fromId:fromId
                                                                                         startTime:startTime
                                                                                           endTime:endTime
                                                                                             limit:limit];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
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
    id<BNBEndpointRequestProtocol> request = [[BNBKlineDataRequest alloc] initWithSymbol:symbol
                                                                                interval:interval
                                                                               startTime:startTime
                                                                                 endTime:endTime
                                                                                   limit:limit];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
}

/*
 * Interval currently defaults to 24hr
 */

// GET /api/v1/ticker/24hr
- (void)priceChangeStatisticsTickerForSymbol:(NSString *)symbol
                                    interval:(BNBInterval)interval
                                      result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBPriceChangeStatisticsTickerRequest alloc] initWithSymbol:symbol
                                                                                                  interval:interval];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
}

// GET /api/v1/ticker/allPrices
- (void)priceTickersResult:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [BNBPriceTickersRequest new];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
}

// GET /api/v1/ticker/allBookTickers
- (void)orderBookTickersResult:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [BNBOrderBookTickersRequest new];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
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
                    clientOrderId:(nullable NSString *)clientOrderId
                        timestamp:(NSTimeInterval)timestamp
                       timeToLive:(NSTimeInterval)timeToLive
                           result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBTestCreateOrderRequest alloc] initWithSymbol:symbol
                                                                                          side:side
                                                                                          type:type
                                                                                   timeInForce:timeInForce
                                                                                      quantity:quantity
                                                                               icebergQuantity:icebergQuantity
                                                                                         price:price
                                                                                     stopPrice:stopPrice
                                                                                 clientOrderId:clientOrderId];
    
    [self performRequest:request
          withHTTPMethod:BNBPOST
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
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
                clientOrderId:(nullable NSString *)clientOrderId
                    timestamp:(NSTimeInterval)timestamp
                   timeToLive:(NSTimeInterval)timeToLive
                       result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBCreateOrderRequest alloc] initWithSymbol:symbol
                                                                                      side:side
                                                                                      type:type
                                                                               timeInForce:timeInForce
                                                                                  quantity:quantity
                                                                           icebergQuantity:icebergQuantity
                                                                                     price:price
                                                                                 stopPrice:stopPrice
                                                                             clientOrderId:clientOrderId];
    
    [self performRequest:request
          withHTTPMethod:BNBPOST
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
}

// GET /api/v3/order
- (void)queryOrderWithSymbol:(NSString *)symbol
                     orderId:(NSUInteger)orderId
       originalClientOrderId:(nullable NSString *)originalClientOrderId
                   timestamp:(NSTimeInterval)timestamp
                  timeToLive:(NSTimeInterval)timeToLive
                      result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBQueryOrderRequest alloc] initWithSymbol:symbol
                                                                                  orderId:orderId
                                                                    originalClientOrderId:originalClientOrderId];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
}

// DELETE /api/v3/order
- (void)deleteOrderWithSymbol:(NSString *)symbol
                      orderId:(NSUInteger)orderId
        originalClientOrderId:(nullable NSString *)originalClientOrderId
                clientOrderId:(nullable NSString *)clientOrderId
                    timestamp:(NSTimeInterval)timestamp
                   timeToLive:(NSTimeInterval)timeToLive
                       result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBDeleteOrderRequest alloc] initWithSymbol:symbol
                                                                                   orderId:orderId
                                                                     originalClientOrderId:originalClientOrderId
                                                                             clientOrderId:clientOrderId];
    
    [self performRequest:request
          withHTTPMethod:BNBDELETE
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
}

// GET /api/v3/openOrders
- (void)openOrdersWithSymbol:(NSString *)symbol
                   timestamp:(NSTimeInterval)timestamp
                  timeToLive:(NSTimeInterval)timeToLive
                      result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBOpenOrdersRequest alloc] initWithSymbol:symbol];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
}

// GET /api/v3/allOrders
- (void)allOrdersWithSymbol:(NSString *)symbol
                    orderId:(NSUInteger)orderId
                      limit:(NSUInteger)limit
                  timestamp:(NSTimeInterval)timestamp
                 timeToLive:(NSTimeInterval)timeToLive
                     result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBAllOrdersRequest alloc] initWithSymbol:symbol
                                                                                 orderId:orderId
                                                                                   limit:limit];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
}

// GET /api/v3/account
- (void)accountInformationWithTimestamp:(NSTimeInterval)timestamp
                             timeToLive:(NSTimeInterval)timeToLive
                                 result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [BNBAccountRequest new];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
}

// GET /api/v3/myTrades
- (void)tradesWithSymbol:(NSString *)symbol
                  fromId:(NSUInteger)fromId
                   limit:(NSUInteger)limit
               timestamp:(NSTimeInterval)timestamp
              timeToLive:(NSTimeInterval)timeToLive
                  result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBTradesRequest alloc] initWithSymbol:symbol
                                                                               fromId:fromId
                                                                                limit:limit];
    
    [self performRequest:request
          withHTTPMethod:BNBGET
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
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
    id<BNBEndpointRequestProtocol> request = [[BNBWithdrawRequest alloc] initWithAsset:asset
                                                                               address:address
                                                                                amount:amount
                                                                                  name:name];
    
    [self performRequest:request
          withHTTPMethod:BNBPOST
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
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
    id<BNBEndpointRequestProtocol> request = [[BNBDepositHistoryRequest alloc] initWithAsset:asset
                                                                               depositStatus:depositStatus
                                                                                   startTime:startTime
                                                                                     endTime:endTime];
    
    [self performRequest:request
          withHTTPMethod:BNBPOST
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
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
    id<BNBEndpointRequestProtocol> request = [[BNBWithdrawHistoryRequest alloc] initWithAsset:asset
                                                                               withdrawStatus:withdrawStatus
                                                                                    startTime:startTime
                                                                                      endTime:endTime];
    
    [self performRequest:request
          withHTTPMethod:BNBPOST
               timestamp:timestamp
              timeToLive:timeToLive
                  result:result];
}

#pragma mark - User Stream Endpoint Methods

// POST /api/v1/userDataStream
- (void)createUserStream:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [BNBCreateUserStreamRequest new];
    
    [self performRequest:request
          withHTTPMethod:BNBPOST
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
}

// PUT /api/v1/userDataStream
- (void)updateUserStreamForListenKey:(NSString *)listenKey result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBUpdateUserStreamRequest alloc] initWithListenKey:listenKey];
    
    [self performRequest:request
          withHTTPMethod:BNBPUT
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
}

// DELETE /api/v1/userDataStream
- (void)deleteUserStreamForListenKey:(NSString *)listenKey result:(nullable ResultBlock)result
{
    id<BNBEndpointRequestProtocol> request = [[BNBDeleteUserStreamRequest alloc] initWithListenKey:listenKey];
    
    [self performRequest:request
          withHTTPMethod:BNBDELETE
               timestamp:-1.0
              timeToLive:-1.0
                  result:result];
}

- (void)performRequest:(id<BNBEndpointRequestProtocol>)request
        withHTTPMethod:(BNBHTTPMethod)HTTPMethod
             timestamp:(NSTimeInterval)timestamp
            timeToLive:(NSTimeInterval)timeToLive
                result:(nullable ResultBlock)result
{
    NSMutableDictionary *parameters;
    
    if ([request respondsToSelector:@selector(requestParameters)])
    {
        parameters = [[request requestParameters] mutableCopy];
    }
    else
    {
        parameters = [NSMutableDictionary new];
    }
    
    if (timestamp > 0.0)
    {
        parameters[@"timestamp"] = @([NSNumber numberWithDouble:timestamp].longLongValue);
    }
    
    if (timeToLive > 0.0)
    {
        parameters[@"recvWindow"] = @([NSNumber numberWithDouble:timeToLive].longLongValue);
    }
    
    BNBHTTPSessionManager *sessionManager = [BNBHTTPSessionManager sharedHTTPSessionManager];
    
    if ([request respondsToSelector:@selector(requiresAPIKey)])
    {
        if ([request requiresAPIKey])
        {
            sessionManager.APIKey = self.APIKey;
        }
    }
    
    if ([request respondsToSelector:@selector(requiresSigning)])
    {
        if ([request requiresSigning])
        {
            sessionManager.secretKey = self.secretKey;
        }
    }
    
    switch (HTTPMethod)
    {
        case BNBPOST:
        {
            [sessionManager POST:[request URLPathString]
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
            break;
            
        case BNBGET:
        {
            [sessionManager GET:[request URLPathString]
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
            break;
            
        case BNBPUT:
        {
            [sessionManager PUT:[request URLPathString]
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
        }
            break;
            
        case BNBDELETE:
        {
            [sessionManager DELETE:[request URLPathString]
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
        }
            break;
            
        default:
            @throw
            [NSException exceptionWithName:@"Unsupported HTTP method"
                                    reason:@"The HTTP method must be one of BNBPOST, BNBGET, BNBPUT or BNBDELETE"
                                  userInfo:nil];
            
            break;
    }
    
    sessionManager.APIKey = nil;
    sessionManager.secretKey = nil;
}

@end
