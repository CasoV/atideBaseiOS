//
//  ProjectOutlineTableController.h
//  PMPlatform_IOS
//
//  Created by vxg on 2017/11/30.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectOutlineTableController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) NSMutableArray *projectDataSource;
@property (nonatomic, assign) NSInteger _currentData1Index;
- (void)refresh:(BOOL)isRefresh;
- (void)reset;
- (void)initProjects;
- (NSString *)time;
- (UIView *)childView;
- (BOOL)sectIsHidden;
@end
