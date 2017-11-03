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

NSString * _Nonnull const SymbolType_toString[BNBSymbolTypeCount] =
{
    [BNBSpot] = @"SPOT"
};

NSString * _Nonnull const OrderStatus_toString[BNBOrderStatusCount] =
{
    [BNBNew] = @"NEW",
    [BNBPartiallyFilled] = @"PARTIALLY_FILLED",
    [BNBFilled] = @"FILLED",
    [BNBCanceled] = @"CANCELED",
    [BNBPendingCancel] = @"PENDING_CANCEL",
    [BNBRejected] = @"REJECTED",
    [BNBExpired] = @"EXPIRED"
};

NSString * _Nonnull const OrderSide_toString[BNBOrderSideCount] =
{
    [BNBBuy] = @"BUY",
    [BNBSell] = @"SELL"
};

NSString * _Nonnull const OrderType_toString[BNBOrderTypeCount] =
{
    [BNBLimit] = @"LIMIT",
    [BNBMarket] = @"MARKET"
};

NSString * _Nonnull const TimeInForce_toString[BNBTimeInForceCount] =
{
    [BNBGTC] = @"GTC",
    [BNBIOC] = @"IOC"
};

NSString * _Nonnull const Interval_toString[BNBIntervalCount] =
{
    [BNBOneMinute] = @"1m",
    [BNBThreeMinutes] = @"3m",
    [BNBFiveMinutes] = @"5m",
    [BNBFifteenMinutes] = @"15m",
    [BNBThirtyMinutes] = @"30m",
    [BNBOneHour] = @"1h",
    [BNBTwoHours] = @"2h",
    [BNBFourHours] = @"4h",
    [BNBSixHours] = @"6h",
    [BNBEightHours] = @"8h",
    [BNBTwelveHours] = @"12h",
    [BNBTwentyFourHours] = @"24h",
    [BNBOneDay] = @"1d",
    [BNBThreeDays] = @"3d",
    [BNBOneWeek] = @"1w",
    [BNBOneMonth] = @"1M",
};
