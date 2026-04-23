//
//  ProcessTrackingController.m
//  HBConstructionApp
//
//  Created by 末末班车 on 2018/5/23.
//  Copyright © 2018年 atide. All rights reserved.
//

#import "ProcessTrackingController.h"
//#import "ChoosePersonController.h"
//#import "ChooseModelController.h"

@interface ProcessTrackingController ()

@property (weak, nonatomic) IBOutlet UITextField *registerNameTF;
@property (weak, nonatomic) IBOutlet UIButton *ChooseModelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ChooseDirectorBtn;
@property (weak, nonatomic) IBOutlet UIButton *ChooseSupvervisorBtn;

@end

@implementation ProcessTrackingController {
    NSString *_modelId;
    NSString *_directorCode;
    NSString *_supvervisorCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorBackground;
    [self setDefaultData];
    
    if (self.canEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    }
    self.registerNameTF.userInteractionEnabled = self.canEdit;
    self.ChooseModelBtn.userInteractionEnabled = self.canEdit;
    self.ChooseDirectorBtn.userInteractionEnabled = self.canEdit;
    self.ChooseSupvervisorBtn.userInteractionEnabled = self.canEdit;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"工艺工序过程填报";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)setDefaultData {
    if (!self.model) {
        return;
    }
    self.ChooseModelBtn.userInteractionEnabled = NO;
    self.partCode = self.model.partCode;
    self.registerNameTF.text = self.model.registerName;
    if (self.model.modelName) {
        [self.ChooseModelBtn setTitle:self.model.modelName forState:UIControlStateNormal];
    }
    _modelId = self.model.modelId;
    if (self.model.director) {
        [self.ChooseDirectorBtn setTitle:self.model.director forState:UIControlStateNormal];
    }
    _directorCode = self.model.directorCode;
    if (self.model.supvervisor) {
        [self.ChooseSupvervisorBtn setTitle:self.model.supvervisor forState:UIControlStateNormal];
    }
    _supvervisorCode = self.model.supvervisorCode;
}

#pragma mark - 点击事件
- (IBAction)chooseBtnClicked:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (sender == self.ChooseModelBtn) {
//        if (self.model) {
//            return;
//        }
//        ChooseModelController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chooseModel"];
//        vc.block = ^(ConstructModel *model) {
//            [sender setTitle:model.modelName forState:UIControlStateNormal];
//            self->_modelId = model.id;
//        };
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    } else {
//        ChoosePersonController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"choosePerson"];
//        vc.showSex = YES;
//        vc.block = ^(PersonModel *person) {
//            [sender setTitle:person.name forState:UIControlStateNormal];
//            if (sender == weakSelf.ChooseDirectorBtn) {
//                self->_directorCode = person.id;
//            } else {
//                self->_supvervisorCode = person.id;
//            }
//        };
//        [weakSelf.navigationController pushViewController:vc animated:YES];
    }
}

- (void)save {
    if ([self FD_validate]) {
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"请求中..."];
        [[HttpManager manager] post:[UrlConfig URL:saveConstructRegisterContent] param:[self params] success:^(NSData *data) {
            if ([ResponseUtils success:data]) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:[ResponseUtils getMsg]];
            }
        } faild:^(NSString *msg) {
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
}

- (NSDictionary *)params {
    return @{
             @"supvervisor":self.ChooseSupvervisorBtn.currentTitle,
             @"registerName":self.registerNameTF.text,
             @"director":self.ChooseDirectorBtn.currentTitle,
             @"id":self.model ? self.model.id : @"",
             @"modelId":_modelId,
             @"partCode":self.partCode ? self.partCode : @"",
             @"sectId": self.sectionId,
             @"projectId":self.projectId
             };
}

#pragma mark - 数据验证
- (BOOL)FD_validate {
    if ([self.registerNameTF.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:self.registerNameTF.placeholder];
        return NO;
    }

    if ([self.ChooseModelBtn.currentTitle isEqualToString:@"请选择类型"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择类型"];
        return NO;
    }
    if ([self.ChooseDirectorBtn.currentTitle isEqualToString:@"请选择负责人"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择负责人"];
        return NO;
    }
    if ([self.ChooseSupvervisorBtn.currentTitle isEqualToString:@"请选择监理人"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择监理人"];
        return NO;
    }

    return YES;
}

@end
