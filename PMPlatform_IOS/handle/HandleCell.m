//
//  HandleCell.m
//  ConstructionApp
//
//  Created by RedLi on 2018/1/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "HandleCell.h"
#import "HandleModel.h"

#define KEY_EXPAND_CELL_HIGHT 25

@implementation HandleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userName.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
    self.orgName.textColor = [UIColor colorWithWhite:0.25 alpha:1.0];
}

- (void)layoutSubviews {
    self.rightContainer.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)getStatusByInt:(NSInteger)status {
    switch (status) {
        case STANDBY:
            self.status.textColor = UIColorFromRGB(0xA7A7A7);
            return @"未启动";
            break;
        case RUN:
            self.status.textColor = UIColorFromRGB(0x3B8DFF);
            return @"办理中";
            break;
        case SUSPEND:
            return @"挂起";
            break;
        case SKIP:
            return @"跳过";
            break;
        case COMPLETE:
            self.status.textColor = UIColorFromRGB(0x71ba71);
            return @"已办理";
            break;
        default:
            return @"未处理";
            break;
    }
}

- (NSString *)getImageByStatus:(NSInteger)status {
    switch (status) {
        case STANDBY:
            return @"no_sub_ico";
            break;
        case RUN:
            return @"alr_sub_ico";
            break;
        case SUSPEND:
            return @"no_sub_ico";
            break;
        case SKIP:
            return @"no_sub_ico";
            break;
        case COMPLETE:
            return @"pro_sub_ico";
            break;
        default:
            return @"no_sub_ico";
            break;
    }
}

- (void)updateTabCell:(NSArray *)arr {
    if (arr.count == 0) {
        self.arrowWidth.constant = 0;
        return;
    }
    self.arrowWidth.constant = 15;
    
    CGFloat width = kScreen_Width - self.leftContainer.frame.size.width - 5;
    [self.bottomContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.bottomContainer addSubview:[self onDrawLabel:CGRectMake(5, 0, width, KEY_EXPAND_CELL_HIGHT) alignment:NSTextAlignmentLeft title:@"办理意见"]];
    
    [self.bottomContainer addSubview:[self onDrawLabel:CGRectMake(0, KEY_EXPAND_CELL_HIGHT, width/3, KEY_EXPAND_CELL_HIGHT) alignment:NSTextAlignmentCenter title:@"办理时间"]];
    [self.bottomContainer addSubview:[self onDrawLabel:CGRectMake(width/3, KEY_EXPAND_CELL_HIGHT, width/3, KEY_EXPAND_CELL_HIGHT) alignment:NSTextAlignmentCenter title:@"办理人"]];
    [self.bottomContainer addSubview:[self onDrawLabel:CGRectMake(width/3 * 2, KEY_EXPAND_CELL_HIGHT, width/3, KEY_EXPAND_CELL_HIGHT) alignment:NSTextAlignmentCenter title:@"办理意见"]];
    
    for (int i = 0; i < arr.count; i++) {
        Opinions *model = arr[i];
        [self.bottomContainer addSubview:[self onDrawLabel:CGRectMake(0, KEY_EXPAND_CELL_HIGHT * (i + 2), width/3, KEY_EXPAND_CELL_HIGHT) alignment:NSTextAlignmentCenter title:model.time]];
        if (model.signature) {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(width/3, KEY_EXPAND_CELL_HIGHT* (i + 2), width/3, KEY_EXPAND_CELL_HIGHT)];
            iv.contentMode = UIViewContentModeScaleAspectFit;
            UIImage *image = [self dataURLImage:model.signature];
            if (image) {
                iv.image = image;
            }
            
            [self.bottomContainer addSubview:iv];
        } else {
            [self.bottomContainer addSubview:[self onDrawLabel:CGRectMake(width/3, KEY_EXPAND_CELL_HIGHT* (i + 2), width/3, KEY_EXPAND_CELL_HIGHT) alignment:NSTextAlignmentCenter title:model.userName]];
        }
        
        [self.bottomContainer addSubview:[self onDrawLabel:CGRectMake(width/3 * 2, KEY_EXPAND_CELL_HIGHT* (i + 2), width/3, KEY_EXPAND_CELL_HIGHT) alignment:NSTextAlignmentCenter title:model.message]];
        
    }
}

- (UILabel *)onDrawLabel:(CGRect) frame alignment:(NSTextAlignment)alignment title:(NSString*)title{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.numberOfLines = 2;
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextColor:[UIColor colorWithWhite:0.25 alpha:1.0]];
    [label setTextAlignment: alignment];
    return label;
}

- (UIImage *) dataURLImage:(NSString *)imgSrc{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:imgSrc options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *image = [UIImage imageWithData: data];
    
    return image;
}

@end
