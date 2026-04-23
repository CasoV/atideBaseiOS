//
//  SectModel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/10/10.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectModel : NSObject

@property (nonatomic, copy) NSString *userCode;
@property (nonatomic, copy) NSString *sectName;
@property (nonatomic, copy) NSString *childBussinessFlag;
@property (nonatomic, copy) NSString *bussinessFlag;
@property (nonatomic, copy) NSString *sessionCode;
@property (nonatomic, copy) NSString *sectNo;

- (void) setData:(NSDictionary*)nsd;

@end
