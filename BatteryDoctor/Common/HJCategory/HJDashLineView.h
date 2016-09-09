//
//  HJDashLineView.h
//  WaaShow
//
//  Created by hj on 16/7/27.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HJLineTypeDashLine,
    HJLineTypeStraightLine
} HJLineType;

IB_DESIGNABLE

@interface HJDashLineView : UIView

// 如果不指定 lineType，默认绘制虚线，否则为实线
@property (nonatomic, assign) IBInspectable BOOL lineType;

/**
 线条宽度 lineWidth 默认 1
 线条颜色 lineColor 默认 blackColor
 偏移点数 movePoint 默认 0
 绘制点数 drawPoint 默认 5
 跳过点数 stepPoint 默认 3
 
 当视图宽大于高，水平虚线
 当视图高大于宽，竖直虚线
 当视图宽高相等，竖直虚线
 */
@property (nonatomic, assign) IBInspectable CGFloat  lineWidth;
@property (nonatomic, strong) IBInspectable UIColor *lineColor;
@property (nonatomic, assign) IBInspectable CGFloat  movePoint;
@property (nonatomic, assign) IBInspectable CGFloat  drawPoint;
@property (nonatomic, assign) IBInspectable CGFloat  stepPoint;

@end
