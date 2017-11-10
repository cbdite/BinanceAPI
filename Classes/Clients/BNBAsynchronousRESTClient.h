// BNBAsynchronousRESTClient.h
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

#import <Foundation/Foundation.h>

#import "BNBGeneralEndpointProtocol.h"
#import "BNBMarketDataEndpointProtocol.h"
#import "BNBAccountEndpointProtocol.h"
#import "BNBUserStreamEndpointProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNBAsynchronousRESTClient : NSObject <BNBGeneralEndpointProtocol, BNBMarketDataEndpointProtocol, BNBAccountEndpointProtocol, BNBUserStreamEndpointProtocol>

@property (nullable, readonly, copy, nonatomic) NSString *APIKey;

@property (nullable, readonly, copy, nonatomic) NSString *secretKey;

- (instancetype)initWithAPIKey:(nullable NSString *)APIKey
                     secretKey:(nullable NSString *)secretKey;

- (void)orderBookForSymbol:(NSString *)symbol
                    result:(nullable ResultBlock)result;

- (void)aggregateTradesListForSymbol:(NSString *)symbol
                              result:(nullable ResultBlock)result;

- (void)klineDataForSymbol:(NSString *)symbol
                  interval:(BNBInterval)interval
                    result:(nullable ResultBlock)result;

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
                           result:(nullable ResultBlock)result;

@end

NS_ASSUME_NONNULL_END
