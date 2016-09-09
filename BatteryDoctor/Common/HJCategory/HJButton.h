//
//  HJButton.h
//  HJCategory
//
//  Created by hj on 16/7/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, POImagePosition) {
    POImagePositionLeft   = 0,  // 图片左文字右
    POImagePositionRight  = 1,  // 图片右文字左
    POImagePositionTop    = 2,  // 图片上文字下
    POImagePositionBottom = 3,  // 图片下文字上
};

@interface UIButton (ImagePosition)

/**
 *  设置按钮图片和文字的位置
 *
 *  @param postion 图片和文字的位置类型
 *  @param inset   图片和文字的间距
 */
- (void)hj_setImagePosition:(POImagePosition)postion withInset:(CGFloat)inset;

@end

@interface UIButton (EnlargeEdge)

/**
 *  同时向按钮的四个方向延伸响应面积
 *
 *  @param size 间距
 */
- (void)hj_setEnlargeEdge:(CGFloat) size;

/**
 *
 *  向按钮的四个方向延伸响应面积
 *
 *  @param top    上间距
 *  @param left   左间距
 *  @param bottom 下间距
 *  @param right  右间距
 */
- (void)hj_setEnlargeEdgeWithTop:(CGFloat) top left:(CGFloat) left bottom:(CGFloat) bottom right:(CGFloat) right;

@end

@interface UIButton (Simplify)

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * highlightedtTitle;
@property (nonatomic, copy) NSString * selectedTitle;

@property (nonatomic, strong) UIColor * titleColor;
@property (nonatomic, strong) UIColor * highlightedTitleColor;
@property (nonatomic, strong) UIColor * selectedTitleColor;

@property (nonatomic, strong) UIImage * image;
@property (nonatomic, strong) UIImage * highlightedImage;
@property (nonatomic, strong) UIImage * selectedImage;

@property (nonatomic, strong) UIImage * backgroundImage;
@property (nonatomic, strong) UIImage * highlightedBackgroundImage;
@property (nonatomic, strong) UIImage * selectedBackgroundImage;

- (void)addTarget:(id)target action:(SEL)action;

@end


typedef void(^RunBlock)(UIButton *button, NSInteger totalTime, NSInteger leftTime);
typedef void(^EndBlock)(UIButton *button);

@interface UIButton (CountDown)

/**
 *  倒计时按钮
 *
 *  为防止文字闪烁，请将UIButton的类型由 System 改为 Custom
 *
 *  @param duration 总时间
 *  @param runBlock 倒计时期间回调
 *  @param endBlock 倒计时结束回调
 */
- (void)hj_startWithDuration:(NSInteger)duration
                     running:(RunBlock)runBlock
                    finished:(EndBlock)endBlock;


@end

