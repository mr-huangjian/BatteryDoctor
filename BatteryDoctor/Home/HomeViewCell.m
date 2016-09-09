//
//  HomeViewCell.m
//  BatteryDoctor
//
//  Created by hj on 16/8/22.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "HomeViewCell.h"

@implementation HomeModel

@end

@interface HomeViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView * iconImageView;
@property (weak, nonatomic) IBOutlet UILabel     * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     * detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView * detailImageView;

@end

@implementation HomeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    
}

- (void)setModel:(HomeModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.leftTitle;
    self.detailLabel.text = model.rightDetail;
    self.iconImageView.image = [UIImage imageNamed:model.leftImage];
}

@end
