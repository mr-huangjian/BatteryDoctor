//
//  CleanView.m
//  BatteryDoctor
//
//  Created by hj on 16/8/25.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "CleanView.h"

#define kDegree2radius(angle) ((angle) / 180.0 * M_PI)

#define kRadius2degree(radius) ((radius) / M_PI * 180.0)

@interface CleanView ()
{
    NSInteger p_lastPercent;
    
    CGFloat p_lastEndAngle;
    
    CGRect irect;
    
    CGFloat ratio;
}
@property (nonatomic, strong) CAShapeLayer * backShapeLayer;
@property (nonatomic, strong) UIBezierPath * backCirclePath;
@property (nonatomic, strong) UIBezierPath * frontCirclePath;

@property (nonatomic, assign) CGFloat firstEndAngle;

@end

@implementation CleanView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = UIClearColor;
}

- (void)setPercent:(NSInteger)percent { _percent = percent;[self setNeedsDisplay]; }
- (void)setBackLineColor:(UIColor *)backLineColor { _backLineColor = backLineColor; [self setNeedsDisplay]; }
- (void)setBackLineWidth:(NSInteger)backLineWidth { _backLineWidth = backLineWidth; [self setNeedsDisplay]; }
- (void)setArcStartAngle:(NSInteger)arcStartAngle { _arcStartAngle = arcStartAngle; [self setNeedsDisplay]; }
- (void)setArcLineColor:(UIColor *)arcLineColor { _arcLineColor = arcLineColor; [self setNeedsDisplay]; }
- (void)setArcLineWidth:(NSInteger)arcLineWidth { _arcLineWidth = arcLineWidth; [self setNeedsDisplay]; }
- (void)setAnimationDuration:(CGFloat)animationDuration { _animationDuration = animationDuration; [self setNeedsDisplay]; }

- (void)drawRect:(CGRect)rect
{
    irect = rect;
    
    CGFloat halfWidth = irect.size.width * 0.5;
    CGPoint center    = CGPointMake(halfWidth, halfWidth);
    CGFloat radius    = halfWidth - self.arcLineWidth * 0.5 - 5;
    
    self.backShapeLayer.frame = irect;
    self.backShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.backShapeLayer.strokeColor = self.backLineColor.CGColor;
    self.backShapeLayer.lineCap = kCALineCapRound;
    self.backShapeLayer.lineWidth = self.backLineWidth;
    [self.layer addSublayer:self.backShapeLayer];
    
    self.backCirclePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius
                                                     startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    self.backShapeLayer.path = self.backCirclePath.CGPath;
    
    self.frontShapeLayer.frame = irect;
    self.frontShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.frontShapeLayer.strokeColor = self.arcLineColor.CGColor;
    self.frontShapeLayer.lineCap = kCALineCapRound;
    
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0 inModes:@[NSRunLoopCommonModes]];
}

- (void)startAnimation
{
    CGFloat halfWidth = irect.size.width * 0.5;
    CGPoint center    = CGPointMake(halfWidth, halfWidth);
    CGFloat radius    = halfWidth - self.arcLineWidth * 0.5 - 5;
    
    self.frontShapeLayer.lineWidth = self.arcLineWidth;
    
    [self.layer addSublayer:self.frontShapeLayer];
    
    CGFloat startAngle, endAngle;
    
    startAngle = kDegree2radius(self.arcStartAngle);
    
    if (_isBackAnimation) {
        endAngle = p_lastEndAngle;
        
        ratio = 1.0 - (CGFloat)(p_lastPercent - self.percent) / (CGFloat)p_lastPercent;
    } else {
        p_lastPercent = self.percent;
        
        endAngle = self.percent ? kDegree2radius(self.percent / 100.0 * 360) + startAngle : startAngle;
        
        p_lastEndAngle = endAngle;
    }
    
    self.frontCirclePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius
                                                      startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    self.frontShapeLayer.path = self.frontCirclePath.CGPath;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = self.animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    animation.fromValue = [NSNumber numberWithFloat:_isBackAnimation? 1: 0];
    animation.toValue   = [NSNumber numberWithFloat:_isBackAnimation? ratio: 1];
    
    animation.autoreverses = NO;
    animation.repeatCount  = 1;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.frontShapeLayer addAnimation:animation forKey:nil];
    
}

- (CAShapeLayer *)backShapeLayer {
	if (_backShapeLayer == nil) {
        _backShapeLayer = [CAShapeLayer layer];
	}
	return _backShapeLayer;
}

- (CAShapeLayer *)frontShapeLayer {
	if (_frontShapeLayer == nil) {
        _frontShapeLayer = [CAShapeLayer layer];
	}
	return _frontShapeLayer;
}

@end
