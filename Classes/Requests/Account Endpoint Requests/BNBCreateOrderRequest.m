// BNBCreateOrderRequest.m
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

#import "BNBCreateOrderRequest.h"

@implementation BNBCreateOrderRequest

#pragma mark - Initialization

- (instancetype)initWithSymbol:(NSString *)symbol
                          side:(BNBOrderSide)side
                          type:(BNBOrderType)type
                   timeInForce:(BNBTimeInForce)timeInForce
                      quantity:(CGFloat)quantity
               icebergQuantity:(CGFloat)icebergQuantity
                         price:(CGFloat)price
                     stopPrice:(CGFloat)stopPrice
                 clientOrderId:(nullable NSString *)clientOrderId
{
    if (self = [super init])
    {
        self.symbol = symbol;
        self.side = side;
        self.type = type;
        self.timeInForce = timeInForce;
        self.quantity = quantity;
        self.icebergQuantity = icebergQuantity;
        self.price = price;
        self.stopPrice = stopPrice;
        self.clientOrderId = clientOrderId;
    }
    
    return self;
}

#pragma mark - BNBEndpointRequestProtocol Methods

- (NSString *)URLPathString
{
    return @"/api/v3/order";
}

- (NSDictionary *)requestParameters
{
    NSMutableDictionary *requestParameters = [NSMutableDictionary new];
    
    NSParameterAssert(self.symbol);
    
    requestParameters[@"symbol"] = self.symbol;
    
    NSString *sideString = OrderSide_toString[self.side];
    
    NSParameterAssert(sideString);
    
    requestParameters[@"side"] = sideString;
    
    NSString *typeString = OrderType_toString[self.type];
    
    NSParameterAssert(typeString);
    
    requestParameters[@"type"] = typeString;
    
    NSString *timeInForceString = TimeInForce_toString[self.timeInForce];
    
    NSParameterAssert(timeInForceString);
    
    requestParameters[@"timeInForce"] = timeInForceString;
    
    requestParameters[@"quantity"] = @(self.quantity);
    
    if (self.icebergQuantity > 0.0)
    {
        requestParameters[@"icebergQuantity"] = @(self.icebergQuantity);
    }
    
    requestParameters[@"price"] = @(self.price);
    
    if (self.stopPrice > 0.0)
    {
        requestParameters[@"stopPrice"] = @(self.stopPrice);
    }
    
    if (self.clientOrderId)
    {
        requestParameters[@"newClientOrderId"] = self.clientOrderId;
    }
    
    return requestParameters;
}

- (BOOL)requiresAPIKey
{
    return YES;
}

- (BOOL)requiresSigning
{
    return YES;
}

@end
