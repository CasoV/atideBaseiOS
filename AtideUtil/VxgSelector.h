//
//  VxgSelector.h
//  TrafficMs
//
//  Created by apple on 2015/11/05.
//  Copyright © 2015年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define __VXGDATE_SELECTOR_WIDTH_  [[UIScreen mainScreen]bounds].size.width*0.8
#define __VXGDATE_SELECTOR_HEIGHT_ [[UIScreen mainScreen]bounds].size.width*0.6

@interface VxgSelector : UIAlertView

- (instancetype)initVxgSelector:(id)delegate title:(NSString*)title btnName:(NSString*)btnName datas:(NSMutableArray *)datas;
- (void)setValue;
- (NSMutableArray *)getData;
@end
