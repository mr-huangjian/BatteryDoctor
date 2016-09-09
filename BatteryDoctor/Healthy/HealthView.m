//
//  HealthView.m
//  BatteryDoctor
//
//  Created by hj on 16/8/25.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HealthView.h"

#define kDegree2radius(angle) ((angle) / 180.0 * M_PI)

#define circleLineWidth 12

@implementation HealthView

- (void)setPercent:(NSInteger)percent
{
    _percent = percent;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat halfWidth = rect.size.width * 0.5;
    CGPoint center    = CGPointMake(halfWidth, halfWidth);
    CGFloat radius    = halfWidth - circleLineWidth * 0.5 - 5;
    CGFloat startAngle = kDegree2radius(-240);
    CGFloat endAngle   = kDegree2radius(60);
    
    CAShapeLayer * backGrayShapeLayer = [CAShapeLayer layer];
    backGrayShapeLayer.frame = rect;
    backGrayShapeLayer.fillColor = [UIColor clearColor].CGColor;
    backGrayShapeLayer.strokeColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1].CGColor;
    backGrayShapeLayer.lineCap = kCALineCapRound;
    backGrayShapeLayer.lineWidth = circleLineWidth + 5;
    [self.layer addSublayer:backGrayShapeLayer];
    
    UIBezierPath * backGrayCirclePath = [UIBezierPath
                                         bezierPathWithArcCenter:center radius:radius
                                         startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    backGrayShapeLayer.path = backGrayCirclePath.CGPath;
    
    CAShapeLayer * frontShapeLayer = [CAShapeLayer layer];
    frontShapeLayer.frame = rect;
    frontShapeLayer.fillColor = [UIColor clearColor].CGColor;
    frontShapeLayer.strokeColor = HexStringColor(Theme_BlueColor).CGColor;
    frontShapeLayer.lineCap = kCALineCapRound;
    frontShapeLayer.lineWidth = circleLineWidth + 5;
    [self.layer addSublayer:frontShapeLayer];
    
    endAngle = self.percent ? kDegree2radius(self.percent / 100.0 * 55) : startAngle;
    
    UIBezierPath * frontCirclePath = [UIBezierPath
                                         bezierPathWithArcCenter:center radius:radius
                                         startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    frontShapeLayer.path = frontCirclePath.CGPath;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue   = [NSNumber numberWithFloat:1];
    animation.autoreverses = NO;
    animation.repeatCount  = 1;
    
    [frontShapeLayer addAnimation:animation forKey:@"strokeEndAnimation"];
}

@end
