//
//  QualityProblemReplyViewController.m
//  ycxm
//
//  Created by 末末班车 on 2018/9/30.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "QualityProblemReplyViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import "QualityProblemReplyCell.h"
#import "PYPhotoBrowseView.h"
#import "BIMFile.h"

@interface QualityProblemReplyViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray <QualityProblemReplyModel *>*dataSource;

@property (nonatomic, strong) NSMutableArray <UIImage *>*images;

@end

@implementation QualityProblemReplyViewController {
    QualityProblemReplyCell *_selectCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (NSArray<QualityProblemReplyModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

- (NSMutableArray<UIImage *> *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (NSString *)id {
    if (!_id) {
        _id = @"";
    }
    return _id;
}

#pragma mark - 加载数据
- (void)requestData {
    NSString *key = @"problemId";
    if ([self.url isEqualToString:safetyDangerContent]) {
        key = @"dangerId";
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [UrlConfig URL:self.url ? self.url : qualityProblemContent];
    if([self.resourceTitle isEqualToString:@"环保问题整改"]){
        url = [UrlConfig URL:greeContent];
    }else if ([self.resourceTitle isEqualToString:@"水保巡查整改"]) {
        url = [UrlConfig URL:greeWaterContent];
    }else if ([self.resourceTitle isEqualToString:@"安全隐患"]||[self.resourceTitle isEqualToString:@"安全检查"]) {
        url = [UrlConfig URL:riskContent];
    }
    [[HttpManager manager] post:url param:@{key:self.id} success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"QualityProblemReplyModel"};
        }];
        DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
        weakSelf.dataSource = dataCollection.rows;
        if (weakSelf.dataSource.count == 0) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView reloadData];
        }
        for (QualityProblemReplyModel *model in weakSelf.dataSource) {
            [weakSelf loadFilesId:model];
        }
    } faild:^(NSString *msg) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadFilesId:(QualityProblemReplyModel *)model {
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] get:[UrlConfig URL:searchFiles] param:@{@"metaData.formId":model.id} success:^(NSData *data) {
        NSArray <BIMFile *>*files = [BIMFile mj_objectArrayWithKeyValuesArray:data];
        model.fileIds = [NSMutableArray array];
        if (files) {
            for (BIMFile *file in files) {
                [model.fileIds addObject:file.id];
            }
        }
        [weakSelf updateContentView];
    } faild:^(NSString *msg) {
        model.fileIds = [NSMutableArray array];
        [weakSelf updateContentView];
    }];
}

- (void)updateContentView {
    for (QualityProblemReplyModel *model in self.dataSource) {
        if (!model.fileIds) {
            return;
        }
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataSource[indexPath.row].rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QualityProblemReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"qualityProblemReplyCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSource[indexPath.row].fileIds.count == 0) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    _selectCell = [tableView cellForRowAtIndexPath:indexPath];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSInteger count = self.dataSource[indexPath.row].fileIds.count;
    __block NSInteger index = 0;
    __weak typeof(self) weakSelf = self;
    [self.images removeAllObjects];
    for (NSString *fileId in self.dataSource[indexPath.row].fileIds) {
        [manager loadImageWithURL:[weakSelf imageUrl:fileId] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image) {
                [weakSelf.images addObject:image];
                index++;
            }
            
            if (index == count) {
                [weakSelf showPhoto];
            }
        }];
    }
}

- (void)showPhoto {
    [SVProgressHUD dismiss];
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    
    // 2.1 设置图片源(UIImage)数组
    photoBroseView.images = self.images;
    // 2.2 设置初始化图片下标（即当前点击第几张图片）
    photoBroseView.currentIndex = 0;
    
    photoBroseView.showFromView = _selectCell;
    photoBroseView.hiddenToView = _selectCell;
    
    // 3.显示(浏览)
    [photoBroseView show];
}

- (NSURL *)imageUrl:(NSString *)ID {
    NSString *url = [UrlConfig URL:downloadFile];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", url, ID]];
}

@end
