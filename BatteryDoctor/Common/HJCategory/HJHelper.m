//
//  Helper.m
//  BatteryDoctor
//
//  Created by hj on 16/8/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HJHelper.h"

@implementation HJHelper

+ (CGFloat)getDeviceScale
{
    CGFloat scale = 1.0;
    
    if (screenW == 320) {
        scale = 15 / 17.0;
    }
//    else if (screenW == 414) {
//        scale = 18 / 17.0;
//    }
    
    return scale;
}

+ (NSInteger)randomNumberFrom:(NSInteger)start to:(NSInteger)end
{
    return (NSInteger)(start + (arc4random() % (end - start + 1)));
}

@end
