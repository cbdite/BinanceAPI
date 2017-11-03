// BNBEnums.h
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

typedef NS_ENUM(NSUInteger, BNBSymbolType)
{
    BNBSpot,
    BNBSymbolTypeCount
};

extern NSString * _Nonnull const SymbolType_toString[BNBSymbolTypeCount];

typedef NS_ENUM(NSUInteger, BNBOrderStatus)
{
    BNBNew,
    BNBPartiallyFilled,
    BNBFilled,
    BNBCanceled,
    BNBPendingCancel,
    BNBRejected,
    BNBExpired,
    BNBOrderStatusCount
};

extern NSString * _Nonnull const OrderStatus_toString[BNBOrderStatusCount];

typedef NS_ENUM(NSUInteger, BNBOrderSide)
{
    BNBBuy,
    BNBSell,
    BNBOrderSideCount
};

extern NSString * _Nonnull const OrderSide_toString[BNBOrderSideCount];

typedef NS_ENUM(NSUInteger, BNBOrderType)
{
    BNBLimit,
    BNBMarket,
    BNBOrderTypeCount
};

extern NSString * _Nonnull const OrderType_toString[BNBOrderTypeCount];

typedef NS_ENUM(NSUInteger, BNBTimeInForce)
{
    BNBGTC, // Good-Til-Canceled
    BNBIOC, // Immediate-Or-Cancel
    BNBTimeInForceCount
};

extern NSString * _Nonnull const TimeInForce_toString[BNBTimeInForceCount];

typedef NS_ENUM(NSUInteger, BNBInterval)
{
    BNBOneMinute,
    BNBThreeMinutes,
    BNBFiveMinutes,
    BNBFifteenMinutes,
    BNBThirtyMinutes,
    BNBOneHour,
    BNBTwoHours,
    BNBFourHours,
    BNBSixHours,
    BNBEightHours,
    BNBTwelveHours,
    BNBTwentyFourHours,
    BNBOneDay,
    BNBThreeDays,
    BNBOneWeek,
    BNBOneMonth,
    BNBIntervalCount
};

extern NSString * _Nonnull const Interval_toString[BNBIntervalCount];

typedef NS_ENUM(NSUInteger, BNBDepositStatus)
{
    BNBPending,
    BNBSuccess
};

typedef NS_ENUM(NSUInteger, BNBWithdrawStatus)
{
    BNBEmailSent,
    BNBCancelled,
    BNBAwaitingApproval,
    BNBWithdrawRejected,
    BNBProcessing,
    BNBFailure,
    BNBCompleted
};
