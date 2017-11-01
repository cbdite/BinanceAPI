// BNBHTTPSessionManager.m
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

#import "BNBHTTPSessionManager.h"

#import "BNBJSONResponseSerializer.h"
#import "BNBUtilities.h"

static NSString *const BinanceRESTBaseURLString = @"https://www.binance.com";

@implementation BNBHTTPSessionManager
{
    NSMutableSet *_signedEndpointURLPaths;
    
    NSMutableSet *_APIKeyEndpointURLPaths;
}

#pragma mark - Properties

- (NSSet *)signedEndpointURLPaths
{
    return [_signedEndpointURLPaths copy];
}

- (NSSet *)APIKeyEndpointURLPaths
{
    return [_APIKeyEndpointURLPaths copy];
}

#pragma mark - Initialization

+ (instancetype)sharedHTTPSessionManager
{
    static BNBHTTPSessionManager *sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[BNBHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BinanceRESTBaseURLString] sessionConfiguration:nil];

        NSString *userAgent = [sharedInstance.requestSerializer valueForHTTPHeaderField:@"User-Agent"];
        
        // Ensure compatibility with targets that don't contain a main bundle
        NSString *canonicalUserAgent = [userAgent stringByReplacingOccurrencesOfString:@"null" withString:@""];
        
        [sharedInstance.requestSerializer setValue:canonicalUserAgent forHTTPHeaderField:@"User-Agent"];
        
        sharedInstance.responseSerializer = [BNBJSONResponseSerializer serializer];
        
        // HTTP response header field "Content-Type" is set to "text/html" although "application/json" would be more appropriate, since the content is JSON
        sharedInstance.responseSerializer.acceptableContentTypes = [sharedInstance.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    });
    
    return sharedInstance;
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration])
    {
        _signedEndpointURLPaths = [NSMutableSet new];
        
        _APIKeyEndpointURLPaths = [NSMutableSet new];
        
        [self populateEndpointURLPaths];
    }
    
    return self;
}

#pragma mark - Endpoint Management

- (void)populateEndpointURLPaths
{
    [self addSignedEndpointURLPath:@"/api/v3/order/test"];
    [self addSignedEndpointURLPath:@"/api/v3/order"];
    [self addSignedEndpointURLPath:@"/api/v3/openOrders"];
    [self addSignedEndpointURLPath:@"/api/v3/allOrders"];
    [self addSignedEndpointURLPath:@"/api/v3/account"];
    [self addSignedEndpointURLPath:@"/api/v3/myTrades"];
    
    [self addAPIKeyEndpointURLPath:@"/api/v1/userDataStream"];
}

- (void)addSignedEndpointURLPath:(NSString *)URLPath
{
    [_signedEndpointURLPaths addObject:URLPath];
}

- (void)removeSignedEndpointURLPath:(NSString *)URLPath
{
    [_signedEndpointURLPaths removeObject:URLPath];
}

- (void)removeAllSignedEndpointURLPaths
{
    [_signedEndpointURLPaths removeAllObjects];
}

- (void)addAPIKeyEndpointURLPath:(NSString *)URLPath
{
    [_APIKeyEndpointURLPaths addObject:URLPath];
}

- (void)removeAPIKeyEndpointURLPath:(NSString *)URLPath
{
    [_APIKeyEndpointURLPaths removeObject:URLPath];
}

- (void)removeAllAPIKeyEndpointURLPaths
{
    [_APIKeyEndpointURLPaths removeAllObjects];
}

#pragma mark - Overrides

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    NSString *URLPath = mutableRequest.URL.path;
    
    if ([self.signedEndpointURLPaths containsObject:URLPath])
    {
        [mutableRequest setValue:self.APIKey forHTTPHeaderField:@"X-MBX-APIKEY"];
        
        NSString *HTTPMethod = mutableRequest.HTTPMethod;
        
        if ([HTTPMethod isEqualToString:@"GET"] || [HTTPMethod isEqualToString:@"DELETE"])
        {
            NSString *queryString = mutableRequest.URL.query;
            
            NSString *HMACString = [BNBUtilities HMACStringForKey:self.secretKey dataString:queryString];
            
            NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:mutableRequest.URL resolvingAgainstBaseURL:NO];
            
            NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"signature" value:HMACString];
            
            URLComponents.queryItems = [URLComponents.queryItems arrayByAddingObject:queryItem];
            
            mutableRequest.URL = URLComponents.URL;
        }
        else if ([HTTPMethod isEqualToString:@"POST"] || [HTTPMethod isEqualToString:@"PUT"])
        {
            NSString *HTTPBodyString = [[NSString alloc] initWithData:mutableRequest.HTTPBody encoding:NSUTF8StringEncoding];
            
            NSString *HMACString = [BNBUtilities HMACStringForKey:self.secretKey dataString:HTTPBodyString];
            
            NSString *signatureHTTPBodyString = [HTTPBodyString stringByAppendingFormat:@"&signature=%@", HMACString];
            
            mutableRequest.HTTPBody = [signatureHTTPBodyString dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    else if ([self.APIKeyEndpointURLPaths containsObject:URLPath])
    {
        [mutableRequest setValue:self.APIKey forHTTPHeaderField:@"X-MBX-APIKEY"];
    }
    
    return [super dataTaskWithRequest:mutableRequest uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
}

@end
