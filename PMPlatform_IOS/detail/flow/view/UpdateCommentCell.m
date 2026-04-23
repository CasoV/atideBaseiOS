//
//  UpdateCommentCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/15.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "UpdateCommentCell.h"

@interface UpdateCommentCell ()

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *childCircle;
@property (weak, nonatomic) IBOutlet UIView *circleIcon;
@property (weak, nonatomic) IBOutlet UIImageView *headPhoto;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *stepName;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIButton *pointButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;

@end

@implementation UpdateCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.userName.font = [UIFont systemFontOfSize:10];
    self.date.font = [UIFont systemFontOfSize:12];
    [self.pointButton setImage:[UIImage imageNamed:@"point_off"] forState:UIControlStateNormal];
    [self.pointButton setImage:[UIImage imageNamed:@"point_on"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.circleIcon.layer.cornerRadius = 5;
    self.circleIcon.layer.borderWidth = 1;
    self.circleIcon.layer.borderColor = [UIColor colorWithRed:0x1c/0xff green:0x98/0xff blue:0x0f/0xff alpha:0.7].CGColor;
    self.childCircle.layer.cornerRadius = 3;
    self.circleIcon.clipsToBounds = YES;
    self.headPhoto.layer.cornerRadius = 25;
    self.headPhoto.clipsToBounds = YES;
    self.status.layer.cornerRadius = 5;
    self.status.layer.borderColor = [UIColor redColor].CGColor;
    self.status.layer.borderWidth = 1;
    self.status.clipsToBounds = YES;
}


- (void)loadDataModel:(ApprovalCommentModel *)model {
    self.model = model;
    
    self.status.text = [NSString stringWithFormat:@"  %@  ", model.doRet];
    self.date.text = model.time;
    self.stepName.text = model.activeName;
    self.userName.text = [NSString stringWithFormat:@"(%@)", model.userName];
    self.desc.text = model.message;
    if ([model.userId isEqualToString:[AppUser sharedInstance].id]) {
        self.status.textColor = [UIColor blackColor];
        self.status.backgroundColor = [UIColor greenColor];
    } else {
        self.status.textColor = [UIColor redColor];
        self.status.backgroundColor = [UIColor whiteColor];
    }
    
    if ([model.ownerId isEqualToString:[AppUser sharedInstance].id]) {
        self.pointButton.hidden = NO;
    } else {
        self.pointButton.hidden = YES;
    }
    
    self.pointButton.selected = model.selected;
}

- (void)hideTop:(BOOL)hide {
    self.topLine.hidden = hide;
}

- (void)hideBottom:(BOOL)hide {
    self.bottomLine.hidden = hide;
}


- (IBAction)pointButtonClicked:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    
    sender.selected = YES;
    if (self.delegate) {
        [self.delegate updateCommentCellPointButtonClicked:self];
    }
}

@end
