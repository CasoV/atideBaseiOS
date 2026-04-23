//
//  SearchBarView.m
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "SearchBarView.h"
#import "JSDropDownMenu.h"
#import "QFDatePickerView.h"
#import "ProjectSectPopController.h"
#import "SysConfig.h"
#import "ProjectSect.h"
@interface SearchBarView(){
    UIButton *timeBtn;
    UIButton *sectBtn;
    UILabel *label;
    UIViewController *vc;
    Block callback;
    NSString *timeTxt;
    NSArray *sectValues;
    
}

@end
@implementation SearchBarView
- (void)dateUp:(UIButton *)sender {
    QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initDatePackerWithResponse:^(NSString *str) {
        timeTxt = [str copy];
        NSString *string = str;
        string = [string stringByReplacingOccurrencesOfString:@"." withString:@"年"];
        string = [NSString stringWithFormat:@"%@月",string];
        [timeBtn setTitle:string forState:UIControlStateNormal];
        if (callback) {
            callback();
        }
    }];
    [datePickerView show];

}
- (void)sectUp:(UIButton *)sender {
    ProjectSectPopController *temp = [[ProjectSectPopController alloc] init];
    temp.callback = ^(NSArray * sects) {
        
        [sectBtn setTitle:[NSString stringWithFormat:@"选择%d个合同段",sects.count] forState:UIControlStateNormal];
        for (ProjectSect *sect in [SysConfig getInstance].sectInfos) {
            sect.issect = NO;
            for (ProjectSect *item in sects) {
                if ([sect.sectno isEqualToString:item.sectno]) {
                    sect.issect = YES;
                    break;
                }
            }
        }
        if (callback) {
            callback();
        }
    };
    [vc.navigationController pushViewController:temp animated:YES];
}

- (void)setSectIsHidden:(BOOL)sectIsHidden{
    [sectBtn setHidden:sectIsHidden];
    if (!sectIsHidden) {
        label.text = @"条件:";
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame controller:(UIViewController *)controller block:(Block)block
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addItemView];
        vc = controller;
        callback = block;
    }
    
    return self;
}

- (void)addItemView{
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"an_date_icon"]];
    icon.contentMode = UIViewContentModeCenter;
    icon.frame = CGRectMake(5, 0, 40, 40);
    [self addSubview:icon];
    label = [[UILabel alloc] init];
    
    label.text = @"截止年月:";
    label.font = [UIFont systemFontOfSize:14];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:label];
    
    timeBtn = [[UIButton alloc] init];
    [timeBtn addTarget:self action:@selector(dateUp:) forControlEvents:UIControlEventTouchUpInside];
    [timeBtn setTitle:[self currentYearMonth] forState:UIControlStateNormal];
    [timeBtn setTitleColor:[UIColor hex:@"3f92e9"] forState:UIControlStateNormal];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    timeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:timeBtn];
    
    sectBtn = [[UIButton alloc] init];
    [sectBtn addTarget:self action:@selector(sectUp:) forControlEvents:UIControlEventTouchUpInside];
    [sectBtn setTitle:@"全部标段" forState:UIControlStateNormal];
    [sectBtn setTitleColor:[UIColor hex:@"3f92e9"] forState:UIControlStateNormal];
    sectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sectBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:sectBtn];
    
    NSLayoutConstraint *top1 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left1 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:45];
    NSLayoutConstraint *bottom1 = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    
    NSLayoutConstraint *top2 = [NSLayoutConstraint constraintWithItem:timeBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left2 = [NSLayoutConstraint constraintWithItem:timeBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *height2 = [NSLayoutConstraint constraintWithItem:timeBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:40];
    
    
    NSLayoutConstraint *top3 = [NSLayoutConstraint constraintWithItem:sectBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *left3 = [NSLayoutConstraint constraintWithItem:sectBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:timeBtn attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *right3 = [NSLayoutConstraint constraintWithItem:sectBtn attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottom3 = [NSLayoutConstraint constraintWithItem:sectBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *width3 = [NSLayoutConstraint constraintWithItem:timeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:sectBtn attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    [self addConstraints:[NSArray arrayWithObjects:left1,top1,bottom1,top2,left2,height2,top3,left3,right3,width3,bottom3,nil]];
}

- (NSString *)time{
    if (timeTxt == nil || timeTxt.length < 1) {
        //获取当前时间 （时间格式支持自定义）
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy.MM"];//自定义时间格式
        NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
        return currentDateStr;
    }else{
        return timeTxt;
    }
}
- (NSArray *)sects{
    if (sectValues == nil) {
        return @[];
    }
    return sectValues;
}
- (void)reset{
    timeTxt = nil;
    sectValues = nil;
    [sectBtn setTitle:@"全部标段" forState:UIControlStateNormal];
    [timeBtn setTitle:[self currentYearMonth] forState:UIControlStateNormal];
}
- (NSString *)currentYearMonth{
    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年M月"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    return currentDateStr;
}


@end
