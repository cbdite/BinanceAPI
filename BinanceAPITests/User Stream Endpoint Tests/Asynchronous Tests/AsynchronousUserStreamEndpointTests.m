// AsynchronousUserStreamEndpointTests.m
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

#import "BNBAsynchronousXCTestCase.h"

#import "BNBAsynchronousRESTClient.h"

@interface AsynchronousUserStreamEndpointTests : BNBAsynchronousXCTestCase

@end

@implementation AsynchronousUserStreamEndpointTests

// POST /api/v3/order/test
- (void)testCreateUserStream
{
    id<BNBUserStreamEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:nil];
    
    [client createUserStream:^(id  _Nullable responseObject, NSError * _Nullable error)
     {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
         {
             DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
             
             NSDictionary *resultJSON = responseObject;
             
             DDLogInfo(@"*** Found listen key %@ ***", resultJSON[@"listenKey"]);
             
             [self.expectation fulfill];
         }
         else
         {
             kJSONResponseSerializerErrorLogging
             
             XCTFail(@"Expectation failed with error: %@", error);
         }
     }];
    
    kAsynchronousExpectationTimeout
}

// PUT /api/v3/order/test
- (void)testUpdateUserStreamForListenKey
{
    id<BNBUserStreamEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:nil];
    
    [client updateUserStreamForListenKey:@""
                                  result:^(id  _Nullable responseObject, NSError * _Nullable error)
     {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
         {
             DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
             
             [self.expectation fulfill];
         }
         else
         {
             kJSONResponseSerializerErrorLogging
             
             XCTFail(@"Expectation failed with error: %@", error);
         }
     }];
    
    kAsynchronousExpectationTimeout
}

// DELETE /api/v3/order/test
- (void)testDeleteUserStreamForListenKey
{
    id<BNBUserStreamEndpointProtocol> client = [[BNBAsynchronousRESTClient alloc] initWithAPIKey:@"YOUR-API-KEY" secretKey:nil];
    
    [client deleteUserStreamForListenKey:@""
                                  result:^(id  _Nullable responseObject, NSError * _Nullable error)
     {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
         {
             DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
             
             [self.expectation fulfill];
         }
         else
         {
             kJSONResponseSerializerErrorLogging
             
             XCTFail(@"Expectation failed with error: %@", error);
         }
     }];
    
    kAsynchronousExpectationTimeout
}

@end
