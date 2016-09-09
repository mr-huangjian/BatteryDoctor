//
//  HealthyViewController.m
//  BatteryDoctor
//
//  Created by hj on 16/8/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HealthyViewController.h"
#import "HealthView.h"

@interface HealthyViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * backViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * frontViewTopMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * batteryPercentTopMargin;

@property (weak, nonatomic) IBOutlet UILabel  * percentLabel;
@property (weak, nonatomic) IBOutlet UILabel  * actualCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel  * theoreticalCapacityLabel;
@property (weak, nonatomic) IBOutlet UIButton * showResultButton;

@property (weak, nonatomic) IBOutlet HealthView *healthView;

@property (nonatomic, assign) NSInteger theoreticalCapacity;
@property (nonatomic, assign) NSInteger actualCapacity;

@property (nonatomic, strong) DeviceModel * deviceModel;

@property (nonatomic, strong) KeychainItemWrapper *keychain;

@end

@implementation HealthyViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setIBOutlet];
    [self setIBAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HealthyResultPage"];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:[self.navigationController.navigationController viewControllers]];
    if (viewControllers.count >= 2) {
        [viewControllers removeObjectAtIndex:1];
    }
    [self.navigationController.navigationController setViewControllers:viewControllers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HealthyResultPage"];
}

- (void)setIBOutlet
{
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = HexStringColor(Theme_BlueColor);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    if (screenH == 480) { self.backViewTopMargin.constant  -= 30;
                          self.frontViewTopMargin.constant -= 30; }
    
    if (screenW == 320) { self.batteryPercentTopMargin.constant -= 10; }
    
    self.showResultButton.userInteractionEnabled = NO;
    self.showResultButton.layer.borderColor  = HexStringColor(Theme_BlueColor).CGColor;
    self.showResultButton.layer.borderWidth  = .6f;
    self.showResultButton.layer.cornerRadius = 3.f;
    self.showResultButton.backgroundColor = [UIColor clearColor];
    [self.showResultButton setTitleColor:HexStringColor(Theme_BlueColor) forState:UIControlStateNormal];
}

- (void)setIBAction
{
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"itemBack"] style:UIBarButtonItemStyleDone target:self action:@selector(backItemAction)];
    item.tintColor = UIWhiteColor;
    self.navigationItem.leftBarButtonItem = item;
    
    self.theoreticalCapacity = [[self.deviceModel.battery_capacity substringToIndex:self.deviceModel.battery_capacity.length - 3] integerValue];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.deviceModel.battery_capacity];
    [attrString addAttribute:NSForegroundColorAttributeName value:HexStringColor(Theme_BlueColor) range:NSMakeRange(0, self.deviceModel.battery_capacity.length - 3)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:NSMakeRange(0, self.deviceModel.battery_capacity.length - 3)];
    
    self.theoreticalCapacityLabel.attributedText = attrString;
    
    [self.keychain resetKeychainItem];
    
    [self BatteryHealth];
}

- (void)BatteryHealth
{
    NSInteger batteryHealthDegree;
    
//    if([self.keychain objectForKey:(__bridge id)(kSecAttrService)] == NO)
//    {   // 产生一个随机的电池健康度
        if (screenH == 480) {
            batteryHealthDegree = self.theoreticalCapacity ? [HJHelper randomNumberFrom:86 to:92] : 0;
        } else if (screenH == 568) {
            batteryHealthDegree = self.theoreticalCapacity ? [HJHelper randomNumberFrom:92 to:95] : 0;
        } else {
            batteryHealthDegree = self.theoreticalCapacity ? [HJHelper randomNumberFrom:95 to:99] : 0;
        }
        
//        [self.keychain setObject:@(batteryHealthDegree).stringValue forKey:(__bridge id)(kSecAttrService)];
//    } else { // 获取已保存好的电池健康度
//        batteryHealthDegree = [[self.keychain objectForKey:(__bridge id)(kSecAttrService)] integerValue];
//    }
    
    NSInteger actualCapacity = self.theoreticalCapacity * batteryHealthDegree / 100.0;
    
    // 保存该设备的电池健康度、理论容量、实际容量
    NSDictionary * BatteryHealthResult = @{@"theoreticalCapacity":[NSString stringWithFormat:@"%ldmAh", (long)self.theoreticalCapacity],
                                           @"batteryHealthDegree":@(batteryHealthDegree).stringValue,
                                           @"actualCapacity"     :[NSString stringWithFormat:@"%ldmAh", (long)actualCapacity]};
    
    NSString * getActualCapacity = BatteryHealthResult[@"actualCapacity"];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:getActualCapacity];
    [attrString addAttribute:NSForegroundColorAttributeName value:HexStringColor(Theme_BlueColor) range:NSMakeRange(0, getActualCapacity.length - 3)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.f] range:NSMakeRange(0, getActualCapacity.length - 3)];
    
    self.actualCapacityLabel.attributedText = attrString;
    
    self.healthView.percent = batteryHealthDegree;
    [self.self.percentLabel animationFrom:0 to:batteryHealthDegree time:1.3 stepTime:0.01 frame:@"%.f"];
    
    if (self.deviceModel.device_no == 0) { [self.showResultButton setTitle:@"Unknown" forState:UIControlStateNormal]; }
}

- (void)backItemAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (DeviceModel *)deviceModel {
	if (_deviceModel == nil) {
        _deviceModel = [DeviceModel sharedModel];
	}
	return _deviceModel;
}

- (KeychainItemWrapper *)keychain {
	if (_keychain == nil) {
        _keychain = [[KeychainItemWrapper alloc] initWithIdentifier:AppBundleID accessGroup:nil];
	}
	return _keychain;
}

@end
