//
//  FDTimePickerView.h
//  AtideOA
//
//  Created by 末末班车 on 2017/8/8.
//  Copyright © 2017年 com.atidesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDTimePickerView : UIView

//用户选择时间后的操作.
@property(nonatomic,copy) void(^timeBlock)(NSDate*date);

- (void)showDateInPicker:(NSDate *)date;

@end
