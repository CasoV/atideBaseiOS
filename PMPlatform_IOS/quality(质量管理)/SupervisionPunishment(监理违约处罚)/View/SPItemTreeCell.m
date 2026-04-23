//
//  SPItemTreeCell.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/20.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "SPItemTreeCell.h"

@interface SPItemTreeCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation SPItemTreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)treeViewCellWith:(RATreeView *)treeView {
    SPItemTreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"SPItemTreeCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPItemTreeCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setCellBasicInfoWith:(PartModel *)model level:(NSInteger)level children:(NSInteger )children{
    _model = model;
    if (children == 0) {
        self.checkBtn.hidden = NO;
        self.expandImg.hidden = YES;
        self.fileImg.image = [UIImage imageNamed:@"ic_file_light_blue"];
    } else {
        self.checkBtn.hidden = YES;
        self.expandImg.hidden = NO;
        self.fileImg.image = [UIImage imageNamed:@"ic_folder_light_blue"];
    }
    
    if (model.isExpanded) {
        self.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
    } else {
        self.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
    }
    
    
    self.title.text = model.text;
    
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
