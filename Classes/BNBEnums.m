// BNBEnums.m
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

#import "BNBEnums.h"

NSString * _Nonnull const SymbolType_toString[SymbolTypeCount] =
{
    [Spot] = @"SPOT"
};

NSString * _Nonnull const OrderStatus_toString[OrderStatusCount] =
{
    [New] = @"NEW",
    [PartiallyFilled] = @"PARTIALLY_FILLED",
    [Filled] = @"FILLED",
    [Canceled] = @"CANCELED",
    [PendingCancel] = @"PENDING_CANCEL",
    [Rejected] = @"REJECTED",
    [Expired] = @"EXPIRED"
};

NSString * _Nonnull const OrderSide_toString[OrderSideCount] =
{
    [Buy] = @"BUY",
    [Sell] = @"SELL"
};

NSString * _Nonnull const OrderType_toString[OrderTypeCount] =
{
    [Limit] = @"LIMIT",
    [Market] = @"MARKET"
};

NSString * _Nonnull const TimeInForce_toString[TimeInForceCount] =
{
    [GTC] = @"GTC",
    [IOC] = @"IOC"
};

NSString * _Nonnull const Interval_toString[IntervalCount] =
{
    [OneMinute] = @"1m",
    [ThreeMinutes] = @"3m",
    [FiveMinutes] = @"5m",
    [FifteenMinutes] = @"15m",
    [ThirtyMinutes] = @"30m",
    [OneHour] = @"1h",
    [TwoHours] = @"2h",
    [FourHours] = @"4h",
    [SixHours] = @"6h",
    [EightHours] = @"8h",
    [TwelveHours] = @"12h",
    [TwentyFourHours] = @"24h",
    [OneDay] = @"1d",
    [ThreeDays] = @"3d",
    [OneWeek] = @"1w",
    [OneMonth] = @"1M",
};
