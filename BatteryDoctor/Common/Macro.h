//
//  Macro.h
//  BatteryDoctor
//
//  Created by hj on 16/8/22.
//  Copyright © 2016年 hj. All rights reserved.
//

#define statusH 20
#define navBarH 44
#define statusAndNavBarH 64
#define tabBarH 49

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#define Theme_BlueColor @"#5aacff"

// Block 弱引用
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define Localized(string) NSLocalizedString(string, nil)

#define AppUserDefaults  [NSUserDefaults standardUserDefaults]

#define AppBundleID      [[NSBundle mainBundle] bundleIdentifier]
#define AppBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// SystemLanguages与PreferredLanguages完全等同，
// 获取首选语言顺序表(数组)，第一个元素即当前系统语言

#define AppSystemLanguages    [NSLocale preferredLanguages]
#define AppPreferredLanguages [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]

// AppSystemLanguage与AppCurrentLanguage不完全等同，
// AppCurrentLanguage不携带区域地区格式
#define AppSystemLanguage     [[NSLocale currentLocale] localeIdentifier]
#define AppCurrentLanguage    [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]
