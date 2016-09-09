//
//  HJObject.m
//  HJCategory
//
//  Created by hj on 16/7/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HJObject.h"

@implementation NSObject (Value)

+ (id)hj_setValue:(id)value withDefalut:(id)aDefault
{
    if ([value isKindOfClass:[NSString class]])
    {
        return ([value isEqual:@""] || !value) ? aDefault : value;
    }
    return value ? value : aDefault;
}

@end
