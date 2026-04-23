//
//  ProtocolModel.h
//  PMPlatform_IOS
//
//  Created by 末末班车 on 2017/9/19.
//  Copyright © 2017年 com.atide. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtocolModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *protocol;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, copy) NSString *port;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) BOOL hasOutline;
@property (nonatomic, assign) BOOL hasMeasure;
@property (nonatomic, assign) BOOL hasSealManagement;
@property (nonatomic, copy) NSString *debug;


@end
