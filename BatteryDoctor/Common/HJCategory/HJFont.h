//
//  HJFont.h
//  WaaShow
//
//  Created by hj on 16/7/28.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define FontWithSize(size) [UIFont hj_systemFontOfSize:size]

@interface UIFont (Extension)

+ (UIFont *)hj_systemFontOfSize:(CGFloat)size;

@end
