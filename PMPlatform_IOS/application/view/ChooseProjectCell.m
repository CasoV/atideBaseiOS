//
//  ChooseProjectCell.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2022/6/13.
//  Copyright © 2022 com.atide. All rights reserved.
//

#import "ChooseProjectCell.h"

@interface ChooseProjectCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation ChooseProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (instancetype)treeViewCellWith:(RATreeView *)treeView {
    ChooseProjectCell *cell = [treeView dequeueReusableCellWithIdentifier:@"ChooseProjectCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseProjectCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)setCellBasicInfoWith:(ProjectInfo *)model level:(NSInteger)level children:(NSInteger )children{
    _model = model;
    if (children == 0) {
        self.expandImg.hidden = YES;
    } else {
        self.expandImg.hidden = NO;
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
