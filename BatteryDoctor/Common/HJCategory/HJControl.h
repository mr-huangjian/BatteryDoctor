//
//  HJControl.h
//  HJControl
//
//  Created by 黄健 on 16/8/7.
//  Copyright © 2016年 黄健. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (HJTouch)

// 点击事件的间隔时间
@property (nonatomic, assign) NSTimeInterval timeInterval;

// 是否不响应点击事件
@property (nonatomic, assign) BOOL disableEvent;

@end
