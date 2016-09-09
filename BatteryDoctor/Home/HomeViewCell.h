//
//  HomeViewCell.h
//  BatteryDoctor
//
//  Created by hj on 16/8/22.
//  Copyright © 2016年 hj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeModel : NSObject

@property (nonatomic, copy) NSString * leftImage;
@property (nonatomic, copy) NSString * leftTitle;
@property (nonatomic, copy) NSString * rightDetail;

@end

@interface HomeViewCell : UITableViewCell

@property (nonatomic, strong) HomeModel * model;

@end
