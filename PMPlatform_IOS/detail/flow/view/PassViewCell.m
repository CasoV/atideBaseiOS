//
//  PassViewCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/14.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "PassViewCell.h"
#import "ReviewButton.h"

#define BUTTONW 60
#define BUTTONH 25

@interface PassViewCell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *ring;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;

@property (weak, nonatomic) IBOutlet UIButton *pointButton;

@end

@implementation PassViewCell {
    BOOL _isPass;
    BOOL _isSingle;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ring.layer.cornerRadius = 5;
    [self.pointButton setImage:[UIImage imageNamed:@"point_off"] forState:UIControlStateNormal];
    [self.pointButton setImage:[UIImage imageNamed:@"point_on"] forState:UIControlStateSelected];
}

- (void)loadDataModel:(FlowPicLocation *)model {
    _isSingle = NO;
    self.flowPicLocation = model;
    
    self.nameLabel.text = model.name;
    if ([model.skip isEqualToString:@"1"]) {
        self.ring.backgroundColor = [UIColor greenColor];
    } else {
        self.ring.backgroundColor = [UIColor redColor];
    }
    
    [self.bottomView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if ([model.selectUser isEqualToString:@"1"]) {
        if (model.taskAssignees != nil && model.taskAssignees.count != 0) {
            NSString *names = model.taskAssignees.firstObject.userName;
            for (int i = 1; i < model.taskAssignees.count; i++) {
                names = [NSString stringWithFormat:@"%@,%@", names, model.taskAssignees[i].userName];
            }
            UILabel *label = [[UILabel alloc] initWithFrame:self.bottomView.bounds];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor darkGrayColor];
            label.numberOfLines = 2;
            label.text = names;
            [self.bottomView addSubview:label];
        }
    } else if ([model.selectUser isEqualToString:@"2"]){
        _isSingle = YES;
        if (model.taskAssignees != nil && model.taskAssignees.count != 0) {
            CGFloat width = kScreen_Width - 70;
            CGFloat x = 0;
            CGFloat y = 0;
            NSInteger index = 100;
            for (FlowApprovalAssignees *item in model.taskAssignees) {
                if (x + BUTTONW > width) {
                    x = 0;
                    y += BUTTONH;
                }
                ReviewButton *button = [ReviewButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(x, y, BUTTONW, BUTTONH);
                [button setImage:[UIImage imageNamed:@"round_def"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"round_pro"] forState:UIControlStateSelected];
                button.titleLabel.font = [UIFont systemFontOfSize:11];
                button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [button setTitle:item.userName forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
                if ([item.checked isEqualToString:@"1"]) {
                    button.selected = YES;
                } else {
                    button.selected = NO;
                }
                button.tag = index;
                [self.bottomView addSubview:button];
                x += BUTTONW;
                index += 1;
            }
        }
    }else {
        if (model.taskAssignees != nil && model.taskAssignees.count != 0) {
            CGFloat width = kScreen_Width - 70;
            CGFloat x = 0;
            CGFloat y = 0;
            NSInteger index = 100;
            for (FlowApprovalAssignees *item in model.taskAssignees) {
                if (x + BUTTONW > width) {
                    x = 0;
                    y += BUTTONH;
                }
                ReviewButton *button = [ReviewButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(x, y, BUTTONW, BUTTONH);
                [button setImage:[UIImage imageNamed:@"cbox_def"] forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"cbox_pro"] forState:UIControlStateSelected];
                button.titleLabel.font = [UIFont systemFontOfSize:11];
                button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                [button setTitle:item.userName forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
                if ([item.checked isEqualToString:@"1"]) {
                    button.selected = YES;
                } else {
                    button.selected = NO;
                }
                button.tag = index;
                [self.bottomView addSubview:button];
                x += BUTTONW;
                index += 1;
            }
        }
    }
    
    self.pointButton.selected = model.pointSelected;
}

- (void)buttonClicked:(UIButton *)sender {
    if (_isPass) {
        if (_isSingle) {
            if (!sender.isSelected) {
                for (UIView *view in self.bottomView.subviews) {
                    UIButton *button = (UIButton *)view;
                    button.selected = NO;
                }
                for (FlowApprovalAssignees *item in self.flowPicLocation.taskAssignees) {
                    item.checked = @"0";
                }
                sender.selected = YES;
                self.flowPicLocation.taskAssignees[sender.tag - 100].checked = @"1";
            }
        } else {
            sender.selected = !sender.selected;
            if (sender.isSelected) {
                self.flowPicLocation.taskAssignees[sender.tag - 100].checked = @"1";
            } else {
                self.flowPicLocation.taskAssignees[sender.tag - 100].checked = @"0";
            }
        }
    }else {
        if (self.flowPicLocation.pointSelected) {
            if (_isSingle) {
                if (!sender.isSelected) {
                    for (UIView *view in self.bottomView.subviews) {
                        UIButton *button = (UIButton *)view;
                        button.selected = NO;
                    }
                    for (FlowApprovalAssignees *item in self.flowPicLocation.taskAssignees) {
                        item.checked = @"0";
                    }
                    sender.selected = YES;
                    self.flowPicLocation.taskAssignees[sender.tag - 100].checked = @"1";
                }
            } else {
                sender.selected = !sender.selected;
                if (sender.isSelected) {
                    self.flowPicLocation.taskAssignees[sender.tag - 100].checked = @"1";
                } else {
                    self.flowPicLocation.taskAssignees[sender.tag - 100].checked = @"0";
                }
            }
        } else {
            return;
        }
    }
}

- (void)cutLine:(BOOL)iscut {
    if (iscut) {
        self.lineTop.constant = 15;
    } else {
        self.lineTop.constant = 0;
    }
}

- (void)showLeft:(BOOL)isShow {
    if (isShow) {
        _isPass = NO;
        self.leftWidth.constant = 30;
    } else {
        _isPass = YES;;
        self.leftWidth.constant = 0;
    }
}

- (IBAction)pointButtonClicked:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    
    sender.selected = YES;
    if (self.delegate) {
        [self.delegate passViewCellPointButtonClicked:self];
    }
}

@end
