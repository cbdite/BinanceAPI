// BNBWithdrawHistoryRequest.h
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

#import "BNBEndpointRequestProtocol.h"
#import "BNBEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface BNBWithdrawHistoryRequest : NSObject <BNBEndpointRequestProtocol>

@property (nullable, copy, nonatomic) NSString *asset;

@property (assign, nonatomic) BNBWithdrawStatus withdrawStatus;

@property (assign, nonatomic) NSTimeInterval startTime;

@property (assign, nonatomic) NSTimeInterval endTime;

- (instancetype)initWithAsset:(nullable NSString *)asset
               withdrawStatus:(BNBWithdrawStatus)withdrawStatus
                    startTime:(NSTimeInterval)startTime
                      endTime:(NSTimeInterval)endTime;

@end

NS_ASSUME_NONNULL_END
