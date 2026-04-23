//
//  FlowPicPopController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/13.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "FlowPicPopController.h"
#import <Masonry/Masonry.h>
#import "FlowPicPopCell.h"

static NSString *cellIdentify = @"flowpicpopcell";

@interface FlowPicPopController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FlowPicPopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView registerNib:[UINib nibWithNibName:@"FlowPicPopCell" bundle:nil] forCellReuseIdentifier:cellIdentify];
    _tableView.estimatedRowHeight = 90;
    _tableView.tableHeaderView = [self createHeader];
}

- (UIView *)createHeader {
    CGFloat height = 30;
    UIView *headerView = [[UIView alloc] init];
    
    [headerView addSubview:[self createItem:@"任务名称" value:self.flowPicLocation.name index:0]];
    
    if ([self.flowPicLocation.status isEqualToString:@"2"] && self.flowPicLocation.taskAssignees != nil) {
        if (self.flowPicLocation.taskAssignees.count != 0) {
            NSString *username = self.flowPicLocation.taskAssignees.firstObject.userName;
            for (int i = 1; i < self.flowPicLocation.taskAssignees.count; i++) {
                username = [NSString stringWithFormat:@"%@,%@", username, self.flowPicLocation.taskAssignees[i].userName];
            }
            [headerView addSubview:[self createItem:@"处理人" value:username index:1]];
            height += 30;
        }
    }
    
    if (self.flowPicLocation.opinions != nil && self.flowPicLocation.opinions.count != 0) {
        NSInteger index = height == 30 ? 1 : 2;
        [headerView addSubview:[self createItem:@"办理意见" value:@"" index:index]];
        height += 30;
    }
    headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, height);
    return headerView;
}

- (UIView *)createItem:(NSString *)key value:(NSString *)value index:(NSInteger)index {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, index * 30, self.tableView.frame.size.width, 30)];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.translatesAutoresizingMaskIntoConstraints = NO;
    label1.textColor = UIColorFromRGB(0x00ddff);
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = key;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.translatesAutoresizingMaskIntoConstraints = NO;
    label2.textColor = UIColorFromRGB(0xff4444);
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = value;
    label2.numberOfLines = 0;
    [view addSubview:label1];
    [view addSubview:label2];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).with.offset(10);
        make.top.mas_equalTo(view.mas_top).with.offset(0);
        make.bottom.mas_equalTo(view.mas_bottom).with.offset(0);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label1.mas_right).with.offset(10);
        make.top.mas_equalTo(view.mas_top).with.offset(0);
        make.bottom.mas_equalTo(view.mas_bottom).with.offset(0);
    }];
    return view;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flowPicLocation.opinions ? self.flowPicLocation.opinions.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FlowPicPopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    [cell loadDataModel:self.flowPicLocation.opinions[indexPath.row]];
    return cell;
}

@end
