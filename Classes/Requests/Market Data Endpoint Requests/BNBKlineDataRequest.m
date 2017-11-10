// BNBKlineDataRequest.m
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

#import "BNBKlineDataRequest.h"

@implementation BNBKlineDataRequest

#pragma mark - Initialization

- (instancetype)initWithSymbol:(NSString *)symbol
                      interval:(BNBInterval)interval
                     startTime:(NSTimeInterval)startTime
                       endTime:(NSTimeInterval)endTime
                         limit:(NSUInteger)limit
{
    if (self = [super init])
    {
        self.symbol = symbol;
        self.interval = interval;
        self.startTime = startTime;
        self.endTime = endTime;
        self.limit = limit;
    }
    
    return self;
}

#pragma mark - BNBEndpointRequestProtocol Methods

- (NSString *)URLPathString
{
    return @"/api/v1/klines";
}

- (NSDictionary *)requestParameters
{
    NSMutableDictionary *requestParameters = [NSMutableDictionary new];
    
    NSParameterAssert(self.symbol);
    
    NSString *intervalString = Interval_toString[self.interval];
    
    NSParameterAssert(intervalString);
    
    requestParameters[@"symbol"] = self.symbol;
    requestParameters[@"interval"] = intervalString;
    
    if (self.startTime >= 0.0)
    {
        requestParameters[@"startTime"] = @([NSNumber numberWithDouble:self.startTime].longLongValue);
    }
    
    if (self.endTime >= 0.0)
    {
        requestParameters[@"endTime"] = @([NSNumber numberWithDouble:self.endTime].longLongValue);
    }
    
    if (self.limit != NSNotFound)
    {
        NSUInteger canonicalLimit = MIN(self.limit, 500);
        
        requestParameters[@"limit"] = @(canonicalLimit);
    }
    
    return requestParameters;
}

@end
