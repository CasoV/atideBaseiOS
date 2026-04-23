//
//  DetailController.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/8.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Panel.h"
#import "SearchFactory.h"

@interface DetailController : UIViewController

@property (nonatomic, assign) SearchType searchType;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *   dealID;

@property (nonatomic, copy) NSString *bizKey;

- (BOOL)checkDownload:(NSString *)filePath;

- (void)showRightButton:(NSArray <Panel *>*)items;

- (void)rightButtonItemClick:(Panel *)item;
@end
