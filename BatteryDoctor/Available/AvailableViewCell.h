//
//  AvailableViewCell.h
//  BatteryDoctor
//
//  Created by hj on 16/8/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableModel : NSObject

@property (nonatomic, assign) NSInteger no;
@property (nonatomic, assign) NSInteger ratio;
@property (nonatomic, copy)  NSString * image;
@property (nonatomic, copy)  NSString * zh_name;
@property (nonatomic, copy)  NSString * vi_name;
@property (nonatomic, copy)  NSString * en_name;

@end

@interface AvailableViewCell : UITableViewCell

@property (nonatomic, strong) AvailableModel * model;

@property (nonatomic, assign) CGFloat currentElectricity;

@end
