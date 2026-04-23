//
//  ProjectOutlineController.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/09/05.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDropDownMenu.h"

@interface ProjectOutlineController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *projectDataSource;
@property (nonatomic, assign) NSInteger _currentData1Index;
- (NSString *)bottomTip;
- (UIView *)bottomView;
- (UIView *)topView;
- (void)refresh;
- (void)reset;
- (void)initProjects;
- (NSString *)time;
- (NSArray *)sects;
- (BOOL)sectIsHidden;
@end
