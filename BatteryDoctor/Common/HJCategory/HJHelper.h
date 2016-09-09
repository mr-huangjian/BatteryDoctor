//
//  Helper.h
//  BatteryDoctor
//
//  Created by hj on 16/8/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>

#define deviceScale [HJHelper getDeviceScale]

@interface HJHelper : NSObject

+ (CGFloat)getDeviceScale;

/**
 *  获取一个随机整数[start, end]
 *
 */
+ (NSInteger)randomNumberFrom:(NSInteger)start to:(NSInteger)end;

@end
