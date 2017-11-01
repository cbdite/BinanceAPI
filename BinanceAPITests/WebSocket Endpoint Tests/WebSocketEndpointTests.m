// WebSocketEndpointTests.m
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

#import "BNBXCTestCase.h"

#import "BNBWebSocketClient.h"
#import "BNBSynchronousRESTClient.h"

#define kWebSocketTestRunningTime 20

@interface WebSocketEndpointTests : BNBXCTestCase

@end

@implementation WebSocketEndpointTests
{
    XCTestExpectation *_expectation;
}

- (void)setUp
{
    [super setUp];
    
    _expectation = [self expectationWithDescription:@"Binance WebSocket API Testing"];
}

- (void)testDepthWebSocketEndpoint
{
    [self runWebSocketEndpointTestWithURLString:@"/ws/ltcbtc@depth"];
}

- (void)testKlineDataWebSocketEndpoint
{
    [self runWebSocketEndpointTestWithURLString:@"/ws/ltcbtc@kline_15m"];
}

- (void)testTradesWebSocketEndpoint
{
    [self runWebSocketEndpointTestWithURLString:@"/ws/ltcbtc@aggTrades"];
}

- (void)testUserDataWebSocketEndpoint
{
    id<BNBUserStreamEndpointProtocol> client = [[BNBSynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:nil];
    
    [client createUserStream:^(id  _Nullable responseObject, NSError * _Nullable error)
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *resultJSON = responseObject;
            
            NSString *listenKey = resultJSON[@"listenKey"];

            DDLogInfo(@"*** Found listen key %@ ***", listenKey);
            
            NSString *URLString = [NSString stringWithFormat:@"/ws/%@", listenKey];
            
            [self runWebSocketEndpointTestWithURLString:URLString];
        }
        else
        {
            kJSONResponseSerializerErrorLogging
            
            XCTFail(@"Expectation failed with error: %@", error);
        }
    }];
}

- (void)runWebSocketEndpointTestWithURLString:(NSString *)URLString
{
    BNBWebSocketClient *client = [BNBWebSocketClient webSocketClientWithURLString:URLString];
    
    client.openBlock = ^(BNBWebSocketClient * _Nonnull webSocketClient)
    {
        DDLogInfo(@"*** WebSocket established for URL %@ ***", webSocketClient.webSocketURL.absoluteString);
    };
    
    client.errorBlock = ^(BNBWebSocketClient * _Nonnull webSocketClient, NSError * _Nonnull error)
    {
        XCTFail(@"Expectation failed with error: %@", error);
    };
    
    client.messageBlock = ^(BNBWebSocketClient * _Nonnull webSocketClient, id  _Nonnull message)
    {
        DDLogInfo(@"*** WebSocket client did receive message %@ ***", message);
    };
    
    [client open];
    
    [NSTimer scheduledTimerWithTimeInterval:kWebSocketTestRunningTime repeats:NO block:^(NSTimer * _Nonnull timer)
     {
         [_expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:kWebSocketTestRunningTime handler:^(NSError *error)
     {
         if (error)
         {
             XCTFail(@"Expectation failed with error: %@", error);\
         }
     }];
}

@end
