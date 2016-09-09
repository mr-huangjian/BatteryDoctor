//
//  HJString.m
//  WaaShow
//
//  Created by hj on 16/8/8.
//  Copyright © 2016年 ShanRuo. All rights reserved.
//

#import "HJString.h"

@implementation NSString (Extensin)

- (BOOL)isPureInt {
    NSScanner * scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isContainerString:(NSString *)subString {
    if([self rangeOfString:subString].location != NSNotFound) {
        return YES;
    }
    return NO;
}

@end
