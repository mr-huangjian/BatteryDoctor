//
//  CleanViewController.m
//  BatteryDoctor
//
//  Created by hj on 16/8/26.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "CleanViewController.h"

@interface CleanViewController ()
{
    BOOL p_isCleanSuccess;
    
    CGFloat  p_preUsedMemoryPercent;
    NSString * p_preFreeMemory;
    
    CGFloat  p_nextUsedMemoryPercent;
    NSString * p_nextFreeMemory;
    
    NSTimeInterval p_timeStamp;
}
@property (weak, nonatomic) IBOutlet UIButton  * tipButton;
@property (weak, nonatomic) IBOutlet CleanView * cleanView;
@property (weak, nonatomic) IBOutlet UIView * dataView;
@property (weak, nonatomic) IBOutlet UIView * releaseView;

@property (weak, nonatomic) IBOutlet UILabel *memoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@property (nonatomic, strong) DeviceModel * deviceModel;

@end

static NSString * LastCleanResult   = @"LastCleanResult";
static NSString * TimeStamp         = @"TimeStamp";
static NSString * UsedMemoryPercent = @"UsedMemoryPercent";
static NSString * FreeMemory        = @"FreeMemory";

@implementation CleanViewController

- (void)dealloc
{
    self.tipButton = nil;
    self.cleanView = nil;
    self.dataView  = nil;
    self.releaseView = nil;
    self.percentLabel = nil;
    self.deviceModel = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setIBOutlet];
    [self setIBAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"CleanPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"CleanPage"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.dataView.layer.cornerRadius = self.dataView.bounds.size.width / 2.0;
}

- (void)setIBOutlet
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_transparent"] forBarMetrics:UIBarMetricsDefault];
    
    self.tipButton.userInteractionEnabled = NO;
    
    self.cleanView.hidden   = NO;
    self.dataView.hidden    = NO;
    self.releaseView.hidden = YES;
}

- (void)setIBAction
{
    p_timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSDictionary * lastClean = [AppUserDefaults objectForKey:LastCleanResult];
    
    if (lastClean && [lastClean[TimeStamp] integerValue] + 2 * 60 > p_timeStamp) {
        
        p_nextUsedMemoryPercent = [[lastClean objectForKey:UsedMemoryPercent] floatValue];
        p_nextFreeMemory        =  [lastClean objectForKey:FreeMemory];
        
        p_preUsedMemoryPercent  = p_nextUsedMemoryPercent;
        
        self.cleanView.percent = p_nextUsedMemoryPercent * 100;
        self.cleanView.animationDuration = 1.f;
        
        self.percentLabel.text = [NSString stringWithFormat:@"%.f%%", p_nextUsedMemoryPercent * 100];
        
        [self.tipButton setImage:nil forState:UIControlStateNormal];
        [self.tipButton setTitle:Localized(@"well running, shouldn't accelerate")
                        forState:UIControlStateNormal];
        
    } else {
        
        NSString * memory = [DeviceModel sharedModel].ramdom_access_memory;
        NSString * memorySub = [memory substringWithRange:NSMakeRange(0, memory.length - 2)];
        
        NSInteger temp = [[NSString stringWithFormat:@"%.2f", [DeviceManager freeFileSystemSize_GBUnit]] floatValue] * 100;

        if (temp >= 100) {
            temp = 90 + [[@(temp).stringValue substringFromIndex:@(temp).stringValue.length - 1] integerValue];
        }
        
        NSInteger rand = [HJHelper randomNumberFrom:temp - 8 to:temp - 5];
        
        p_preUsedMemoryPercent  = rand / 100.f;
        p_nextUsedMemoryPercent = [HJHelper randomNumberFrom:20 to:40] / 100.f;
        
        CGFloat temp_pre, temp_next;
        
        if ([memory hasSuffix:@"MB"]) {
            temp_pre  = memorySub.floatValue * (1 - p_preUsedMemoryPercent);
            temp_next = memorySub.floatValue * (1 - p_nextUsedMemoryPercent);
        } else if ([memory hasSuffix:@"GB"]) {
            temp_pre  = memorySub.floatValue * (1 - p_preUsedMemoryPercent)  * 1024;
            temp_next = memorySub.floatValue * (1 - p_nextUsedMemoryPercent) * 1024;
        }
        
        p_preFreeMemory  = [NSString stringWithFormat:@"%.fMB", temp_pre];
        p_nextFreeMemory = [NSString stringWithFormat:@"%.fMB", temp_next];

        self.cleanView.percent = p_preUsedMemoryPercent * 100;
        self.cleanView.animationDuration = 1.f;
        
        self.percentLabel.text = [NSString stringWithFormat:@"%.f%%", p_preUsedMemoryPercent * 100];
    }
}

- (IBAction)powerSaveButtonAction:(UIButton *)sender {
    
    if (p_isCleanSuccess) { [self.navigationController popToRootViewControllerAnimated:YES]; return; }
    
    [MobClick event:@"click_clean_powersavenow"];
    
    NSDictionary * lastCleanResult = @{TimeStamp        : @(p_timeStamp),
                                       UsedMemoryPercent: @(p_nextUsedMemoryPercent),
                                       FreeMemory       : p_nextFreeMemory};
    
    [AppUserDefaults setObject:lastCleanResult forKey:LastCleanResult];
    
    @WeakObj(self);
    
    [UIView animateWithDuration:1.f animations:^{
        selfWeak.tipButton.hidden = YES;
        sender.userInteractionEnabled = NO;
        sender.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        [sender setTitle:Localized(@"clear the memory") forState:UIControlStateNormal];
        
        selfWeak.cleanView.isBackAnimation = YES;
        selfWeak.cleanView.percent = p_nextUsedMemoryPercent * 100;
        selfWeak.percentLabel.text = [NSString stringWithFormat:@"%.f%%", p_nextUsedMemoryPercent * 100];
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            p_isCleanSuccess = YES;
            selfWeak.cleanView.hidden   = YES;
            selfWeak.dataView.hidden    = YES;
            selfWeak.releaseView.hidden = NO;
            sender.userInteractionEnabled = YES;
            sender.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            [sender setTitle:Localized(@"finish") forState:UIControlStateNormal];
            
            NSInteger temp1 = (p_preUsedMemoryPercent - p_nextUsedMemoryPercent) * 1024.0;
            NSInteger temp2 = (p_preUsedMemoryPercent - p_nextUsedMemoryPercent) * 120;
            
            if (temp2 == 0) {
                selfWeak.memoryLabel.text = [NSString stringWithFormat:@"%@ 0MB\n%@ 0%@",
                                             Localized(@"released"), Localized(@"save power"), Localized(@"minute")];
            } else if (temp2 / 60 == 0) {
                selfWeak.memoryLabel.text = [NSString stringWithFormat:@"%@ %ldMB\n%@ %.2ld%@",
                                             Localized(@"released"), (long)temp1, Localized(@"save power"),
                                             temp2 % 60, Localized(@"minute")];
            }  else if (temp2 % 60 == 0) {
                selfWeak.memoryLabel.text = [NSString stringWithFormat:@"%@ %ldMB\n%@ %ld%@",
                                             Localized(@"released"), (long)temp1, Localized(@"save power"),
                                             temp2 / 60, Localized(@"hour")];
            } else {
                selfWeak.memoryLabel.text = [NSString stringWithFormat:@"%@ %ldMB\n%@ %ld%@%.2ld%@",
                                             Localized(@"released"), (long)temp1, Localized(@"save power"),
                                             temp2 / 60, Localized(@"hour"),
                                             temp2 % 60, Localized(@"minute")];
            }
            
        });
        
    }];
}

- (DeviceModel *)deviceModel {
	if (_deviceModel == nil) {
        _deviceModel = [DeviceModel sharedModel];
	}
	return _deviceModel;
}

@end
