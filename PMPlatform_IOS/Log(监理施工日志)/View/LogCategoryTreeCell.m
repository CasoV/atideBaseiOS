//
//  LogCategoryTreeCell.m
//  ycxm
//
//  Created by 高小伟 on 2021/7/5.
//  Copyright © 2021 末末班车. All rights reserved.
//

#import "LogCategoryTreeCell.h"

@interface LogCategoryTreeCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation LogCategoryTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)treeViewCellWith:(RATreeView *)treeView {
    LogCategoryTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"LogCategoryTreeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LogCategoryTreeCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setCellBasicInfoWith:(LogTreeModel *)model level:(NSInteger)level children:(NSInteger )children{
    _model = model;
//    if (children == 0) {
//        self.expandImg.hidden = YES;
//        self.fileImg.image = [UIImage imageNamed:@"ic_file_light_blue"];
//    } else {
//        self.expandImg.hidden = NO;
//        self.fileImg.image = [UIImage imageNamed:@"ic_folder_light_blue"];
//    }

    if (model.isExpanded) {
        self.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
    } else {
        self.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
    }


    self.title.text = model.name;

    //每一层的布局
    CGFloat left = level * 10;
    self.leftViewWidth.constant = left;
}

- (IBAction)checkBtnClicked:(id)sender {
    if (self.callBack) {
        self.callBack(self.model);
    }
}

@end
