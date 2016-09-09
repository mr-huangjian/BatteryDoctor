//
//  HJFont.m
//  WaaShow
//
//  Created by hj on 16/7/28.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import "HJFont.h"
#import "HJHelper.h"

@implementation UIFont (Extension)

+ (UIFont *)hj_systemFontOfSize:(CGFloat)size
{
    return [self systemFontOfSize:size * deviceScale];
}

@end
