//
//  DeviceManager.m
//  BatteryDoctor
//
//  Created by hj on 16/8/24.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "DeviceManager.h"
#include <sys/utsname.h>

@interface DeviceManager ()

@property (nonatomic, strong) NSDictionary * fileSystemDiskInfomation;

@end

static NSInteger GB_Unit = 1024 * 1024 * 1024;
static NSInteger MB_Unit = 1024 * 1024;
static NSInteger KB_Unit = 1024;

static NSString * KEY_fileSystemSize_GBUnit     = @"fileSystemSize_GBUnit";
static NSString * KEY_freeFileSystemSize_GBUnit = @"freeFileSystemSize_GBUnit";
static NSString * KEY_fileSystemSize            = @"fileSystemSize";
static NSString * KEY_freeFileSystemSize        = @"freeFileSystemSize";

@implementation DeviceManager

+ (DeviceType)currentPlatform {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString * platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone3,1"]) return DeviceType_iPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"]) return DeviceType_iPhone_4;
    if ([platform isEqualToString:@"iPhone3,3"]) return DeviceType_iPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"]) return DeviceType_iPhone_4s;
    if ([platform isEqualToString:@"iPhone5,1"]) return DeviceType_iPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"]) return DeviceType_iPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"]) return DeviceType_iPhone_5c;
    if ([platform isEqualToString:@"iPhone5,4"]) return DeviceType_iPhone_5c;
    if ([platform isEqualToString:@"iPhone6,1"]) return DeviceType_iPhone_5s;
    if ([platform isEqualToString:@"iPhone6,2"]) return DeviceType_iPhone_5s;
    if ([platform isEqualToString:@"iPhone7,1"]) return DeviceType_iPhone_6_plus;
    if ([platform isEqualToString:@"iPhone7,2"]) return DeviceType_iPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"]) return DeviceType_iPhone_6s;
    if ([platform isEqualToString:@"iPhone8,2"]) return DeviceType_iPhone_6s_plus;

    return DeviceType_Unknown;
}

+ (CGFloat)fileSystemSize_GBUnit {
    return [[self.fileSystemDiskInfomation objectForKey:KEY_fileSystemSize_GBUnit] floatValue];
}

+ (CGFloat)freeFileSystemSize_GBUnit {
    return [[self.fileSystemDiskInfomation objectForKey:KEY_freeFileSystemSize_GBUnit] floatValue];
}

+ (NSString *)fileSystemSize {
    return [self.fileSystemDiskInfomation objectForKey:KEY_fileSystemSize];
}

+ (NSString *)freeFileSystemSize {
    return [self.fileSystemDiskInfomation objectForKey:KEY_freeFileSystemSize];
}

- (NSDictionary *)fileSystemDiskInfomation {
    if (_fileSystemDiskInfomation == nil) {
        _fileSystemDiskInfomation = [self.class fileSystemDiskInfomation];
    }
    return _fileSystemDiskInfomation;
}

+ (NSDictionary *)fileSystemDiskInfomation {
    
    CGFloat fileSystemSize_GBUnit;
    CGFloat freeFileSystemSize_GBUnit;
    
    NSString * fileSystemSize;
    NSString * freeFileSystemSize;
    
    NSError * error = nil;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSDictionary * dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        
        NSNumber * fileSystemSizeInBytes     = [dictionary objectForKey:NSFileSystemSize];
        NSNumber * freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        
        fileSystemSize_GBUnit     = fileSystemSizeInBytes.floatValue / GB_Unit;
        freeFileSystemSize_GBUnit = freeFileSystemSizeInBytes.floatValue / GB_Unit;

        fileSystemSize     = [self fileSizeFormatter:fileSystemSizeInBytes.floatValue];
        freeFileSystemSize = [self fileSizeFormatter:freeFileSystemSizeInBytes.floatValue];
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return @{KEY_fileSystemSize : fileSystemSize,
             KEY_freeFileSystemSize : freeFileSystemSize,
             KEY_fileSystemSize_GBUnit : @(fileSystemSize_GBUnit),
             KEY_freeFileSystemSize_GBUnit : @(freeFileSystemSize_GBUnit)};
}

+ (NSString *)fileSizeFormatter:(CGFloat)size {
    
    if (size > GB_Unit) {
        return [NSString stringWithFormat:@"%.1fG", (CGFloat)(size / GB_Unit)];// 大于1G，则转化成G单位的字符串
    }
    else if (size < GB_Unit && size >= MB_Unit) // 大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%.1fM", (CGFloat)(size / MB_Unit)];
    }
    else if (size < MB_Unit && size >= KB_Unit) // 不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%.1fK", (CGFloat)(size / KB_Unit)];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%.1fB", size];
    }
}

@end
