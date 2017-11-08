// BNBWithdrawHistoryRequest.m
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

#import "BNBWithdrawHistoryRequest.h"

@implementation BNBWithdrawHistoryRequest

#pragma mark - Initialization

- (instancetype)initWithAsset:(nullable NSString *)asset
               withdrawStatus:(BNBWithdrawStatus)withdrawStatus
                    startTime:(NSTimeInterval)startTime
                      endTime:(NSTimeInterval)endTime
{
    if (self = [super init])
    {
        self.asset = asset;
        self.withdrawStatus = withdrawStatus;
        self.startTime = startTime;
        self.endTime = endTime;
    }
    
    return self;
}

#pragma mark - BNBEndpointRequestProtocol Methods

- (NSString *)URLPathString
{
    return @"/wapi/v1/getWithdrawHistory.html";
}

- (nullable NSDictionary *)requestParametersForHTTPMethod:(BNBHTTPMethod)HTTPMethod
{
    NSMutableDictionary *requestParameters;
    
    if (HTTPMethod == BNBPOST)
    {
        requestParameters = [NSMutableDictionary new];
        
        if (self.asset)
        {
            requestParameters[@"asset"] = self.asset;
        }
        
        if (self.withdrawStatus != NSNotFound)
        {
            requestParameters[@"status"] = @(self.withdrawStatus);
        }
        
        if (self.startTime >= 0.0)
        {
            requestParameters[@"startTime"] = @([NSNumber numberWithDouble:self.startTime].longLongValue);
        }
        
        if (self.endTime >= 0.0)
        {
            requestParameters[@"endTime"] = @([NSNumber numberWithDouble:self.endTime].longLongValue);
        }
    }
    
    return requestParameters;
}

- (BOOL)requiresAPIKey
{
    return YES;
}

- (BOOL)requiresSecretKey
{
    return YES;
}

@end
