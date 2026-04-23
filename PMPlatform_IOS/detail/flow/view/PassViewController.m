//
//  PassViewController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/14.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "PassViewController.h"
#import "EasySignatureView.h"
#import "UIImage+Additions.h"
#import "UnderlineButton.h"
#import "FlowPicLocation.h"
#import "OpinionsCell.h"
#import "PassViewCell.h"
//#import <IMPortal/IMPortal.h>
#import "CaLoginUtil.h"

@interface PassViewController ()<UITableViewDelegate, UITableViewDataSource, PassViewCellDelegate, SignatureViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIView *ring1;
@property (weak, nonatomic) IBOutlet UIView *ring2;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet EasySignatureView *signatureView;
@property (weak, nonatomic) IBOutlet UIView *textParentView;
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;

@property (weak, nonatomic) IBOutlet UIView *choiceOpinionView;
@property (weak, nonatomic) IBOutlet UITableView *choiceOpinionTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceOpinionTableViewHeight;

@property (nonatomic, copy) NSArray <OpinionsModel *>*opinionsData;

@property (nonatomic, strong) UnderlineButton *frontBtn;
@property (nonatomic, strong) UnderlineButton *opinionBtn;

@property (nonatomic, copy) NSString *nowKey;

@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, strong) NSArray<NSDictionary *> *processdata;
@property (nonatomic, assign) int scount;

@property (nonatomic, assign) BOOL isCaLocal;

@end

@implementation PassViewController {
    NSArray <FlowPicLocation *>*_dataSource;
    
    CGFloat _height1;
    CGFloat _height2;
    BOOL _signature;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *port = [userDefaults objectForKey:@"port"];
    if (port && [port isEqualToString:@"31070"]) {
        self.isCaLocal = YES;
    }
    [self setupUI];
    [self loadData];
}

#pragma mark - 初始化界面
- (void)setupUI {
    _height1 = 150;
    _height2 = 105;
    
//    [self.btnView addSubview:self.frontBtn];
    [self.btnView addSubview:self.opinionBtn];
    self.signatureView.delegate = self;
    _signature = NO;
    
    _dataSource = [NSArray array];
    
    self.textParentView.layer.cornerRadius = 5;
    self.textParentView.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    self.textParentView.layer.borderWidth = 1;
    
    self.signatureView.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    self.signatureView.layer.borderWidth = 1;
    
    self.ring1.layer.cornerRadius = 5;
    self.ring2.layer.cornerRadius = 5;
    
    self.checkButton.layer.cornerRadius = 3;
    
//    self.button1.hidden = YES;
//    [self.button2 setTitle:@"重写" forState:UIControlStateNormal];
    
    if (self.checkTitle) {
        [self.checkButton setTitle:self.checkTitle forState:UIControlStateNormal];
    }
}

#pragma mark - 懒加载
- (UnderlineButton *)frontBtn {
    if (!_frontBtn) {
        _frontBtn = [UnderlineButton buttonWithType:UIButtonTypeCustom];
        _frontBtn.frame = CGRectMake(5, 0, 70, 30);
        _frontBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_frontBtn setTitle:@"签名" forState:UIControlStateNormal];
        [_frontBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_frontBtn setImage:[UIImage imageWithColor:UIColorFromRGB(0x0096FF)] forState:UIControlStateSelected];
        [_frontBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _frontBtn.selected = YES;
    }
    return _frontBtn;
}

- (UnderlineButton *)opinionBtn {
    if (!_opinionBtn) {
        _opinionBtn = [UnderlineButton buttonWithType:UIButtonTypeCustom];
        _opinionBtn.frame = CGRectMake(5, 0, 70, 30);
        _opinionBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_opinionBtn setTitle:@"意见填写" forState:UIControlStateNormal];
        [_opinionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_opinionBtn setImage:[UIImage imageWithColor:UIColorFromRGB(0x0096FF)] forState:UIControlStateSelected];
        [_opinionBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _opinionBtn.selected = YES;
    }
    return _opinionBtn;
}

- (NSArray<OpinionsModel *> *)opinionsData {
    if (!_opinionsData) {
        _opinionsData = [NSArray array];
    }
    return _opinionsData;
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
            [FlowPicLocation mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"opinions":[FlowApprovalResult class], @"taskAssignees":[FlowApprovalAssignees class]};
            }];
            [FlowPicLocation mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            [FlowApprovalAssignees mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            self->_dataSource = [FlowPicLocation mj_objectArrayWithKeyValuesArray:[ResponseUtils getData:@"data"]];
            if (self->_dataSource) {
                NSMutableArray <FlowPicLocation *>*arr = [NSMutableArray array];
                for (FlowPicLocation *item in self->_dataSource) {
                    if ([item.status isEqualToString:@"2"]) {
                        weakSelf.nowKey = item.ID;
                    }
                    NSString *taskType = [item.type lowercaseString];
                    if ([taskType isEqualToString:@"usertask"]) {
                        [arr addObject:item];
                    }
                }
                self->_dataSource = [arr copy];
                if ([self.title hasSuffix:@"退回"]) {
                    for (int i = 0; i < self->_dataSource.count; i ++) {
                        if (i == 0) {
                            self->_dataSource[i].pointSelected = YES;
                        } else {
                            self->_dataSource[i].pointSelected = NO;
                        }
                    }
                }
                [weakSelf.tableView reloadData];
            }
            weakSelf.checkButton.hidden = NO;
        }else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];

    [[HttpManager manager] post:[UrlConfig URL:commentsEnum] param:nil success:^(NSData *data) {
        [DataCollection mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"OpinionsModel"};
        }];
        DataCollection *dataCollection = [DataCollection mj_objectWithKeyValues:data];
        weakSelf.opinionsData = dataCollection.rows;
        
        if (weakSelf.opinionsData.count >= 5) {
            weakSelf.choiceOpinionTableViewHeight.constant = 40 * 5;
        } else {
            weakSelf.choiceOpinionTableViewHeight.constant = 40 * weakSelf.opinionsData.count;
        }
        [weakSelf.choiceOpinionTableView reloadData];
    } faild:nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.choiceOpinionTableView) {
        return self.opinionsData.count;
    }
    
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.choiceOpinionTableView) {
        return 40;
    }
    
    if ([self.title hasSuffix:@"退回"]) {
        return [_dataSource[indexPath.row] getPassCellHeight:YES];
    } else {
        return [_dataSource[indexPath.row] getPassCellHeight:NO];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.choiceOpinionTableView) {
        OpinionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"opinionsCell" forIndexPath:indexPath];
        
        cell.model = self.opinionsData[indexPath.row];
        
        return cell;
    }
    
    PassViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"passViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        [cell cutLine:YES];
    }else {
        [cell cutLine:NO];
    }
    
    if ([self.title hasSuffix:@"退回"]) {
        [cell showLeft:YES];
    } else {
        [cell showLeft:NO];
    }
    
    [cell loadDataModel:_dataSource[indexPath.row]];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.choiceOpinionTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        for (OpinionsModel *model in self.opinionsData) {
            model.isSelected = NO;
        }
        
        self.opinionsData[indexPath.row].isSelected = YES;
        
        self.tv.text = self.opinionsData[indexPath.row].name;
        self.choiceOpinionView.hidden = YES;
        
        [tableView reloadData];
    }
}

#pragma mark - PassViewCellDelegate
- (void)passViewCellPointButtonClicked:(PassViewCell *)cell {
    for (FlowPicLocation *item in _dataSource) {
        item.pointSelected = NO;
    }
    cell.flowPicLocation.pointSelected = YES;
    [self.tableView reloadData];
}

#pragma mark - 点击事件
- (IBAction)voiceBtnClicked:(UIButton *)sender {
    self.textView = self.tv;
//    [self.iflyHelper speech];
    self.choiceOpinionView.hidden = YES;
}

- (IBAction)choiceOpinionClicked:(UIButton *)sender {
    self.choiceOpinionView.hidden = !self.choiceOpinionView.hidden;
}

- (IBAction)choiceOpinionViewClicked:(id)sender {
    self.choiceOpinionView.hidden = YES;
}

- (void)btnClicked:(UnderlineButton *)sender {
    sender.selected = YES;
    
    if (sender == self.frontBtn) {
        self.choiceOpinionView.hidden = YES;
        self.opinionBtn.selected = NO;
        self.signatureView.hidden = NO;
        self.tv.hidden = YES;
        self.headerViewHeight.constant =_height1;
        
        self.button1.hidden = YES;
        [self.button2 setTitle:@"重写" forState:UIControlStateNormal];
    } else {
        self.frontBtn.selected = NO;
        self.signatureView.hidden = YES;
        self.tv.hidden = NO;
        self.headerViewHeight.constant =_height2;
        
        self.button1.hidden = NO;
        if ([self.title hasSuffix:@"退回"]) {
            [self.button1 setTitle:@"不通过" forState:UIControlStateNormal];
            [self.button2 setTitle:@"退回" forState:UIControlStateNormal];
        } else {
            [self.button1 setTitle:@"同意" forState:UIControlStateNormal];
            [self.button2 setTitle:@"已阅" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)buttonClicked:(UIButton *)sender {
//    if (self.frontBtn.isSelected) {
//        [self.signatureView clear];
//        _signature = NO;
//    } else {
        self.tv.text = sender.currentTitle;
//    }
}

- (IBAction)sure:(id)sender {
    if ([self.title hasSuffix:@"通过"] || [self.title hasSuffix:@"提交"] || [self.title hasSuffix:@"申报"]) {
        if (self.isCaLocal && [self.title hasSuffix:@"通过"]) {
            [self handSign];
        } else {
            [self submit1];
        }
    } else if ([self.title hasSuffix:@"退回"]) {
        [self reject];
    } else if ([self.title hasSuffix:@"签章"]) {
        [self handSeal];
    } else if ([self.title hasSuffix:@"签名"]) {
        [self handSign];
    }
}

#pragma mark - 获取jsonTaskAssigness and taskKey
- (NSString *)getJsonTaskAssigness {
    NSString *result = @"[";
    
    __block NSInteger index = 0;
    [_dataSource enumerateObjectsUsingBlock:^(FlowPicLocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.status isEqualToString:@"2"]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    BOOL isFirst = YES;
    for (NSInteger i = index + 1; i < _dataSource.count; i++) {
        if ([[_dataSource[i] getJsonTaskAssigness] isEqualToString:@""]) {
            continue;
        }
        if (isFirst) {
            isFirst = NO;
            result = [NSString stringWithFormat:@"%@%@", result, [_dataSource[i] getJsonTaskAssigness]];
        } else {
            result = [NSString stringWithFormat:@"%@,%@", result, [_dataSource[i] getJsonTaskAssigness]];
        }
    }
    
    
    return [NSString stringWithFormat:@"%@]", result];
}

- (NSString *)getTaskKey {
    __block NSInteger index = 0;
    [_dataSource enumerateObjectsUsingBlock:^(FlowPicLocation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.status isEqualToString:@"2"]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    NSString *taskKey = @"";
    for (NSInteger i = index + 1; i < _dataSource.count; i++) {
        if (i == index + 1) {
            taskKey = [NSString stringWithFormat:@"%@", _dataSource[i].ID];
        } else {
            taskKey = [NSString stringWithFormat:@"%@,%@", taskKey, _dataSource[i].ID];
        }
    }
    
    return taskKey;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"填写意见"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"填写意见";
    }
}

#pragma mark - SignatureViewDelegate
- (void)onSignatureWriteAction {
    _signature = YES;
}

- (NSString *) getSignatureImgStr {
    if (_signature) {
        [_signatureView sure];
    } else {
        return @"";
    }
    if(_signatureView.SignatureImg) {
        return [UIImagePNGRepresentation(_signatureView.SignatureImg) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {

        return @"";
    }
}
#pragma mark - 签名
-(void)handSign{
    NSString *comment = [self.tv.text isEqualToString:@"填写意见"] ? @"" : self.tv.text;
    NSDictionary *params = @{
        @"comment" : comment,
        @"taskKey" : [self getTaskKey],
        @"jsonTaskAssignees" : [self getJsonTaskAssigness],
        @"bizPk" : self.instanceId,
        @"taskId" : self.taskId ? self.taskId : @"",
        @"nowKey" : self.nowKey,
        @"signature" : [self getSignatureImgStr],
        @"bizKey": self.bizKey
    };
    __weak typeof(self) weakSelf = self;
    //签名 self.useJsonParams
    [[CaLoginUtil alloc]signByParams:params viewController:self opinionsData:self.opinionsData useJsonParams:YES success:^(BOOL isSuccess) {
        if(isSuccess){
            if (weakSelf.callBack) {
                weakSelf.callBack(YES);
            }
            [SVProgressHUD showSuccessWithStatus:@"办理成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    
}
//生成摘要 hash签名
-(void)genClientSignDigestByContent:(NSString *)content fileId:(NSString *)fileId item:(NSMutableDictionary *)item{
    [[HttpManager manager]post:[NSString stringWithFormat:@"%@/%@",[UrlConfig URL:signDigest],self.instanceId] data:[NSJSONSerialization dataWithJSONObject:item options:NSJSONWritingPrettyPrinted error:nil] success:^(NSData *data) {
           if ([ResponseUtils success:data]) {
               NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               NSMutableDictionary *digestMessages = dictData[@"data"];
               NSMutableArray *digestMessageslist = digestMessages[@"digestMessages"];
               if(digestMessageslist && digestMessageslist.count > 0){
                   NSMutableDictionary *hashDic = digestMessageslist.firstObject;
                   NSString *hashData = hashDic[@"hashData"];
                   NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
//                   IMCert *cert = [[IMCert alloc]initWithUsername:userName];
                   IMUser *user = [IMUser userWithUserName:userName];
//                   SignModeRaw = 0,裸签名
//                   SignModeAttached=1 attached签名
//                   SignModeDetached  detached签名
                   [user.cert signWithPIN:content Plain:hashData encoding:NSUTF8StringEncoding mode:1 andCompleteBlock:^(int resultCode, NSString *signResult) {
                       if(signResult){
                           digestMessageslist.firstObject[@"clientSignData"] = signResult;
                           digestMessages[@"digestMessages"] = digestMessageslist;
                           [self genClientSignByContent:@"" fileId:fileId digestMessages:digestMessages];
                       }else{
                           [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"hash签名失败！%d",resultCode]];
                       }
                   }];
               }

           } else {
               [SVProgressHUD showErrorWithStatus:@"生成摘失败"];
           }
       } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:@"生成摘失败"];
       }];
}
//    pdf签名
-(void)genClientSignByContent:(NSString *)content fileId:(NSString *)fileId digestMessages:(NSMutableDictionary *)digestMessages{
    [[HttpManager manager]post:[NSString stringWithFormat:@"%@/%@/%@",[UrlConfig URL:clientSign],self.instanceId,fileId] data:[NSJSONSerialization dataWithJSONObject:digestMessages options:NSJSONWritingPrettyPrinted error:nil]  success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            self.scount++;
            if(self.scount < self.opinionsData.count){
//                NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_USER_NAME];
//                [[CaLoginUtil alloc]loginByPin:content openId:^(NSString * _Nonnull openId) {
//                    NSString *certsn = [[[IMCert alloc]initWithUsername:userName] exportCert];
//                    NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:self.processdata[self.scount]];
//                    self.fileId = self.processdata[self.scount][@"fileId"];
//                    item[@"fileId"] = self.fileId;
//                    item[@"signCert"] = certsn;
//                    [self genClientSignDigestByContent:content fileId:self.fileId item:item];
//
//                }];
            }else{
                [self submit1];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"签名失败"];
        }
    } faild:^(NSString *msg) {
          [SVProgressHUD showErrorWithStatus:@"签名失败"];
    }];
}
#pragma mark - 签章
-(void)handSeal{
    NSString *comment = [self.tv.text isEqualToString:@"填写意见"] ? @"" : self.tv.text;
    NSDictionary *params = @{
        @"comment" : comment,
        @"taskKey" : [self getTaskKey],
        @"jsonTaskAssignees" : [self getJsonTaskAssigness],
        @"bizPk" : self.instanceId,
        @"taskId" : self.taskId ? self.taskId : @"",
        @"nowKey" : self.nowKey,
        @"signature" : [self getSignatureImgStr],
        @"bizKey": self.bizKey
    };
    __weak typeof(self) weakSelf = self;
//    self.useJsonParams
    [[CaLoginUtil alloc]sealByParams:params viewController:self opinionsData:self.opinionsData useJsonParams:YES success:^(BOOL isSuccess) {
            if(isSuccess){
                if (weakSelf.callBack) {
                    weakSelf.callBack(YES);
                }
                [SVProgressHUD showSuccessWithStatus:@"办理成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
    }];
//    [[HttpManager manager]post:[NSString stringWithFormat:@"%@/%@/%@",[UrlConfig URL:bjcaGenSign],self.instanceId,[[NSUserDefaults standardUserDefaults]valueForKey:@"actionVar"]] param:nil success:^(NSData *data) {
//        if ([ResponseUtils success:data]) {
//            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            if (dictData&&dictData[@"id"]) {
//                self.fileId = dictData[@"id"];
//                [self submit1];
//            }
//        } else {
//            [SVProgressHUD showErrorWithStatus:@"签章失败"];
//        }
//    } faild:^(NSString *msg) {
//
//    }];
}
#pragma mark - 提交/申报/通过
- (void)submit1 {
    NSString *url;
    if (self.finalUrl) {
        url = self.finalUrl;
    } else {
        url = [NSString stringWithFormat:[UrlConfig URL:caServiceInstance], self.instanceId];
        if (self.isCaLocal) {
            url = [NSString stringWithFormat:[UrlConfig URL:caServiceInstanceByCa], self.instanceId];
        }
    }
    
    NSString *comment = [self.tv.text isEqualToString:@"填写意见"] ? @"" : self.tv.text;
    NSDictionary *params = @{
        @"comment" : comment,
        @"taskKey" : [self getTaskKey],
        @"jsonTaskAssignees" : [self getJsonTaskAssigness],
        @"bizPk" : self.instanceId,
        @"taskId" : self.taskId ? self.taskId : @"",
        @"nowKey" : self.nowKey,
        @"signature" : [self getSignatureImgStr],
        @"bizKey": self.bizKey,
        @"fileId":self.fileId? self.taskId : @""
    };
    [SVProgressHUD showWithStatus:nil];
    if ([self.nowKey isEqualToString:@"usertask1"] && self.finalUrl == nil) {
        NSString *pdfUrl = [UrlConfig URL:odsToPdf];
        NSDictionary *pdfParams = @{
            @"isCa":self.isCaLocal ? @"1" : @"0",
            @"fileId":self.instanceId,
            @"bizPk":self.instanceId,
            @"taskId":self.taskId ? self.taskId : @"",
            @"format":@"pdf",
            @"taskKey":self.nowKey,
        };
        __weak typeof(self) weakSelf = self;
        [[HttpManager manager] get:pdfUrl param:pdfParams success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [weakSelf submit2:url params:params];
            } else {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"PDF文件生成失败:%@", [ResponseUtils getMsg]]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    } else {
        [self submit2:url params:params];
    }
}

- (void)submit2:(NSString *)url params:(NSDictionary *)params {
    __weak typeof(self) weakSelf = self;
    if (self.finalUrl && !self.useJsonParams) {
        [[HttpManager manager] post:url param:params success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                if (weakSelf.callBack) {
                    weakSelf.callBack(YES);
                }
                [SVProgressHUD showSuccessWithStatus:@"办理成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        } headers:@{
            @"flow-token": @"COMPLETE"
        }];
    } else {
        [[HttpManager manager] jsonPost:url param:params success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                if (weakSelf.callBack) {
                    weakSelf.callBack(YES);
                }
                [SVProgressHUD showSuccessWithStatus:@"办理成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        } headers:@{
            @"flow-token": @"COMPLETE"
        }];
    }
}

#pragma mark - 退回
- (void)reject {
    NSString *url;
    if (self.finalUrl) {
        url = self.finalUrl;
    } else {
        url = [NSString stringWithFormat:[UrlConfig URL:caServiceInstance], self.instanceId];
        if (self.isCaLocal) {
            url = [NSString stringWithFormat:[UrlConfig URL:caServiceInstanceByCa], self.instanceId];
        }
    }
    

    NSString *comment = [self.tv.text isEqualToString:@"填写意见"] ? @"" : self.tv.text;
    
    FlowPicLocation *model;
    for (FlowPicLocation *item in _dataSource) {
        if (item.pointSelected) {
            model = item;
        }
    }

    
    NSDictionary *params = @{
        @"comment" : comment,
        @"destTaskKey" : model.ID ? model.ID : @"",
        @"jsonTaskAssignees" : [NSString stringWithFormat:@"[%@]", [model getJsonTaskAssigness] ? [model getJsonTaskAssigness] : @""],
        @"bizPk" : self.instanceId,
        @"taskId" : self.taskId ? self.taskId : @"",
        @"signature" : [self getSignatureImgStr]
    };
    
    if (self.finalUrl && !self.useJsonParams) {
        __weak typeof(self) weakSelf = self;
        [[HttpManager manager] post:url param:params success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                if (weakSelf.callBack) {
                    weakSelf.callBack(YES);
                }
                [SVProgressHUD showSuccessWithStatus:@"退回成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        } headers:@{
            @"flow-token": @"REJECT"
        }];
    } else {
         __weak typeof(self) weakSelf = self;
            [[HttpManager manager] jsonPost:url param:params success:^(NSData *data) {
                if ([ResponseUtils success:data]) {
                    if (weakSelf.callBack) {
                        weakSelf.callBack(YES);
                    }
                    [SVProgressHUD showSuccessWithStatus:@"退回成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
                }
            } faild:^(NSString *msg) {
                [SVProgressHUD showErrorWithStatus:msg];
            } headers:@{
                @"flow-token": @"REJECT"
            }];
    }
}

@end
