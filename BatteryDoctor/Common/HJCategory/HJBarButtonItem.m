//
//  HJBarButtonItem.m
//  HJCategory
//
//  Created by 黄健 on 16/7/25.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HJBarButtonItem.h"

@implementation UIBarButtonItem (Simplify)

+ (instancetype)itemWithTitle:(NSString *)title
                        color:(UIColor *)color target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[self alloc] initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action];
    
    item.tintColor = color ? color : item.tintColor;
    
    return item;
}

+ (instancetype)itemWithImage:(UIImage *)image
                    highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setFrame:(CGRect){CGPointZero, image.size}];
    [button setImage:image     forState:UIControlStateNormal];
    [button setImage:highImage forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

+ (instancetype)itemWithSpaceWidth:(CGFloat)width
{
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    space.width = width;
    
    return space;
}

@end
