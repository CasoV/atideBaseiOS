//
//  DetailController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "DetailController.h"
#import "PopoverView.h"

@interface DetailController ()

@property (nonatomic, copy) NSArray <Panel *>*rightItems;

@end

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)showRightButton:(NSArray<Panel *> *)items {
    if (_searchType == SearchTypeSealIn || _searchType == SearchTypeSealEx || _searchType == SearchTypeSealLoan) {
        NSMutableArray <Panel *> *arr = [NSMutableArray array];
        NSString *option;
        for (Panel *item in items) {
            if([item.content isEqualToString:@"保存"]||[item.content isEqualToString:@"归还"]){
                option = item.content;
            }else{
                [arr addObject:item];
            }
        }
        UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick:)];
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:option style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: menuBtn,saveButton,nil]];
        self.rightItems = arr;
        return;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"white_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick:)];
    self.rightItems = items;

}

//MARK: 右边按钮展示内容
- (void)rightButtonClick:(UIBarButtonItem *)sender {
    if (!self.rightItems || self.rightItems.count == 0) {
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (Panel *item in self.rightItems) {
        PopoverAction *action = [PopoverAction actionWithTitle:item.content handler:^(PopoverAction *action) {
            [self rightButtonItemClick:item];
        }];
        [arr addObject:action];
    }
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleDark;
    popoverView.hideAfterTouchOutside = YES; // 点击外部时不允许隐藏
    [popoverView showToPoint:CGPointMake(ScreenWidth - 20, 64) withActions:arr];
}

- (void)rightButtonItemClick:(Panel *)item {
}

#pragma mark - 判断文件是否已经下载
- (BOOL)checkDownload:(NSString *)filePath {
    for (NSString *item in [[NSFileManager defaultManager] subpathsAtPath:[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()]]) {
        if ([item isEqualToString:filePath]) {
            return YES;
        }
    }
    
    return NO;
}


@end
