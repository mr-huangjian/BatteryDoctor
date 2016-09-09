//
//  HJScaleLayout.m
//  WaaShow
//
//  Created by hj on 16/7/27.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import "HJScaleLayout.h"
#import <objc/runtime.h>

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

@implementation UILabel (ScaleLayout)

+ (void)load
{
    Method imp    = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method hj_imp = class_getInstanceMethod([self class], @selector(hj_initWithCoder:));
    method_exchangeImplementations(imp, hj_imp);
}

- (id)hj_initWithCoder:(NSCoder*)aDecoder
{
    [self hj_initWithCoder:aDecoder];
    
    if (self)
    {
        if(self.tag != 999999)
        {
            self.font = [UIFont systemFontOfSize:self.font.pointSize * deviceScale];
        }
    }
    return self;
}

@end


@implementation UIButton (ScaleLayout)

+ (void)load
{
    Method imp    = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method hj_imp = class_getInstanceMethod([self class], @selector(hj_initWithCoder:));
    method_exchangeImplementations(imp, hj_imp);
}

- (id)hj_initWithCoder:(NSCoder*)aDecoder
{
    [self hj_initWithCoder:aDecoder];
    
    if (self)
    {
        if(self.titleLabel.tag != 999999)
        {
            self.titleLabel.font = [UIFont systemFontOfSize:self.titleLabel.font.pointSize * deviceScale];
        }
    }
    return self;
}

@end

@implementation UIView (ScaleLayout)

- (void)layoutSubviews
{
    if (self.tag == 777777)
    {
        self.layer.cornerRadius  = self.bounds.size.height / 2.f;
        self.layer.masksToBounds = YES;
        
    } else if (self.tag == 888888)
    {
        self.layer.cornerRadius  = self.bounds.size.width / 2.f;
        self.layer.masksToBounds = YES;
    }
}

@end

@implementation NSLayoutConstraint (ScaleLayout)

+ (void)load
{
//    Method imp    = class_getInstanceMethod([self class], @selector(initWithCoder:));
//    Method hj_imp = class_getInstanceMethod([self class], @selector(hj_initWithCoder:));
//    method_exchangeImplementations(imp, hj_imp);
}

- (id)hj_initWithCoder:(NSCoder*)aDecoder
{
    [self hj_initWithCoder:aDecoder];
    
    if (self)
    {
        if (![self.identifier isEqualToString:@"noscale"])
        {
            self.constant *= deviceScale;
        }
    }
    return self;
}

@end
