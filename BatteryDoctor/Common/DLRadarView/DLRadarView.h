//
//  DLRadarImageView.h
//  wearable
//
//  Created by cenon on 16/5/7.
//  Copyright © 2016年 jawatch. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface DLRadarView : UIView

/**
 波纹背景颜色 circleColor
 波纹条数    circleCount
 波纹边框颜色 borderColor
 波纹中心图片 centerImage
 一组动画持续时长 duration
 */
@property (nonatomic, strong) IBInspectable UIColor   * circleColor;
@property (nonatomic, assign) IBInspectable NSInteger   circleCount;
@property (nonatomic, strong) IBInspectable UIColor   * borderColor;
@property (nonatomic, strong) IBInspectable UIImage   * centerImage;
@property (nonatomic, assign) IBInspectable double      duration;

- (void)resume;

@end
