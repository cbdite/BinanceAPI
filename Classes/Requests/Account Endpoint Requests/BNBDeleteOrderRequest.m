// BNBDeleteOrderRequest.m
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

#import "BNBDeleteOrderRequest.h"

@implementation BNBDeleteOrderRequest

#pragma mark - Initialization

- (instancetype)initWithSymbol:(NSString *)symbol
                       orderId:(NSUInteger)orderId
         originalClientOrderId:(nullable NSString *)originalClientOrderId
          updatedClientOrderId:(nullable NSString *)updatedClientOrderId
{
    if (self = [super init])
    {
        self.symbol = symbol;
        self.orderId = orderId;
        self.originalClientOrderId = originalClientOrderId;
        self.updatedClientOrderId = updatedClientOrderId;
    }
    
    return self;
}

#pragma mark - BNBEndpointRequestProtocol Methods

- (NSString *)URLPathString
{
    return @"/api/v3/order";
}

- (nullable NSDictionary *)requestParametersForHTTPMethod:(BNBHTTPMethod)HTTPMethod
{
    NSMutableDictionary *requestParameters;
    
    if (HTTPMethod == BNBDELETE)
    {
        requestParameters = [NSMutableDictionary new];
        
        NSParameterAssert(self.symbol);
        
        requestParameters[@"symbol"] = self.symbol;
        
        if (self.orderId != NSNotFound)
        {
            requestParameters[@"orderId"] = @(self.orderId);
        }
        else
        {
            NSParameterAssert(self.originalClientOrderId);
            
            requestParameters[@"origClientOrderId"] = self.originalClientOrderId;
        }
        
        if (self.updatedClientOrderId)
        {
            requestParameters[@"newClientOrderId"] = self.updatedClientOrderId;
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
