//
//  HealthyPreView.m
//  BatteryDoctor
//
//  Created by hj on 16/8/25.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HealthyPreView.h"

@implementation HealthyPreView

- (void)awakeFromNib
{
    
}

- (void)drawRect:(CGRect)rect
{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame     = rect;
    gradientLayer.colors    = @[(__bridge id)HexStringColor(@"91F2FF").CGColor,
                                (__bridge id)HexStringColor(@"49A3FD").CGColor];
    gradientLayer.locations = @[@(0.0), @(1.0)];
    
    [self.layer addSublayer:gradientLayer];
}

@end
