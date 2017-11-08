// BNBAccountEndpointProtocol.h
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

#import "BNBEndpointProtocol.h"

#import "BNBEnums.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BNBAccountEndpointProtocol <BNBEndpointProtocol>

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
                       result:(nullable ResultBlock)result;

- (void)queryOrderWithSymbol:(NSString *)symbol
                     orderId:(NSUInteger)orderId
       originalClientOrderId:(nullable NSString *)originalClientOrderId
                   timestamp:(NSTimeInterval)timestamp
                  timeToLive:(NSTimeInterval)timeToLive
                      result:(nullable ResultBlock)result;

- (void)deleteOrderWithSymbol:(NSString *)symbol
                      orderId:(NSUInteger)orderId
        originalClientOrderId:(nullable NSString *)originalClientOrderId
         clientOrderId:(nullable NSString *)clientOrderId
                    timestamp:(NSTimeInterval)timestamp
                   timeToLive:(NSTimeInterval)timeToLive
                       result:(nullable ResultBlock)result;

- (void)openOrdersWithSymbol:(NSString *)symbol
                   timestamp:(NSTimeInterval)timestamp
                  timeToLive:(NSTimeInterval)timeToLive
                      result:(nullable ResultBlock)result;

- (void)allOrdersWithSymbol:(NSString *)symbol
                    orderId:(NSUInteger)orderId
                      limit:(NSUInteger)limit
                  timestamp:(NSTimeInterval)timestamp
                 timeToLive:(NSTimeInterval)timeToLive
                     result:(nullable ResultBlock)result;

- (void)accountInformationWithTimestamp:(NSTimeInterval)timestamp
                             timeToLive:(NSTimeInterval)timeToLive
                                 result:(nullable ResultBlock)result;

- (void)tradesWithSymbol:(NSString *)symbol
                  fromId:(NSUInteger)fromId
                   limit:(NSUInteger)limit
               timestamp:(NSTimeInterval)timestamp
              timeToLive:(NSTimeInterval)timeToLive
                  result:(nullable ResultBlock)result;

- (void)withdrawAsset:(NSString *)asset
              address:(NSString *)address
               amount:(CGFloat)amount
                 name:(nullable NSString *)name
            timestamp:(NSTimeInterval)timestamp
           timeToLive:(NSTimeInterval)timeToLive
               result:(nullable ResultBlock)result;

- (void)depositHistoryForAsset:(nullable NSString *)asset
                 depositStatus:(BNBDepositStatus)depositStatus
                     startTime:(NSTimeInterval)startTime
                       endTime:(NSTimeInterval)endTime
                     timestamp:(NSTimeInterval)timestamp
                    timeToLive:(NSTimeInterval)timeToLive
                        result:(nullable ResultBlock)result;

- (void)withdrawHistoryForAsset:(nullable NSString *)asset
                 withdrawStatus:(BNBWithdrawStatus)withdrawStatus
                      startTime:(NSTimeInterval)startTime
                        endTime:(NSTimeInterval)endTime
                      timestamp:(NSTimeInterval)timestamp
                     timeToLive:(NSTimeInterval)timeToLive
                         result:(nullable ResultBlock)result;

@end

NS_ASSUME_NONNULL_END
