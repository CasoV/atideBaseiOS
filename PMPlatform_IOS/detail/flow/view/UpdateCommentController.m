//
//  UpdateCommentController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/15.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "UpdateCommentController.h"
#import "ApprovalCommentModel.h"
#import "UpdateCommentCell.h"

@interface UpdateCommentController ()<UITableViewDelegate, UITableViewDataSource, UpdateCommentCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation UpdateCommentController {
    NSArray <ApprovalCommentModel *>*_dataSource;
    ApprovalCommentModel *_selecedModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

#pragma mark - 初始化界面
- (void)setupUI {
    _dataSource = [NSArray array];
    
    self.tv.layer.cornerRadius = 5;
    self.tv.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    self.tv.layer.borderWidth = 1;
}

#pragma mark - 加载数据
- (void)loadData {
    __weak typeof(self) weakSelf= self;
    NSDictionary *param = @{
                            @"bizPk":self.instanceId,
                            @"sectId":[UserAgent DefaultAgent].sectionId,
                            @"projectId":[UserAgent DefaultAgent].projectId
                            };
    [[HttpManager manager] post:[UrlConfig URL:self.url] param:param success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [ApprovalCommentModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            self->_dataSource = [ApprovalCommentModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if (self->_dataSource == nil) {
                return;
            }
            [weakSelf.tableView reloadData];
        }else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 点击事件
- (IBAction)buttonClicked:(UIButton *)sender {
    self.tv.text = sender.currentTitle;
}

- (IBAction)sure:(id)sender {
    if (!_selecedModel) {
        [SVProgressHUD showInfoWithStatus:@"请先选择补签流程"];
        return;
    }
    
    NSString *url;
    NSString *bizKey;
    if ([self.bizKey isEqualToString:@"doc_send"]) {
        url = @"/oa/doc/send/updateComment";
        bizKey = @"doc_send";
    } else {
        url = @"/oa/doc/rcv/updateComment";
        bizKey = @"doc_rcv_deal";
    }
    
    [SVProgressHUD showWithStatus:nil];
    __weak typeof(self) weakSelf= self;
    NSDictionary *param = @{
                            @"commentId":_selecedModel.ID,
                            @"comment":self.tv.text,
                            @"bizPk":self.instanceId,
                            @"bizKey":bizKey,
                            @"sectId":[UserAgent DefaultAgent].sectionId,
                            @"projectId":[UserAgent DefaultAgent].projectId
                            };
    [[HttpManager manager] post:[UrlConfig URL:url] param:param success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"补签成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpdateCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"updateCommentCell" forIndexPath:indexPath];
    [cell loadDataModel:_dataSource[indexPath.row]];
    [cell hideTop:(indexPath.row == 0)];
    [cell hideBottom:(indexPath.row == (_dataSource.count - 1))];
    cell.delegate = self;
    return cell;
}

#pragma mark - UpdateCommentCellDelegate
- (void)updateCommentCellPointButtonClicked:(UpdateCommentCell *)cell {
    for (ApprovalCommentModel *item in _dataSource) {
        item.selected = NO;
    }
    cell.model.selected = YES;
    _selecedModel = cell.model;
    self.tv.text = _selecedModel.message;
    [self.tableView reloadData];
}

#pragma mark - 移除第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.tv resignFirstResponder];
}

@end
