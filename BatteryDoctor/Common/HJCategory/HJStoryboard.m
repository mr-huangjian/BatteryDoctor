//
//  HJStoryboard.m
//  WaaShow
//
//  Created by hj on 16/7/27.
//  Copyright © 2016年 seris-Jam. All rights reserved.
//

#import "HJStoryboard.h"

@implementation UIStoryboard (Extension)

+ (id)storyboardWithName:(NSString *)name identifier:(NSString *)identifier
{
    UIStoryboard *storyboard = [self storyboardWithName:name bundle:nil];
    
    UIViewController *viewController;
    
    if (identifier)
    {
        viewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    else
    {
        viewController = [storyboard instantiateInitialViewController];
    }
    
    return viewController;
}

@end
