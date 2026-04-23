//
//  TransferController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/15.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "TransferController.h"
#import "FlowPicLocation.h"

@interface TransferController ()

@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TransferController {
    FlowPicLocation *_flowPicLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

#pragma mark - 初始化界面
- (void)setupUI {
    self.tv.layer.cornerRadius = 5;
    self.tv.layer.borderColor = UIColorFromRGB(0xE6E6E6).CGColor;
    self.tv.layer.borderWidth = 1;
}

#pragma mark - 加载数据
- (void)loadData {
    NSDictionary *param = @{
                            @"bizPk":self.instanceId,
                            @"sectId":[UserAgent DefaultAgent].sectionId,
                            @"projectId":[UserAgent DefaultAgent].projectId
                            };
    [[HttpManager manager] post:[UrlConfig URL:transfer] param:param success:^(NSData *data) {
        if ([ResponseUtils success:data]) {
            [FlowPicLocation mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"ID":@"id"};
            }];
            [FlowPicLocation mj_setupObjectClassInArray:^NSDictionary *{
                return @{@"opinions":@"FlowApprovalResult",@"taskAssignees":@"FlowApprovalAssignees"};
            }];
            _flowPicLocation = [FlowPicLocation mj_objectWithKeyValues:[ResponseUtils getData:@"data"]];
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

}
- (IBAction)showUserVC:(id)sender {

}

@end
