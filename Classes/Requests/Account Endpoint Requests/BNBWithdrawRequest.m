// BNBWithdrawRequest.m
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

#import "BNBWithdrawRequest.h"

@implementation BNBWithdrawRequest

#pragma mark - Initialization

- (instancetype)initWithAsset:(NSString *)asset
                      address:(NSString *)address
                       amount:(CGFloat)amount
                         name:(nullable NSString *)name
{
    if (self = [super init])
    {
        self.asset = asset;
        self.address = address;
        self.amount = amount;
        self.name = name;
    }
    
    return self;
}

#pragma mark - BNBEndpointRequestProtocol Methods

- (NSString *)URLPathString
{
    return @"/wapi/v1/withdraw.html";
}

- (nullable NSDictionary *)requestParametersForHTTPMethod:(BNBHTTPMethod)HTTPMethod
{
    NSMutableDictionary *requestParameters;
    
    if (HTTPMethod == BNBPOST)
    {
        requestParameters = [NSMutableDictionary new];
        
        NSParameterAssert(self.asset);
        
        requestParameters[@"asset"] = self.asset;
        
        NSParameterAssert(self.address);
        
        requestParameters[@"address"] = self.address;
        
        NSAssert(self.amount >= 0.0, @"Amount must be greater than or equal to zero");
        
        requestParameters[@"amount"] = @(self.amount);
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
