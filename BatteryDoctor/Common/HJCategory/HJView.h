//
//  HJView.h
//  HJCategory
//
//  Created by hj on 16/7/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;

// x + width
@property (nonatomic, assign, readonly) CGFloat xWidth;

// y + height
@property (nonatomic, assign, readonly) CGFloat yHeight;

- (void)removeAllSubviews;

@end
