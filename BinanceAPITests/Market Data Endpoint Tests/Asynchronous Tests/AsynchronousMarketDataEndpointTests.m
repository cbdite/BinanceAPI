// AsynchronousMarketDataEndpointTests.m
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
#import "BNBNumberFormatters.h"

@interface AsynchronousMarketDataEndpointTests : BNBAsynchronousXCTestCase

@end

@implementation AsynchronousMarketDataEndpointTests

// GET /api/v1/depth
- (void)testOrderBookForSymbolLimit
{
    id<BNBMarketDataEndpointProtocol> client = [BNBAsynchronousRESTClient new];
    
    [client orderBookForSymbol:@"BNBETH"
                         limit:10
                        result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSDictionary *resultJSON = responseObject;
        
            NSArray<NSArray *> *asks = resultJSON[@"asks"];
            NSArray<NSArray *> *bids = resultJSON[@"bids"];
            
            DDLogInfo(@"*** BNB/ETH ***");
            DDLogInfo(@"*** Price (ETH)\t Type\t Amount\t ***");

            NSEnumerator *enumerator = [asks reverseObjectEnumerator];

            for (NSArray *ask in enumerator)
            {
                DDLogInfo(@"*** %@\t ASK\t %@\t ***", ask[0], ask[1]);
            }
            
            [bids enumerateObjectsUsingBlock:^(NSArray * _Nonnull bid, NSUInteger idx, BOOL * _Nonnull stop)
            {
                DDLogInfo(@"*** %@\t BID\t %@\t ***", bid[0], bid[1]);
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

// GET /api/v1/aggTrades
- (void)testAggreateTradesListForSymbolLimit
{
    id<BNBMarketDataEndpointProtocol> client = [BNBAsynchronousRESTClient new];
    
    [client aggregateTradesListForSymbol:@"BNBETH"
                                  fromId:NSNotFound
                               startTime:-1.0
                                 endTime:-1.0
                                   limit:10
                                  result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
            
            NSArray *resultJSON = responseObject;
            
            DDLogInfo(@"*** %@ ***", resultJSON);
            
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

/*
 * [
 *       [
 *       1499040000000,      // Open time
 *       "0.01634790",       // Open
 *       "0.80000000",       // High
 *       "0.01575800",       // Low
 *       "0.01577100",       // Close
 *       "148976.11427815",  // Volume
 *       1499644799999,      // Close time
 *       "2434.19055334",    // Quote asset volume
 *       308,                // Number of trades
 *       "1756.87402397",    // Taker buy base asset volume
 *       "28.46694368",      // Taker buy quote asset volume
 *       "17928899.62484339" // Can be ignored
 *       ]
 * ]
 */

// GET /api/v1/klines
- (void)testKlineDataForSymbolLimit
{
    id<BNBMarketDataEndpointProtocol> client = [BNBAsynchronousRESTClient new];
    
    [client klineDataForSymbol:@"BNBETH"
                         interval:BNBFifteenMinutes
                        startTime:0.0
                          endTime:0.0
                            limit:10
                           result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
            
            DDLogInfo(@"*** BNB/ETH ***");
            DDLogInfo(@"*** Open time\t\t Open (ETH)\t Close (ETH) High (ETH)\t Low (ETH)\t Close time\t\t Market sentiment ***");
            
            NSArray<NSArray *> *resultJSON = responseObject;
            
            [resultJSON enumerateObjectsUsingBlock:^(NSArray * _Nonnull intervalData, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 NSString *openString = intervalData[1];
                 NSString *closeString = intervalData[4];
                 
                 NSNumberFormatter *decimalNumberFormatter = [BNBNumberFormatters decimalNumberFormatter];

                 NSNumber *openNumber = [decimalNumberFormatter numberFromString:openString];
                 NSNumber *closeNumber = [decimalNumberFormatter numberFromString:closeString];
                 
                 NSString *marketSentiment = @"Undefined";
                 
                 if (openNumber && closeNumber)
                 {
                     CGFloat delta = closeNumber.floatValue - openNumber.floatValue;
                     
                     marketSentiment = delta > 0 ? @"Bullish" : @"Bearish";
                 }
                 
                 DDLogInfo(@"*** %@\t %@\t %@\t %@\t %@\t %@\t %@\t ***", intervalData[0], openString, closeString, intervalData[2], intervalData[3], intervalData[6], marketSentiment);
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

/*
 * {
 *   "priceChange": "-94.99999800",
 *   "priceChangePercent": "-95.960",
 *   "weightedAvgPrice": "0.29628482",
 *   "prevClosePrice": "0.10002000",
 *   "lastPrice": "4.00000200",
 *   "bidPrice": "4.00000000",
 *   "askPrice": "4.00000200",
 *   "openPrice": "99.00000000",
 *   "highPrice": "100.00000000",
 *   "lowPrice": "0.10000000",
 *   "volume": "8913.30000000",
 *   "openTime": 1499783499040,
 *   "closeTime": 1499869899040,
 *   "fristId": 28385,   // First tradeId
 *   "lastId": 28460,    // Last tradeId
 *   "count": 76         // Trade count
 * }
 */

// GET /api/v1/ticker/24hr
- (void)testPriceChangeStatisticsTickerForSymbol
{
    id<BNBMarketDataEndpointProtocol> client = [BNBAsynchronousRESTClient new];
    
    [client priceChangeStatisticsTickerForSymbol:@"BNBETH"
                                        interval:BNBTwentyFourHours
                                          result:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSDictionary *resultJSON = responseObject;

            DDLogInfo(@"*** BNB/ETH\t Last price %@\t 24h Change %@%%\t 24h High %@\t 24h Low %@\t 24h Total %@\t ***", resultJSON[@"lastPrice"], resultJSON[@"priceChangePercent"], resultJSON[@"highPrice"], resultJSON[@"lowPrice"], resultJSON[@"volume"]);
            
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

// GET /api/v1/ticker/allPrices
- (void)testPriceTickers
{
    id<BNBMarketDataEndpointProtocol> client = [BNBAsynchronousRESTClient new];
    
    [client priceTickersResult:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSArray<NSDictionary *> *resultJSON = responseObject;
            
            [resultJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull symbolData, NSUInteger idx, BOOL * _Nonnull stop)
            {
                DDLogInfo(@"*** Symbol %@\t Price %@\t ***", symbolData[@"symbol"], symbolData[@"price"]);
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

// GET /api/v1/ticker/allBookTickers
- (void)testOrderBookTickers
{
    id<BNBMarketDataEndpointProtocol> client = [BNBAsynchronousRESTClient new];
    
    [client orderBookTickersResult:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSArray class]])
        {
            DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

            NSArray<NSDictionary *> *resultJSON = responseObject;
            
            [resultJSON enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull symbolData, NSUInteger idx, BOOL * _Nonnull stop)
             {
                 DDLogInfo(@"*** Symbol %@\t Ask Price %@\t Ask Quantity %@\t Bid Price %@\t Bid Quantity %@\t ***", symbolData[@"symbol"], symbolData[@"askPrice"], symbolData[@"askQty"], symbolData[@"bidPrice"], symbolData[@"bidQty"]);
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

@end
