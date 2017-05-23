//
//  HealthyPreViewController.m
//  BatteryDoctor
//
//  Created by hj on 16/8/25.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HealthyPreViewController.h"

@interface HealthyPreViewController ()

@property (weak, nonatomic) IBOutlet DLRadarView *radarView;

@end

@implementation HealthyPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setIBOutlet];
    [self setIBAction];
    
    for (int i = 0; i < 5; i++) {
        NSLog(@"i = %d", i);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HealthyScanPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HealthyScanPage"];
}

- (void)setIBOutlet
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_transparent"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setIBAction
{
    @WeakObj(self);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController * vc = [UIStoryboard storyboardWithName:@"Main" identifier:NSStringFromClass(HealthyViewController.class)];

        [selfWeak.navigationController pushViewController:vc animated:YES];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.radarView resume];
}

@end
