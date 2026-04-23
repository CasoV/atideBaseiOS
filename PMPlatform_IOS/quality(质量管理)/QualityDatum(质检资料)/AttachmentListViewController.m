//
//  AttachmentListViewController.m
//  ycxm
//
//  Created by 高小伟 on 2020/7/20.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "AttachmentListViewController.h"
#import "BIMFile.h"
#import "AttachmentTableCell.h"
#import "OpenDocumentationController.h"

@interface AttachmentListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <BIMFile *>* dataSource;

@end

@implementation AttachmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title = @"附件列表";
}
- (NSMutableArray<BIMFile *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)loadData {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:searchFiles] param:@{@"metaData.formId":self.formId} success:^(NSData *data) {
       self.dataSource = [BIMFile mj_objectArrayWithKeyValuesArray:data];
        [weakSelf.tableView reloadData];
    } faild:^(NSString *msg) {
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AttachmentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttachmentTableCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell loadModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource[indexPath.row] isDownload]) {
        [self openFile:self.dataSource[indexPath.row]];
    } else {
        [SVProgressHUD showWithStatus:@"下载中..."];
        
        [[HttpManager manager] downloadWithFileid:self.dataSource[indexPath.row].id fileName:self.dataSource[indexPath.row].filename progress:^(NSProgress *downloadProgress) {
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            [SVProgressHUD dismiss];
            if (!error) {
                [self openFile:self.dataSource[indexPath.row]];
            } else {
                [SVProgressHUD showErrorWithStatus:@"下载失败！"];
            }
            
        }];
        
    }
}
- (void)openFile:(BIMFile *)file {
    if ([file isDownload]) {
        OpenDocumentationController *vc = [[OpenDocumentationController alloc] init];
        vc.filepath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:file.filePath];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
