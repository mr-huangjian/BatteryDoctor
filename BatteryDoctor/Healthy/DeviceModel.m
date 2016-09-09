//
//  DeviceModel.m
//  BatteryDoctor
//
//  Created by 黄健 on 16/8/27.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

+ (instancetype)sharedModel
{
    static DeviceModel * model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[self alloc] init];
        
        NSData * JsonData  = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Device" ofType:@"json"]];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary * item in dic[@"list"]) {
            
            if ([DeviceManager currentPlatform] == [item[@"device_no"] integerValue]) {
                
                [model setValuesForKeysWithDictionary:item];
            }
        }
    });
    return model;
}

@end