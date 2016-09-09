//
//  HJColor.h
//  HJCategory
//
//  Created by hj on 16/7/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIClearColor           [UIColor clearColor]
#define UIWhiteColor           [UIColor whiteColor]

#define HexRandomColor         [UIColor hj_randomColor]
#define HexStringColor(string) [UIColor hj_colorWithHexString:string]
#define HexRGBColor(R, G, B)   [UIColor hj_colorWith8BitRed:R green:G blue:B]

@interface UIColor (Hex)

+ (UIColor *)hj_randomColor;

+ (UIColor *)hj_colorWithHexString:(NSString *)color;
+ (UIColor *)hj_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)hj_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)hj_colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

@end
