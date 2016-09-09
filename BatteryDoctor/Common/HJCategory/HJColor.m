//
//  HJColor.m
//  HJCategory
//
//  Created by hj on 16/7/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HJColor.h"

@implementation UIColor (Hex)

+ (UIColor *)hj_randomColor
{
    CGFloat R = arc4random_uniform(256) / 255.0;
    CGFloat G = arc4random_uniform(256) / 255.0;
    CGFloat B = arc4random_uniform(256) / 255.0;
    
    return [[self class] colorWithRed:R green:G blue:B alpha:1];
}

+ (UIColor *)hj_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"0x"] || [cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)hj_colorWithHexString:(NSString *)color
{
    return [[self class] hj_colorWithHexString:color alpha:1.f];
}

+ (UIColor *)hj_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
}

+ (UIColor *)hj_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [[self class] hj_colorWith8BitRed:red green:green blue:blue alpha:1.f];
}

@end
