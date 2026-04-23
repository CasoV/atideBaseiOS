//
//  NewQDHomeController.m
//  ycxm
//
//  Created by 末末班车 on 2020/3/13.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import "NewQDHomeController.h"
#import "QDReportDetailController.h"
#import "NSString+encryptionMD5.h"
#import "QDDTBDController.h"
#import "NSDate+Timestamp.h"
//#import "PartSeleterVc.h"
#import "NewQDTreeCell.h"
#import "PartModel.h"
#import "DatumModel.h"
#import "AttachmentListViewController.h"
#import "TreeChooserMaterialViewController.h"

@interface NewQDHomeController () <RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic, strong) PartModel *partModel;
@property (weak, nonatomic) IBOutlet UIButton *partBtn;
@property (weak, nonatomic) IBOutlet UIView *treeContentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
//@property (nonatomic, strong) PartSeleterVc *seleterVc;
@property (nonatomic, copy) NSArray <NewQDModel *>*dataSource;
@property (nonatomic, strong) RATreeView *treeView;
@property (nonatomic, strong) NewQDModel *selectedModel;
@property(nonatomic, copy) NSString *mainId;

@property (nonatomic,strong)TreeChooserMaterialViewController *rightVc;
@property (nonatomic,strong)UIView *backColorView;
@end

@implementation NewQDHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isFirst = YES;
    [self initView];
    [self initChildVc];
}

-(void)initChildVc{
      __weak typeof(self) weakSelf = self;
    /* 创建一个阴影 */
    _backColorView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backColorView.backgroundColor = [UIColor blackColor];
    _backColorView.alpha = 0;   //开始透明度为0,后面通过动画逐渐变黑
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap)];
    [_backColorView addGestureRecognizer:tapG]; //加入触摸手势,点阴影区域时关闭右侧导航栏
    [self.view addSubview:_backColorView];
    
    /* 创建第二页对象 */
    _rightVc = [TreeChooserMaterialViewController new];
    _rightVc.callBack = ^(DatumModel *model) {
        if(model){
            weakSelf.mainId = model.id;
            weakSelf.titleLb.text = model.text;
            [weakSelf loadData];
            [weakSelf closeTap];
        }
    };
    _rightVc.view.frame = CGRectMake(kScreen_Width, kNavBarH + kStatusBarH,kScreen_Width - 50 , kScreen_Height - kNavBarH - kStatusBarH);
    [self addChildViewController:_rightVc];
    [self.view addSubview:_rightVc.view];
}

- (void)tapCondition {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view bringSubviewToFront:_backColorView];
    [self.view bringSubviewToFront:_rightVc.view];
    /* 出现的动画 */
    [UIView animateWithDuration:0.5 animations:^{
        self->_backColorView.alpha = 0.3;
        self->_rightVc.view.frame = CGRectMake(50, kStatusBarH + kNavBarH, kScreen_Width - 50, kScreen_Height - kStatusBarH - kNavBarH);
    }];
}

- (void)closeTap {
    self.navigationItem.rightBarButtonItem.enabled = YES;
    /* 关闭操作,先动画后移除 */
    [UIView animateWithDuration:0.5 animations:^{
        self->_backColorView.alpha = 0;
        self->_rightVc.view.frame = CGRectMake(kScreen_Width, kStatusBarH + kNavBarH, kScreen_Width - 50, kScreen_Height - kStatusBarH - kNavBarH);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = self.resourceTitle;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"目录" style:UIBarButtonItemStylePlain target:self action:@selector(tapCondition)];
    if (self.isFirst) {
        self.isFirst = NO;
    } else {
        [self loadData];
    }
}

#pragma mark - 初始化页面
- (void)initView {
    [self loadDefaultPart];
    [self initTreeView];
}

#pragma mark - 懒加载
- (NSArray<NewQDModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}

#pragma mark - 加载默认部位
- (void)loadDefaultPart {
    NSString *partCode = @"";
    if (self.sectionCode) {
        partCode = self.sectionCode;
    } else {
        partCode = self.projectCode;
    }
    
    NSDictionary *params = nil;
    if (self.code) {
        params = @{@"useCompany": self.code};
    }
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[NSString stringWithFormat:[UrlConfig URL:qualityDatumPartDoc], partCode] param:params success:^(NSData *data) {
        NSArray <PartModel *>*datas = [PartModel mj_objectArrayWithKeyValuesArray:data];
        if (datas.count > 0) {
            weakSelf.partModel = datas[0];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
-(void)loadDefaultMaterial{
    NSString *projectId = [UserAgent DefaultAgent].projectId;
    NSString *sectId = [UserAgent DefaultAgent].sectionId;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"projectId": projectId ? projectId : @"",
        @"sectId": sectId ? sectId : @"",
        @"partType": self.partModel.type ? self.partModel.type : @"",
        @"partTypeCode": self.partModel.projectTypeCode ? self.partModel.projectTypeCode : @"",
        @"partCode": self.partModel.id ? self.partModel.id : @""
    }];

    if (self.code) {
        [params setValue:self.code forKey:@"useCompany"];
    }
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getQualityDatumList] param:params success:^(NSData *data) {
        NSArray <DatumModel *>*datas = [DatumModel mj_objectArrayWithKeyValuesArray:[data mj_JSONObject][@"data"]];
        if (datas.count > 0) {
            weakSelf.mainId = datas[0].id;
            weakSelf.titleLb.text = datas[0].text;
            [self loadData];
        }else{
            weakSelf.dataSource = [NSArray array];
            [weakSelf.treeView reloadData];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}
#pragma mark - 设置工程部位
- (void)setPartModel:(PartModel *)partModel {
    _partModel = partModel;
    _rightVc.partModel = partModel;
    [self.partBtn setTitle:partModel.text forState:UIControlStateNormal];
    [self loadDefaultMaterial];
}

#pragma mark - 工程部位按钮点击事件
- (IBAction)partBtnClicked:(UIButton *)sender {
//    if (self.seleterVc) {
//        [self.navigationController pushViewController:self.seleterVc animated:YES];
//        return;
//    }
//
//    __weak typeof(self) weakSelf = self;
//    PartSeleterVc *vc = [[UIStoryboard storyboardWithName:@"PartSeleter" bundle:nil] instantiateViewControllerWithIdentifier:@"PartSeleterVc"];
//    vc.useCompany = self.code;
//    vc.type = SelectQD;
//
//    vc.block = ^(SiteModel *site) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"QDPart" object:site];
//        weakSelf.isFirst = YES;
//
//        PartModel *partModel = [PartModel new];
//        partModel.id = site.id;
//        partModel.text = site.text;
//        partModel.type = site.type;
//        partModel.projectTypeCode = site.projectTypeCode;
//
//        weakSelf.partModel = partModel;
//    };
//    vc.vcBlock = ^(PartSeleterVc *selectVc) {
//        weakSelf.seleterVc = selectVc;
//    };
//
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 初始化树
- (void)initTreeView {
    _treeView = [[RATreeView alloc] initWithFrame:self.treeContentView.bounds style:RATreeViewStylePlain];
    _treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    _treeView.treeFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _treeView.delegate = self;
    _treeView.dataSource = self;
    [self.treeContentView addSubview:_treeView];
}

#pragma mark - 加载数据
- (void)loadData {
    [SVProgressHUD showWithStatus:nil];
    NSString *projectId = [UserAgent DefaultAgent].projectId;
    NSString *sectId = [UserAgent DefaultAgent].sectionId;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"projectId": projectId ? projectId : @"",
        @"sectId": sectId ? sectId : @"",
        @"partType": self.partModel.type ? self.partModel.type : @"",
        @"partTypeCode": self.partModel.projectTypeCode ? self.partModel.projectTypeCode : @"",
        @"partCode": self.partModel.id ? self.partModel.id : @"",
        @"type":@"",
        @"code":@""
    }];
    if (self.mainId) {
        [params setValue:self.mainId forKey:@"mainId"];
    }
    if (self.code) {
        [params setValue:self.code forKey:@"useCompany"];
    }
    
    __weak typeof(self) weakSelf = self;
    [[HttpManager manager] post:[UrlConfig URL:getQualityListFile] param:params success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data]) {
            [NewQDModel mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"children":@"NewQDModel"};
            }];
            weakSelf.dataSource = [NewQDModel mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            for (NewQDModel *item in weakSelf.dataSource) {
                item.isExpanded = YES;
            }
            [weakSelf.treeView reloadData];
            for (NewQDModel *item in weakSelf.dataSource) {
                [weakSelf.treeView expandRowForItem:item expandChildren:YES withRowAnimation:RATreeViewRowAnimationNone];
            }
        } else {
             [SVProgressHUD dismiss];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - RATreeViewDataSource, RATreeViewDelegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 40;
}

//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    NewQDTreeCell *cell = (NewQDTreeCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_bottom_black"];
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    NewQDTreeCell *cell = (NewQDTreeCell *)[treeView cellForItem:item];
    cell.expandImg.image = [UIImage imageNamed:@"ic_arrow_right_black"];
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    NewQDModel *model = item;
    model.isExpanded = YES;
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    NewQDModel *model = item;
    model.isExpanded = NO;
}

//# dataSource方法
//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    //获取cell
    NewQDTreeCell *cell = [NewQDTreeCell treeViewCellWith:treeView];
    //当前item
    NewQDModel *modelItem = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    //赋值
    [cell setCellBasicInfoWith:modelItem level:level children:modelItem.children.count];
    
    __weak typeof(self) weakSelf = self;
    cell.callBack = ^(NewQDModel * _Nonnull selectModel) {
        weakSelf.selectedModel = selectModel;
        [weakSelf handleTableClicked];
    };
    cell.attCallBack = ^(NewQDModel * _Nonnull selectModel) {
        AttachmentListViewController *vc = [[UIStoryboard storyboardWithName:@"AttachmentListSb" bundle:nil] instantiateViewControllerWithIdentifier:@"AttachmentListViewController"];
        vc.formId = selectModel.instId;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    NewQDModel *model = item;
    if (item == nil) {
        return self.dataSource.count;
    }
    return model.children.count;
}


/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    NewQDModel *model = item;
    if (item == nil) {
        return self.dataSource[index];
    }
    return model.children[index];
}

//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
}
//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}
//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {

}

#pragma mark - 处理表单点击事件
- (void)handleTableClicked {
    NewQDModel *model = self.selectedModel;
    if ([model.testStatus isEqualToString:@"2"] || [model.testStatus isEqualToString:@"3"] || [model.testStatus isEqualToString:@"4"]) {
        //退回、流程中、已完结
        QDReportDetailController *vc = [[QDReportDetailController alloc] init];
        vc.model =  [NewQDKeyModel mj_objectWithKeyValues:[model mj_JSONObject]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        QDDTBDController *dtbdVc = [[QDDTBDController alloc] init];
        dtbdVc.model = [NewQDModel mj_objectWithKeyValues:[model mj_JSONObject]];
        [self.navigationController pushViewController:dtbdVc animated:YES];
//        [self getTemplateCode:self.selectedModel];
    }
}

- (void)getTemplateCode:(NewQDModel *)model {
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *url = [NSString stringWithFormat:[UrlConfig URL:entityTemplate], model.excelId];
    [[HttpManager manager] get:url param:nil success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic = [ResponseUtils getData:@"data"];
            if([dic isEqual:[NSNull null]]){
                [SVProgressHUD showErrorWithStatus:@"未获取到模板！"];
                return;
            }
            if (dic != nil && dic[@"entityName"] != nil && ![dic[@"entityName"] isEqual:@""]) {
                model.templateCode = dic[@"entityName"];
                [self checkTemplateCodeExists:model];
                return ;
            }
        }
        
        [SVProgressHUD showErrorWithStatus:@"模版编码获取失败!"];
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)checkTemplateCodeExists:(NewQDModel *)model {
    [[HttpManager manager] get:[UrlConfig URL:definitionExists] param:@{@"entityName": model.templateCode} success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSNumber *isHave = [ResponseUtils getData:@"data"];
            if ([isHave boolValue]) {
                if ([model.storageType isEqualToString:@"1"]) {
                    if (model.id == nil) {
                        [self saveMappin:model bizId:@""];
                    } else {
                        [SVProgressHUD dismiss];
//                        toDTBDActivity2(bean)
                    }
                } else {
                    if (model.instId == nil) {
                        //未填写
                        [self mergeTemplates:model];
                    } else {
                        [SVProgressHUD dismiss];
                        //未提交
                        [self toDTBD:model];
                    }
                }
            } else {
                [SVProgressHUD showErrorWithStatus:@"动态表单模版不存在!"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 未填写表单需进行操作1
- (void)mergeTemplates:(NewQDModel *)item {
    NSString *projectId = [UserAgent DefaultAgent].projectId ? [UserAgent DefaultAgent].projectId : @"";
    NSString *projectCode = [UserAgent DefaultAgent].projectCode ? [UserAgent DefaultAgent].projectCode : @"";
    NSString *sectionId = [UserAgent DefaultAgent].sectionId ? [UserAgent DefaultAgent].sectionId : @"";
    NSString *sectionCode = [UserAgent DefaultAgent].sectionCode ? [UserAgent DefaultAgent].sectionCode : @"";
    
    NSString *url = [UrlConfig URL:mergeTemplates];
    NSString *reportCode = [NSString stringWithFormat:@"%@%@", item.partType, [NSDate nowDateStringYYMMddHHmmss]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(YES) forKey:@"hasFlow"];
    [params setObject:item.name forKey:@"name"];
    [params setObject:@"999999" forKey:@"categoryId"];
    [params setObject:@{
        @"reportName": item.name,
        @"reportCode": [NSString stringMD5:reportCode]
    } forKey:@"extJson"];
    [params setObject:@{
        @"partCode": (self.partModel.id ? self.partModel.id : @"")
    } forKey:@"jsonBizProps"];
    [params setObject:@[@{
        @"isFlow": @"1",
        @"sheetName": item.name,
        @"bizId": item.excelId
    }] forKey:@"files"];
    [params setObject:@{
        @"own_project_id": projectId,
        @"own_project_code": projectCode,
        @"own_section_id": sectionId,
        @"own_section_code": sectionCode
    } forKey:@"variablesJson"];
    
    [[HttpManager manager] jsonPost:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            NSDictionary *dic = [ResponseUtils getData:@"data"];
            if (!item.processCode) {
                item.processCode = dic[@"bizKey"];
            }
            [self saveMappin:item bizId:dic[@"bizId"]];
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 未填写表单需进行操作2
- (void)saveMappin:(NewQDModel *)item bizId:(NSString *)bizId {
    [SVProgressHUD showWithStatus:@"加载中"];
    NSString *url = [UrlConfig URL:saveMappin];
    NSString *projectId = [UserAgent DefaultAgent].projectId ? [UserAgent DefaultAgent].projectId : @"";
    NSString *sectionId = [UserAgent DefaultAgent].sectionId ? [UserAgent DefaultAgent].sectionId : @"";
    
    NSDictionary *params = @{
        @"id": (item.id ? item.id : @""),
        @"instId": bizId,
        @"numId": (item.numId ? item.numId : @""),
        @"partCode": (self.partModel.id ? self.partModel.id : @""),
        @"pid": (item.pid ? item.pid : @""),
        @"pName": (item.pname ? item.pname : @""),
        @"projectId": projectId,
        @"sectId": sectionId,
        @"testStatus": (item.testStatus ? item.testStatus : @"")
    };
    
    [[HttpManager manager] post:url param:params success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [SVProgressHUD dismiss];
            NSDictionary *dic = [ResponseUtils getData:@"data"];
            if ([item.storageType isEqualToString:@"1"]) {
                item.id = dic[@"id"];
//                toDTBDActivity2(item)
            } else {
                item.instId = bizId;
                [self toDTBD:item];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - 跳转动态表单
- (void)toDTBD:(NewQDModel *)item {
    QDDTBDController *dtbdVc = [[QDDTBDController alloc] init];
    dtbdVc.model = item;
    [self.navigationController pushViewController:dtbdVc animated:YES];
}

@end
