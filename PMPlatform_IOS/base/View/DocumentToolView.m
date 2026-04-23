//
//  DocumentToolView.m
//  YXConstructionApp
//
//  Created by 末末班车 on 2018/3/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "DocumentToolView.h"
#import "FlowManagermentFactory.h"
#import "UIView+BorderLine.h"
#import "FunctionFactory.h"
#import "FlowPicLocation.h"
#import "BaseWebViewController.h"
#import "PentahoPageViewController.h"

@implementation DocumentToolView {
    NSMutableArray <Panel *>*_array;
    
    Panel *_item;
}

- (void)setCompleteInfo:(NSString *)completeInfo {
    _completeInfo = completeInfo;
    [FlowManagermentFactory config:self.findViewController.navigationController symbol:[NSString stringWithFormat:@"%@,%@",_completeInfo ,self.taskId] update:nil];
//    [FlowManagermentFactory factory:_item bizPk:self.bizKey instanceId:self.bizPk bizUrl:self.bizUrl];
}

- (void)setData:(NSArray<Panel *> *)data {
    [FlowManagermentFactory config:self.findViewController.navigationController symbol:self.taskId ? self.taskId : @"" update:nil];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (data) {
        _data = data;
        _array = [NSMutableArray array];
        for (Panel *panel in data) {
            if (![panel.content isEqualToString:@"办理过程"] && ![panel.content isEqualToString:@"返回"]&&![panel.content isEqualToString:@"删除"]&& ![panel.content isEqualToString:@"重批"]) {
                if([panel.content isEqualToString:@"通过"]&& self.status && [self.status isEqualToString:@"1"]){
                    panel.content = @"提交";
                }
                if (self.canSave) {
                    [_array addObject:panel];
                } else {
                    if (![panel.content isEqualToString:@"保存"]) {
                        [_array addObject:panel];
                    }
                }
                
            }
        }
        
        CGFloat width = self.frame.size.width / _array.count;
        CGFloat height = (self.frame.size.height == 0) ? 44 : self.frame.size.height;
        
        for (int j = 0; j < _array.count; j++) {
            UIButton *bottomItem = [[UIButton alloc] initWithFrame:CGRectMake(j * width, 0, width, height)];
            [bottomItem setTitle:_array[j].content forState:UIControlStateNormal];
            [bottomItem setTitleColor:UIColorFromRGB(0x0096FF) forState:UIControlStateNormal];
            [bottomItem borderForColor:UIColorGrey_200 borderWidth:1 borderType:UIBorderSideTypeRight];
            bottomItem.titleLabel.font=[UIFont systemFontOfSize:14];
            bottomItem.tag = j + 100;
            [bottomItem addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: bottomItem];
        }
        
        if (_array.count != 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
            lineView.backgroundColor = UIColorGrey_200;
            [self addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
                make.height.equalTo(@0.5);
            }];
        }
    }
}

- (BOOL)isEmpty{
    return _array.count == 0;
}

- (void)bottomAction:(UIButton *)sender {
    if (self.callBack) {
        if ([self.bizKey isEqualToString:@"construction_process"]) {
            [self bottomItemClick:_array[sender.tag - 100]];
        } else {
            self.callBack(_array[sender.tag - 100]);
        }
    } else {
        [self bottomItemClick:_array[sender.tag - 100]];
    }
}

- (void)bottomItemClick:(Panel *)item {
    if([item.ID isEqualToString:@"button-showReport"]){
        if(self.reportBlock){
            self.reportBlock(YES);
        }
        return;
    }else if ([item.ID isEqualToString:@"button-revoke"]) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认撤回？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf getRevokeTask];
        }]];
        [self.findViewController presentViewController:alert animated:YES completion:nil];
    } else if ([item.ID isEqualToString:@"button-remove"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showWithStatus:nil];
            
            if ([self.bizUrl isEqualToString:@"/progress/progressControlPart"]) {
                [[HttpManager manager] del:[NSString stringWithFormat:@"%@%@",[UrlConfig URL:deleteReportMain],self.bizPk] param:nil success:^(NSData *data) {
                    if ([ResponseUtils success:data]) {
                        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                        [self.findViewController.navigationController popViewControllerAnimated:YES];
                    } else {
                        [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
                    }
                } faild:^(NSString *msg) {
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
                return;
            }
            
            NSDictionary *param = @{
                                    @"id":self.bizPk,
                                    @"bizPk":self.bizPk,
                                    @"sectId":[UserAgent DefaultAgent].sectionId,
                                    @"projectId":[UserAgent DefaultAgent].projectId
                                    };
            [[HttpManager manager] post:[UrlConfig URL:[self getRemoveUrl]] param:param success:^(NSData *data) {
                if ([ResponseUtils success:data]) {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                    [self.findViewController.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
                }
                if (self.block) {
                    self.block(YES);
                }
            } faild:^(NSString *msg) {
                [SVProgressHUD showErrorWithStatus:msg];
                if (self.block) {
                    self.block(YES);
                }
            }];
        }]];
        [self.findViewController presentViewController:alert animated:YES completion:nil];
    } else if ([item.ID isEqualToString:@"button-result"]) {
//        [FlowManagermentFactory factory:item bizPk:self.bizKey instanceId:self.bizPk bizUrl:self.bizUrl];
    } else {
//        if ([self.bizKey isEqualToString:@"construction_process"]) {
//            if ([item.ID isEqualToString:@"button-pass"] || [item.ID isEqualToString:@"button-submit"]) {
//                if (self.callBack) {
//                    _item = item;
//                    self.callBack(item);
//                    return;
//                }
//            }
//        }
        if(self.rejectBlock && [item.content isEqualToString:@"退回"]){
            self.rejectBlock(YES);
            return;
        }
        if(self.completeBlock){
            self.completeBlock(item.content);
            return;
        }
        item.iconName = [NSString stringWithFormat:@"%@-%@", self.vcTitle, item.content];
        [FlowManagermentFactory factory:item bizPk:self.bizKey instanceId:self.bizPk bizUrl:self.bizUrl];
    }
}

#pragma mark - 获得撤回url
- (NSString *)getRevokeUrl {
    NSString *url = [NSString stringWithFormat:[UrlConfig URL:caServiceInstance], self.bizPk];
    if (isCa) {
        url = [NSString stringWithFormat:[UrlConfig URL:caServiceInstanceByCa], self.bizPk];
    }
    return url;
}

#pragma mark - 获得删除url
- (NSString *)getRemoveUrl {
    if ([self.bizUrl isEqualToString:@"inspect"]) {
        return [NSString stringWithFormat:@"/processapprovalnew/%@/delete", self.bizUrl];
    }else {
        return [NSString stringWithFormat:@"/processapprovalnew/%@/delContent", self.bizUrl];
    }
}

#pragma mark - 获得通过的审核步骤json
- (void)getRevokeTask {
    [SVProgressHUD showWithStatus:nil];
    
    NSString *url = [UrlConfig URL:pass];
    NSDictionary *params = @{
        @"bizPk": self.bizPk,
        @"dataType": @"2",
        @"json": @(YES)
    };
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [FlowPicLocation mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            NSArray <FlowPicLocation *>*datas = [FlowPicLocation mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if (datas != nil && datas.count > 0) {
                for (FlowPicLocation *item in datas) {
                    if (item.type != nil && [item.type isEqualToString:@"userTask"]) {
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        [params setObject:weakSelf.bizPk forKey:@"bizPk"];
                        [params setObject:item.ID forKey:@"destTaskKey"];
                        [weakSelf revokeTask:params];
                        break;
                    }
                }
            } else {
                [SVProgressHUD dismiss];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 撤回
- (void)revokeTask:(NSMutableDictionary *)params {
    if (self.taskId) {
        [params setObject:self.taskId forKey:@"taskId"];
    }
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] jsonPost:[self getRevokeUrl] param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"撤回成功"];
            if([self.vcTitle containsString:@"监理日志"] || [self.vcTitle containsString:@"施工日志"]||[self.vcTitle containsString:@"安全生产隐患检查记录表"]||[self.vcTitle containsString:@"检查记录"]){
//                [FlowManagermentFactory getStatus:params[@"bizPk"] title:self.vcTitle];
                return;
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
        if (weakSelf.block) {
            weakSelf.block(NO);
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    } headers:@{
        @"flow-token":@"REVOKE"
    }];
}

- (void)setTaskId:(NSString *)taskId {
    _taskId = taskId;
    [FlowManagermentFactory config:self.findViewController.navigationController symbol:_taskId update:nil];
}
@end
