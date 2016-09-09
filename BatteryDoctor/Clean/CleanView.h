//
//  CleanView.h
//  BatteryDoctor
//
//  Created by hj on 16/8/25.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CleanView : UIView

@property (nonatomic, assign) IBInspectable NSInteger percent;

@property (nonatomic, assign) IBInspectable NSInteger backLineWidth;
@property (nonatomic, strong) IBInspectable UIColor * backLineColor;

@property (nonatomic, assign) IBInspectable NSInteger arcStartAngle;
@property (nonatomic, assign) IBInspectable NSInteger arcLineWidth;
@property (nonatomic, strong) IBInspectable UIColor * arcLineColor;

@property (nonatomic, assign) IBInspectable CGFloat animationDuration;

@property (nonatomic, strong) CAShapeLayer * frontShapeLayer;

@property (nonatomic, assign) BOOL isBackAnimation;

@end
