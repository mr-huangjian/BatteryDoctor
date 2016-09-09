//
//  UILabel+digitAnimation.h
//  digitAnimation
//
//  Created by RHC on 15/8/24.
//  Copyright (c) 2015年 com.launch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (digitAnimation)
/**
 *  @brief  数字变化动画
 *  @param fromValue 开始值
 *  @param toValue   结束值
 *  @param time      时间
 *  @param stepTime  刷新间隔
 *  @param frame     字符显示格式
 */
-(void)animationFrom:(CGFloat)fromValue to:(CGFloat)toValue time:(NSTimeInterval)time stepTime:(NSTimeInterval)stepTime frame:(NSString *)frame;
@end
