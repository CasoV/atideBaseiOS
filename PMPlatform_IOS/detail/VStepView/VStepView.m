//
//  VStepView.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/11.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "VStepView.h"
#import "ApprovalCommentModel.h"

static NSString *cellIdentify = @"cellIdentify";

@interface VStepView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void (^callback)(id, DefaultVStepViewCell *cell);
@property (nonatomic, copy) void (^itemClick)(id);
@property (nonatomic, copy) NSArray *datas;

@end

@implementation VStepView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.scrollEnabled = NO;
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify];
    }
    return self;
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        self.backgroundColor = [UIColor blueColor];
        self.scrollEnabled = NO;
        self.delegate = self;
        self.dataSource = self;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentify];
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemClick) {
        self.itemClick(self.datas[indexPath.row]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.datas) {
        return self.datas.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApprovalCommentModel *model = self.datas[indexPath.row];
    return model.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DefaultVStepViewCell *contentView = (DefaultVStepViewCell *)[[NSBundle mainBundle] loadNibNamed:@"DefaultVStepViewCell" owner:self options:nil].lastObject;
    if (indexPath.row == 0) {
        contentView.topLine.hidden = YES;
    } else {
        contentView.topLine.hidden = NO;
    }
    
    if (indexPath.row == self.datas.count - 1) {
        contentView.bottomLine.hidden = YES;
    } else {
        contentView.bottomLine.hidden = NO;
    }
    
    ApprovalCommentModel *model = self.datas[indexPath.row];
    contentView.frame = CGRectMake(0, 0, tableView.frame.size.width, model.rowHeight);
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:contentView];
    if (self.callback) {
        self.callback(self.datas[indexPath.row], contentView);
    }else {
        [contentView fillData];
    }

    return cell;
}

//MARK: 设置数据源
- (void)setDataAndView:(NSArray *)data itemClick:(void (^)(id))itemClick callback:(void(^)(id, DefaultVStepViewCell *cell))callback {
    self.itemClick =  itemClick;
    self.callback = callback;
    self.datas = data;
    [self reloadData];
}

@end
