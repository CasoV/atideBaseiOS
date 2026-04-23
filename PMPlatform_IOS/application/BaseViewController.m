//
//  BaseViewController.m
//  ycTest
//
//  Created by 末末班车 on 2018/9/10.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+Awesome.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.line];
   
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kStatusBarH + kNavBarH));
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(0.5));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:self.line];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x000000);
//    [self.navigationController.navigationBar lt_setBackgroundColor:UIColorFromRGBWithAlpha(0xffffff,1)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBManager hideAlert];
    self.navigationItem.title = @"";
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.frame = CGRectMake(0, kStatusBarH + kNavBarH, ScreenWidth, 0.5);
        _line.backgroundColor = UIColorBackground;
    }
    return _line;
}

#pragma mark - 项目标段id、code懒加载
- (NSString *)projectId {
    if (!_projectId) {
        _projectId = [UserAgent DefaultAgent].projectId;
    }
    return _projectId;
}

- (NSString *)projectCode {
    if (!_projectCode) {
        _projectCode = [UserAgent DefaultAgent].projectCode;
    }
    return _projectCode;
}

- (NSString *)sectionId {
    if (!_sectionId) {
        _sectionId = [UserAgent DefaultAgent].sectionId;
    }
    return _sectionId;
}

- (NSString *)sectionCode {
    if (!_sectionCode) {
        _sectionCode = [UserAgent DefaultAgent].sectionCode;
    }
    return _sectionCode;
}

@end
