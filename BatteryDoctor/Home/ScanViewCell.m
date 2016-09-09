//
//  ScanViewCell.m
//  BatteryDoctor
//
//  Created by hj on 16/8/30.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "ScanViewCell.h"

@interface ScanViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView * iconImageView;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isSelectedImageView;

@end

@implementation ScanViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(ApplicationModel *)model
{
    _model = model;
    
    NSString * currentLanguage = [[[NSLocale preferredLanguages] firstObject] substringToIndex:2];
    
    if ([currentLanguage isEqualToString:@"zh"]) {
        self.nameLabel.text = model.zh_name;
    }
    else if ([currentLanguage isEqualToString:@"vi"]) {
        self.nameLabel.text = model.vi_name;
    }
    else {
        self.nameLabel.text = model.en_name;
    }
    
    self.iconImageView.image = [UIImage imageNamed:model.image_icon];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.isSelectedImageView.image = [UIImage imageNamed:@"selected"];
    } else {
        self.isSelectedImageView.image = [UIImage imageNamed:@"unSelected"];
    }
}

@end
