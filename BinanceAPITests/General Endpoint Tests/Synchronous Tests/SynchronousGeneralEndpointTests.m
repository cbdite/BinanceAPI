// SynchronousGeneralEndpointTests.m
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

#import "BNBXCTestCase.h"

#import "BNBSynchronousRESTClient.h"

@interface SynchronousGeneralEndpointTests : BNBXCTestCase

@end

@implementation SynchronousGeneralEndpointTests

// GET /api/v1/ping
- (void)testTestConnectivity
{
    id<BNBGeneralEndpointProtocol> client = [BNBSynchronousRESTClient new];
    
    [client testConnectivity:^(id  _Nullable responseObject, NSError * _Nullable error)
     {
         if (responseObject)
         {
             DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);
         }
         else
         {
             kJSONResponseSerializerErrorLogging
             
             XCTFail(@"Expectation failed with error: %@", error);
         }
     }];
}

// GET /api/v1/time
- (void)testCheckServerTime
{
    id<BNBGeneralEndpointProtocol> client = [BNBSynchronousRESTClient new];
    
    [client checkServerTime:^(id  _Nullable responseObject, NSError * _Nullable error)
     {
         if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
         {
             DDLogInfo(@"*** %s succeeded ***", __PRETTY_FUNCTION__);

             NSDictionary *resultJSON = responseObject;
             
             // Invoking stringValue property on NSNumber
             DDLogInfo(@"*** Server time is %@ ***", resultJSON[@"serverTime"]);
          }
         else
         {
             kJSONResponseSerializerErrorLogging
             
             XCTFail(@"Expectation failed with error: %@", error);
         }
     }];    
}

@end
