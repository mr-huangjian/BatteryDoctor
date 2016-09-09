//
//  ViewController.m
//  BatteryDoctor
//
//  Created by hj on 16/8/22.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewCell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView             * topSuperView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * topSuperViewHeight;
@property (weak, nonatomic) IBOutlet UITableView        * tableView;

@property (weak, nonatomic) IBOutlet UIView * radarSuperView;
@property (weak, nonatomic) IBOutlet UIView * scanView;
@property (weak, nonatomic) IBOutlet UIView * circleView;
@property (weak, nonatomic) IBOutlet UIView * dataView;
@property (weak, nonatomic) IBOutlet CleanView *cleanView;

@property (weak, nonatomic) IBOutlet UILabel * batteryPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel * valueTimeLabel;

@property (nonatomic, strong) NSArray<HomeModel *> * originalGroup;

@property (nonatomic, strong) UITableView * scanTableView;
@property (nonatomic, strong) NSMutableArray * applicationGroup;

@property (nonatomic, strong) DLRadarView * radarView;
@property (nonatomic, strong) ScanView * qrScanView;

@end

static NSString * reuseID_item = @"HomeViewCell";
static NSString * reuseID_scan = @"ScanViewCell";
static NSInteger  currentIndex = 0;

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification    object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setIBOutlet];
    [self setIBAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HomePage"];
    
//    self.radarView.hidden  = YES;
    self.scanView.hidden   = YES;
    self.circleView.hidden = NO;
    self.dataView.hidden   = NO;
    
    self.tableView.hidden = NO;
    self.scanTableView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.dataView.layer.cornerRadius = self.dataView.bounds.size.width / 2.0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HomePage"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
//    [self.radarView resume];
}

- (void)setIBOutlet
{
    self.tableView.scrollEnabled = NO;
    
    if (screenH == 480) {
        self.tableView.rowHeight = 70 * deviceScale;
    } else {
        self.tableView.rowHeight = 80 * deviceScale;
    }
    
    self.topSuperViewHeight.constant = screenH - self.tableView.rowHeight * 3;

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar_transparent"] forBarMetrics:UIBarMetricsDefault];
    
    [self.scanTableView registerNib:[UINib nibWithNibName:@"ScanViewCell" bundle:nil] forCellReuseIdentifier:reuseID_scan];
    [self.view addSubview:self.scanTableView];
}

- (void)setIBAction
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground)
//                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground)
//                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged)
                                                 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
    [self batteryLevelChanged];
}

//- (void)appDidEnterBackground
//{
//    [self.radarView resume];
//}
//
//- (void)appWillEnterForeground
//{
//    [self.radarView resume];
//}

- (void)batteryLevelChanged
{
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    
    self.batteryPercentLabel.text = [NSString stringWithFormat:@"%.f%%", batteryLevel * 100];
    
    NSInteger currentAvailable = 23 * 60 * batteryLevel;
    
    if (currentAvailable % 60 == 0) {
        self.valueTimeLabel.text = [NSString stringWithFormat:@"%@ %ld%@", Localized(@"using time"),
                                    currentAvailable / 60, Localized(@"hour")];
    } else {
        self.valueTimeLabel.text = [NSString stringWithFormat:@"%@ %ld%@%.2ld%@", Localized(@"using time"),
                                    currentAvailable / 60, Localized(@"hour"),
                                    currentAvailable % 60, Localized(@"minute")];
    }
    
    self.cleanView.percent = batteryLevel * 100;
    self.cleanView.animationDuration = 1.0;
}

- (IBAction)powerSaveButtonAction:(UIButton *)sender {
    
    [MobClick event:@"click_home_onekeypower"];
    
//    self.radarView.hidden = NO;
//    [self.radarView resume];
    
    [self.view addSubview:self.qrScanView];
    [self.radarSuperView addSubview:self.radarView];
    
    self.dataView.hidden  = YES;
    self.scanView.hidden  = NO;
    self.cleanView.hidden = YES;
    
    self.tableView.hidden = YES;
    self.scanTableView.hidden = NO;
    
    currentIndex = 0;
    
    [self.scanTableView setContentOffset:CGPointZero animated:NO];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timeAction:(NSTimer *)timer
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
    
    ScanViewCell * cell = [self.scanTableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:YES animated:YES];
    
    [self.scanTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];

    if (currentIndex ++ == self.applicationGroup.count - 1) {
        [timer setFireDate:[NSDate distantFuture]];
        [timer invalidate];
        timer = nil;
        
        @WeakObj(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [selfWeak.qrScanView removeFromSuperview];
            [selfWeak.radarView removeFromSuperview];
            selfWeak.radarView = nil;
            
            UIViewController * vc = [UIStoryboard storyboardWithName:@"Main" identifier:NSStringFromClass(CleanViewController.class)];
            [selfWeak.navigationController pushViewController:vc animated:YES];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual: self.tableView]) {
        return self.originalGroup.count;
    } else {
        return self.applicationGroup.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual: self.tableView]) {
        HomeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID_item];
        
        cell.model = self.originalGroup[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        ScanViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID_scan];
        
        cell.model = self.applicationGroup[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {   //** 预计可用时长
            [MobClick event:@"click_enter_availablePage"];
            
            UIViewController * vc = [UIStoryboard storyboardWithName:@"Main" identifier:NSStringFromClass(AvailableViewController.class)];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {   //** 电池健康监测
            [MobClick event:@"click_enter_healthyPage"];
            
            UIViewController * vc = [UIStoryboard storyboardWithName:@"Main" identifier:NSStringFromClass(HealthyPreViewController.class)];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {   //** 网络测速
            [MobClick event:@"click_enter_speedPage"];
            
            UIViewController * vc = [UIStoryboard storyboardWithName:@"Main" identifier:NSStringFromClass(SpeedViewController.class)];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (DLRadarView *)radarView {
	if (_radarView == nil) {
        _radarView = [[DLRadarView alloc] initWithFrame:self.radarSuperView.bounds];
        _radarView.circleColor = UIWhiteColor;
        _radarView.circleCount = 5;
        _radarView.borderColor = UIWhiteColor;
        _radarView.duration    = 3;
	}
	return _radarView;
}

- (ScanView *)qrScanView {
	if (_qrScanView == nil) {
        _qrScanView = [[ScanView alloc] initWithFrame:self.tableView.frame];
        _qrScanView.backgroundColor = [UIColor clearColor];
	}
	return _qrScanView;
}

- (UITableView *)scanTableView {
	if (_scanTableView == nil) {
        _scanTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topSuperViewHeight.constant, screenW, screenH - self.topSuperViewHeight.constant) style:UITableViewStylePlain];
        _scanTableView.rowHeight = self.tableView.rowHeight;
        _scanTableView.userInteractionEnabled = NO;
        _scanTableView.dataSource = self;
        _scanTableView.delegate = self;
	}
	return _scanTableView;
}

- (NSMutableArray *)applicationGroup {
    if (_applicationGroup == nil) {
        _applicationGroup = [[NSMutableArray alloc] initWithCapacity:30];
        
        //** 挑选的20个系统应用
        NSData * JsonData  = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Application" ofType:@"json"]];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary * item in dic[@"list"]) {
            ApplicationModel * model = [[ApplicationModel alloc] init];
            [model setValuesForKeysWithDictionary:item];
            [_applicationGroup addObject:model];
        }
        
        /** 用户安装应用
         *  app_WeChat, app_QQ, app_Weibo, app_Alipay, app_Facebook, app_Twitter, - app_Instagram */
        if ([AppsManager isInstalledApp:app_WeChat]) {
            ApplicationModel * model = [[ApplicationModel alloc] init];
            model.image_icon = @"app_WeChat";
            model.zh_name = @"微信";
            model.en_name = @"WeChat";
            model.vi_name = @"WeChat";
            [_applicationGroup addObject:model];
        }
        
        if ([AppsManager isInstalledApp:app_QQ]) {
            ApplicationModel * model = [[ApplicationModel alloc] init];
            model.image_icon = @"app_QQ";
            model.zh_name = @"QQ";
            model.en_name = @"QQ";
            model.vi_name = @"QQ";
            [_applicationGroup addObject:model];
        }
        
        if ([AppsManager isInstalledApp:app_Weibo]) {
            ApplicationModel * model = [[ApplicationModel alloc] init];
            model.image_icon = @"app_Weibo";
            model.zh_name = @"微博";
            model.en_name = @"Weibo";
            model.vi_name = @"Weibo";
            [_applicationGroup addObject:model];
        }
        
        if ([AppsManager isInstalledApp:app_Alipay]) {
            ApplicationModel * model = [[ApplicationModel alloc] init];
            model.image_icon = @"app_Alipay";
            model.zh_name = @"支付宝";
            model.en_name = @"Alipay";
            model.vi_name = @"Alipay";
            [_applicationGroup addObject:model];
        }
        
        if ([AppsManager isInstalledApp:app_Facebook]) {
            ApplicationModel * model = [[ApplicationModel alloc] init];
            model.image_icon = @"app_Facebook";
            model.zh_name = @"Facebook";
            model.en_name = @"Facebook";
            model.vi_name = @"Facebook";
            [_applicationGroup addObject:model];
        }
        
        if ([AppsManager isInstalledApp:app_Twitter]) {
            ApplicationModel * model = [[ApplicationModel alloc] init];
            model.image_icon = @"app_Twitter";
            model.zh_name = @"Twitter";
            model.en_name = @"Twitter";
            model.vi_name = @"Twitter";
            [_applicationGroup addObject:model];
        }
    }
    return _applicationGroup;
}

- (NSArray *)originalGroup {
	if (_originalGroup == nil) {
        
        HomeModel * model1 = [[HomeModel alloc] init];
        model1.leftImage   = @"home_available";
        model1.leftTitle   = Localized(@"expected time to use");
        model1.rightDetail = Localized(@"see now");
        
        HomeModel * model3 = [[HomeModel alloc] init];
        model3.leftImage   = @"home_healthy";
        model3.leftTitle   = Localized(@"test quality of PIN");
        model3.rightDetail = Localized(@"see now");
        
        HomeModel * model4 = [[HomeModel alloc] init];
        model4.leftImage   = @"home_speed";
        model4.leftTitle   = Localized(@"test speed connect");
        model4.rightDetail = Localized(@"see now");
        
        _originalGroup = @[model1, model3, model4];
	}
	return _originalGroup;
}

@end
