//
//  OpinionsCell.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/30.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "OpinionsCell.h"

@interface OpinionsCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation OpinionsCell

- (void)setModel:(OpinionsModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.name;
    if (_model.isSelected) {
        self.iconImageView.image = [UIImage imageNamed:@"confirm_off"];
    } else {
        self.iconImageView.image = nil;
    }
}

@end
