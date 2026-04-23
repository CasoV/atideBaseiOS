//
//  Panel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/12.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Panel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *iconName;

- (instancetype)init:(NSString *)ID text:(NSString *)text icon:(NSString *)icon;

@end
