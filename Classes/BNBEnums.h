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

typedef NS_ENUM(NSUInteger, SymbolType)
{
    Spot,
    SymbolTypeCount
};

extern NSString * _Nonnull const SymbolType_toString[SymbolTypeCount];

typedef NS_ENUM(NSUInteger, OrderStatus)
{
    New,
    PartiallyFilled,
    Filled,
    Canceled,
    PendingCancel,
    Rejected,
    Expired,
    OrderStatusCount
};

extern NSString * _Nonnull const OrderStatus_toString[OrderStatusCount];

typedef NS_ENUM(NSUInteger, OrderSide)
{
    Buy,
    Sell,
    OrderSideCount
};

extern NSString * _Nonnull const OrderSide_toString[OrderSideCount];

typedef NS_ENUM(NSUInteger, OrderType)
{
    Limit,
    Market,
    OrderTypeCount
};

extern NSString * _Nonnull const OrderType_toString[OrderTypeCount];

typedef NS_ENUM(NSUInteger, TimeInForce)
{
    GTC, // Good-Til-Canceled
    IOC, // Immediate-Or-Cancel
    TimeInForceCount
};

extern NSString * _Nonnull const TimeInForce_toString[TimeInForceCount];

typedef NS_ENUM(NSUInteger, Interval)
{
    OneMinute,
    ThreeMinutes,
    FiveMinutes,
    FifteenMinutes,
    ThirtyMinutes,
    OneHour,
    TwoHours,
    FourHours,
    SixHours,
    EightHours,
    TwelveHours,
    TwentyFourHours,
    OneDay,
    ThreeDays,
    OneWeek,
    OneMonth,
    IntervalCount
};

extern NSString * _Nonnull const Interval_toString[IntervalCount];
