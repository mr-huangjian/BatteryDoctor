//
//  AppsManager.m
//  BatteryDoctor
//
//  Created by hj on 16/8/24.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "AppsManager.h"

NSArray * URLSchemes(AppStandardName app) {
    switch (app) {
        case app_WeChat:
            return @[@"wechat",
                     @"weixin"];
            break;
        case app_QQ:
            return @[@"mqq",
                     @"mqqapi",
                     @"mqqOpensdkSSoLogin",
                     @"mqqopensdkapiV2",
                     @"mqqopensdkapiV3",
                     @"wtloginmqq2"];
            break;
        case app_Weibo:
            return @[@"sinaweibo",
                     @"sinaweibosso",
                     @"sinaweibohd",
                     @"weibosdk",
                     @"weibosdk2.5"];
            break;
        case app_Alipay:
            return @[@"alipay",
                     @"alipayshare"];
            break;
        case app_Facebook:
            return @[@"fb",
                     @"fbauth2"];
            break;
        case app_Twitter:
            return @[@"twitter"];
            break;
        case app_Instagram:
            return @[@"instagram"];
            break;
        default:
            return @[];
            break;
    }
}

@implementation AppsManager

+ (BOOL)isInstalledApp:(AppStandardName)app
{
    return [self isInstalledApps:URLSchemes(app)];
}

+ (BOOL)isInstalledApps:(NSArray<NSString *> *)URLSchemes
{
    for (NSString * URLScheme in URLSchemes)
    {
        NSURL * AppURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", URLScheme]];
        
        if ([[UIApplication sharedApplication] canOpenURL:AppURL])
        {
            return YES;
        }
    }
    return NO;
}

@end
