//
//  OrgAndUserChoiceController.m
//  circlViewText
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 atide. All rights reserved.
//

#import "OrgAndUserChoiceController.h"

@interface OrgAndUserChoiceController ()

@end

@implementation OrgAndUserChoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0xf2/0xff green:0xf2/0xff blue:0xf2/0xff alpha:1];
    self.navigationItem.title = @"申请人";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
}

@end
