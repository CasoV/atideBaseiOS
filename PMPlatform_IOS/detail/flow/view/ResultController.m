//
//  ResultController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/20.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "ResultController.h"

@interface ResultController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - 初始化界面
- (void)setupUI {
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderColor = UIColorFromRGB(0xa8abad).CGColor;
    self.textView.layer.borderWidth = 1;
    
    self.checkBtn.layer.cornerRadius = 5;
    
    self.textView.text = self.memo;
}

#pragma mark - 点击事件
- (IBAction)sure:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"内容不能为空！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:nil];
    NSDictionary *param = @{@"id":self.ID,
                            @"memo":self.textView.text,
                            @"sectId":[UserAgent DefaultAgent].sectionId,
                            @"projectId":[UserAgent DefaultAgent].projectId};
    [[HttpManager manager] post:[UrlConfig URL:saveMemo] param:param success:^(NSData *data) {
        [SVProgressHUD dismiss];
        if ([ResponseUtils success:data]) {
            [SVProgressHUD showSuccessWithStatus:@"办理成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
        }
    } faild:^(NSString *msg) {
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

@end
