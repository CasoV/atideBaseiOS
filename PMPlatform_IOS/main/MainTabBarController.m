//
//  MainTabBarController.m
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/4.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarBackgroundColor:[UIColor navigationBgColor]];
}
-(void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
     statusBar.backgroundColor = [UIColor navigationBgColor];;
     [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    if(@available(iOS 13.0, *)) {
        static UIView*statusBar =nil;
        if(!statusBar) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                statusBar.backgroundColor= color;
            });
        }else{
            statusBar.backgroundColor= color;
        }
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
        }
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置一个自定义 View,大小等于 tabBar 的大小
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
    // 给自定义 View 设置颜色
    bgView.backgroundColor = [UIColor whiteColor];
    // 将自定义 View 添加到 tabBar 上
    [self.tabBar insertSubview:bgView atIndex:0];
    
    //定义背景色
    self.tabBar.barTintColor = [UIColor hex:@"#f8f8f9"]; //定义选中时的背景色
    UIColor * selectedColor = [UIColor navigationBgColor];
    UIColor * normalColor = [UIColor darkGrayColor];
    UITabBarItem * item = self.tabBar.items[0];
    item.titlePositionAdjustment = UIOffsetMake(0, -3);
    item.image = [[UIImage imageNamed:@"an_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:@"an_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : normalColor} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedColor} forState:UIControlStateSelected];
    
    item = self.tabBar.items[1];
    item.titlePositionAdjustment = UIOffsetMake(0, -3);
    item.image = [[UIImage imageNamed:@"an_home_safety"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:@"an_home_safety_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : normalColor} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedColor} forState:UIControlStateSelected];
    
    item = self.tabBar.items[2];
    item.titlePositionAdjustment = UIOffsetMake(0, -3);
    item.image = [[UIImage imageNamed:@"an_home_oa"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [[UIImage imageNamed:@"an_home_oa_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : normalColor} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : selectedColor} forState:UIControlStateSelected];
}

@end
