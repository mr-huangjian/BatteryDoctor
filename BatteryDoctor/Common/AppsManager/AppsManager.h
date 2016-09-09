//
//  AppsManager.h
//  BatteryDoctor
//
//  Created by hj on 16/8/24.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AppStandardName) {
    app_WeChat,
    app_QQ,
    app_Weibo,
    app_Alipay,
    app_Facebook,
    app_Twitter,
    app_Instagram,
};

@interface AppsManager : NSObject

/* 根据枚举表判断该应用是否已安装 */
+ (BOOL)isInstalledApp:(AppStandardName)app;

/* 传递某些应用的URLScheme来判断它们是否已安装 */
+ (BOOL)isInstalledApps:(NSArray <NSString *> *)URLSchemes;

@end
