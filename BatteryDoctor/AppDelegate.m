//
//  AppDelegate.m
//  BatteryDoctor
//
//  Created by hj on 16/8/22.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //** 启动页停留时间
    [NSThread sleepForTimeInterval:2];
    
    //** 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UMConfigInstance.appKey = @"57c796f3e0f55a82a5002f9f";
    [MobClick startWithConfigure:UMConfigInstance];
    
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick setLogEnabled:YES];
    [MobClick setEncryptEnabled:YES];
    [MobClick setBackgroundTaskEnabled:YES];
    
//    + ISOCountryCodes// 所有的ISO定义的国家地区编码
//    + ISOCurrencyCodes// 所有的ISO定义的货币编码
//    + ISOLanguageCodes// 所有ISO定义的语言编码
    
    // 语言_区域格式
    
    NSLog(@"ISOCountryCodes: %@",  [NSLocale availableLocaleIdentifiers]);
    NSLog(@"ISOCurrencyCodes: %@", [[NSLocale currentLocale] localeIdentifier]);//vi_CN,zh_CN
    NSLog(@"ISOLanguageCodes: %@", [[NSLocale currentLocale] objectForKey:NSLocaleIdentifier]);//vi_CN,zh_CN
    
    NSLog(@"4; %lu", (unsigned long)[NSLocale lineDirectionForLanguage:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]]);
    
    NSLog(@"SystemLanguages: %@", AppSystemLanguages);
    NSLog(@"PreferredLanguages: %@", AppPreferredLanguages);
    
    NSLog(@"AppleLanguage: %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]);
    
    NSLog(@"availableLanguages: %@", [self availableLanguages]);
    
    NSString *languageCode = [[[NSUserDefaults standardUserDefaults] stringForKey:@"LanguageCode"] lowercaseString];
    
    NSLog(@"languageCode: %@", languageCode);
    
    /**
     "zh-Hans-CN",
     "vi-CN"
     */
    
    NSString *currentLanguageCode = [[NSLocale currentLocale] objectForKey: NSLocaleLanguageCode];
    
    NSLog(@"currentLanguageCode: %@", currentLanguageCode);// zh

    [[NSBundle mainBundle] localizedStringForKey:@"" value:@"" table:nil];
    
#define AppLanguage @"appLanguage"
#define CustomLocalizedString(key) \
        [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]

    [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(@"key") value:@"" table:nil];
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:AppLanguage]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
    }
    
    return YES;
}

- (NSArray *)availableLanguages
{
    NSString *extension = @"lproj";
    NSArray *lprojPaths = [[NSBundle mainBundle] pathsForResourcesOfType:extension inDirectory:nil];
    NSMutableArray *availables = [NSMutableArray new];
    
    for (NSString *oneLproj in lprojPaths)
    {
        NSLog(@"oneLproj:    %@", oneLproj);
        
        if (![oneLproj isEqualToString:@"Base.lproj"]){
            NSString *fileName = [oneLproj lastPathComponent];
            [availables addObject:[fileName stringByDeletingPathExtension]];
        }
    }
    
    return availables;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    __block UIBackgroundTaskIdentifier backgroundTask;
    
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (backgroundTask != UIBackgroundTaskInvalid)
            {
                backgroundTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (backgroundTask != UIBackgroundTaskInvalid)
            {
                backgroundTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
