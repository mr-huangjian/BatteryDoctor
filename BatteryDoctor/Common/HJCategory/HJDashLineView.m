//
//  HJDashLineView.m
//  WaaShow
//
//  Created by hj on 16/7/27.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import "HJDashLineView.h"

@implementation HJDashLineView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 由于设置的是直线或虚线，直接设置背景颜色为透明
    self.backgroundColor = [UIColor clearColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

//FEIYU HJDashLineView 性能需要优化
/**
 *  @author feiyu, 07.28 09:07 2016
    
    file:///Users/hj/WaaShow2Version/WaaShow/WaaShow/MVCS/LoginRegister/Controller/LoginRegister.storyboard:
 
    error: IB Designables: Failed to render instance of HJDashLineView: Rendering the view took longer than 200 ms. 
    Your drawing code may suffer from slow performance.
 */
-(void)drawRect:(CGRect)rect
{
    CGContextRef context  = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    if (width > height)
    {
        CGPathMoveToPoint(path, nil, 0, height / 2.f);
        CGPathAddLineToPoint(path, nil, width, height / 2.f);
    }
    else
    {
        CGPathMoveToPoint(path, nil, width / 2.f, 0);
        CGPathAddLineToPoint(path, nil, width / 2.f, height);
    }
    
    CGContextAddPath(context, path);
    
    CGContextSetStrokeColorWithColor(context, self.lineColor ? self.lineColor.CGColor : [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, self.lineWidth == 0 ? 1 : self.lineWidth);
    
    if (self.lineType == HJLineTypeDashLine)
    {
        CGFloat lengths[2] = {self.drawPoint == 0 ? 5 : self.drawPoint, self.stepPoint == 0 ? 3 : self.stepPoint};
        CGContextSetLineDash(context, self.movePoint == 0 ? 0 : -self.movePoint, lengths, 2);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)setLineType:(BOOL)lineType
{
    _lineType = lineType;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setMovePoint:(CGFloat)movePoint
{
    _movePoint = movePoint;
    [self setNeedsDisplay];
}

- (void)setDrawPoint:(CGFloat)drawPoint
{
    _drawPoint = drawPoint;
    [self setNeedsDisplay];
}

- (void)setStepPoint:(CGFloat)stepPoint
{
    _stepPoint = stepPoint;
    [self setNeedsDisplay];
}

@end
