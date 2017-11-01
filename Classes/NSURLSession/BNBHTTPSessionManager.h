// BNBHTTPSessionManager.h
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

#import <AFNetworking/AFHTTPSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface BNBHTTPSessionManager : AFHTTPSessionManager

@property (nullable, copy, nonatomic) NSString *APIKey;

@property (nullable, copy, nonatomic) NSString *secretKey;

@property (readonly, copy, nonatomic) NSSet<NSString *> *signedEndpointURLPaths;

@property (readonly, copy, nonatomic) NSSet<NSString *> *APIKeyEndpointURLPaths;

+ (nullable instancetype)sharedHTTPSessionManager;

- (void)addSignedEndpointURLPath:(NSString *)URLPath;
- (void)removeSignedEndpointURLPath:(NSString *)URLPath;
- (void)removeAllSignedEndpointURLPaths;

- (void)addAPIKeyEndpointURLPath:(NSString *)URLPath;
- (void)removeAPIKeyEndpointURLPath:(NSString *)URLPath;
- (void)removeAllAPIKeyEndpointURLPaths;

@end

NS_ASSUME_NONNULL_END
