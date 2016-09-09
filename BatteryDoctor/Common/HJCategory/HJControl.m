//
//  HJControl.m
//  HJControl
//
//  Created by 黄健 on 16/8/7.
//  Copyright © 2016年 黄健. All rights reserved.
//

#import "HJControl.h"
#import <objc/runtime.h>

@implementation UIControl (HJTouch)

static const char * UIControl_TimeInterval = "UIControl_TimeInterval";
static const char * UIControl_DisableEvent = "UIcontrol_DisableEvent";

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, UIControl_TimeInterval, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, UIControl_TimeInterval) doubleValue];
}

- (void)setDisableEvent:(BOOL)disableEvent {
    objc_setAssociatedObject(self, UIControl_DisableEvent, @(disableEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)disableEvent {
    return [objc_getAssociatedObject(self, UIControl_DisableEvent) boolValue];
}

+ (void)load {
//    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
//    Method b = class_getInstanceMethod(self, @selector(hj_sendAction:to:forEvent:));
//    method_exchangeImplementations(a, b);
}

- (void)hj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if (self.disableEvent) return;
    
    if (self.timeInterval > 0) {
        
        self.disableEvent = YES;
        
        [self performSelector:@selector(setDisableEvent:) withObject:@(NO) afterDelay:self.timeInterval];
    }
    
    [self hj_sendAction:action to:target forEvent:event];
}

@end
