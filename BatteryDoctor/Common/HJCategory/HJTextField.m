//
//  HJTextField.m
//  WaaShow
//
//  Created by hj on 16/7/28.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import "HJTextField.h"

@implementation UITextField (HJKeyPath)

/**
 *  @author feiyu, 07.28 13:07 2016
 *
 *  @brief 在 Xib 或 Storyboard 中设置光标的颜色
 *
 *  KeyPath: pointColor => Color => #xxxxxx
 */
- (void)setPointColor:(UIColor *)color
{
    self.tintColor = color;
}

/**
 *  @author feiyu, 07.28 13:07 2016
 *
 *  @brief 在 Xib 或 Storyboard 中设置提示文字的颜色
 *
 *  KeyPath: placeholderColor => Color => #xxxxxx
 */
- (void)setPlaceholderColor:(UIColor *)color
{
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

/**
 *  @author feiyu, 07.28 13:07 2016
 *
 *  @brief 在 Xib 或 Storyboard 中设置提示文字的字号
 *
 *  KeyPath: placeholderFont => Number => 17
 */
- (void)setPlaceholderFont:(NSNumber *)size
{
    [self setValue:[UIFont systemFontOfSize:size.intValue] forKeyPath:@"_placeholderLabel.font"];
}

@end

@implementation UITextField (LeftViewAndRightView)

- (void)addLeftViewWithImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)addLeftIndent:(CGFloat)width
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    self.leftView = imageView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
