//
//  ApplicationCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/5.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ApplicationCell.h"

@interface ApplicationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation ApplicationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = 45 / 2;
}

- (void)loadDataModel:(ApplicationModel *)model section:(NSInteger)section ishome:(BOOL)ishome{
    if (ishome) {
        if (section == 2) {
            self.titleLabel.text = @"";
            if (model.iconName) {
                self.iconImageView.image = nil;
                self.bgImageView.image = [UIImage imageNamed:model.iconName];
            }
        } else {
            self.titleLabel.text = model.title;
            if (model.iconName) {
                self.iconImageView.image = [UIImage imageNamed:model.iconName];
                self.bgImageView.image = nil;
            }
        }
    } else {
        self.titleLabel.text = model.title;
        if (model.iconName) {
            self.iconImageView.image = [UIImage imageNamed:model.iconName];
            self.bgImageView.image = nil;
        }
    }

}

@end
