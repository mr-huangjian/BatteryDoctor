//
//  AvailableViewController.m
//  BatteryDoctor
//
//  Created by hj on 16/8/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "AvailableViewController.h"
#import "AvailableViewCell.h"

@interface AvailableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * modelGroup;

@end

static NSString * reuseIdentifier = @"AvailableViewCell";

@implementation AvailableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setIBOutlet];
    [self setIBAction];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"AvailablePage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"AvailablePage"];
}

- (void)setIBOutlet
{
    self.tableView.rowHeight = 50 * deviceScale;
    
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = HexStringColor(Theme_BlueColor);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
}

- (void)setIBAction
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChanged)
                                                 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
    [self batteryLevelChanged];
}

- (void)batteryLevelChanged
{
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    
    self.title = [NSString stringWithFormat:@"%@ %.f%%",
                  Localized(@"PIN at the present"), batteryLevel * 100];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvailableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.model = self.modelGroup[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layoutMargins  = UIEdgeInsetsZero;
    
    return cell;
}

- (NSMutableArray *)modelGroup {
	if (_modelGroup == nil) {
        _modelGroup = [[NSMutableArray alloc] initWithCapacity:30];
        
        NSData * JsonData  = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Available" ofType:@"json"]];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:JsonData options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary * item in dic[@"list"]) {
            AvailableModel * model = [[AvailableModel alloc] init];
            [model setValuesForKeysWithDictionary:item];
            [_modelGroup addObject:model];
        }
	}
	return _modelGroup;
}

@end
