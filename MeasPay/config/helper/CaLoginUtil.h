//
//  CaLoginUtil.h
//  ycxm
//
//  Created by 高小伟 on 2020/4/17.
//  Copyright © 2020 末末班车. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpinionsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaLoginUtil : NSObject

-(void)loginByPin:(NSString *)pinText openId: (void (^)(NSString *openId)) openId;

//签名
-(void)signByParams:(NSDictionary *)params viewController:(UIViewController *)vc opinionsData:(NSArray<OpinionsModel *>*)opinionsData useJsonParams:(BOOL)useJsonParams success: (void (^)(BOOL isSuccess))succes;
//签章
-(void)sealByParams:(NSDictionary *)params viewController:(UIViewController *)vc opinionsData:(NSArray<OpinionsModel *>*)opinionsData useJsonParams:(BOOL)useJsonParams success: (void (^)(BOOL isSuccess))succes;
@end

NS_ASSUME_NONNULL_END
