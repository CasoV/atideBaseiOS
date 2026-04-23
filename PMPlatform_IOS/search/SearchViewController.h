//
//  SearchViewController.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/6.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchFactory.h"

@interface SearchViewController : UIViewController

@property (nonatomic, assign) SearchType searchType;

- (void)resetTotalButton:(NSString *)total;

@end
