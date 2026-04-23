//
//  NewQDTreeCell.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/16.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "NewQDTreeCell.h"
#import "UIColor+hex.h"

@interface NewQDTreeCell()

@property (weak, nonatomic) IBOutlet UIView *nodeView;
@property (weak, nonatomic) IBOutlet UIView *leafView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nodeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leafViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nodeLeftWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leafLeftWidth;
@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UILabel *leafLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *attBtn;

@end

@implementation NewQDTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)treeViewCellWith:(RATreeView *)treeView {
    NewQDTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"NewQDTreeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewQDTreeCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setCellBasicInfoWith:(NewQDModel *)model level:(NSInteger)level children:(NSInteger)children {
    _model = model;
//    if (_model.object == nil) {
//        self.nodeLabel.hidden = NO;
//        self.nodeViewHeight.constant = 40;
//        self.leafView.hidden = YES;
//        self.leafViewHeight.constant = 0;
//
//        self.nodeLabel.text = _model.name;
//
//        if (children == 0) {
//            self.expandImg.hidden = YES;
//        } else {
//            self.expandImg.hidden = NO;
//            if (_model.isExpanded) {
//                self.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
//            } else {
//                self.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
//            }
//        }
//    } else {
        self.nodeLabel.hidden = YES;
        self.nodeViewHeight.constant = 0;
        self.leafView.hidden = NO;
        self.leafViewHeight.constant = 40;
        
        NSString *testStatus = _model.testStatus;
        if (testStatus != nil) {
            self.leafLabel.textColor = [UIColor blackColor];
            if ([testStatus isEqualToString:@"1"]) {
                self.pointView.backgroundColor = UIColorStatus1;
            } else if ([testStatus isEqualToString:@"2"]) {
                self.pointView.backgroundColor = UIColorStatus2;
            } else if ([testStatus isEqualToString:@"3"]) {
                self.pointView.backgroundColor = UIColorStatus3;
            } else if ([testStatus isEqualToString:@"4"]) {
                self.pointView.backgroundColor = UIColorStatus4;
            } else {
                self.leafLabel.textColor = UIColorStatus0;
                self.pointView.backgroundColor = UIColorStatus0;
            }
        } else {
            self.leafLabel.textColor = UIColorStatus0;
            self.pointView.backgroundColor = UIColorStatus0;
        }
        
        self.leafLabel.text = model.name;
        
        if ([_model.object.key.storageType isEqualToString:@"1"]) {
            self.checkBtn.titleLabel.text = @"附件";
            self.leafLabel.textColor = [UIColor blackColor];
            self.pointView.backgroundColor = UIColorStatus4;
        } else {
            self.checkBtn.titleLabel.text = @"查看";
        }
//    }
    
    self.attBtn.hidden = !qdShowAtc;
    //每一层的布局
    CGFloat left = level * 10;
    self.nodeLeftWidth.constant = left;
    self.leafLeftWidth.constant = left;
}

- (IBAction)checkBtnClicked:(id)sender {
    if (self.callBack) {
        self.callBack(self.model);
    }
}
- (IBAction)attachmentBtnClick:(id)sender {
    if (self.attCallBack) {
        self.attCallBack(self.model);
    }
}

@end
