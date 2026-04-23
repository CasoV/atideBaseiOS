//
//  ConditionDetail.h
//  ycxm
//
//  Created by 末末班车 on 2018/9/28.
//  Copyright © 2018年 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConditionDetail : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isSelected;

+ (ConditionDetail *)detailWith:(NSString *)ID text:(NSString *)text;

@end
