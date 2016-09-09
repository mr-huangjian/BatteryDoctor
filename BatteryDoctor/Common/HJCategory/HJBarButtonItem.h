//
//  HJBarButtonItem.h
//  HJCategory
//
//  Created by 黄健 on 16/7/25.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Simplify)

+ (instancetype)itemWithTitle:(NSString *)title
                        color:(UIColor *)color target:(id)target action:(SEL)action;

+ (instancetype)itemWithImage:(UIImage *)image
                    highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithSpaceWidth:(CGFloat)width;

@end
