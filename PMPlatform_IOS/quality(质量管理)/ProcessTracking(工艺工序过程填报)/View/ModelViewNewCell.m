//
//  ModelViewNewCell.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/18.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ModelViewNewCell.h"
//#import "ModelInfoController.h"
#import "PopoverView.h"

@interface ModelViewNewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation ModelViewNewCell {
    ModelViewModel *_model;
}

- (void)setDataModel:(ModelViewModel *)model withIndex:(NSInteger)index {
    _model = model;
    
    self.titleLabel.text = _model.name;
    self.numLabel.text = [NSString stringWithFormat:@"%ld", index];
    
    if (_model.children == nil || _model.children.count == 0) {
        self.arrow.hidden = YES;
    } else {
        self.arrow.hidden = NO;
    }
}

- (IBAction)btnClicked:(id)sender {
    if (self.block) {
        self.block(_model);
        return;
    }
    
    __weak typeof(self) weakSelf = self;

    PopoverAction *action1 = [PopoverAction actionWithTitle:@"添加下级" handler:^(PopoverAction *action) {
        [weakSelf editOrAdd:NO];
    }];

    PopoverAction *action2 = [PopoverAction actionWithTitle:@"编辑" handler:^(PopoverAction *action) {
        [weakSelf editOrAdd:YES];
    }];

    PopoverAction *action3 = [PopoverAction actionWithTitle:@"删除" handler:^(PopoverAction *action) {
        [weakSelf deleteData];
    }];

    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES; // 显示阴影背景
    popoverView.style = PopoverViewStyleDark; // 设置为黑色风格
    // 有两种显示方法
    [popoverView showToView:sender withActions:@[action1, action2, action3]];
}

#pragma mark - 删除数据
- (void)deleteData {
//    if (_del) {
//        [_del stop];
//    }
//
//    __weak typeof(self) weakSelf = self;
//    [SVProgressHUD showWithStatus:@"删除中..."];
//    _del = [[BIMPostRequest alloc] initWithRequestParams:@{@"departmentId":_model.id}];
//    _del.requestUrl = @"form/constructModel/subDelContent";
//    [_del startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        [SVProgressHUD dismiss];
//        if ([request resultIsSuccess]) {
//            if (weakSelf.delBlock) {
//                weakSelf.delBlock(_model);
//            }
//        } else {
//           [SVProgressHUD showErrorWithStatus:[request resultMsg]];
//        }
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:[request resultMsg]];
//    }];
}

#pragma mark - 编辑或新增
- (void)editOrAdd:(BOOL)isEdit {
//    ModelInfoController *vc = [[UIStoryboard storyboardWithName:@"NewMain" bundle:nil] instantiateViewControllerWithIdentifier:@"ModelInfo"];
//    vc.model = _model;
//    vc.pid = self.pid;
//    vc.isEdit = isEdit;
//    [self.findViewController.navigationController pushViewController:vc animated:YES];
}

@end
