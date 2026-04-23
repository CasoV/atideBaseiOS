//
//  FlowApprovalCommentView.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowApprovalCommentView.h"
#import "ApprovalCommentModel.h"
#import "HeadPhotoUtils.h"
#import "VStepView.h"
#import "Masonry.h"

@implementation FlowApprovalCommentView {
    VStepView *_vStepView;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = NO;
        _vStepView = [[VStepView alloc] init];
        _vStepView.frame = CGRectMake(0, 0, 100, 100);
        _vStepView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:_vStepView];
        _vStepView.backgroundColor = [UIColor redColor];
        [_vStepView setDataAndView:@[] itemClick:nil callback:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_vStepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        make.left.mas_equalTo(self.mas_left).with.offset(0);
        make.right.mas_equalTo(self.mas_right).with.offset(0);
    }];
}

- (void)request:(NSString *)ID type:(NSInteger)type callback:(void (^)(CGFloat height))callback {
    NSString *url;
    if (type == 0) {
        url = [UrlConfig URL:getComments];
    }else {
        url = [UrlConfig URL:getFlowPass];
    }
    
    [MBManager showLoading];
    [[HttpManager manager] post:url param:@{@"bizPk":ID,@"json":@true,@"dataType":@"2"} success:^(NSData *data) {
        [MBManager hideAlert];
        if ([ResponseUtils success:data]) {
            
            NSArray <ApprovalCommentModel *>*result;
            
            if(type == 0){
                result = [ApprovalCommentModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            }else{
                NSMutableArray *arr= [NSMutableArray array];
                NSArray <ApprovalCommentModel *>*modelArr  = [ApprovalCommentModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
                
                for (ApprovalCommentModel *pModel in modelArr) {
                    int i = 0;
                    for (NSDictionary *dic in pModel.opinions) {
                        ApprovalCommentModel *model = [ApprovalCommentModel new];
                        model.doRet = dic[@"doRet"];
                        model.userName = dic[@"userName"];
                        model.time = dic[@"time"];
                        model.activeName = dic[@"activeName"];
                        model.message = dic[@"message"];
                        if(i != 0){
                            model.activeName = @"";
                            model.isNotRoot = YES;
                        }
                        [arr addObject:model];
                        i++;
                    }
                }
                result = arr;
                
                
            }
            
            
            if (result == nil) {
                if (callback) {
                    callback(0);
                }
                return ;
            }
            
            CGFloat sum = 0;
            for (ApprovalCommentModel *model in result) {
                sum += model.rowHeight;
            }
            self.frame = CGRectMake(0, 0, kScreen_Width, sum);
            [self initApproval:result];
            if (callback) {
                callback(sum);
            }
        }else {
            [MBManager showBriefAlert:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [MBManager hideAlert];
        [MBManager showBriefAlert:msg];
    }];
}

- (void)initApproval:(NSArray <ApprovalCommentModel *>*)datas {
    [_vStepView setDataAndView:datas itemClick:nil callback:^(id item, DefaultVStepViewCell *cell) {
        ApprovalCommentModel *user = (ApprovalCommentModel *)item;
        [HeadPhotoUtils setHeadPhotoByUserId:cell.headPhoto userId:user.ownerId];
        cell.status.text = [NSString stringWithFormat:@"  %@  ", user.doRet];
        cell.date.text = user.time;
        cell.stepName.text = user.activeName;
        cell.userName.text = [NSString stringWithFormat:@"(%@)", user.userName];
        cell.desc.text = user.message;
        if(user.isNotRoot){
            cell.circleIcon.hidden = user.isNotRoot;
            cell.childCircle.hidden = user.isNotRoot;
            cell.topToImg.constant = -20;
            cell.headPhoto.hidden = YES;
        }

        if ([user.userId isEqualToString:[UserInfo getInstance].ID]) {
            cell.status.textColor = [UIColor blackColor];
            cell.status.backgroundColor = [UIColor greenColor];
        } else {
            cell.status.textColor = [UIColor redColor];
            cell.status.backgroundColor = [UIColor whiteColor];
        }
    }];
}

@end
