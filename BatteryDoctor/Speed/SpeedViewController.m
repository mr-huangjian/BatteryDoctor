//
//  SpeedViewController.m
//  BatteryDoctor
//
//  Created by hj on 16/8/22.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "SpeedViewController.h"
#import "FGGDownloadManager.h"

@interface SpeedViewController ()

@property (weak, nonatomic) IBOutlet UILabel * speedLabel;
@property (weak, nonatomic) IBOutlet UILabel * tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * speedLabelBtmMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * tipLabelBtmMargin;
@property (weak, nonatomic) IBOutlet UILabel * statusLabel;
@property (weak, nonatomic) IBOutlet UIView  * startView;
@property (weak, nonatomic) IBOutlet CleanView * cleanView;
@property (weak, nonatomic) IBOutlet UIButton * startButton;
@property (weak, nonatomic) IBOutlet UIButton * tryAgainButton;

@property (nonatomic, strong) NSMutableArray * BS_SpeedGroup;
@property (nonatomic, strong) NSMutableArray * KS_SpeedGroup;
@property (nonatomic, strong) NSMutableArray * MS_SpeedGroup;

@property (nonatomic, strong) NSArray * downloadFileURLGroup;

@property (nonatomic, strong) NSString * fileURL;               // 下载文件的网络路径
@property (nonatomic, strong) NSString * destinationPath;       // 下载文件的目标路径

@property (nonatomic, strong) NSTimer * timer;                  // 定时器，用于在一定时间内处理完网速的检测
@property (nonatomic, strong) FGGDownloadManager * downloadMgr; // 网络测速的下载管理器

@property (nonatomic, strong) Reachability * hostReachability;
@property (nonatomic, assign) NetworkStatus  networkStatus;

@end

static int i = 0;

@implementation SpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setIBOutlet];
    [self setIBAction];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object: nil];
    self.hostReachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    [self.hostReachability startNotifier];
}

- (void)dealloc
{
    [self.hostReachability stopNotifier];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.timer.fireDate = [NSDate distantFuture];
    [self.timer invalidate];
    [self.downloadMgr cancelAllTasks];
    [self.downloadMgr removeForUrl:self.fileURL file:self.destinationPath];
     self.downloadMgr = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.destinationPath error:nil];
}

- (void)reachabilityChanged:(NSNotification *)notify {

    Reachability * curReach = [notify object];
    
    self.networkStatus = [curReach currentReachabilityStatus];
    
    switch (self.networkStatus) {
        case NotReachable:
        {
            
        }
            break;
        case ReachableViaWiFi:
        {
            
        }
            break;
        case ReachableViaWWAN:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"SpeedPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SpeedPage"];
}

- (void)setIBOutlet
{
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = HexStringColor(Theme_BlueColor);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.speedLabel.adjustsFontSizeToFitWidth = YES;
    
    self.startView.layer.shadowOffset  = CGSizeMake(0, 1);
    self.startView.layer.shadowRadius  = 5;
    self.startView.layer.shadowColor   = HexStringColor(Theme_BlueColor).CGColor;
    self.startView.layer.shadowOpacity = 0.5;
    
    self.cleanView.frontShapeLayer.shadowOffset  = CGSizeMake(0, 2);
    self.cleanView.frontShapeLayer.shadowRadius  = 6;
    self.cleanView.frontShapeLayer.shadowColor   = HexStringColor(Theme_BlueColor).CGColor;
    self.cleanView.frontShapeLayer.shadowOpacity = 0.5;
}

- (void)setIBAction
{
    self.BS_SpeedGroup = [NSMutableArray array];
    self.KS_SpeedGroup = [NSMutableArray array];
    self.MS_SpeedGroup = [NSMutableArray array];
    
    NSInteger random = [HJHelper randomNumberFrom:0 to:self.downloadFileURLGroup.count - 1];
    
    self.fileURL = self.downloadFileURLGroup[random];
    self.destinationPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:@"temp"];

    self.downloadMgr = [FGGDownloadManager shredManager];
    
    self.timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (IBAction)startButtonAction:(UIButton *)sender {
    
    [MobClick event:@"click_speed_speedtest"];
    
    sender.enabled = NO;
    
    @WeakObj(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (selfWeak.networkStatus == NotReachable) {
            sender.enabled = YES;
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:Localized(@"network connection exception")
                                                                            message:Localized(@"please check your network connection status")
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"%d%s", __LINE__, __func__);
            }]];
            [selfWeak presentViewController:alert animated:YES completion:nil];
            
        } else {
            sender.hidden = YES;
            
            selfWeak.statusLabel.text = Localized(@"test download speed");
            
            [selfWeak addDownloadTask];
            
            selfWeak.timer.fireDate = [NSDate distantPast];
            
            [[NSRunLoop currentRunLoop] addTimer:selfWeak.timer forMode:NSRunLoopCommonModes];
            
            selfWeak.cleanView.percent = 100;
            selfWeak.cleanView.animationDuration = 4.f;
        }
        
    });
}

- (void)addDownloadTask
{
    @WeakObj(self);
    
    NSString * temp = @"0B/s";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:temp];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.f] range:NSMakeRange(0, temp.length - 3)];
    selfWeak.speedLabel.attributedText = attrString;
    
    [self.downloadMgr downloadWithUrlString:self.fileURL toPath:self.destinationPath process:^(float progress, NSString *sizeString, NSString *speedString) {
        
        NSLog(@"speedString: %@", speedString);
        
        if (![speedString hasPrefix:@"-"]) {
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:speedString];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.f] range:NSMakeRange(0, speedString.length - 3)];
            
            selfWeak.speedLabel.attributedText = attrString;
            
            if ([speedString hasSuffix:@"M/s"]) {
                [selfWeak.MS_SpeedGroup addObject:[speedString substringToIndex:speedString.length - 3]];
            } else if ([speedString hasSuffix:@"K/s"]) {
                [selfWeak.KS_SpeedGroup addObject:[speedString substringToIndex:speedString.length - 3]];
            } else if ([speedString hasSuffix:@"B/s"]) {
                [selfWeak.BS_SpeedGroup addObject:[speedString substringToIndex:speedString.length - 3]];
            }
        }
        
    } completion:nil failure:nil];
}

- (void)timerAction:(NSTimer *)timer
{
    self.tipLabel.text = nil;
    
    if (i++ == 4)
    {
        timer.fireDate = [NSDate distantFuture];
        [self.downloadMgr cancelAllTasks];
        [self.downloadMgr removeForUrl:self.fileURL file:self.destinationPath];
        
        NSArray * tempArray;
        NSString * tempString;
        
        if (self.MS_SpeedGroup.count > 0) {
            tempArray = self.MS_SpeedGroup;
            tempString = @"M/s";
        } else if (self.KS_SpeedGroup.count > 0) {
            tempArray = self.KS_SpeedGroup;
            tempString = @"K/s";
        } else if (self.BS_SpeedGroup.count > 0) {
            tempArray = self.BS_SpeedGroup;
            tempString = @"B/s";
        }
        
        float sum = 0;
        for (int i = 0; i < tempArray.count; i++) {
            sum += [tempArray[i] floatValue];
        }
        
        CGFloat average = sum / tempArray.count;

        if (tempArray.count == 0 || average == 0) {// 没有网速的情况
            
            self.statusLabel.text = Localized(@"finish speeding test");
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:Localized(@"network busy")
                                                                            message:Localized(@"please try again")
                                                                     preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"%d%s", __LINE__, __func__);
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            NSString * averageString = [NSString stringWithFormat:@"%.1f%@", average, tempString];
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:averageString];
            [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.f] range:NSMakeRange(0, averageString.length - 3)];
            
            self.speedLabel.attributedText = attrString;
            self.speedLabelBtmMargin.constant += 28;
            self.tipLabelBtmMargin.constant += 15;
            
            self.tipLabel.text = Localized(@"connect speed now");
            self.statusLabel.text = Localized(@"finish speeding test");
        }
        
        self.startButton.enabled = YES;
        [[NSFileManager defaultManager] removeItemAtPath:self.destinationPath error:nil];
        [self.MS_SpeedGroup removeAllObjects];
        [self.KS_SpeedGroup removeAllObjects];
        [self.BS_SpeedGroup removeAllObjects];
        tempArray = nil;
        tempString = nil;
        i = 0;
        
        self.tryAgainButton.hidden = NO;
    }
}

- (IBAction)tryAgainButtonAction:(UIButton *)sender {
    sender.hidden = YES;
    self.statusLabel.text = Localized(@"test download speed");
    
    self.cleanView.percent = 100;
    self.cleanView.animationDuration = 4.f;
    
    self.startButton.hidden = YES;
    self.speedLabelBtmMargin.constant = 0;
    self.tipLabelBtmMargin.constant = 0;
    
    self.fileURL = self.downloadFileURLGroup[[HJHelper randomNumberFrom:0 to:self.downloadFileURLGroup.count - 1]];
    
    [self addDownloadTask];
    
    self.timer.fireDate = [NSDate distantPast];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (NSArray *)downloadFileURLGroup {
	if (_downloadFileURLGroup == nil) {
        _downloadFileURLGroup = @[@"http://imgcache.qq.com/qzone/biz/gdt/dev/sdk/ios/release/GDT_iOS_SDK.zip",
                                  @"http://android-mirror.bugly.qq.com:8080/eclipse_mirror/juno/content.jar",
                                  @"http://dota2.dl.wanmei.com/dota2/client/DOTA2Setup20160329.zip"];
	}
	return _downloadFileURLGroup;
}

@end
