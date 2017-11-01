// BNBWebSocketClient.m
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

#import "BNBWebSocketClient.h"

#import <PocketSocket/PSWebSocket.h>

static NSString *const BinanceWebSocketBaseURLString = @"wss://stream.binance.com:9443";

@interface BNBWebSocketClient () <PSWebSocketDelegate>

@property (strong, nonatomic) PSWebSocket *webSocket;

@end

@implementation BNBWebSocketClient

#pragma mark - Initialization

- (nullable instancetype)initWithURLString:(NSString *)URLString
{
    if (self = [super init])
    {
        NSURL *baseURL = [NSURL URLWithString:BinanceWebSocketBaseURLString];
        
        _webSocketURL = [NSURL URLWithString:URLString relativeToURL:baseURL];
        
        self.webSocket = [PSWebSocket clientSocketWithRequest:[NSURLRequest requestWithURL:_webSocketURL]];
        self.webSocket.delegate = self;
    }
    
    return self;
}

+ (nullable instancetype)webSocketClientWithURLString:(NSString *)URLString
{
    return [[self alloc] initWithURLString:URLString];
}

#pragma mark - Actions

- (void)open
{
    [self.webSocket open];
}

- (void)close
{
    [self.webSocket close];
}

#pragma mark - PSWebSocketDelegate Methods

- (void)webSocketDidOpen:(PSWebSocket *)webSocket
{
    if (self.openBlock)
    {
        self.openBlock(self);
    }
}

- (void)webSocket:(PSWebSocket *)webSocket didFailWithError:(NSError *)error
{
    if (self.errorBlock)
    {
        self.errorBlock(self, error);
    }
}

- (void)webSocket:(PSWebSocket *)webSocket didReceiveMessage:(id)message
{
    if (self.messageBlock)
    {
        self.messageBlock(self, message);
    }
}

- (void)webSocket:(PSWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{    
    if (self.closeBlock)
    {
        self.closeBlock(self, code, reason, wasClean);
    }
}

#pragma mark - Memory Management

- (void)dealloc
{    
    [self.webSocket close];
}

@end
