//
//  QDTab1Cell.m
//  ycxm
//
//  Created by 末末班车 on 2019/3/29.
//  Copyright © 2019 末末班车. All rights reserved.
//

#import "QDTab1Cell.h"

@interface QDTab1Cell()

@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation QDTab1Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(CheckListBean *)model indexPath:(NSIndexPath *)indexPath {
    if (!model.status) {
        model.status = @"";
    }
    self.nameLabel.textColor = UIColorFromRGB(0x333333);
    if ([model.status isEqualToString:@"1"]) {
        self.pointView.backgroundColor = UIColorFromRGB(0x3D66DC);
    }else if([model.status isEqualToString:@"3"]){
        self.pointView.backgroundColor = UIColorFromRGB(0xFDB422);
    }else if([model.status isEqualToString:@"4"]){
        self.pointView.backgroundColor = UIColorFromRGB(0x3EB36E);
    }else if([model.status isEqualToString:@"2"]){
        self.pointView.backgroundColor = UIColorFromRGB(0xfd4e22);
    }else{
        self.pointView.backgroundColor = UIColorFromRGB(0x999999);
        self.nameLabel.textColor = UIColorFromRGB(0x98a1ae);
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%ld.%@", indexPath.row + 1,model.name];
}

@end
