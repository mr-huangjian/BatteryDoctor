//
//  AvailableViewCell.m
//  BatteryDoctor
//
//  Created by hj on 16/8/23.
//  Copyright © 2016年 hj. All rights reserved.
//

#import "AvailableViewCell.h"

@implementation AvailableModel

@end

@interface AvailableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView * iconImageView;
@property (weak, nonatomic) IBOutlet UILabel * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel * timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelWidth;

@end

@implementation AvailableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

//    self.nameLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setModel:(AvailableModel *)model
{
    _model = model;
    
    NSString * currentLanguage = [[[NSLocale preferredLanguages] firstObject] substringToIndex:2];
    
    if ([currentLanguage containsString:@"zh"]) {
        self.nameLabel.text = model.zh_name;
    }
    else if ([currentLanguage containsString:@"vi"]) {
        self.nameLabel.text = model.vi_name;
    }
    else {
        self.nameLabel.text = model.en_name;
    }
    
    self.iconImageView.image = [UIImage imageNamed:model.image];
    
    CGFloat currentElectricity = [UIDevice currentDevice].batteryLevel;
    NSInteger currentAvailable = model.ratio * currentElectricity;
    
    if (currentAvailable % 60 == 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld%@",
                               currentAvailable / 60, Localized(@"hour")];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld%@%.2ld%@",
                               currentAvailable / 60, Localized(@"hour"),
                               currentAvailable % 60, Localized(@"minute")];
    }
    
//    CGSize size = [self.timeLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 34) options:NSStringDrawingUsesLineFragmentOrigin
//                                                 attributes:@{NSFontAttributeName: self.timeLabel.font} context:nil].size;
//    self.timeLabelWidth.constant = size.width + 10;
    
}

@end
