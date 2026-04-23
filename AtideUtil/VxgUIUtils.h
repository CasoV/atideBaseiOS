//
//  VxgUIUtils.h
//  TrafficMs
//
//  Created by apple on 2015/11/03.
//  Copyright © 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CommCfg.h"
#import "VxgColor.h"

#define  CELL_HEIGHT 48.0f
#define  DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开
#define  DIC_ARARRY @"array"
#define  DIC_TITILESTRING @"title"

#define  MAIN_SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


@interface VxgUIUtils : NSObject

+ (void) s_uuchart_bar_init_item_desc:(UIView *)view y:(CGFloat)y labelWidth:(CGFloat)width colors:(NSMutableArray *)colors labels:(NSMutableArray *)colorsLabels;

+ (UIView *)s_create_header_view:(NSMutableArray *)tbArray view:(UIView *)sourceView eButton:(UIButton*)eButton section:(NSInteger)section isExpanded:(BOOL)isExpanded;

+ (void) s_vxg_view_set_corner:(UIView*)sourceView cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color;

@end
