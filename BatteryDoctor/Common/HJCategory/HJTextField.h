//
//  HJTextField.h
//  WaaShow
//
//  Created by hj on 16/7/28.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HJKeyPath)

@end

@interface UITextField (LeftViewAndRightView)

// 为 UITextField 的左边添加图标
- (void)addLeftViewWithImage:(UIImage *)image;

- (void)addLeftIndent:(CGFloat)width;

@end
