//
//  UILabel+digitAnimation.m
//  digitAnimation
//
//  Created by RHC on 15/8/24.
//  Copyright (c) 2015年 com.launch. All rights reserved.
//

#import "UILabel+digitAnimation.h"
/**
 *  @brief  存储动画相关数据，用来使用key移除定时器用
 */
static NSMutableDictionary *digitAnimationDict;

/**
 *  @brief  动画相关数据
 */
@interface digitAnimationData : NSObject
/**
 *  @brief  定时器指针
 */
@property (nonatomic, weak) NSTimer *timer;
/**
 *  @brief  实际值，在循环过程中这个值是变化的
 */
@property (nonatomic) CGFloat value;
/**
 *  @brief  目标值
 */
@property (nonatomic) CGFloat toValue;
/**
 *  @brief  每一次跳动的大小
 */
@property (nonatomic) CGFloat stepValue;
/**
 *  @brief  显示格式
 */
@property (nonatomic, copy) NSString *frame;
@end

@implementation digitAnimationData
@end

@implementation UILabel (digitAnimation)
-(void)animationFrom:(CGFloat)fromValue to:(CGFloat)toValue time:(NSTimeInterval)time stepTime:(NSTimeInterval)stepTime frame:(NSString *)frame {
    // 以自身地址为键
    NSString *key = [NSString stringWithFormat:@"%lx", (NSUInteger)self];
    // 创建动画数据存储器
    if (digitAnimationDict == nil) {
        digitAnimationDict = [NSMutableDictionary dictionary];
    }
    
    digitAnimationData *data = digitAnimationDict[key];
    if (data == nil) {
        // 创建动画数据对象
        data = [[digitAnimationData alloc] init];
        digitAnimationDict[key] = data;
    }
    else {
        // 移除原有的定时器
        [data.timer invalidate];
    }
    
    data.value = fromValue;
    data.toValue = toValue;
    data.stepValue = (toValue - fromValue) / (time / stepTime);
    data.frame = frame;
    data.timer = [NSTimer scheduledTimerWithTimeInterval:stepTime target:self selector:@selector(timerFireMethod:) userInfo:key repeats:YES];
}

- (void)timerFireMethod:(NSTimer *)timer {
    NSString *key = timer.userInfo;
    digitAnimationData *data = digitAnimationDict[key];
    // 对比动画数据中的定时器和参数定时器看是否是同一个
    if (data.timer != timer) {
        return;
    }
    // 改变值
    data.value += data.stepValue;
    if ((data.stepValue < -0.01 && data.value >= data.toValue)
        || (data.stepValue > 0.01 && data.value <= data.toValue)) {
        // 显示值
        self.text = [NSString stringWithFormat:data.frame, data.value];
    }
    else {
        // 销毁定时器并从动画存储器中移动动画数据
        [data.timer invalidate];
        [digitAnimationDict removeObjectForKey:key];
    }
}
@end
