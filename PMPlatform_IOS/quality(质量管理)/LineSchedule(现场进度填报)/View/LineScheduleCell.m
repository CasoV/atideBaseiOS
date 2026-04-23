//
//  LineScheduleCell.m
//  ycxm
//
//  Created by 末末班车 on 2019/1/15.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "LineScheduleCell.h"

@interface LineScheduleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkbox;

@end

@implementation LineScheduleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(LineScheduleModel *)model {
    _model = model;
    self.titleLabel.text = _model.name;
    self.leftLabel.text = [@"编号:" stringByAppendingString:_model.code];
    self.rightLabel.text = [@"类型:" stringByAppendingString:_model.typeName];
    if(_model.isSelected){
        self.checkbox.image = [UIImage imageNamed:@"cbox_blue_pro"];
    }else{
        self.checkbox.image = [UIImage imageNamed:@"cbox_def"];
    }
    self.statusLabel.hidden = NO;
    switch (_model.status.integerValue) {
        case 0:
            self.statusLabel.text = @"未开始";
            self.statusLabel.textColor = UIColorFromRGB(0xffa438);
            break;
        case 1:
            self.statusLabel.text = @"施工中";
            self.statusLabel.textColor = UIColorTextBlue;
            break;
        case 2:
            self.statusLabel.text = @"已完工";
            self.statusLabel.textColor = UIColorFromRGB(0x70ba6f);
            break;
        default:
            self.statusLabel.hidden = YES;
            break;
    }
}

@end
