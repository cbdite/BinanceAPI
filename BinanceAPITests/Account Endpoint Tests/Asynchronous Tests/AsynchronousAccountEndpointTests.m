// AsynchronousAccountEndpointTests.m
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

#import "BNBAsynchronousXCTestCase.h"

#import "BNBAsynchronousRESTClient.h"
#import "NSDate+Utilities.h"
#import "BNBNumberFormatters.h"

@interface AsynchronousAccountEndpointTests : BNBAsynchronousXCTestCase

@end

@implementation AsynchronousAccountEndpointTests

// POST /api/v3/order/test
- (void)testTestCreateOrderWithSymbolSideTypeTimeInForceQuantityIcebergQuantityPriceStopPriceNewClientOrderIdTimestampTimeToLive
{
    BNBAsynchronousRESTClient *client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];

    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];

    [client testCreateOrderWithSymbol:@"LTCBTC"
                          side:Buy
                          type:Limit
                   timeInForce:GTC
                      quantity:1.0
               icebergQuantity:0.0
                         price:0.005
                     stopPrice:0.0
              newClientOrderId:nil
                     timestamp:timestamp
                    timeToLive:5000.0
                        result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
    
    kAsynchronousExpectationTimeout
}

#warning Uncommenting the following test will result in an order being added to the order book
/*
// POST /api/v3/order
- (void)testCreateOrderWithSymbolSideTypeTimeInForceQuantityIcebergQuantityPriceStopPriceNewClientOrderIdTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:kAPIKey secretKey:kSecretKey];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];
    
    // BNBETH symbol fails with HTTP status code 400 and Binance error code -1013 "Filter failure: MIN_NOTIONAL"
    [client createOrderWithSymbol:@"LTCBTC"
                          side:Sell
                          type:Limit
                   timeInForce:GTC
                      quantity:1.0
               icebergQuantity:0.0
                         price:0.1
                     stopPrice:0.0
              newClientOrderId:nil
                     timestamp:timestamp
                     timeToLive:5000.0
                        result:^(id  _Nullable responseObject, NSError * _Nullable error)
     {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
         {
             DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
 
             NSDictionary *resultJSON = responseObject;
             
             // Invoking stringValue property on NSNumber
             DDLogInfo(@"*** Successfully added %@ order with order id %@ client order id %@ to order book. Order was transacted at %@ ms ***", resultJSON[@"symbol"], resultJSON[@"orderId"], resultJSON[@"clientOrderId"], resultJSON[@"transactTime"]);
             
             [self.expectation fulfill];
         }
         else
         {
             kJSONResponseSerializerErrorLogging
 
             XCTFail(@"Expectation failed with error: %@", error);
         }
     }];
    
    kAsynchronousExpectationTimeout
}
*/

// GET /api/v3/order
- (void)testQueryOrderWithSymbolOrderIdOriginalClientOrderIdTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];

    [client queryOrderWithSymbol:@"LTCBTC"
                    orderId:0
      originalClientOrderId:nil
                  timestamp:timestamp
                 timeToLive:5000
                     result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
            
            NSDictionary *resultJSON = responseObject;

            DDLogInfo(@"*** Successfully retrieved order with\nSymbol: %@\nOrder id: %@\nClient order id %@\nPrice: %@\nOriginal Quantity: %@\nExecuted Quantity: %@\nStatus: %@\nTime in force: %@\nType: %@\nSide: %@\nStop Price: %@\nIceberg Quantity: %@\ntime: %@ ***", resultJSON[@"symbol"], resultJSON[@"orderId"], resultJSON[@"clientOrderId"], resultJSON[@"price"], resultJSON[@"origQty"], resultJSON[@"executedQty"], resultJSON[@"status"], resultJSON[@"timeInForce"], resultJSON[@"type"], resultJSON[@"side"], resultJSON[@"stopPrice"], resultJSON[@"icebergQty"], resultJSON[@"time"]);

            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];

    kAsynchronousExpectationTimeout
}

// DELETE /api/v3/order
- (void)testDeleteOrderWithSymbolOrderIdOriginalClientOrderIdNewClientOrderIdTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];
    
    [client deleteOrderWithSymbol:@"LTCBTC"
                    orderId:0
      originalClientOrderId:nil
           newClientOrderId:nil
                  timestamp:timestamp
                 timeToLive:5000
                     result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSDictionary *resultJSON = responseObject;

            DDLogInfo(@"*** Successfully canceled order with symbol %@ order id %@ original client order id %@ client order id %@ ***", resultJSON[@"symbol"], resultJSON[@"orderId"], resultJSON[@"origClientOrderId"], resultJSON[@"clientOrderId"]);
            
            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
    
    kAsynchronousExpectationTimeout
}

// GET /api/v3/openOrders
- (void)testOpenOrdersWithSymbolTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];
    
    [client openOrdersWithSymbol:@"LTCBTC"
                       timestamp:timestamp
                      timeToLive:5000
                          result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSArray<NSDictionary *> *resultJSON = responseObject;

            [resultJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull openOrder, NSUInteger idx, BOOL * _Nonnull stop)
            {
                 DDLogInfo(@"*** Found order with\nSymbol: %@\nOrder id: %@\nClient order id: %@\nPrice: %@\nOriginal quantity: %@\nExecuted quantity: %@\nStatus: %@\nTime in force: %@\nType: %@\nSide: %@\nStop price: %@\nIceberg quantity: %@\nTime: %@ ***", openOrder[@"symbol"], openOrder[@"orderId"], openOrder[@"clientOrderId"], openOrder[@"price"], openOrder[@"origQty"], openOrder[@"executedQty"], openOrder[@"status"], openOrder[@"timeInForce"], openOrder[@"type"], openOrder[@"side"], openOrder[@"stopPrice"], openOrder[@"icebergQty"], openOrder[@"time"]);
            }];
            
            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];

    kAsynchronousExpectationTimeout
}

// GET /api/v3/allOrders
- (void)testAllOrdersWithSymbolOrderIdLimitTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];
    
    [client allOrdersWithSymbol:@"LTCBTC"
                        orderId:0
                          limit:10
                      timestamp:timestamp
                     timeToLive:5000
                         result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSArray<NSDictionary *> *resultJSON = responseObject;
            
            [resultJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull order, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 DDLogInfo(@"*** Found order with\nSymbol: %@\nOrder id: %@\nClient order id: %@\nPrice: %@\nOriginal quantity: %@\nExecuted quantity: %@\nStatus: %@\nTime in force: %@\nType: %@\nSide: %@\nStop price: %@\nIceberg quantity: %@\nTime: %@ ***", order[@"symbol"], order[@"orderId"], order[@"clientOrderId"], order[@"price"], order[@"origQty"], order[@"executedQty"], order[@"status"], order[@"timeInForce"], order[@"type"], order[@"side"], order[@"stopPrice"], order[@"icebergQty"], order[@"time"]);
             }];
            
            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];

    kAsynchronousExpectationTimeout
}

// GET /api/v3/account
- (void)testAccountInformationWithTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];
    
    [client accountInformationWithTimestamp:timestamp
                                 timeToLive:5000
                                     result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSDictionary *resultJSON = responseObject;

            DDLogInfo(@"*** Account settings are as follows:\ncan trade? %@\ncan withdraw? %@\ncan deposit? %@\n***", resultJSON[@"canTrade"] ? @"true" : @"false", resultJSON[@"canWithdraw"] ? @"true" : @"false", resultJSON[@"canDeposit"] ? @"true" : @"false");
            
            NSNumberFormatter *decimalNumberFormatter = [BNBNumberFormatters decimalNumberFormatter];
   
            NSArray<NSDictionary *> *balances = resultJSON[@"balances"];
            
            [balances enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull balance, NSUInteger idx, BOOL * _Nonnull stop)
            {
                NSNumber *freeNumber = [decimalNumberFormatter numberFromString:balance[@"free"]];
                NSNumber *lockedNumber = [decimalNumberFormatter numberFromString:balance[@"locked"]];
                
                if (freeNumber && lockedNumber)
                {
                    CGFloat freeBalance = freeNumber.floatValue;
                    CGFloat lockedBalance = lockedNumber.floatValue;
                    
                    CGFloat totalBalance = freeBalance + lockedBalance;
                    
                    if (totalBalance > 0.0)
                    {
                        DDLogInfo(@"*** Nonzero balance for asset %@ is %f ***", balance[@"asset"], totalBalance);
                    }
                }
            }];
            
            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
    
    kAsynchronousExpectationTimeout
}

// GET /api/v3/myTrades
- (void)testTradesWithSymboFromIdlLimitTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];
    
    [client tradesWithSymbol:@"LTCBTC"
                      fromId:NSNotFound
                       limit:10
                   timestamp:timestamp
                  timeToLive:5000
                      result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSArray<NSDictionary *> *resultJSON = responseObject;

            [resultJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull trade, NSUInteger idx, BOOL * _Nonnull stop)
            {
                DDLogInfo(@"*** Found trade with id %@\nprice %@\nquantity %@\ncommission %@\n commission asset %@\ntransaction time %@ ***", trade[@"id"], trade[@"price"], trade[@"qty"], trade[@"commission"], trade[@"commissionAsset"], trade[@"time"]);
            }];
            
            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];

    kAsynchronousExpectationTimeout
}

// POST /wapi/v1/withdraw
- (void)tesWithdrawAssetAddressAmountNameTimestampTimeToLive
{
    id<BNBAccountEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:@"YOUR-SECRET-KEY"];
    
    NSTimeInterval timestamp = [NSDate millisecondTimeIntervalSince1970];
    
    [client withdrawAsset:@"BTC"
                  address:@""
                   amount:0.0
                     name:nil
                timestamp:timestamp
               timeToLive:5000
                   result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
            
            NSDictionary *resultJSON = responseObject;
            
            DDLogInfo(@"*** Received message %@ success? %@ ***", resultJSON[@"msg"], resultJSON[@"success"] ? @"true" : @"false");
            
            [self.expectation fulfill];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
    
    kAsynchronousExpectationTimeout
}

@end
